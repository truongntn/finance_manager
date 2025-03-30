# frozen_string_literal: true

# Versionist configuration
Versionist.configure do |config|
  # Set the default version
  config.default_version = 'v1'
  
  # Set the version header name
  config.header_name = 'Accept'
  
  # Set the version header format
  config.header_format = 'application/vnd.finance_manager+json; version=%s'
  
  # Set the version parameter name
  config.parameter_name = 'version'
  
  # Set the version parameter format
  config.parameter_format = '%s'
  
  # Set the version module name format
  config.module_name_format = 'V%s'
  
  # Set the version controller name format
  config.controller_name_format = 'V%s::BaseController'
end 