Gem::Specification.new do |s|
  s.name        = 'git_commits_rewriter'
  s.version     = '0.0.1'
  s.date        = '2013-05-11'
  s.summary     = "Git commits author rewriter"
  s.description = "Rewrites the author name and email in git commits by using web hooks"
  s.authors     = ["Yosy Attias"]
  s.email       = 'yosy101@gmail.com'
  s.files       = `git ls-files lib/`.split("\n")


  s.add_dependency("json")
  s.add_dependency("typhoeus")
end
