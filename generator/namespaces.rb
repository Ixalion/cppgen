
# options = {
#   namespace: Array -> String, # e.g. ["ix", "ai"]
#   line_ending: String, # e.g. '\n', defaults to: '\n'
# }
#
# return = {
#   header: String, # The namespace's header.
#   footer: String # The namespace's footer.
# }
def build_namespace(options={})
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

# options = {
#   namespace: Array -> String # e.g. ["ix", "ai"]
# }
def compose_namespace(options={})
  options[:namespace] ||= Array.new

  return options[:namespace].join("::")
end

# options = {
#   namespace: Array -> String # e.g. ["ix", "ai"]
# }
def build_namespace_directory(options={})
  options[:namespace] ||= Array.new

  return File.join(options[:namespace])
end
