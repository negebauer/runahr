# frozen_string_literal: true

json.extract! user, :id, :created_at, :updated_at, :email, :name
json.role user.role(@organization.id) if @organization
