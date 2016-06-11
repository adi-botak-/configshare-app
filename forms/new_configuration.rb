require 'dry-validation'

NewConfiguration = Dry::Validation.Form do
  key(:filename).required(:filename_valid?)
  key(:relative_path).maybe(:path_chars?)
  key(:description).maybe
  key(:document).required

  configure do
    config.messages_file = File.join(__dir__, 'new_configuration_errors.yml')

    def filename_valid?(str)
      (str.length <= 256) && (str =~ %r{^((?![&\/\\\{\}\|\t]).)*$}) ? true : false
    end

    def path_chars?(str)
      (str =~ %r{^((?![&\/\\\{\}\|\t]).)*$}) ? true : false
    end
  end
end