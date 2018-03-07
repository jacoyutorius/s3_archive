require "s3_archive/aws"
require "logger"
require "json"

module S3Archive
	class Client
		include S3Archive::AWS
		attr_reader :dir, :bucket, :versioning, :dry, :region, :logger

		def initialize dir: "", bucket: "", versioning: nil, dry: false, region: ""
			@dir = File.expand_path(dir)
			@bucket = bucket
			@versioning = versioning
			@dry = dry
			@region = region
			@logger = Logger.new(File.expand_path(File.dirname($0)) + "/s3_archive.log")
		end

		def execute
			validations
			enable_bucket_versioning if versioning

			[
				"tar -czvf #{archive_fullpath} #{dir}",
        "aws s3 cp #{archive_fullpath} s3://#{bucket}/#{archive_name} --region #{region} --storage-class STANDARD_IA",
        "rm -rf #{archive_fullpath}"
			].each do |command|
				log = { command: command, dry: dry }
				logger.info(log.to_json)

				puts "#{Time.now} #{dry ? "[dry-run]" : ""} #{command}"
				if !dry
					system command
				end
      end
		rescue => ex
			logger.error({
				message: ex.message,
				backtrace: ex.backtrace[0..10]
			}.to_json)
		ensure

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
