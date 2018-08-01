#pragma once

#include "ofMain.h"
//#include "ofxOpenBCI.hpp"
#include "ofxOsc.h"
#include "ofxGui.h"
//#include "ofxPubSubOsc.h"

#define RECEIVE_PORT 12345
#define RECEIVE_ADDRESS "/openbci"
#define SEND_HOST "127.0.0.1"
#define SEND_PORT 8889

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();
        void drawGraphs();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
		
    ofxOscReceiver receiver;
    ofxOscSender sender;
    ofxPanel gui;
    ofxToggle sendOSC;
    
    static const int CHANNEL_NUM = 16;
    static constexpr float BUFFER_TIME_SEC = 5.0;
    static const int BUFFER_PER_CHANNEL = int(30*BUFFER_TIME_SEC);
    float buffer_timeseries[BUFFER_PER_CHANNEL * CHANNEL_NUM];
    float receive_timeseries[CHANNEL_NUM];
    ofColor graphCol[CHANNEL_NUM];
//    ofColor col[];
};
