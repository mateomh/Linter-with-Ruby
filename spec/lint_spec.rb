require './lib/lint.rb'

describe Lint do
  let(:linter) { Lint.new('./test_files/test_file.css') }
  let(:test_white1) { '    background-color: whitesmoke ' }
  let(:test_white2) { '    margin: 0px;' }
  
  it 'Checks the trailing white linter - FINDS AN ERROR' do
    linter.curr_text = test_white1
    linter.curr_line = 4
    expect(linter.trailing_white_linter.is_a?(File)).to eql(true)
  end

  it 'Checks the trailing white linter - NO ERROR' do
    linter.curr_text = test_white2
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
end
