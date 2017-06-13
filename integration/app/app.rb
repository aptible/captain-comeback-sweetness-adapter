require 'sidekiq'

def oops
  Process.kill('KILL', Process.pid)
end

Sidekiq.configure_server do |config|
  config.error_handlers << proc do |exc|
    Sidekiq.logger.error exc.to_s
    oops
  end
end

module Sweetness
  module Tasks
    class RecoverContainer
      include Sidekiq::Worker

      def perform(operation_id, docker_name)
        Sidekiq.logger.info "got: #{operation_id} / #{docker_name}"
        oops if operation_id != 0
        oops if docker_name != 'foo-container'
        Process.kill('TERM', Process.pid) # aka exit 0
      end
    end
  end
end
