# # encoding: utf-8

# Inspec test for recipe glynx_application::_user

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('webdev') do
  it { should exist }
end

describe group('webdev') do
  it { should exist }
end
