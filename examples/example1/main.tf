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
  command = {
    command_one = {
      description      = "Command block, index command_one"
      shell_command    = "echo 'Command block, index command_one'"
      inline_script    = null
      script_file      = null
      script_file_args = null
    }
    command_two = {
      description      = "Command block, index command_two"
      shell_command    = null
      inline_script    = null
      script_file      = null
      script_file_args = null
    }
    command_three = {
      description      = "Command block, index command_three"
      shell_command    = null
      inline_script    = null
      script_file      = null
      script_file_args = null
    }
    command_four = {
      description      = "Command block, index command_four"
      shell_command    = null
      inline_script    = null
      script_file      = null
      script_file_args = null
    }
    command_five = {
      description      = "Command block, index command_five"
      shell_command    = null
      inline_script    = null
      script_file      = null
      script_file_args = null
    }
  }

  command_job = {
    command_two = {
      name              = "command_job-command_two"
      group_name        = null
      run_for_each_node = null
      args              = null
    }
    command_three = {
      name              = "command_job-command_three"
      group_name        = null
      run_for_each_node = null
      args              = null
    }
  }

  command_job_nodefilters = {
    command_three = {
      excludeprecedence = false
      filter            = "*.*"
    }
  }

  command_node_step_plugin = {
    command_four = {
      type   = "command_four - type"
      config = {}
    }
  }

  command_step_plugin = {
    command_five = {
      type   = "command_five - type"
      config = {}
    }
  }
  
  # Module notification blocks
  notification = {
    notification_one = {
      type = "on_success"
      webhook_urls = ["http://localhost?index=notification_one"]
    }
    notification_two = {
      type = "email"
      webhook_urls = null
    }
  }

  notification_email = {
    notification_two = {
      attach_log = true
      recipients = ["root@localhost"]
      subject = "Notification two, email"
    }
  }
}