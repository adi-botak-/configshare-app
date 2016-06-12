require 'sinatra'

# Account resource routes
class ShareConfigurationsApp < Sinatra::Base
	get '/accounts/:username' do
		halt_if_incorrect_user(params)

		@auth_token = session[:auth_token]
		slim(:account)
	end
end