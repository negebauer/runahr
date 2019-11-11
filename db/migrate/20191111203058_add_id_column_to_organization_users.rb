# frozen_string_literal: true

class AddIdColumnToOrganizationUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :organization_users, :id, :primary_key
  end
end
