class LineBackground {   

  public int i = 0; 
  public boolean enabled = true;
  
  void debug(){   
   println( utility.getObjectJson(this));
   println(""); 
  }
  
  void set(){
       
   //debug("");
        
  }     

  void draw() {  // this is run repeatedly.  

    if (!enabled) return;
 
    // set the color
    stroke(random(50), random(255), random(255), 100);
    strokeWeight(4);
    
    // draw the line
    line(i, 0, random(0, width), height);
    
    // move over a pixel
    if (i < width) {
        i++;
    } else {
        i = 0; 
    }
}
}
