class CookieEncoder
	def encode(cookies)
		SecureMessage.encrypt(cookies) if cookies
	end

	def decode(str)
		SecureMessage.decrypt(str) if str
	end
end