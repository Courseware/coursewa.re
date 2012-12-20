namespace :doc do
  desc 'Generate YARD documentation database'
  task :build do
    sh "yard doc --no-cache --no-stats --verbose -n app/**/**/*.rb"
  end

  desc 'Generate YARD documentation'
  task :generate do
    sh "yard doc --no-cache --no-save --no-stats --verbose app/**/**/*.rb"
  end

  desc 'Start a server for viewing project documentation'
  task server: [:build] do
    sh "yard server"
  end

  desc 'Show a short summary on project documentation summary'
  task :stats do
    sh "yard stats --list-undoc --no-save --no-cache app/**/**/*.rb"
  end
end
