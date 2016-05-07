require 'base64'
require 'rbnacl/libsodium'

# Utility class to encrypt and decrypt messages from this application
# Used for: cookies
# Requires: ENV['MSG_KEY']
class SecureMessages
	def self.encrypt(message)
		key = Base64.urlsafe_decode64(ENV['MSG_KEY'])
		simple_box = RbNaCl::SimpleBox.from_secret_key(key)
		message_enc = simple_box.encrypt(message.to_s)
		Base64.urlsafe_encode64(message_enc)
	end

	def self.decrypt(secret_message)
		key = Base64.urlsafe_decode64(ENV['MSG_KEY'])
		simple_box = RbNaCl::SimpleBox.from_secret_key(key)
		message_enc = Base64.urlsafe_decode64(secret_message)
		simple_box.decrypt(message_enc)
	rescue
		raise "INVALID ENCRYPTED MESSAGE"
	end
end