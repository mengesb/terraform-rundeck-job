#
# Terraform:: terraform-rundeck-job
# Plan:: main.tf
#

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
    for_each = var.options

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
    for_each = var.commands

    content {
      description   = command.value.description
      shell_command = command.value.shell_command
      inline_script = command.value.inline_script
      script_file   = command.value.inline_script

      dynamic "job" {
        for_each = command.value.jobs

        content {
          name              = job.value.name
          group_name        = job.value.group_name
          run_for_each_node = job.value.run_for_each_node
          args              = job.value.args

          dynamic "node_filters" {
            for_each = job.value.node_filters

            content {
              exclude_precedence = node_filters.value.exclude_precedence
              filter             = node_filters.value.filter
              exclude_filter     = node_filters.value.exclude_filter
            }
          }
        }
      }

      dynamic "node_step_plugin" {
        for_each = command.value.steps == null ? [] : [for j in command.value.steps : { type = j.type, config = j.config } if j.plugin == "node_step_plugin"]

        content {
          type   = node_step_plugin.value.type
          config = node_step_plugin.value.config
        }
      }

      dynamic "step_plugin" {
        for_each = command.value.steps == null ? [] : [for k in command.value.steps : { type = k.type, config = k.config } if k.plugin == "step_plugin"]

        content {
          type   = step_plugin.value.type
          config = step_plugin.value.config
        }
      }
    }
  }

  dynamic "notification" {
    for_each = var.notifications

    content {
      type         = notification.value.type
      webhook_urls = notification.value.webhook_urls

      dynamic "email" {
        for_each = notification.value.emails == null ? [] : [for e in notification.value.emails : { attach_log = e.attach_log, recipients = e.recipients, subject = e.subject }]

        content {
          attach_log = email.value.attach_log
          recipients = email.value.recipients
          subject    = email.value.subject
        }
      }

      dynamic "plugin" {
        for_each = notification.value.plugin == null ? [] : [for p in notification.value.plugins : { type = p.type, config = p.config }]

        content {
          type   = plugin.value.type
          config = plugin.value.config
        }
      }
    }
  }
}
