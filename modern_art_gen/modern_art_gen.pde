import oscP5.*;
import netP5.*;
//networking with osc
OscP5 oscp5;
NetAddress myRemoteLocation;

  boolean sketchFullScreen(){
 return true; 
 }
 
 //variables
String name;//this will one day print out a file with a number after but i am having problems
int t1, t2, c, x, y;
float chance;
int shot = 0;//this will count up and give each screenshot a number
int updateCount = 0;
int walkerNumber = 25;
int squareNumber = 2;
int smartNumber = 4;
int lineNumber = 10;
//arrays
Diagonals lineArr[];
smartWalker smartArr[];//what exactally does this do?
walker walkerArr[];
Squares squareArr[];
//set-up function
void setup()
{
  walkerArr = new walker[walkerNumber];
  squareArr = new Squares[squareNumber];
  smartArr = new smartWalker[smartNumber];
  lineArr = new Diagonals[lineNumber];
  frameRate(15);
  size (displayWidth, displayHeight,OPENGL); 
  println(displayWidth,displayHeight);
  //size (500, 500);

  for (int i = 0; i < smartNumber; i++){
   smartArr[i] = new smartWalker(int(random(200,1000)), int(random(200,1000)), int(random(5,90)), int(random(10,100)), int(random(3,8))); 
  }
  
  for (int i = 0; i < squareNumber; i++){
   squareArr[i] = new Squares(int(random(40,200)), int(random(20,200)), int(random(20,200)), int(random(20,200)), int(random(20,200)), int(random(20,200)), int(random(20,200)), int(random(20,200)));
  }
  
  for(int i=0; i<walkerNumber; i++)
  {
    walkerArr[i] = new walker(int(random(50,800)),int(random(50,800)), int(random (3,50)), int(random(2,20)));
  }
  for(int i = 0; i < lineNumber;i++){
    lineArr[i] = new Diagonals(int(random(200,800)), int(random(50,800)),int(random(60,460)), int(random(2,6)), int(random(10,210)));
  }
  oscp5 = new OscP5(this, 12001);//listening port
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);//the IP address of my PC
}
//the draw function

//i want to make sure that it stops only for one frame not two after
void draw()
{
  smooth();
  background(0);
  
  for (int i = 0; i < lineNumber; i++){
    lineArr[i].update();
  } 
  for (int i = 0; i < squareNumber; i++){
   squareArr[i].update(); 
  }
  for (int i = 0; i < walkerNumber; i++){
    walkerArr[i].update();
  }
  for ( int i = 0; i < smartNumber; i++)
  {
   smartArr[i].update(); 
  }
  x = mouseX;
  y = mouseY;
  //the functions that i call
  sendMousePos();
  sendQuadInfo(squareArr[1].x1, squareArr[1].x2, squareArr[1].x3, squareArr[1].x4, squareArr[1].y1, squareArr[1].y2, squareArr[1].y3, squareArr[1].y4);
  updateCount += 1;
  
  if (mousePressed == true) {
    frameRate(.3);
    name = "Modern Art" + str(shot) + ".jpg";
    println(name);
    save(name);
    sendMouseClick();
    shot++;
  }
  else {
    frameRate(random(10,20));
  }
}
void sendQuadInfo(float x1, float x2, float x3, float x4, float y1, float y2, float y3, float y4) {
  OscMessage myInfo = new OscMessage("/quad");
  myInfo.add(x1);
  myInfo.add(x2);
  myInfo.add(x3);
  myInfo.add(x4);
  myInfo.add(y1);
  myInfo.add(y2);
  myInfo.add(y3);
  myInfo.add(y4);
  //print(x1, x2, x3, x4, y1, y2, y3, y4);
  oscp5.send(myInfo, myRemoteLocation);
}
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
void sendSmartSquares(float sx, float sy) {
  OscMessage squareInfo = new OscMessage("/squares");
  squareInfo.add(sx);
  squareInfo.add(sy);
  oscp5.send(squareInfo, myRemoteLocation);
}

