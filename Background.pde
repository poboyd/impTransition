class Background {   

  // Flat background colour
  public float red = 0;
  public float green = 0;
  public float blue = 0;
  
  public float randomRed = 2;
  public float randomGreen = 2;
  public float randomBlue = 2;
  
  public float maxColourChanger = 200;
  
  public int changeSpeed = 0;
  public int changeSpeedCount = 0;
    
  public boolean colourChanger = true;
  public boolean colourLighter = true;
  public boolean colourBlack = false;
  

  void debug(){   
   println( utility.getObjectJson(this));
   println(""); 
  }
  
  void draw(){
       
   //debug("");
   
    
   int(DISABLE_DEPTH_TEST);  
   
   changeSpeedCount++;
   
   if (colourChanger && changeSpeedCount>=changeSpeed)
   {             
     if (colourLighter && !colourBlack){
       red=red + random(randomRed);
       green=green + random(randomGreen);
       blue=blue + random(randomBlue);
       
       if (red>maxColourChanger || green>maxColourChanger || blue> maxColourChanger)
         colourLighter = false;
     }
     else{
       red--;
       green--;
       blue--;
     
       if (red<=0 && green<=0 && blue<=0){
         red=0;
         green=0;
         blue=0;     
         colourLighter = true;
       }
     }        
   }
   
   if (changeSpeedCount>changeSpeed)
     changeSpeedCount = 0;
   
   background(red, green, blue, 255); // translucent background (creates trails)
   
   hint(ENABLE_DEPTH_TEST);
  }     

}
