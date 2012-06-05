require 'rubygems'
require 'rack'
require 'rack/test'
require 'test/unit'
require 'mocha'
require 'digest/sha1'
require 'lib/git_http/app'
require 'pp'

class GitHttpMiddlewareTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def example
    File.expand_path(File.dirname(__FILE__))
  end

  def app
    config = {
      :project_root => example,
      :uri_root => '/repos',
      :upload_pack => true,
      :receive_pack => true,
    }
    GitHttp::Middleware.new(MockApp.new, config)
  end

  def test_request_handled_by_parent_app
    get '/welcome'
    assert_equal 'Hello World', r.body
  end
    
  private

  def r
    last_response
  end
end

class MockApp 
  def call(env)
    [200, {'Content-Type' => 'text/html'}, 'Hello World']
  end
end