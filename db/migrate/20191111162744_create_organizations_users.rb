# frozen_string_literal: true

class CreateOrganizationsUsers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :organizations, :users do |t|
      t.index :organization_id
      t.index :user_id
    end
  end
end
