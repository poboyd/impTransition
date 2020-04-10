// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  boolean enabled=false;
  
  ArrayList<Particle> particles;    // An arraylist for all the particles
  
  ArrayList<PVector> origin;                   // An origin point for where particles are birthed  
   
  float pWidth;
  float pHeight;
   
  int pRed;
  int pGreen;
  int pBlue;
    
  float lifespan;

  float lifespanAdj;
  
  int particleType;
  int particleSystemType ;  
    
  static final int TYPE_CLOUDS = 1;
  static final int TYPE_STATIC_4 = 0;
   
  void debug(){   
   println( utility.getObjectJson(this));
   println(""); 
  }
  
  void drawParticleSystem()
  {    
    psEq.run();
    for (int i = 0; i < 2; i++) {
      if (enabled)
        psEq.addParticle();
    }
  }
  
  void drawParticleSystem4()
  {
     if (enabled)
        psStatic4.run();
  }
  
  ParticleSystem(int num, PVector v, float pWidth_, float pHeight_ , int pRed_, int pGreen_,int pBlue_, float lifespan_, float lifespanAdj_,  int particleType_, int particleSystemType_) {
    particles = new ArrayList<Particle>();              // Initialize the arraylist
    
    particleType = particleType_;
    particleSystemType = particleSystemType_;
    
    origin = new ArrayList<PVector>();
    
    if (particleSystemType == TYPE_CLOUDS )
    {
      origin.add(v.copy());
    } 
    else if (particleSystemType == TYPE_STATIC_4 ) 
    {
      origin.add( new PVector(v.x -700, v.y+350));
      origin.add( new PVector(v.x -700, v.y-350));
      origin.add( new PVector(v.x +700, v.y+350));
      origin.add( new PVector(v.x +700, v.y-350));             
    }
      
    pWidth = pWidth_;
    pHeight = pHeight_;
    
    pRed = pRed_;
    pGreen = pGreen_;
    pBlue = pBlue_;
  
    lifespan = lifespan_;
    lifespanAdj = lifespanAdj_;
      
    // Add "num" amount of particles to the arraylist  
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin.get(i), pRed==-1 ? floor(random(255)) : pRed
                                        , pGreen==-1 ? floor(random(255)) : pGreen
                                        , pBlue==-1 ? floor(random(255)) : pBlue
                                        , pWidth,  pHeight, lifespan, lifespanAdj
                                        , particleType ));             
    }
  
    
    if (particleSystemType == TYPE_STATIC_4 )
       killAll();
     
   
    //Particle p = particles.get(num-1);
    //println( "red:  " + p.red + "    green:" + p.green + "    blue:" + p.blue + "  lifespan:" + p.lifespan );
    
  }

  void killAll() {       
    for (int i = particles.size()-1; i >= 0; i--) {
       Particle p = particles.get(i);
       p.kill();
    }
  }
  
  void reset() {  
   if (particleSystemType == TYPE_STATIC_4 )
   {
      for (int i = particles.size()-1; i >= 0; i--) {
         Particle p = particles.get(i);
         p.reset();
      }
   }

  }

  void reset(float newWidth) {    
   
   if (particleSystemType == TYPE_STATIC_4 )
   {
      for (int i = particles.size()-1; i >= 0; i--) {
         Particle p = particles.get(i);
         p.reset(newWidth);
      }
   }
  }

  
  void run() {    
   
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (particleSystemType != TYPE_STATIC_4 && p.isDead()) 
        particles.remove(i);
     
    }
  }

  // Method to add a force vector to all particles currently in the system
  void applyForce(PVector dir) {    
    for (Particle p : particles) {
      p.applyForce(dir);
    }
  }  

  void addParticle() {
      
    particles.add(new Particle(origin.get(0), pRed==-1 ? floor(random(255)) : pRed
                                        , pGreen==-1 ? floor(random(255)) : pGreen
                                        , pBlue==-1 ? floor(random(255)) : pBlue
                                        , pWidth,  pHeight, lifespan, lifespanAdj
                                        , particleType));                   
  }
}
