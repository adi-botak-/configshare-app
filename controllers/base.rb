require 'sinatra'
require 'rack-flash'
require 'rack/ssl-enforcer'

# Base class for ConfigShare Web Application
class ShareConfigurationsApp < Sinatra::Base
	enable :logging
	
	use Rack::Session::Cookie, secret: ENV['MSG_KEY'], expire_after: 60 * 60 * 24 * 7
	use Rack::Flash

	configure :production do
		use Rack::SslEnforcer
	end

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