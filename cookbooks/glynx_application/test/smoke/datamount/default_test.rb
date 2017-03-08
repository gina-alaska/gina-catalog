# # encoding: utf-8

# Inspec test for recipe glynx_application::datamounts

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe directory('/var/www/glynx/shared/uploads') do
  it { should exist }
  its('owner') { should eq 'webdev' }
  its('group') { should eq 'webdev' }
end

describe mount('/var/www/glynx/shared/uploads') do
  it { should be_mounted }
end
