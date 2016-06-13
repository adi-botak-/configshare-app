require 'sinatra'
require 'rack-flash'

# Base class for ConfigShare Web Application
class ShareConfigurationsApp < Sinatra::Base
	enable :logging
	
	use Rack::Flash

	set :views, File.expand_path('../../views', __FILE__)
	set :public_dir, File.expand_path('../../public', __FILE__)

	before do
		if session[:current_account]
			@current_account = SecureMessage.decrypt(session[:current_account])
		end
	end

	def current_account?(params)
	  @current_account && @current_account['username'] == params[:username]
	end

	def halt_if_incorrect_user(params)
	  return true if current_account?(params)
	  flash[:error] = 'You used the wrong account for this request'
	  redirect '/login'
	  halt
	end
	
	get '/' do 
		slim :home
	end
end