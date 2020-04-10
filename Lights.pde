class Lights {   

  public float ambLightRed=0;
  public float ambLightGreen=0;
  public float ambLightBlue=0;
  
  void debug(){   
   println( utility.getObjectJson(this));
   println(""); 
  }
  
  void set(){
    
    // NEVER MANAGED TO GET ANY OF THESE WORKING
    return;
  
    //lights();
    //pointLight(ambLightRed, ambLightGreen, ambLightBlue, width/2, height/2, 100);  
    //directionalLight(ambLightRed, ambLightGreen, ambLightBlue, 0, -1, 0);
    //ambientLight( ambLightRed, ambLightGreen, ambLightBlue);
    //lightFalloff(1.0, 0.001, 0.0);
  }   

}
