public class StackedBarChart extends AxisChart {
  private HashMap<String, Integer> colorMap;
  private ArrayList<Bar> bars;
  private TransitionValue axisOpacity;
  
  public StackedBarChart(
    Table tbl,
    String xname, String[] xlabels, String yname, String[] ylabels,
    HashMap<String, Integer> colorMap
  ) {
    // general
    super(tbl, xname, xlabels, yname, ylabels);
    this.colorMap = colorMap;
    this.bars = new ArrayList<Bar>();
    makeBars(this.tbl);
  }
  
  private class Bar extends DataPoint {
    private float drawx, draww, drawy;
    private TransitionValue[] drawhs;
    
    public Bar(TableRow row) {
      super(row);
      this.drawhs = new TransitionValue[StackedBarChart.this.ylabels.length];
    }   
    
    /* draw */
    // private helper for draw
    private void drawRect(int i, float y, int strk, int strkWgt) {
      stroke(strk);
      strokeWeight(strkWgt);
      fill(StackedBarChart.this.colorMap.get(StackedBarChart.this.ylabels[i]));
      rect(this.drawx, y, this.draww, this.drawhs[i].getCurrent());
    }
    
    public void draw(float x, float y, float chartw, float charth) {
      this.draww = .75 * chartw / StackedBarChart.this.xlabels.length;
      this.drawx = x - this.draww / 2;
      this.drawy = y;
      int ylabelsLen = StackedBarChart.this.ylabels.length;
      
      // set drawhs
      for (int i = 0; i < ylabelsLen; i++) {
        String ylabel = StackedBarChart.this.ylabels[i];
        float yval = Float.valueOf(this.data.get(ylabel));
        float h = charth * yval / StackedBarChart.this.ymax;
        if (this.drawhs[i] == null) {
          this.drawhs[i] = TransitionValues.add(0, h, .01);
        } else {
          this.drawhs[i].setFinal(h);
        }
        y -= h;
      }
      // draw rects
      float whichy = -1;
      int which = whichOver();
      for (int i = ylabelsLen-1; i >= 0; i--) {
        if (i == which) {
          whichy = y;
        } else {
          drawRect(i, y, 0, 1);
        }
        y += this.drawhs[i].getCurrent();
      }
      if (which >= 0) drawRect(which, whichy, 150, 4);
      strokeWeight(1);
    }
    
    public void drawTooltip() {
      int which = whichOver();
      if (which < 0) return;
      String yValStr = nf(Float.valueOf(this.data.get(StackedBarChart.this.ylabels[which])), 1, 2);
      String[] lines = new String[]{
        StackedBarChart.this.xname + ": " + this.data.get(StackedBarChart.this.xname), // x string
        "platform: " + StackedBarChart.this.ylabels[which], // platform string, hacky
        StackedBarChart.this.yname + ": " + yValStr + " mil" // y string, hacky
      };
      drawDefault(lines);
    }
    
    private int whichOver() {
      float  y = this.drawy;
      for (int i = 0; i < this.drawhs.length; i++) {
        if (this.drawhs[i] == null) return -1; // not yet initialized
        float h = this.drawhs[i].getCurrent();
        if (mouseX > this.drawx && mouseX < this.drawx + this.draww &&
            mouseY > y - h && mouseY < y)
          return i;
        y -= h;
      }
      return -1;
    }
    
    public boolean isOver() {
      return whichOver() >= 0;
    }
  }
  
  /* bar methods */
  private void makeBars(Table tbl) {
    for (String lbl : this.xlabels) {
      TableRow row = tbl.findRow(lbl, this.xname);
      this.bars.add(new Bar(row));
    }
  }
  
  /* ymax */
  private float yRowSum(TableRow row) {
    float sum = 0;
    for (String colName : this.ylabels) sum += row.getFloat(colName);
    return sum;
  }
  
  protected float yMax(Table tbl) {
    FloatList lst = new FloatList();
    for (String lbl : this.xlabels) {
      TableRow row = tbl.findRow(lbl, this.xname);
      lst.append(yRowSum(row));
    }
    return lst.max();
  }
  
  /* draw */
  public void draw(float x, float y, float w, float h) {    
    // prep
    float xoff = xOffset(), yoff = yOffset();
    float chartx = x + xoff, chartw = w - xoff;
    float charty = y, charth = h - yoff;
    
    // bars
    for (int i = 0; i < this.xlabels.length; i++) {
      float tickX = chartx + chartw * (i + .5) / this.xlabels.length;
      this.bars.get(i).draw(tickX, charty + charth, chartw, charth);
    }
    
    // axes
    PFont font = createFont(MAIN_FONT, FONT_SIZE);
    textFont(font);
    if (this.axisOpacity == null)
      this.axisOpacity = TransitionValues.add(0, 255, .05);
    stroke(0, this.axisOpacity.getCurrent());
    fill(0, this.axisOpacity.getCurrent());
    drawAxes(x, y, w, h, chartx, charty, chartw, charth);
  }
  
  /* mouse interactions */
  private Bar onWhich() {
    for (Bar bar : this.bars)
      if (bar.isOver()) return bar;
    return null;
  }
  
  public void onOver() {
    Bar over = onWhich();
    if (over != null) tooltips.add(over);
  }
}