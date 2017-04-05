require "s3_archive/aws"

module S3Archive
	class Client
		include S3Archive::AWS
		attr_reader :dir, :bucket, :versioning, :dry

		def initialize dir: "", bucket: "", versioning: nil, dry: false
			@dir = File.expand_path(dir)
			@bucket = bucket
			@versioning = versioning
			@dry = dry
		end

		def execute
			validations

			if versioning
				# p "exec 'aws s3api put-bucket-versioning --bucket #{bucket} --versioning-configuration Status=Enabled"
				enable_bucket_versioning
			end

			[
				"tar -czvf #{archive_fullpath} #{dir}",
        "aws s3 cp #{archive_fullpath} s3://#{bucket}/#{archive_name}",
        "rm -rf #{archive_fullpath}"
			].each do |command|
        if dry
        	p "[dry-run]  " + command
        else
        	system command
        end
      end
		rescue => ex
			puts ex
		end

		private
			def validations
				raise Exception.new("aws cli was not installed!") unless cli_installed?
				raise Exception.new("#{dir} target dir was not exist!") unless Dir.exists?(dir)
				raise Exception.new("#{bucket} target bucket was not exist!") unless bucket_exist?(bucket)
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
		    system "aws s3api put-bucket-versioning --bucket #{@bucket_name} --versioning-configuration Status=Enabled"
		  end
	end
end