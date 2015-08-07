class CreateDiabeticToolboxMembers < ActiveRecord::Migration
  def change
    create_table(:diabetic_toolbox_members) do |t|
      ## Database authenticatable
      t.string :first_name,              null: false, default: ''
      t.string :last_name,               null: false, default: ''
      t.string :username,                null: false, default: ''
      t.string :slug,                    null: false, default: ''
      t.string :email,                   null: false, default: ''
      t.string :encrypted_password,      null: false, default: ''
      t.string :encryption_salt,         null: false, default: ''
      t.string :session_token
      t.date   :dob


      # Reset password
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      # Remember user
      t.datetime :remembered_at

      # Logging
      t.datetime :current_session_began_at
      t.datetime :last_session_began_at
      t.string   :current_session_ip
      t.string   :last_session_ip

      # Confirm user
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      # Security measures
      t.integer  :failed_attempts
      t.string   :unlock_token
      t.datetime :last_locked_at

      t.timestamps null: false
    end

    add_index :diabetic_toolbox_members, :slug,                 unique: true
    add_index :diabetic_toolbox_members, :email,                unique: true
    add_index :diabetic_toolbox_members, :session_token,        unique: true
    add_index :diabetic_toolbox_members, :reset_password_token, unique: true
    add_index :diabetic_toolbox_members, :confirmation_token,   unique: true
    add_index :diabetic_toolbox_members, :unlock_token,         unique: true
  end

  def down
    drop_table :diabetic_toolbox_members
  end
end
