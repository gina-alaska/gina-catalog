# # encoding: utf-8

# Inspec test for recipe glynx_application::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe directory('/var/www/glynx') do
  it { should exist }
  its('owner') { should eq 'webdev' }
  its('group') { should eq 'webdev' }
end

describe directory('/var/www/glynx/shared') do
  it { should exist }
  its('owner') { should eq 'webdev' }
  its('group') { should eq 'webdev' }
end
