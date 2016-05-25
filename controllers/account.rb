require 'sinatra'

class ShareConfigurationsApp < Sinatra::Base
	get '/accounts/:username' do
		if @current_account && @current_account['username'] == params[:username]
			@auth_token = session[:auth_token]
			slim(:account)
		else
			slim(:login)
		end
	end

	get '/login/?' do 
		slim :login
	end

	post '/login/?' do
		credentials = LoginCredentials.call(params)
		if credentials.failure?
			flash[:error] = 'Please enter both your username and password'
			redirect '/login'
			halt
		end

		auth_account = FindAuthenticatedAccount.call(credentials)

		if auth_account
			@current_account = auth_account['account']
			session[:auth_token] = auth_account['auth_token']
			session[:current_account] = SecureMessage.encrypt(@current_account)
			flash[:notice] = "Welcome back, #{@current_account['username']}!"
			redirect '/'
		else
			flash[:error] = 'Your username or password did not match our records'
			slim :login
		end
	end

	get '/logout/?' do
		@current_account = nil
		session.clear
		flash[:notice] = 'You have logged out - please login again to use this site'
		slim :login
	end
end