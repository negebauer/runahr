# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserTokenController, type: :controller do
  it { should route(:post, 'login').to(action: :create) }
end
