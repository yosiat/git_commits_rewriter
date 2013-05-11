require "json"
require "typhoeus"

require_relative "git_filter_enviroment"
require_relative "utils/parameters_mapper"

class CommitsFilter

  def initialize provider_config, commits_info
    @provider_config = provider_config 
    @commits_info = commits_info
  end

  def start!
    # Send a request
    response = send_request


    # Apply response if we have..
    if @provider_config.has_key? "response"
      response = ParametersMapper.map(response, @provider_config["response"])
    end

    # Create new configuration..
    commit_info = {
      :GIT_AUTHOR_NAME => response["author_name"],
      :GIT_AUTHOR_EMAIL => response["author_email"]
    }

    GitFilterEnviroment.update_commits_info commit_info
  end


  def self.init_from_arguments
    # load the configuration file
    file_name = ARGV.shift
    json = File.open(file_name).readlines("").first

    # Parse the config file
    provider_config = JSON.parse(json)

    CommitsFilter.new(provider_config, GitFilterEnviroment.get_commits_info)
  end

private

  def send_request
   params = build_params 
   headers = {
    :Accept => "text/json, application/json"
   }

   
   request = Typhoeus::Request.new(@provider_config["url"], method: @provider_config["method"].to_sym, params: params, headers: headers)
   response = request.run

   JSON.parse response.body
  end


  def build_params
    # get the params by the commits info
    params = {
      :author_name => @commits_info[:GIT_AUTHOR_NAME],
      :author_email => @commits_info[:GIT_AUTHOR_EMAIL]
    }

    # does the user wants to map the params to other names?
    if @provider_config.has_key? "params"
      params = ParametersMapper.map(params, @provider_config["params"])
    end

    params
  end 
end


commits_filter = CommitsFilter.init_from_arguments
commits_filter.start! 

