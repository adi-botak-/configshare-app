require 'http'

# Returns an authenticated account, or nil
class FindAuthenticatedAccount
	HOST = 'http://api-configshare.herokuapp.com/api/v1'

	def self.call(username:, password:)
		response = HTTP.get(
			"#{HOST}/accounts/#{username}/authenticate",
			params: {password: password})
		response.code == 200 ? JSON.parse(response) : nil
	end
end