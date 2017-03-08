# # encoding: utf-8

# Inspec test for recipe glynx_application::puma

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('puma') do
  it { should be_running }
end

describe port(8080) do
  it { should be_listening }
end
