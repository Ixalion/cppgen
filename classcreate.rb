require "filecreate"

require "functions"
require "namespaces"

# Structure:
# options = {
#   functions: Array -> Hash, # (For hash fields see build_function)
#   fields: Array -> {
#     type: *String, # e.g. int
#     name: *String # e.g. myField
#   }
# }
def validate_class_scope_options(options={})
  options[:functions] ||= Array.new
  options[:fields] ||= Array.new

  options[:functions].each_with_index do |function, index|
    begin
      validate_function(function)
    rescue => e
      message =  "validate_class_scope_options caught exception during function"
      message += " validation: '#{e}' at index ##{index}"
      raise message
    end
  end

  options[:fields].each_with_index do |field, index|
    unless field[:type]
      raise "validate_class_scope_options type must be present at index ##{index}"
    end
    unless field[:name]
      raise "validate_class_scope_options name must be present at index ##{index}"
    end
  end
end

# Structure:
# See validate_class_scope_options
def generate_class_scope(options={})
  options = validate_class_scope_options(options)

  return <<-EOF

EOF
end

# Structure:
# options = {
#   name: *String, e.g. MyClass
#   namespace: Array -> String,
#   use_struct: Boolean, # defaults to: false
#   parents: Array -> {
#     scope: String, # e.g. public, defaults to: public
#     name: *String, # e.g. MyParentClass
#   },
#   private: Hash, # (For hash fields see generate_class_scope)
#   public: Hash, # (For hash fields see generate_class_scope)
#   public: Hash, # (For hash fields see generate_class_scope)
# }
def validate_class_options(options={})
  raise "validate_class_options name must be present" unless options[:name]

  options[:namespace] ||= Array.new
  options[:parents] ||= Array.new

  options[:private] ||= Hash.new
  options[:private][:functions] ||= Array.new
  options[:private][:fields] ||= Array.new

  options[:protected] ||= Hash.new
  options[:protected][:functions] ||= Array.new
  options[:protected][:fields] ||= Array.new

  options[:public] ||= Hash.new
  options[:public][:functions] ||= Array.new
  options[:public][:fields] ||= Array.new

  return options
end

# Structure:
# See validate_class_options
def compose_class_header(options={})
  options = validate_class_options(options)

  type = options[:use_struct] ? "struct" : "class"

  return <<-EOF
#{type} #{option[:name]}#{} {

private:

public:
}
EOF
end

# Structure:
# See validate_class_options
def compose_class_source(options={})
  options = validate_class_options(options)

end

# Structure:
# See validate_class_options
#
# return = {
#   header: String, # The class's header file.
#   source: String # The class's source file.
# }
def compose_class(options={})
  options = validate_class_options(options)

  return {
    header: compose_class_header(options),
    source: compose_class_source(options)
  }
end
