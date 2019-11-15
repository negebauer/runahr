# frozen_string_literal: true

class RenameAttendanceCheckinAndCheckoutToIncludeSpace < ActiveRecord::Migration[5.2]
  def change
    rename_column :attendances, :checkin_at, :check_in_at
    rename_column :attendances, :checkout_at, :check_out_at
  end
end
