#! /usr/bin/ruby
require_relative 'bob_builder/note'

BobBuilder::Note.new(ARGV[0], ARGV[1], ARGV[2]).render()
