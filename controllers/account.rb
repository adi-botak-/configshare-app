require 'sinatra'

class ShareConfigurationsApp < Sinatra::Base
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
			slim :home
		else
			slim :login
		end
	end

	get '/logout/?' do
		@current_account = nil
		slim :login
	end
end