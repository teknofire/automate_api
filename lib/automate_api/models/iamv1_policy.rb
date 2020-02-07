module AutomateApi
  module Models
    class IamV1Policy < AutomateApi::Resource::Base
      fields :id, :description, :active, :value
      endpoints all: { path: 'auth/policies', collect: 'policies' }
    end
  end
end
