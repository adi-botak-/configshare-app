require 'dry-validation'

NewProject = Dry::Validation.Form do
  key(:name).required
  key(:repo_url).maybe(format?: URI.regexp)

  configure do
    config.messages_file = File.join(__dir__, 'new_project_errors.yml')
  end
end