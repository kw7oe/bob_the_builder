require 'minitest/autorun'
require_relative '../../lib/bob_builder/index_generator'

describe BobBuilder::IndexGenerator do

  let(:generator) do
    BobBuilder::IndexGenerator.new("test/fixtures/sources/")
  end

  it 'should render index correctly' do
  end

  it 'should return file lists correctly' do
    result = generator.file_lists
    expected_file_lists = ['notes/another-title.md', 'notes/this-is-title.md', 'notes/topic_one/ch-1.md', 'notes/topic_one/ch-2.md']


    assert_equal result.sort, expected_file_lists.sort
  end

end
