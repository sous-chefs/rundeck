# rubocop:disable Style/UnneededPercentQ

default['rundeck']['acl_policies']['myadmin'] = %q(
description: Admin project level access control. Applies to resources within a specific project.
context:
  project: '.*' # all projects
for:
  resource:
    - equals:
        kind: job
      allow: [create] # allow create jobs
    - equals:
        kind: node
      allow: [read,create,update,refresh] # allow refresh node sources
    - equals:
        kind: event
      allow: [read,create] # allow read/create events
  adhoc:
    - allow: [read,run,runAs,kill,killAs] # allow running/killing adhoc jobs
  job:
    - allow: [create,read,update,delete,run,runAs,kill,killAs] # allow create/read/write/delete/run/kill of all jobs
  node:
    - allow: [read,run] # allow read/run for nodes
by:
  group: admin

---

description: Admin Application level access control, applies to creating/deleting projects, admin of user profiles, viewing projects and reading system information.
context:
  application: 'rundeck'
for:
  resource:
    - equals:
        kind: project
      allow: [create] # allow create of projects
    - equals:
        kind: system
      allow: [read,enable_executions,disable_executions,admin] # allow read of system info, enable/disable all executions
    - equals:
        kind: system_acl
      allow: [read,create,update,delete,admin] # allow modifying system ACL files
    - equals:
        kind: user
      allow: [admin] # allow modify user profiles
  project:
    - match:
        name: '.*'
      allow: [read,import,export,configure,delete,admin] # allow full access of all projects or use 'admin'
  project_acl:
    - match:
        name: '.*'
      allow: [read,create,update,delete,admin] # allow modifying project-specific ACL files
  storage:
    - allow: [read,create,update,delete] # allow access for /ssh-key/* storage content

by:
  group: admin
)

default['rundeck']['acl_policies']['myproject'] = %q(
description: "Allow users in runjobs group to run, kill jobs, etc. in the project called YOUR PROJECT"
context:
  project: YOUR PROJECT
by:
  group: groupname
for:
  resource:
    - equals:
        kind: job
      allow: [read, run, kill]
    - equals:
        kind: node
      allow: [read]
    - equals:
        kind: event
      allow: [read] # allow reading activity logs
    - equals:
        kind: 'adhoc'
      allow: [read,run,kill]
  adhoc:
    - allow: [read,run,kill] # allow running/killing adhoc jobs
  job:
    - allow: [read,run,kill]
  node:
    - allow: [read,run] # allow read/run for nodes
---
context:
  application: rundeck
description: "Users in the 'runjobs' group can launch jobs in the project called YOUR PROJECT but not edit them"
for:
  project:
    - match:
        name: 'YOUR PROJECT'
      allow: [read]
  system:
    - match:
        name: '.*'
      allow: [read]
by:
  group: groupname
)
