require 'spec_helper'

describe StickyFingers::Dir do
  subject { @dir }
  before do
    @dir = StickyFingers::Dir.new(:sticky_fingers, 'foo/bar/')
  end

  its(:name) { should == 'foo/bar/' }
  its(:dir?) { should be_true }
  its(:file?) { should be_false }
end
