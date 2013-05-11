module ParametersMapper
  def self.map source, response
      response = mapping.map do |key, value|
        [ soruce[key.to_s], value ]
      end 

      response = Hash[mapping]
  end
end


