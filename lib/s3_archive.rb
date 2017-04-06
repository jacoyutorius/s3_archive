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
		option :region, type: :string, default: "ap-northeast-1"
		def archive(target_dir, target_bucket)
			if options[:each]
				Dir.glob("#{target_dir}/**").each do |dir|
					child = target_dir.split("/").last.gsub(/[.]/, "_")
					run(dir, "#{target_bucket}/#{child}", options)
				end
			else
				run(target_dir, target_bucket, options)
			end
		end

		private
			def run target_dir, target_bucket, options
				Client.new(
					dir: target_dir,
					bucket: target_bucket,
					versioning: options[:enable_versioning],
					dry: options[:dry],
					region: options[:region]
				).execute
			rescue => ex
				puts ex
			end
	end
end
