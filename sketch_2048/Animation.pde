// Used to store grid information about blocks that need to move after a key press.
//
// Do not change this file.
public class Animation
{
  private int fromCol;
  private int fromRow;
  private int fromValue;
  private int toCol;
  private int toRow;
  private int toValue;
  
  Animation(int fCol, int fRow, int fv, int tcol, int trow, int tv) {
    fromCol = fCol;
    fromRow = fRow;
    fromValue = fv;
    toCol = tcol;
    toRow = trow;
    toValue = tv;
  }
  
  public int getFromCol() { return fromCol; }
  public int getFromRow() { return fromRow; }
  public int getFromValue() { return fromValue; }
  public int getToCol() { return toCol; }
  public int getToRow() { return toRow; }
  public int getToValue() { return toValue; }
}