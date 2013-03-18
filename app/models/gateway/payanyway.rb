class Gateway::Payanyway < Gateway
  preference :id, :string
  preference :currency_code, :string, :default => 'RUB'
  preference :signature, :string
  preference :locale, :string, :default => 'ru'
  preference :payment_system, :string
  preference :payment_system_list, :string

  def method_type
    'payanyway'
  end

  def url
    'https://www.moneta.ru/assistant.htm'
  end

  def mode
    test? ? 1 : 0
  end

  def test?
    options[:test_mode] == true
  end

  def self.current
    self.where(:type => self.to_s, :environment => Rails.env, :active => true).first
  end

  def source_required?
    false
  end

end
