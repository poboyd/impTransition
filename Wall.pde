class Wall {   

  
  
  void debug(){   
   println( utility.getObjectJson(this));
   println(""); 
  }
  
  float startingZ = -25000;
  float maxZ = 5000;

  //Valeurs de position
  float x, y, z;
  float sizeX, sizeY;
  
  Wall(float x, float y, float sizeX, float sizeY) {
    this.x = x;
    this.y = y;
    this.z = random(startingZ, maxZ);  

    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }

  //======= WALL COLORS ==========
  void draw(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal, int wallMode) {
   
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, scoreGlobal);

    // Make the lines disappear in the distance to give an illusion of fog
    fill(displayColor, ((scoreGlobal-5)/1000)*(255+(z/25)));
    fill(displayColor);
    noStroke();       
  
    pushMatrix();
   
    translate(x, y, z);
  
    if (intensity > 100) intensity = 100;
    scale(sizeX*(intensity/100), sizeY*(intensity/100), 10);

    
    if (wallMode==1)
      sphere(1);   
    else
      box(1);
    
       
    popMatrix();

    displayColor = color(scoreLow*0.5, scoreMid*0.5, scoreHi*0.5, scoreGlobal);
    fill(displayColor, (scoreGlobal/5000)*(255+(z/25)));
    pushMatrix();

    translate(x, y, z);

    scale(sizeX, sizeY, 10);

    if (wallMode==1)
      sphere(1);    
    else
      box(1);

    
    
    popMatrix();

    z+= (pow((scoreGlobal/150), 2));
    if (z >= maxZ) {
      z = startingZ;
    }
  }

}
