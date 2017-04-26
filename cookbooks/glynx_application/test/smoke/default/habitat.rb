# # encoding: utf-8

# Inspec test for recipe glynx_application::habitat

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('glynx') do
  it { should be_running }
end

describe port(9292) do
  it { should be_listening }
end
