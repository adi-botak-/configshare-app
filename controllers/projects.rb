require 'sinatra'

class ShareConfigurationsApp < Sinatra::Base
  get '/accounts/:username/projects' do 
    if @current_account && @current_account['username'] == params[:username]
      @projects = GetAllProjects.call(
        username: params[:username],
        auth_token: session[:auth_token])
    end

    @projects ? slim(:all_projects) : redirect('/login')
  end

  get '/accounts/:username/projects/:project_id' do
    if @current_account && @current_account['username'] == params[:username]
      @project = GetProjectDetails.call(
        project_id: params[:project_id],
        auth_token: session[:auth_token])
      if @project
        slim(:project)
      else
        flash[:error] = 'We cannot find this project in your account'
        redirect "/accounts/#{params[:username]}/projects"
      end
    else
      redirect '/login'
    end
  end
end