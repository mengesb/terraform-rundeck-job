#
# Terraform:: terraform-rundeck-job
# Plan:: variables.tf
#

variable "name" {
  type        = string
  description = "The name of the job, used to describe the job in the Rundeck UI."
}

variable "description" {
  type        = string
  description = "A longer description of the job, describing the job in the Rundeck UI."
}

variable "project_name" {
  type        = string
  description = "The name of the project that this job should belong to."
}

variable "execution_enabled" {
  type        = bool
  description = "If you want job execution to be enabled or disabled. Defaults to true."
  default     = true
}

variable "group_name" {
  type        = string
  description = "The name of a group within the project in which to place the job. Setting this creates collapsable subcategories within the Rundeck UI's project job index."
  default     = null
}

variable "log_level" {
  type        = string
  description = "The log level that Rundeck should use for this job. Defaults to `INFO`."
  default     = "INFO"

  validation {
    condition     = contains(["DEBUG", "ERROR", "NORMAL", "INFO", "OTHER", "VERBOSE", "WARN"], var.log_level)
    error_message = "Variable log_level must be one of the following: DEBUG, ERROR, NORMAL, INFO, OTHER, VERBOSE, WARN."
  }
}

variable "schedule" {
  type        = string
  description = "The jobs schedule in Unix crontab format"
  default     = null

  validation {
    condition     = var.schedule == null ? true : length(split(" ", var.schedule)) == 5
    error_message = "Variable schedule must be in a Unux crontab format."
  }
}

variable "schedule_enabled" {
  type        = bool
  description = "Sets the job schedule to be enabled or disabled. Defaults to true."
  default     = true
}

variable "allow_concurrent_executions" {
  type        = bool
  description = "Boolean defining whether two or more executions of this job can run concurrently. The default is false, meaning that jobs will only run sequentially."
  default     = false
}

variable "max_thread_count" {
  type        = number
  description = "The maximum number of threads to use to execute this job, which controls on how many nodes the commands can be run simulateneously. Defaults to 1, meaning that the nodes will be visited sequentially."
  default     = 1
}

variable "continue_on_error" {
  type        = bool
  description = "(Optional) Boolean defining whether Rundeck will continue to run subsequent steps if any intermediate step fails. Defaults to false, meaning that execution will stop and the execution will be considered to have failed."
  default     = false
}

variable "rank_attribute" {
  type        = string
  description = "The name of the attribute that will be used to decide in which order the nodes will be visited while executing the job across multiple nodes."
  default     = null
}

variable "rank_order" {
  type        = string
  description = "Keyword deciding which direction the nodes are sorted in terms of the chosen rank_attribute. May be either `ascending` (the default) or `descending`."
  default     = "ascending"

  validation {
    condition     = contains(["ascending", "descending"], var.rank_order)
    error_message = "Variablee rank_order must be one if the following: ascending, descending."
  }
}

variable "success_on_empty_node_filter" {
  type        = bool
  description = "Boolean determining if an empty node filter yields a successful result. Default: `false`"
  default     = false
}

variable "preserve_options_order" {
  type        = bool
  description = "Boolean controlling whether the configured options will be presented in their configuration order when shown in the Rundeck UI. The default is false, which means that the options will be displayed in alphabetical order by name."
  default     = false
}

variable "command_ordering_strategy" {
  type        = string
  description = "The name of the strategy used to describe how to traverse the matrix of nodes and commands. The default is `node-first`, meaning that all commands will be executed on a single node before moving on to the next. May also be set to `step-first`, meaning that a single step will be executed across all nodes before moving on to the next step."
  default     = "node-first"

  validation {
    condition     = contains(["node-first", "step-first"], var.command_ordering_strategy)
    error_message = "Variable command_ordering_strategy must be one of: node-first, step-first."
  }
}

variable "node_filter_query" {
  type        = string
  description = "A query string using Rundeck's node filter language that defines which subset of the project's nodes will be used to execute this job."
  default     = null
}

variable "node_filter_exclude_precedence" {
  type        = bool
  description = "Boolean controlling a deprecated Rundeck feature that controls whether node exclusions take priority over inclusions. Default: `false`"
  default     = false
}

variable "options" {
  type = list(object({
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
  description = "Nested block defining an option a user may set when executing this job. A job may have any number of options."
  default     = []
}

variable "commands" {
  type = list(object({
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
      node_filters      = optional(map(any))
    })))

    # node_step_plugin and step_plugin blocks (optional)
    # plugin = (node_step_plugin || step_plugin)
    steps = optional(list(object({
      plugin = string
      type   = string
      config = optional(map(any))
    })))
  }))
  description = "Nested block defining one step in the job workflow. A job must have one or more commands."
}

variable "notifications" {
  type = list(object({
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
  description = "Nested block defining notifications on the job workflow."
  default     = []
}
