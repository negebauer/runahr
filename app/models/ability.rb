# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    can :create, User

    return unless user.present?

    # Signed in user permissions
    can :me, User
    can :read, Organization, id: user.organizations.pluck(:id)
    can :create, Organization

    # Organization employee permissions
    can :me, Attendance, user_id: user.id
    can :index, Attendance, user_id: user.id
    can :check_in, Organization, organization_users: { user_id: user.id, role: %i[admin employee] }
    can :check_out, Organization, organization_users: { user_id: user.id, role: %i[admin employee] }

    # Organization admin permissions
    can :manage, Attendance, organization: { organization_users: { user_id: user.id, role: OrganizationUser.roles[:admin] } }
    can :manage, Organization, organization_users: { user_id: user.id, role: :admin }
  end
end
