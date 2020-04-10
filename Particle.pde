// A simple Particle class, renders the particle as an image

class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float lifespan;
  float lifespanAdj;
  float lifespanOriginal;
  
  int red;
  int green;
  int blue;
  
  float pWidth;
  float pHeight;
  float currentSize;
  
  float vx;
  float vy; 

  int particleType = 1;


 void debug(){   
   println( utility.getObjectJson(this));
   println(""); 
  }
  
   static final int TYPE_MOVING = 1;
   static final int TYPE_STATIC = 0;


  Particle(PVector l, int red_, int green_, int blue_, float pWidth_, float pHeight_, float lifespan_, float lifespanAdj_, int particleType_) {
    acc = new PVector(0, 0);
      
    particleType = particleType_;
      
    if (particleType==TYPE_STATIC){
      vx = 0;
      vy = 0;
    }
    else{
      vx = randomGaussian()*0.3;
      vy = randomGaussian()*0.3;
    }
            
    vel = new PVector(vx, vy);
    
    loc = l.copy();
      
    lifespan = lifespan_;
    lifespanAdj = lifespanAdj_;
    lifespanOriginal =  lifespan; 
    
    currentSize = 0;
    
    red = red_;
    green = green_;
    blue = blue_;
   
    pWidth = pWidth_;
    pHeight = pHeight_;
   
  }

  void reset() {
    reset(pWidth);
  }

  void reset(float newWidth) {
     currentSize = 0;
     lifespan = lifespanOriginal;
     pWidth = newWidth;
  }
  
  
  void run() {
    
    if (isDead())
       return;
    update();
    render();
  }

  void applyForce(PVector f) {
    if (particleType!=TYPE_STATIC)
      acc.add(f);
  }  

  void update() {
    vel.add(acc);
    loc.add(vel);
    lifespan -= lifespanAdj;
    acc.mult(0); // clear Acceleration
    
    if (particleType==TYPE_STATIC && currentSize<pWidth)
       currentSize = currentSize + 5;
    else
       currentSize = pWidth;
  }

  void render() {   
         
     //println( "red:" + red + "  green:" + green + "  blue:" + blue);                   
       
     pushMatrix();                
     
     translate(loc.x,loc.y, -100);     
     
     fill(red, green, blue, lifespan);
              
     sphere(currentSize);               
     
     popMatrix();      
                     
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
  
  void kill()
  {
    lifespan = 0;
  }
}
