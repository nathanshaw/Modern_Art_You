 class Squares {

 float x1, x2, x3, x4, y1, y2, y3, y4;//global class members
//constructor
Squares(float point1, float point2, float point3, float point4, float point5, float point6, float point7, float point8)
  {
    x1 = point1;
    x2 = point2;
    x3 = point3;
    x4 = point4;
    y1 = point5;
    y2 = point6;
    y3 = point7;
    y4 = point8;
  }

  void update() {
    strokeWeight(random(50));
    stroke(random(200,255),random(200,255),random(150,255));
    fill(random(255));
    quad(x1,x2,x3,x4,y1,y2,y3,y4);
    x1 += random(5);
    x2 += random(8);
    x3 = x3-1;
    x4 = x4 * 1.1;
    y1 = y1 * 1.1;
    y2 = y2*1.1;
    y3 = y3+1;
    y4 = y4-1;
    if (y1 > displayHeight){
     y1 = mouseY; 
    }
    if (y2 > displayHeight) {
     y2 = 20; 
    }
    if (y3 < displayHeight){
     y3 = random(60,1200); 
    }
    if (y4 > displayHeight){
     y4 = -50; 
    }
    if (x1 > displayWidth){
     x1 = mouseX;
    }
    if (x2 > displayWidth) {
     x2 = 20; 
    }
    if (x3 < displayWidth){
     x3 = random(600,1200); 
    }
    if (x4 > displayWidth){
     x4 = -50; 
    }
  }
 }


