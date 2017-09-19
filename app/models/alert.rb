class Alert < ApplicationRecord

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

  after_save :send_alert_email, if: :production?
  after_save :send_slack_notification, if: :production?

  validate :type_alert_for_alert_and_issue_is_the_same, if: :issue? # it ensures that we have chosen the same type_alert in both tables
  validate :solution_resolution_text_exist?, if: :resolved?

  def set_assigned_alert_to
    self.user = self.type_alert.group_alert.user
  end 

  def set_created_by
    unless test? # TODO: Current.user not working in rspec
      self.created_by = Current.user
    end 
  end 

  def self.all_resolved
    where.not(resolved_at: nil)
  end

  def self.all_open
    where(resolved_at: nil)
  end

  def self.my_resolved
    all_resolved.my_alerts
  end

  def self.my_open
    all_open.my_alerts
  end

  def self.my_alerts
    where(user: Current.user)
  end 

  def title # to humanize rails admin
    self.type_alert.name if self.type_alert.present?
  end

  def type_alert_for_alert_and_issue_is_the_same
    unless self.type_alert == self.issue.type_alert
      errors[:type_alert] << "#Type Alert has to be the same for Issue and Alert"
    end
  end

  def issue?
    true if self.issue.present?
  end

  def solution_resolution_text_exist?
    if self.issue.try(:resolution) == "" || self.issue.try(:resolution).nil? 
      errors[:type_alert] << "#{self.id} An alert can be only marked as a resolved if it has a solution and a date resolved_at"
    end  
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
    user_to_assign_task = alert.user.slack_username ? alert.user.slack_username : '@laima'
    text = "Hello #{Current.user.name}! You have a new alert created by #{alert.created_by.name if alert.created_by.present?} for Customer #{alert.customer.first_name} #{alert.customer.last_name}: #{alert.type_alert.name}"
    client = Slack::Web::Client.new
    client.auth_test
    client.chat_postMessage(channel: user_to_assign_task, text: text, as_user: 'ubuntu')
  end

  def self.notify_open_alerts_to_slack(user)
    alerts = Alert.all_open.where(user: user)
    alerts.sort_by(&:created_at)
    text = "Good Morning #{user.name}! \n You have #{alerts.count} alerts open. \n"
    alerts.each_with_index do |alert, index|
      text << "#{index + 1 } - id: #{alert.id}, The customer #{alert.customer.name} has the following issue since #{alert.created_at.strftime("%d %m")}: #{alert.type_alert.name}. \n"
    end 
    text << "*You can resolve your open alerts here* https://ubuntu-power.herokuapp.com/alerts"
    client = Slack::Web::Client.new
    client.auth_test
    client.chat_postMessage(channel: user.slack_username, text: text, as_user: 'ubuntu')
  end

  def resolved_at!
     self.update_attributes(resolved_at: Time.current)
  end

  def closed_at!
     self.update_attributes(closed_at: Time.current)
  end

  def self.check_customers_with_negative_acount
    Customer.all.each do |customer|
      if customer.account_balance.to_i <= 0 && !customer.an_alert_with_negative_acount_open?
        type_alert = TypeAlert.find_by(name: "Negative account")
        @alert = if Alert.create!({
            customer: customer,
            type_alert: type_alert,
            issue: Issue.find_by(type_alert: type_alert)
            })
        else
          flash[:alert] = @alert.errors.full_messages
          # TODO: send email with there has been a problem
        end
      end
    end
  end

end
