require_relative "help"

require_relative "../generator/filecreate"

require "pathname"


def file_arguments_parse(args)
  rawname = args.first

  options = generate_template_file_options

  if rawname == nil
    puts "filename must not be blank"
    puts cli_file_help
    exit(1)
  elsif ["-h", "--help"].include? rawname
    puts cli_file_help
    exit(0)
  end

  options[:filename] = Pathname(rawname).each_filename.to_a.last
  tempdir = File.join(Pathname(rawname).each_filename.to_a.slice(0..-2))
  options[:directory] = tempdir if tempdir && tempdir.length > 0

  params = args.slice(1..-1)

  simulate = false

  params.each_with_index do |param, index|
    # Parse the options
    case param
    when "-h", "--help"
      puts cli_file_help
      exit(0)
    when "-f", "--function"
      options[:fileguard] = true
    when "--ruby-gen"
      options[:ruby_generator] = true
    when "--simulate"
      simulate = true
    else
      puts "Unexpected param ##{index} '#{param}'"
    end
  end

  if simulate
    puts "// #{File.join(options[:directory],options[:filename])}"
    puts compose_file(options)

  else
    file_write(options)
  end
end
