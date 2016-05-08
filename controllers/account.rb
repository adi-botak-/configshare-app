require 'sinatra'

class ShareConfigurationsApp < Sinatra::Base
	get '/account/:username' do
		if @current_account && @current_account['username'] == params[:username]
			slim(:account)
		else
			slim(:login)
		end
	end

	get '/login/?' do 
		slim :login
	end

	post '/login/?' do
		username = params[:username]
		password = params[:password]

		@current_account = FindAuthenticatedAccount.call(
			username: username,
			password: password)

		if @current_account
			session[:current_account] = @current_account
			slim :home
		else
			slim :login
		end
	end

	get '/logout/?' do
		@current_account = nil
		session[:current_account] = nil
		slim :login
	end
end