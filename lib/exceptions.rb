# frozen_string_literal: true

module Exceptions
  class UserHasNoCheckInToCheckOut < StandardError; end

  class UserHasPendingCheckOut < StandardError
    attr_reader :attendance

    def initialize(attendance)
      @attendance = attendance
    end
  end
end
