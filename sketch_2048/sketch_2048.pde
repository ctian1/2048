public final int GRID_X_OFFSET = 15;      // distance from left to start drawing grid
public final int GRID_Y_OFFSET = 85;      // distance from top to start drawing grid
public final int BLOCK_SIZE = 120;   // width and height of a block
public final int BLOCK_MARGIN = 15;  // separation between blocks
public final int BLOCK_RADIUS = 5;   // for making blocks look slightly rounded in corners
public final int Y_TEXT_OFFSET = 7;  // for centering the numbers when drawn on blocks
public final int GRID_SIZE = 4;      // number of rows and columns
public final int COLS = GRID_SIZE;
public final int ROWS = GRID_SIZE;
public PFont blockFont;

public final int SCORE_Y_OFFSET = 36;
public PFont scoreFont;

public final color BACKGROUND_COLOR = color(189, 195, 199);
public final color BLANK_COLOR = color(203, 208, 210);
public Grid grid = new Grid(COLS, ROWS);
public Grid backup_grid = new Grid(COLS, ROWS);

// Every time a key is pressed, blocks need to move visually (if there is a way to move).
// All of the animations to be carried out are stored in anims.
public ArrayList<Animation> anims = new ArrayList<Animation>();
// number of movements to complete a block animation
public final int TICK_STEPS = 20;
// counter for number of iterations have been used to animate block movement
// if animation_ticks == TICK_STEPS, then the display is not moving blocks
public int animation_ticks = TICK_STEPS;  


// setup() is analogous to init() in Java.  It is done once at the start of the
// program.  (It is more applet-like than application-like, but if you want to think
// of it as analogous to public static void main(), I won't quibble.)
public void setup()
{
  size(555, 625);  // Do not include P3D as third input as it prevents keyDown; no idea why
  background(BACKGROUND_COLOR);
  noStroke();
  
  blockFont = createFont("LucidaSans", 50);;
  textFont(blockFont);
  textAlign(CENTER, CENTER); 
  
  scoreFont = createFont("LucidaSans", 42);

  // Comment out this setBlock() and replace it with a placeBlock() once you have
  // written placeBlock().
  //grid.setBlock(2,0,2,false);
  grid.placeBlock();
  System.out.print(grid);
  backup_grid.gridCopy(grid);   // save grid in backup_grid in case Undo is needed
}

// This is where the animation will take place
// draw() exhibits the behavior of being inside an infinite loop
public void draw() {  
  background(BACKGROUND_COLOR);
  grid.computeScore();
  grid.showScore();
  grid.showBlocks();
  
  // Don't show GAME OVER during an animation
  if (animation_ticks == TICK_STEPS && grid.isGameOver()) {
    grid.showGameOver();
  }
  
  if (animation_ticks < TICK_STEPS) {
    for(int row = 0; row < ROWS; row++) {
      for(int col = 0; col < COLS; col++) {
        fill(BLANK_COLOR);
        rect(GRID_X_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*col, 
             GRID_Y_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*row, 
             BLOCK_SIZE, BLOCK_SIZE, BLOCK_RADIUS);
      }
    }
    
    
    // animation_ticks is used to count up to TICK_STEPS, which
    // determines how many
    
    // Iterate on the anims ArrayList to 
    for(int i = 0; i < anims.size(); i++) {
      Animation a = anims.get(i);
      float col = 1.0 * ((a.getToCol() - a.getFromCol())*animation_ticks)/TICK_STEPS + a.getFromCol();
      float row = 1.0 * ((a.getToRow() - a.getFromRow())*animation_ticks)/TICK_STEPS + a.getFromRow();
      float adjustment = (log(a.getFromValue()) / log(2)) - 1;
      fill(color(242 , 241 - 8*adjustment, 239 - 8*adjustment));
      rect(GRID_X_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*col, GRID_Y_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*row, BLOCK_SIZE, BLOCK_SIZE, BLOCK_RADIUS);
      fill(color(108, 122, 137));
      text(str(a.getFromValue()), GRID_X_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*col + BLOCK_SIZE/2, GRID_Y_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*row + BLOCK_SIZE/2 - Y_TEXT_OFFSET);
    }
    animation_ticks += 1;   
  }
}

public void gameUpdate(DIR direction)
{  
  //BEGIN MOVEMENT SECTION
  Grid newGrid = new Grid(COLS, ROWS);
  newGrid.gridCopy(grid);   // 
  anims = new ArrayList<Animation>();
  
  // EAST-WEST movement
  if (direction == DIR.WEST || direction == DIR.EAST) {
    int startingCol = direction == DIR.EAST ? GRID_SIZE-1 : 0;
    int endingCol = direction == DIR.EAST ? -1 : GRID_SIZE;
    int colAdjust = direction == DIR.EAST ? 1 : -1;
    
    for (int row = 0; row < ROWS; row++) {
      for (int col = startingCol; col != endingCol; col -= colAdjust) {
        int colPos = col;
        int val = newGrid.getBlock(col, row).getValue();
        if (!newGrid.getBlock(col,row).isEmpty()) {
          // While the position being inspected is in the grid and does not contain a block
          // whose values has already been changed this move
          while(newGrid.isValid(colPos + colAdjust, row) && !newGrid.getBlock(colPos, row).hasChanged()) {
            if (newGrid.getBlock(colPos+colAdjust,row).isEmpty()) {
            // if (newGrid[colPos + colAdjust][row].getValue() == -1) {
              // Move the block into the empty space and create an empty space where the block was
              newGrid.swap(colPos,row,colPos+colAdjust,row);
            } else if (newGrid.canMerge(colPos + colAdjust, row, colPos, row)) {
                if (!newGrid.getBlock(colPos + colAdjust, row).hasChanged()) {
                  newGrid.setBlock(colPos + colAdjust, row, newGrid.getBlock(colPos, row).getValue()*2, true);
                  newGrid.setBlock(colPos, row);
              }
            } else {  // Nowhere to move to
              break;  // Exit while loop
            }
            colPos += colAdjust;
          }
          // If a block moves, add its information to the list of blocks that must be animated
          anims.add(new Animation(col,row,val,colPos,row,val));
        }
      }
    }
  }
  
  // NORTH-SOUTH movement
  // 
  // Analogous to EAST-WEST movement
  if (direction == DIR.NORTH || direction == DIR.SOUTH) {
    int startingRow = direction == DIR.SOUTH ? GRID_SIZE-1 : 0;
    int endingRow = direction == DIR.SOUTH ? -1 : GRID_SIZE;
    int rowAdjust = direction == DIR.SOUTH ? 1 : -1;

    for (int col = 0; col < COLS; col++) {
      for (int row = startingRow; row != endingRow; row -= rowAdjust) {
        int rowPos = row;
        int val = newGrid.getBlock(col, rowPos).getValue();
        if (!newGrid.getBlock(col,rowPos).isEmpty()) {
          while(newGrid.isValid(col, rowPos + rowAdjust) && !newGrid.getBlock(col, rowPos).hasChanged()) {
            if (newGrid.getBlock(col, rowPos + rowAdjust).isEmpty()) {
              newGrid.swap(col, rowPos, col, rowPos+rowAdjust);
            } else if(newGrid.canMerge(col, rowPos + rowAdjust, col, rowPos)) {
              if(!newGrid.getBlock(col, rowPos + rowAdjust).hasChanged()) {
                newGrid.setBlock(col, rowPos + rowAdjust, newGrid.getBlock(col, rowPos).getValue()*2, true);
                newGrid.setBlock(col, rowPos);
              }
            } else {
              break;  // Exit while loop
            }
            rowPos += rowAdjust;
          }
          // If a block moves, add its information to the list of blocks that must be animated
          anims.add(new Animation(col,row,val,col,rowPos,val)); 
        }
      }
    }
  }
  
  newGrid.clearChangedFlags();
  if (newGrid.canPlaceBlock()) {
    newGrid.placeBlock();
  }
  
  backup_grid.gridCopy(grid);  // Copy the grid to backup in case Undo is needed
  grid.gridCopy(newGrid);      // The newGrid should now be made the main grid
  
  //END MOVEMENT SECTION
  
  startAnimations();
}

public void startAnimations() {
  // Effectively turns draw() into a for loop with animation_ticks as the index
  animation_ticks = 0;
}