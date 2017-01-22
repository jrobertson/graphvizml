#!/usr/bin/env ruby

# file: graphvizml.rb


require 'rexle'
require 'graphviz'  # this loads the ruby-graphviz gem

class GraphVizML


  def initialize(obj)

    @g = GraphViz::new( "structs", "type" => "graph" )
    @g[:rankdir] = "LR"
    
    if obj.is_a? String then
      
      @filename = obj
      @doc = Rexle.new(File.read @filename)
      
    elsif obj.is_a? Rexle
      
      @filename = 'gvml.xml'
      @doc = obj

    end
    
    build()

  end

  def to_png(filename=@filename.sub(/\.xml$/,'.png'))
    @g.output( png: filename )
  end
  
  def to_svg(filename=@filename.sub(/\.xml$/,'.svg'))
    @g.output( svg: filename )
  end  
  
  private
  
  def build
    
    stylesheet = @doc.root.element('style').text
    e_nodes = @doc.root.element 'nodes'
    e_edges = @doc.root.element 'edges'

    # parse the stylesheet

    a = stylesheet.split(/}/)[0..-2].map do |entry|

      raw_selector,raw_styles = entry.split(/{/,2)

      h = raw_styles.strip.split(/;/).inject({}) do |r, x| 
        k, v = x.split(/:/,2).map(&:strip)
        r.merge(k.to_sym => v)
      end

      [raw_selector.split(/,\s*/).map(&:strip), h]
    end      
    
    node_style = a.detect {|x| x.assoc 'node'}
    node_style.last.each {|key, value|  @g.node[key] = value } if node_style
    
    edge_style = a.detect {|x| x.assoc 'edge'}
    edge_style.last.each {|key, value| @g.edge[key] = value } if edge_style


    # add the nodes

    e_nodes.root.xpath('records/node').each do |node|
      @g.add_node(node.attribute('id').to_s).label = node.text('label')
    end

    # add the edges

    e_edges.root.xpath('records/edge').each do |edge|

      a = edge.xpath('records/node')
      @g.add_edge(a[0].attribute('id').to_s, 
        a[1].attribute('id').to_s).label = edge.text('summary/label').to_s
    end    
  end

end