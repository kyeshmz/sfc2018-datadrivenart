//import library
import oscP5.*;
import netP5.*;
import processing.serial.*;

OscP5 oscInput;

Serial serialOutputPort;  // Create object from Serial class
int val;        // Data received from the serial port

final int receivePort = 12345;

void setup(){
  size(800, 600);
  frameRate(30);
  
  //input port setup from openbci via osc
  oscInput = new OscP5(this, 12345);
  
  //output port setup via serial
  String outputPortName = Serial.list()[0];
  serialOutputPort = new Serial(this, outputPortName, 9600);
  
}

void draw(){
  background(0);
  
  
}

void oscEvent(OscMessage msg) {
  if(msg.checkAddrPattern("/openbci")){  //set address
    byte out[] = new byte[128];
    for(int i = 0; i < 128; i++){
      out[i] = byte(msg.get(i).intValue() * 255);  //send only 0-255
    }
    serialOutputPort.write(out);
  }
  //msg.print();
}