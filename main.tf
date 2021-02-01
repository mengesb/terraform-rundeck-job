#
# Terraform:: terraform-rundeck-job
# Plan:: main.tf
#

locals {
  commands = flatten([ for k, v in var.command : {
    description   = v.description
    shell_command = v.shell_command
    inline_script = v.inline_script
    script_file   = v.inline_script
    job = flatten([ for l, w in var.command_job : {
      name              = w.name
      group_name        = w.group_name
      run_for_each_node = w.run_for_each_node
      args              = w.args
      nodefilters       = lookup(var.command_job_nodefilters, l, null)
    } if l == k])
    node_step_plugin = flatten([ for m, x in var.command_node_step_plugin : {
      type   = x.type
      config = x.config
    } if m == k])
    step_plugin = flatten([ for n, y in var.command_step_plugin : {
      type   = y.type
      config = y.config
    } if n == k])
  }])
  notifications = flatten([ for k, v in var.notification : {
    type         = v.type
    webhook_urls = v.webhook_urls
    email = flatten([ for l, w in var.notification_email : {
      attach_log = w.attach_log
      recipients = w.recipients
      subject    = w.subject
    } if l == k])
    plugin = flatten([ for m, x in var.notification_plugin : {
      type   = x.type
      config = x.config
    } if m == k])
  }])
}

output "local-commands" {
  value = local.commands
}

resource "rundeck_job" "job" {
  name                           = var.name
  description                    = var.description
  project_name                   = var.project_name
  execution_enabled              = var.execution_enabled
  group_name                     = var.group_name
  log_level                      = var.log_level
  schedule                       = var.schedule
  schedule_enabled               = var.schedule_enabled
  allow_concurrent_executions    = var.allow_concurrent_executions
  max_thread_count               = var.max_thread_count
  continue_on_error              = var.continue_on_error
  rank_attribute                 = var.rank_attribute
  rank_order                     = var.rank_order
  success_on_empty_node_filter   = var.success_on_empty_node_filter
  preserve_options_order         = var.preserve_options_order
  command_ordering_strategy      = var.command_ordering_strategy
  node_filter_query              = var.node_filter_query
  node_filter_exclude_precedence = var.node_filter_exclude_precedence

  dynamic "option" {
    for_each = var.option

    content {
      name                      = option.value.name
      default_value             = option.value.default_value
      value_choices             = option.value.value_choices
      value_choices_url         = option.value.value_choices_url
      require_predefined_choice = option.value.require_predefined_choice
      validation_regex          = option.value.validation_regex
      description               = option.value.description
      required                  = option.value.required
      allow_multiple_values     = option.value.allow_multiple_values
      multi_value_delimiter     = option.value.multi_value_delimiter
      obscure_input             = option.value.obscure_input
      exposed_to_scripts        = option.value.exposed_to_scripts
    }
  }

  dynamic "command" {
    for_each = local.commands

    content {
      description   = command.value.description
      shell_command = command.value.shell_command
      inline_script = command.value.inline_script
      script_file   = command.value.inline_script

      dynamic "job" {
        for_each = command.value.job

        content {
          name              = job.value.name
          group_name        = job.value.group_name
          run_for_each_node = job.value.run_for_each_node
          args              = job.value.args
          nodefilters       = job.value.nodefilters
        }
      }

      dynamic "node_step_plugin" {
        for_each = command.value.node_step_plugin
        
        content {
          type   = node_step_plugin.value.type
          config = node_step_plugin.value.config
        }
      }

      dynamic "step_plugin" {
        for_each = command.value.step_plugin

        content {
          type   = step_plugin.value.type
          config = step_plugin.value.config
        }
      }
    }
  }

  dynamic "notification" {
    for_each = local.notifications

    content {
      type         = notification.value.type
      webhook_urls = notification.value.webhook_urls

      dynamic "email" {
        for_each = notification.value.email

        content {
          attach_log = email.value.attach_log
          recipients = email.value.recipients
          subject    = email.value.subject
        }
      }
      dynamic "plugin" {
        for_each = notification.value.plugin

        content {
          type   = plugin.value.type
          config = plugin.value.config
        }
      }
    }
  }
}