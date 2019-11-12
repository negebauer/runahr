# frozen_string_literal: true

class RenameAttendanceInAtAndOutAtToCheckinAtAndCheckoutAt < ActiveRecord::Migration[5.2]
  def change
    rename_column :attendances, :in_at, :checkin_at
    rename_column :attendances, :out_at, :checkout_at
  end
end
