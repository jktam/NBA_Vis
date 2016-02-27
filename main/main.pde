import de.bezier.guido.*;  //for list box menu
import java.util.*;
Queue trails;// = new ArrayDeque();
//ball is life

HScrollbar hs1;  // scrollbar
//PImage img1, img2;  // Two images to load
PShape court;
Listbox listbox;  //for list menu
//Listbox listbox2;  //for list menu
Object lastItemClicked;  //for list menu and interaction

Table teamtable;
Table playertable;
Table gametable;
Player[] players;

ArrayList<Position> ballpositions;
float listlenball;
float listlenpos;
ArrayList<Position> position1;
ArrayList<Position> position2;
ArrayList<Position> position3;
ArrayList<Position> position4;
ArrayList<Position> position5;
ArrayList<Position> position6;
ArrayList<Position> position7;
ArrayList<Position> position8;
ArrayList<Position> position9;
ArrayList<Position> position10;


//SCALE MULTIPLIER
float SCALE = 6;

//court design origin
float cxo;
float cyo;

float xo, yo;

Table eventTable;
ArrayList<String> eventList;

String chosenGameId = "0041400101";
int chosenHomeId = 1610612737;
int chosenAwayId = 1610612751;
String chosenHomeName = "Home Team";
String chosenAwayName = "Away Team";
String chosenHomeAbbr = "HOM";
String chosenAwayAbbr = "AWY";

String fname;
int previousTickIndex = 0; //if currentTickIndex < prev, then undraw path
boolean pathball = false;
boolean path1 = false;
boolean path2 = false;
boolean path3 = false;
boolean path4 = false;
boolean path5 = false;
boolean path6 = false;
boolean path7 = false;
boolean path8 = false;
boolean path9 = false;
boolean path10 = false;
boolean buttonOver = false;
int rectX, rectY;      // Position of square button

void setup() {
  size(1024, 768);
  //xo = width/2;
  //yo = height/2;

  //ui elements
  Interactive.make(this);  //make list manager
  listbox = new Listbox(width/1.5, height/8, width/4, height/1.3);
  setupListbox();

  //listbox2 = new Listbox(width/14, height/1.5, (SCALE*94), height/4);

  court = loadShape("fullcourt.svg");

  rectX = (int)cxo;
  rectY = (int)cyo+(int)SCALE*47;
  //ui

  smooth();
  noStroke();

  // Load images
  //img1 = loadImage("seedTop.jpg");
  //img2 = loadImage("seedBottom.jpg");

  parseEvents("2.csv");  //to start things off.
  parsedata();

  hs1 = new HScrollbar(0, 20, width, 16, 16);

  //ball = new Player[1];
  //hometeam = new Player[5];
  //awayteam = new Player[5];
  //ball[0] = new Player(cxo, cyo, SCALE*1.2, 0, ball);
  //for (int i = 0; i < 5; i++)
  //{
  //  hometeam[i] = new Player(cxo, cyo, SCALE*1.2, 0, ball);
  //  awayteam[i] = new Player(cxo, cyo, SCALE*1.2, 0, ball);
  //}  
  players = new Player[11];
  players[0] = new Player(cxo, cyo, SCALE*1.2, 0, players, "ball");  //the ball
  for (int i = 1; i < 6; i++)  //1-5 home team, 6-10 away team
  {
    players[i] = new Player(cxo, cyo, SCALE*2, i, players, "home");
  }
  for (int i = 6; i < 11; i++)  //1-5 home team, 6-10 away team
  {
    players[i] = new Player(cxo, cyo, SCALE*2, i, players, "away");
  }
}

void draw() {
  update(mouseX, mouseY);
  background(255);

  hs1.update();
  hs1.display();
  stroke(0);
  strokeWeight(1);
  line(0, 28, width, 28); //for scrollbar

  //title
  textSize(32);
  fill(0, 102, 153, 204);
  text("NBA Data Visualization", width/14, height/8);
  textSize(20);
  fill(0, 102, 153, 100);
  text("James Tam", width/14, height/6);
  //text("James Tam\nECS 163 - Information Interfaces\nDr. Kwan-Liu Ma", width/14, height/6);

  if ( lastItemClicked != null )  //for list menu
  {
    changeMenu();
  }

  //game info
  whosPlaying();
  eventInfo();

  if (buttonOver) {
    fill(0, 102, 153, 100);
  } else
    fill(150);
  noStroke();
  rect(cxo+SCALE*50, cyo+SCALE*53, 30, 20);
  fill(150);
  textSize(16);
  text("Show paths traveled", cxo+SCALE*56, cyo+SCALE*56);

  //if (buttonOver((int)cxo, (int)cyo+(int)SCALE*55, 20, 20))
  //{
  //  fill(0, 102, 153, 100);
  //} else {
  //  fill(200);
  //}
  //rect(cxo-25, cyo+SCALE*62, 20, 20);



  //DRAWING COURT NBA 94x50 FEET
  cxo = width/14;
  cyo = height/4;
  shape(court, cxo, cyo, SCALE*94, SCALE*50);

  //update player movements
  for (Player player : players)
  {
    player.display();
  }

  paths();
}

void update(int x, int y)
{
  if (buttonOver((int)cxo+(int)SCALE*50, (int)cyo+(int)SCALE*53, 30, 20))
  {
    buttonOver = true;
  } else
    buttonOver = false;
}

void mousePressed()
{
  if (buttonOver)
  {
    //println("click");
    pathball = !pathball;
    path1 = !path1;
    path2 = !path2;
    path3 = !path3;
    path4 = !path4;
    path5 = !path5;
    path6 = !path6;
    path7 = !path7;
    path8 = !path8;
    path9 = !path9;
    path10 = !path10;
  }

  //if (buttonOver((int)cxo, (int)cyo+(int)SCALE*65, (int)SCALE*45, 50))
  //println("click");
}

boolean buttonOver(int x, int y, int width, int height)
{
  if (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height)
    return true;
  return false;
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  int ticks;
  float ticksize;
  int currenttick = 0;
  //ticks to constrain total movement visualization to length of slider

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;

    ticksize = swidth/listlenpos;
    //println(swidth, listlen, ticksize);
    ticks = (int)listlenpos;
  }

  void update() {
    if (lastItemClicked != null && match(lastItemClicked.toString(), ".csv") != null)  //update slider with new constraints
    {
      //println(listlenpos);
      spos = xpos;
      newspos = spos;      
      ticksize = swidth/listlenpos;
      ticks = (int)listlenpos;
      currenttick = 0;
      //println(ticksize, ticks);
    }
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
      //println(newspos);
      currenttick = (int)newspos;
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }

  int getTickIndex()
  {
    if (currenttick>=ballpositions.size()) return ballpositions.size()-1;
    return currenttick;
  }
} //end class HScrollbar

public void itemClicked ( int i, Object item )
{
  lastItemClicked = item;
}

public class Listbox
{
  float x, y, width, height;

  ArrayList items;
  int itemHeight = 20;
  int listStartAt = 0;
  int hoverItem = -1;

  float valueY = 0;
  boolean hasSlider = false;

  Listbox ( float xx, float yy, float ww, float hh ) 
  {
    x = xx; 
    y = yy;
    valueY = y;

    width = ww; 
    height = hh;

    // register it
    Interactive.add( this );
  }

  public void addItem ( String item )
  {
    if ( items == null ) items = new ArrayList();
    items.add( item );

    hasSlider = items.size() * itemHeight > height;
  }

  public void clearItems ()
  {
    if ( items != null ) items = new ArrayList();

    hasSlider = items.size() * itemHeight > height;
  }

  public void mouseMoved ( float mx, float my )
  {
    if ( hasSlider && mx > 1024 ) return;  //WARNING: number is hardcoded. must scale to window width!

    hoverItem = listStartAt + int((my-y) / itemHeight);
  }

  public void mouseExited ( float mx, float my )
  {
    hoverItem = -1;
  }

  // called from manager
  void mouseDragged ( float mx, float my, float dx, float dy )
  {
    if ( !hasSlider ) return;
    if ( mx < x+width-20 ) return;

    valueY = my-10;
    valueY = constrain( valueY, y, y+height-20 );

    update();
  }

  // called from manager
  void mouseScrolled ( float step )
  {
    valueY += step;
    valueY = constrain( valueY, y, y+height-20 );

    update();
  }

  void update ()
  {
    float totalHeight = items.size() * itemHeight;
    float itemsInView = height / itemHeight;
    float listOffset = map( valueY, y, y+height-20, 0, totalHeight-height );

    listStartAt = int( listOffset / itemHeight );
  }

  public void mousePressed ( float mx, float my )
  {
    if ( hasSlider && mx > 910 ) return;  //WARNING: number is hardcoded. must scale to window width!

    int item = listStartAt + int( (my-y) / itemHeight);
    itemClicked( item, items.get(item) );
  }

  void draw ()
  { 
    noStroke();
    fill( 200 );
    rect( x, y, this.width, this.height );
    if ( items != null )
    {
      for ( int i = 0; i < int(height/itemHeight) && i < items.size(); i++ )
      {
        stroke( 80 );
        fill( (i+listStartAt) == hoverItem ? color(0, 102, 153, 100) : 120 );
        if (items.get(i+listStartAt).toString() == "Back") fill(0, 102, 153, 100);
        rect( x, y + (i*itemHeight), this.width, itemHeight );

        noStroke();
        fill(255);
        textSize(18);
        text( items.get(i+listStartAt).toString(), x+5, y+(i+1)*itemHeight-5 );
      }
    }

    if ( hasSlider )
    {
      stroke( 80 );
      fill( 100 );
      rect( x+width-20, y, 20, height );
      fill( 120 );
      rect( x+width-20, valueY, 20, 20 );
    }
  }
}

class Player
{
  float x, y;
  float diameter;
  int id;
  Player[] others;
  String type;

  double totalDist = 0;
  double prevDist = 0;

  Player(float xin, float yin, float din, int idin, Player[] oin, String t) {  //type = ball,home, or away
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
    type = t;
  } 

  void calculateTotalDistance(Position prevPos) {
    float tempX = Math.abs(this.x - prevPos.xpos);
    float tempY = Math.abs(this.y - prevPos.ypos);
    this.totalDist = Math.sqrt((tempY)*(tempY) +(tempX)*(tempX));
  }

  void display() {
    noStroke();

    //position ball
    if (id == 0) {
      fill(255, 120, 39);
      x = ballpositions.get(hs1.getTickIndex()).xpos;
      y = ballpositions.get(hs1.getTickIndex()).ypos;
      ellipse(SCALE*x + cxo, SCALE*y + cyo, diameter, diameter);
      //println(positions.get(hs1.getTickIndex()).xpos, positions.get(hs1.getTickIndex()).ypos);
    }    
    if (id == 1) {
      fill(0, 102, 153, 100);
      x = position1.get(hs1.getTickIndex()).xpos;
      y = position1.get(hs1.getTickIndex()).ypos;
      ellipse(SCALE*x + cxo, SCALE*y + cyo, diameter, diameter);      
      fill(0, 102, 153, 230);
      textSize(12);
      text( pidToJNum(position1.get(hs1.getTickIndex()).pid), SCALE*x+cxo-diameter, SCALE*y+cyo+diameter );
      //println(positions.get(hs1.getTickIndex()).xpos, positions.get(hs1.getTickIndex()).ypos);
    }    
    if (id == 2) {
      fill(0, 102, 153, 100);
      x = position2.get(hs1.getTickIndex()).xpos;
      y = position2.get(hs1.getTickIndex()).ypos;
      ellipse(SCALE*x + cxo, SCALE*y + cyo, diameter, diameter);
      fill(0, 102, 153, 230);
      textSize(12);
      text( pidToJNum(position2.get(hs1.getTickIndex()).pid), SCALE*x+cxo-diameter, SCALE*y+cyo+diameter );
    }    
    if (id == 3) {
      fill(0, 102, 153, 100);
      x = position3.get(hs1.getTickIndex()).xpos;
      y = position3.get(hs1.getTickIndex()).ypos;
      ellipse(SCALE*x + cxo, SCALE*y + cyo, diameter, diameter);
      fill(0, 102, 153, 230);
      textSize(12);
      text( pidToJNum(position3.get(hs1.getTickIndex()).pid), SCALE*x+cxo-diameter, SCALE*y+cyo+diameter );
    }    
    if (id == 4) {
      fill(0, 102, 153, 100);
      x = position4.get(hs1.getTickIndex()).xpos;
      y = position4.get(hs1.getTickIndex()).ypos;
      ellipse(SCALE*x + cxo, SCALE*y + cyo, diameter, diameter);
      fill(0, 102, 153, 230);
      textSize(12);
      text( pidToJNum(position4.get(hs1.getTickIndex()).pid), SCALE*x+cxo-diameter, SCALE*y+cyo+diameter );
    }        
    if (id == 5) {
      fill(0, 102, 153, 100);
      x = position5.get(hs1.getTickIndex()).xpos;
      y = position5.get(hs1.getTickIndex()).ypos;
      ellipse(SCALE*x + cxo, SCALE*y + cyo, diameter, diameter);
      fill(0, 102, 153, 230);
      textSize(12);
      text( pidToJNum(position5.get(hs1.getTickIndex()).pid), SCALE*x+cxo-diameter, SCALE*y+cyo+diameter );
    }
    if (id == 6) {
      fill(0, 0, 0);
      x = position6.get(hs1.getTickIndex()).xpos;
      y = position6.get(hs1.getTickIndex()).ypos;
      ellipse(SCALE*x + cxo, SCALE*y + cyo, diameter, diameter);
      fill(0);
      textSize(12);
      text( pidToJNum(position6.get(hs1.getTickIndex()).pid), SCALE*x+cxo-diameter, SCALE*y+cyo+diameter );
    }    
    if (id == 7) {
      fill(0, 0, 0);
      x = position7.get(hs1.getTickIndex()).xpos;
      y = position7.get(hs1.getTickIndex()).ypos;
      ellipse(SCALE*x + cxo, SCALE*y + cyo, diameter, diameter);
      fill(0);
      textSize(12);
      text( pidToJNum(position7.get(hs1.getTickIndex()).pid), SCALE*x+cxo-diameter, SCALE*y+cyo+diameter );
    }    
    if (id == 8) {
      fill(0, 0, 0);
      x = position8.get(hs1.getTickIndex()).xpos;
      y = position8.get(hs1.getTickIndex()).ypos;
      ellipse(SCALE*x + cxo, SCALE*y + cyo, diameter, diameter);
      fill(0);
      textSize(12);
      text( pidToJNum(position8.get(hs1.getTickIndex()).pid), SCALE*x+cxo-diameter, SCALE*y+cyo+diameter );
    }    
    if (id == 9) {
      fill(0, 0, 0);
      x = position9.get(hs1.getTickIndex()).xpos;
      y = position9.get(hs1.getTickIndex()).ypos;
      ellipse(SCALE*x + cxo, SCALE*y + cyo, diameter, diameter);
      fill(0);
      textSize(12);
      text( pidToJNum(position9.get(hs1.getTickIndex()).pid), SCALE*x+cxo-diameter, SCALE*y+cyo+diameter );
    }    
    if (id == 10) {
      fill(0, 0, 0);
      x = position10.get(hs1.getTickIndex()).xpos;
      y = position10.get(hs1.getTickIndex()).ypos;
      ellipse(SCALE*x + cxo, SCALE*y + cyo, diameter, diameter);
      fill(0);
      textSize(12);
      text( pidToJNum(position10.get(hs1.getTickIndex()).pid), SCALE*x+cxo-diameter, SCALE*y+cyo+diameter );
    }
  }
}

class Position
{
  float xpos, ypos, gclock;
  int pid, mom;
  Position(float x, float y, int p, int m, float gc)
  {
    xpos = x;
    ypos = y;
    pid = p;
    mom = m;
    gclock = gc;
  }
}

void parsedata()
{
  //parse csv
  parseteams();
  parseplayers();
  parsegames();
  //parseEvents();
}  //parsedata()

void parseteams()
{
  teamtable = loadTable("team.csv", "header");

  for (TableRow row : teamtable.rows()) {
    int teamid = row.getInt("teamid");
    String name = row.getString("name");
    String abbrv = row.getString("abbreviation");
  }
}

void parseplayers()
{
  playertable = loadTable("players.csv", "header");

  for (TableRow row : playertable.rows()) {
    int playerid = row.getInt("playerid");
    String firstname = row.getString("firstname");
    String lastname = row.getString("lastname");
    int jerseynumber = row.getInt("jerseynumber");
    String position = row.getString("position");
    int teamid = row.getInt("teamid");

    //println(firstname + " " + lastname + " has the playerid of " 
    //  + playerid + " and wears the jersey no. " + jerseynumber 
    //  + " playing the position " + position + " for the team " + teamid);
  }
}

void parsegames()
{
  gametable = loadTable("games.csv", "header");

  for (TableRow row : gametable.rows()) {
    int gameid = row.getInt("gameid");
    String gamedate = row.getString("gamedate");
    int hometeamid = row.getInt("hometeamid");
    int visitorteamid = row.getInt("visitorteamid");
  }
}

void parseEvents(String fn)
{


  fname = fn;

  //eventList = new ArrayList();
  //eventTable = loadTable
  println("data/games/" + chosenGameId + "/" + fname);
  String lines[] = loadStrings("data/games/" + chosenGameId + "/" + fname);

  Table table = new Table();
  table.addColumn("GameID", Table.INT);
  table.addColumn("TeamID", Table.INT);
  table.addColumn("PlayerID", Table.INT);
  table.addColumn("XPos", Table.FLOAT);
  table.addColumn("YPos", Table.FLOAT);
  table.addColumn("Height", Table.FLOAT);
  table.addColumn("Moment", Table.INT);
  table.addColumn("GameClock", Table.FLOAT);
  table.addColumn("ShotClock", Table.FLOAT);
  table.addColumn("Period", Table.INT);

  for (String line : lines) {
    TableRow newRow= table.addRow();
    String[] lineData = line.split(",");
    newRow.setInt("GameID", Integer.parseInt(lineData[0]));
    newRow.setInt("TeamID", Integer.parseInt(lineData[1]));
    newRow.setInt("PlayerID", Integer.parseInt(lineData[2]));
    newRow.setFloat("XPos", Float.parseFloat(lineData[3]));
    newRow.setFloat("YPos", Float.parseFloat(lineData[4]));
    newRow.setFloat("Height", Float.parseFloat(lineData[5]));
    newRow.setInt("Moment", Integer.parseInt(lineData[6]));
    newRow.setFloat("GameClock", Float.parseFloat(lineData[7]));
    if (lineData[8].equals("None"))
      newRow.setFloat("ShotClock", 0);
    else
      newRow.setFloat("ShotClock", Float.parseFloat(lineData[8]));
    newRow.setInt("Period", Integer.parseInt(lineData[9]));
  } // parse the data to events, change this to an arraylist for dynamic

  ballpositions = new ArrayList();

  //for (TableRow row : table.findRows("-1", "TeamID")) {
  //  //println(row.getFloat("XPos"), row.getFloat("YPos"));
  //  ballpositions.add(new Position(row.getFloat("XPos"), row.getFloat("YPos"), row.getFloat("PlayerID"), 
  //    row.getInt("Moment"), row.getFloat("GameClock"), row.getFloat("ShotClock")));
  //}

  //do by 10?
  int counter = 1;
  int moment = 0;
  position1 = new ArrayList();
  position2 = new ArrayList();
  position3 = new ArrayList();
  position4 = new ArrayList();
  position5 = new ArrayList();
  position6 = new ArrayList();
  position7 = new ArrayList();
  position8 = new ArrayList();
  position9 = new ArrayList();
  position10 = new ArrayList();

  //Table temptable = table;
  //for (TableRow t : table.rows())
  //{
  //  if(match(Integer.toString(t.getInt("TeamID")), "-1") == null)
  //    temptable.addRow(t);
  //} 
  for (TableRow row : table.rows())
  {
    //if (counter == 0)
    //if (row.getInt("Moment") == moment)
    if (row.getInt("TeamID") == -1)
    {
      ballpositions.add(new Position(row.getFloat("XPos"), row.getFloat("YPos"), row.getInt("PlayerID"), 
        row.getInt("Moment"), row.getFloat("GameClock")));
      continue;
    }
    if (counter == 1) {
      position1.add(new Position(row.getFloat("XPos"), row.getFloat("YPos"), row.getInt("PlayerID"), 
        row.getInt("Moment"), row.getFloat("GameClock")));
      //if (hs1.getTickIndex() == 0){}
        //players[1].calculateTotalDistance(position1.get(hs1.getTickIndex()-1));
    } 
    if (counter == 2)
      position2.add(new Position(row.getFloat("XPos"), row.getFloat("YPos"), row.getInt("PlayerID"), 
        row.getInt("Moment"), row.getFloat("GameClock")));   
    if (counter == 3)
      position3.add(new Position(row.getFloat("XPos"), row.getFloat("YPos"), row.getInt("PlayerID"), 
        row.getInt("Moment"), row.getFloat("GameClock")));    
    if (counter == 4)
      position4.add(new Position(row.getFloat("XPos"), row.getFloat("YPos"), row.getInt("PlayerID"), 
        row.getInt("Moment"), row.getFloat("GameClock")));    
    if (counter == 5)
      position5.add(new Position(row.getFloat("XPos"), row.getFloat("YPos"), row.getInt("PlayerID"), 
        row.getInt("Moment"), row.getFloat("GameClock")));    
    if (counter == 6)
      position6.add(new Position(row.getFloat("XPos"), row.getFloat("YPos"), row.getInt("PlayerID"), 
        row.getInt("Moment"), row.getFloat("GameClock")));    
    if (counter == 7)
      position7.add(new Position(row.getFloat("XPos"), row.getFloat("YPos"), row.getInt("PlayerID"), 
        row.getInt("Moment"), row.getFloat("GameClock")));    
    if (counter == 8)
      position8.add(new Position(row.getFloat("XPos"), row.getFloat("YPos"), row.getInt("PlayerID"), 
        row.getInt("Moment"), row.getFloat("GameClock")));    
    if (counter == 9)
      position9.add(new Position(row.getFloat("XPos"), row.getFloat("YPos"), row.getInt("PlayerID"), 
        row.getInt("Moment"), row.getFloat("GameClock")));    
    if (counter == 10)
    {
      position10.add(new Position(row.getFloat("XPos"), row.getFloat("YPos"), row.getInt("PlayerID"), 
        row.getInt("Moment"), row.getFloat("GameClock")));
      moment = row.getInt("Moment");
    }
    //println(counter);
    counter++;
    if (counter == 11)
      counter = 1;
  }

  listlenball = ballpositions.size();  //everyone shares the same list length.... .right?
  listlenpos = position1.size();
  //println(listlenball);
  //println(chosenGameId);
  //println(chosenHomeId);
  //println(chosenAwayId);

  //for (int i = 0; i < 5; i++)
  //{
  //  hometeam[i] = 
  //}
}

void parseGameId()
{
  String gd = "";
  String htshort = "";
  String vtshort = "";
  int htid = 0;
  int vtid = 0;
  if (lastItemClicked != null)
  {
    gd = lastItemClicked.toString().substring(0, 10);
    htshort = lastItemClicked.toString().substring(17, 20);
    htid = teamtable.findRow(htshort, "abbreviation").getInt("teamid");
    vtshort = lastItemClicked.toString().substring(11, 14);
    vtid = teamtable.findRow(vtshort, "abbreviation").getInt("teamid");
    //println(gd, htid, vtid);
  }

  for (TableRow row : gametable.rows())
  {
    if (row.getString("gamedate").equals(gd) && row.getInt("hometeamid") == htid
      && row.getInt("visitorteamid") == vtid)
    {
      chosenGameId = "00" + row.getInt("gameid");
      chosenHomeId = htid;
      chosenAwayId = vtid;
      //println(chosenGameId);
    }
  }
}

void setupListbox()
{
  listbox.addItem("Teams");
  listbox.addItem("Players");
  listbox.addItem("Games");
}

void changeMenu()
{
  fill( 100 );

  if (lastItemClicked.toString() == "Back") {
    listbox.clearItems();
    setupListbox();
  }

  if (lastItemClicked.toString() == "Teams") {
    listbox.clearItems();
    listbox.addItem("Back");
    for (TableRow row : teamtable.rows()) {
      listbox.addItem(row.getString("name"));
    }
  } 

  if (teamtable.findRow(lastItemClicked.toString(), "name") != null)
  {
    //println("clicked a team");
    int tid = teamtable.findRow(lastItemClicked.toString(), "name").getInt("teamid");
    listbox.clearItems();
    listbox.addItem("Back");
    for (TableRow row : playertable.findRows(Integer.toString(tid), "teamid")) {
      listbox.addItem(row.getString("lastname") + ", " + row.getString("firstname"));
    }
  }

  if (lastItemClicked.toString() == "Players") {
    listbox.clearItems();
    listbox.addItem("Back");
    for (TableRow row : playertable.rows()) {
      listbox.addItem(row.getString("lastname") + ", " + row.getString("firstname"));
    }
  }

  if (lastItemClicked.toString() == "Games") {
    listbox.clearItems();
    listbox.addItem("Back");
    String ht = "hometeam";
    String vt = "awayteam";
    for (TableRow row : gametable.rows()) {
      for (TableRow row2 : teamtable.findRows(""+row.getInt("hometeamid"), "teamid")) {
        //println(row.getFloat("XPos"), row.getFloat("YPos"));
        ht = row2.getString("abbreviation");
      }

      for (TableRow row2 : teamtable.findRows(""+row.getInt("visitorteamid"), "teamid")) {
        vt = row2.getString("abbreviation");
      }
      listbox.addItem(row.getString("gamedate") + " " + vt + " @ " + ht);
    }
  }  //click Games

  //if clicked a specific game. should be the only thing with "@" symbol, so used as key
  if (match(lastItemClicked.toString(), "@") != null)
  {
    //parseEventKey();
    //println(lastItemClicked.toString().substring(0,9));
    parseGameId();  //events can be clicked

    File dir = new File(dataPath("games/" + chosenGameId));
    //println(dir);
    String[] filenames = dir.list();


    if (filenames == null) {
      println("Folder does not exist or cannot be accessed or none chosen.");
    } else {
      //println(filenames.length + " files in specified directory");
      listbox.clearItems();
      listbox.addItem("Back");
      for (int i = 0; i < filenames.length; i++) {
        //println(filenames[i]);
        listbox.addItem(filenames[i]);
      }
    }
  }

  //if clicked a specific event. should be only thing with ".csv", so used as key
  if (match(lastItemClicked.toString(), ".csv") != null)
  {
    parseEvents(lastItemClicked.toString());
  }

  //text( "Clicked " + lastItemClicked.toString(), width/1.5, height/9 );
  lastItemClicked = null;
}

void whosPlaying()
{
  chosenHomeName = teamtable.findRow(Integer.toString(chosenHomeId), "teamid").getString("name");
  chosenAwayName = teamtable.findRow(Integer.toString(chosenAwayId), "teamid").getString("name");
  textSize(28);
  fill(0, 102, 153, 204);
  text(chosenHomeName, width/14, height/4.5);
  fill(200);
  text(" vs ", width/14 + textWidth(chosenHomeName), height/4.5);
  fill(0);
  text(chosenAwayName, width/14 + textWidth(chosenHomeName) + textWidth(" vs "), height/4.5);
}

//position10.add(new Position(row.getFloat("XPos"), row.getFloat("YPos"), row.getInt("PlayerID"), 
//  row.getInt("Moment"), row.getFloat("GameClock")));
//text( pidToName(position3.get(hs1.getTickIndex()).pid), SCALE*x+cxo-diameter, SCALE*y+cyo+diameter );

void eventInfo()
{
  fill(150);
  textSize(16);
  text("Showing event " + chosenGameId + "/" + fname, cxo, cyo + SCALE*55);

  fill(0, 102, 153, 255);
  textSize(20);
  text("In Play:", cxo, cyo + SCALE*60);

  fill(0, 102, 153, 204);
  textSize(18);
  //new SimpleButton(cxo-50,cyo+SCALE*65,SCALE*30,SCALE*5);
  text(pidToJNum(position1.get(hs1.getTickIndex()).pid) + " " + 
    pidToName(position1.get(hs1.getTickIndex()).pid) + players[1].totalDist, cxo, cyo + SCALE*65);
  text(pidToJNum(position2.get(hs1.getTickIndex()).pid) + " " + 
    pidToName(position2.get(hs1.getTickIndex()).pid), cxo, cyo + SCALE*70);
  text(pidToJNum(position3.get(hs1.getTickIndex()).pid) + " " + 
    pidToName(position3.get(hs1.getTickIndex()).pid), cxo, cyo + SCALE*75);
  text(pidToJNum(position4.get(hs1.getTickIndex()).pid) + " " + 
    pidToName(position4.get(hs1.getTickIndex()).pid), cxo, cyo + SCALE*80);
  text(pidToJNum(position5.get(hs1.getTickIndex()).pid) + " " + 
    pidToName(position5.get(hs1.getTickIndex()).pid), cxo, cyo + SCALE*85);  

  fill(0);
  text(pidToJNum(position6.get(hs1.getTickIndex()).pid) + " " + 
    pidToName(position6.get(hs1.getTickIndex()).pid), cxo + SCALE*50, cyo + SCALE*65);
  text(pidToJNum(position7.get(hs1.getTickIndex()).pid) + " " + 
    pidToName(position7.get(hs1.getTickIndex()).pid), cxo + SCALE*50, cyo + SCALE*70);
  text(pidToJNum(position8.get(hs1.getTickIndex()).pid) + " " + 
    pidToName(position8.get(hs1.getTickIndex()).pid), cxo + SCALE*50, cyo + SCALE*75);
  text(pidToJNum(position9.get(hs1.getTickIndex()).pid) + " " + 
    pidToName(position9.get(hs1.getTickIndex()).pid), cxo + SCALE*50, cyo + SCALE*80);
  text(pidToJNum(position10.get(hs1.getTickIndex()).pid) + " " + 
    pidToName(position10.get(hs1.getTickIndex()).pid), cxo + SCALE*50, cyo + SCALE*85);
}

String pidToName(int p)
{
  TableRow r = playertable.findRow(Integer.toString(p), "playerid");
  return r.getString("firstname") + " " + r.getString("lastname");
}
String pidToJNum(int p)
{
  TableRow r = playertable.findRow(Integer.toString(p), "playerid");
  return r.getString("jerseynumber");
}

void paths()
{
  if (pathball == true)
  {
    fill(255, 120, 39);
    for (int i = 0; i < ballpositions.size(); i++)
    {
      ellipse(SCALE*ballpositions.get(i).xpos + cxo, 
        SCALE*ballpositions.get(i).ypos + cyo, 1, 1);
    }
  }

  fill(0, 102, 153, 204);
  if (path1 == true)
  {
    for (int i = 0; i < position1.size(); i++)
    {
      ellipse(SCALE*position1.get(i).xpos + cxo, 
        SCALE*position1.get(i).ypos + cyo, 1, 1);
    }
  }
  if (path2 == true) {
    for (int i = 0; i < position2.size(); i++)
    {
      ellipse(SCALE*position2.get(i).xpos + cxo, 
        SCALE*position2.get(i).ypos + cyo, 1, 1);
    }
  }
  if (path3 == true) {
    for (int i = 0; i < position3.size(); i++)
    {
      ellipse(SCALE*position3.get(i).xpos + cxo, 
        SCALE*position3.get(i).ypos + cyo, 1, 1);
    }
  }
  if (path4 == true) {
    for (int i = 0; i < position4.size(); i++)
    {
      ellipse(SCALE*position4.get(i).xpos + cxo, 
        SCALE*position4.get(i).ypos + cyo, 1, 1);
    }
  }
  if (path5 == true) {
    for (int i = 0; i < position5.size(); i++)
    {
      ellipse(SCALE*position5.get(i).xpos + cxo, 
        SCALE*position5.get(i).ypos + cyo, 1, 1);
    }
  }

  fill(0);
  if (path6 == true) {
    for (int i = 0; i < position6.size(); i++)
    {
      ellipse(SCALE*position6.get(i).xpos + cxo, 
        SCALE*position6.get(i).ypos + cyo, 1, 1);
    }
  }
  if (path7 == true) {
    for (int i = 0; i < position7.size(); i++)
    {
      ellipse(SCALE*position7.get(i).xpos + cxo, 
        SCALE*position7.get(i).ypos + cyo, 1, 1);
    }
  }
  if (path8 == true) {
    for (int i = 0; i < position8.size(); i++)
    {
      ellipse(SCALE*position8.get(i).xpos + cxo, 
        SCALE*position8.get(i).ypos + cyo, 1, 1);
    }
  }
  if (path9 == true) {
    for (int i = 0; i < position9.size(); i++)
    {
      ellipse(SCALE*position9.get(i).xpos + cxo, 
        SCALE*position9.get(i).ypos + cyo, 1, 1);
    }
  }
  if (path10 == true) {
    for (int i = 0; i < position10.size(); i++)
    {
      ellipse(SCALE*position10.get(i).xpos + cxo, 
        SCALE*position10.get(i).ypos + cyo, 1, 1);
    }
  }
}

void teamShowInfo()
{
}