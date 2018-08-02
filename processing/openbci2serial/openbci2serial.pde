//import library
import oscP5.*;
import netP5.*;
import processing.serial.*;

final int CHANNEL_NUM = 16;
float[] receive_timeseries = new float[CHANNEL_NUM];
OscMessage msg_timeseries;

//osc
OscP5 oscInput;
final int RECEIVE_PORT = 12345;
final String RECEIVE_ADDRESS = "/openbci";

//serial
Serial serialOutputPort;  // Create object from Serial class
int val;        // Data received from the serial port

//draw graphs
final int FRAMERATE = 30;
final float BUFFER_TIME_SEC = 5.0;
final int BUFFER_PER_CHANNEL = int(FRAMERATE * BUFFER_TIME_SEC);
float[] buffer_timeseries = new float[BUFFER_PER_CHANNEL * CHANNEL_NUM];
color[] col = new color[CHANNEL_NUM];

void setup(){
  size(800, 600);
  frameRate(30);
  
  //input port setup from openbci via osc
  oscInput = new OscP5(this, RECEIVE_PORT);
  
  //output port setup via serial
  String outputPortName = Serial.list()[0];
  serialOutputPort = new Serial(this, outputPortName, 9600);
  
  //init var
  for(int i = 0; i < CHANNEL_NUM; i++){
    receive_timeseries[i] = 0.0;
  }
  for(int i = 0; i < CHANNEL_NUM; i++){
    col[i] = color(random(100, 255), random(100, 255), random(100, 255));
  }
  
}

void draw(){
  background(0);
  
  drawGraphs();
  
}

void oscEvent(OscMessage msg) {
  if(msg.checkAddrPattern(RECEIVE_ADDRESS)){  //set address
    byte out[] = new byte[128];
    for(int i = 0; i < 128; i++){
      out[i] = byte(msg.get(i).intValue() * 255);  //send only 0-255
    }
    serialOutputPort.write(out);
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