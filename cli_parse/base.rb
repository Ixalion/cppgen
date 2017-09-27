require_relative "help"

require_relative "class"
require_relative "file"

def cli_parse(args)
  case args.first
  when "struct"
    class_arguments_parse(args.slice(1..-1), true)
  when "class", "c"
    class_arguments_parse(args.slice(1..-1), false)
  when "file", "f"
    file_arguments_parse(args.slice(1..-1))
  when "help"
    help_arguments_parse(args.slice(1..-1))
  when "-h", "--help"
    puts cli_help
  else
    puts cli_help
  end
end
