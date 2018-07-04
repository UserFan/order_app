require_relative 'boot'

require File.expand_path('../boot', __FILE__)
ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OrderApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.encoding = "utf-8"
    config.time_zone = 'Moscow'
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.assets.initialize_on_precompile = false
    config.i18n.default_locale = :ru
    config.active_record.index_nested_attribute_errors = true
    config.action_mailer.deliver_later_queue_name = 'default_mailer_queue'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
