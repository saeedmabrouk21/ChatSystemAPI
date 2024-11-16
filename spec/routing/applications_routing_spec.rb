# spec/routing/applications_routing_spec.rb
require 'rails_helper'

RSpec.describe "Applications routing", type: :routing do
  it 'routes to #create' do
    expect(post: '/applications').to route_to('applications#create')
  end

  it 'routes to #show' do
    expect(get: '/applications/12345').to route_to('applications#show', token: '12345')
  end

  it 'routes to #update' do
    expect(patch: '/applications/12345').to route_to('applications#update', token: '12345')
  end
end
