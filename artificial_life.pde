final int sx = 200;
final int sy = 200;

float bitesize = 0.1;

ArrayList<Visible> visibles;
Genepool genepool;

PGraphics pg;

int frame = 0;
int rnd = 0;
int rnd_score = 0;

float mutrate = 0.01;

Ent ents[];
int maxents = 25;
Food[] food;

int maxfood = 5;

float a_diff(float a1, float a2)
{  
  float d = a2 - a1;
  
  while (d < -PI)
    d += 2*PI;
  
  while (d > PI)
    d -= 2*PI;
  
  return d;  
}

void setup()
{
  size(200, 200, P2D);
  noSmooth();
  
  Ent te = new Ent(); // temporary entity, used to initialise the genepool to the correct size 
  
  visibles = new ArrayList<Visible>();
  
  genepool = new Genepool(500, te.nn.weights.length);
  //genepool = new Genepool("pool.txt", 500, te.nn.weights.length);
  
  food = new Food[maxfood];
  for (int i = 0; i < maxfood; i++)
    food[i] = new Food();
    
  ents = new Ent[maxents];
  for (int i = 0; i < maxents; i++)
  {
    ents[i] = new Ent();
    ents[i].nn.weights = genepool.getGenes();
    ents[i].nn.reconnect();
  }
  
  background(0);
}

void draw()
{
  background(55);

  for (int i = 0; i < maxents; i++)
  {
    ents[i].v_id = i;
    Visible v = new Visible(ents[i].x, ents[i].y, ents[i].r+0.01, ents[i].g+0.01, ents[i].b+0.01, i);
    visibles.add(v);
  }
  
  for( int i = 0; i < maxfood; i++)
  {
    food[i].update();
    
    Visible v = new Visible(food[i].x, food[i].y, 0.01, 1, 0.01, -1);
    visibles.add(v);
  }
  
  for (int i = 0; i < maxents; i++)
    ents[i].update();
    
  noFill();
  stroke(255, 100);
  
  visibles.clear();  
  frame++;
  if (frame >= 500)
  {
    for (int i = 0; i < maxents; i++)
    {
      ents[i].nn.weights = genepool.getGenes();
      ents[i].nn.reconnect();
      ents[i].x = random(10, sx-10);
      ents[i].y = random(10, sy-10);
      ents[i].a = random(-PI, PI);
      ents[i].energy = 0;
    }
    frame = 0;
    println("new round: " + rnd++ + " round score: " + rnd_score);
    
    //genepool.savePool(); // uncomments to save the genepool after each round
    rnd_score = 0;
    bitesize = 0.1;
  }  
}
