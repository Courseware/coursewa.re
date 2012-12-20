desc 'Run cane to check quality metrics'
begin
  require 'cane/rake_task'
  Cane::RakeTask.new(:quality) do |cane|
    cane.abc_max = 20
  end
rescue LoadError
  task :quality
  puts 'Cane is not installed, :quality task unavailable'
end

desc 'Show some QA details about the code'
task qa: [:stats, 'doc:stats', :quality] do
end
