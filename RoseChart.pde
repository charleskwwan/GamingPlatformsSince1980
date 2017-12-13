//public class RoseCharextends Chart t extends Chart {
//  private HashMap<String, Integer> colorMap;
//  private float ymax;
//  private ArrayList<Slice> slices;
  
//  public RoseChart(
//    float x, float y, float w, float h,
//    Table tbl,
//    String xname, String[] xlabels, String yname,
//    HashMap<String, Integer> colorMap
//  ) {
//    super(x, y, w, h, tbl, xname, xlabels, yname, new String[]{});
//    this.colorMap = colorMap;
//    this.ymax = 250;
//    this.slices = makeSlices();
//  }
  
//  private class Slice extends DataPoint {
//    public Slice(TableRow row) {
//      super(row);
//    }
    
//    public void draw(float x, float y, int i, float chartw, float charth) {
//      float r = getRadius() * row.getFloat(RoseChart.this.yname) / RoseChart.this.ymax;
//      float subAngle = TWO_PI / RoseChart.this.xlabels.length;
//      float a1 = -(HALF_PI + subAngle/2) + i * subAngle, a2 = -(HALF_PI + subAngle/2) + (i+1) * subAngle;
//      fill(colorMap.get(RoseChart.this.xlabels[i]));
//      arc(x, y, r*2, r*2, a1, a2, PIE);
//    }
//  }
  
//  /* general methods */
//  public float getRadius() {
//    return min(getW() * .8, getH() - 4 * FONT_SIZE) / 2;
//  }
  
//  /* slice methods */
//  private ArrayList<Slice> makeSlices() {
//    ArrayList<Slice> slices = new ArrayList<Slice>();
//    for (String lbl : this.xlabels) {
//      TableRow row = this.tbl.findRow(lbl, this.xname);
//      slices.add(new Slice(row));
//    }
//    return slices;
//  }
  
//  /* chart and data methods */
//  private float yMax() {
//    FloatList lst = new FloatList();
//    for (String lbl : this.xlabels) {
//      TableRow row = this.tbl.findRow(lbl, this.xname);
//      lst.append(row.getFloat(this.yname));
//    }
//    return lst.max();
//  }
  
//  private int nYGaps() {
//    return int(getRadius() / 50);
//  }
  
//  /* abstracts */
//  public void draw() {
//    // prep
//    float cx = getCenterX(), cy = getCenterY(), r = getRadius();
//    int ngaps = nYGaps();
//    PFont font = createFont(MAIN_FONT, FONT_SIZE);
//    textFont(font);
     
//    // slices
//    stroke(0);
//    for (int i = 0; i < this.xlabels.length; i++)
//      this.slices.get(i).draw(cx, cy, i, 0, 0);
    
//    // circles
//    stroke(0);
//    noFill();
//    for (int i = 0; i < ngaps + 1; i++) {
//      float circr = i * r / ngaps;
//      ellipse(cx, cy, circr*2, circr*2);
//    }
//    // axis, pt labels
//    stroke(0);
//    fill(0);
//    float offset = -HALF_PI;
//    for (int i = 0; i < this.xlabels.length; i++) {
//      float outerx = cx + cos(offset) * r, outery = cy + sin(offset) * r;
//      line(cx, cy, outerx, outery);
//      if (offset == HALF_PI || offset == -HALF_PI) {
//        textAlign(CENTER, CENTER);
//        text(this.xlabels[i], outerx, outery + 2 * FONT_SIZE * (offset < 0 ? -1 : 1));
//      } else if (offset > -HALF_PI && offset < HALF_PI) {
//        textAlign(LEFT, CENTER);
//        text(this.xlabels[i], cx + cos(offset) * (r + 2 * FONT_SIZE), cy + sin(offset) * (r + 2 * FONT_SIZE));
//      } else {
//        textAlign(RIGHT, CENTER);
//        text(this.xlabels[i], cx + cos(offset) * (r + 2 * FONT_SIZE), cy + sin(offset) * (r + 2 * FONT_SIZE));
//      }
//      offset += TWO_PI / this.xlabels.length;
//    }
//    // axis labels
//    textAlign(CENTER, CENTER);
//    for (int i = 0; i < ngaps + 1; i++) {
//      String lbl = nf(i * this.ymax / ngaps, 1, 2);
//      float lblx = cx + cos(-HALF_PI) * r * i / ngaps, lbly = cy + sin(-HALF_PI) * r * i / ngaps;
//      float lblw = textWidth(lbl) + 10, lblh = FONT_SIZE + 10;
//      // rect bg
//      fill(255);
//      rect(lblx - lblw/2, lbly - lblh/2, lblw, lblh);
//      // text
//      fill(0);
//      text(lbl, lblx, lbly);
//    }
//  }
//}