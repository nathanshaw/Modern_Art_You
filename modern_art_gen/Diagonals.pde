class Diagonals
{
  float x, y, speed, thick, grey;//global class members

  //constructor, happens in setup
  Diagonals(float xpos, float ypos, float s, float t, float g)
  {
    x = xpos;
    y = ypos;
    speed = s;
    thick = t;
    grey = g;
  }

  //update functions
  void update() {
    
    strokeWeight(random(30)/thick);
    stroke(mouseY, mouseX, grey);
    line(1440 - x, 1440 - y, x+random(7), x+40);
    line(1440 - x, y+89, x, y);
    line(x * 1.015, y+5, x + random(5), y + random(8));
    
    x = x+(speed/random(30));
    y =  y + speed/15;
    
    
    if (y > displayHeight + 300)
    {
      y = mouseY;
    }
    if (x > displayWidth + 300)
    {
      x = mouseX;
    }
    if (x < displayWidth- 300)
    {
      x = mouseX + random(-40,40);
    }
    if (y < displayHeight - 300)
    {
      y = mouseY + random(-40,40);
    }
  }
}

