# frozen_string_literal: true

json.extract! organization, :id, :created_at, :updated_at, :name
json.role @user.role(organization.id) if @user
