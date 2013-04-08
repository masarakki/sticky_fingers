require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe StickyFingers do
  let(:sample_zip) { File.join File.dirname(__FILE__), 'sample/sample.zip' }
  describe :open_file do
    it { StickyFingers.open_file(sample_zip).should be_a StickyFingers }
  end
end
