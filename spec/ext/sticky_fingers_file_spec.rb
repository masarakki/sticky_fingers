# -*- coding: utf-8 -*-
require 'spec_helper'

describe StickyFingers::File, "C-extension" do
  let(:archive) { StickyFingers.open_file(sample_file('sample.zip')) }
  before { @file = StickyFingers::File.new(archive, 'test1.txt') }
  subject { @file }

  describe :open do
    context :can_not_open do
      it do
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

  describe :read do
    context :not_opened do
      it do
        lambda {
          @file.read
        }.should raise_error(StickyFingers::Error, 'File not opened')
      end
    end

    context :opened do
      before { @file.open }
      after { @file.close }
      its(:read) { should eq "test\n" }
    end

    describe :sjis_file do
      before do
        @file = StickyFingers::File.new(archive, 'テスト.txt')
        @file.open
      end
      after { @file.close }
      it {
        NKF.nkf('-w', subject.read).should eq File.read(sample_file('src/テスト.txt'))
      }
    end
  end
end
