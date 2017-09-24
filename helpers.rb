class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

HEADER_FILE_EXTENSION = "hpp"
SOURCE_FILE_EXTENSION = "cpp"

HEADER_FILE_DIRECTORY = "include"
SOURCE_FILE_DIRECTORY = "src"
