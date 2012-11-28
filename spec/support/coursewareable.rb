# Set default URL options since we use sub-domains in tests
# TODO: Cleanup this shit!
class ActionDispatch::Routing::RouteSet
  def url_for_with_host_fix(options)
    url_for_without_host_fix(options.merge(:host => 'test.host'))
  end

  alias_method_chain :url_for, :host_fix
end

# Expose engine routes
RSpec.configure do |c|
  c.include Coursewareable::Engine.routes.url_helpers
end
