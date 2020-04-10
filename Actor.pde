class Actor {   
  
  public String name;
  public boolean enabled = true;  
  public int type;
  public int mode;
  
  public float size=20;
  public float strokeWeight=2;
  
  public float red=random(254);
  public float green=random(254);
  public float blue=random(254);
  public float alpha=random(254);
   
  Actor(String thisname, int thistype) {
    name = thisname;
    type = thistype; 
  }
  
  void debug(){   
   println( utility.getObjectJson(this));
   println(""); 
  }
  
}
