default['rundeck']['acl_policies'] = {
  'rundeck_administrator' => [
    {
      description: 'Administrators, all access.',
      context: {
        project: '.*',
      },
      for: {
        resource: [
          {
            equals: { kind: 'job' },
            allow: [
              'create',
            ],
          },
          {
            equals: { kind: 'node' },
            allow: %w(read create update refresh),
          },
          {
            equals: { kind: 'event' },
            allow: %w(read create),
          },
        ],
        adhoc: [
          allow: %w(read run runAs kill killAs),
        ],
        job: [
          allow: %w(create read update delete run runAs kill killAs toggle_schedule),
        ],
        node: [
          allow: %w(read run),
        ],
      },
      by: {
        group: 'rundeck_administrators',
      },
    },
    {
      description: 'Administrators, all access.',
      context: {
        application: 'rundeck',
      },
      for: {
        resource: [
          {
            equals: { kind: 'project' },
            allow: %w(create),
          },
          {
            equals: { kind: 'system' },
            allow: %w(read enable_executions disable_executions admin),
          },
          {
            equals: { kind: 'system_acl' },
            allow: %w(read create update delete admin),
          },
        ],
        project: [
          {
            match: { name: '.*' },
            allow: %w(read import export configure delete admin),
          },
        ],
        project_acl: [
          {
            match: { name: '.*' },
            allow: %w(read create update delete admin),
          },
        ],
        storage: [
          allow: %w(read create update delete),
        ],
      },
      by: {
        group: 'rundeck_administrators',
      },
    },
  ],
}
