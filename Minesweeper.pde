import de.bezier.guido.*;
private static final int NUM_ROWS = 20;
private static final int NUM_COLS = 20;
int numFlags = 40;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(600, 650);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
    }
  }
    
    
    
    for (int i = 0; i < 40; i++){
      setMines();
    }
}
public void setMines()
{
    
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[row][col])){
      mines.add(buttons[row][col]);
    } else {
      setMines();  
    }
    
}

public void draw ()
{
    background( 0 );
    if(isWon() == true){
        displayWinningMessage();
    }
    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    text("You have " + numFlags + " flags left!", 300, 620);
}
public boolean isWon()
{
    for (int i = 0; i < mines.size(); i++){
      if (mines.get(i).isFlagged() == false){
      return false;
      } 
    } return true;
 }

public void displayLosingMessage()
{
   for (int i = 6; i < 14; i++){
     buttons[9][i].myColor = color(0, 255, 0);
     buttons[9][i].size = 25;
   }
   buttons[9][6].setLabel("Y");
   buttons[9][7].setLabel("O");
   buttons[9][8].setLabel("U");
   buttons[9][9].setLabel("");
   buttons[9][10].setLabel("L");
   buttons[9][11].setLabel("O");
   buttons[9][12].setLabel("S");
   buttons[9][13].setLabel("T");
   for (int i = 0; i < mines.size(); i++){
     mines.get(i).clicked = true;
     mines.get(i).draw();
   }
}
public void displayWinningMessage()
{
  for (int i = 7; i < 14; i++){
    buttons[9][i].myColor = color(0, 255, 0);
    buttons[9][i].size = 25;
  }
   buttons[9][7].setLabel("Y");
   buttons[9][8].setLabel("O");
   buttons[9][9].setLabel("U");
   buttons[9][10].setLabel("");
   buttons[9][11].setLabel("W");
   buttons[9][12].setLabel("I");
   buttons[9][13].setLabel("N");
   
}
public boolean isValid(int r, int c)
{
    if (r > -1 && c > -1 && r < NUM_ROWS && c < NUM_COLS){
      return true;
  } else return false;
}

public int countMines(int row, int col)
{
    int numMines = 0;
    for (int r = row - 1; r <= row + 1; r++){
      for (int c = col - 1; c <= col + 1; c++){
        if (isValid(r, c)){
          if (mines.contains(buttons[r][c])){
            numMines += 1;
          }
        }
      }
  } 
  //if (buttons[row][col].equals(mines)){
    //numMines -= 1;
  //}
  return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged, click;
    private String myLabel;
    public int myColor, size;
    
    public MSButton ( int row, int col )
    {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
        myColor = color(0, 0, 0);
        size = 15;
    }


    // called by manager
    public void mousePressed () 
    {
      clicked = true;
        if (mouseButton == RIGHT && click == false){
        flagged = !flagged;
          if (flagged == false){
            clicked = false;
            numFlags += 1;
          } else if (flagged == true && numFlags !=0){
            numFlags -=1;
          } else if (numFlags == 0) {
            flagged = !flagged;
            clicked = false;
          }
        } else if (!flagged && mines.contains(buttons[myRow][myCol])){
          displayLosingMessage();
        } else if (!flagged && countMines(myRow, myCol) > 0){
          setLabel(countMines(myRow, myCol));
        } else if (!flagged) {
          for (int r = myRow - 1; r <= myRow + 1; r++){
            for (int c = myCol - 1; c <= myCol + 1; c++){
              if (isValid(r, c) && buttons[r][c].clicked == false){
                
                buttons[r][c].mousePressed();
              }
             }
            }
        }
     }
    
    
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked){
            fill( 200 );
            click = true;
        }
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(myColor);
        textSize(size);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
  }
