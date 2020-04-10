abstract class ActorOnStage {   
  
  public boolean enabled = true;  
  public int type;
  public int mode;
  
  public float size=20;
  public float strokeWeight=2;
  
  public float red=random(254);
  public float green=random(254);
  public float blue=random(254);
  public float alpha=random(254);
  
  public float timeToLive = 0;
  public float endFade = 0;  
 
   
  ActorOnStage(int thistype) {  
    type = thistype; 
  }
  
  void draw(AudioFFT audioFFT){
    
  }
  
}
