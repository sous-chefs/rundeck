# frozen_string_literal: true

describe http('http://localhost/user/login') do
  its('status') { should cmp 200 }
end