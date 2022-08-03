module Sieves
  class Engine < ::Rails::Engine
    isolate_namespace Sieves

    initializer 'sieves.locales', before: :load_config_initializers do
      Rails.application.config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end

    initializer 'sieves.action_controller' do
      ActiveSupport.on_load :action_controller do
        helper FilterableHelper
        include Filterable::FilterableRequest
      end
    end
  end
end
