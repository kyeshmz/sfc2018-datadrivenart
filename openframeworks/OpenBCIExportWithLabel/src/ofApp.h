#pragma once

#include "ofMain.h"
#include "ofxPubSubOsc.h"

const int num_fft = 125;
const int num_sensors = 16;
const int num_skip_frames = 5;

// FFT
class FFTData{
public:
    vector<float> data;
    int label;
    FFTData(){
        data = vector<float>(num_fft, 0.f);
        label = -1;
    }
};

// state
enum State : char{
    STOP = 0,
    PLAYBACK,
    RECORDING,
    NUM_STATE
};

// graph color, same as OpenBCI_GUI
const vector<ofColor> color_list =
{
    {129, 129, 129},
    {127, 75, 141},
    {54, 87, 158},
    {49, 113, 89},
    {221, 178, 13},
    {253, 94, 52},
    {224, 56, 45},
    {162, 82, 49},
    {129, 129, 129},
    {124, 75, 141},
    {54, 87, 158},
    {49, 113, 89},
    {221, 178, 13},
    {253, 94, 52},
    {224, 56, 45},
    {162, 82, 49}
};

class ofApp : public ofBaseApp{
    int label = 0;
    int counter_seq = 0;
    
    // fft data(num_fft) x num_sensors
    unordered_map<int, FFTData > sensor_data_map;
    // container for buffer
    vector< unordered_map<int, FFTData> > recording_buffer;
    // state
    State state = State::STOP;

	public:
		void setup();
		void update();
		void draw();

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
		
};
