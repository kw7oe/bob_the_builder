#! /usr/bin/ruby
require_relative 'bob_builder/note'
require_relative 'bob_builder/index_generator'

BobBuilder::IndexGenerator.new(ARGV[0], ARGV[1]).create_index_file
