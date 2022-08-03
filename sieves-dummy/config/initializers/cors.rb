Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://127.0.0.1:8000"
    resource '*', headers: :any, methods: :any
    resource '/dist/*', headers: :any, methods: :any
    resource '/dist/sieves-js.js', headers: :any, methods: :any
    resource '/**/*', headers: :any, methods: :any
  end
end
