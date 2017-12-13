public class BubbleChart extends Chart {
  private HashMap<String, Integer> colorMap;
  private HashMap<String, ArrayList<Node>> nodes;
  
  public BubbleChart(
    Table tbl, 
    String xname, String[] xlabels, String yname,
    HashMap<String, Integer> colorMap
  ) {
    super(tbl, xname, xlabels, yname, new String[]{});
    this.colorMap = colorMap;
    makeNodes(); // initializes nodes
  }
  
  private class Node extends DataPoint {
    private PVector pos, v0;
    private float r, mass;
    private ArrayList<PVector> q;
    private float drawx, drawy, drawr;

    public Node(float x, float y, float r, TableRow row) {
      super(row);
      this.pos = new PVector(x, y);
      this.v0 = new PVector(0, 0);
      this.r = r;
      this.mass = r;
      this.q = new ArrayList<PVector>();
    }
    
    /* physics */
    public PVector particleForce(Node other) {
      PVector fc = Physics.coulombs(this.pos, other.pos);
      PVector fd = Physics.damping(this.v0);
      return PVector.add(fc, fd);
    }
    
    public PVector springForce(Node other, float len) {
      float dist = pow(this.pos.x - other.pos.x, 2) + pow(this.pos.y - other.pos.y, 2);
      float otherr = other.getRadius();
      if (pow(this.r - otherr, 2) < dist && dist < pow(this.r + otherr, 2)) {
        return new PVector(0, 0);
      }
      return Physics.hookes(this.pos, other.pos, len);
    }
    
    public void stage(PVector chg) {
      this.q.add(chg);
    }
    
    // keep node within confines of chart
    private void enclose() {
      float w = getW(), h = getH();
      if (this.pos.x < 0 || this.pos.x > w) {
        this.pos.x = max(0, min(getW(), this.pos.x));
        this.v0.x = 0;
      }
      if (this.pos.y < 0 || this.pos.y > h) {
        this.pos.y = max(0, min(getH(), this.pos.y));
        this.v0.y = 0;
      }
    }
    
    public void accumulate() {
      PVector total = new PVector(0, 0);
      while (!q.isEmpty()) total.add(q.remove(q.size()-1));
      PVector a = Physics.acceleration(total, this.mass);
      PVector v1 = Physics.velocity(this.v0, a, 1);
      PVector s = Physics.displacement(this.v0, a, 1);
      this.v0 = v1;
      this.pos.add(s);
      enclose();
    }
    
    /* general */
    public float getRadius() {
      return this.r;
    }
    
    /* drawing */
    public void draw(float x, float y, float w, float h) {
      this.drawx = x + this.pos.x * (w / getW());
      this.drawy = y + this.pos.y * (h / getH());
      this.drawr = this.r * (w < h ? w / getW() : h / getH());
      if (this.row == null) return; // no fill possible
      stroke(0);
      strokeWeight(isOver() ? 4 : 1);
      fill(BubbleChart.this.colorMap.get(this.row.getString(BubbleChart.this.xname)));
      ellipse(this.drawx, this.drawy, this.drawr*2, this.drawr*2);
      strokeWeight(1);
    }
    
    public void drawTooltip() {
      String nameStr = "name: " + this.row.getString("name");
      String xStr = BubbleChart.this.xname + ": " + this.row.getString(BubbleChart.this.xname);
      String yStr = BubbleChart.this.yname + ": " + this.row.getString(BubbleChart.this.yname);
      float longest = max(textWidth(nameStr), textWidth(xStr), textWidth(yStr));
      
      textFont(createFont(MAIN_FONT, FONT_SIZE));
      textAlign(LEFT, TOP);
      // rect
      stroke(0);
      fill(255);
      float h = 3 * (textAscent() + textDescent()) + 2 * TEXT_GAP;
      rect(mouseX, mouseY - h - TEXT_GAP, longest + 2 * TEXT_GAP, h);
      // text
      fill(0);
      text(nameStr, mouseX + TEXT_GAP, mouseY - h);
      text(xStr, mouseX + TEXT_GAP, mouseY - h + textAscent() + textDescent());
      text(yStr, mouseX + TEXT_GAP, mouseY - h + 2 * (textAscent() + textDescent()));
    }
    
    /* mouse interactions */
    public boolean isOver() {
      return pow(mouseX - this.drawx, 2) + pow(mouseY - this.drawy, 2) <= pow(this.drawr, 2);
    }
  }
  
  /* relative dimension methods, same as ViewPort as Java doesnt allow multiple inheritance */
  private float getX() {
    return 0.;
  }
  
  private float getY() {
    return 0.;
  }
  
  private float getW() {
    return min(width, height);
  }
  
  private float getH() {
    return min(width, height);
  }
  
  private float getCenterX() {
    return getX() + getW() / 2;
  }
  
  private float getCenterY() {
    return getY() + getH() / 2;
  }
  
  /* Node methods */
  private float toRadius(float yval) {
    return sqrt(yval) * min(getW(), getH()) / 60;
  }
  
  private void makeNodes() {
    this.nodes = new HashMap<String, ArrayList<Node>>();
    float cx = getCenterX(), cy = getCenterY();
    
    // gather all nonempties to allow better initial node positioning
    ArrayList<Pair<String, Iterable<TableRow>>> nonEmptyRows = new ArrayList<Pair<String, Iterable<TableRow>>>();
    for (String lbl : this.xlabels) {
      Iterable<TableRow> rows = this.tbl.findRows(lbl, this.xname);
      if (rows.iterator().hasNext()) nonEmptyRows.add(new Pair(lbl, rows));
    }
    
    // initialize 1 arrayist per xlabel
    for (int i = 0; i < nonEmptyRows.size(); i++) {
      String lbl = nonEmptyRows.get(i).fst;
      Iterable<TableRow> rows = nonEmptyRows.get(i).snd;
      float a1 = i * TWO_PI / nonEmptyRows.size(), a2 = (i+1) * TWO_PI / nonEmptyRows.size();
      ArrayList<Node> lblNodes = new ArrayList<Node>();
      
      for (TableRow row : rows) {
        float yval = row.getFloat(this.yname);
        if (yval < 0.5) continue; // ignore too small
        float angle = random(a1, a2);
        float r = random(getW()/10, 2*getW()/5);
        lblNodes.add(new Node(cx+cos(angle)*r-getX(), cy+sin(angle)*r-getY(), toRadius(yval), row));
      }
      this.nodes.put(lbl, lblNodes);
    }
  }
  
  // stage all changes
  private void chargeTheForce() {
    for (String lbl1 : this.nodes.keySet()) {
      for (String lbl2 : this.nodes.keySet()) {
        for (Node n1 : this.nodes.get(lbl1)) {
          for (Node n2 : this.nodes.get(lbl2)) {
            if (n1 == n2) continue;
            float springLen = getW() / (lbl1 == lbl2 ? 8 : 3);
            springLen += 2 * sqrt(n1.getRadius() + n2.getRadius());
            n1.stage(n1.particleForce(n2));
            n1.stage(n1.springForce(n2, springLen));
          }
        }
      }
    }
  }
  
  private void useTheForce() {
    for (String lbl : this.nodes.keySet())
      for (Node node : this.nodes.get(lbl))
        node.accumulate();
  }
  
  /* abstract */
  public void draw(float x, float y, float w, float h) {
    chargeTheForce();
    useTheForce();

    for (String lbl : this.nodes.keySet())
      for (Node node : this.nodes.get(lbl))
        node.draw(x, y, w, h);
  }
  
  /* mouse interactions */
  private Node onWhich() {
    Node which = null;
    for (String lbl : this.nodes.keySet())
      for (Node n : this.nodes.get(lbl))
        if (n.isOver()) which = n;
    return which;
  }
  
  public void onOver() {
    Node over = onWhich();
    if (over != null) tooltips.add(over);
  }
}