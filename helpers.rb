class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  def indent!(amount, indent_string=nil, indent_empty_lines=false)
    indent_string = indent_string || self[/^[ \t]/] || ' '
    re = indent_empty_lines ? /^/ : /^(?!$)/
    gsub!(re, indent_string * amount)
  end
  
  def indent(amount, indent_string=nil, indent_empty_lines=false)
    dup.tap {|_| _.indent!(amount, indent_string, indent_empty_lines)}
  end
end

HEADER_FILE_EXTENSION = "hpp"
SOURCE_FILE_EXTENSION = "cpp"

HEADER_FILE_DIRECTORY = "include"
SOURCE_FILE_DIRECTORY = "src"
