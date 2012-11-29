# This migration comes from coursewareable (originally 20120703095429)
# Sorcery gem migration
class CreateCoursewareableUsers < ActiveRecord::Migration
  def change
    create_table :coursewareable_users do |t|
      # Core fields
      t.string :email,                              null: false
      t.string :crypted_password,                   default: nil
      t.string :salt,                               default: nil

      # Custom fields
      t.string :role,                               default: nil
      t.string :first_name,                         default: nil
      t.string :last_name,                          default: nil
      t.integer :memberships_count,                 default: 0
      t.integer :collaborations_count,              default: 0
      t.integer :created_classrooms_count,          default: 0

      # Remember me support
      t.string    :remember_me_token,               default: nil
      t.datetime  :remember_me_token_expires_at,    default: nil

      # Reset password support
      t.string    :reset_password_token,            default: nil
      t.datetime  :reset_password_token_expires_at, default: nil
      t.datetime  :reset_password_email_sent_at,    default: nil

      # Activate account support
      t.string    :activation_state,                default: nil
      t.string    :activation_token,                default: nil
      t.datetime  :activation_token_expires_at,     default: nil

      # Last loging support
      t.datetime :last_login_at,                    default: nil
      t.datetime :last_logout_at,                   default: nil
      t.datetime :last_activity_at,                 default: nil

      # Brute force protection
      t.integer   :failed_logins_count,             default: 0
      t.datetime  :lock_expires_at,                 default: nil
      t.string    :unlock_token,                    default: nil

      t.timestamps
    end

    add_index :coursewareable_users, :email
    add_index :coursewareable_users, :activation_token
    add_index :coursewareable_users, :remember_me_token
    add_index :coursewareable_users, :reset_password_token
    add_index(:coursewareable_users, [:last_logout_at, :last_activity_at],
      :name => 'index_coursewareable_users_on_logout_at_and_activity_at')
  end
end
