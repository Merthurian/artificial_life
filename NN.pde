float e = (float)Math.E;

class NN
{
  neuron inlayer[];
  neuron hidlayers[][];
  neuron outlayer[];
  
  int ins;
  int outs;
  int layers;
  int perlayer;
  
  float lc;
  
  int pass;
  int maxpass;
  
  float[] weights;

  NN (int ins_, int outs_, int layers_, int perlayer_)
  {
    ins = ins_;
    outs = outs_;
    layers = layers_;
    perlayer = perlayer_;
    
    pass = 0;
    maxpass = 20;

    inlayer = new neuron[ins];
    hidlayers = new neuron[layers][perlayer];
    outlayer = new neuron[outs];
    
    init();   
    //println(weights.length);
    
    lc = 0.5/weights.length;
    
    connect();
  }
 
  void reweight()
  {
    for (int i = 0; i < weights.length; i++)
      weights[i] = random(-1, 1);
    reconnect();    
  }   

  void init() 
  {
    for (int i = 0; i < ins; i++)
    {
      inlayer[i] = new neuron();
    }
    
    for (int x = 0; x < layers; x++)
    {
      for (int y = 0; y < perlayer; y++)
        hidlayers[x][y] = new neuron();
    }
    
    for (int i = 0; i < outs; i++)
    {
      outlayer[i] = new neuron();
    }  
    weights = new float[((ins*perlayer) + (perlayer*perlayer*(layers)) + (perlayer*outs))];
    
    for (int i = 0; i < weights.length; i++)
      weights[i] = random(-1, 1);  
  }
 
  void connect()
  {
    int index = 0;
    for (int i = 0; i < ins; i++)
    {
      for (int n = 0; n < perlayer; n++)
      {
        inlayer[i].weights.add(weights[index++]);
      }
    } 
   
    for (int x = 0; x < layers; x++)
    {
      for (int y = 0; y < perlayer; y++)
      {
        if (x == layers-1)
        {
          for (int n = 0; n < outs; n++)
          {
            hidlayers[x][y].weights.add(weights[index++]);
          }
        }
        else
        {
          for (int n = 0; n < perlayer; n++)
          {
            hidlayers[x][y].weights.add(weights[index++]);
          }
        }  
      }        
    }
  }
  
  void reconnect()
  {
    int index = 0;
    for (int i = 0; i < ins; i++)
    {
      for (int n = 0; n < perlayer; n++)
      {
        inlayer[i].weights.set(n, weights[index++]);
      }
    } 
   
    for (int x = 0; x < layers; x++)
    {
      for (int y = 0; y < perlayer; y++)
      {
        if (x == layers-1)
        {
          for (int n = 0; n < outs; n++)
          {
            hidlayers[x][y].weights.set(n, weights[index++]);
          }
        }
        else
        {
          for (int n = 0; n < perlayer; n++)
          {
            hidlayers[x][y].weights.set(n, weights[index++]);
          }
        }  
      }  
    }
  }
  float sinh(float x)
  {
    return 0.5*(pow(e, x) - pow(e, -x));
  }

  float cosh(float x)
  {
    return 0.5*(pow(e, x) + pow(e, -x));
  }
  
  float tanh(float x)
  {
    return sinh(x)/cosh(x);
  }
  
  float sech(float x)
  {
    return 1/cosh(x);
  }
  
  float sigmoid(float x)
  {
    float a = pow(e, x);
    
    float b = pow(e, -x);
   
    return (0.5 * (a - b))/(0.5 * (a + b));
    //return 1/(1+pow(e,-x));
    //return 2.0/(1.0 + pow(e, -x*2.0)) -1;
    //return tanh(x);
  }
  
  float derivative(float x)
  {
    return 1.0/pow(cosh(x), 2);
  }
  
  void backprop(float[] err)
  {
    pass++;
    for (int i = 0; i < outs; i++)
    {
      outlayer[i].err += err[i];
      for (int n = 0; n < perlayer; n++)
      {
        hidlayers[layers-1][n].err += (Float)hidlayers[layers-1][n].weights.get(i)* outlayer[i].err;        
      }
    }
    
    for (int i = layers-1; i > 0; i--)
    {
      for (int n = 0; n < perlayer; n++)
      {
        for (int j = 0; j < perlayer; j++)
        {
          hidlayers[i-1][j].err += (Float)hidlayers[i-1][n].weights.get(n)*hidlayers[i][n].err;
        }
      }
    }
    
    for (int n = 0; n < perlayer; n++)
    {
      for (int i = 0; i < ins; i++)
      {
        inlayer[i].err += (Float)inlayer[i].weights.get(n)*hidlayers[0][n].err;
        //println(inlayer[i].err);
      }
    }
    if (pass >= maxpass)
      backprop2();
  }
  
  void backprop2()
  {
    for (int i = 0; i < ins; i++) 
    {
      for (int n = 0; n < perlayer; n++)
      {
        float w = (Float)inlayer[i].weights.get(n);
        float d = hidlayers[0][n].err/pass;
        inlayer[i].weights.set(n, w + (d * lc * derivative(inlayer[i].oldvalue)));
        float temp = (Float)inlayer[i].weights.get(n);
        if(temp > 1.0 || temp < -1.0)
          inlayer[i].weights.set(n, random(-1, 1));
      }
    } 
   
    for (int x = 0; x < layers; x++)
    {
      for (int y = 0; y < perlayer; y++)
      {       
        if (x == layers-1)
        {
          for (int n = 0; n < outs; n++)
          {
            float w = (Float)hidlayers[x][y].weights.get(n);
            float d = outlayer[n].err/pass;  
            hidlayers[x][y].weights.set(n, w + (d * lc * derivative(hidlayers[x][y].oldvalue)));            
            
            float temp = (Float)hidlayers[x][y].weights.get(n);
            if(temp > 1.0 || temp < -1.0)
              hidlayers[x][y].weights.set(n, random(-1, 1));
          }
        }
        else
        {
          for (int n = 0; n < perlayer; n++)
          {
            float w = (Float)hidlayers[x][y].weights.get(n);
            float d = hidlayers[x+1][n].err/pass;
            hidlayers[x][y].weights.set(n, w + (d * lc * derivative(hidlayers[x][y].oldvalue))); 
      
            float temp = (Float)hidlayers[x][y].weights.get(n);
            if(temp > 1.0 || temp < -1.0)
              hidlayers[x][y].weights.set(n, random(-1, 1));      
          }
        }  
      }        
    }
    
    backprop3();
  }
  
  void backprop3()
  {
    for (int i = 0; i < ins; i++)
    {
      inlayer[i].err = 0.0;
    }
    for (int x = 0; x < layers; x++)
    {
      for (int y = 0; y < perlayer; y++)
        hidlayers[x][y].err = 0.0;
        
    }
    for (int i = 0; i < outs; i++)
    {
      outlayer[i].err = 0.0;
    }
    pass = 0;
  }
  
  float[] update(float[] input)
  {
    for (int i = 0; i < ins; i++)
    {
      inlayer[i].oldvalue = inlayer[i].value;
      inlayer[i].value = input[i];
      for (int n = 0; n < perlayer; n++)
      {
        float w = (Float)inlayer[i].weights.get(n);
        hidlayers[0][n].value += inlayer[i].value*w;
      }
    } 
   
    for (int x = 0; x < layers; x++)
    {
      for (int y = 0; y < perlayer; y++)
      {
        //hidlayers[x][y].oldvalue = hidlayers[x][y].value;
        hidlayers[x][y].value = sigmoid(hidlayers[x][y].value);
        hidlayers[x][y].oldvalue = hidlayers[x][y].value;
        
        if (x == layers-1)
        {
          for (int n = 0; n < outs; n++)
          {
            float w = (Float)hidlayers[x][y].weights.get(n);
            outlayer[n].value += hidlayers[x][y].value*w;
          }
        }
        else
        {
          for (int n = 0; n < perlayer; n++)
          {
            float w = (Float)hidlayers[x][y].weights.get(n);
            hidlayers[x+1][n].value += hidlayers[x][y].value*w;       
          }
        }  
      }        
    }
        
    float[] ret = new float[outs];
    
    //drawconnect();
    //drawnet();
        
    // Reset for next frame
    for (int i = 0; i < outs; i++)
    {
      outlayer[i].value = sigmoid(outlayer[i].value);
      outlayer[i].oldvalue = outlayer[i].value;
    }
    for (int i = 0; i < outs; i++)
    {
      ret[i] = outlayer[i].value;
    }
    
    for (int i = 0; i < ins; i++)
      inlayer[i].value = 0.0;
      
    for (int x = 0; x < layers; x++)
    {
      for (int y = 0; y < perlayer; y++)
        hidlayers[x][y].value = 0.0;
    }
    
    for (int n = 0; n < outs; n++)
      outlayer[n].value = 0.0;
      
    //for (int i = 0; i < outs; i++)
    //  ret[i] = sigmoid(ret[i]);
           
    return ret;
  }
  
}


