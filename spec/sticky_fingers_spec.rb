# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'nkf'

describe StickyFingers do
  let(:sample_zip) { File.join File.dirname(__FILE__), '/sample/sample.zip' }
  describe :class_methods do
    describe :open do
      it "run block with StickyFingers instance" do
        StickyFingers.open(sample_zip) {|f| f.should be_a StickyFingers }
      end
    end
  end

  describe :instance_methods do
    subject { @sticky_fingers }
    before { @sticky_fingers = StickyFingers.open_file(sample_zip) }
    its(:ls) { should == %w{dir1/ dir2/ test1.txt テスト.txt} }
  end
end
