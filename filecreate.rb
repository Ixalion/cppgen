require "date"

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
**/
EOF
end

# Structure:

def fileguard_generate(options={})
<<-EOF

EOF
end

# Structure:
# options = {
#   filename: *String, # e.g. MyFile.cpp,
#   directory: String, # e.g. Dir.pwd, defaults to: Dir.pwd
#   license_header: Hash, # Passed into license_header
#   header: String, # Contents at the top of the file.
#   body: String, # Contents within the file.
#   footer: String, # Conents at the end of the file.
#   fileguard: Boolean, # defaults to: false
# }
def file_compose(options={})
  options[:directory] = Dir.pwd
<<-EOF
#{license_header(options[:license_header])}

#{options[:header]}

#{options[:body]}

#{options[:footer]}

EOF
end

# Structure:
# See file_compose
def file_write(options={})
