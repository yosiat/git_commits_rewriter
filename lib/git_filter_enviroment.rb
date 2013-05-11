module GitFilterEnviroment
  
  def self.get_commits_info
    {
      :GIT_AUTHOR_NAME => ENV["GIT_AUTHOR_NAME"],
      :GIT_AUTHOR_EMAIL => ENV["GIT_AUTHOR_EMAIL"]
    }
  end

  # Dirty trick - in order to export to git shell we will print
  # the export statement and execute with ticks ``
  def self.export key, value
    puts "export #{key}=#{value}"
  end


  def self.update_commits_info info
    info.each do |key, value|
      export key, value
    end
  end

end


