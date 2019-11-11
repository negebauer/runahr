# frozen_string_literal: true

class CreateOrganizationsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :organization_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :organization, index: true
    end
  end
end
