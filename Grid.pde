class Grid extends ActorOnStage {   
     
  public float circleTargetRed=255;
  public float circleTargetGreen=255;
  public float circleTargetBlue=255;

  public float gridPointX;
  public float gridPointY;

  public float gridMovingFromX=640;
  public float gridMovingFromY=320;
 
  public float t = 0;   
  
  Grid(){
    super(Constants.TYPE_Grid);
  }
 
  void resetGrid(float thisgridPointX, float thisgridPointY, float thisgridMovingFromX, float thisgridMovingFromY ){
       
     //debug("");       
  
     gridPointX=thisgridPointX;
     gridPointY=thisgridPointY;
     gridMovingFromX=thisgridMovingFromX;
     gridMovingFromY=thisgridMovingFromY;
  }

  void setGridProperties(float movingFromX, float movingFromY, float targetRed, float targetGreen, float targetBlue ){
  
     if (movingFromX>-1) gridMovingFromX=movingFromX;    
     if (movingFromY>-1) gridMovingFromY=movingFromY;
     
     if (circleTargetRed>-1)  circleTargetRed=targetRed;
     if (circleTargetGreen>-1) circleTargetGreen=targetGreen;
     if (circleTargetBlue>-1) circleTargetBlue=targetBlue;                
  }

  @Override  
  void draw(AudioFFT audioFFT) {
     //debug("");    
     
    if (!enabled) return;
    
    size = audioFFT.scoreGlobal/100 ;
    if (audioFFT.scoreLow>700)
      size += (audioFFT.scoreLow<800 ? 5 : (audioFFT.scoreLow<1000) ? 10 : (audioFFT.scoreLow<1200 ? 30 : 20));
      
      
    if (gridPointX<gridMovingFromX) gridPointX++;
    if (gridPointX>gridMovingFromX) gridPointX--;
    
    if (gridPointY<gridMovingFromY) gridPointY++;
    if (gridPointY>gridMovingFromY) gridPointY--;
  
    //gridPointX = mouseX;
    //gridPointY = mouseY;
  
    // make a x and y grid of ellipses
    for (float x = 0; x <= width; x = x + 50) {
              
      for (float y = 0; y <= height; y = y + 50) {
        // starting point of each circle depends on mouse position
        float xAngle = map(gridPointX, 0, width, -4 * PI, 4 * PI);
        float yAngle = map(gridPointY, 0, height, -4 * PI, 4 * PI);
        // and also varies based on the particle's location
        float angle = xAngle * (x / width) + yAngle * (y / height);
  
        // each particle moves in a circle
        float myX = x + 20 * cos(2 * PI * t + angle);
        float myY = y + 20 * sin(2 * PI * t + angle);
  
        if (red<circleTargetRed) red+=0.001;    
        if (green<circleTargetGreen) green+=0.001;
        if (blue<circleTargetBlue) blue+=0.001;
  
        if (red>circleTargetRed) red-=0.001;    
        if (green>circleTargetGreen) green-=0.001;
        if (blue>circleTargetBlue) blue-=0.001;
  
         
        stroke(red, green, blue, 200);
        strokeWeight(strokeWeight);
        fill(red, green, blue, 200 ); 
        ellipse(myX, myY, size, size);                
       
        //println("circleSize:" + size + " circleRed:" + red + "  circleGreen:" + green + " circleBlue:" + blue +  "                   gridMovingFromX:"+ gridMovingFromX + "    gridMovingFromY:"  + gridMovingFromY);
      }
    }
  
    t = t + 0.01; // update time
  }
    
}
