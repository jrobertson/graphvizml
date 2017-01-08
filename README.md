# Introducing the GraphVizML gem

## Prerequisites

* install the software package *graphviz*
* install the gem *graphvizml*

## Example

    require 'graphvizml'

    gvml = GraphVizML.new('gvml.xml')
    gvml.to_png

Input file: gvml.xml

<pre>
&lt;?xml version='1.0' encoding='UTF-8'?&gt;
&lt;gvml&gt;
  &lt;style&gt;
  node { 
    color: #ddaa66; 
    fillcolor: #775500;
    fontcolor: #ffeecc; 
    fontname: Trebuchet MS; 
    fontsize: 8; 
    margin: 0.0;
    penwidth: 1; 
    shape: box; 
    style: filled;
  }

  edge {
    arrowsize: 0.5;
    color: #999999; 
    fontcolor: #444444; 
    fontname: Verdana; 
    fontsize: 8; 
    dir: forward;
    weight: 1;
  }
&lt;/style&gt;
  &lt;nodes&gt;
    &lt;summary/&gt;
    &lt;records&gt;
      &lt;node id='1'&gt;
        &lt;label&gt;hello&lt;/label&gt;
      &lt;/node&gt;
      &lt;node id='2'&gt;
        &lt;label&gt;world&lt;/label&gt;
      &lt;/node&gt;
      &lt;node id='3'&gt;
        &lt;label&gt;fun&lt;/label&gt;
      &lt;/node&gt;
      &lt;node id='4'&gt;
        &lt;label&gt;run&lt;/label&gt;
      &lt;/node&gt;
      &lt;node id='5'&gt;
        &lt;label&gt;walk&lt;/label&gt;
      &lt;/node&gt;
    &lt;/records&gt;
  &lt;/nodes&gt;
  &lt;edges&gt;
    &lt;summary/&gt;
    &lt;records&gt;
      &lt;edge id='e1'&gt;
        &lt;summary&gt;
          &lt;label&gt;link 1&lt;/label&gt;
        &lt;/summary&gt;
        &lt;records&gt;
          &lt;node id='1'&gt;
            &lt;label&gt;hello2&lt;/label&gt;
          &lt;/node&gt;
          &lt;node id='2'&gt;
            &lt;label&gt;world&lt;/label&gt;
          &lt;/node&gt;
        &lt;/records&gt;
      &lt;/edge&gt;
      &lt;edge id='e2'&gt;
        &lt;summary&gt;
          &lt;label&gt;link 2&lt;/label&gt;
        &lt;/summary&gt;
        &lt;records&gt;
          &lt;node id='2'&gt;
            &lt;label&gt;world&lt;/label&gt;
          &lt;/node&gt;
          &lt;node id='4'&gt;
            &lt;label&gt;run&lt;/label&gt;
          &lt;/node&gt;
        &lt;/records&gt;
      &lt;/edge&gt;
      &lt;edge id='e3'&gt;
        &lt;summary&gt;
          &lt;label&gt;link 3&lt;/label&gt;
        &lt;/summary&gt;
        &lt;records&gt;
          &lt;node id='2'&gt;
            &lt;label&gt;world&lt;/label&gt;
          &lt;/node&gt;
          &lt;node id='5'&gt;
            &lt;label&gt;walk&lt;/label&gt;
          &lt;/node&gt;
        &lt;/records&gt;
      &lt;/edge&gt;
      &lt;edge id='e4'&gt;
        &lt;summary&gt;
          &lt;label&gt;link 4&lt;/label&gt;
        &lt;/summary&gt;
        &lt;records&gt;
          &lt;node id='5'&gt;
            &lt;label&gt;walk&lt;/label&gt;
          &lt;/node&gt;
          &lt;node id='3'&gt;
            &lt;label&gt;fun&lt;/label&gt;
          &lt;/node&gt;
        &lt;/records&gt;
      &lt;/edge&gt;
      &lt;edge id='e5'&gt;
        &lt;summary&gt;
          &lt;label&gt;link 5&lt;/label&gt;
        &lt;/summary&gt;
        &lt;records&gt;
          &lt;node id='1'&gt;
            &lt;label&gt;hello2&lt;/label&gt;
          &lt;/node&gt;
          &lt;node id='3'&gt;
            &lt;label&gt;fun&lt;/label&gt;
          &lt;/node&gt;
        &lt;/records&gt;
      &lt;/edge&gt;
    &lt;/records&gt;
  &lt;/edges&gt;
&lt;/gvml&gt;
</pre>

Output:

![screenshot of the output](http://www.jamesrobertson.eu/twitxr/168496.jpg)

## Resources

* A simple Ruby-graphviz example http://www.jamesrobertson.eu/snippets/2014/apr/04/a-simple-ruby-graphviz-example.html
* Make a diagram using XML and Graphviz http://www.jamesrobertson.eu/snippets/2014/apr/10/make-a-diagram-using-xml-and-graphviz.html

graphviz xml graphvizml png
