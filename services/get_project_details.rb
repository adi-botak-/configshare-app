require 'http'

class GetProjectDetails
  def self.call(project_id:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}").get("#{ENV['API_HOST']}/projects/#{project_id}")
    response.code == 200 ? extract_project_details(response.parse) : nil
  end

  private_class_method

  def self.extract_project_details(project_data)
    project = project_data['data']
    configs = project_data['relationships']

    configurations = configs.map do |config|
      { id: config['id'],
      	name: config['data']['name'],
      	description: config['data']['description']
      }
    end

    { id: project['id'],
    	name: project['attributes']['name'],
    	repo_url: project['attributes']['repo_url'],
    	configurations: configurations
    }
  end
end