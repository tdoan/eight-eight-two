module EightEightTwo
  module Backends
    class SqliteBackend < EightEightTwo::Backend
      # ActiveRecord::Base.establish_connection({:adapter=>'sqlite3',:database=>'/tmp/db.tmp'})
      # ActiveRecord::Migration.verbose = false

      # class Entry < ActiveRecord::Base
      # end

      # unless Entry.table_exists?
      #   class CreateEntries < ActiveRecord::Migration
      #     def self.up
      #       create_table :entries do |t|
      #         t.integer :id
      #         t.string :src_ip
      #         t.string :request
      #         t.timestamps
      #       end
      #     end
      #     def self.down
      #       drop_table :entries
      #     end
      #   end
      #   $stderr.print "Creating Entries table..."
      #   CreateEntries.up
      #   $stderr.puts "done."
      # end
    end
  end
end
