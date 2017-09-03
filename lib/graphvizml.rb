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

    @type = (h.has_key?(:type) ? h[:type].to_sym : :digraph)
    direction = h.has_key?(:direction) ? h[:direction].to_s.upcase : 'LR'
    
    @g = Graphviz::Graph.new type: @type.to_s, rankdir: direction
    
    build()

  end

  # writes to a PNG file (not a PNG blob)
  #
  def to_png(filename=@filename.sub(/\.xml$/,'.png'))
    Graphviz::output(@g, :path => filename)
  end
  
  # writes to a SVG file (not an SVG blob)
  #
  def to_svg(filename=@filename.sub(/\.xml$/,'.svg'))
    Graphviz::output(@g, :path => filename)
  end  
  
  private
  
  def build
    
    e_nodes = @doc.root.element 'nodes'
    e_edges = @doc.root.element 'edges'

    # add the nodes
    
    nodes = {}

    nodes = e_nodes.root.xpath('records/node').inject({}) do |r,node|

      h =node.attributes
      id = h[:id]
      label = node.text('label')
      
      # shape options:  box, ellipse, record, diamond, circle, polygon, point
      shape = h.has_key?(:shape) ? h[:shape] : :box
      #puts "adding node id: %s label: %s" % [id, label]
      r.merge(id => [label, {shape: shape}, nil])
    end

    
    # add the edges    

    id_1 = e_edges.root.element('records/edge/records/node/attribute::id').to_s
    nodes[id_1][-1] = @g.add_node(nodes[id_1][0])


    e_edges.root.xpath('records/edge').each do |edge|

      id1, id2 = edge.xpath('records/node/attribute::id').map(&:to_s)

      label = edge.text('summary/label').to_s
      #puts "adding edge id1: %s id2: %s label: %s" % [id1, id2, label]
      nodes[id2][-1] ||= nodes[id1].last.add_node(nodes[id2][0])
      
    end 
    
    #puts @g.to_dot    
    
    # add the styling once the objects have been created
    
    style = @doc.root.element('style')
    
    stylesheet = style ? style.text : default_stylesheet()
    
    
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
    
    if node_style then
      
      nodes.each do |id, x|
        node_style.last.each {|key, value| x.last.attributes[key] = value }
      end      
    end
    
    edge_style = a.detect {|x| x.assoc 'edge'}
    
    if edge_style then

      nodes.each do |id,x|      
        x.last.connections.each do |conn|
          edge_style.last.each {|key, value| conn.attributes[key] = value }
        end
      end      
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