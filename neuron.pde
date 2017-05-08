static int nID = 0;

class neuron
{
  int id;  
  int x;
  int y;
  int on;
  
  float value;
  float oldvalue;
  float err;
  
  int dx;
  int dy;
  
  ArrayList weights;
    
  neuron()
  {
    id = nID++;
    
    value = 0;

    weights = new ArrayList();
  }
}
