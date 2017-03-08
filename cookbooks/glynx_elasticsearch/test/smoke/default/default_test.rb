# # encoding: utf-8

# Inspec test for recipe glynx_elasticsearch::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/


describe service('elasticsearch') do
  it { should be_running }
  it { should be_enabled }
end

# describe port(9200) do
#   it { should be_listening }
# end
