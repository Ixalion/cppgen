
# Structure:
# options = {
#   type: *String, # e.g. int
#   name: *String, # e.g. myFunction
#   params: Array -> Hash {
#     type: *String, # e.g. int
#     Name: *String, # e.g. myParam
#     default: String, # Can be nil
#   },
#   build_doxygen: Boolean # defaults to: true
# }
def validate_function(options={})
  raise "function type is invalid '#{options[:type]}'" unless options[:type]
  raise "function name is invalid '#{options[:name]}'" unless options[:name]

  options[:params] ||= Array.new

  return options
end

# Structure:
# See validate_function
def build_function(options={})
  options = validate_function(options)

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

  paramstring = paramlist.join(", ")

  if options[:build_doxygen]
    doxy_params = options[:params].map do |param|
      " * @param #{param[:name]}"
    end

    doxy_params.push(" * @return") unless options[:type] == "void"

    doxygen_comment = <<-COMMENT
/**
 *
 *
#{doxy_params.join("\n")}
 */
COMMENT

    return <<-EOF
#{doxygen_comment}
#{options[:type]} #{options[:name]}(#{paramstring}) {
  // TODO: Implement me.
}
EOF
  else
    return <<-EOF
#{options[:type]} #{options[:name]}(#{paramstring}) {
  // TODO: Implement me.
}
EOF
  end
end


# Structure:
# See validate_function
def build_function_header(options={})
  options = validate_function(options)

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

  paramstring = paramlist.join(", ")

  return <<-EOF
#{options[:type]} #{options[:name]}(#{paramstring});
EOF
end
