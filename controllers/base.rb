require 'sinatra'
require 'json/jwt'

# Base class for ConfigShare Web Application
class ShareConfigurationsApp < Sinatra::Base
	use Rack::Session::Cookie, coder: CookieEncoder.new, let_coder_handle_secure_encoding: true

	set :views, File.expand_path('../../views', __FILE__)

	before do
		@current_account = session[:current_account]
	end
	
	get '/' do 
		slim :home
	end
end