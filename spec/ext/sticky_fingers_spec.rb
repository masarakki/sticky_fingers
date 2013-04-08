# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'nkf'

describe StickyFingers, "C-extension" do
  let(:sample_zip) { File.join File.dirname(__FILE__), '/../sample/sample.zip' }
  describe :class_methods do
    describe :open_file do
      it { StickyFingers.open_file(sample_zip).should be_a StickyFingers }
    end

    describe :open do
      it "run block with StickyFingers instance" do
        StickyFingers.open(sample_zip) {|f| f.should be_a StickyFingers }
      end
    end
  end

  describe :instance_methods do
    subject { @sticky_fingers }
    before { @sticky_fingers = StickyFingers.open_file(sample_zip) }
    describe :list_files do
      it { subject.list_files.map { |x| NKF.nkf('-w', x) }.should == ['dir1/', 'dir1/test1.txt', 'dir2/', 'dir2/test1.txt', 'test1.txt', 'テスト.txt'] }
    end


  end
end
