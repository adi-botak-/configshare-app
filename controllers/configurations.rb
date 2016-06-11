require 'sinatra'

class ShareConfigurationsApp < Sinatra::Base
  post '/accounts/:username/projects/:project_id/configurations' do
    halt_if_incorrect_user(params)

    project_url = "/accounts/#{@current_account['username']}/projects/#{params[:project_id]}"

    new_config_data = NewConfiguration.call(params)

    if new_config_data.failure?
      flash[:error] = 'Configuration details invalid: ' + new_config_data.values.join('; ')
      redirect project_url
    else
      begin
        new_config = CreateNewConfiguration.call(
        	auth_token: session[:auth_token],
        	account: @current_account,
        	project_id: params[:project_id],
        	configuration_data: new_config_data.to_h)
        flash[:notice] = 'Here is your new configuration file!'
        redirect project_url + "/configurations/#{new_config['id']}"
      rescue => e
        flash[:error] = 'Something went wrong -- we will look into it!'
        logger.error "NEW CONFIGURATION FAIL: #{e}"
        redirect project_url
      end
    end
  end
end