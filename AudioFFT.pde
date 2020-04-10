class AudioFFT {     
  private FFT fft;
  private Minim appMinim;
  private AudioPlayer song;     // used for playback as its buffering, as opposed to AudioSample which loads the whole sample/song into memory
    
  public boolean moveSong = true;
  public boolean enabled = true;
  public String songFile;
  public float songPosition;
  public float lastSongPosition;
  public int soundPosition; // used by text file FFT
  
  public float specLow = 0.03; // 3%
  public float specMid = 0.125;  // 12.5%
  public float specHi = 0.20;   // 20%

  public float scoreLow = 0;
  public float scoreMid = 0;
  public float scoreHi = 0;
  public float oldScoreLow = scoreLow;
  public float oldScoreMid = scoreMid;
  public float oldScoreHi = scoreHi;
  public float scoreGlobal;

  public float scoreDecreaseRate = 25;

  public String seperatorChar = "|";

  void debug(){   
   println( utility.getObjectJson(this));
   println(""); 
  }
  
  AudioFFT(Minim thisminim, String thisSongFile)
  {       
    appMinim = thisminim;
    
    songFile = thisSongFile;
    song = minim.loadFile(songFile);           
     
    fft = new FFT(song.bufferSize(), song.sampleRate());      
    println("song.bufferSize():" + song.bufferSize() + " song.sampleRate():" + song.sampleRate() + " fft.specSize():" + fft.specSize()); 
  }
  
  void updateSongPosition(){
    lastSongPosition = songPosition; 
    songPosition = song.position();
  }
  
  void reset(){       
     //debug("");         
  }
  
  void moveSong(int mouseX){  
    if (!moveSong) return;
    
    int position = int( map( mouseX, 0, width, 0, song.length() ) ); 
    song.cue( position );
  }
  
  // https://github.com/hamoid/video_export_processing/blob/master/examples/withAudioViz/withAudioViz.pde
  // Minim based audio FFT to data text file conversion.
  // Non real-time, so you don't wait 5 minutes for a 5 minute song :)
  // You can look at the produced txt file in the data folder
  // after running this program to see how it looks like.
  void audioToTextFile() {
    PrintWriter output;
     
    output = createWriter(dataPath(songFile + ".txt"));
  
    AudioSample track = appMinim.loadSample(songFile, 2048);
  
    //int fftSize = 1024; 512, 256, 128, 64, 32,16, 8, 2
    int fftSize = 1024;
    float sampleRate = track.sampleRate();
  
    float[] fftSamplesL = new float[fftSize];
    float[] fftSamplesR = new float[fftSize];
  
    float[] samplesL = track.getChannel(AudioSample.LEFT);
    float[] samplesR = track.getChannel(AudioSample.RIGHT);  
  
    FFT fftL = new FFT(fftSize, sampleRate);
    FFT fftR = new FFT(fftSize, sampleRate);
  
    fftL.logAverages(22, 3);
    fftR.logAverages(22, 3);
  
    int totalChunks = (samplesL.length / fftSize) + 1;
    int fftSlices = fftL.avgSize();
  
    for (int ci = 0; ci < totalChunks; ++ci) {
      int chunkStartIndex = ci * fftSize;   
      int chunkSize = min( samplesL.length - chunkStartIndex, fftSize );
  
      System.arraycopy( samplesL, chunkStartIndex, fftSamplesL, 0, chunkSize);      
      System.arraycopy( samplesR, chunkStartIndex, fftSamplesR, 0, chunkSize);      
      if ( chunkSize < fftSize ) {
        java.util.Arrays.fill( fftSamplesL, chunkSize, fftSamplesL.length - 1, 0.0 );
        java.util.Arrays.fill( fftSamplesR, chunkSize, fftSamplesR.length - 1, 0.0 );
      }
  
      fftL.forward( fftSamplesL );
      fftR.forward( fftSamplesL );
  
      // The format of the saved txt file.
      // The file contains many rows. Each row looks like this:
      // T|L|R|L|R|L|R|... etc
      // where T is the time in seconds
      // Then we alternate left and right channel FFT values
      // The first L and R values in each row are low frequencies (bass)
      // and they go towards high frequency as we advance towards
      // the end of the line.
      StringBuilder msg = new StringBuilder(nf(chunkStartIndex/sampleRate, 0, 3).replace(',', '.'));
      msg.append(seperatorChar + chunkStartIndex);
      
      for (int i=0; i<fftSlices; ++i) {
        msg.append(seperatorChar + nf(fftL.getAvg(i), 0, 4).replace(',', '.'));
        msg.append(seperatorChar + nf(fftR.getAvg(i), 0, 4).replace(',', '.'));
      }
      output.println(msg.toString());
    }
    track.close();
    output.flush();
    output.close();
    println("Sound analysis done");
  }    
  
  
  void setFFTScores()
  {      
    fft.forward(song.mix);
       
    oldScoreLow = scoreLow;
    oldScoreMid = scoreMid;
    oldScoreHi = scoreHi;
  
    scoreLow = 0;
    scoreMid = 0;
    scoreHi = 0;
     
    for (int i = 0; i < fft.specSize()*specLow; i++){
      scoreLow += fft.getBand(i);
    }
  
    for (int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++){
      scoreMid += fft.getBand(i);
    }
  
    for (int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++){
      scoreHi += fft.getBand(i);
    }
  
    if (oldScoreLow > scoreLow) {
      scoreLow = oldScoreLow - scoreDecreaseRate;
    }
  
    if (oldScoreMid > scoreMid) {
      scoreMid = oldScoreMid - scoreDecreaseRate;
    }
  
    if (oldScoreHi > scoreHi) {
      scoreHi = oldScoreHi - scoreDecreaseRate;
    }
   
    scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;       
            
  }
  
}
