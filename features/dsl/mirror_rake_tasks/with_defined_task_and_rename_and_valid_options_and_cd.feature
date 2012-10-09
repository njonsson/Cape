Feature: The #mirror_rake_tasks DSL method with a defined task, renaming logic, valid options, and a different directory

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror only the matching Rake task
    Given a full-featured Rakefile defining a Ruby-method-shadowing task
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks :load do |recipes|
          recipes.rename do |task_name|
            "do_#{task_name}"
          end
          recipes.options[:roles] = :app
          recipes.cd { release_path }
        end
      end
      """
    When I run `cap -vT`
    Then the output should contain:
      """
      cap do_load # A task that shadows a Ruby method.
      """
    And the output should not contain "period"
    And the output should not contain "my_namespace"

  Scenario: mirror the matching Rake task with its implementation
    Given a full-featured Rakefile defining a Ruby-method-shadowing task
    And a Capfile with:
      """
      set :release_path, '/release/path'

      Cape do
        mirror_rake_tasks :load do |recipes|
          recipes.rename do |task_name|
            "do_#{task_name}"
          end
          recipes.options[:roles] = :app
          recipes.cd { release_path }
        end
      end
      """
    When I run `cap do_load`
    Then the output should contain:
      """
        * executing `do_load'
        * executing "cd /release/path && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake load"
      `do_load' is only run for servers matching {:roles=>:app}, but no servers matched
      """
