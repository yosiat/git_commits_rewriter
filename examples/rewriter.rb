require 'git_commits_rewriter'

repository = "/Users/yosy/repos/test"


GitCommitsRewriter.rewrite repository, File.join(Dir.pwd, "data.json") 

