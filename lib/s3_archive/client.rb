require "s3_archive/aws"

module S3Archive
	class Client
		include S3Archive::AWS
		attr_reader :dir, :bucket, :versioning, :dry, :region

		def initialize dir: "", bucket: "", versioning: nil, dry: false, region: ""
			@dir = File.expand_path(dir)
			@bucket = bucket
			@versioning = versioning
			@dry = dry
			@region = region
		end

		def execute
			validations
			enable_bucket_versioning if versioning

			[
				"tar -czvf #{archive_fullpath} #{dir}",
        "aws s3 cp #{archive_fullpath} s3://#{bucket}/#{archive_name} --region #{region}",
        "rm -rf #{archive_fullpath}"
			].each do |command|
        if dry
        	p "[dry-run]  " + command
        else
        	system command
        end
      end
		end

		private
			def validations
				raise "aws cli was not installed!" unless cli_installed?
				
				if (!Dir.exists?(dir) || !File.exists?(dir))
					raise "#{dir} target dir or file was not exist!"
				end
			end

			def archive_name
				@_archive_name ||= dir.split("/").last + ".gz"
			end

			def archive_fullpath
				"#{current_dir}/#{archive_name}"
			end

			def current_dir
				Dir.pwd
			end

			def enable_bucket_versioning
		    system "aws s3api put-bucket-versioning --bucket #{bucket} --versioning-configuration Status=Enabled"
		  end
	end
end