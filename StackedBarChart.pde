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
    public Bar(TableRow row) {
      super(row);
    }
    
    /* draw */
    public void draw(float x, float y, float chartw, float charth) {
      float w = .75 * chartw / StackedBarChart.this.xlabels.length;
      int ylabelsLen = StackedBarChart.this.ylabels.length;
      for (int j = 0; j < ylabelsLen; j++) {
        String ylabel = StackedBarChart.this.ylabels[j];
        float yval = this.row.getFloat(ylabel);
        float h = charth * yval / StackedBarChart.this.ymax;
        y -= h;
        fill(StackedBarChart.this.colorMap.get(ylabel));
        rect(x - w/2, y, w, h);
      }
    }
    
    public void drawTooltip() {
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
  public void onOver() {
  }
}