#!/usr/bin/env ruby

unless ARGV.size == 1
  raise ArgumentError, "wrong arguments"
  exit(1)
end

passenger_conf_path = ARGV[0].chomp


PASSENGER_VERSION = (`passenger --version | grep -e '[0-9].*' | awk '{print $4}' `).chomp
PASSENGER_ROOT = "#{ ENV['GEM_HOME'] }/gems/passenger-#{ PASSENGER_VERSION }"
PASSENGER_RUBY = "#{ ENV['rvm_path'] }/wrappers/#{ ENV['RUBY_VERSION'] }/ruby"


buf = []

File.open(passenger_conf_path) do |f|
  f.each_line do |line|
    if line.match('{_PASSENGER_ROOT_}')
      line = line.gsub('{_PASSENGER_ROOT_}', PASSENGER_ROOT)
    elsif line.match('{_PASSENGER_RUBY_}')
      line = line.gsub('{_PASSENGER_RUBY_}', PASSENGER_RUBY)
    end
    buf << line
  end
end

File.open(passenger_conf_path, "w") do |f|
  f.write(buf.join)
end


