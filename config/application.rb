require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bankbot
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    Rails.application.config.fb_token = 'CAAY9TEEFWvsBAIeOCZClJ9N5hMS3ZBm0ra4zLKClKL5qx3Nl1sZAOjAZB7wT4ChMXQ71gtVPfyWDhczPIMhPzsGv4n6dFJY71zFWGZChnjnBVArH0dDOm0ee3cktTMVzeDkPjXndeBOSx6pk5dKHa6n5DoZC8u7QEqIBe6WcJ0cnxGTIRJhKU74wWZBrpQbAOnVZBZCaVyMIcvwZDZD'
    Rails.application.config.ai_token = 'e5e7bff08d9e488e80519a300cc3d9d6'

  end
end
