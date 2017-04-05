module S3Archive
	module AWS
		def cli_installed?
			cli_path = `which aws`.strip
			File.exists?(cli_path)
		end

		def bucket_exist? bucket
			ret = `aws s3 ls #{bucket}`.strip
			!ret.empty?
		end
	end
end