require "bundler/setup"
require "sinatra"
require "sinatra/namespace"
require "sinatra/partial"
#require 'sinatra/cross_origin'
require "rubygems"
require "json"
require "curb"
require 'active_record'
require 'cgi'
require 'warden'
require 'haml'

# Start the show
set :app_file, __FILE__
set :root, File.dirname(__FILE__)

require "./app-sinatra/config/settings.rb"
require "./app-sinatra/config/config.rb"
require "./app-sinatra/config/routes.rb"
