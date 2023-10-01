RSpec::Matchers.define :match_response_reminder_schema do |schema|
   match do |response|
      schema_path = YAML.load(File.open("spec/schema/#{schema}.yml"))
     JSON::Validator.validate!(schema_path, response.body)
   end
end
