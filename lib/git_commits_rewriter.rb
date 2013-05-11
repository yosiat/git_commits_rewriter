module GitCommitsRewriter

  def self.rewrite repository, provider_config 
    # Get the filter script
    script = File.join(File.dirname(__FILE__), "commits_fixer.rb")

    # The command will run filter-branch with env-filter because we want
    # to update the commits data by exporting the enviroments.
    #
    # In order to the export the enviroments from ruby we will output
    # the "export" command and execute them, like this - 
    # '`echo export test=true`'
    cmd = "cd #{repository} && git filter-branch -f --env-filter '`ruby #{script} #{provider_config}`' HEAD"
    system(cmd)
  end
end
