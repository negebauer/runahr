# frozen_string_literal: true

class MoveRoleFromUserToOrganizationsUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :role

    add_column :organization_users, :role, :integer
  end
end
