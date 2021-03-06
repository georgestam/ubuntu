class Alert < ApplicationRecord
  
  require 'rest-client'

  STATUS = %w[open resolved].freeze

  belongs_to :customer
  belongs_to :type_alert
  belongs_to :issue

  belongs_to :created_by, class_name: "User"
  belongs_to :user, class_name: "User"

  before_validation :set_created_by, on: :create 
  before_validation :set_assigned_alert_to, on: :create

  validates :customer, presence: true
  validates :user, presence: true
  validates :type_alert, presence: true
  validates :issue, presence: true, if: :resolved?

  # after_save :send_alert_email, if: :production?
  after_commit :send_slack_notification, unless: :test?

  validate :type_alert_for_alert_and_issue_is_the_same, if: :issue? # it ensures that we have chosen the same type_alert in both tables
  validate :customer_cannot_generate_alerts
  
  after_commit :notify_slack_user_created_by, on: :update 

  def set_assigned_alert_to
    self.user = self.type_alert.group_alert.user
  end 

  def set_created_by
    unless test? # TODO: Current.user not working in rspec
      self.created_by = Current.user if Current.user
      self.created_by = User.find_by(name: "Ubuntu") unless Current.user # When a rake tasks is called
    end 
  end 
  
  def self.all_not_hidden
    where(type_alert: TypeAlert.where(hidden_from_graphs: false))
  end 
  
  def self.all_resolved
    where.not(resolved_at: nil)
  end

  def self.all_open
    where(resolved_at: nil)
  end

  def self.my_resolved
    all_resolved.my_alerts.order(created_at: :asc)
  end

  def self.my_open
    all_open.my_alerts.order(created_at: :asc)
  end

  def self.my_alerts
    where(user: Current.user).order(created_at: :asc)
  end 

  def title # to humanize rails admin
    self.type_alert.present? ? self.type_alert.name : "type alert is not present"
  end

  def type_alert_for_alert_and_issue_is_the_same
    unless self.type_alert == self.issue.type_alert
      errors[:type_alert] << "Type Alert has to be the same for Issue and Alert"
    end
  end
  
  def customer_cannot_generate_alerts
    if self.customer.ignore_alerts == true
      errors[:customer] << "Alert cannot be created for this customer"
    end
  end

  def issue?
    true if self.issue.present?
  end

  def resolved?
    true if self.resolved_at
  end

  def send_alert_email
    AlertMailer.perform(self).deliver_later
  end

  def group_alert
    if self.type_alert
      (self.type_alert.group_alert.title).to_s
    end
  end

  def send_slack_notification
    SendNotificationsToSlack.perform_later(self.id)
  end

  def self.notify_an_alert_to_slack(alert_id)
    alert = Alert.find(alert_id)
    user_to_assign_task = if development?
      "@jordi"
    else
      alert.user.slack_username ? alert.user.slack_username : '@laima'
    end 
    user = User.find_by(slack_username: user_to_assign_task)
    Alert.notify_slack_user(user, alert) unless alert.resolved?
    Alert.notify_slack_channel(alert) unless development_or_test?
  end
  
  def self.notify_slack_user(user, alert)
    text = "Hello #{user.name}!\n You have a new alert created (or updated) by #{alert.created_by.try(:name) if alert.created_by.present?} for Customer #{alert.customer.first_name} #{alert.customer.last_name}: id: #{alert.id}, #{alert.type_alert.name} - #{alert.try(:resolved_comments)}\n"
    text << "*You can see your open alerts here* https://ubuntu-power.herokuapp.com/alerts"
    client = Slack::Web::Client.new
    client.auth_test
    client.chat_postMessage(channel: user.slack_username, text: text, as_user: 'ubuntu')
  end 
  
  def notify_slack_user_created_by
    ubuntu_user = User.find_by(slack_username: "@ubuntu")
    if self.resolved? && !test? && self.created_by != ubuntu_user
      user = User.find(self.created_by_id)
      text = "Hello #{self.created_by.try(:name) if self.created_by.present?}!\n Alert resolved by #{self.user.try(:name)} for Customer #{self.customer.first_name} #{self.customer.last_name}: id: #{self.id}, #{self.type_alert.name} - #{self.try(:resolved_comments)}\n"
      client = Slack::Web::Client.new
      client.auth_test
      client.chat_postMessage(channel: user.slack_username, text: text, as_user: 'ubuntu')
    end 
  end
  
  def self.notify_slack_channel(alert)
    text = if alert.resolved?
      "Alert resolved for Customer #{alert.customer.first_name} #{alert.customer.last_name}: id: #{alert.id}, #{alert.type_alert.name}\n"
    else 
      "New alert created (or updated) by #{alert.created_by.try(:name) if alert.created_by.present?} for Customer #{alert.customer.first_name} #{alert.customer.last_name}: id: #{alert.id}, #{alert.type_alert.name} - #{alert.try(:resolved_comments)}\n"
    end 
    client = Slack::Web::Client.new
    client.auth_test
    client.chat_postMessage(channel: "#alerts", text: text, as_user: 'ubuntu')
  end

  def self.notify_open_alerts_to_slack(user)
    alerts = Alert.all_open.where(user: user)
    alerts.sort_by(&:created_at)
    text = "Good Morning #{user.name}! \n You have #{alerts.count} alerts open. \n"
    alerts.each_with_index do |alert, index|
      text << "#{index + 1} - id: #{alert.id}, The customer #{alert.customer.name} has the following issue (created by #{alert.created_by.try(:name) if alert.created_by.present?}) since #{alert.created_at.strftime("%d %m")}: #{alert.type_alert.name} - #{alert.try(:resolved_comments)}\n"
    end 
    text << "*You can resolve your open alerts here* https://ubuntu-power.herokuapp.com/alerts"
    unless test? # TODO: how to stub_request and remove this unless for testing
      client = Slack::Web::Client.new
      client.auth_test
      client.chat_postMessage(channel: user.slack_username, text: text, as_user: 'ubuntu')
    end 
  end

  def resolved!
     self.update_attributes(resolved_at: Time.current)
  end
  
  def unresolved!
     self.update_attributes(resolved_at: nil)
  end

  def closed!
     self.update_attributes(closed_at: Time.current)
  end

  def self.check_customers_with_negative_acount
    Customer.all.each do |customer|
      balance_four_days_ago = Balance.find_by(customer: customer, created_on: Time.zone.today - 4.days)
      balance_today = Balance.find_by(customer: customer, created_on: Time.zone.today)
      if balance_today && balance_four_days_ago
        Alert.create_negative_account(balance_four_days_ago, balance_today, customer)
      end 
    end
  end
  
  def self.create_negative_account(balance_four_days_ago, balance_today, customer)
    if balance_four_days_ago.value_cents <= 0 && balance_today.value_cents <= 0 && !customer.an_alert_open_with?("Negative account") && !customer.ignore_alerts == true
      type_alert = TypeAlert.find_by(name: "Negative account")
      Alert.create!({
          customer: customer,
          type_alert: type_alert,
          issue: Issue.find_by(type_alert: type_alert)
          })
    end
  end 
  
  def self.create_alert_for_customers_with_line_off

    url1 = "https://api.steama.co/bitharvesters/99596/meters/?format=json&page_size=70"
    url2 = "https://api.steama.co/bitharvesters/99596/meters/?format=json&page=2&page_size=70"
    
    [url1, url2].each do |url|
      json_data = if !test?
        body = RestClient.get url, {:Authorization => "Token #{ENV['TOKEN_STEAMA']}"}
        JSON.parse(body)
      else 
        file = Rails.root.join('spec', 'support', 'example_steama_meters.json')
        JSON.parse(File.read(file))
      end 
    
    
      json_data['results'].each do |meter|
        
        id_steama = meter['customer'].to_i
        customer = Customer.find_by(id_steama: id_steama)
        # add condition as an_alert_open_with?("Line is off") does not work if customer is nil
        if customer
          # line_status 4,5,6,7 are line off
          if !meter['connection_is_on'] && !customer.an_alert_open_with?("Line is off") && !customer.an_alert_open_with?("Negative account")
          
          type_alert = TypeAlert.find_by(name: "Line is off")
          Alert.create({
              customer: customer,
              type_alert: type_alert,
              issue: Issue.find_by(type_alert: type_alert)
              })
              
          end
          
        end 
        
      end  
        
    end 
  end
  
  def self.check_meters_exceeding_max_daily_usage

    Meter.all.each do |meter|
      
      json = Usage.generate_usage_json(meter)

      cumulative = 0
      json.map do |usage_hour|
        cumulative += usage_hour["usage"].to_f
      end 
    
      if cumulative > (3 * Usage.max_usage_per_customer)
        type_alert = TypeAlert.find_by(name: "Usage exceeded three times the average")
        @alert = if Alert.create!({
            customer: meter.customer,
            type_alert: type_alert,
            issue: Issue.find_by(type_alert: type_alert),
            resolved_comments: "Total usage was #{cumulative.round(2)} kwh, on #{Date.yesterday}"
            })
        else
          flash[:alert] = @alert.errors.full_messages
          # TODO: send email with there has been a problem
        end
      end
    
    end
  end

end
