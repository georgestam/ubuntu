class Customer < ApplicationRecord
  
  TARIFS = %w[60 80 100].freeze
  
  require 'rest-client'
  
  has_many :alerts, dependent: :destroy
  has_many :topups, dependent: :destroy
  
  has_many :meters, dependent: :destroy
  has_many :usages, through: :meters
  
  has_many :balances, dependent: :destroy
  
  validates :id_steama, presence: true, uniqueness: true
  validates :energy_price, inclusion: { in: TARIFS, allow_nil: false }
  
  def self.customer_id_exist?(id_steama)
    true if Customer.find_by(id_steama: id_steama)
  end 
  
  def name
    "#{self.first_name},#{self.last_name}"
  end
  
  def self.tariff(number)
    if number == 1 # top 11
      TARIFS[0]
    elsif number == 2
      TARIFS[1]
    else # bottom 44
      TARIFS[2]
    end 
  end 
  
  def an_alert_open_with?(name_type_of_alert)
    exist = false 
    Alert.all.each do |alert|
      if Alert.find_by(resolved_at: nil, customer_id: self.id, issue: Issue.find_by(type_alert: TypeAlert.find_by(name: name_type_of_alert)))
        exist = true  
      end
    end 
    exist
  end
  
  def self.update_customer_db
    url1 = "https://api.steama.co/customers/?format=json&page_size=70"
    url2 = "https://api.steama.co/customers/?format=json&page=2&page_size=70"
    
    [url1, url2].each do |url|
      json_data = {}
      if !test?
        body = RestClient.get url, {:Authorization => "Token #{ENV['TOKEN_STEAMA']}"}
        json_data = JSON.parse(body)
      else 
        file = Rails.root.join('spec', 'support', 'example_steama.json')
        json_data = JSON.parse(File.read(file))
      end 
      # This defines the id:
      # body['results'][0]['id']
      # create new customers
      json_data['results'].each do |customer|
        # create new customers
        if Customer.customer_id_exist?(customer['id'])
          Customer.find_by(id_steama: customer['id']).update_customer(customer)
        else # create new customer
          Customer.create_new_customer(customer)
        end 
      end  
        
    end 
  end
  
  def self.create_new_customer(user)
    if Customer.create({  
        id_steama: user['id'],
        url: user['url'],
        transactions_url: user['transactions_url'],
        utilities: user['utilities'],
        telephone: user['telephone'], 
        first_name: user['first_name'],
        last_name: user['last_name'],
        energy_price: user['energy_price'],
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
    self.check_customers_with_sudden_drop_in_balance(user['account_balance'].to_i)
    if self.update_attributes({  
        id_steama: user['id'],
        url: user['url'],
        transactions_url: user['transactions_url'],
        utilities: user['utilities'],
        telephone: user['telephone'], 
        first_name: user['first_name'],
        last_name: user['last_name'],
        energy_price: user['energy_price'],
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
  
  def check_customers_with_sudden_drop_in_balance(new_account_balance)
    if (self.account_balance.to_i - new_account_balance) > 100
      type_alert = TypeAlert.find_by(name: "Sudden high drop in account balance")
      Alert.create!({
          customer: self,
          type_alert: type_alert,
          issue: Issue.find_by(type_alert: type_alert)
          })
    end
  end
  
end
