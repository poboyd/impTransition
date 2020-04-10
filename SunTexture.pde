class SunTexture {

int ptsW, ptsH;

PImage img;
PImage img2;
PImage img3;
PImage img35;
PImage img4;
PImage img45;
PImage img5;
PImage img55;
PImage img6;
PImage img65;

int numPointsW;
int numPointsH_2pi; 
int numPointsH;

float[] coorX;
float[] coorY;
float[] coorZ;
float[] multXZ;

boolean endingSun = false;

float size=80;

float rotateYAdj;

int changeImageCount=0;

void debug(){   
   println( utility.getObjectJson(this));
   println(""); 
  }
  
SunTexture(){ 
  img=loadImage("SAM_2357_small2.JPG");
  img2 = loadImage("SAM_2357_small2.JPG");
  img3 =loadImage("SAM_2357_small3.png");
  img35 =loadImage("SAM_2357_small35.png");
  img4 =loadImage("SAM_2357_small4.png");
  img45 =loadImage("SAM_2357_small45.png");
  img5 =loadImage("SAM_2357_small5.png");
  img55 =loadImage("SAM_2357_small55.png");
  img6 =loadImage("SAM_2357_small6.png");
  img65 =loadImage("SAM_2357_small65.png");
  
  ptsW=30;
  ptsH=30;
  
  rotateYAdj = 0.3;
  
  // Parameters below are the number of vertices around the width and height
  initializeSphere(ptsW, ptsH);
}

void adjustRotateY(float adjY){

  rotateYAdj = rotateYAdj + adjY;
  
  if (rotateYAdj>6)
    rotateYAdj =6;

  else if (rotateYAdj<0.15)
    rotateYAdj = 0.15;

}

void endSun(){
  rotateYAdj += 0.08;
  endingSun = true;
}

void draw(float zOrder) { 
  //camera(width/2+map(mouseX, 0, width, -2*width, 2*width), 
    //     height/2+map(mouseY, 0, height, -height, height),
      //   height/2/tan(PI*30.0 / 180.0), 
        // width, height/2.0, 0,     0, 1, 0);
    
  if (changeImageCount>0)
    changeImageCount = changeImageCount + 1;    

   if (changeImageCount==300)
       img = img3;
   else if (changeImageCount==302)
      img = img35;
    else if (changeImageCount==304)
       img = img4;
    else if (changeImageCount==306)
       img = img45;
    else if (changeImageCount==308)
       img = img5;
    else if (changeImageCount==310)
       img = img55;
   else if (changeImageCount==312)
       img = img6;
   else if (changeImageCount==314)
       img = img65;
   else if (changeImageCount>=316){
      changeImageCount = 0;
      img = img2;
   }
      
      

  pushMatrix();
  translate(width/2, height/2, zOrder);    
  rotateX(radians(frameCount*0.1));
  rotateY(radians(frameCount*rotateYAdj));   
  noStroke();
  fill(255);
  if (size<2000)
    textureSphere(size, size, size, img);
  popMatrix(); 
}

void initializeSphere(int numPtsW, int numPtsH_2pi) {

  
  // The number of points around the width and height
  numPointsW=numPtsW+1;
  numPointsH_2pi=numPtsH_2pi;  // How many actual pts around the sphere (not just from top to bottom)
  numPointsH=ceil((float)numPointsH_2pi/2)+1;  // How many pts from top to bottom (abs(....) b/c of the possibility of an odd numPointsH_2pi)

  coorX=new float[numPointsW];   // All the x-coor in a horizontal circle radius 1
  coorY=new float[numPointsH];   // All the y-coor in a vertical circle radius 1
  coorZ=new float[numPointsW];   // All the z-coor in a horizontal circle radius 1
  multXZ=new float[numPointsH];  // The radius of each horizontal circle (that you will multiply with coorX and coorZ)

  for (int i=0; i<numPointsW ;i++) {  // For all the points around the width
    float thetaW=i*2*PI/(numPointsW-1);
    coorX[i]=sin(thetaW);
    coorZ[i]=cos(thetaW);
  }
  
  for (int i=0; i<numPointsH; i++) {  // For all points from top to bottom
    if (int(numPointsH_2pi/2) != (float)numPointsH_2pi/2 && i==numPointsH-1) {  // If the numPointsH_2pi is odd and it is at the last pt
      float thetaH=(i-1)*2*PI/(numPointsH_2pi);
      coorY[i]=cos(PI+thetaH); 
      multXZ[i]=0;
    } 
    else {
      //The numPointsH_2pi and 2 below allows there to be a flat bottom if the numPointsH is odd
      float thetaH=i*2*PI/(numPointsH_2pi);

      //PI+ below makes the top always the point instead of the bottom.
      coorY[i]=cos(PI+thetaH); 
      multXZ[i]=sin(thetaH);
    }
  }
}

void textureSphere(float rx, float ry, float rz, PImage t) { 
  
  if (endingSun){
    
    if (size==300)
       img = img3;
    else if (size==350)
      img = img35;
    else if (size==400)
       img = img4;
    else if (size==450)
       img = img45;
    else if (size==500)
       img = img5;
    else if (size==550)
       img = img55;
   else if (size==600)
       img = img6;
   else if (size>650)
       img = img65;
       
    size = size + 5;
          
    rotateYAdj += 0.1;
    if (rotateYAdj>100)
      rotateYAdj=100;
          
    //println( "size:" + size );
  }
  
  // These are so we can map certain parts of the image on to the shape 
  float changeU=t.width/(float)(numPointsW-1); 
  float changeV=t.height/(float)(numPointsH-1); 
  float u=0;  // Width variable for the texture
  float v=0;  // Height variable for the texture

  beginShape(TRIANGLE_STRIP);
  texture(t);
  for (int i=0; i<(numPointsH-1); i++) {  // For all the rings but top and bottom
    // Goes into the array here instead of loop to save time
    float coory=coorY[i];
    float cooryPlus=coorY[i+1];

    float multxz=multXZ[i];
    float multxzPlus=multXZ[i+1];

    for (int j=0; j<numPointsW; j++) { // For all the pts in the ring
      normal(-coorX[j]*multxz, -coory, -coorZ[j]*multxz);
      vertex(coorX[j]*multxz*rx, coory*ry, coorZ[j]*multxz*rz, u, v);
      normal(-coorX[j]*multxzPlus, -cooryPlus, -coorZ[j]*multxzPlus);
      vertex(coorX[j]*multxzPlus*rx, cooryPlus*ry, coorZ[j]*multxzPlus*rz, u, v+changeV);
      u+=changeU;
    }
    v+=changeV;
    u=0;
  }
  endShape();
}
}
