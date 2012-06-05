$: << File.dirname(__FILE__)

require 'zlib'
require 'rack/request'
require 'rack/response'
require 'rack/utils'
require 'time'
require 'git_http/app'
require 'git_http/middleware'
