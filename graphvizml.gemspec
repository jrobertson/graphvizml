Gem::Specification.new do |s|
  s.name = 'graphvizml'
  s.version = '0.7.0'
  s.summary = 'Generates an SVG file from GraphViz using a ' + 
      'GraphViz Markup Language file'
  s.authors = ['James Robertson']
  s.files = Dir['lib/graphvizml.rb']
  s.add_runtime_dependency('domle', '~> 0.5', '>=0.5.3')
  s.add_runtime_dependency('graphviz', '~> 1.2', '>=1.2.1')
  s.add_runtime_dependency('line-tree', '~> 0.9', '>=0.9.3')
  s.signing_key = '../privatekeys/graphvizml.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/graphvizml'
  s.required_ruby_version = '>= 3.0.2'
end
