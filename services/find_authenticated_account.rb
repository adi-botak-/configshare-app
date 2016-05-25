require 'http'

# Returns an authenticated account, or nil
class FindAuthenticatedAccount
	def self.call(username:, password:)
		response = HTTP.post(
			"#{ENV['API_HOST']}/accounts/authenticate",
			json: {username: username, password: password})
		response.code == 200 ? response.parse : nil
	end
end