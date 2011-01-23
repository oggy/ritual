require 'spec/spec_helper'

describe Ritual::Extension do
  DLEXT = Config::CONFIG['DLEXT']

  def extension(name, options={})
    params = options.merge(:library_name => 'LIBNAME')
    Ritual::Extension.new(name, params)
  end

  describe "when unnamed" do
    it "should name the task 'ext'" do
      extension = extension(nil)
      extension.task_name.should == 'ext'
    end

    it "should find the extension in ext by default" do
      extension = extension(nil)
      extension.path.should == 'ext'
    end

    it "should use ext/LIBNAME.DLEXT as the default build path" do
      extension = extension(nil)
      extension.build_path.should == "ext/LIBNAME.#{DLEXT}"
    end

    it "should install to lib/LIBNAME/LIBNAME.DLEXT by default" do
      extension = extension(nil)
      extension.install_path.should == "lib/LIBNAME/LIBNAME.#{DLEXT}"
    end
  end

  describe "when named" do
    it "should name the task 'ext:NAME'" do
      extension = extension(:NAME)
      extension.task_name.should == 'ext:NAME'
    end

    it "should find the extension in ext/NAME by default" do
      extension = extension(:NAME)
      extension.path.should == "ext/NAME"
    end

    it "should use ext/NAME/NAME.DLEXT as the default build path" do
      extension = extension(:NAME)
      extension.build_path.should == "ext/NAME/NAME.#{DLEXT}"
    end

    it "should install to lib/LIBNAME/NAME.DLEXT by default" do
      extension = extension(:NAME)
      extension.install_path.should == "lib/LIBNAME/NAME.#{DLEXT}"
    end
  end

  it "should accept an explicit build path" do
    extension = extension(nil, :build_as => 'custom')
    extension.build_path.should == "custom.#{DLEXT}"
  end

  it "should accept an explicit install path" do
    extension = extension(nil, :install_as => 'custom')
    extension.install_path.should == "custom.#{DLEXT}"
  end
end
