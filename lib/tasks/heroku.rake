require 'resque/tasks'
require 'resque_scheduler/tasks'

task :schedule_and_work do
  if Process.fork
    sh "rake environment resque:work"
  else
    sh "rake resque:scheduler"
    Process.wait
  end
end