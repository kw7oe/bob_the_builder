require 'minitest/autorun'
require_relative '../../lib/bob_builder/index_generator'

describe BobBuilder::IndexGenerator do

  let(:dir) { "test/fixtures/test_sources/" }
  let(:des) { "test/fixtures/test_outputs/" }
  let(:generator) do
    BobBuilder::IndexGenerator.new(dir, des)
  end

  it 'should render index correctly' do
    result = generator.render([
      "notes/another-title.md",
      "notes/this.md"
    ])
    expected_result = <<~EOF.rstrip

    ### Notes
    - [another title](notes/another-title.html)
    - [this](notes/this.html)
    EOF

    assert_equal expected_result, result
  end

  it 'should render index correctly with nested folder' do
    result = generator.render(generator.file_lists(dir))
    expected_result = <<~EOF.rstrip

    ### Notes
    - [another title](notes/another-title.html)
    - [this is title](notes/this-is-title.html)

    ### Topic one
    - [ch 2](notes/topic-one/ch-2.html)
    - [ch 1](notes/topic-one/ch-1.html)
    EOF

    assert_equal expected_result, result
  end

  it 'should render dir index correctly with nested folder' do
    files = generator.file_lists(File.join(dir, 'notes'))
    result = generator.render_dir(files, 'notes')
    expected_result = <<~EOF.rstrip

    ### Notes
    - [another title](another-title.html)
    - [this is title](this-is-title.html)
    - [Topic one](topic-one/index.html)
    EOF

    assert_equal expected_result, result
  end

  it 'should return file lists correctly' do
    result = generator.file_lists(dir)
    expected_result = ['notes/another-title.md', 'notes/this-is-title.md', 'notes/topic-one/ch-1.md', 'notes/topic-one/ch-2.md']


    assert_equal result.sort, expected_result.sort
  end

  it 'should return directory lists correctly' do
    result = generator.dir_lists
    expected_result = ['notes', 'notes/topic-one', 'notes/topic-one/nested-dir']

    assert_equal result, expected_result
  end

  it 'should get the root directory' do
    result = generator.get_root_dir('notes/apple')
    expected_result = 'apple'

    assert_equal expected_result, result
  end

  it 'should get the parent directory' do
    dirname = File.dirname('notes/apple/cat.md')
    result, size = generator.get_parent_dir(dirname)
    expected_result = 'apple'

    assert_equal expected_result, result
    assert_equal 2, size
  end

end
