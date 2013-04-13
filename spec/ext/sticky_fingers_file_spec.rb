require 'spec_helper'

describe StickyFingers::File, "C-extension" do
  let(:archive) { StickyFingers.open_file(sample_file('sample.zip')) }
  before { @file = StickyFingers::File.new(archive, 'test1.txt') }
  subject { @file }

  describe :open do
    context :can_not_open do
      it 'raise error' do
        lambda {
          StickyFingers::File.new(archive, 'unko').open
        }.should raise_error(StickyFingers::Error, 'Error: No such file')
      end
    end
  end

  describe :close do
    context :opened do
      before { @file.open }
      its(:close) { should be_true}
    end

    its(:close) { should be_true }
  end
end
