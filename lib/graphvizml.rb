#!/usr/bin/env ruby

# file: graphvizml.rb


require 'domle'
require 'graphviz'
require 'line-tree'
require 'tempfile'


module RegGem

  def self.register()
'
hkey_gems
  doctype
    graphvizml
      require graphvizml
      class GraphVizML
      media_type svg
'
  end
end

class GraphVizML
  using ColouredText

  attr_accessor :css, :stroke, :fill, :text_color
  attr_reader :g

  def initialize(obj=nil, debug: false, fill: 'transparent', stroke: '#000', text_color: '#000')

    @debug = debug
    @fill, @stroke, @text_color = fill, stroke, text_color

    if obj then


      xml = if obj.is_a? Rexle or obj.is_a? Rexle::Element

        obj.xml

      else

        s = RXFHelper.read(obj).first

        if  s =~ /<\?graphvizml\b/ then

          import_string s

        else

          if @debug then
            #File.write '/tmp/graphviz.xml', xml
            puts('graphvizml xml: ' + s.inspect)
          end

          s

        end

      end

      @g = build_from_nodes Domle.new(xml)

    end

    @css = "
      .node ellipse {stroke: #{stroke}; fill: #{fill}}
      .node text {fill: #{text_color}}
      .edge path {stroke: #{stroke}}
      .edge polygon {stroke: #{stroke}; fill: #{stroke}}
    "

  end

  def import(obj)

    s = RXFHelper.read(obj).first
    xml = import_string s
    puts('graphvizml/import xml: ' + xml.inspect).debug if @debug
    @g = build_from_nodes Domle.new(xml)
    self

  end


  def to_dot()

    @g.to_dot

  end


  # returns an SVG blob
  #
  def to_svg()
    f = Tempfile.new('graphvizml')
    #jr 26-01-2022 Graphviz::output(@g, format: 'svg', path: f.path)
    Graphviz.output(@g, path: f.path, format: 'svg')
    s = File.read f.path
    #s.sub!('xmlns:xlink="http://www.w3.org/1999/xlink"','')
    #s.sub!('xlink:','') # not yet implemented because of a local namespace issue
    s.lines.insert(8, css_code()).join
  end


  private


  def build_from_nodes(doc)

    puts 'inside build_from_nodes'.info if @debug

    g = Graphviz::Graph.new **format_summary_attributes(doc.root.attributes)

    # add the nodes

    nodes = doc.root.xpath('//node').inject({}) do |r,e|

      r.merge fetch_node(e)

    end

    if @debug then
      puts 'nodes: ' + nodes.inspect
      puts 'doc: ' + doc.root.xml.inspect
    end

    a = doc.root.element('style/text()').to_s.strip.split(/}/).map do |entry|

      puts 'entry: ' + entry.inspect if @debug

      raw_selector,raw_styles = entry.split(/{/,2)

      h = raw_styles.strip.split(/;/).inject({}) do |r, x|
        k, v = x.split(/:/,2).map(&:strip)
        r.merge(k.to_sym => v)
      end

      [raw_selector.split(/,\s*/).map(&:strip), h]
    end

    puts ' a: ' + a.inspect if @debug


    edge_style = a.any? ? a.find {|x| x[0].grep(/edge/).any?}.last : []



    # add the edges

    id_1 = nodes.first[0]
    nodes[id_1][-1] = g.add_node(nodes[id_1][0])


    doc.root.each_recursive do |node|

      next unless node.name == 'node'

      node.xpath('a/node | node').each do |child|

        id1, id2 = node.object_id, child.object_id

        label = child.attributes[:connection].to_s
        puts('nodes[id1]: ' + nodes[id1].inspect) if @debug
        puts('nodes[id1].last: ' + nodes[id1].last.inspect) if @debug
        nodes[id2][-1] ||= nodes[id1].last.add_node(nodes[id2][0])
        attributes = child.style.merge({label: label})

        conn = nodes[id1][-1].connections.last
        conn.attributes[:label] = label

        edge_style.each {|key,val| conn.attributes[key] = m(val) }

      end
    end

    format_attributes nodes

    g

  end

  def css_code()
<<EOF
	<defs>
		<style type='text/css'><![CDATA[
      #{@css}
		]]></style>
	</defs>

EOF
  end

  def fetch_node(node)

    puts 'inside fetch_node'.info if @debug

    h = node.attributes
    #puts 'h: ' + h.inspect
    puts('graphvizml/fetch_node h: ' + h.inspect) if @debug

    if node.parent.name == 'a' then

      url = node.parent.attributes[:href]
      h[:url] = url if url

    end

    id = h[:gid] || node.object_id
    label = node.text('label')

    # shape options:  box, ellipse, record, diamond, circle, polygon, point

    style = {}

    style[:shape] = h[:shape] if h[:shape] and !h[:shape].empty?
    style[:URL] = h[:url] if h[:url]

    #puts "adding node id: %s label: %s" % [id, label]

    # the nil is replaced by the Graphviz node object
    {id => [label, node.style.merge(style), nil]}

  end

  def format_attributes(nodes)

    nodes.each do |id, x|

      _, attributes, obj = x
      next unless obj
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


  def import_string(s)


    s2 = s.slice!(/<\?graphvizml\b[^>]*\?>/)

    if s2 then

      attributes = %w(id fill stroke text_color).inject({}) do |r, keyword|
        found = s2[/(?<=#{keyword}=['"])[^'"]+/]
        found ? r.merge(keyword.to_sym => found) : r
      end

    fill, stroke, text_color = %i(fill stroke text_color).map do |x|
      attributes[x] ? attributes[x] : method(x).call
    end

    @css = "
      .node ellipse {stroke: #{stroke}; fill: #{fill}}
      .node text {fill: #{text_color}}
      .edge path {stroke: #{stroke}}
      .edge polygon {stroke: #{stroke}; fill: #{stroke}}
    "

    end

    xml = LineTree.new(s, root: 'nodes', debug: @debug).to_xml

  end

  # modify the value if it matches the following criteria
  #
  def m(s)

    # is it a shorthand hexcode? e.g. #fff
    s.gsub(/^#([\da-f]{3})$/)\
        { '#' + ($1).chars.inject([]) {|r,x| r << x + x}.join}
  end

end
