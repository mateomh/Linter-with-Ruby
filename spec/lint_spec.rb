require './lib/lint.rb'

describe Lint do
  let(:linter) { Lint.new('./test_files/test_file.css') }

  it 'Checks the trailing white linter - FINDS AN ERROR' do
    linter.curr_text = '    background-color: whitesmoke '
    linter.curr_line = 4
    expect(linter.trailing_white_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the trailing white linter - NO ERROR' do
    linter.curr_text = '    margin: 0px;'
    linter.curr_line = 4
    expect(linter.trailing_white_linter).to eql(nil)
  end

  let(:test_empty1) { '   ' }
  let(:test_empty2) { '    ;' }
  it 'Checks the empty line linter outside block - FINDS AN ERROR' do
    linter.curr_text = test_empty1
    linter.curr_line = 4
    linter.unset_inside_block
    linter.empty_count = 2
    expect(linter.empty_line_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the empty line linter outside block - NO ERROR' do
    linter.curr_text = test_empty1
    linter.curr_line = 4
    linter.unset_inside_block
    linter.empty_count = 1
    expect(linter.empty_line_linter).to eql(nil)
  end

  it 'Checks the empty line linter inside block - FINDS AN ERROR' do
    linter.curr_text = test_empty1
    linter.curr_line = 4
    linter.set_inside_block
    linter.empty_count = 1
    expect(linter.empty_line_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the empty line linter inside block - NO ERROR' do
    linter.curr_text = test_empty2
    linter.curr_line = 4
    linter.set_inside_block
    linter.empty_count = 0
    expect(linter.empty_line_linter).to eql(nil)
  end

  let(:test_colon1) { '    position:fixed;' }
  let(:test_colon2) { 'background-color: white;' }
  it 'Checks the colon space linter - FINDS ERROR' do
    linter.curr_text = test_colon1
    linter.curr_line = 4
    expect(linter.property_space_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the colon space linter - NO ERROR' do
    linter.curr_text = test_colon2
    linter.curr_line = 4
    expect(linter.property_space_linter).to eql(nil)
  end

  let(:test_color1) { 'color: #3344A8;' }
  let(:test_color2) { 'color: #3344a8;' }
  it 'Checks the color linter - FINDS ERROR' do
    linter.curr_text = test_color1
    linter.curr_line = 4
    expect(linter.colors_lowercase_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the color linter - NO ERROR' do
    linter.curr_text = test_color2
    linter.curr_line = 4
    expect(linter.colors_lowercase_linter).to eql(nil)
  end

  let(:test_semicol1) { 'background-color: whitesmoke ' }
  let(:test_semicol2) { 'max-width: 10vmin;' }
  it 'Checks the semicolon linter - FINDS ERROR' do
    linter.curr_text = test_semicol1
    linter.curr_line = 4
    expect(linter.no_semicolon_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the semicolon linter - NO ERROR' do
    linter.curr_text = test_semicol2
    linter.curr_line = 4
    expect(linter.no_semicolon_linter).to eql(nil)
  end

  let(:test_comment1) { '/*================= NAVBAR SECTION =================*/' }
  let(:test_comment2) { '/* ================= CONTENT SECTION ================ */' }
  it 'Checks the comment linter - FINDS ERROR' do
    linter.curr_text = test_comment1
    linter.curr_line = 4
    expect(linter.comment_start_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the comment linter - NO ERROR' do
    linter.curr_text = test_comment2
    linter.curr_line = 4
    expect(linter.comment_start_linter).to eql(nil)
  end

  let(:test_bracket1) { '#content{' }
  let(:test_bracket2) { 'input#search {' }
  it 'Checks the declaration bracket linter - FINDS ERROR' do
    linter.curr_text = test_bracket1
    linter.curr_line = 4
    expect(linter.declaration_space_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the declaration bracket linter - NO ERROR' do
    linter.curr_text = test_bracket2
    linter.curr_line = 4
    expect(linter.declaration_space_linter).to eql(nil)
  end

  it 'Checks the line type method TYPE 1: Comment line' do
    linter.curr_text = test_comment1
    linter.curr_line = 4
    expect(linter.type_of_line).to eql('comment')
  end

  it 'Checks the line type method TYPE 2: Beginning of block line' do
    linter.curr_text = test_bracket1
    linter.curr_line = 4
    expect(linter.type_of_line).to eql('block start')
  end

  it 'Checks the line type method TYPE 3: End of block line' do
    linter.curr_text = '}'
    linter.curr_line = 4
    expect(linter.type_of_line).to eql('block end')
  end

  it 'Checks the line type method TYPE 4: Empty line - CASE 1' do
    linter.curr_text = ''
    linter.curr_line = 4
    expect(linter.type_of_line).to eql('empty line')
  end

  it 'Checks the line type method TYPE 4: Empty line - CASE 2' do
    linter.curr_text = '    '
    linter.curr_line = 4
    expect(linter.type_of_line).to eql('empty line')
  end

  it 'Checks the line type method TYPE 5: Regular line' do
    linter.curr_text = ';'
    linter.curr_line = 4
    expect(linter.type_of_line).to eql('regular')
  end
end
