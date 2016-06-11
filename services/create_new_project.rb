require 'http'

class CreateNewProject
  def self.call(auth_token:, owner:, new_project:)
    response = HTTP.auth("Bearer #{auth_token}").post(
    	"#{ENV['API_HOST']}/accounts/#{owner['id']}/projects",
    	json: new_project.to_h)
    new_project = response.parse['data']
    response.code == 201 ? new_project : nil
  end
end