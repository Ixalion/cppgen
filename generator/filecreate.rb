require "date"
require 'fileutils'

# Structure:
# options = {
#   filename: *String, # e.g. MyFile.cpp
#   date: Date, # e.g. Date.today, defaults to Date.today
#   author: String, # e.g. username, defaults to: `whoami`
#   user: String, # e.g. FirstName LastName, defaults to: 'Christopher Britt'
#   ruby_generator: Boolean # defaults to: false
# }
def validate_license_header(options={})
  raise "validate_license_header filename must be present" unless options[:filename]

  options[:date] ||= Date.today
  options[:author] ||= `whoami`
  options[:user] ||= 'Christopher Britt'

  options[:ruby_generator] ||= false

  return options
end

def license_header(options={})
  options = validate_license_header(options.clone)

  timestamp = options[:ruby_generator] ? <<-EOF
 *  Rgen created on: #{options[:date].strftime("%b %e, %Y")}
 *  Generated on: \#{Date.today.strftime(\"%b %e, %Y\")}"
EOF
  : " *  Created on: #{options[:date].strftime("%b %e, %Y")}"

<<-EOF
/*
 * #{options[:filename]}
 *
#{timestamp.rstrip}
 *      Author: #{options[:author].strip}
 *
 * Copyright (C) #{options[:date].year} #{options[:user]}
 * ALL RIGHTS RESERVED
 * THE CONTENTS OF THIS FILE ARE CONFIDENTIAL
 * DO NOT DISTRIBUTE
**/
EOF
end

def ruby_generator_license_header(options={})
  options = validate_license_header(options.clone)

<<-EOF
# #{options[:filename]}.rgen
#
#  Created on: #{options[:date].strftime("%b %e, %Y")}
#      Author: #{options[:author].strip}
#
# Copyright (C) #{options[:date].year} #{options[:user]}
# ALL RIGHTS RESERVED
# THE CONTENTS OF THIS FILE ARE CONFIDENTIAL
# DO NOT DISTRIBUTE
EOF
end
# Structure:
# options = {
#   filename: *String, # e.g. MyFile.cpp,
#   directory: *String # e.g. Dir.pwd
# }
# return = {
#   header: String, # The header for the guard
#   footer: String # The footer for the guard
# }
def fileguard_generate(options={})
  raise "fileguard_generate filename must be present" unless options[:filename]
  raise "fileguard_generate directory must be present" unless options[:directory]

  guard_block = options[:directory]
    .split(/[\/\\]/)
    .select{|e| !e.nil? && e.length > 0}
    .concat(options[:filename]
      .split("."))
    .map(&:upcase)
    .join("_") + "_"

  header = <<-EOF
#ifndef #{guard_block}
#define #{guard_block}
EOF

  footer = <<-EOF
#endif /* #{guard_block} */
EOF

  return {
    header: header,
    footer: footer
  }
end

# Structure:
# options = Hash, # See validate_compose_file
# return = {
#   header: String, # The start of the file for ruby generator
#   footer: String # The end of the file for ruby generator
# }
def ruby_generator_generate(options={})
  header = <<-RUBY_GENERATOR_BLOCK
file = <<-RUBY_GENERATOR_EOF
RUBY_GENERATOR_BLOCK

  footer = <<-RUBY_GENERATOR_BLOCK
RUBY_GENERATOR_EOF

open("\#{File.join(File.dirname(__FILE__),File.basename(__FILE__,".rgen"))}","w"){|f| f.write(file)}
RUBY_GENERATOR_BLOCK

  return {
    header: header,
    footer: footer
  }
end

# Structure:
# options = {
#   filename: *String, # e.g. MyFile.cpp,
#   directory: String, # e.g. Dir.pwd, defaults to: Dir.pwd
#   license_header: Hash, # Passed into license_header
#   header: String, # Contents at the top of the file.
#   body: String, # Contents within the file.
#   footer: String, # Conents at the end of the file.
#   fileguard: Boolean, # defaults to: nil,
#   line_ending: String, # e.g. '\n', defaults to: '\n'
#   ruby_generator: Boolean # defaults to: false
# }
#
# If license_header -> filename is not set, then it will be set to the value
# within options[:filename]
def validate_compose_file(options={})
  raise "validate_compose_file filename must be present" unless options[:filename]

  options[:directory] ||= Dir.pwd
  options[:license_header] ||= Hash.new
  options[:line_ending] ||= "\n"

  options[:license_header][:filename] ||= options[:filename]
  options[:license_header][:ruby_generator] ||= options[:ruby_generator]

  return options
end

# Structure:
# See validate_compose_file
def compose_file(options={})
  options = validate_compose_file(options.clone)

  fileguard_data = Hash.new
  if options[:fileguard]
    fileguard_data = fileguard_generate(options.clone)
  end

  ruby_generator_data = Hash.new
  if options[:ruby_generator]
    ruby_generator_data = ruby_generator_generate(options.clone)
  end

  lines = Array.new
  if ruby_generator_data[:header]
    lines.push(ruby_generator_data[:header])
  end

  lines.push(license_header(options[:license_header]))

  if fileguard_data[:header]
    lines.push("")
    lines.push(fileguard_data[:header])
  end

  if options[:header]
    lines.push("")
    lines.push(options[:header])
  end

  if options[:body]
    lines.push("")
    lines.push(options[:body])
  end

  if options[:footer]
    lines.push("")
    lines.push(options[:footer])
  end

  if fileguard_data[:footer]
    lines.push("")
    lines.push(fileguard_data[:footer])
  end

  if ruby_generator_data[:footer]
    lines.push(ruby_generator_data[:footer])
  end

  return <<-EOF
#{lines.map(&:rstrip).join(options[:line_ending])}
EOF
end

# Structure:
# See validate_compose_file
#
# This function just wraps around compose_file
def file_write(options={})
  options = validate_compose_file(options.clone)

  filepath = File.join(options[:directory], options[:filename])

  if options[:ruby_generator]
    filepath = File.join(File.dirname(filepath), File.basename(filepath, ".rgen") + ".rgen")
  end

  unless File.directory?(options[:directory])
    FileUtils.mkdir_p(options[:directory])
  end

  File.open(filepath, 'w') { |file| file.write(compose_file(options.clone)) }
end

def generate_template_file_options
  return {
    filename: nil,
    directory: Dir.pwd,
    license_header: Hash.new,
    header: nil,
    body: nil,
    footer: nil,
    fileguard: nil,
    line_ending: "\n",
    ruby_generator: false
  }
end
