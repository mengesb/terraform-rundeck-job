<!-- markdownlint-disable-file MD033 MD012 -->
# terraform-rundeck-job

Terraform rundeck job module.

A Rundeck job is quite complex, and as such its representation in Terraform can  
also be a bit daunting. Beginning with Terraform 0.15.x, we'll have support for  
defaulting values in structured objects, and while experimental in 0.14.x, it  
was thought best to not use experimental features for the time being.

With this in mind, the structure of the job's nested blocks is in a keyed-index  
model.

The following relationships apply:

- A `rundeck_job` can have several command blocks: `{ n | n ∈ ℕ}`
- A `command {}` block __may__ have a `job {}` block: 0 or 1
- A `command {}` block __may__ have a `node_step_plugin {}` block: 0 or 1
- A `command {}` block __may__ have a `step_plugin {}` block: 0 or 1
- Several `notification {}` blocks __may__ exist: `{ n | n ∈ ℝ }`
- A `notification {}` block __may__ have several `email {}` blocks: `{ n | n ∈ ℝ }`
- A `notification {}` block __may__ have several `plugin {}` blocks: `{ n | n ∈ ℝ }`

How this is accomplished in Terraform is via named indexes. Each `command {}`  
block is identified by it's index and must be unique. You can re-use existing  
indexes for nested items, however not for parent items like `command {}` and
`notification {}`. There are different variables defining the sub-objects and  
their relationship to the parent via their name:

Command block relationships:

- `var.command`
- `var.command_job`
- `var.command_job_notification`
- `var.command_node_step_plugin`
- `var.command_step_plugin`

Notification block relationships:

- `var.notification`
- `var.notification_email`
- `var.notification_plugin`

Indexes of sub-objects must link up to its parent object to populate the  
correct `rundeck_job` `command` or `notification` block element.

Example:

- Please see [examples/example1/main.tf](examples/example1/main.tf)

## Requirements

The following requirements are needed by this module:

- terraform (~> 0.14.0)

- rundeck (~> 0.4.0)

## Providers

The following providers are used by this module:

- rundeck (~> 0.4.0)

## Required Inputs

The following input variables are required:

### command

Description: Nested block defining one step in the job workflow. A job must have one or more commands.

Type:

```hcl
map(object({
    description      = string
    shell_command    = string
    inline_script    = string
    script_file      = string
    script_file_args = string
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

### command\_job

Description: A job block for a command.

Type:

```hcl
map(object({
    name              = string
    group_name        = string
    run_for_each_node = bool
    args              = string
  }))
```

Default: `{}`

### command\_job\_nodefilters

Description: A nodefilters block for a specific job block

Type:

```hcl
map(object({
    excludeprecedence = bool
    filter            = string
  }))
```

Default: `{}`

### command\_node\_step\_plugin

Description: A node\_step\_plugin block for a command.

Type:

```hcl
map(object({
    type   = string
    config = map(string)
  }))
```

Default: `{}`

### command\_ordering\_strategy

Description: The name of the strategy used to describe how to traverse the matrix of nodes and commands. The default is `node-first`, meaning that all commands will be executed on a single node before moving on to the next. May also be set to `step-first`, meaning that a single step will be executed across all nodes before moving on to the next step.

Type: `string`

Default: `"node-first"`

### command\_step\_plugin

Description: A step block for a command.

Type:

```hcl
map(object({
    type   = string
    config = map(string)
  }))
```

Default: `{}`

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

### notification

Description: Nested block defining notifications on the job workflow.

Type:

```hcl
map(object({
    type         = string
    webhook_urls = list(string)
  }))
```

Default: `{}`

### notification\_email

Description: Email block for a notification

Type:

```hcl
map(object({
    attach_log = bool
    recipients = list(string)
    subject    = string
  }))
```

Default: `{}`

### notification\_plugin

Description: Plugin block for a notification

Type:

```hcl
map(object({
    type   = string
    config = map(string)
  }))
```

Default: `{}`

### option

Description: Nested block defining an option a user may set when executing this job. A job may have any number of options.

Type:

```hcl
list(object({
    name                      = string
    default_value             = string
    value_choices             = list(string)
    value_choices_url         = string
    require_predefined_choice = bool
    validation_regex          = string
    description               = string
    required                  = bool
    allow_multiple_values     = bool
    multi-value_delimiter     = string
    obscure_input             = bool
    exposed_to_scripts        = bool
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

### local-commands

Description: n/a

### rundeck\_job

Description: n/a

