require 'sinatra'

class ShareConfigurationsApp < Sinatra::Base
  get '/accounts/:username/projects' do 
    if @current_account && @current_account['username'] == params[:username]
      @projects = GetAllProjects.call(username: params[:username])
      slim(:all_projects)
    else
      slim(:login)
    end
  end

  get '/accounts/:username/projects/:project_id' do
    if @current_account && @current_account['username'] == params[:username]
      @project = GetProjectDetails.call(username: params[:username], project_id: params[:project_id])
      slim(:project)
    else
      slim(:login)
    end
  end
end