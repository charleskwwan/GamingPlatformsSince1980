private float POINT_RADIUS = 5;

public class LineChart extends AxisChart {
  private HashMap<String, ArrayList<Point>> points;
  private HashMap<String, ArrayList<Line>> lines;
  private HashMap<String, Integer> colorMap;
  private HashMap<String, Integer> hiddenSeries; // hide certain labels, integer is a dummy 
  
  public LineChart(
    Table tbl,
    String xname, String[] xlabels, String yname, String[] ylabels,
    HashMap<String, Integer> colorMap
  ) {
    super(tbl, xname, xlabels, yname, ylabels);
    this.colorMap = colorMap;
    this.hiddenSeries = new HashMap<String, Integer>();
    
    // initialize points
    this.points = new HashMap<String, ArrayList<Point>>();
    this.lines = new HashMap<String, ArrayList<Line>>();
    for (String lbl : this.ylabels) {
      this.points.put(lbl, new ArrayList<Point>());
      this.lines.put(lbl, new ArrayList<Line>());
    }
    makePoints(this.tbl);
  }
  
  private class Point extends DataPoint {
    private String label;
    private float drawx, drawy;
    private TransitionValue drawr;

    public Point(TableRow row, String label) {
      super(row);
      this.label = label;
      this.drawr = TransitionValues.add(0, POINT_RADIUS);
    }
    
    protected float getH(float charth) {
      return charth * Float.valueOf(this.data.get(this.label)) / LineChart.this.ymax;
    }
    
    /* draw */
    public void draw(float x, float y, float chartw, float charth) {
      this.drawx = x;
      this.drawy = y - getH(charth);
      float rMult = isOver() ? 4 : 2;
      noStroke();
      fill(LineChart.this.colorMap.get(this.label));
      ellipse(this.drawx, this.drawy, this.drawr.getCurrent()*rMult, this.drawr.getCurrent()*rMult);
    }
    
    public void drawTooltip() {
      drawDefault(new String[]{
        LineChart.this.xname + ": " + this.data.get(LineChart.this.xname), // x string
        "market: " + this.label, // y string, hacky
        "revenue: " + this.data.get(this.label) + " bil" // hacky
      });
    }
    
    /* mouse interactions */
    public boolean isOver() {
      return pow(mouseX - this.drawx, 2) + pow(mouseY - this.drawy, 2) <= 
             pow(this.drawr.getCurrent(), 2);
    }
  }
  
  private class Line {
    TransitionValue x1, y1, x2, y2;
    
    public Line(float x1, float y1, float x2, float y2) {
      this.x1 = TransitionValues.add(x1, x1);
      this.y1 = TransitionValues.add(y1, y1);
      this.x2 = TransitionValues.add(x1, x2);
      this.y2 = TransitionValues.add(y1, y2);
    }
    
    public void draw(float x1, float y1, float x2, float y2) {
      this.x1.setFinal(x1);
      this.y1.setFinal(y1);
      this.x2.setFinal(x2);
      this.y2.setFinal(y2);
      if (this.x1.getCurrent() != this.x2.getCurrent() &&
          this.y1.getCurrent() != this.y2.getCurrent())
        line(
          this.x1.getCurrent(), this.y1.getCurrent(),
          this.x2.getCurrent(), this.y2.getCurrent()
        );
    }
  }
  
  /* point methods */
  private void makePoints(Table tbl) {
    for (String ylbl : this.ylabels) {
      ArrayList<Point> lblPoints = this.points.get(ylbl);
      for (String xlbl : this.xlabels) {
        TableRow row = tbl.findRow(xlbl, this.xname);
        lblPoints.add(new Point(row, ylbl));
      }
    }
  }
  
  public void addHidden(String series) {
    this.hiddenSeries.put(series, 0);
    //if (this.lines.containsKey(series))
    //  this.lines.get(series).clear();
  }
  
  public void clearHidden() {
    this.hiddenSeries.clear();
  }
  
  /* ymax */  
  protected float yMax(Table tbl) {
    FloatList lst = new FloatList();
    for (String xlbl : this.xlabels) {
      TableRow row = tbl.findRow(xlbl, this.xname);
      for (String ylbl : this.ylabels) lst.append(row.getFloat(ylbl));
    }
    return lst.max();
  }
  
  /* drawing */
  public void draw(float x, float y, float w, float h) {
    // prep
    float xoff = xOffset(), yoff = yOffset();
    float chartx = x + xoff, chartw = w - xoff;
    float charty = y, charth = h - yoff;
    
    // points and lines
    for (String lbl : this.points.keySet()) {      
      ArrayList<Point> lblPoints = this.points.get(lbl);
      ArrayList<Line> lblLines = this.lines.get(lbl);
      Float prevx = null, prevy = null;
      
      for (int i = 0; i < lblPoints.size(); i++) {
        // draw point
        Point pt = lblPoints.get(i);
        float ptx = chartx + chartw * (i + .5) / this.xlabels.length;
        float pty = charty + charth - pt.getH(charth);
        if (!this.hiddenSeries.containsKey(lbl))
          pt.draw(ptx, charty + charth, chartw, charth);
        
        // draw line using previous point's coordinates
        if (prevx != null && prevy != null) {
          stroke(this.colorMap.get(lbl));
          strokeWeight(4);
          if (i - 1 >= lblLines.size())
            lblLines.add(new Line(prevx, prevy, ptx, pty));
          if (this.hiddenSeries.containsKey(lbl)) { // shrink
            lblLines.get(i - 1).draw(prevx, prevy, prevx, prevy);
          } else { // draw
            lblLines.get(i - 1).draw(prevx, prevy, ptx, pty);
          }
          strokeWeight(1);
        }
        prevx = ptx;
        prevy = pty;
      }
    }
    
    // axes
    PFont font = createFont(MAIN_FONT, FONT_SIZE);
    textFont(font);
    fill(0);
    stroke(0);
    drawAxes(x, y, w, h, chartx, charty, chartw, charth);
  }
  
  /* mouse interactions */
  private Point whichOver() {
    Point which = null;
    for (String lbl : this.points.keySet()) {
      if (this.hiddenSeries.containsKey(lbl)) continue;
      for (Point pt : this.points.get(lbl))
        if (pt.isOver()) which = pt;
    }
    return which;
  }
  
  public void onOver() {
    Point over = whichOver();
    if (over != null) tooltips.add(over);
  }
}