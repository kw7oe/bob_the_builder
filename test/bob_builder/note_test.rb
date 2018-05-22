require 'minitest/autorun'
require_relative '../../lib/bob_builder/note'

describe BobBuilder::Note do

  let(:note) do
    file = "sample/notes/2017-05-02-this-is-title.md"
    BobBuilder::Note.new(file, "sample", "output")
  end

  it 'must extract base file name' do
    assert_equal note.file_name, "2017-05-02-this-is-title.md"
  end

  it 'must have output file name' do
    assert_equal note.output_file_name, "output/notes/2017-05-02-this-is-title.html"
  end

end
