# -*- coding: utf-8 -*-
require 'spec_helper'

describe StickyFingers::File do
  let(:sticky_fingers) { StickyFingers.open(sample_file('sample.zip')) }
  subject { @file }
  before { @file = sticky_fingers.ls.last }

  its(:file?) { should be_true }
  its(:name) { should == 'テスト.txt' }

  describe :content do
    context :utf8 do
      before { @file = StickyFingers::File.new(sticky_fingers, 'utf8.txt') }
      its(:content) { should == "てすと\n" }
    end

    context :sjis do
      before { @file = StickyFingers::File.new(sticky_fingers, 'sjis.txt') }
      describe :content do
        it "encoded to utf8" do
          @file.content.should == "てすと\n"
        end
      end
    end

    context :binary do
      before { @file = StickyFingers::File.new(sticky_fingers, 'ruby.png') }
      describe :content do
        it 'same binary' do
          @file.content.should == File.binread(sample_file('src/ruby.png'))
        end
      end
      describe :cp do
        it 'file should copyied' do
          filename = sample_file('ruby.png')
          @file.cp filename
          File.exists?(filename).should be_true
          copied = File.binread(filename)
          src = File.binread(sample_file('src/ruby.png'))
          copied.should == src
          File.unlink(filename)
        end
      end
    end
  end
end
