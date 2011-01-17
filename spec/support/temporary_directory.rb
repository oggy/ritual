module Support
  module TemporaryDirectory
    def create_temporary_directory
      FileUtils.rm_rf TMP
      FileUtils.mkdir_p TMP
    end

    def destroy_temporary_directory
      FileUtils.rm_rf TMP
    end
  end
end
