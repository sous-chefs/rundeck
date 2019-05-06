# project #

Use the **project** resource to add or remove a Rundeck project.

## Syntax ##

The full syntax for all of the properties available to the **project** resource is:

----

```ruby
project 'project' do
    label                        String # You may wish to use a more user friendly display name for the project. The project label can contain spaces and other characters.
    description                  String # A brief explanation about the project. Normally, this is just one phrase or sentence explaining the project purpose. If you have large amounts of text, consider creating a project README.
    executions_disable           [true, false] # Turn off the ability to execute jobs and ad-hoc commands.
    schedule_disable             [true, false] # Turn off the job scheduling feature.
    job_group_expansion_level    Integer # In the Jobs page, how should the job groups be collapsed? A 1 is default and shows one group level opened. Use 0 to collapse all. Use -1 to expand all.
    display_motd                 [none, projectList, projectHome, both] # Show the Readme in the project list and/or home page.
    display_readme               [none, projectList, projectHome, both] # Show the Readme in the project list and/or home page.
    project_properties           Hash # Hash of additional settings that get added directly to the project configuration.
end
```

## Actions ##

`:create`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Create the Rundeck project. This is the default, action.

`:delete`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Deletes the Rundeck Project.

## Examples ##

### Create project with default settings ###

```ruby
rundeck_project 'myproject' do
end
```

### Create project, specifying default file copy provider ###

```ruby
project_properties = {
  'service.FileCopier.default.provider': 'jsch-scp',
}

rundeck_project 'myproject' do
  description 'test project'
  label 'my test project'
  project_properties project_properties
  action [:create]
end
```

### Deletes project ###

```ruby
rundeck_project 'shouldnotexist' do
  action [:delete]
end
```