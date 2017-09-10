#!/usr/bin/env ruby

# file: graphvizml.rb


require 'domle'
require 'graphviz'
require 'tempfile'


class GraphVizML

  attr_reader :g

  def initialize(obj)
    
    xml = if obj.is_a? String then
            
      File.read filename=obj
      
    elsif obj.is_a? Rexle or obj.is_a? Rexle::Element
      
      obj.xml

    end    
    
    doc = Domle.new(xml)    

    # check if the root node is gvml or nodes
    @g = if doc.root.name == 'gvml' then
      build_from_gvml doc
    elsif doc.root.name == 'nodes'
      build_from_nodes doc
    end

  end
  
  def to_dot()
    @g.to_dot
  end

  # returns a PNG blob
  #
  def to_png()
    f = Tempfile.new('graphvizml')
    Graphviz::output(@g, output_format: 'png', path: f.path)
    File.read f.path
  end
  
  # returns an SVG blob
  #
  def to_svg()
    f = Tempfile.new('graphvizml')
    Graphviz::output(@g, format: 'svg', path: f.path)
    File.read f.path
  end

  def write(filename)
    Graphviz::output(@g, :path => filename)
  end
  
  private
  
  def build_from_gvml(doc)
        
    g = Graphviz::Graph.new format_summary_attributes(doc.root.attributes) 

    e_nodes = doc.root.element 'nodes'
    e_edges = doc.root.element 'edges'


    # add the nodes    

    nodes = e_nodes.root.xpath('records/a | records/node').inject({}) do |r,e|
      
      r.merge fetch_node(e)

    end

    
    # add the edges    

    id_1 = e_edges.root.element('records/edge/records/node/attribute::gid').to_s
    nodes[id_1][-1] = g.add_node(nodes[id_1][0])

    e_edges.root.xpath('records/edge').each do |edge|

      id1, id2 = edge.xpath('records//node/attribute::gid').map(&:to_s)

      label = edge.text('summary/label').to_s
      #puts "adding edge id1: %s id2: %s label: %s" % [id1, id2, label]
      nodes[id2][-1] ||= nodes[id1].last.add_node(nodes[id2][0])
      attributes = edge.style.merge({label: label})
      
      conn = nodes[id1][-1].connections.last
      conn.attributes[:label] = label
      edge.style.each {|key,val| conn.attributes[key] = m(val) }
      
    end         
     
    format_attributes nodes

    return g
  end
  
  def build_from_nodes(doc)    

    
    g = Graphviz::Graph.new format_summary_attributes(doc.root.attributes) 
    

    # add the nodes    

    nodes = doc.root.xpath('//a | //node').inject({}) do |r,e|
      
      r.merge fetch_node(e)

    end    
    
    # add the edges    

    id_1 = nodes.first[0]
    nodes[id_1][-1] = g.add_node(nodes[id_1][0])    
    

    doc.root.each_recursive do |node|
      
      node.xpath('node').each do |child|                
        
        id1, id2 = node.object_id, child.object_id

        label = child.attributes[:connection].to_s
        #puts "adding edge id1: %s id2: %s label: %s" % [id1, id2, label]
        nodes[id2][-1] ||= nodes[id1].last.add_node(nodes[id2][0])
        attributes = child.style.merge({label: label})
        
        conn = nodes[id1][-1].connections.last
        conn.attributes[:label] = label
        child.style.each {|key,val| conn.attributes[key] = m(val) }    
              
      end
    end    
    
    format_attributes nodes    
    
    g
    
  end
  
  def fetch_node(e)
    
    node = if e.name == 'a' then
                    
      url = e.attributes[:href]
      child = e.element 'node'
      child.attributes[:url] = url
      
      child
    else
      e
    end
    
    h = node.attributes

    id = h[:gid] || node.object_id
    label = node.text('label')
    
    # shape options:  box, ellipse, record, diamond, circle, polygon, point
    
    style = {}
    style[:shape] = h[:shape] || 'box'
    style[:URL] = h[:url] if h[:url]
    
    #puts "adding node id: %s label: %s" % [id, label]
    
    # the nil is replaced by the Graphviz node object 
    {id => [label, node.style.merge(style), nil]}
    
  end
  
  def format_attributes(nodes)
    
    nodes.each do |id, x|
      
      _, attributes, obj = x
      attributes.each {|key, val| obj.attributes[key] = m(val) }
                                                      
    end    

  end
  
  def format_summary_attributes(h)
    
    type = (h.has_key?(:type) ? h[:type].to_sym : :digraph)    

    h[:type] = type.to_s
    h[:rankdir] = h.has_key?(:direction) ? h[:direction].to_s.upcase : 'LR'
    
    %i(recordx_type format_mask schema direction).each do |x| 
      h.delete x; h.delete x.to_s
    end
    
    # remove any entries with an empty value
    h.each {|key, value| h.delete key if value.empty?}    
    
    h
  end
  
  # modify the value if it matches the following criteria
  #
  def m(s)
    
    # is it a shorthand hexcode? e.g. #fff
    s.gsub(/^#([\da-f]{3})$/)\
        { '#' + ($1).chars.inject([]) {|r,x| r << x + x}.join}
  end
  
end