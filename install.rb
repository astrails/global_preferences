# Install hook code here
dir = File.join(RAILS_ROOT, "db/migrate")

existing = Dir[File.join(dir, "*_create_global_preferences.rb")]
unless existing.empty?
  puts "migration already exists: #{existing *' '}"
else
  filename = File.join(dir, "#{Time.now.utc.strftime "%Y%m%d%H%M%S"}_create_global_preferences.rb")
  puts "creating migration #{filename}"
  File.open(filename, "w") do |file|
    file.write <<-END
class CreateGlobalPreferences < ActiveRecord::Migration
  def self.up
    create_table :global_preferences do |t|
      t.string :name
      t.string :value
      t.integer :ttl

      t.timestamps
    end
    add_index :global_preferences, [:name], :unique => true
  end

  def self.down
    drop_table :global_preferences
  end
end
    END
  end
end

puts "Installation complete! Don't forget to 'rake db:migrate'."

