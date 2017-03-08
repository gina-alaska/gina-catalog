# # encoding: utf-8

# Inspec test for recipe glynx_database::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe port(5432) do
  it { should be_listening }
end

describe service('postgresql-9.4') do
  it { should be_running }
  it { should be_enabled }
end
