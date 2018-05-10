require 'pdf-reader'
require 'json'
require_relative './parsers/walk_in_lab'
require_relative './parsers/kaiser'

WALK_IN_LAB_DIR = '/data/walk_in_lab'
files = Dir.entries(File.dirname(__FILE__)+WALK_IN_LAB_DIR)
results_list = []
files.each do |file|
  next unless file.end_with?('pdf')
  p file
  results_list.concat(Parser::WalkInLab.parse(File.dirname(__FILE__)+WALK_IN_LAB_DIR+'/'+file))
end

KAISER_DIR = '/data/kaiser'
files = Dir.entries(File.dirname(__FILE__)+KAISER_DIR)
results_list = []
files.each do |file|
  next unless file.end_with?('pdf')
  results_list.concat(Parser::Kaiser.parse(File.dirname(__FILE__)+KAISER_DIR+'/'+file))
end

outfile = File.new("./output/json/results.json", File::CREAT|File::TRUNC|File::RDWR, 0777)
output = JSON.pretty_generate(results_list)
output.delete! '\\'
output.gsub!("\"{","{")
output.gsub!("}\"","}")
outfile << output