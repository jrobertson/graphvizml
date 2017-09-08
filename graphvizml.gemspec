Gem::Specification.new do |s|
  s.name = 'graphvizml'
  s.version = '0.5.3'
  s.summary = 'Generates an SVG file or PNG file from GraphViz using a GraphViz Markup Language file'
  s.authors = ['James Robertson']
  s.files = Dir['lib/graphvizml.rb']
  s.add_runtime_dependency('domle', '~> 0.2', '>=0.2.0')
  s.add_runtime_dependency('graphviz', '~> 0.4', '>=0.4.0')
  s.signing_key = '../privatekeys/graphvizml.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/graphvizml'
end
