require "filecreate"

# Structure:
# options = {
#   name: *String, e.g. MyClass
#   namespace: Array -> String,
#   parents: Array -> {
#     scope: String, # e.g. public, defaults to: public
#     name: *String, # e.g. MyParentClass
#   },
#   private: {
#     functions: Array -> Hash, # (For hash fields see build_function)
#     fields: Array -> {
#       type: *String, # e.g. int
#       name: *String # e.g. myField
#     }
#   },
#   public: {
#     functions: Array -> Hash, # (For hash fields see build_function)
#     fields: Array -> {
#       type: *String, # e.g. int
#       name: *String # e.g. myField
#     }
#   },
#   public: {
#     functions: Array -> Hash, # (For hash fields see build_function)
#     fields: Array -> {
#       type: *String, # e.g. int
#       name: *String # e.g. myField
#     }
#   }
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
