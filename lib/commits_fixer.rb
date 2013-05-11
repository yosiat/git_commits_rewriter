require "json"
require_relative "git_filter_enviroment"
require "typhoeus"

class CommitsFilter

  def initialize provider_config, commits_info
    @provider_config = provider_config 
    @commits_info = commits_info
  end

  def start!
    # Send a request
    mapping = send_request



    # Apply mapping if we have..
    if @provider_config.has_key? "response"
      mapping = mapping.map do |key, value|
        [ @provider_config["response"][key.to_s], value ]
      end 

      mapping = Hash[mapping]
    end

    # Create new configuration..
    commit_info = {
      :GIT_AUTHOR_NAME => mapping["author_name"],
      :GIT_AUTHOR_EMAIL => mapping["author_email"]
    }

    GitFilterEnviroment.update_commits_info commit_info
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
      # Remap the array according to the provider config
      params  = params.map do |key,value|
        [ @provider_config["params"][key.to_s], value ]
      end

      # params now will be an hash, convert to hash
      params = Hash[params]
    end

    params
  end 

end


# load the configuration file
file_name = ARGV.shift
json = File.open(file_name).readlines("").first


provider_config = JSON.parse(json)
commits_filter = CommitsFilter.new(provider_config, GitFilterEnviroment.get_commits_info)

commits_filter.start! 












