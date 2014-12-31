//how do i get the sound to cut out after processing scetch is closed

SqrOsc sqr => Chorus filter => JCRev reverb => NRev reverb1 => Gain master => dac;
SawOsc saw => filter => reverb => reverb1 => dac;
//to be used somehow
SndBuf snare => dac;
SndBuf kick => dac;

0.6 => master.gain => reverb.gain => reverb1.gain;
/*
SinOsc sinx1 => filter => reverb => reverb1 => master => dac;
SinOsc sinx2 => filter => reverb => reverb1 => master => dac;
SinOsc sinx3 => filter => reverb => reverb1 => master => dac;
SinOsc sinx4 => filter => reverb => reverb1 => master => dac;
SinOsc siny1 => filter => reverb => reverb1 => master => dac;
SinOsc siny2 => filter => reverb => reverb1 => master => dac;
SinOsc siny3 => filter => reverb => reverb1 => master => dac;
SinOsc siny4 => filter => reverb => reverb1 => master => dac;

SinOsc sinx1 => reverb => dac;
SinOsc sinx2 => reverb => dac;
SinOsc sinx3 => reverb => dac;
SinOsc sinx4 => reverb => dac;
SinOsc siny1 => reverb => dac;
SinOsc siny2 => reverb => dac;
SinOsc siny3 => reverb => dac;
SinOsc siny4 => reverb => dac;
*/
SinOsc sinx1 => dac;
SinOsc sinx2 => dac;
SinOsc sinx3 => dac;
SinOsc sinx4 => dac;
SinOsc siny1 => dac;
SinOsc siny2 => dac;
SinOsc siny3 => dac;
SinOsc siny4 => dac;

0 => sqr.gain => saw.gain => sinx1.gain => sinx2.gain => sinx3.gain  => sinx4.gain;
0 => siny1.gain => siny2.gain => siny3.gain => siny4.gain;

string kick_samples[4];
me.dir(-1) + "/samples/Kick1.wav" => kick_samples[0];
me.dir(-1) + "/samples/Kick2.wav" => kick_samples[1];
me.dir(-1) + "/samples/Kick3.wav" => kick_samples[2];
me.dir(-1) + "/samples/Kick4.wav" => kick_samples[3];

string snare_samples[2];

me.dir(-1) + "/samples/Snare1.wav" => snare_samples[0];
me.dir(-1) + "/samples/Snare2.wav" => snare_samples[1];

//OscRecv recv1;
OscRecv recv;//creates OSC receiver
12000 => recv.port;// use port 12000
//12003 => recv1.port;//second port for quads
recv.listen();//start listening to OSC
//recv1.listen();
//Create event listener
recv.event("/mouse/click, ii") @=> OscEvent mcEvent;
recv.event("/quad, ffffffff") @=> OscEvent qEvent;
recv.event("/squares, ff") @=> OscEvent sEvent;
recv.event("/mouse/pos, ii") @=> OscEvent mEvent;
// global variables
int x, y, mx, my;
float x1, x2, x3, x4, y1, y2, y3, y4,q,c;

fun void quadHarmony(){
    while(true){
        qEvent => now;
        //gets the data from processing
        qEvent.getFloat() => x1;
        qEvent.getFloat() => x2;
        qEvent.getFloat() => x3;
        qEvent.getFloat() => x4;
        qEvent.getFloat() => y1;
        qEvent.getFloat() => y2;
        qEvent.getFloat() => y3;
        qEvent.getFloat() => y4;
        //if there is a message then do following
        if(qEvent.nextMsg() != 0)
        {
            //random gain level for two sets of four
            Math.random2f(0,0.12) => siny1.gain => siny2.gain => siny3.gain => siny4.gain;
            Math.random2f(0,0.12) => sinx1.gain => sinx2.gain => sinx3.gain  => sinx4.gain;
           //osc for each quar corrident 
            x1/2 => sinx1.freq;
            x2/2 => sinx2.freq;
            x3/2 => sinx3.freq;
            x4/2 => sinx4.freq;
            y1/3 => siny1.freq;
            y2/3 => siny2.freq;
            y3/3 => siny3.freq;
            y4/3 => siny4.freq;    
        }
    }
}

fun void mouseBang(){
    while(true){
        mcEvent => now;
        mcEvent.getInt() => x;
        mcEvent.getInt() => y;
        //<<<x, y>>>;
        if (mcEvent.nextMsg() != 0)
        {
            0.3 => sqr.gain => saw.gain;
            y => sqr.freq;
            x => saw.freq;
            0.1::second => now;
            0 => sqr.gain => saw.gain;
        }   
    }   
}

fun void mousePos(){
    while(1){
        mEvent => now;
        mEvent.getInt() => mx;
        mEvent.getInt() => my;
        if(mEvent.nextMsg() != 0){
        }
    }   
}

fun void sqrEffects(){
    while(1){
        sEvent => now;
        sEvent.getFloat() => float sawX;
        sEvent.getFloat() => float sqrY;
        //<<<q,c>>>;
        kick_samples[2] => kick.read;
        
        if (sEvent.nextMsg() != 0)
        {
            //<<<"hey">>>;
            (sawX * 0.12) => saw.freq;
            (sqrY * 0.8) => sqr.freq;
            Math.random2f(0, 0.2) => saw.gain;
            Math.random2f(0, 0.2) => sqr.gain;
            1::samp => now;
        }
        else{
            //0 => kick.pos;   
            1::samp => now;
        }
    }
}
spork ~ mousePos();
spork ~ sqrEffects();
spork ~ mouseBang();
spork ~ quadHarmony();

while(1){
    0.833::second => now; 
    //<<<x1,x2,x3,x4,y1,y2,y3,y4>>>;
    <<<x,y>>>;
}