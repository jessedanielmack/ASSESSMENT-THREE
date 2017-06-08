int red, green, blue;

void setup() {
  size(600, 700);
}

void draw() {
    background(red, 200, 100);
  rectMode(CENTER);
  noFill();
  rect(300, 100, 400, 110);
  rect(300, 250, 400, 110);
  rect(300, 400, 450, 130);
  rect(300, 550, 400, 110);
 String s = "DECLARE THE VARIABLES! Declare libraries and variables (minim player, minim analysis, audio player and beat detect. I also declared booleans for each instrument as they are later used with true/false statements.";
fill(50);
text(s, 300, 100, 400, 100);  // Text wraps within text box
String d = "SET UP! This is where I load up the track files assigned to each instrument. All the tracks play in unison however they are muted (setGain -80). I also set up BeatDetect.";
fill(50);
text(d, 300, 250, 400, 100);  // Text wraps within text box
String r = "DRAW! At this stage I explain what happens when the state of the various keys are true/false. When the keys are true, two processes determine the audio/visual elements. The tracks are unmuted and a ring that pulsates based on the beat of the instrument is displayed. I use various parameters to make the ring opacity correlate with the radius. The last draw element includes the background cubes. This section of code was inspired from a project I found online. I changed the code dramatically to make it my own. Floating cubes never looked so good! ";
fill(50);
text(r,300, 400, 450, 125);  // Text wraps within text box
String t = "KEY PRESSED! Changing the state of the keys between true and false when pressed. Also generates a random background colour by randomise the colour intervals when any key is pressed.";
fill(50);
text(t,300, 550, 400, 100);  // Text wraps within text box
}

void keyPressed(){
  //Colours are assigned to random values between 0 and 255. These vairables
  //change on every key press allowing the background to change colour randomly
  red=int(random(255));
  green=int(random(255));
  blue=int(random(255));
  
}