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
    its(:ls) { subject.ls.map(&:name).sort.should == %w{dir1/ dir2/ test1.txt テスト.txt ruby.png sjis.txt utf8.txt}.sort }

    describe :cd do
      context :block_given?, true do
        it "into directory" do
          files = @sticky_fingers.cd('dir1') do
            cd "subdir" do
              ls
            end
          end
          files.map(&:name).should == ['dir1/subdir/test1.txt']
        end
      end

      context :block_given?, false do
        it { true.should be_true }
      end
    end

    describe :generate_file_mappings do
      it 'create mapping from file_list' do
        mappings = subject.send(:generate_file_mappings)
        mappings.keys.map{|x| NKF.nkf('-w', x) }.sort.should == %w{dir1/ dir2/ test1.txt テスト.txt ruby.png sjis.txt utf8.txt}.sort
        mappings["dir1/"].keys.sort.should == %w{test1.txt subdir/}.sort
      end
    end

    describe :unzip do
      it 'unzip' do
        subject.unzip sample_file('unzip'), quiet: true
        File.exists?(sample_file('unzip')).should be_true
        File.read(sample_file('unzip/sjis.txt')).should == "てすと\n"
        FileUtils.rm_r sample_file('unzip')
      end
    end
  end
end
