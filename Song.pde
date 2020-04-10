class Song {   
  public boolean songEnabled = false;
  public boolean songPositionEnabled = false;
  private Minim appMinim;  
  private AudioSample sample; // used for transitions as it loads the whole song into memory
   
  public String songFile;
  public int border=0; 
  public FloatList sampleAverage; 
  public int intervalGap=1; // MUST be a least 1 
  public float songPositionLineX;
  
  public float mainRed=0;   // Where the song position is should be this colour
  public float mainGreen=200;
  public float mainBlue=0;
       
  public float solidRed=20;   // the entire song should be this colour underneath the cursor colour
  public float solidGreen=20;
  public float solidBlue= 20;
  
       
  public boolean colourSweepEnabled = true;
  public int sweepWidthLimiter=30;
  public int sweepMode=1;    
  private static final int SWEEP_FADE_BEHIND = 0;
  private static final int SWEEP_KEEP_BEHIND = 1;
  
  
  void debug(){   
   println( utility.getObjectJson(this));
   println(""); 
  }
   
  void loadSong(Minim thisminim, String thisSongFile){    
     if (!songEnabled) return;
     
     appMinim = thisminim;
     songFile = thisSongFile;
     sample = appMinim.loadSample(songFile, 2048);
     println("sample.bufferSize():" + sample.bufferSize() + " sample.sampleRate():" + sample.sampleRate()); 
  }
  
  void reset(){
     //1. get samples values as if it was a mono file, we could just take one channel here
    float[] leftSamples = fullsong.sample.getChannel(AudioSample.LEFT);
    float[] rightSamples = fullsong.sample.getChannel(AudioSample.RIGHT);
    float [] samplesVal = new float[rightSamples.length];
    for (int i=0; i < rightSamples.length; i++) {
      samplesVal[i] = leftSamples[i]+ rightSamples[i];
    }
    
    float sizeOfIntervals =samplesVal.length/width;
    
    //2. reduce quantity : get an average from those values each  16 348 samples
    sampleAverage = new FloatList();
    int average=0;
    for (int i = 0; i< samplesVal.length; i+=1) {
      average += abs(samplesVal[i])*200 ; // sample are low value so *1000
      if ( i % sizeOfIntervals == 0 && i!=0) { 
        sampleAverage.append( average /sizeOfIntervals);  //16384, 8192
        average = 0;
      }
    }
        
    println( " samplesVal.length:" + samplesVal.length + " border:" + border + "  sizeOfIntervals:" + sizeOfIntervals );
  }
  
  
  void drawSong(AudioPlayer player){                    
                   
     if (!songEnabled)
       return;

     float posx = map(player.position(), 0, player.length(), 0, width);

     strokeWeight(2);
      
     for ( int i=0; i< sampleAverage.size(); i=i+intervalGap) {
       
        float diffFromi=0;   
        
        // underneath solid lines
        stroke(solidRed, solidGreen, solidBlue);
        line(i+border, height-border*2, i+border, (height-border*2) - sampleAverage.get(i));
       
        // top coloured lines
        if (colourSweepEnabled){
                    
          diffFromi= map(posx, i, sampleAverage.size(), 0, 255)*sweepWidthLimiter; 
                                       
          if (posx>i)
            if (sweepMode==SWEEP_FADE_BEHIND)
              stroke(mainRed+diffFromi, mainGreen+diffFromi, mainBlue+diffFromi);                 
            else
              stroke(mainRed+diffFromi, mainGreen+diffFromi, mainBlue+diffFromi, 200);
          else
            stroke(mainRed-diffFromi, mainGreen-diffFromi, mainBlue-diffFromi, 200);
          
                      
          line(i, height-border*2, i, (height-border*2) - sampleAverage.get(i));
          
          //float time = round(  i*16384 / fullsong.sample.sampleRate() );
          //if (time % 30 == 0) text(round(time), i, height-border/2);
        }
     }     
      
     
     // Draw line under which transitions wont 
     stroke(0, 0, 200, 200);
     line(0, height -50, width, height-50);
  }
  
  void drawSongPosition(AudioPlayer player)
  {
       if (!songPositionEnabled)
         return;
       
      // draw a line to show where in the song playback is currently located
      songPositionLineX = map(player.position(), 0, player.length(), 0, width);
      stroke(mainRed, mainGreen, mainBlue);
      line(songPositionLineX, border, songPositionLineX, height - (border*2));

      stroke(mainRed, mainGreen, mainBlue, 100);
      line(songPositionLineX+2, border, songPositionLineX+2, height - (border*2));

      stroke(mainRed, mainGreen, mainBlue, 60);
      line(songPositionLineX+4, border, songPositionLineX+4, height - (border*2));
      
       stroke(mainRed, mainGreen, mainBlue, 30);
      line(songPositionLineX+6, border, songPositionLineX+6, height - (border*2));
  }
  
}
