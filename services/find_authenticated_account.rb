require 'http'

# Returns an authenticated account, or nil
#   args: credentials (LoginCredentials)
#    return: account (Hash)
class FindAuthenticatedAccount
	def self.call(credentials)
		response = HTTP.post(
			"#{ENV['API_HOST']}/accounts/authenticate",
			body: SecureMessage.sign(credentials.to_hash))
		response.code == 200 ? response.parse : nil
	end
end