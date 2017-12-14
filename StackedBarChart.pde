public class StackedBarChart extends Chart {
  private HashMap<String, Integer> colorMap;
  private float ymax;
  private ArrayList<Bar> bars;
  
  public StackedBarChart(
    Table tbl,
    String xname, String[] xlabels, String yname, String[] ylabels,
    HashMap<String, Integer> colorMap
  ) {
    // general
    super(tbl, xname, xlabels, yname, ylabels);
    this.ymax = yMax();
    this.colorMap = colorMap;
    this.bars = makeBars();
  }
  
  private class Bar extends DataPoint {
    private float drawx, draww, drawy;
    private TransitionValue[] drawhs;
    
    public Bar(TableRow row) {
      super(row);
      this.drawhs = new TransitionValue[StackedBarChart.this.ylabels.length];
      
      // dummy for now
      for (int i = 0; i < this.drawhs.length; i++)
        this.drawhs[i] = TransitionValues.add(0, 0);
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
          this.drawhs[i] = TransitionValues.add(0, h);
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
        "platform: " + StackedBarChart.this.ylabels[which], // hacky
        StackedBarChart.this.yname + ": " + yValStr // y string
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
  private ArrayList<Bar> makeBars() {
    ArrayList<Bar> bars = new ArrayList<Bar>();
    for (String lbl : this.xlabels) {
      TableRow row = this.tbl.findRow(lbl, this.xname);
      bars.add(new Bar(row));
    }
    return bars;
  }
  
  /* chart and data methods */
  private float yRowSum(TableRow row) {
    float sum = 0;
    for (String colName : this.ylabels) sum += row.getFloat(colName);
    return sum;
  }
  
  private float yMax() {
    FloatList lst = new FloatList();
    for (String lbl : this.xlabels) {
      TableRow row = this.tbl.findRow(lbl, this.xname);
      lst.append(yRowSum(row));
    }
    return lst.max();
  }
  
  private float xOffset() {
    this.ymax = yMax();
    String ymaxStr = nf(this.ymax, 1, 2); // pad decimal points to 2
    return FONT_SIZE + textWidth(ymaxStr) + 2 * TEXT_GAP + TICK_LEN;
  }
  
  private float yOffset() {
    FloatList lst = new FloatList();
    for (String label : this.xlabels) lst.append(textWidth(label));
    return FONT_SIZE + lst.max() + 2 * TEXT_GAP + TICK_LEN;
  }
  
  private int nYGaps(float h) {
    return int(h / 40);
  }
  
  /* abstracts */
  public void draw(float x, float y, float w, float h) {  
    // prep
    float xoff = xOffset(), yoff = yOffset();
    float chartx = x + xoff, chartw = w - xoff;
    float charty = y, charth = h - yoff;
    PFont font = createFont(MAIN_FONT, FONT_SIZE);
    textFont(font);
    
    // bars
    for (int i = 0; i < this.xlabels.length; i++) {
      float tickX = chartx + chartw * (i + .5) / this.xlabels.length;
      this.bars.get(i).draw(tickX, charty + charth, chartw, charth);
    }
    
    fill(0);
    stroke(0);
    // axes
    line(chartx, charty + charth, chartx + chartw, charty + charth);
    line(chartx, charty, chartx, charty + charth);
    // x label
    textAlign(CENTER, BOTTOM);
    text(this.xname, chartx + chartw/2, y + h); 
    // y label
    textAlign(CENTER, TOP);
    pushMatrix();
    translate(x, y + charth/2);
    rotate(-HALF_PI);
    text(this.yname, 0, 0);
    popMatrix();
    // x ticks/labels
    textAlign(RIGHT, CENTER);
    for (int i = 0; i < this.xlabels.length; i++) {
      float tickX = chartx + chartw * (i + .5) / this.xlabels.length;
      line(tickX, charty + charth, tickX, charty + charth + TICK_LEN);
      pushMatrix();
      translate(tickX, charty + charth + TICK_LEN + TEXT_GAP);
      rotate(-HALF_PI);
      text(this.xlabels[i], 0, 0);
      popMatrix();
    }
    // y ticks/labels
    textAlign(RIGHT, CENTER);
    int ngaps = nYGaps(h);
    for (int i = 0; i < ngaps + 1; i++) {
      float tickY = charty + charth * i / ngaps;
      line(chartx, tickY, chartx - TICK_LEN, tickY);
      String tickStr = nf((1 - i / float(ngaps)) * this.ymax, 1, 2);
      text(tickStr, chartx - TICK_LEN - TEXT_GAP, tickY);
    }
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