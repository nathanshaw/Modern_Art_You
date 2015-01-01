        import oscP5.*;
        import netP5.*;
        import processing.video.*;
        //networking with osc
        OscP5 oscp5;
        NetAddress myRemoteLocation;
        Capture cam;
        //variables
        String name;//this will one day print out a file with a number after but i am having problems
        int t1, t2, c, x, y, oldNum;
        float chance;
        int shot = 0;//this will count up and give each screenshot a number
        int videoCount = 0;//this is the number that the modulos use for updating each screenshot
        int rL,gL,bL;
        
        
       // boolean sketchFullScreen() {
        //  return true;
        //}
        
        //set-up function
        void setup()
        {
          //get a list of available camera modes and list them
          String[] cameras = Capture.list();//puts all the capture divices available into an array while you can then print out later
          frameRate(15);
          size (displayWidth/2, displayHeight/2); 
          cam = new Capture(this, cameras[0]); //this designates my high res, 1fps camera as the one we capture
          cam.start(); //starts routing camera data into processing
            oscp5 = new OscP5(this, 12001);//listening port
        myRemoteLocation = new NetAddress("127.0.0.1", 12000);//the IP address of my PC
          //println(displayWidth,displayHeight);
          //size (640,480);
          if (cameras.length == 0) {
           println("There are no cameras available for capture.");
           exit();
           } else {
           println("Available cameras:");
           for (int i = 0; i < cameras.length; i++) {
           println(cameras[i]);
           }
           
           // The camera can be initialized directly using an 
           // element from the array returned by list():
           
           } 
        }
         
        //the draw function
        
        //i want to make sure that it stops only for one frame not two after
        void draw()
        {
         // x = mouseX;
          //y = mouseY;
         videoCount += 1;
          if (videoCount % 7 == 1) {
            image(cam, 0, 0, displayWidth/4, displayHeight/4);
            tint(rL, gL,bL);
            
          }
          else if (videoCount % 8 == 1) {
            image(cam, 0, displayHeight/4, displayWidth/4, displayHeight/4);
            tint(rL, gL,bL);
            
          }
          else if (videoCount % 12 == 1) {
            image(cam, displayWidth/4, 0, displayWidth/4, displayHeight/4);
           tint(rL, gL,bL);
            
          }
          else if (videoCount % 20 == 1) {
            image(cam, displayWidth/4, displayHeight/4, displayWidth/4, displayHeight/4);
            tint(rL, gL,bL);
          }
            
        
          if (cam.available() == true) {
            cam.read();
          }
          else{
           println("error, camera not working"); 
          }
          smooth();
          
          if (mousePressed == true) {
            frameRate(.3);
            name = "Modern Art" + str(shot) + ".jpg";
            println(name);
            save(name);
            sendMouseClick();
            shot++;
          }
          else {
            frameRate(30);
            videoCount++;
          }
        }
        
        //functions to send OSC to chuck
        void sendMousePos() {
          OscMessage mousePos = new OscMessage("/mouse/pos");
          mousePos.add(x);
          mousePos.add(y);
          oscp5.send(mousePos, myRemoteLocation);
        }
        void sendMouseClick() {
          
          OscMessage myMessage = new OscMessage("/mouse/click");
          myMessage.add(x);
          myMessage.add(y);
          //println("x: ", x, "y: ", y);
          oscp5.send(myMessage, myRemoteLocation);
        
        }
      void oscColorEvent(OscMessage xmit){
        println("Pattern: " + xmit.addrPattern());
        //println("TypeTag: " + msg.checkTypetag());
        
        if (xmit.checkAddrPattern("/color") == true){
         if (xmit.checkTypetag("if")){
          rL = xmit.get(0).intValue();
          gL = xmit.get(1).intValue();
          bL = xmit.get(2).intValue();
          println(rL,gL,bL);
         } 
      }
      }
