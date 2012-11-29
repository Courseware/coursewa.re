Fabrication.configure do |config|
  config.fabricator_path = [
    'spec/fabricators',
    # Load Coursewareable fabricators
    Coursewareable::Engine.root.join(
      'spec', 'fabricators').relative_path_from(Courseware::Application.root)
  ]
end
