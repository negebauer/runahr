# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, organization = nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity
    can :create, User

    return unless user.present?

    # Signed in user permissions
    can :me, User
    can :read, Organization, id: user.organizations.pluck(:id)
    can :create, Organization

    return unless organization.present?

    organization_user = organization.organization_users.find_by(user_id: user.id)
    return unless organization_user.present?
    return unless organization_user.admin? || organization_user.employee?

    # Organization employee permissions
    can :me, Attendance, user_id: user.id
    can %i[check_in check_out], Organization, id: organization.id

    return unless organization_user.admin?

    # Organization admin permissions
    can :manage, Attendance, organization_id: organization.id
    can :manage, Organization, id: organization.id
  end
end
