final int CHANNEL_NUM = 16;

//import library
import oscP5.*;
import netP5.*;
import controlP5.*;

OscP5 oscP5;
NetAddress sendTo;
final int RECEIVE_PORT = 12345;
final String RECEIVE_ADDRESS = "/openbci";
final String SEND_HOST = "127.0.0.1";
final int SEND_PORT = 13455;
final String SEND_ADDRESS = "/address";

float[] receive_timeseries = new float[CHANNEL_NUM];
OscMessage msg_timeseries;

//draw graphs
final int FRAMERATE = 30;
final float BUFFER_TIME_SEC = 5.0;
final int BUFFER_PER_CHANNEL = int(FRAMERATE * BUFFER_TIME_SEC);
float[] buffer_timeseries = new float[BUFFER_PER_CHANNEL * CHANNEL_NUM];
color[] col = new color[CHANNEL_NUM];

void setup(){
  size(800, 600);
  frameRate(FRAMERATE);
  
  msg_timeseries = new OscMessage(SEND_ADDRESS);
  
  //input port setup from openbci via osc
  oscP5 = new OscP5(this, RECEIVE_PORT);
  
  //output host and port setup via osc
  sendTo = new NetAddress(SEND_HOST, SEND_PORT);
  
  //init var
  for(int i = 0; i < CHANNEL_NUM; i++){
    receive_timeseries[i] = 0.0;
  }
  
  for(int i = 0; i < CHANNEL_NUM; i++){
    col[i] = color(255, 255, 255);
  }
  
}

void draw(){
  background(0);
  fill(255);
  
  drawGraphs();
  
  msg_timeseries.clear();
  msg_timeseries.add(SEND_ADDRESS);
  for(int i = 0; i < CHANNEL_NUM; i++){
    msg_timeseries.add(receive_timeseries[i]);
  }
  oscP5.send(msg_timeseries, sendTo);
  
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
    translate(50, 50 + 30 * i);
    text(i, 4, 0);
    translate(15, 0);
    for(int j = 0; j < BUFFER_PER_CHANNEL-1; j++){
      line((BUFFER_PER_CHANNEL-j)*3, buffer_timeseries[i * BUFFER_PER_CHANNEL + j] * 0.1, (BUFFER_PER_CHANNEL-(j+1))*3, buffer_timeseries[i * BUFFER_PER_CHANNEL + j + 1] * 0.1);
    }
    popMatrix();
  }
  
  
}

void oscEvent(OscMessage msg) {
  if(msg.checkAddrPattern(RECEIVE_ADDRESS)){  //set address
     for(int i = 0; i < CHANNEL_NUM; i++){
       receive_timeseries[i] = msg.get(i).floatValue();
     }
  }
}
