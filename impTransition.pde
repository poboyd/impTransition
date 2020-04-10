import ddf.minim.*;
import ddf.minim.analysis.*;
import java.util.*;
import java.lang.reflect.*;
import controlP5.*;

ControlP5 cp5; // you always need the main class
Utility utility;
Background background;
AudioFFT audioFFT;
Lights lights;
Camera camera;
LineEQ lineEQ;
LineEQ transitionsLineEQ;
ParticleSystem psEq;
ParticleSystem psStatic4;
Walls walls;
Song fullsong;
ControlLayout controls;
Constants constants = new Constants();

Minim minim;

Transitions transitions = new Transitions(); 
boolean loading=true;
boolean runningDemo = true;

int demoIndex = 0;
int nextIndex = -1;



void setup()
{  
  // Best for utube  240p: 426x240 || 360p: 640x360 || 480p: 854x480 || 720p: 1280x720 || 1080p: 1920x1080 |  
  size(1280, 720, P3D);    
      
  minim = new Minim(this);
  runningDemo = true;
  
  utility = new Utility();
    
  if (!transitions.loadExistingTransitions(this))
    transitions = new Transitions(); 
  else
    println("Transitions loaded:" + transitions.getTransitionsAsJson());  
    
    
  cp5 = new ControlP5(this);    
  cp5.setAutoDraw(false);
  controls = new ControlLayout(cp5);
  controls.setup();
       
                  
  background = new Background();
  background.colourChanger = true;
  background.changeSpeed = 20;
  background.randomGreen = 2;  
  background.maxColourChanger = 100;
  background.red=0;
  background.green=0;
  background.blue=0;         
      
  audioFFT = new AudioFFT(minim, "Jot.4.wav");
  audioFFT.moveSong = true;
  
  fullsong = new Song();
  fullsong.songEnabled = true;
  fullsong.songPositionEnabled = true;
  fullsong.loadSong(minim, audioFFT.songFile);
  fullsong.reset();
  fullsong.intervalGap = 4;
  
  camera = new Camera();   
  camera.cameyeZ = 624; 
  camera.setHome();
  
  // Graphic providers specific to this song 
    
   
  walls = new Walls();
  walls.enabled = false;
  
  lights = new Lights(); 
  lights.ambLightRed=255;
  lights.ambLightGreen=0;
  lights.ambLightBlue=0;
     
  lineEQ = new LineEQ();
  lineEQ.enabled = false;
  
  transitionsLineEQ = new LineEQ();
  transitionsLineEQ.enabled = true;
  
  psEq = new ParticleSystem(0, new PVector(width/2, height/2)
                            , 10, 10       // width, height
                            , -1, -1, 255  // RGB
                            , 200, 0.9     // ALPHA + RATE
                            , Particle.TYPE_MOVING, ParticleSystem.TYPE_CLOUDS);
  psEq.enabled = false;
   
  psStatic4 = new ParticleSystem(4, new PVector(width/2, height/2)
                            , 1000, 1000
                            , -1, -1, 255  // RGB
                            , 200, 1.2   // ALPHA + RATE
                            , Particle.TYPE_STATIC, ParticleSystem.TYPE_STATIC_4);
     
  
  psStatic4.reset();
  psStatic4.enabled = false;  
  
  audioFFT.updateSongPosition();
  audioFFT.song.play(0);                         
  
  // smooth edges
  smooth();
                                                            
  println( "SETUP width:" + width + "  height:" + height );
  //println( "Testing getAppJson" );
  //String appJson = getAppJson();
  //println( "Testing setAppJson" );
  //setAppJson(appJson);
  println( "");
  
  loading=false;

}

void restartDemo(){  
  audioFFT.song.play(0);  
  demoIndex = 0; 
  nextIndex = -1;
  runningDemo = true;
  transitions.clearActorsOnStage();
}

void hideDemo(){  
  runningDemo = false;
}

void showDemo(){  
  runningDemo = true;
}


void draw(){                    
   
   //println( "audioFFT.songposition:" + audioFFT.songposition );
   
      
   if ( audioFFT.song.isPlaying())
     background.draw();
   else
     background(0, 0, 0, 255);
         
   audioFFT.updateSongPosition();
        
   audioFFT.setFFTScores();
       
   camera.set();
   
   lights.set(); 
            
       
              
     nextIndex = transitions.nextTransitionIndex(demoIndex, audioFFT.songPosition);     
     if (nextIndex>demoIndex){
       // need to action transition at demoIndex then move it forward.
       println("RUNNING TRANSITION:" + demoIndex);
       transitions.addActorsToTheStage(transitions.currentList.get(demoIndex));
       demoIndex = nextIndex;
     }
   
    if (runningDemo){ 
     transitions.drawActorsOnStage(audioFFT);
     
     //psEq.drawParticleSystem();     
     //psStatic4.drawParticleSystem4();       
     //grid.drawGrid();                  
     //lineEQ.drawMidEQ();    
     //walls.draw(audioFFT);   
   }
                 
   fullsong.drawSong(audioFFT.song);
   fullsong.drawSongPosition(audioFFT.song);   
   transitions.draw(audioFFT.song, fullsong.border);              
   cp5.draw();
   
}


 void controlEvent(ControlEvent theEvent) {
      
   if(loading)
     return;
   
  //println("theEvent:" + theEvent);
    
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.getName()=="Add Actor") {   
    println("event from Add Actor : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    transitions.addActor(cp5);  
    controls.setTransitionActors(transitions.selectedTransition());    
  }  
  else if (theEvent.getName()=="Remove Actor") {   
    println("event from Remove Actor : "+ theEvent.getController().getValue()+" from "+theEvent.getController());     
    transitions.removeActor(cp5);    
    controls.setTransitionActors(transitions.selectedTransition());
  }  
  else if (theEvent.getName()=="Save") {   
    println("event from Save : "+ theEvent.getController().getValue()+" from "+theEvent.getController());     
    transitions.saveActor(cp5);       
  }  
  else if (theEvent.getName()=="Actors") {   
    println("event from Actors : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    controls.showActorControls(transitions.selectedTransition());    
  }           
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }   
}

String getAppJson(){
  String jsonData = "[";   
  
  jsonData += utility.getObjectJson(audioFFT);
  jsonData += "," + utility.getObjectJson(background);
  jsonData += "," + utility.getObjectJson(camera);
  jsonData += "," + utility.getObjectJson(lights);  
  jsonData += "]";  
  return jsonData;
}

void setAppJson(String jsonArrayData){
   println(jsonArrayData);   
    
   utility.setObjectFromJson(this, audioFFT, jsonArrayData);
   utility.setObjectFromJson(this, background, jsonArrayData);
   utility.setObjectFromJson(this, camera, jsonArrayData);
   utility.setObjectFromJson(this, lights, jsonArrayData);   
}

void keyPressed() {             
  if (key =='t'){        
    String appJson = getAppJson();
    println( appJson );
    println( "");
  }  
  else if (key == 'u' ){        
    audioFFT.song.pause();
    println( "length: " + audioFFT.song.length() + " audioFFT.songposition:" + audioFFT.songPosition+ " audioFFT.lastsongposition:" + audioFFT.lastSongPosition + " postitiondiff: " + (audioFFT.songPosition-audioFFT.lastSongPosition) + " fft.specSize():" + audioFFT.fft.specSize() + " audioFFT.song.sampleRate():" + audioFFT.song.sampleRate() );
    println( "");
  } 
  else if (key == 'n'){        
    audioFFT.song.play();
    println( "length: " + audioFFT.song.length() + " audioFFT.songposition:" + audioFFT.songPosition+ " audioFFT.lastsongposition:" + audioFFT.lastSongPosition + " postitiondiff: " + (audioFFT.songPosition-audioFFT.lastSongPosition) + " fft.specSize():" + audioFFT.fft.specSize() + " audioFFT.song.sampleRate():" + audioFFT.song.sampleRate() );
    println( "");
  } 
 else if (key == 'h'){        
    audioFFT.song.cue( audioFFT.song.position()-200 );
    println( "length: " + audioFFT.song.length() + " audioFFT.songposition:" + audioFFT.songPosition+ " audioFFT.lastsongposition:" + audioFFT.lastSongPosition + " postitiondiff: " + (audioFFT.songPosition-audioFFT.lastSongPosition) + " fft.specSize():" + audioFFT.fft.specSize() + " audioFFT.song.sampleRate():" + audioFFT.song.sampleRate() );
    println( "");
  }   
   else if (key == 'j'){        
    audioFFT.song.cue( audioFFT.song.position()+200 );
    println( "length: " + audioFFT.song.length() + " audioFFT.songposition:" + audioFFT.songPosition+ " audioFFT.lastsongposition:" + audioFFT.lastSongPosition + " postitiondiff: " + (audioFFT.songPosition-audioFFT.lastSongPosition) + " fft.specSize():" + audioFFT.fft.specSize() + " audioFFT.song.sampleRate():" + audioFFT.song.sampleRate() );
    println( "");
  }   
  else if (key == 'g'){        
    audioFFT.song.cue( audioFFT.song.position()-800 );
    println( "length: " + audioFFT.song.length() + " audioFFT.songposition:" + audioFFT.songPosition+ " audioFFT.lastsongposition:" + audioFFT.lastSongPosition + " postitiondiff: " + (audioFFT.songPosition-audioFFT.lastSongPosition) + " fft.specSize():" + audioFFT.fft.specSize() + " audioFFT.song.sampleRate():" + audioFFT.song.sampleRate() );
    println( "");
  }   
  else if (key == 'k'){        
    audioFFT.song.cue( audioFFT.song.position()+800 );
    println( "length: " + audioFFT.song.length() + " audioFFT.songposition:" + audioFFT.songPosition+ " audioFFT.lastsongposition:" + audioFFT.lastSongPosition + " postitiondiff: " + (audioFFT.songPosition-audioFFT.lastSongPosition) + " fft.specSize():" + audioFFT.fft.specSize() + " audioFFT.song.sampleRate():" + audioFFT.song.sampleRate() );
    println( "");
  }  
  else if (key == 'r'){        
    println( "restart demo");
    restartDemo();
  }        
  else if (key == 'd'){        
    println( "hide demo");
    hideDemo();
  }   
  else if (key == 's'){        
    println( "show demo");
    showDemo();
  }   
  else if (key == DELETE){      
      if (transitions.deleteTransitions())
        println( "Deleted TRANSITIONS");
      
      transitions.saveFile();
  }
  else if (key == ' '){      // Add new transistion                       
    transitions.add(true, audioFFT.songPosition);
    println( "Added Grid TRANSITION audioFFT.songposition:" + audioFFT.songPosition);             
  }     
  else{           
    println( "key:'" + key + "'" );
    println( "");
  }
   
}

void mouseClicked() {
  
  if (pmouseY>height/2 && pmouseY<height-50){       
      if (!transitions.selectTransition(audioFFT.song, pmouseX))
        audioFFT.moveSong(pmouseX);       
      else
       controls.setTransitionActors(transitions.selectedTransition());
      println( "song.position:" + audioFFT.song.position() + "pmouseX:" + pmouseX + "  songPositionLineX:" + fullsong.songPositionLineX +  " pmouseY:" + pmouseY );
      return;
  }
    
  if (pmouseY>height-50){            
      audioFFT.moveSong(pmouseX);              
      println( "song.position:" + audioFFT.song.position() + "pmouseX:" + pmouseX + "  songPositionLineX:" + fullsong.songPositionLineX +  " pmouseY:" + pmouseY );
      return;
  }
}
