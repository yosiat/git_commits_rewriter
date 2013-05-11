require "json"

module GitCommitsRewriter

  def self.rewrite repository, provider_config 
    # Get the filter script
    script = File.join(File.dirname(__FILE__), "commits_fixer.rb")


    cmd = "cd #{repository} && git filter-branch -f --env-filter '`ruby #{script} #{provider_config}`' HEAD"
    system(cmd)
  end


end
