require "filecreate"


# Structure:
# options = {
#   type: *String, # e.g. int
#   name: *String, # e.g. myFunction
#   params: Array -> Hash {
#     type: *String, # e.g. int
#     Name: *String, # e.g. myParam
#     default: String, # Can be nil
#   }
# }
def build_function(options={})
  raise "function type is invalid '#{options[:type]}'" unless options[:type]
  raise "function name is invalid '#{options[:name]}'" unless options[:name]

  options.params ||= Array.new

  paramlist = Array.new

  options.params.each_with_index do |param, index|
    raise "param '#{param}' at index ##{index} has an invalid type" unless param[:type]
    raise "param '#{param}' at index ##{index} has an invalid name" unless param[:name]

    paramstring = "#{param[:type]} #{param[:name]}"
    if param[:default]
      paramstring += " = #{param[:default]}"
    end
    paramlist.push(paramstring)
  end


end
