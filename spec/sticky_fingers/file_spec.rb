# -*- coding: utf-8 -*-
require 'spec_helper'

describe StickyFingers::File do
  subject { @file }
  before do
    sticky_fingers = StickyFingers.open(sample_file('sample.zip'))
    @file = sticky_fingers.ls.last
  end
  its(:file?) { should be_true }
  its(:name) { should == 'テスト.txt' }

  context :fuckin_sjis_file do
    before do
      sticky_fingers = StickyFingers.open(sample_file('sjis.zip'))
      @file = StickyFingers::File.new(sticky_fingers, sticky_fingers.list_files.first)
    end

    its(:encoded_content) { should == 'てすとてすと' }
    describe :cp do
      it "copy file with fix encoding" do
        filename = sample_file('hoge.txt')
        @file.cp filename
        File.exists?(filename).should be_true
        File.read(filename).should == "てすとてすと"
        File.unlink(filename)
      end
    end
  end
end
