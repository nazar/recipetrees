module BranchesHelper


  def generate_forks_image(forks, current_recipe)
    # initialize new Graphviz graph
    g = GraphViz::new( "structs", "type" => "graph" )
    g[:rankdir] = "TB"
    g["size"] = "8,8"
    # set global node options
    g.node[:color]    = "#ddaa66"
    g.node[:style]    = "filled"
    g.node[:shape]    = "box"
    g.node[:penwidth] = "1"
    g.node[:fontsize] = "10"
    g.node[:fillcolor]= "#ffeecc"
    g.node[:fontcolor]= "#775500"
    g.node[:margin]   = "0.1"

    # set global edge options
    g.edge[:color]    = "#999999"
    g.edge[:weight]   = "1"
    g.edge[:fontsize] = "8"
    g.edge[:fontcolor]= "#444444"
    g.edge[:dir]      = "forward"
    g.edge[:arrowsize]= "0.5"


    #iterate through relations and build nodes
    forks.each do |recipe|
      node = g.add_node(recipe.id.to_s)
      node.label = truncate(recipe.name, :length => 30)
      node.fillcolor = "#ffffff" if recipe.id == current_recipe.id
      node.URL = recipe_path(recipe)
    end

    #get relation objects
    recipe_fork_ids = forks.collect{|recipe| recipe.recipe_fork_hold}
    recipe_forks = RecipeFork.all :conditions => {:id => recipe_fork_ids}

    #build edges
    recipe_forks.each do |recipe_fork|
      edge = g.add_edge(recipe_fork.from_recipe_id.to_s, recipe_fork.to_recipe_id.to_s)
      edge.label = recipe_fork.at_rev.to_s
    end

    #build image
    file_name = Rails.root.join('public', 'images', 'graphs', "recipe_#{current_recipe.id}.png")
    g.output( "output" => "png", :file => file_name )
    #map file
    map_file =  Rails.root.join('public', 'images', 'graphs', "recipe_#{current_recipe.id}.map")
    g.output("output" => 'cmapx', :file =>  map_file )
    #finally, return image_to to file
    image = image_tag(['graphs', "recipe_#{current_recipe.id}.png"].join('/'), :class => 'graph', :usemap => '#structs' )
    cmap = File.open(map_file, 'r') {|f| f.read}
    image + cmap
  end


end
