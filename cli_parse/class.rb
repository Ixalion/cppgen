require_relative "help"

require_relative "../classcreate"


def class_arguments_parse(args, use_struct)
  rawname = args.first

  if rawname == nil
    puts "name must not be blank"
    puts cli_class_help
    exit(1)
  end
end
