
def running_as_server?
  Rails.const_defined?(:Server) || defined?(::Rack::Handler::Thin)
end

Rails.application.config.after_initialize do
  unless running_as_server?
    Faye.ensure_reactor_running!
  end
end