require 'sqlite3'

class Database
  @DBNAME = 'database.sqlite'
  @db_path = ''
  @DB = nil

  def self.load(path)
    print 'Loading DB...'
    @db_path = path + '/' + @DBNAME
    if File.exists? @db_path
      @DB = SQLite3::Database.open @db_path
    else
      @DB = SQLite3::Database.new @db_path
      @DB.execute 'CREATE TABLE main_table(server_id int, user_id int, xp float);'
      @DB.execute 'CREATE TABLE warns_table(server_id int, user_id, int, warn_id string, warn_reason string, warn_mod int);'
      @DB.execute 'CREATE TABLE server_info(server_id int, join_msg string, join_channel int);'
    end
    @DB.results_as_hash = true
    print " Done.\n"
  end

  def self.get_db
    return @DB
  end

  def self.get_by_server(server_id, table)
    return @DB.execute 'SELECT * FROM ' + table + ' WHERE server_id = ?;', server_id
  end
end
