class Camera {   

  public boolean rotateCameraX;
  public boolean rotateCameraY;
  public boolean rotateCameraZ;  
  public float rotatingCamera;  
  public int rotatingCameraTurns;
  
  public float rotateBy;
  
  public float cameyeX=width/2;
  public float cameyeY=height/2;
  public float cameyeZ=600;
  
  public float cameyeHomeX=width/2;
  public float cameyeHomeY=height/2;
  public float cameyeHomeZ=600;
  
  public float camcenterX=width/2;
  public float camcenterY=height/2;
  public float camcenterZ=0;    
    
  public float camTripeyeX;
  public float camTripeyeY;
  public float camTripeyeZ;
  public  boolean goOnTrip = false;
  

  void debug(){   
   println( utility.getObjectJson(this));
   println(""); 
  }
    
  void reset(boolean thisrotateCameraX, boolean thisrotateCameraY, boolean thisrotateCameraZ, int thisrotatingCameraTurns ){    
    rotateCameraX= thisrotateCameraX;
    rotateCameraY=thisrotateCameraY;
    rotateCameraZ=thisrotateCameraZ; 
    rotatingCameraTurns=thisrotatingCameraTurns;

    rotatingCamera = 0;    
  }
  
  void setHome(){
    cameyeHomeX=cameyeX;
    cameyeHomeY=cameyeY;
    cameyeHomeZ=cameyeZ;
  }
  
  void moveToHome(){
    cameyeX=cameyeHomeX;
    cameyeY=cameyeHomeY;
    cameyeZ=cameyeHomeZ;
  }
  
   void set(){
  
    /*
     DEFAULT
     camera(  width/2, height/2, 300   // EYE
           , width/2, height/2, -300  // CENTRE
           , 0, 1, 0);                // AXIS FACING UP  
  */
  
    if (keyPressed){                 
      if (keyCode == UP) 
        cameyeY = cameyeY + 2;
      else if (keyCode == DOWN) 
        cameyeY  = cameyeY - 2;
      else if (keyCode == RIGHT) 
        cameyeX = cameyeX +2;
      else if (keyCode == LEFT) 
        cameyeX = cameyeX -2;
      else if (key == 'a') 
        cameyeZ = cameyeZ-2;
      else if (key == 'z'){
        cameyeZ = cameyeZ + 2;
        //println("ZOOM OUT");
       }
       else if (key == 'q'){
         moveToHome();
       }
       //println("cameyeX: "+cameyeX + "  cameyeY:"  +  cameyeY  +  "   cameyeZ:" + cameyeZ);
    }
    
    if (goOnTrip){
      cameyeX = cameyeX == camTripeyeX ? cameyeX : (cameyeX <camTripeyeX ? cameyeX+2 : cameyeX-2);
      cameyeY = cameyeY == camTripeyeY ? cameyeY : (cameyeY <camTripeyeY ? cameyeY+2 : cameyeY-2);
      cameyeZ = cameyeZ == camTripeyeZ ? cameyeZ : (cameyeZ <camTripeyeZ ? cameyeZ+2 : cameyeZ-2);
        
    }
    
    if (cameyeX == camTripeyeX &&  cameyeY == camTripeyeY &&  cameyeZ == camTripeyeZ) {
        //&& camcenterX == camTripcentreX && camcenterY == camTripcentreY && camcenterZ == camTripcentreZ){
        goOnTrip = false;    
    }
        
    beginCamera();
    camera(  cameyeX, cameyeY, cameyeZ   // EYE
           , camcenterX, camcenterY, camcenterZ  // CENTRE
           , 0, 1, 0);                // AXIS FACING UP
           
                                   
    if (rotatingCameraTurns>0)
    {        
      if (rotatingCamera >= 360){      
        rotatingCameraTurns = rotatingCameraTurns -1;
        rotatingCamera = 0;      
      }
      
      rotatingCamera = rotatingCamera + 1;
      rotateBy = rotatingCamera*TWO_PI/360;    
      
      if (rotateCameraY)  rotateY(rotateBy);
      if (rotateCameraX)  rotateX(rotateBy);
      if (rotateCameraZ)  rotateZ(rotateBy);
       
      //println("rotatingCamera: "+rotatingCamera  + "  rotateBy:"+ rotateBy);
    }
                   
    endCamera();
  }   

}
