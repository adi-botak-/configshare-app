require 'http'

class GetProjectDetails
  def self.call(project_id:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}").get("#{ENV['API_HOST']}/projects/#{project_id}")
    response.code == 200 ? extract_project_details(response.parse) : nil
  end

  private_class_method

  def self.extract_project_details(project_data)
    configurations = project_data['relationships']['configurations']

    configs = configurations.map do |config|
      { 'id' => config['id'] }.merge(config['attributes'])
    end

    { 'id' => project_data['id'], 'configurations' => configs }.merge(project_data['attributes']).merge(project_data['relationships'])
  end
end