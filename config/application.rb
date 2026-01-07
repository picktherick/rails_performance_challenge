require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsPerformanceChallenge
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    config.active_record.raise_in_transactional_callbacks = true

    # Timezone
    config.time_zone = 'Brasilia'

    # Locale
    config.i18n.default_locale = :'pt-BR'

    # Generators
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end
