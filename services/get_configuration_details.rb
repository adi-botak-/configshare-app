require 'http'

class GetConfigurationDetails
  def self.call(auth_token:, project_id:, configuration_id:)
    response = HTTP.auth("Bearer #{auth_token}").get("#{ENV['API_HOST']}/projects/#{project_id}/configurations/#{configuration_id}")
    response.code == 200 ? extract_configuration_details(response.parse) : nil
  end

  private_class_method

  def self.extract_configuration_details(config_data)
    project_data = config_data['relationships']['project']
    project = { 'project' => { 'id' => project_data['id'] } }

    { 'id' => config_data['id'] }.merge(config_data['attributes']).merge(project)
  end
end