namespace :db do
  desc "Creates the test database for MySQL."
  task :mysql do
    load 'test/db/mysql.rb' rescue nil
    IO.popen("mysql -u root", "w") do |io|
      io.puts <<-SQL
DROP DATABASE IF EXISTS `#{MYSQL_CONFIG[:database]}`;
CREATE DATABASE `#{MYSQL_CONFIG[:database]}` DEFAULT CHARACTER SET `utf8`;
GRANT ALL PRIVILEGES ON `#{MYSQL_CONFIG[:database]}`.* TO #{MYSQL_CONFIG[:username]}@localhost;
SET PASSWORD FOR #{MYSQL_CONFIG[:username]}@localhost = PASSWORD('#{MYSQL_CONFIG[:password]}');
SQL
    end
  end

  desc "Creates the test database for PostgreSQL."
  task :postgres do
    load 'test/db/postgres.rb' rescue nil
    IO.popen("psql", "w") do |io|
      io.puts <<-SQL
DROP DATABASE IF EXISTS #{POSTGRES_CONFIG[:database]};
DROP USER IF EXISTS #{POSTGRES_CONFIG[:username]};
CREATE USER #{POSTGRES_CONFIG[:username]} CREATEDB SUPERUSER LOGIN PASSWORD '#{POSTGRES_CONFIG[:password]}';
CREATE DATABASE #{POSTGRES_CONFIG[:database]} OWNER #{POSTGRES_CONFIG[:username]};
SQL
    end
  end
end
