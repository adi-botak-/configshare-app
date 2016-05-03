require 'sinatra'

# Base class for ConfigShare Web Application
class ShareConfigurationsApp < Sinatra::Base
	use Rack::Session::Cookie, expire_after: 2_592_000 # One month in seconds

	set :views, File.expand_path('../../views', __FILE__)

	before do
		@current_account = session[:current_account]
	end
	
	get '/' do 
		slim :home
	end
end