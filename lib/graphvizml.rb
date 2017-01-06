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

  end

  def to_png(filename=@filename.sub(/\.xml$/,'.png'))

    e_options = @doc.root.element 'options'
    e_nodes = @doc.root.element 'nodes'
    e_edges = @doc.root.element 'edges'

    # set global node options

    xpath_node = "records/option[summary/type='node']/records/attribute"
    e_options.root.xpath(xpath_node).each do |attribute|
      @g.node[attribute.text('name').to_sym] = attribute.text('value')
    end

    xpath_edge = "records/option[summary/type='edge']/records/attribute"
    e_options.root.xpath(xpath_edge).each do |attribute|
      @g.edge[attribute.text('name').to_sym] = attribute.text('value')
    end

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

    # output the file

    out_type = e_edges.root.text('summary/output_type')
    out_file = e_edges.root.text('summary/output_file')
    @g.output( png: filename )
  end

end
