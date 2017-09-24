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
def build_function(options={})
  raise "function type is invalid '#{options[:type]}'" unless options[:type]
  raise "function name is invalid '#{options[:name]}'" unless options[:name]

  options[:params] ||= Array.new

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

    doxy_params.push(" * @return")

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
# See build_function
def build_function_header(options={})

  raise "function type is invalid '#{options[:type]}'" unless options[:type]
  raise "function name is invalid '#{options[:name]}'" unless options[:name]

  options[:params] ||= Array.new

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

# Structure:
# options = {
#   namespace: Array -> String # e.g. ["ix", "ai"],
#   line_ending: String, # e.g. '\n', defaults to: '\n'
# }
#
# return = {
#   header: String, # The namespace's header.
#   footer: String # The namespace's footer.
# }
def build_namespace(options)
  options[:namespace] ||= Array.new
  options[:line_ending] ||= "\n"

  header = options[:namespace].map do |namespace|
    "namespace #{namespace} {"
  end.join(options[:line_ending])

  footer = options[:namespace].map do |namespace|
    "} /* namespace #{namespace} */"
  end.join(options[:line_ending])

  return {
    header: header,
    footer: footer
  }
end
