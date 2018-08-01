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

ControlP5 cp5;
CheckBox checkbox;
boolean[] state_channel = new boolean[CHANNEL_NUM];

int receive_channel_num;
float[] receive_fft = new float[125];

void setup(){
  size(800, 600);
  frameRate(30);
  
  //input port setup from openbci via osc
  oscP5 = new OscP5(this, RECEIVE_PORT);
  
  //output host and port setup via osc
  sendTo = new NetAddress(SEND_HOST, SEND_PORT);
  
  //control p5
  cp5 = new ControlP5(this);
  
  checkbox = cp5.addCheckBox("channel")
                .setPosition(100, 200)
                .setSize(20, 20)
                .setItemsPerRow(16)
                .setSpacingColumn(12)
                .addItem("1", 1)
                .addItem("2", 2)
                .addItem("3", 3)
                .addItem("4", 4)
                .addItem("5", 5)
                .addItem("6", 6)
                .addItem("7", 7)
                .addItem("8", 8)
                .addItem("9", 9)
                .addItem("10", 10)
                .addItem("11", 11)
                .addItem("12", 12)
                .addItem("13", 13)
                .addItem("14", 14)
                .addItem("15", 15)
                .addItem("16", 16)
                ;

  //init var
  for(int i = 0; i < CHANNEL_NUM; i++){
    state_channel[i] = false;
  }
  
}

void draw(){
  background(0);
  fill(255);
  
  text("channel_num", 50, 50);
  text(receive_channel_num, 50, 60);
  
  OscMessage msg = new OscMessage("/address");
  oscP5.send(msg, sendTo);
  
}

void oscEvent(OscMessage msg) {
  if(msg.checkAddrPattern(RECEIVE_ADDRESS)){  //set address
     receive_channel_num = msg.get(0).intValue();
     for(int i = 0; i < 125; i++){
       receive_fft[i]  = msg.get(i+1).floatValue();
     }
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(checkbox)) {
    // .getArrayValue()[i] false->0.0 true->1.0
    // use .internalValue() to get value
    for (int i = 0; i < CHANNEL_NUM; i++) {
      int n = (int)checkbox.getArrayValue()[i];
      if(n == 1){
        state_channel[i] = true;
      }else{
        state_channel[i] = false;
      }
    }
  }
}