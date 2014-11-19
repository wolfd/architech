require 'graphviz' # this loads the ruby-graphviz gem

def make_style_diagram(building)
  # initialize new Graphviz graph
  g = GraphViz.new(:G, :type => :digraph)
  g[:rankdir] = "LR"
  # set global node options
  g.node[:color] = "#ddaa66"
  g.node[:style] = "filled"
  g.node[:shape] = "box"
  g.node[:penwidth] = "1"
  g.node[:fontname] = "Trebuchet MS"
  g.node[:fontsize] = "8"
  g.node[:fillcolor]= "#ffeecc"
  g.node[:fontcolor]= "#775500"
  g.node[:margin] = "0.0" # set global edge options
  g.edge[:color] = "#999999"
  g.edge[:weight] = "1"
  g.edge[:fontsize] = "6"
  g.edge[:fontcolor]= "#444444"
  g.edge[:fontname] = "Verdana"
  g.edge[:dir] = "forward"
  g.edge[:arrowsize]= "0.5" # draw our nodes, i.e., plants

  start = g.add_node('Begin')
  recursively_define_graphviz(g, building.styleset, start)

  g.output(:png => 'style.png')

end

def recursively_define_graphviz(g, sty, parent)
  puts
  if sty.kind_of?(Hash)
    sty.each do |key, substy|
      next_parent = g.add_node(key)
      g.add_edges(parent, next_parent)
      if substy.empty?
      else
        recursively_define_graphviz(g, substy, next_parent)
      end
    end
  end
end