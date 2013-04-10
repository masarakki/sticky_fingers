# -*- coding: utf-8 -*-
require 'spec_helper'

describe StickyFingers::File do
  let(:sample_zip) { File.expand_path('../sample/sample.zip', File.dirname(__FILE__)) }
  subject { @file }
  before do
    sticky_fingers = StickyFingers.open(sample_zip)
    @file = sticky_fingers.ls.last
  end
  its(:file?) { should be_true }
  its(:name) { should == 'テスト.txt' }
end
