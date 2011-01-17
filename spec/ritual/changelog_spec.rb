require 'spec/spec_helper'

describe Ritual::Changelog do
  before do
    @changelog = Ritual::Changelog.new("#{TMP}/changelog")
  end

  describe "#path" do
    it "should return the path of the changelog" do
      @changelog.path.should == "#{TMP}/changelog"
    end
  end

  describe "#set_latest_version" do
    it "should set the 'LATEST' heading to the given version, and datestamp it" do
      warp_to 'December 13, 2011'
      open("#{TMP}/changelog", 'w') { |f| f.puts <<-EOS.gsub(/^ *\|/, '') }
        |== LATEST
        |== 0.1.0 2011-11-11
      EOS

      @changelog.set_latest_version '1.2.3'
      File.read("#{TMP}/changelog").should == <<-EOS.gsub(/^ *\|/, '')
        |== 1.2.3 2011-12-13
        |== 0.1.0 2011-11-11
      EOS
    end

    it "should raise an error if no 'LATEST' header could be found" do
      open("#{TMP}/changelog", 'w') { |f| f.puts <<-EOS.gsub(/^ *\|/, '') }
        |== 0.1.0 2011-11-11
      EOS

      lambda do
        @changelog.set_latest_version '1.2.3'
      end.should raise_error(Ritual::Changelog::Error)
    end
  end
end
