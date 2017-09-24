require_relative "help"

require_relative "../classcreate"
require_relative "../functions"


def parse_class_function(param)
  options = generate_template_function_options

  array = param.split(":")

  options[:type] = array.first
  options[:name] = array.second

  param_array = array.slice(2..-1).join(":").split(",")

  param_array.each do |param|
    fields = param.split(":")
    options[:params].push({
      type: fields.first,
      name: fields,second,
      default: fields.third
    })
  end

  return options
end

def parse_class_variable(param)
  array = param.split(":")

  return {
    type: array.first,
    name: array.second
  }
end

def parse_class_parent(param)
  array = param.split(":")

  return {
    name: array.first,
    scope: array.second
  }
end

def class_arguments_parse(args, use_struct)
  rawname = args.first

  options = generate_template_class_options

  if rawname == nil
    puts "name must not be blank"
    puts cli_class_help
    exit(1)
  end

  options[:name] = rawname.split("::").last
  options[:namespace] = rawname.split("::").slice(0..-2)

  options[:use_struct] = use_struct

  params = args.slice(1..-1)

  current_mode = :none

  current_scope = :public

  simulate = false

  params.each_with_index do |param, index|
    # Parse the options
    case param
    when "-h", "--help"
      puts cli_class_help
      exit(0)
    when "--public"
      current_scope = :public
    when "--protected"
      current_scope = :protected
    when "--private"
      current_scope = :private
    when "-f", "--function"
      current_mode = :function
    when "-v", "--variable"
      current_mode = :variable
    when "-p", "--parents"
      current_mode = :parents
    when "--system-includes"
      current_mode = :system_includes
    when "--project-includes"
      current_mode = :project_includes
    when "--simulate"
      simulate = true
    else
      case current_mode
      when :none
        # Do nothing
      when :function
        options[current_scope][:functions].push(parse_class_function(param))
      when :variable
        options[current_scope][:fields].push(parse_class_variable(param))
      when :parents
        options[:parents].push(parse_class_parent(param))
      when :system_includes
        options[:system_includes].push(param)
      when :project_includes
        options[:project_includes].push(param)
      end
    end
  end

  if simulate
    klass = compose_class(options)

    header_filename = "// #{compose_class_base_filename(options.clone)}.#{HEADER_FILE_EXTENSION}"
    puts header_filename
    puts klass[:header]


    puts ""
    puts ""
    puts ""
    puts "// #{compose_class_base_filename(options.clone)}.#{SOURCE_FILE_EXTENSION}"
    puts klass[:source]
  else
    class_file_write(options)
  end
end
