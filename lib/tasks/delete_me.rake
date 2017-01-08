desc "This is a helper to delete me as a user"
task :delete_me => :environment do
  me = User.find_by_email("joncravotta32@gmail.com")
  me.destroy
end
