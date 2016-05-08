require 'sinatra'

class ShareConfigurationsApp < Sinatra::Base
	get '/register/?' do 
		slim :register
	end

	post '/register/?' do
		begin
			EmailRegistrationVerification.call(
				username: params[:username],
				email: params[:email])
			redirect '/'
		rescue => e 
			puts "FAIL EMAIL: #{e}"
			redirect '/register'
		end
	end

	get '/register/:token_secure/verify' do
		@token_secure = params[:token_secure]
		@new_account = SecureMessage.decrypt(@token_secure)

		slim :register_confirm
	end

	post '/register/:token_secure/verify' do
		redirect "/register/#{params[:token_secure]}/verify" unless (params[:password] == params[:password_confirm]) && !params[:password].empty?

		new_account = SecureMessage.decrypt(params[:token_secure])

		result = CreateVerifiedAccount.call(
			username: new_account[:username],
			email: new_account[:email],
			password: params[:password])

		puts "RESULT: #{result}"
		result ? redirect('/login') : redirect('/register')
	end
end