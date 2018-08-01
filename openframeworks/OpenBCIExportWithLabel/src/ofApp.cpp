#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofxSubscribeOsc(12345, "/openbci", [&](ofxOscMessage & m){
        if(m.getNumArgs()!=126){
            return;
        }else{
            int id = m.getArgAsInt(0);
            for(int i=1;i<m.getNumArgs();i++){
                float val = m.getArgAsFloat(i);
                int fft_bin = i - 1;
                sensor_data_map[id].data[fft_bin] = val;
                sensor_data_map[id].label = label;
            }
        }
    }
    );

}

//--------------------------------------------------------------
void ofApp::update(){
    //export csv
    if(state == State::RECORDING){
        if(ofGetFrameNum() % num_skip_frames == 0){
            recording_buffer.push_back(sensor_data_map);
        }
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(255);
    
//info
    stringstream ss;

    if(state == State::STOP){
        ss<< "state:STOP" <<endl;
    }
    else if(state == State::PLAYBACK){
        ss<< "state:PLAYBACK" <<endl;
    }
    else if(state == State::RECORDING){
        ss<< "state:RECORDING" <<endl;
    }
    
    ss<< "num_fft:" << num_fft << endl;
    ss<< "num_sensors:" << num_sensors <<endl;
    ss<< "num_skip_frames:" << num_skip_frames << endl;

    ss<<"count :"<<counter_seq << endl;
    ss<<"bufsize:"<<recording_buffer.size() << endl;
    ss<<"label = " << label<<endl;
    ss << endl;
    ss<<"---key command---"<<endl;
    ss<<"1~4: label" <<endl;
    ss<<"s:stop"<<endl;
    ss<<"r:record"<<endl;
    ss<<"p:play"<<endl;
    ss<<"c:clear recording"<<endl;
    ofSetColor(0);
    ofDrawBitmapString(ss.str(), 10, 30);
    
    float graph_width = 480;
    float graph_height = 240.;

    ofPushMatrix();
    ofTranslate(0, 250);
    ofNoFill();
    ofDrawRectangle(0, 0, graph_width, graph_height);
    
    if(state == State::STOP || state == State::RECORDING){
        for(auto a: sensor_data_map){
            ofPolyline poly;
            auto data = a.second.data; // FFTData.data
            for(int i=0;i<data.size();i++){
                float px = ofMap(i, 0, data.size() - 1, 0, graph_width - 1);
                float val = data[i];
                
                float ph_log = ofClamp(ofMap(log10(val), -1, 3, 0, graph_height), 0, graph_height);
                poly.addVertex(px, graph_height - ph_log);
            }
            ofSetColor(color_list[a.first]);
            poly.draw();
        }
    }
    else if(state == State::PLAYBACK){
        auto data_map = recording_buffer[counter_seq];
        for(auto a: data_map){
            ofPolyline poly;
            auto data = a.second.data; // FFTData.data
            for(int i=0;i<data.size();i++){
                float px = ofMap(i, 0, data.size() - 1, 0, graph_width - 1);
                float val = data[i];
                
                float ph_log = ofClamp(ofMap(log10(val), -1, 3, 0, graph_height), 0, graph_height);
                poly.addVertex(px, graph_height - ph_log);
            }
            ofSetColor(color_list[a.first]);
            poly.draw();
        }
        if(ofGetFrameNum() % num_skip_frames == 0){
            counter_seq++;
        }
        if(counter_seq > recording_buffer.size() - 1){
            counter_seq = 0;
        }
    }
    
    if(state == State::RECORDING){
        ofPushStyle();
        ofSetLineWidth(4);
        ofSetColor(255, 0, 250, 100);
        ofDrawRectangle(0, 0, ofGetWidth(), ofGetHeight());
        ofPopStyle();
    }
    
    ofPopMatrix();
    
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    // set label
    if(key == '1'){
        label = 1;
    }
    else if(key == '2'){
        label = 2;
    }
    else if(key == '3'){
        label = 3;
    }
    else if(key == '4'){
        label = 4;
    }
    
    // change state
    else if(key == 'p'){
        state = State::PLAYBACK;
    }
    else if(key == 's'){
        state = State::STOP;
    }
    else if(key == 'r'){
        state = State::RECORDING;
    }
    // clear recording buffer
    else if(key == 'c'){
        recording_buffer.clear();
    }

    // export file
    // it should be another thread but ok for now
    else if(key == 'e'){
        ofFile file(ofGetTimestampString() + ".txt",ofFile::WriteOnly);
        cout << "export line size = " << recording_buffer.size() << endl;
        for(int i=0; i<recording_buffer.size(); i++){
            for(auto a: recording_buffer[i]){
                auto data = a.second.data;
                int id = a.second.label;
                file << id << ",";
                
                for(int j=0; j<data.size();j++){
                    //last line
                    file << data[j];
                    if(j == data.size() - 1){
                        file << endl;
                    }else{
                        file << ",";
                    }
                }
            }
        }
        file.close();
    }

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
