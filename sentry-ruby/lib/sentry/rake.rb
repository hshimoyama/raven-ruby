require "rake"
require "rake/task"

module Rake
  class Application
    alias orig_display_error_messsage display_error_message
    def display_error_message(ex)
      Sentry.capture_exception(ex) do |scope|
        task_name = top_level_tasks.join(' ')
        scope.set_transaction_name(task_name)
        scope.set_tag("rake_task", task_name)
      end

      orig_display_error_messsage(ex)
    end
  end
end
