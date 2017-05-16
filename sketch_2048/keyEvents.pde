// The only keys (and corresponding keyCodes) that are used to control the game are:
// * RETURN (10)--Restarts game if Game Over is being displayed
// * LEFT ARROW (37)--Move blocks to the left
// * UP ARROW (38)--Move blocks up
// * RIGHT ARROW (39)--Move blocks right
// * DOWN ARROW (40)--Move blocks down
// * Upper-case 'U' (85)--Undo (revert one keypress)

void keyPressed() {
  if (grid.isGameOver()) {
    // If RETURN is pressed, then start a fresh game with one block
    if (keyCode == 10) { 
      grid.initBlocks();
      grid.placeBlock();
    } 
    return;
  }
  
  // If a key is pressed and it isn't LEFT (arrow), RIGHT, UP, DOWN, or U,
  // then ignore it by returning immediately
  if (!(isBetween(keyCode, 37, 40) || keyCode == 85)) return;

  if (keyCode == 85) {  // ASCII value for upper case U (for Undo)
     grid.gridCopy(backup_grid);  // Copy the backup grid to the main grid
     return;
  }
  
  // If you are curious about keyCodes, there are two things to look at:
  //
  // First, look up Unicode values (you can Google this easily)
  // Second, look at the documentation at Processing.org
  DIR dir;
  DIR[] dirs = { DIR.WEST, DIR.NORTH, DIR.EAST, DIR.SOUTH };
  // Key codes for LEFT ARROW, UP ARROW, RIGHT ARROW, and DOWN ARROW are 37--40.
  // By subtracting 37, we get an appropriate index for the dirs array that converts
  // LEFT ARROW to DIR.WEST, UP ARROW to DIR. 
  dir = dirs[keyCode-37];
  
  if (!grid.someBlockCanMoveInDirection(dir)) return;
  else gameUpdate(dir);
}