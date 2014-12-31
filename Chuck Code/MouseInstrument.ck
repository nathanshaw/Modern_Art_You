public class ChordSynth
{
    //creates a master gain stage
    Gain master => BiQuad f => ADSR env => JCRev reverb => Pan2 masterPan => dac;
    //three Osc's to play 5th chord
    FMVoices root => Pan2 pan1  => master;
    FMVoices fifth => Pan2 pan2 =>  master;
    FMVoices octave => Pan2 pan3 =>  master;
    //tri osc to reenforce the root
    FMVoices main => Pan2 pan4 => master;
    
    SndBuf sfx => dac;
    
    
    
    me.dir() + "/audio/stereo_fx_04.wav" => sfx.read;
    
    sfx.samples() => sfx.pos;
    
    0.3 => master.gain => root.gain => fifth.gain => octave.gain;
    // set biquad pole radius
    .9 => f.prad;
    // set biquad gain
    .5 => f.gain;
    // set equal zeros 
    3 => f.eqzs;
    // our float
    0.0 => float t;
    
    fun void pfreq ( float freq )
    {
        freq => f.pfreq;   
    }
    fun void prad ( float level)
    {
        level => f.prad;
    }
    
    fun void fgain ( float level)
    {
        level => f.gain;   
    }    
    //reverb => Gain feedbackGain => reverb;
    //default value for feedback
    //0.095 => feedbackGain.gain;
    
    
    //i want to create an lfo to adjust the pitch of the different OSC, as a sort of tuning drift
    //how do i do that, i cant chuck an LFO to a float, how do i get the OSC's data into a variable?
    
    //default panning positions
    0 => pan1.pan => pan4.pan;
0.5 => pan2.pan;
-0.5 => pan3.pan;
0.2 => reverb.mix;
1 => reverb.gain;
//tone cap for whatever key
fun void panSpread (float amount)
{
    if ( (amount < 1) || (amount > -1))
    {
        amount => pan1.pan => pan4.pan;
        amount*-1 => pan2.pan => pan3.pan;
    } 
    else
    {
        0 => pan1.pan => pan4.pan;
        0.5 => pan2.pan;
        -0.5 => pan3.pan;  
    }
}

(400::ms, 305::ms,0.35,300::ms) => env.set;
//1 => env.keyOn;
fun void envSet (int a, int d, float s, float r)
{
    //here, I think you typoed. previously you defined env1 all three times
    (a::ms,d::ms,s,r::ms) => env.set;
    
}
fun float freq (float freq)
{
    freq => root.freq => main.freq;
    freq*1.5 => fifth.freq;
    freq*2 => octave.freq; 
    1 => env.keyOn;
    return float freq;
}

fun void noteOn (int value)
{
    Math.random2f(0,1) => root.vowel => fifth.vowel => octave.vowel => main.vowel;
    value*0.2 => master.gain;
    Math.random2f(0.6,.9) => f.prad;
    // set biquad gain
    Math.random2f(0.4,.6) => f.gain;
    // set equal zeros 
    Math.random2(2,4) => f.eqzs;
    1 => root.noteOn => fifth.noteOn => octave.noteOn => main.noteOn;
    // our float
    
    
    
    if (value > 0)
    {
        //1 => status;
        320000 => sfx.pos;
        -0.25 => sfx.rate;
        value => env.keyOn;
        while (env.state() < 2)
        {
            1::samp => now;
        }
        //2 => status;
        1 => env.keyOff;
        while (env.state() != 4)
        {
            1::samp => now;
        }
        //0 => status;
    }   
}
fun void noteOff (int value)
{
    0 => master.gain;
    1::samp => now;   
}


fun void space (float gain)
{
    gain => reverb.mix;   
}

//why does this not work?

/*
fun void feedback (float amount)
{
    if ((amount >= 0) && (amount <= 0.97))
    { 
        amount => feedbackGain.gain;
    }
    else 
    {
        0.55 => feedbackGain.gain;   
    }
}

fun void detuneFifth (float cents)
{
    
    cents + freq => float modulated;
    modulated => fifth.freq;
}
*/

}

Hid hi;

HidMsg msg;



0 => int device;

if (!hi.openMouse(device))
{ 
    me.exit();
}

<<<"mouse : " + hi.name() + " ready" >>>;
0 => int initalize;

fun void mouse()
{
    ChordSynth a;
    FMVoices s => Echo delay => ResonZ filt => JCRev rev =>dac.left;
    FMVoices tri => delay => filt => rev => dac.right;
    SndBuf snare => JCRev rev2 => dac;
    SndBuf bell => rev2 => dac;
     
     0.3 => snare.gain => bell.gain;
     0.2 => rev2.mix;
    
    
    me.dir() + "/audio/cowbell_01.wav" => bell.read; 
    me.dir() + "/audio/snare_01.wav" => snare.read;
    
    bell.samples() => bell.pos;
    snare.samples() => snare.pos;
    
    while (initalize == 0)
        
        {
            
            0 => s.gain => tri.gain;
            1::samp => now;
            initalize++;
        }
        while ( true )
        {
            hi => now;
            0.0 => float t;
            while ( hi.recv( msg ) )
            {
                if( msg.isButtonDown())
                {
                    0 => s.gain => tri.gain;
                    [50,57,59,38,62] @=> int tone[]; 
                    Std.mtof(tone[Math.random2(0,4)]) => float root;
                    //<<<root>>>; 
                    root => a.freq;
                    (50,30,0.1,300) => a.envSet;
                    1 => a.noteOn;
                    
                    
                    //500::ms => now;
                    //1 => a.noteOff;
                }  
                
                else if ( msg.isMouseMotion())
                {
                    0.2 => rev.mix;
                    0.85 => rev.gain;
                    if ( (msg.deltaX > 2) || (msg.deltaX < -2) )
                    {
                        
                        
                        
                        if ((msg.deltaX > 25) || (msg.deltaX < -25))
                        {
                            
                            Math.random2f(0.1,0.12) => s.gain;  
                            
                        }
                        if ((msg.deltaX > 40) || (msg.deltaX < -40))
                        {
                            snare.samples() => snare.pos;
                            Math.abs(msg.deltaX)*Math.random2f(-.01,-.19) => snare.rate;
                        }
                        
                        //<<< " Mouse Delta X:", msg.deltaX>>>;
                        //<<< msg.deltaX/10.0 >>>;   
                        msg.deltaX => float xValue;
                        //<<<xValue>>>;
                        Math.fabs(xValue) => xValue;
                        
                        xValue*25 => s.freq;
                        1 => s.noteOn;
                        xValue*0.1 => a.panSpread;
                        msg.deltaX*2 => s.freq;
                        //1000::samp => now;
                        
                    }   
                    if ((msg.deltaY > 7) || (msg.deltaY < -7) )
                    {
                        if((msg.deltaY < -25) || (msg.deltaY > 25))
                        {
                            Math.random2f(0.1,0.12) => float trigain;
                            trigain => tri.gain;   
                            
                        }
                        if((msg.deltaY < -40) || (msg.deltaY > 40))
                        {
                            bell.samples() => bell.pos;
                            Math.abs(msg.deltaY)*Math.random2f(-.1,-.3) => bell.rate;  
                        }
                        //<<< " Mouse Delta Y:", msg.deltaY>>>;
                        
                        Math.fabs(msg.deltaY) => float yValue;
                        yValue*2 :: ms  => delay.delay;
                        yValue*5 => tri.freq;
                        
                        
                        //this make the mouse y axis effect which vouls are played
                        if (msg.deltaY > 60)
                        {
                            Math.random2f(0,1) =>  s.vowel;
                            Math.random2f(0,1) => tri.vowel;
                            //1 => tri.noteOn => s.noteOn;
                        }
                        
                        if (msg.deltaY < -60)
                        {
                            Math.random2f(0,1) => s.vowel;
                            Math.random2f(0,1) => tri.vowel;
                            
                        }
                        else
                        {
                            1 => tri.noteOff;   
                        }
                        
                        yValue*0.15 => float ST;
                        if (ST > 0.8)
                        {
                            0.8 => ST;   
                        }
                        else
                        {
                            ST => tri.spectralTilt => s.spectralTilt;   
                        }
                        //25::ms => now;
                    }
                    
                    else
                    {
                        for (0.525 => float trigain; trigain > 0.051;)
                        {
                            trigain *0.98 => trigain;
                            trigain => tri.gain;
                            // 0.5::samp => now;
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    
    //actual program
    
    
    
    
    
    spork ~ mouse();
    1::week => now;
    //program proper
    0 => float autoPan;
    /*
    while (true)
    {
        
        for (0 => float autoPan, autoPan =< 1.0)
        {
            autoPan + 0.02 => autoPan;
            autopan => masterPan.pan;
            10::ms => now;   
        }
        if ((autopan > -1) && (autopan < 0))
        {
            autoPan - 0.02 => autoPan;
            autopan => masterPan.pan;   
            10::ms => now;
        }
        
    }
    */