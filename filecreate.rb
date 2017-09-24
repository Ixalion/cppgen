require "date"
require 'fileutils'


# Structure:
# options = {
#   filename: *String, # e.g. MyFile.cpp
#   date: Date, # e.g. Date.today, defaults to Date.today
#   author: String, # e.g. username, defaults to: `whoami`
#   user: String, # e.g. FirstName LastName, defaults to: `id -F`
# }
def license_header(options={})
  raise "license_header filename must be present" unless options[:filename]

  options[:date] ||= Date.today
  options[:author] ||= `whoami`
  options[:user] ||= `id -F`
<<-EOF
/*
 * #{options[:filename]}
 *
 *  Created on: #{options[:date].strftime("%b %e, %Y")}
 *      Author: #{options[:author]}
 *
 * Copyright (C) #{options[:date].year} #{options[:user]}
 * ALL RIGHTS RESERVED
 * THE CONTENTS OF THIS FILE ARE CONFIDENTIAL
 * DO NOT DISTRIBUTE
 */
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
# options = {
#   filename: *String, # e.g. MyFile.cpp,
#   directory: String, # e.g. Dir.pwd, defaults to: Dir.pwd
#   license_header: Hash, # Passed into license_header
#   header: String, # Contents at the top of the file.
#   body: String, # Contents within the file.
#   footer: String, # Conents at the end of the file.
#   fileguard: Boolean, # defaults to: nil,
#   line_ending: String, # e.g. '\n', defaults to: '\n'
# }
def file_compose(options={})
  raise "file_compose filename must be present" unless options[:filename]

  options[:directory] ||= Dir.pwd
  options[:license_header] ||= Hash.new
  options[:line_ending] ||= '\n'

  fileguard_data = Hash.new
  if options[:fileguard]
    fileguard_data = fileguard_generate(options)
  end

  lines = Array.new

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

  return <<-EOF
#{lines.join(options[:line_ending])}
EOF
end

# Structure:
# See file_compose
#
# This function just wraps around file_compose
def file_write(options={})
  raise "file_write filename must be present" unless options[:filename]

  options[:directory] ||= Dir.pwd

  filepath = File.join(options[:directory], options[:filename])

  unless File.directory?(options[:directory])
    FileUtils.mkdir_p(options[:directory])
  end

  File.open(filepath, 'w') { |file| file.write(file_compose(options)) }
end
