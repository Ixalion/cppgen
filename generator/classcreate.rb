require_relative "helpers"

require_relative "filecreate"

require_relative "functions"
require_relative "namespaces"

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
      options[:functions][index] = validate_function(function)
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

  return options
end

# Structure:
# See validate_class_scope_options
def generate_class_scope(options={})
  options = validate_class_scope_options(options.clone)

  lines = Array.new

  options[:fields].each do |field|
    lines.push("#{field[:type]} #{field[:name]};")
  end

  options[:functions].each do |function|
    lines.push(build_function_header(function))
  end

  return <<-EOF
#{lines.join("\n")}
EOF
end

def generate_template_class_scope_options
  return {
    functions: Array.new,
    fields: Array.new
  }
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
#   protected: Hash, # (For hash fields see generate_class_scope)
#   public: Hash, # (For hash fields see generate_class_scope)
#   project_includes: Array -> String, # e.g. my_other_header.h
#   system_includes: Array -> String, # e.g. iostream
#   path: String # Defaults to nil, if Falsy, then default path generation is used.
#   ruby_generator: Boolean # defaults to false
# }
def validate_class_options(options={})
  raise "validate_class_options name must be present options: '#{options.inspect}'" unless options[:name]

  options[:namespace] ||= Array.new

  options[:project_includes] ||= Array.new
  options[:system_includes] ||= Array.new

  options[:path] ||= nil

  options[:ruby_generator] ||= false

  options[:parents] ||= Array.new
  options[:parents].each_with_index do |parent, index|
    unless parent[:name]
      raise "validate_class_options parents name must be present at index ##{index}"
    end

    options[:parents][index][:scope] ||= "public"
  end

  begin
    options[:private] ||= Hash.new
    options[:private] = validate_class_scope_options(options[:private])
  rescue => e
    message =  "validate_class_options caught exception during private"
    message += " validation: '#{e}'"
    raise message
  end

  begin
    options[:protected] ||= Hash.new
    options[:protected] = validate_class_scope_options(options[:protected])
  rescue => e
    message =  "validate_class_options caught exception during protected"
    message += " validation: '#{e}'"
    raise message
  end

  begin
    options[:public] ||= Hash.new
    options[:public] = validate_class_scope_options(options[:public])
  rescue => e
    message =  "validate_class_options caught exception during public"
    message += " validation: '#{e}'"
    raise message
  end

  return options
end


# Structure:
# See validate_class_options
def compose_class_base_filename(options={})
  options = validate_class_options(options.clone)

  return options[:name].underscore
end

# Structure:
# See validate_class_options
def compose_class_header(options={})
  options = validate_class_options(options.clone)

  type = options[:use_struct] ? "struct" : "class"

  lines = Array.new

  if options[:system_includes].any?
    system_includes = options[:system_includes].map do |system_include|
      "#include <#{system_include}>"
    end
    system_includes.push("")

    lines.concat(system_includes)
  end

  if options[:project_includes].any?
    project_includes = options[:project_includes].map do |project_include|
      "#include \"#{project_include}\""
    end
    project_includes.push("")

    lines.concat(project_includes)
  end

  if options[:namespace].any?
    lines.push(build_namespace(options.clone)[:header])
    lines.push("")
  end

  inheritance_string = ""

  if options[:parents].any?
    inheritances = Array.new

    options[:parents].each do |parent|
      inheritances.push("#{parent[:scope]} #{parent[:name]}")
    end

    inheritance_string = ": #{inheritances.join(", ")}"
  end

  lines.push("#{type} #{options[:name]}#{inheritance_string} {")

  if options[:private][:functions].any? || options[:private][:fields].any?
    lines.push <<-BLOCK
private:
#{generate_class_scope(options[:private]).indent(2)}
BLOCK
  end

  if options[:protected][:functions].any? || options[:protected][:fields].any?
    lines.push <<-BLOCK
protected:
#{generate_class_scope(options[:protected]).indent(2)}
BLOCK
  end

  if options[:public][:functions].any? || options[:public][:fields].any?
    lines.push <<-BLOCK
public:
#{generate_class_scope(options[:public]).indent(2)}
BLOCK
  end

  lines.push("};")

  if options[:namespace].any?
    lines.push("")
    lines.push(build_namespace(options.clone)[:footer])
  end

  return <<-EOF
#{lines.join("\n")}
EOF
end

# Structure:
# See validate_class_options
def compose_class_source(options={})
  options = validate_class_options(options.clone)

  lines = Array.new

  if options[:namespace].any?
    lines.push(build_namespace(options.clone)[:header])
    lines.push("")
  end

  if options[:private][:functions].any?
    lines.push <<-COMMENT
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                      Private Function Implementation                       //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
COMMENT
    lines.push("")

    options[:private][:functions].each do |function|
      temp_function = function.clone
      temp_function[:name] = "#{options[:name]}::#{function[:name]}"
      lines.push(build_function(temp_function))
      lines.push("")
    end

    lines.push("")
  end

  if options[:protected][:functions].any?
    lines.push <<-COMMENT
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                     Protected Function Implementation                      //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
COMMENT
    lines.push("")

    options[:protected][:functions].each do |function|
      temp_function = function.clone
      temp_function[:name] = "#{options[:name]}::#{function[:name]}"
      lines.push(build_function(temp_function))
      lines.push("")
    end

    lines.push("")
  end

  if options[:public][:functions].any?
    lines.push <<-COMMENT
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                       Public Function Implementation                       //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
COMMENT
    lines.push("")

    options[:public][:functions].each do |function|
      temp_function = function.clone
      temp_function[:name] = "#{options[:name]}::#{function[:name]}"
      lines.push(build_function(temp_function))
      lines.push("")
    end

    lines.push("")
  end

  if options[:namespace].any?
    lines.push(build_namespace(options.clone)[:footer])
  end

  return <<-EOF
#include "#{compose_class_base_filename(options.clone)}.#{HEADER_FILE_EXTENSION}"

#{lines.map(&:rstrip).join("\n")}
EOF
end

# Structure:
# See validate_class_options
#
# return = {
#   header: String, # The class's header file.
#   source: String # The class's source file.
# }
def compose_class(options={})
  options = validate_class_options(options.clone)

  return {
    header: compose_class_header(options.clone),
    source: compose_class_source(options.clone)
  }
end


# Structure:
# See validate_class_options
def class_file_write(options={})
  options = validate_class_options(options.clone)

  class_data = compose_class(options.clone)

  # The header file
  header_filename = "#{compose_class_base_filename(options.clone)}.#{HEADER_FILE_EXTENSION}"
  header_directory = "#{File.join(HEADER_FILE_DIRECTORY, build_namespace_directory(options.clone))}"

  if options[:path]
    header_directory = options[:path]
  end

  file_write(
    filename: header_filename,
    directory: header_directory,
    body: class_data[:header],
    fileguard: true,
    ruby_generator: options[:ruby_generator]
  )

  # The source file
  source_filename = "#{compose_class_base_filename(options.clone)}.#{SOURCE_FILE_EXTENSION}"
  source_directory = "#{File.join(SOURCE_FILE_DIRECTORY, build_namespace_directory(options.clone))}"

  if options[:path]
    source_directory = options[:path]
  end

  file_write(
    filename: source_filename,
    directory: source_directory,
    body: class_data[:source],
    fileguard: false,
    ruby_generator: options[:ruby_generator]
  )
end

def generate_template_class_options
  return {
    name: nil,
    namespace: Array.new,
    use_struct: nil,
    parents: Array.new,
    private: generate_template_class_scope_options,
    protected: generate_template_class_scope_options,
    public: generate_template_class_scope_options,
    project_includes: Array.new,
    system_includes: Array.new,
    ruby_generator: false
  }
end
