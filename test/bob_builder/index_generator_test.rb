require 'minitest/autorun'
require_relative '../../lib/bob_builder/index_generator'

describe BobBuilder::IndexGenerator do

  let(:generator) do
    BobBuilder::IndexGenerator.new("test/fixtures/test_sources/")
  end

  it 'should render index correctly' do
    result = generator.render([
      "notes/another-title.md",
      "notes/this.md"
    ])
    expected_result = <<~EOF.strip
    ### Notes
    - [another title](notes/another-title.html)
    - [this](notes/this.html)
    EOF

    assert_equal expected_result, result
  end

  it 'should render index correctly with nested folder' do
    result = generator.render(generator.file_lists)
    expected_result = <<~EOF.strip
    ### Notes
    - [another title](notes/another-title.html)
    - [this is title](notes/this-is-title.html)
    ### Topic one
    - [ch 2](notes/topic-one/ch-2.html)
    - [ch 1](notes/topic-one/ch-1.html)
    EOF

    assert_equal expected_result, result
  end

  it 'should return file lists correctly' do
    result = generator.file_lists
    expected_result = ['notes/another-title.md', 'notes/this-is-title.md', 'notes/topic-one/ch-1.md', 'notes/topic-one/ch-2.md']


    assert_equal result.sort, expected_result.sort
  end

end
