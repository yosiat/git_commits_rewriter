module ParametersMapper
  def self.map source, mapping
      mapped_source = source.map do |key, value|
        [ mapping[key.to_s], value ]
      end 

      mapped_source = Hash[mapped_source]
      mapped_source
  end
end


