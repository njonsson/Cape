Feature: The #mirror_rake_tasks DSL method with a different directory

  In order to include Rake tasks with descriptions in my Capistrano recipes,
  As a developer using Cape,
  I want to use the Cape DSL.

  Scenario: mirror a Rake task with its implementation, using a Capistrano variable inside a lambda
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :release_path, '/release/path'

      Cape do
        mirror_rake_tasks do |recipes|
          recipes.cd lambda { release_path }
        end
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing `with_period'
        * executing "cd /release/path && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake with_period"
      `with_period' is only run for servers matching {}, but no servers matched
      """

  Scenario: mirror a Rake task with its implementation, using a Capistrano variable inside a block
    Given a full-featured Rakefile
    And a Capfile with:
      """
      set :release_path, '/release/path'

      Cape do
        mirror_rake_tasks do |recipes|
          recipes.cd { release_path }
        end
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing `with_period'
        * executing "cd /release/path && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake with_period"
      `with_period' is only run for servers matching {}, but no servers matched
      """

  Scenario: mirror a Rake task with its implementation, using a string
    Given a full-featured Rakefile
    And a Capfile with:
      """
      Cape do
        mirror_rake_tasks do |recipes|
          recipes.cd '/release/path'
        end
      end
      """
    When I run `cap with_period`
    Then the output should contain:
      """
        * executing `with_period'
        * executing "cd /release/path && /usr/bin/env `/usr/bin/env bundle check >/dev/null 2>&1; case $? in 0|1 ) echo bundle exec ;; esac` rake with_period"
      `with_period' is only run for servers matching {}, but no servers matched
      """
