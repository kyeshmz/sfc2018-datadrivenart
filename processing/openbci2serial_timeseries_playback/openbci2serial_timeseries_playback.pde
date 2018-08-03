//import library
import processing.serial.*;
import controlP5.*;

final String FILENAME = "file.txt";
final int CHANNEL_NUM = 8;
float[] receive_timeseries = new float[CHANNEL_NUM];

//serial
Serial serialOutputPort;  // Create object from Serial class
int val;        // Data received from the serial port
byte[] outData = new byte[CHANNEL_NUM];
float threshold = 0.0;

//playback
//control p5
ControlP5 cp5;
RadioButton button;
boolean state_playback;

int currentPosition = 1;

//load file
String[] lines = {};

//draw graphs
final int FRAMERATE = 30;
final float BUFFER_TIME_SEC = 5.0;
final int BUFFER_PER_CHANNEL = int(FRAMERATE * BUFFER_TIME_SEC);
float[] buffer_timeseries = new float[BUFFER_PER_CHANNEL * CHANNEL_NUM];
color[] col = new color[CHANNEL_NUM];

void setup(){
  size(800, 600);
  frameRate(30);  
  
  //output port setup via serial
  for (int i = 0; i < Serial.list ().length; i++) {
    println (i + ": " + Serial.list ()[i]);
  }
  String outputPortName = Serial.list()[0];  //select piripiri device from list written in console
  serialOutputPort = new Serial(this, outputPortName, 9600);
  
  //control p5
  cp5 = new ControlP5(this);
  button = cp5.addRadioButton("button")
              .setPosition(30, 20)
              .setSize(40, 20)
              .setColorForeground(color(120))
              .setColorActive(color(255, 128, 0))
              .setColorLabel(color(0))
              .setItemsPerRow(3)
              .setSpacingColumn(35)
              .addItem("start", 0.0)
              .addItem("stop", 1.0)
              .addItem("rewind", 2.0)
              ;
              
  //load file
  lines = loadStrings(FILENAME);
  
  //init var
  for(int i = 0; i < CHANNEL_NUM; i++){
    receive_timeseries[i] = 0.0;
    outData[i] = 0;
  }
  
  col[0] = color(122);
  col[1] = color(124, 75, 141);
  col[2] = color(54, 87, 158);
  col[3] = color(49, 113, 89);
  col[4] = color(221, 178, 13);
  col[5] = color(253, 94, 52);
  col[6] = color(224, 56, 45);
  col[7] = color(162, 82, 49);
  //col[8] = col[0];
  //col[9] = col[1];
  //col[10] = col[2];
  //col[11] = col[3];
  //col[12] = col[4];
  //col[13] = col[5];
  //col[14] = col[6];
  //col[15] = col[7];
  
  state_playback = false;
  
}

void draw(){
  background(255);
  
  drawGraphs();
  
  //write text and draw recoding state
  fill(0);
  if(state_playback){
    for(int i = 0; i < CHANNEL_NUM; i++){
    }
    receive_timeseries = float(split(lines[currentPosition], ','));
    
    sendingSerial();

    currentPosition++;
    if(currentPosition == lines.length-1){
      currentPosition = 1;
      state_playback = false;
    }
    text("state: play", 30, 65);
  }else{
    text("state: stop", 30, 65);
  }
  
  float ratio = (currentPosition - 1.0)  / (lines.length - 1.0);
  int line_length = 100;
  pushMatrix();
  translate(270, 30);
  stroke(0);
  line(0, 0, line_length, 0);
  noStroke();
  fill(128, 255, 0);
  triangle(ratio*line_length, 0, ratio*line_length-3, 10, ratio*line_length+3, 10);
  popMatrix();
}

void sendingSerial(){
  //byte out[] = new byte[CHANNEL_NUM];
  byte out;
  
  if(receive_timeseries[0] > threshold){  //ch1
    out = byte(31);
    serialOutputPort.write(out);
  }else{
    out = byte(30);
    serialOutputPort.write(out);
  }
  
  if(receive_timeseries[1] > threshold){  //ch2
    out = byte(35);
    serialOutputPort.write(out);
  }else{
    out = byte(34);
    serialOutputPort.write(out);
  }

    if(receive_timeseries[2] > threshold){  //ch3
    out = byte(37);
    serialOutputPort.write(out);
  }else{
    out = byte(36);
    serialOutputPort.write(out);
  }
  
  if(receive_timeseries[3] > threshold){  //ch4
    out = byte(39);
    serialOutputPort.write(out);
  }else{
    out = byte(38);
    serialOutputPort.write(out);
  }
  
  if(receive_timeseries[4] > threshold){  //ch5
    out = byte(41);
    serialOutputPort.write(out);
  }else{
    out = byte(40);
    serialOutputPort.write(out);
  }
  
  if(receive_timeseries[5] > threshold){  //ch6
    out = byte(43);
    serialOutputPort.write(out);
  }else{
    out = byte(42);
    serialOutputPort.write(out);
  }
  
  if(receive_timeseries[6] > threshold){  //ch7
    out = byte(45);
    serialOutputPort.write(out);
  }else{
    out = byte(44);
    serialOutputPort.write(out);
  }
  
  if(receive_timeseries[07] > threshold){  //ch8
    out = byte(47);
    serialOutputPort.write(out);
  }else{
    out = byte(46);
    serialOutputPort.write(out);
  }
  
}

void controlEvent(ControlEvent event){
  if(event.isFrom(button)){
    if(event.getValue() == 0.0 && state_playback == false){
      state_playback = true;
    }
    if(event.getValue() == 1.0 && state_playback == true){
      state_playback = false;
    }
    if(event.getValue() == 2.0){
      currentPosition = 1;
    }
  }
}

void drawGraphs(){
  for(int i = 0; i < CHANNEL_NUM; i++){
    for(int j = int(FRAMERATE * BUFFER_TIME_SEC)-1; j > 0; j--){
      buffer_timeseries[i * BUFFER_PER_CHANNEL + j] = buffer_timeseries[i * BUFFER_PER_CHANNEL + j - 1];
    }
    buffer_timeseries[i * BUFFER_PER_CHANNEL] = receive_timeseries[i];
  }
  
  for(int i = 0; i < CHANNEL_NUM; i++){
    pushMatrix();
    translate(50, 110 + 30 * i);
    noStroke();
    fill(col[i]);
    ellipse(1, -4, 25, 25);
    textAlign(CENTER);
    fill(0);
    text(i, 0, 0);
    translate(20, 0);
    stroke(col[i]);
    for(int j = 0; j < BUFFER_PER_CHANNEL-1; j++){
      line((BUFFER_PER_CHANNEL-j)*3, buffer_timeseries[i * BUFFER_PER_CHANNEL + j] * 0.1, (BUFFER_PER_CHANNEL-(j+1))*3, buffer_timeseries[i * BUFFER_PER_CHANNEL + j + 1] * 0.1);
    }
    textAlign(LEFT);
    text(receive_timeseries[i], BUFFER_PER_CHANNEL * 3 + 10, 0);
    translate(BUFFER_PER_CHANNEL * 3 + 60, 0);
    noStroke();
    if(receive_timeseries[i] > threshold){
      fill(0, 255, 0);
    }else{
      fill(255, 0, 0);
    }
    ellipse(0, -4, 15, 15);
    popMatrix();
  }
}