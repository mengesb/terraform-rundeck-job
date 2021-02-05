module "rd_job" {
  source = "../../"
  # version      = null
  name         = "Example 1 - singleton usage"
  description  = "Example usage of the terraform rundeck module `job` as a singleton object"
  project_name = "example_project"

  # Module inputs
  # execution_enabled              = "" # Accepting the module's default
  # group_name                     = "" # Accepting the module's default
  # log_level                      = "" # Accepting the module's default
  # schedule                       = "" # Accepting the module's default
  # schedule_enabled               = "" # Accepting the module's default
  # allow_concurrent_executions    = "" # Accepting the module's default
  # max_thread_count               = "" # Accepting the module's default
  # continue_on_error              = "" # Accepting the module's default
  # rank_attribute                 = "" # Accepting the module's default
  # rank_order                     = "" # Accepting the module's default
  # success_on_empty_node_filter   = "" # Accepting the module's default
  # preserve_options_order         = "" # Accepting the module's default
  # command_ordering_strategy      = "" # Accepting the module's default
  # node_filter_query              = "" # Accepting the module's default
  # node_filter_exclude_precedence = "" # Accepting the module's default

  # Module command blocks
  commands = [
    {
      description = "command block"
      jobs = [
        {
          name = "job 1 in command block"
        },
        {
          name = "job 2 in command block"
        }
      ]
    }
  ]
}