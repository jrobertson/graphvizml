Gem::Specification.new do |s|
  s.name = 'graphvizml'
  s.version = '0.1.2'
  s.summary = 'Generates a PNG file from GraphViz using a GraphViz Markup Language file'
  s.authors = ['James Robertson']
  s.files = Dir['lib/graphvizml.rb']
  s.add_runtime_dependency('rexle', '~> 1.4', '>=1.4.3')
  s.add_runtime_dependency('ruby-graphviz', '~> 1.2', '>=1.2.2')
  s.signing_key = '../privatekeys/graphvizml.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/graphvizml'
end
