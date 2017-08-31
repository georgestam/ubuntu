class Alert < ApplicationRecord
  
  STATUS = %w[open resolved].freeze
  
  belongs_to :customer
  belongs_to :type_alert
  belongs_to :status
  belongs_to :query
  
  validates :resolved_at, presence:true, if: :resolved_at
  
  validates :customer, presence: true
  validates :query, presence: true
  
  after_save :send_alert_email
  after_save :send_slack_notification, unless: :development?

  def send_alert_email
    AlertMailer.perform(self).deliver_later
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
      if customer.account_balance.to_i <= 0 && customer.customer_description_does_not_exist_open?
        if Alert.create({
            customer: customer,
            type_alert: TypeAlert.first, # this alert is 'nagative_account'
            description: "User has negative account",
            status: Status.first,
            created_by: "Laima"
            })
        else 
          # flash[:alert] = alert.errors.full_messages
          # TODO: send email with there has been a problem
        end 
      end 
    end
  end  

end
