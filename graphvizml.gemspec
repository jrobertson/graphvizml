Gem::Specification.new do |s|
  s.name = 'graphvizml'
  s.version = '0.6.1'
  s.summary = 'Generates an SVG file from GraphViz using a ' + 
      'GraphViz Markup Language file'
  s.authors = ['James Robertson']
  s.files = Dir['lib/graphvizml.rb']
  s.add_runtime_dependency('domle', '~> 0.3', '>=0.3.1')
  s.add_runtime_dependency('graphviz', '~> 1.1', '>=1.1.0')
  s.add_runtime_dependency('line-tree', '~> 0.8', '>=0.8.0')
  s.signing_key = '../privatekeys/graphvizml.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/graphvizml'
end
