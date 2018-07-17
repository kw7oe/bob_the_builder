require 'minitest/autorun'
require_relative '../../lib/bob_builder/index_generator'

describe BobBuilder::IndexGenerator do

  let(:dir) { "test/fixtures/test_sources/" }
  let(:des) { "test/fixtures/test_outputs/" }
  let(:generator) do
    BobBuilder::IndexGenerator.new(dir, des)
  end

  it 'should return main index' do
    result = generator.content_for_index_file(dir)
    expected_result = <<~EOF.rstrip
    ### Test sources
    - [Notes](notes/index.html)
    - [Test](test.html)
    EOF

    assert_equal expected_result, result
  end

  it 'should render the index file correctly' do
    result = generator.content_for_index_file(dir + 'notes')
    expected_result = <<~EOF.rstrip
    ### Notes
    - [Topic one](topic-one/index.html)
    - [Another title](another-title.html)
    - [This is title](this-is-title.html)
    EOF

    assert_equal expected_result, result
  end


  it 'should return file lists correctly' do
    result = generator.file_lists(dir)
    expected_result = ['notes/another-title.md', 'notes/this-is-title.md', 'notes/topic-one/ch-1.md', 'notes/topic-one/ch-2.md', 'test.md']


    assert_equal result.sort, expected_result.sort
  end

  it 'should return directory lists correctly' do
    result = generator.dir_lists
    expected_result = ['notes', 'notes/topic-one', 'notes/topic-one/nested-dir']

    assert_equal result, expected_result
  end

  it 'should return current directory file lists correctly' do
    result = generator.current_dir_files(dir)
    expected_result = ['test.md']

    assert_equal expected_result, result
  end

  it 'should return current directory directory lists correctly' do
    result = generator.current_dir_directories(dir)
    expected_result = ['notes']

    assert_equal expected_result, result
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
