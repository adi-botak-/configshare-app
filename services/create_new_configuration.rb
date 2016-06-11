require 'http'

class CreateNewConfiguration
  def self.call(auth_token:, account:, project_id:, configuration_data:)
    config_url = "#{ENV['API_HOST']}/projects/#{project_id}/configurations"
    "NEW CONFIG REQUEST: #{configuration_data.to_h}"
    response = HTTP.accept('application/json').auth("Bearer #{auth_token}").post(
    	config_url,
    	json: configuration_data.to_h)
    new_configuration = response.parse
    response.code == 201 ? new_configuration : nil
  end
end