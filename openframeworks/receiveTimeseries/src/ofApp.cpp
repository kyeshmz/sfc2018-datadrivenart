#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofBackground(0);
    ofSetVerticalSync(true);
    
    receiver.setup(RECEIVE_PORT);
    ofSetFrameRate(30);
    buffer_timeseries.resize(BUFFER_PER_CHANNEL*CHANNEL_NUM);
    
    sender.setup(SEND_HOST,SEND_PORT);
    
    gui.setup();
    gui.add(sendOSC.setup("sendOSC", false));
//    col[].re
    
    //init var
    for (int i=0; i < CHANNEL_NUM; i++){
        receive_timeseries.assign(0, i);
    }
    
    

}

//--------------------------------------------------------------
void ofApp::update(){
    if(sendOSC){
        ofxOscMessage m;
        m.setAddress("/timseries");
        for(int i =0; receive_timeseries.size(); i++){
            m.addFloatArg(receive_timeseries[i]);
            sender.sendMessage(m,false);
        }
        //sender.sendMessage(m,false);
    }
    while(receiver.hasWaitingMessages()){
        
        ofxOscMessage m;
        receiver.getNextMessage(m);
//        cout << receiver.getNextMessage(m);
//         cout << m.getArgType(m);
        
        if (m.getAddress() == "/openbci"){
           // cout << receiver.getNextMessage(m);
             //cout << m.getArgType(i);
            for(int i=0; i<CHANNEL_NUM; i++){
            ofLog() << m.getArgType(i);
//                   cout << m.getArgType(i);
//                 cout << receiver.getNextMessage(m)[i];
               // receive_timeseries.push_back(m.getArgAsFloat(i));
                //                buffer_timeseries.push_back(m.getArgAsFloat(i));
            }
        }
        
    }

}

//--------------------------------------------------------------
void ofApp::draw(){
      drawGraphs();
    if(!receiver.isListening()){
        //cout << "osc not found";
    }
}

//--------------------------------------------------------------

void ofApp::drawGraphs(){
//    for (int i=0; i< CHANNEL_NUM; i++){
//        for(int j = int(ofGetFrameRate() * BUFFER_TIME_SEC)-1; j > 0; j--){
//            buffer_timeseries[i * BUFFER_PER_CHANNEL + j] = buffer_timeseries[i * BUFFER_PER_CHANNEL + j - 1];
//        }
//        buffer_timeseries[i * BUFFER_PER_CHANNEL] = receive_timeseries[i];
//    }
    ofBackground(0);
    for (int i=0; i <CHANNEL_NUM; i++){
        graphCol.push_back(ofColor(ofRandom(255),ofRandom(255),ofRandom(255)));
        ofSetColor(graphCol[i]);
        ofPushMatrix();
        ofTranslate(50, 50+30*i);
        ofDrawBitmapString(i, 4, 0);
        ofTranslate(15,0);
        for(int j = 0; j < BUFFER_PER_CHANNEL-1; j++){
            ofDrawLine((BUFFER_PER_CHANNEL-j)*3, buffer_timeseries[i * BUFFER_PER_CHANNEL + j] * 0.1, (BUFFER_PER_CHANNEL-(j+1))*3, buffer_timeseries[i * BUFFER_PER_CHANNEL + j + 1] * 0.1);
        }
        ofPopMatrix();
    }
}
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
