# frozen_string_literal: true

class CreateAttendance < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.belongs_to :user, index: true
      t.belongs_to :organization, index: true
      t.datetime :in_at
      t.datetime :out_at

      t.timestamps
    end

    add_index :attendances, %i[user_id organization_id]
  end
end
