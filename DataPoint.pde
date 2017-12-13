public abstract class DataPoint extends Tooltip {
  protected HashMap<String, String> data;
  
  public DataPoint(TableRow row) {
    this.data = new HashMap<String, String>();
    for (int i = 0; i < row.getColumnCount(); i++) {
      String colName = row.getColumnTitle(i);
      String colValue = row.getString(colName);
      this.data.put(colName, colValue);
    }
  }
  
  public abstract void drawTooltip();
}