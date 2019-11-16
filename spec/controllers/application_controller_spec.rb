# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it { should route(:get, '').to(action: :root) }
end
