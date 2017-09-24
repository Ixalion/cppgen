require_relative "help"

require_relative "class"

def cli_parse(args)
  case args.first
  when "struct"
    class_arguments_parse(args.slice(1..-1), true)
  when "class"
    class_arguments_parse(args.slice(1..-1), false)
  when "help"
    help_arguments_parse(args.slice(1..-1))
  when "-h"
    puts cli_help
  when "--help"
    puts cli_help
  else
    puts cli_help
  end
end
