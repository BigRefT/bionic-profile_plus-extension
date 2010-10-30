namespace :bionic do
  namespace :extensions do
    namespace :profile_plus do
      
      desc "Runs the migration of the Profile Plus extension"
      task :migrate => :environment do
        require 'bionic/extension_migrator'
        if ENV["VERSION"]
          ProfilePlusExtension.migrator.migrate(ENV["VERSION"].to_i)
          Rake::Task['db:schema:dump'].invoke
        else
          ProfilePlusExtension.migrator.migrate
          Rake::Task['db:schema:dump'].invoke
        end
      end
      
      desc "Copies public assets of the Profile Plus to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from ProfilePlusExtension"
        Dir[ProfilePlusExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(ProfilePlusExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
        unless ProfilePlusExtension.root.starts_with? RAILS_ROOT # don't need to copy vendored tasks
          puts "Copying rake tasks from ProfilePlusExtension"
          local_tasks_path = File.join(RAILS_ROOT, %w(lib tasks))
          mkdir_p local_tasks_path, :verbose => false
          Dir[File.join ProfilePlusExtension.root, %w(lib tasks *.rake)].each do |file|
            cp file, local_tasks_path, :verbose => false
          end
        end
      end
    end

  end
end
