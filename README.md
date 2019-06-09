# Importing a raw document into GraphVizML

    require 'graphvizml'

    s = "
    <?graphvizml?>

    node
      label a1
      node
        label a2
    "

    gvml = GraphVizML.new(s)
    File.write '/tmp/graph.svg', gvml.to_svg
    `firefox /tmp/graph.svg`

Output:

!s[](#graphviz)

graphvizml graphviz

__DATA__

<?graphvizml id="graphviz"?>

node
  label a1
  node
    label a2
