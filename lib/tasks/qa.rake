begin
  require 'cane/rake_task'
  desc 'Run cane to check quality metrics'
  Cane::RakeTask.new(:quality)
rescue LoadError
  puts 'Cane is not installed, :quality task unavailable'
end

desc 'Show some QA details about the code'
task qa: [:stats, 'doc:stats', :quality] do
end
