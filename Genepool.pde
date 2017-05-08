class Genepool
{
  //ArrayList<float[]> pool;
  
  float[][] pool;
  
  int poolmax;
  int gmax;
  
  int index;
  
  Genepool(int pm, int gm)
  {
    pool = new float[pm][gm];
    gmax = gm;
    poolmax = pm;
    index = 0;
    
    for (int p = 0; p < poolmax; p++)
    {
      for (int g = 0; g < gmax; g++)
        pool[p][g] = random(-1, 1);
    }
  }
  Genepool(String filename, int pm, int gm)
  {
    String[] p = loadStrings(filename);
    poolmax = pm;
    gmax = gm;
    pool = new float[pm][gm];
    for (int pl = 0; pl < poolmax; pl++)
    {
      for (int g = 0; g < gmax; g++)
        pool[pl][g] = random(-1, 1);
    }
    for (int i = 0; i < p.length; i++)
    {
      float[] g = float(split(p[i], ' '));
      //println(g);
      addGenes(g);  
    }
    index = 0;  
  }
  
  void addGenes(float[] g)
  {
    pool[(index++)%poolmax] = g;
  }
  
  void savePool()
  { 
    pg = createGraphics(poolmax, gmax, P2D);
    
    String[] p = new String[poolmax];
    for (int i = 0; i < poolmax; i++)
    {
      float[] g = pool[i];
      String s = new String();
      for (int j = 0; j < gmax; j++)
      {
        float loci = g[j];
        s += str(loci);
        if(j < gmax-1)
          s += ' ';
        loci = map(loci, -1, 1, 0, 255);
        pg.set(i, j, color(loci, loci, loci));
      }  
      p[i] = s;
      
    }
    
    pg.save("snapshot.tif");  
        
    saveStrings("pool.txt", p);  
    println("pool saved");  
  }
  
  float[] getGenes()
  {
    float[] a = pool[int(random(0, poolmax))];
    float[] ret = new float[gmax];
    
    for (int i = 0; i < gmax; i++)
      ret[i] = a[i];
    
    if(random(0, 1) > 0.5)
    {           
      return ret;
    }
    
    if(random(0, 1) > 0.5)
    {           
      float[] b = pool[int(random(0, poolmax))];
      
      //println(a.length + " " + b.length + " " + ret.length);
      
      for (int i = 0; i < ret.length; i++)
      {
        if (random(0, 1) > 0.5)
          ret[i] = b[i];        
      }
    }
    
    float n = random(0, 1);
    
    int c = 0;
        
    while ((n < 0.5) && (c < 10))
    {
      n = random(0,1);
      int r = int(random(0, ret.length));
      if(n < 0.05)
        ret[r] = random(-1, 1);    
      else
        ret[r] = constrain(ret[r] + random(-0.1, 0.1), -1, 1);  
      n = random(0, 5);
      c++;
    }

    return ret;
  }
}
