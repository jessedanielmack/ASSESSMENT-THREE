// importing libraries, audio players and beat detect. Also creates booleans for each instrument.
import ddf.minim.*; 
import ddf.minim.analysis.*; 
AudioPlayer[] player = new AudioPlayer[5];
AudioPlayer song;
BeatDetect beat;
BeatDetect BASSbeat;
FFT fft;

boolean bass = false;
boolean drums = false;
boolean sub = false;
boolean synth = false;
boolean pressed = false;
float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.20;   // 20%
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;
float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;
float scoreDecreaseRate = 25;
Minim minim; 
int red, green, blue;
float eRadius;

int nbCubes;
Cube[] cubes;
int nbMurs = 500;
Mur[] murs;
 


void setup() { 
  
  //fullscreen
   fullScreen(P3D);

//load the minum player and track files
  minim = new Minim(this); 
  player[0] = minim.loadFile("1.wav"); 
  player[1] = minim.loadFile("2.wav"); 
  player[2] = minim.loadFile("3.wav"); 
  player[3] = minim.loadFile("4.wav"); 
  player[4] = minim.loadFile("5.wav"); 
  
//play all the files at once
  player[0].play(); 
  player[1].play(); 
  player[2].play(); 
  player[3].play(); 
  player[4].play(); 
  //mute all tracks
  player[0].setGain(-80);
  player[1].setGain(-80);
  player[2].setGain(-80);
  player[3].setGain(-80);
  player[4].setGain(-80);
  
  
beat = new BeatDetect();
  
BASSbeat = new BeatDetect();

  //beat detect analyses track
  ellipseMode(RADIUS);
  eRadius = 20;
  song = minim.loadFile("1.wav"); 
   fft = new FFT(song.bufferSize(), song.sampleRate());
     //Declare background cube variables
  nbCubes = (int)(fft.specSize()*specHi);
  cubes = new Cube[nbCubes];
 
  for (int i = 0; i < nbCubes; i++) {
   cubes[i] = new Cube(); 
  }
  }


  void draw() {
  background(red, green, blue);
    //the background is comprised of the colour variables that are later randomised when keyPressed
  noStroke();
  fill(255, 0, 150);
    //if keyPressed = true unmute the track and draw (same repeated per each key/instrument)
  if (bass == true) {
   //switch(key) {
    //case '2': {
      BASSbeat.detect(player[0].mix);
      player[0].setGain(0);
  float a = map(eRadius, 100, 80, 60, 255);
  noFill();
  stroke(250,24,51, eRadius*5);
  strokeWeight(eRadius*.6);
  if ( BASSbeat.isOnset() ) eRadius = 100;
  rect(width/4, height/4, eRadius*2, eRadius*2);
  eRadius *= 0.95;
  if ( eRadius < 20 ) eRadius = 20;}
  
  if (bass == false) {
    player[0].setGain(-80);
    }
 if (drums == true) {
    beat.detect(player[1].mix);
  player[1].setGain(0);
 float a = map(eRadius, 100, 80, 60, 255);
  noFill();
  stroke(51,24,255, eRadius*5);
  strokeWeight(eRadius*.6);
  if ( beat.isOnset() ) eRadius = 100;
  ellipse(width/1.4, height/4, eRadius*2, eRadius*2);
  eRadius *= 0.95;
  if ( eRadius < 20 ) eRadius = 20;}
 

if (drums == false) {
  player[1].setGain(-80);
    
  }
  
   if (sub == true) {
  player[2].setGain(0);
  
  beat.detect(player[2].mix);
 player[2].setGain(0);
 float a = map(eRadius, 100, 80, 60, 255);
  noFill();
  stroke(51,255,5,eRadius*5);
  strokeWeight(eRadius*.6);
  if ( beat.isOnset() ) eRadius = 100;
  rect(width/1.4, height/1.4, eRadius*2, eRadius*2);
  eRadius *= 0.95;
  if ( eRadius < 20 ) eRadius = 20;}
  
if (sub == false) {
  player[2].setGain(-80);
    
  }
  
   if (synth == true) {
  player[3].setGain(0);
   beat.detect(player[3].mix);
  float a = map(eRadius, 100, 80, 60, 255);
  noFill();
  stroke(100,100,100,eRadius*5);
  strokeWeight(eRadius*.6);
  if ( beat.isOnset() ) eRadius = 100;
  ellipse(width/4, height/1.4, eRadius*2, eRadius*2);
  eRadius *= 0.95;
  if ( eRadius < 20 ) eRadius = 20;
  }

if (synth == false) {
  player[3].setGain(-80);
    
  }
      //Draw cube 
   fft.forward(song.mix);
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;

  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;

  for(int i = 0; i < fft.specSize()*specLow; i++)
  {
    scoreLow += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
  {
    scoreMid += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
  {
    scoreHi += fft.getBand(i);
  }
  
  //Faire ralentir la descente.
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }
  
  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }
  
  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
 
  for(int i = 0; i < nbCubes; i++)
  {
    float bandValue = fft.getBand(i);

    cubes[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
  
  float previousBandValue = fft.getBand(0);
 
  float dist = -25;

  float heightMult = 2;
  }

class Cube {
 
  float startingZ = -10000;
  float maxZ = 1000;
 
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  Cube() {
   x = random(0, width);
    y = random(0, height);
    z = random(startingZ, maxZ);
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  }
  
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, intensity*5);
    noFill();
    
    //Couleur lignes, elles disparaissent avec l'intensité individuelle du cube
    color strokeColor = color(255, 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/300));
    
    pushMatrix();

    translate(x, y, z);
 
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);
   
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    box(100+(intensity/2));

    popMatrix();
  
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
   
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }
  }
}

class Mur {
  float startingZ = -10000;
  float maxZ = 50;
 
  float x, y, z;
  float sizeX, sizeY;

  Mur(float x, float y, float sizeX, float sizeY) {

    this.x = x;
    this.y = y;
 
    this.z = random(startingZ, maxZ);  
   
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
 
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
   
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, scoreGlobal);
    
    fill(displayColor, ((scoreGlobal-5)/1000)*(255+(z/25)));
    noStroke();

    pushMatrix();
 
    translate(x, y, z);

    if (intensity > 100) intensity = 100;
    scale(sizeX*(intensity*100), sizeY*(intensity*100), 20);
  
    box(1);
    popMatrix();
 
    displayColor = color(scoreLow*5, scoreMid*5, scoreHi*5, scoreGlobal);
    fill(displayColor, (scoreGlobal/5000)*(255+(z/25)));
  
    pushMatrix();
 
    translate(x, y, z);

    scale(sizeX, sizeY, 10);
   
    box(1);
    popMatrix();
    
    z+= (pow((scoreGlobal/150), 2));
    if (z >= maxZ) {
      z = startingZ;  
    }
  }

   }
//void keyPressed() {
  


//  switch(key) {
//  case '2':
//    player[0].setGain(0);
//    break;
//  case '3':
//   player[1].setGain(0);
//    break;
//  case '4':
//   player[2].setGain(0);
//    break;
//  case '5':
//    player[3].setGain(0);
//    break;
//  case '6':
//   player[4].setGain(0);
//    break;
//    case 'q':
//    player[0].setGain(-80);
//    break;
//  case 'w':
//   player[1].setGain(-80);
//    break;
//  case 'e':
//   player[2].setGain(-80);
//    break;
//  case 'r':
//    player[3].setGain(-80);
//    break;
//  case 't':
//   player[4].setGain(-80);
//    break;
//  }
  
    
 
//}

void keyPressed(){
  //Colours are assigned to random values between 0 and 255. These vairables
  //change on every key press allowing the background to change colour randomly
  red=int(random(255));
  green=int(random(255));
  blue=int(random(255));
  
  //the state of the key swtiches between true and false
    if (key == '2'){
      bass = !bass;
    }
    
    if (key == '3'){
      drums = !drums;
    }
    
    if (key == '4'){
      sub = !sub;
    }
    
    if (key == '5'){
      synth = !synth;
    }
   }