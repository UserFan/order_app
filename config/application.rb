require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OrderApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.encoding = "utf-8"
    config.time_zone = 'Moscow'
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.assets.initialize_on_precompile = false
    config.i18n.default_locale = :ru
    config.active_record.index_nested_attribute_errors = true
    config.action_mailer.deliver_later_queue_name = 'default_mailer_queue'
    config.action_dispatch.rescue_responses['Pundit::NotAuthorizedError'] = :forbidden
    config.i18n.fallbacks = [I18n.default_locale]
        # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
