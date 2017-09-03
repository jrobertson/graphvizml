#!/usr/bin/env ruby

# file: graphvizml.rb


require 'rexle'
require 'graphviz'


class GraphVizML

  attr_reader :g

  def initialize(obj)
    
    @doc = if obj.is_a? String then
            
      Rexle.new(File.read @filename=obj)
      
    elsif obj.is_a? Rexle
      
      @filename = 'gvml.xml'
      obj

    end
    
    h = @doc.root.attributes

    @type = h.has_key?(:type) ? h[:type].to_sym : :digraph
    direction = h.has_key?(:direction) ? h[:direction].to_s.upcase : 'LR'
    
    @g = GraphViz::new( :G, type: @type)
    @g[:rankdir] = direction
    
    build()

  end

  # writes to a PNG file (not a PNG blob)
  #
  def to_png(filename=@filename.sub(/\.xml$/,'.png'))
    @g.output( :png => filename )
  end
  
  # writes to a SVG file (not an SVG blob)
  #
  def to_svg(filename=@filename.sub(/\.xml$/,'.svg'))
    @g.output( :svg => filename )
  end  
  
  private
  
  def build
    
    style = @doc.root.element('style')
    
    stylesheet = style ? style.text : default_stylesheet()

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

      h =node.attributes
      id = h[:id]
      label = node.text('label')
      
      # shape options:  box, ellipse, record, diamond, circle, polygon, point
      shape = h.has_key?(:shape) ? h[:shape] : :box
      #puts "adding node id: %s label: %s" % [id, label]
      @g.add_node(id, shape: shape).label = label
    end

    # add the edges

    e_edges.root.xpath('records/edge').each do |edge|

      a = edge.xpath('records/node')

      id1, id2 = a[0].attribute('id').to_s, a[1].attribute('id').to_s
      label = edge.text('summary/label').to_s
      #puts "adding edge id1: %s id2: %s label: %s" % [id1, id2, label]
      @g.add_edge(id1, id2).label = label
    end    
    
    :build
  end
  
  private
  
  def default_stylesheet()

<<STYLE
  node { 
    color: #ddaa66; 
    fillcolor: #ffeeee;
    fontcolor: #113377; 
    fontname: Trebuchet MS; 
    fontsize: 9; 
    margin: 0.1;
    penwidth: 1.3; 
    shape: box; 
    style: filled;
  }

  edge {
    arrowsize: 0.9;
    color: #999999; 
    fontcolor: #444444; 
    fontname: Verdana; 
    fontsize: 9; 
    #{@type == :digraph ? 'dir: forward;' : ''}
    weight: 1;
  }    
  
STYLE
  end

end