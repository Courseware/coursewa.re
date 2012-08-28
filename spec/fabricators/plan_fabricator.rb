Fabricator(:plan) do
  transient           :plan
  allowed_classrooms  { |attrs|
    Courseware.config.plans[ attrs[:plan] || :free ][:allowed_classrooms]
  }
  allowed_space       { |attrs|
    Courseware.config.plans[ attrs[:plan] || :free ][:allowed_space]
  }
  expires_in          { |attrs|
    Courseware.config.plans[ attrs[:plan] || :free ][:expires_in]
  }
  slug                { |attrs| (attrs[:plan] || :free).to_sym }
end
