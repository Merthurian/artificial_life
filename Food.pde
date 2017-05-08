class Food
{
  float x, y, a, speed;
  float health;
   
  Food()
  {
    health = 1.0;
    x = random(0, sx);
    y = random(0, sy);
    
    speed = 0;
    
    a = random(-PI, PI);
  }
  
  void update()
  {
    //float ab = atan2((sx/2) -x, (sy/2) - y);
   
//    if (x > sx)
//      x -= sx;
//    if (x < 0)
//      x += sx;
//      
//    if (y > sy)
//      y -= sy;
//    if (y < 0)
//      y += sy;
    
    if ((x < 12) || (y < 12) || (x > sx-12) || (y > sy-12))
    {
      a += random(-1, 1);
      speed += 0.1;
    }

    speed *= 0.95;
    if (speed < 0.3)
      speed = 0.3;  
      
    a += random(-speed, speed)*0.5;
      
    x += sin(a)*speed;
    y += cos(a)*speed;
    
    x = constrain(x, 5, sx-5);
    y = constrain(y, 5, sy-5);
      
    fill(0, 255, 0);
    noStroke();
    ellipse(x, y, 6, 6);    
  }
}
