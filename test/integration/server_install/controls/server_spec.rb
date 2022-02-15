describe service('rundeckd') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

case os[:family]
when 'redhat'
  describe yum.repo('rundeck') do
    it { should exist }
    it { should be_enabled }
  end

when 'debian'
  describe apt('https://packages.rundeck.com/pagerduty/rundeck/any/') do
    it { should exist }
    it { should be_enabled }
  end
end

# rubocop:disable Style/UnneededPercentQ
admin_policy = %q(
---
description: Administrators, all access.
context:
  project: '.*'
for:
  resource:
  - equals:
      kind: job
    allow:
    - create
  - equals:
      kind: node
    allow:
    - read
    - create
    - update
    - refresh
  - equals:
      kind: event
    allow:
    - read
    - create
  adhoc:
  - allow:
    - read
    - run
    - runAs
    - kill
    - killAs
  job:
  - allow:
    - create
    - read
    - update
    - delete
    - run
    - runAs
    - kill
    - killAs
    - toggle_schedule
  node:
  - allow:
    - read
    - run
by:
  group: admin

---
description: Administrators, all access.
context:
  application: rundeck
for:
  resource:
  - equals:
      kind: project
    allow:
    - create
  - equals:
      kind: system
    allow:
    - read
    - enable_executions
    - disable_executions
    - admin
  - equals:
      kind: system_acl
    allow:
    - read
    - create
    - update
    - delete
    - admin
  project:
  - match:
      name: '.*'
    allow:
    - read
    - import
    - export
    - configure
    - delete
    - admin
  project_acl:
  - match:
      name: '.*'
    allow:
    - read
    - create
    - update
    - delete
    - admin
  storage:
  - allow:
    - read
    - create
    - update
    - delete
by:
  group: admin
)

describe file('/etc/rundeck/admin.aclpolicy') do
  its('content') { should match admin_policy }
end
