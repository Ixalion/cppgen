def cli_help
<<-EOF
cppgen <subcommand> [options]

Subcommands
c   class                   Generates a class.
    struct                  Generates a struct.

h   help                    Prints the help page for the specied module.
                            cppgen help <module_name>
EOF
end

def cli_class_help
<<-EOF
cppgen <class|struct> <[namespaces::]name> [options]

Options
-p  --parents               Sets the parents for the the class
                            <parent1:[scope]> [parent2:[scope]...]

    --public                Sets all further parameters to be public
                            This is the default scope.
    --protected             Sets all further parameters to be protected
    --private               Sets all further parameters to be private

-f  --function              Creates a member function with the current scope
                            <type:name[:param_type1:param_name1[,params...]]
                            Multiple functions can be specified

-v  --variable              Creates a member variable with the current scope
                            <type:name> [type2:name2...]

    --system-includes       Sets the system includes for the class
                            <file1> [file2...]

    --project-includes      Sets the system includes for the class
                            <file1> [file2...]

    --simulate              Does not create any files, will just print
                            everything to the console

-h  --help                  Print this help screen
                            Must be the first and only parameter
EOF
end

def cli_help_help
<<-EOF
cppgen help <module_name>
EOF
end


def help_arguments_parse(args)
  case args.first
  when "class"
    puts cli_class_help
  when "struct"
    puts cli_class_help
  when "help"
    puts cli_help_help
  when "-h"
    puts cli_help_help
  when "--help"
    puts cli_help_help
  when nil
    puts cli_help
  end
end
