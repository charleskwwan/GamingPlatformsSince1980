public abstract class AxisChart extends Chart {
  protected float ymax;
  
  public AxisChart(Table tbl, String xname, String[] xlabels, String yname, String[] ylabels) {
    super(tbl, xname, xlabels, yname, ylabels);
    this.ymax = yMax(this.tbl);
  }
  
  /* chart and data methods */  
  protected float xOffset() {
    String ymaxStr = nf(this.ymax, 1, 2); // pad decimal points to 2
    return FONT_SIZE + textWidth(ymaxStr) + 2 * TEXT_GAP + TICK_LEN;
  }
  
  protected float yOffset() {
    FloatList lst = new FloatList();
    for (String label : this.xlabels) lst.append(textWidth(label));
    return FONT_SIZE + lst.max() + 2 * TEXT_GAP + TICK_LEN;
  }
  
  protected int nYGaps(float h) {
    return int(h / 40);
  }
  
  /* drawing */
  protected void drawAxes(
    float x, float y, float w, float h,
    float chartx, float charty, float chartw, float charth
  ) {   
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
  
  /* abstracts (from chart) */
  protected abstract float yMax(Table tbl);
  public abstract void draw(float x, float y, float w, float h);
  public abstract void onOver();
}