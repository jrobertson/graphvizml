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
&lt;gvml&gt;
  &lt;options&gt;
    &lt;summary/&gt;
    &lt;records&gt;
      &lt;option&gt;
        &lt;summary&gt;&lt;type&gt;node&lt;/type&gt;&lt;/summary&gt;
        &lt;records&gt;
          &lt;attribute&gt;&lt;name&gt;color&lt;/name&gt;&lt;value&gt;#ddaa66&lt;/value&gt;&lt;/attribute&gt;
          &lt;attribute&gt;&lt;name&gt;style&lt;/name&gt;&lt;value&gt;filled&lt;/value&gt;&lt;/attribute&gt;
          &lt;attribute&gt;&lt;name&gt;shape&lt;/name&gt;&lt;value&gt;box&lt;/value&gt;&lt;/attribute&gt;                    
          &lt;attribute&gt;&lt;name&gt;penwidth&lt;/name&gt;&lt;value&gt;1&lt;/value&gt;&lt;/attribute&gt;          
          &lt;attribute&gt;&lt;name&gt;fontname&lt;/name&gt;&lt;value&gt;Trebuchet MS&lt;/value&gt;&lt;/attribute&gt;
          &lt;attribute&gt;&lt;name&gt;fontsize&lt;/name&gt;&lt;value&gt;8&lt;/value&gt;&lt;/attribute&gt;                    
          &lt;attribute&gt;&lt;name&gt;fillcolor&lt;/name&gt;&lt;value&gt;#775500&lt;/value&gt;&lt;/attribute&gt;                    
          &lt;attribute&gt;&lt;name&gt;fontcolor&lt;/name&gt;&lt;value&gt;#ffeecc&lt;/value&gt;&lt;/attribute&gt;          
          &lt;attribute&gt;&lt;name&gt;margin&lt;/name&gt;&lt;value&gt;0.0&lt;/value&gt;&lt;/attribute&gt;
        &lt;/records&gt;
      &lt;/option&gt;
      &lt;option&gt;
        &lt;summary&gt;&lt;type&gt;edge&lt;/type&gt;&lt;/summary&gt;
        &lt;records&gt;
          &lt;attribute&gt;&lt;name&gt;color&lt;/name&gt;&lt;value&gt;#999999&lt;/value&gt;&lt;/attribute&gt;
          &lt;attribute&gt;&lt;name&gt;weight&lt;/name&gt;&lt;value&gt;1&lt;/value&gt;&lt;/attribute&gt;
          &lt;attribute&gt;&lt;name&gt;fontsize&lt;/name&gt;&lt;value&gt;6&lt;/value&gt;&lt;/attribute&gt;                    
          &lt;attribute&gt;&lt;name&gt;fontcolor&lt;/name&gt;&lt;value&gt;#444444&lt;/value&gt;&lt;/attribute&gt;          
          &lt;attribute&gt;&lt;name&gt;fontname&lt;/name&gt;&lt;value&gt;Verdana&lt;/value&gt;&lt;/attribute&gt;
          &lt;attribute&gt;&lt;name&gt;dir&lt;/name&gt;&lt;value&gt;forward&lt;/value&gt;&lt;/attribute&gt;                    
          &lt;attribute&gt;&lt;name&gt;arrowsize&lt;/name&gt;&lt;value&gt;0.5&lt;/value&gt;&lt;/attribute&gt;          
        &lt;/records&gt;    
      &lt;/option&gt;  
    &lt;/records&gt;
  &lt;/options&gt;
  &lt;nodes&gt;
    &lt;summary/&gt;
    &lt;records&gt;
      &lt;node id="123"&gt;&lt;label&gt;a&lt;/label&gt;&lt;/node&gt;
      &lt;node id="124"&gt;&lt;label&gt;b&lt;/label&gt;&lt;/node&gt;    
      &lt;node id="125"&gt;&lt;label&gt;c&lt;/label&gt;&lt;/node&gt;
      &lt;node id="126"&gt;&lt;label&gt;d&lt;/label&gt;&lt;/node&gt;
      &lt;node id="127"&gt;&lt;label&gt;e&lt;/label&gt;&lt;/node&gt;    
    &lt;/records&gt;
  &lt;/nodes&gt;

  &lt;edges&gt;
    &lt;summary/&gt;
    &lt;records&gt;
      &lt;edge id="201"&gt;
        &lt;summary&gt;&lt;label&gt;smart1&lt;/label&gt;&lt;/summary&gt;
        &lt;records&gt;
          &lt;node id="123"&gt;&lt;label&gt;a&lt;/label&gt;&lt;/node&gt;
          &lt;node id="124"&gt;&lt;label&gt;b&lt;/label&gt;&lt;/node&gt;    
        &lt;/records&gt;
      &lt;/edge&gt;
      &lt;edge id="202"&gt;
        &lt;summary&gt;&lt;label&gt;smart2&lt;/label&gt;&lt;/summary&gt;
        &lt;records&gt;
          &lt;node id="123"&gt;&lt;label&gt;a&lt;/label&gt;&lt;/node&gt;
          &lt;node id="125"&gt;&lt;label&gt;c&lt;/label&gt;&lt;/node&gt;
         &lt;/records&gt;
      &lt;/edge&gt;
      &lt;edge id="203"&gt;
        &lt;summary&gt;&lt;label&gt;smart3&lt;/label&gt;&lt;/summary&gt;
        &lt;records&gt;
          &lt;node id="123"&gt;&lt;label&gt;a&lt;/label&gt;&lt;/node&gt;
          &lt;node id="126"&gt;&lt;label&gt;d&lt;/label&gt;&lt;/node&gt;
        &lt;/records&gt;
      &lt;/edge&gt;
      &lt;edge id="204"&gt;
        &lt;summary&gt;&lt;label&gt;smart4&lt;/label&gt;&lt;/summary&gt;
        &lt;records&gt;    
          &lt;node id="123"&gt;&lt;label&gt;a&lt;/label&gt;&lt;/node&gt;
          &lt;node id="127"&gt;&lt;label&gt;e&lt;/label&gt;&lt;/node&gt;    
        &lt;/records&gt;
      &lt;/edge&gt;
      &lt;edge id="205"&gt;
        &lt;summary&gt;&lt;label&gt;smart5&lt;/label&gt;&lt;/summary&gt;
        &lt;records&gt;    
          &lt;node id="124"&gt;&lt;label&gt;b&lt;/label&gt;&lt;/node&gt;    
          &lt;node id="127"&gt;&lt;label&gt;e&lt;/label&gt;&lt;/node&gt;    
        &lt;/records&gt;
      &lt;/edge&gt;
      &lt;edge id="206"&gt;
        &lt;summary&gt;&lt;label&gt;smart6&lt;/label&gt;&lt;/summary&gt;
        &lt;records&gt;    
          &lt;node id="124"&gt;&lt;label&gt;b&lt;/label&gt;&lt;/node&gt;    
          &lt;node id="126"&gt;&lt;label&gt;d&lt;/label&gt;&lt;/node&gt;
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
