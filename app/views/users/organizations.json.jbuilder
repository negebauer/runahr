# frozen_string_literal: true

json.array! @organizations do |organization|
  json.partial! 'organizations/organization', organization: organization
  json.role OrganizationUser.find_by(user_id: @user.id, organization_id: organization.id).role
end
