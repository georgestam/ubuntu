class Customer < ApplicationRecord
  
  has_many :alerts, dependent: :destroy
  
  validates :id_steama, presence: true, uniqueness: true
  
  def self.customer_id_exist?(id_steama)
    true if Customer.find_by(id_steama: id_steama)
  end 
  
  def name
    "#{self.first_name},#{self.last_name}"
  end
  
  def customer_description_does_not_exist_open?
    exist = true 
    Alert.all.each do |alert|
      if Alert.find_by(customer_id: self.id, status_id: 1, description: "User has negative account")
        exist = false  
      end
    end 
    exist
  end
  
  def self.create_new_customer(user)
    if Customer.create!({  
        id_steama: user['id'],
        url: user['url'],
        transactions_url: user['transactions_url'],
        utilities: user['utilities'],
        telephone: user['telephone'], 
        first_name: user['first_name'],
        last_name: user['last_name'],
        account_balance: user['account_balance'],
        low_balance_warning: user['low_balance_warning'],
        low_balance_level: user['low_balance_level'],
        site_manager: user['site_manager'], 
        site_manager_url: user['site_manager_url'],
        site_manager_telephone: user['site_manager_telephone'],
        site: user['site'],
        site_url: user['site_url'],
        site_name: user['site_name'],
        bit_harvester: user['bit_harvester'],
        bit_harvester_url: user['bit_harvester_url'],
        bit_harvester_telephone: user['bit_harvester_telephone'],
        control_type: user['control_type'], 
        line_number: user['line_number'],
        is_user: user['is_user'],
        is_agent: user['is_agent'],
        is_site_manager: user['is_site_manager'],
        is_field_manager: user['is_field_manager'],
        is_demo: user['is_demo'],
        language: user['language'],
        TOU_hours: user['TOU_hours'],
        payment_plan: user['payment_plan'],
        integration_id: user['integration_id'],
        labels: user['labels']
        })
      # flash[:notice] = "New Customers were created"
    else 
      # flash[:alert] = customer.errors.full_messages
      # TODO: send email with there has been a problem
    end      
  end 
  
  def update_customer(user)
    if self.update_attributes!({  
        id_steama: user['id'],
        url: user['url'],
        transactions_url: user['transactions_url'],
        utilities: user['utilities'],
        telephone: user['telephone'], 
        first_name: user['first_name'],
        last_name: user['last_name'],
        account_balance: user['account_balance'],
        low_balance_warning: user['low_balance_warning'],
        low_balance_level: user['low_balance_level'],
        site_manager: user['site_manager'], 
        site_manager_url: user['site_manager_url'],
        site_manager_telephone: user['site_manager_telephone'],
        site: user['site'],
        site_url: user['site_url'],
        site_name: user['site_name'],
        bit_harvester: user['bit_harvester'],
        bit_harvester_url: user['bit_harvester_url'],
        bit_harvester_telephone: user['bit_harvester_telephone'],
        control_type: user['control_type'], 
        line_number: user['line_number'],
        is_user: user['is_user'],
        is_agent: user['is_agent'],
        is_site_manager: user['is_site_manager'],
        is_field_manager: user['is_field_manager'],
        is_demo: user['is_demo'],
        language: user['language'],
        TOU_hours: user['TOU_hours'],
        payment_plan: user['payment_plan'],
        integration_id: user['integration_id'],
        labels: user['labels']
        })
      # flash[:notice] = "New Customers were created"
    else 
      # flash[:alert] = customer.errors.full_messages
      # TODO: send email with there has been a problem
    end 
         
  end
  
end
