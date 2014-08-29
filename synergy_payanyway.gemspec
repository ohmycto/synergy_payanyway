# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'synergy_payanyway'
  s.version      = '0.70.3'
  s.summary      = 'Adds PayAnyWay support'
  s.description  = 'synergy_payanyway add PayAnyWay payment method to spree commerce.'
  s.required_ruby_version = '>= 1.8.7'

  s.author       = 'Igor Kapkov (Service & Consulting)'
  s.email        = 'service@secoint.ru'
  s.homepage     = 'http://synergycommerce.ru/'

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 0.60.0'
  s.add_development_dependency 'rspec-rails'
end
