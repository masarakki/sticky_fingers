# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'nkf'

describe StickyFingers do
  describe :class_methods do
    describe :open do
      it "run block with StickyFingers instance" do
        StickyFingers.open(sample_file('sample.zip')) { self }.should be_a StickyFingers
      end
      it { StickyFingers.open(sample_file('sample.zip')).should be_a StickyFingers }
    end
  end

  describe :instance_methods do
    subject { @sticky_fingers }
    before { @sticky_fingers = StickyFingers.open_file(sample_file('sample.zip')) }
    its(:ls) { subject.ls.map(&:name).should == %w{dir1/ dir2/ test1.txt テスト.txt} }

    describe :generate_file_mappings do
      it 'create mapping from file_list' do
        mappings = subject.send(:generate_file_mappings)
        mappings.keys.map{|x| NKF.nkf('-w', x) }.sort.should == %w{dir1/ dir2/ test1.txt テスト.txt}.sort
        mappings["dir1/"].keys.sort.should == %w{test1.txt subdir/}.sort
      end
    end
  end
end
