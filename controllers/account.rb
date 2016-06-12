require 'sinatra'

# Account resource routes
class ShareConfigurationsApp < Sinatra::Base
	get '/accounts/:username' do
		if correct_user?(params)
			@auth_token = session[:auth_token]
			slim(:account)
		else
			redirect '/login'
		end
	end
end