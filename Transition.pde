class Transition {   

  public boolean enabled = true;
  public float songPosition = 0;
  public boolean selected = false;
 
  public ArrayList<Actor> actors = new ArrayList<Actor>();
  
  public Transition(){
    // Thought i needed this dummy actor because of empty actor json array parsing issues but it seems ok so leave out for now 
    //Actor dummy = new Actor( "dummy-" + actors.size(), constants.TYPE_None);  // add a default dummy action to every transition so the JSON format works ok.
    //actors.add(dummy);    
  }

  public Transition( Transition toclone){
    enabled = toclone.enabled;
    songPosition = toclone.songPosition;
    selected = toclone.selected;
    actors = toclone.actors;      
  }

  void debug(){      println( utility.getObjectJson(this));
   println(""); 
  }
  
  void set(){       
   //debug("");        
  }     

}
