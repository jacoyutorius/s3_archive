require "s3_archive/version"
require "s3_archive/client"
require "thor"

module S3Archive
	class CLI < Thor
		class_option :help, type: :boolean, aliases: "-h", desc: "help"
		class_option :version, type: :boolean, desc: "version"
	
		desc "version", "show version"
		def version
			puts S3Archive::VERSION
		end

		desc "archive", "execute archive"
		option :each, type: :boolean, default: false
		option :enable_versioning, type: :boolean, default: true
		option :dry, type: :boolean, default: false
		def archive(target_dir, target_bucket)
			if options[:each]
				Dir.glob("#{target_dir}/**").each do |dir|
					gotcha!(dir, target_bucket, options)
				end
			else
				gotcha!(target_dir, target_bucket, options)
			end
		end

		private
			def gotcha! target_dir, target_bucket, options
				Client.new(
					dir: target_dir,
					bucket: target_bucket,
					versioning: options[:enable_versioning],
					dry: options[:dry]
				).execute
			end
	end
end
