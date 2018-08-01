//app for playback
//playback data in project file and send via osc
//push "record" button to start playback
//push "stop" button to stop

final String FILENAME = "file.txt";

final int CHANNEL_NUM = 16;

//import library
import oscP5.*;
import netP5.*;
import controlP5.*;

//osc
OscP5 oscP5;
NetAddress sendTo;
final String SEND_HOST = "127.0.0.1";
final int SEND_PORT = 13455;
final String SEND_ADDRESS = "/address";

float[] receive_timeseries = new float[CHANNEL_NUM];
OscMessage msg_timeseries;

///playback
//control p5
ControlP5 cp5;
RadioButton button;

boolean state_playback;  //true:play, false:stop

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
  frameRate(FRAMERATE);
  
  //osc
  oscP5 = new OscP5(this, 7400);
  msg_timeseries = new OscMessage(SEND_ADDRESS);
  //output host and port setup via osc
  sendTo = new NetAddress(SEND_HOST, SEND_PORT);
  
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
   
  state_playback = false;
  
  //load file
  lines = loadStrings(FILENAME);
     
  //init var
  for(int i = 0; i < CHANNEL_NUM; i++){
    receive_timeseries[i] = 0.0;
  }
  for(int i = 0; i < CHANNEL_NUM; i++){
    col[i] = color(random(100, 255), random(100, 255), random(100, 255));
  }
  
}

void draw(){
  background(255);
  fill(0);
  
  drawGraphs();
  
  //send osc
  msg_timeseries.clear();
  msg_timeseries.add(SEND_ADDRESS);
  for(int i = 0; i < CHANNEL_NUM; i++){
    msg_timeseries.add(receive_timeseries[i]);
  }
  oscP5.send(msg_timeseries, sendTo);
  
  //write text and draw recoding state
  if(state_playback){
    for(int i = 0; i < CHANNEL_NUM; i++){
    }
    receive_timeseries = float(split(lines[currentPosition], ','));

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

void controlEvent(ControlEvent event){
  if(event.isFrom(button)){
    if(event.getValue() == 0.0 && state_playback == false){
      startPlayback();
    }
    if(event.getValue() == 1.0 && state_playback == true){
      stopPlayback();
    }
    if(event.getValue() == 2.0){
      currentPosition = 1;
    }
  }
}

void startPlayback(){
  state_playback = true;
}

void stopPlayback(){
  state_playback = false;
}

void drawGraphs(){
  for(int i = 0; i < CHANNEL_NUM; i++){
    for(int j = int(FRAMERATE * BUFFER_TIME_SEC)-1; j > 0; j--){
      buffer_timeseries[i * BUFFER_PER_CHANNEL + j] = buffer_timeseries[i * BUFFER_PER_CHANNEL + j - 1];
    }
    buffer_timeseries[i * BUFFER_PER_CHANNEL] = receive_timeseries[i];
  }
  
  for(int i = 0; i < CHANNEL_NUM; i++){
    stroke(col[i]);
    pushMatrix();
    translate(50, 110 + 30 * i);
    text(i, 4, 0);
    translate(15, 0);
    for(int j = 0; j < BUFFER_PER_CHANNEL-1; j++){
      line((BUFFER_PER_CHANNEL-j)*3, buffer_timeseries[i * BUFFER_PER_CHANNEL + j] * 0.1, (BUFFER_PER_CHANNEL-(j+1))*3, buffer_timeseries[i * BUFFER_PER_CHANNEL + j + 1] * 0.1);
    }
    popMatrix();
  }
}