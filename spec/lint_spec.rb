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

  it 'Checks the empty line linter outside block - FINDS AN ERROR' do
    linter.curr_text = '   '
    linter.curr_line = 4
    linter.unset_inside_block
    linter.empty_count = 2
    expect(linter.empty_line_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the empty line linter outside block - NO ERROR' do
    linter.curr_text = '   '
    linter.curr_line = 4
    linter.unset_inside_block
    linter.empty_count = 1
    expect(linter.empty_line_linter).to eql(nil)
  end

  it 'Checks the empty line linter inside block - FINDS AN ERROR' do
    linter.curr_text = '   '
    linter.curr_line = 4
    linter.set_inside_block
    linter.empty_count = 1
    expect(linter.empty_line_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the empty line linter inside block - NO ERROR' do
    linter.curr_text = '    ;'
    linter.curr_line = 4
    linter.set_inside_block
    linter.empty_count = 0
    expect(linter.empty_line_linter).to eql(nil)
  end

  it 'Checks the colon space linter - FINDS ERROR' do
    linter.curr_text = '    position:fixed;'
    linter.curr_line = 4
    expect(linter.property_space_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the colon space linter - NO ERROR' do
    linter.curr_text = 'background-color: white;'
    linter.curr_line = 4
    expect(linter.property_space_linter).to eql(nil)
  end

  it 'Checks the color linter - FINDS ERROR' do
    linter.curr_text = 'color: #3344A8;'
    linter.curr_line = 4
    expect(linter.colors_lowercase_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the color linter - NO ERROR' do
    linter.curr_text = 'color: #3344a8;'
    linter.curr_line = 4
    expect(linter.colors_lowercase_linter).to eql(nil)
  end

  it 'Checks the semicolon linter - FINDS ERROR' do
    linter.curr_text = 'background-color: whitesmoke '
    linter.curr_line = 4
    expect(linter.no_semicolon_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the semicolon linter - NO ERROR' do
    linter.curr_text = 'max-width: 10vmin;'
    linter.curr_line = 4
    expect(linter.no_semicolon_linter).to eql(nil)
  end

  it 'Checks the comment start linter - FINDS ERROR' do
    linter.curr_text = '/*================= NAVBAR SECTION =================*/'
    linter.curr_line = 4
    expect(linter.comment_start_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the comment start linter - NO ERROR' do
    linter.curr_text = '/* ================= CONTENT SECTION ================ */'
    linter.curr_line = 4
    expect(linter.comment_start_linter).to eql(nil)
  end

  it 'Checks the comment end linter - FINDS ERROR' do
    linter.curr_text = '/*================= NAVBAR SECTION =================*/'
    linter.curr_line = 4
    expect(linter.comment_end_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the comment end linter - NO ERROR' do
    linter.curr_text = '/* ================= CONTENT SECTION ================ */'
    linter.curr_line = 4
    expect(linter.comment_end_linter).to eql(nil)
  end

  it 'Checks the declaration bracket linter - FINDS ERROR' do
    linter.curr_text = '#content{'
    linter.curr_line = 4
    expect(linter.declaration_space_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the declaration bracket linter - NO ERROR' do
    linter.curr_text = 'input#search {'
    linter.curr_line = 4
    expect(linter.declaration_space_linter).to eql(nil)
  end

  it 'Checks closing block space linter - FINDS ERROR' do
    linter.curr_text = '   }'
    linter.curr_line = 4
    expect(linter.block_end_space_linter.is_a?(File)).to eql(true)
  end

  it 'Checks closing block space linter - NO ERROR' do
    linter.curr_text = '}'
    linter.curr_line = 4
    expect(linter.block_end_space_linter).to eql(nil)
  end

  it 'Checks closing block space linter - NO ERROR' do
    linter.curr_text = '} '
    linter.curr_line = 4
    expect(linter.block_end_space_linter).to eql(nil)
  end

  it 'Checks the line type method TYPE 1: Comment line' do
    linter.curr_text = '/*================= NAVBAR SECTION =================*/'
    linter.curr_line = 4
    expect(linter.type_of_line).to eql('comment')
  end

  it 'Checks the line type method TYPE 2: Beginning of block line' do
    linter.curr_text = '#content{'
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
