require 'sinatra'

class ShareConfigurationsApp < Sinatra::Base
  get '/accounts/:username/projects/?' do 
    if @current_account && @current_account['username'] == params[:username]
      @projects = GetAllProjects.call(
        current_account: @current_account,
        auth_token: session[:auth_token])
    end

    @projects ? slim(:all_projects) : redirect('/login')
  end

  get '/accounts/:username/projects/:project_id/?' do
    if @current_account && @current_account['username'] == params[:username]
      @project = GetProjectDetails.call(
        project_id: params[:project_id],
        auth_token: session[:auth_token])
      if @project
        puts "PROJECT #{@project}"
        slim(:project)
      else
        flash[:error] = 'We cannot find this project in your account'
        redirect "/accounts/#{params[:username]}/projects"
      end
    else
      redirect '/login'
    end
  end

  post '/accounts/:username/projects/?' do
    halt_if_incorrect_user(params)

    projects_url = "/accounts/#{@current_account['username']}/projects"

    new_project_data = NewProject.call(params)
    if new_project_data.failure?
      flash[:error] = new_project_data.messages.values.join('; ')
      redirect projects_url
    else
      begin
        new_project = CreateNewProject.call(
          auth_token: session[:auth_token],
          owner: @current_account,
          new_project: new_project_data.to_h)
        flash[:notice] = 'Your new project has been created! '\
                                  'Now add configurations and invite collaborators.'
        redirect projects_url + "/#{new_project['id']}"
      rescue => e
        flash[:error] = 'Something went wrong -- we will look into it!'
        logger.error "NEW_PROJECT FAIL: #{e}"
        redirect "/accounts/#{@current_account['username']}/projects"
      end
    end
  end
end