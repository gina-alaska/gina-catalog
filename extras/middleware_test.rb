class MiddlewareTest
  def initialize(app, config = {})
    @app = app
    @config = config
  end
  
  def call(env)
    @env = env.dup
    response = @app.call(env)
    
    puts @env[]
    
    [200, {"Content-Type" => "text/html"}, ['foo']]
  end
end