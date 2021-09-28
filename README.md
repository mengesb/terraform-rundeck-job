<!-- markdownlint-disable-file MD033 -->
# terraform-rundeck-job

Terraform rundeck job module.

NOTE: Terraform experimental feature enabled: [module_variable_optional_attrs](https://www.terraform.io/docs/language/expressions/type-constraints.html#experimental-optional-object-type-attributes)

<!--- BEGIN_TF_DOCS --->
## Requirements

The following requirements are needed by this module:

- terraform (~> 1.0.0)

- rundeck (= 0.4.1-pre)

## Providers

The following providers are used by this module:

- rundeck (= 0.4.1-pre)

## Required Inputs

The following input variables are required:

### commands

Description: Nested block defining one step in the job workflow. A job must have one or more commands.

Type:

```hcl
list(object({
    description      = optional(string)
    shell_command    = optional(string)
    inline_script    = optional(string)
    script_file      = optional(string)
    script_file_args = optional(string)

    # job blocks (optional)
    jobs = optional(list(object({
      name              = string
      group_name        = optional(string)
      run_for_each_node = optional(bool)
      args              = optional(string)
      nodefilters       = optional(map(any))
    })))

    # node_step_plugin and step_plugin blocks (optional)
    # plugin = (node_step_plugin || step_plugin)
    steps = optional(list(object({
      plugin = string
      type   = string
      config = optional(map(any))
    })))
  }))
```

### description

Description: A longer description of the job, describing the job in the Rundeck UI.

Type: `string`

### name

Description: The name of the job, used to describe the job in the Rundeck UI.

Type: `string`

### project\_name

Description: The name of the project that this job should belong to.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### allow\_concurrent\_executions

Description: Boolean defining whether two or more executions of this job can run concurrently. The default is false, meaning that jobs will only run sequentially.

Type: `bool`

Default: `false`

### command\_ordering\_strategy

Description: The name of the strategy used to describe how to traverse the matrix of nodes and commands. The default is `node-first`, meaning that all commands will be executed on a single node before moving on to the next. May also be set to `step-first`, meaning that a single step will be executed across all nodes before moving on to the next step.

Type: `string`

Default: `"node-first"`

### continue\_on\_error

Description: (Optional) Boolean defining whether Rundeck will continue to run subsequent steps if any intermediate step fails. Defaults to false, meaning that execution will stop and the execution will be considered to have failed.

Type: `bool`

Default: `false`

### execution\_enabled

Description: If you want job execution to be enabled or disabled. Defaults to true.

Type: `bool`

Default: `true`

### group\_name

Description: The name of a group within the project in which to place the job. Setting this creates collapsable subcategories within the Rundeck UI's project job index.

Type: `string`

Default: `null`

### log\_level

Description: The log level that Rundeck should use for this job. Defaults to `INFO`.

Type: `string`

Default: `"INFO"`

### max\_thread\_count

Description: The maximum number of threads to use to execute this job, which controls on how many nodes the commands can be run simulateneously. Defaults to 1, meaning that the nodes will be visited sequentially.

Type: `number`

Default: `1`

### node\_filter\_exclude\_precedence

Description: Boolean controlling a deprecated Rundeck feature that controls whether node exclusions take priority over inclusions. Default: `false`

Type: `bool`

Default: `false`

### node\_filter\_query

Description: A query string using Rundeck's node filter language that defines which subset of the project's nodes will be used to execute this job.

Type: `string`

Default: `null`

### notifications

Description: Nested block defining notifications on the job workflow.

Type:

```hcl
list(object({
    type         = string
    webhook_urls = optional(list(string))

    emails = optional(list(object({
      attach_log = optional(bool)
      recipients = list(string)
      subject    = optional(string)
    })))

    plugins = optional(list(object({
      type   = string
      config = map(any)
    })))
  }))
```

Default: `[]`

### options

Description: Nested block defining an option a user may set when executing this job. A job may have any number of options.

Type:

```hcl
list(object({
    name                      = string
    default_value             = optional(string)
    value_choices             = optional(list(string))
    value_choices_url         = optional(string)
    require_predefined_choice = optional(bool)
    validation_regex          = optional(string)
    description               = optional(string)
    required                  = optional(bool)
    allow_multiple_values     = optional(bool)
    multi_value_delimiter     = optional(string)
    obscure_input             = optional(bool)
    exposed_to_scripts        = optional(bool)
  }))
```

Default: `[]`

### preserve\_options\_order

Description: Boolean controlling whether the configured options will be presented in their configuration order when shown in the Rundeck UI. The default is false, which means that the options will be displayed in alphabetical order by name.

Type: `bool`

Default: `false`

### rank\_attribute

Description: The name of the attribute that will be used to decide in which order the nodes will be visited while executing the job across multiple nodes.

Type: `string`

Default: `null`

### rank\_order

Description: Keyword deciding which direction the nodes are sorted in terms of the chosen rank\_attribute. May be either `ascending` (the default) or `descending`.

Type: `string`

Default: `"ascending"`

### schedule

Description: The jobs schedule in Unix crontab format

Type: `string`

Default: `null`

### schedule\_enabled

Description: Sets the job schedule to be enabled or disabled. Defaults to true.

Type: `bool`

Default: `true`

### success\_on\_empty\_node\_filter

Description: Boolean determining if an empty node filter yields a successful result. Default: `false`

Type: `bool`

Default: `false`

## Outputs

The following outputs are exported:

### rundeck\_job

Description: n/a

<!--- END_TF_DOCS --->
## Contributing

Contributions are always welcome. Please consult our [CONTRIBUTING.md](CONTRIBUTING.md) file for more information on how to submit quality contributions.

## License & Authors

Author: Brian Menges (@mengesb)

```text
Copyright 2021 Brian Menges

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
