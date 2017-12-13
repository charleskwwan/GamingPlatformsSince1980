public abstract class DataPoint implements Tooltip {
  protected TableRow row;
  
  public DataPoint(TableRow row) {
    this.row = row;
  }
  
  public abstract void drawTooltip();
}