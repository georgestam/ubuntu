class Alert < ApplicationRecord
  
  STATUS = %w[open resolved].freeze
  
  belongs_to :customer
  belongs_to :type_alert
  belongs_to :issue
  
  validates :resolved_at, presence: true, if: :closed?
  
  validates :customer, presence: true
  
  after_save :send_alert_email, if: :production?
  after_save :send_slack_notification, if: :production?
  
  validate :type_alert_for_alert_and_issue_is_the_same, if: :issue #it ensures that we have chosen the same type_alert in both tables

  def type_alert_for_alert_and_issue_is_the_same
    self.type_alert == self.issue.type_alert
  end 
  
  def resolved?
    true if self.resolved_at && self.issue.resolution != "" && !self.issue.resolution.nil?
  end 
  
  def closed?
    true if self.closed_at 
  end 
  
  def send_alert_email
    AlertMailer.perform(self).deliver_later
  end
  
  def group_and_type
    # binding.pry
    if self.issue
      "#{self.type_alert.group_alert.title}, #{self.type_alert.name}"
    end 
  end
  
  def send_slack_notification
    SendNotificationsToSlack.perform_later(self.id)
  end
  
  def self.slack_api_call(alert_id)
    alert = Alert.find(alert_id)
    text = "New alert created by #{alert.created_by if alert.created_by.present?} for Customer #{alert.customer.first_name} #{alert.customer.last_name}: #{alert.description}"
    client = Slack::Web::Client.new
    client.auth_test
    client.chat_postMessage(channel: '#alerts', text: text, as_user: 'ubuntu')
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
        @alert = if Alert.create!({
            customer: customer,
            issue: Issue.find_by(type_alert: TypeAlert.find_by(name: "Negative account")),
            created_by: "Laima"
            })
        else 
          flash[:alert] = @alert.errors.full_messages
          # TODO: send email with there has been a problem
        end 
      end 
    end
  end  

end
