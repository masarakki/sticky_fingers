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
end
