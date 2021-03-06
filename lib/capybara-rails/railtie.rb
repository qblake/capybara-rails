module Capybara
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "capybara-rails.configure_rails_initialization" do |app|
        unless app.config.action_dispatch.show_exceptions
          raise "[set up config.action_dispatch.show_exceptions to true in environments/test.rb]"
        end

        require 'capybara/rails'
        require 'exception_notification'

        exception_logger = Logger.new('log/capybara_exceptions.log')
        ExceptionNotifier.add_notifier :capybara_exceptions,
          ->(exception, options) {
            exception_logger.debug(exception.message)
            cleaned_backtrace = ::Rails.backtrace_cleaner.filter exception.backtrace
            exception_logger.debug(cleaned_backtrace)
          }

        app.middleware.use 'ExceptionNotification::Rack'
      end
    end
  end
end
