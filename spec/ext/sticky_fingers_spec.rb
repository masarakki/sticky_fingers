# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'nkf'

describe StickyFingers, "C-extension" do
  describe :class_methods do
    describe :open_file do
      it { StickyFingers.open_file(sample_file('sample.zip')).should be_a StickyFingers }
    end
  end

  describe :instance_methods do
    subject { @sticky_fingers }
    before { @sticky_fingers = StickyFingers.open_file(sample_file('sample.zip')) }
    describe :list_files do
      it { subject.list_files.map { |x| NKF.nkf('-w', x) }.sort.should == ['dir1/', 'dir1/test1.txt', 'dir1/subdir/', 'dir1/subdir/test1.txt', 'dir2/', 'dir2/test1.txt', 'test1.txt', 'テスト.txt'].sort }
    end
  end

  describe :sjis_file do
    subject { @sticky_fingers }
    before { @sticky_fingers = StickyFingers.open_file(sample_file('sjis.zip')) }
    its(:ls) { @sticky_fingers.ls.map(&:name).should == ['えすじす/'] }
  end
end
