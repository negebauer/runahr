# frozen_string_literal: true

class AddUserOrganizationIndexToOrganizationUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :organization_users, %i[user_id organization_id], unique: true
  end
end
