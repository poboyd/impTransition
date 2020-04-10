class Walls  extends ActorOnStage {   
    
  public int wallMode = 2;
  public int numberOfWalls = 800;
  private Wall[] wall;
  
  void debug(){   
   println( utility.getObjectJson(this));
   println(""); 
  }
       
  Walls() {
    super(Constants.TYPE_Walls);
        
    wall = new Wall[numberOfWalls];

    for (int i = 0; i < numberOfWalls; i+=4) {
      wall[i] = new Wall(0, height/2, 10, height);
    }
  
    for (int i = 1; i < numberOfWalls; i+=4) {
      wall[i] = new Wall(width, height/2, 10, height);
    }
  
    for (int i = 2; i < numberOfWalls; i+=4) {
      wall[i] = new Wall(width/2, height, width, 10);
    }
  
    for (int i = 3; i < numberOfWalls; i+=4) {
      wall[i] = new Wall(width/2, 0, width, 10);
    }
  }


  @Override 
  void draw(AudioFFT audioFFT) {
    if (!enabled)
      return;               
                    
     beginShape();
    // Walls rectangles
    for (int i = 0; i < numberOfWalls; i++)
    {
      // Each wall is assigned a band, and its amplitude is sent to it.
      float intensity = audioFFT.fft.getBand(i%((int)(audioFFT.fft.specSize()*audioFFT.specHi)));
      wall[i].draw( audioFFT.scoreLow, audioFFT.scoreMid, audioFFT.scoreHi, intensity, audioFFT.scoreGlobal, mode);
    }          
    endShape();
  }

}
