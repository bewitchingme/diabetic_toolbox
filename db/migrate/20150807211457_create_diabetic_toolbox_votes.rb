# This uses the thumbs_up gem, the table was properly namespaced to
# ensure that it doesn't collide with the use of it in the host application
class CreateDiabeticToolboxVotes < ActiveRecord::Migration
  def self.up
    create_table :diabetic_toolbox_votes, :force => true do |t|

      t.boolean    :vote,     :default     => false, :null => false
      t.references :voteable, :polymorphic => true,  :null => false
      t.references :voter,    :polymorphic => true
      t.timestamps null: false

    end

    add_index :diabetic_toolbox_votes, [:voter_id, :voter_type]
    add_index :diabetic_toolbox_votes, [:voteable_id, :voteable_type]
    add_index :diabetic_toolbox_votes, [:voter_id, :voter_type, :voteable_id, :voteable_type],
              :unique => true, :name => 'fk_one_vote_per_member'
  end

  def self.down
    drop_table :diabetic_toolbox_votes
  end
end

