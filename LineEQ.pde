class LineEQ extends ActorOnStage {    
    
  public boolean drawMidEQOn = true;
  public int eqLinesMode;
  public float eqLineAlpha = 255;
  
  static final int EQLINES_4DIAG = 1;
  static final int EQLINES_TOPBOTTOM = 2;
  static final int EQLINES_MIDDIAG = 3;
  
  public int strokeHeightFactor=200;
   
  LineEQ(){
    super(Constants.TYPE_LineEQ);
  } 
  
  @Override
  void draw(AudioFFT audioFFT) {
    drawMidEQ();
  }
  
  void drawMidEQ()
  {
    if (!drawMidEQOn || !enabled)
      return;
    
    float alpha=255;
    float rightStartingPoint = width/2;
    float leftStartingPoint = width/2;      
     
    for(int i = 0; i < audioFFT.song.bufferSize() - 1; i++)
    {     
      alpha = alpha - 0.4;
       
      stroke(red, green, blue, alpha);        
      strokeWeight(strokeWeight);
      
      //line(i+100, height/2 + song.left.get(i)*50, i+105, height/2 + song.left.get(i+1)*50 ); 
              
      line( leftStartingPoint - i         , height/2 + audioFFT.song.left.get(i)*strokeHeightFactor      , -230
           , leftStartingPoint - i  -1    , height/2 + audioFFT.song.left.get(i+1)*strokeHeightFactor    , -230 );   
  
      line( rightStartingPoint + i        , height/2 + audioFFT.song.left.get(i)*strokeHeightFactor      , -230
           , rightStartingPoint + i + 1   , height/2 + audioFFT.song.left.get(i+1)*strokeHeightFactor    , -230 );             
    }
  }
  
  
  void drawEqLines(float scoreGlobal, int mode)
  {
    if (!enabled)
      return;
      
    float previousBandValue = audioFFT.fft.getBand(0);
  
     // Values for EQ bands, when drawing EQ frequency bands this is the distance apart (z axis) they appear.
    float eqDist = -25;
  
    // We can use energy or loudness to increse/decrease it. The final value should be between 1 and 8 to be nice.
    float eqHeightMult = 2;
  
    beginShape();
    for (int i = 1; i < audioFFT.fft.specSize(); i++)
    {
      // The value of the frequency band, the farther bands are multiplied so that they are more visible.
      float bandValue = audioFFT.fft.getBand(i)*(1 + (i/10));            
  
      stroke(100+audioFFT.scoreLow, 100+audioFFT.scoreMid, 100+audioFFT.scoreHi, 155-i);
      strokeWeight(1 + (scoreGlobal/100));
  
  
      if (mode == EQLINES_4DIAG)
      {
        //diagonal line, left, lower - three lines showing Audio EQ at slightly different angles  
        ////upper
        line(0, height-(previousBandValue*eqHeightMult), eqDist*(i-1), 0, height-(bandValue*eqHeightMult), eqDist*i);
        //lower
        line((previousBandValue*eqHeightMult), height, eqDist*(i-1), (bandValue*eqHeightMult), height, eqDist*i);
        //central
        line(0, height-(previousBandValue*eqHeightMult), eqDist*(i-1), (bandValue*eqHeightMult), height, eqDist*i);
    
        //diagonal line, left, higher
        line(0, (previousBandValue*eqHeightMult), eqDist*(i-1), 0, (bandValue*eqHeightMult), eqDist*i);
        line((previousBandValue*eqHeightMult), 0, eqDist*(i-1), (bandValue*eqHeightMult), 0, eqDist*i);
        line(0, (previousBandValue*eqHeightMult), eqDist*(i-1), (bandValue*eqHeightMult), 0, eqDist*i);
     
        //diagonal line, right, lower
        line(width, height-(previousBandValue*eqHeightMult), eqDist*(i-1), width, height-(bandValue*eqHeightMult), eqDist*i);
        line(width-(previousBandValue*eqHeightMult), height, eqDist*(i-1), width-(bandValue*eqHeightMult), height, eqDist*i);
        line(width, height-(previousBandValue*eqHeightMult), eqDist*(i-1), width-(bandValue*eqHeightMult), height, eqDist*i);
    
        //diagonal line, left, higher
        line(width, (previousBandValue*eqHeightMult), eqDist*(i-1), width, (bandValue*eqHeightMult), eqDist*i);
        line(width-(previousBandValue*eqHeightMult), 0, eqDist*(i-1), width-(bandValue*eqHeightMult), 0, eqDist*i);
        line(width, (previousBandValue*eqHeightMult), eqDist*(i-1), width-(bandValue*eqHeightMult), 0, eqDist*i);
      }
      else if (mode == EQLINES_TOPBOTTOM)
      {
        //// Bottom middle to Bottom left
        line(width/2, height-(previousBandValue*eqHeightMult), eqDist*(i-1), 0, height-(bandValue*eqHeightMult), eqDist*i);  
        //Bottom middle TO bottom right
        line(width/2, height-(previousBandValue*eqHeightMult), eqDist*(i-1), width, height-(bandValue*eqHeightMult), eqDist*i); 
         //Top middle TO Top left
        line((width/2), (previousBandValue*eqHeightMult), eqDist*(i-1), 0, (bandValue*eqHeightMult), eqDist*i); 
        // Top middle to top right
        line(width/2, (previousBandValue*eqHeightMult), eqDist*(i-1), width, (bandValue*eqHeightMult), eqDist*i);
      }
      else if (mode == EQLINES_MIDDIAG)
      {
        //// Bottom quarter to centre
        line(width/4, height-(previousBandValue*eqHeightMult), eqDist*(i-1)  , width/4, height-(bandValue*eqHeightMult), eqDist*i);        
        // Bottom 3/4 to centre
        line(width*3/4, height-(previousBandValue*eqHeightMult), eqDist*(i-1)  , width*3/4, height-(bandValue*eqHeightMult), eqDist*i);      
        //Top 3/4 TO centre
        line(width*3/4, (previousBandValue*eqHeightMult), eqDist*(i-1)   , width*3/4, (bandValue*eqHeightMult), eqDist*i);       
        // Top 1/4 to centre
        line(width/4, (previousBandValue*eqHeightMult), eqDist*(i-1)   , width/4, (bandValue*eqHeightMult), eqDist*i); 
      }
      strokeWeight(1);
  
      previousBandValue = bandValue;
    }
    endShape();
  }
    

}
