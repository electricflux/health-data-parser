require 'pdf-reader'
require 'json'
require_relative './parsers/walk_in_lab'

WALK_IN_LAB_DIR = '/data/walk_in_lab'
files = Dir.entries(File.dirname(__FILE__)+WALK_IN_LAB_DIR)
results_list = []
files.each do |file|
  next unless file.end_with?('pdf')
  p file
  results_list.concat(Parser::WalkInLab.parse(File.dirname(__FILE__)+WALK_IN_LAB_DIR+'/'+file))
end

puts JSON.pretty_generate(results_list)