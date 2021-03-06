require_relative '../spec_helper'

describe Ritual::VersionFile do
  describe "when the version file does not exist" do
    before do
      @version_file = Ritual::VersionFile.new("#{TMP}/version.rb", 'MyGem')
    end

    describe "#value" do
      it "should return [0, 0, 0]" do
        @version_file.value.should == [0, 0, 0]
      end
    end

    describe "#to_s" do
      it "should return '0.0.0'" do
        @version_file.to_s.should == '0.0.0'
      end
    end

    describe "#increment" do
      it "should increment the first component if the given component is 0" do
        @version_file.increment(0)
        @version_file.value.should == [1, 0, 0]
      end

      it "should increment the second component if the given component is 1" do
        @version_file.increment(1)
        @version_file.value.should == [0, 1, 0]
      end

      it "should increment the third component if the given component is 2" do
        @version_file.increment(2)
        @version_file.value.should == [0, 0, 1]
      end
    end

    describe "#write" do
      it "should create the version file with the current version if it does not yet exist" do
        @version_file.increment(2)
        @version_file.write
        File.read("#{TMP}/version.rb").should == <<-EOS.gsub(/^ *\|/, '')
          |module MyGem
          |  VERSION = [0, 0, 1]
          |
          |  class << VERSION
          |    include Comparable
          |
          |    def to_s
          |      join('.')
          |    end
          |  end
          |end
        EOS
      end
    end
  end

  describe "when the version file exists" do
    before do
      open("#{TMP}/version.rb", 'w') { |f| f.puts <<-EOS.gsub(/^ *\|/, '') }
        |module MyGem
        |  VERSION = [1, 2, 3]
        |
        |  class << VERSION
        |    include Comparable
        |
        |    def to_s
        |      join('.')
        |    end
        |  end
        |
        |  # Custom code.
        |end
      EOS
      @version_file = Ritual::VersionFile.new("#{TMP}/version.rb", 'MyGem')
    end

    describe "#value" do
      it "should return the version" do
        @version_file.value.should == [1, 2, 3]
      end
    end

    describe "#to_s" do
      it "should return a dot-separated version string" do
        @version_file.to_s.should == '1.2.3'
      end
    end

    describe "#increment" do
      it "should increment the first component if the given component is 0" do
        @version_file.increment(0)
        @version_file.value.should == [2, 0, 0]
      end

      it "should increment the second component if the given component is 1" do
        @version_file.increment(1)
        @version_file.value.should == [1, 3, 0]
      end

      it "should increment the third component if the given component is 2" do
        @version_file.increment(2)
        @version_file.value.should == [1, 2, 4]
      end
    end

    describe "#write" do
      it "should update the version in the file to the current version" do
        @version_file.increment(2)
        @version_file.write
        File.read("#{TMP}/version.rb").should == <<-EOS.gsub(/^ *\|/, '')
          |module MyGem
          |  VERSION = [1, 2, 4]
          |
          |  class << VERSION
          |    include Comparable
          |
          |    def to_s
          |      join('.')
          |    end
          |  end
          |
          |  # Custom code.
          |end
        EOS
      end
    end
  end

  describe "when the version file is invalid" do
    before do
      open("#{TMP}/version.rb", 'w') { |f| f.puts "INVALID" }
    end

    it "should raise a Ritual::Error when instantiating" do
      lambda do
        Ritual::VersionFile.new("#{TMP}/version.rb", 'MyGem')
      end.should raise_error(Ritual::Error)
    end
  end
end
