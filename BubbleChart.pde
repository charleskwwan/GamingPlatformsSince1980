private final float FIXED_DIM_PERCENT = .8;

public class BubbleChart extends Chart {
  private String idname;
  private HashMap<String, Integer> colorMap;
  private HashMap<String, ArrayList<Node>> nodes;
  private ArrayList<Node> fixedNodes, dyingNodes; // nodes transitioning out
  
  public BubbleChart(
    Table tbl, 
    String idname, String xname, String[] xlabels, String yname,
    HashMap<String, Integer> colorMap
  ) {
    super(tbl, xname, xlabels, yname, new String[]{});
    this.idname = idname;
    this.colorMap = colorMap;
    this.dyingNodes = new ArrayList<Node>();
    this.fixedNodes = new ArrayList<Node>();
    
    // node initialization
    this.nodes = new HashMap<String, ArrayList<Node>>();
    for (String lbl : this.xlabels)
      this.nodes.put(lbl, new ArrayList<Node>());
    updateNodes(this.tbl); // initializes nodes
  }
  
  private class Node extends DataPoint {
    private PVector pos, v0;
    private TransitionValue r, drawx, drawy, drawr;
    private ArrayList<PVector> q;

    public Node(float x, float y, float r, TableRow row) {
      super(row);
      this.pos = new PVector(x, y);
      this.v0 = new PVector(0, 0);
      this.r = TransitionValues.add(0, r);
      this.q = new ArrayList<PVector>();
      
      // set dummy draw dimensions for now
      this.drawx = TransitionValues.add(getCenterX(), getCenterX());
      this.drawy = TransitionValues.add(getCenterY(), getCenterY());
      this.drawr = TransitionValues.add(0, 0);
    }
    
    /* general */
    public String getId() {
      return this.data.get(BubbleChart.this.idname);
    }
    
    public String getLabel() {
      return this.data.get(BubbleChart.this.xname);
    }
    
    public float getRadius() {
      return this.r.getCurrent();
    }
    
    private float getTrueRadius() {
      return this.r.getFinal();
    }
    
    public float getMass() {
      return pow(this.r.getFinal(), 2);
    }
    
    public void update(float r, TableRow row) {
      if (row != null) set(row);
      this.r.setFinal(r);
    }
    
    /* physics */
    public PVector particleForce(Node other) {
      PVector fc = Physics.coulombs(this.pos, other.pos);
      PVector fd = Physics.damping(this.v0);
      return PVector.add(fc, fd);
    }
    
    public PVector springForce(Node other, float len) {
      float dist = pow(this.pos.x - other.pos.x, 2) + pow(this.pos.y - other.pos.y, 2);
      float thisr = getTrueRadius(), otherr = other.getTrueRadius();
      if (pow(thisr - otherr, 2) < dist && dist < pow(thisr + otherr, 2)) {
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
      if (yScale(this.pos.y) < 0 || yScale(this.pos.y) > yScale(h)) {
        this.pos.y = max(0, min(getH(), this.pos.y));
        this.v0.y = 0;
      }
    }
    
    public void accumulate() {
      PVector total = new PVector(0, 0);
      while (!q.isEmpty()) total.add(q.remove(q.size()-1));
      PVector a = Physics.acceleration(total, getMass());
      PVector v1 = Physics.velocity(this.v0, a, 1);
      PVector s = Physics.displacement(this.v0, a, 1);
      this.v0 = v1;
      this.pos.add(s);
      enclose();
    }
    
    /* drawing */    
    private void draw() {
      stroke(isOver() ? 150 : 0);
      strokeWeight(isOver() ? 4 : 1);
      fill(BubbleChart.this.colorMap.get(this.data.get(BubbleChart.this.xname)));
      ellipse(
        this.drawx.getCurrent(), this.drawy.getCurrent(),
        this.drawr.getCurrent()*2, this.drawr.getCurrent()*2
      );
      strokeWeight(1);
    }
    
    // x, y, w, h are chart dimensions
    public void draw(float x, float y, float w, float h) {
      this.drawx.setFinal(x + this.pos.x * (w / getW()));
      this.drawy.setFinal(yScale(y + this.pos.y * (h / getH())));
      this.drawr.setFinal(this.getRadius() * (w < h ? w / getW() : h / getH()));
      draw();
    }
    
    public void drawFixed(float x, float y, float chartw, float charth) {
      this.drawx.setFinal(x);
      this.drawy.setFinal(y);
      this.drawr.setFinal(this.getRadius() * (chartw < charth ? chartw / getW() : charth / getH()));
      draw();
    }
    
    public void drawTooltip() {
      String[] lines = new String[]{
        "name: " + this.data.get("name"), // name string
        BubbleChart.this.xname + ": " + this.data.get(BubbleChart.this.xname), // x string
        BubbleChart.this.yname + ": " + this.data.get(BubbleChart.this.yname) // y string
      };
      drawDefault(lines);
    }
    
    /* mouse interactions */
    public boolean isOver() {
      return pow(mouseX - this.drawx.getCurrent(), 2) + pow(mouseY - this.drawy.getCurrent(), 2) <= 
             pow(this.drawr.getCurrent(), 2);
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
  
  private float xScale(float val) {
    return val;
  }
  
  private float yScale(float val) {
    return val * (this.fixedNodes.isEmpty() ? 1 : FIXED_DIM_PERCENT);
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
  
  // helper for node making: pick out xlabels that have at least one row
  private HashMap<String, Iterable<TableRow>> getNonEmptyRows(Table tbl) {
    HashMap<String, Iterable<TableRow>> map = new HashMap<String, Iterable<TableRow>>();
    for (String lbl : this.xlabels) {
      Iterable<TableRow> rows = tbl.findRows(lbl, this.xname);
      if (rows.iterator().hasNext()) map.put(lbl, rows);
    }
    return map;
  }
  
  private Node newNode(float a1, float a2, float r, TableRow row) {
    float angle = random(a1, a2);
    float dist = random(getW()/10, 2*getW()/5);
    return new Node(
      getCenterX() + cos(angle) * dist - getX(),
      getCenterY() + sin(angle) * dist - getY(),
      r,
      row
    );
  }
  
  private void killNode(Node node) {
    node.update(0, null);
    this.dyingNodes.add(node);
  }
  
  public void updateNodes(Table tbl) {
    HashMap<String, Iterable<TableRow>> nonEmptyRows = getNonEmptyRows(tbl);
    
    for (int i = 0; i < this.xlabels.length; i++) {
      String lbl = this.xlabels[i];
      // remove nodes for nonexisting labels with no rows
      if (!nonEmptyRows.containsKey(lbl)) {
        for (Node node : this.nodes.get(lbl))
          killNode(node);
        this.nodes.get(lbl).clear();
        continue;
      }
      
      Iterable<TableRow> rows = nonEmptyRows.get(lbl);
      float a1 = i * TWO_PI / this.xlabels.length, a2 = (i+1) * TWO_PI / this.xlabels.length;
      ArrayList<Node> lblNodes = this.nodes.get(lbl);
      
      int j = 0;
      for (TableRow row : rows) {
        float yval = row.getFloat(this.yname);
        if (yval < 0.5) { // ignore values that are too small
          continue;
        } else if (j < lblNodes.size()) { // update existing node
          lblNodes.get(j).update(toRadius(yval), row);
        } else { // add new node
          lblNodes.add(newNode(a1, a2, toRadius(yval), row));
        }
        j++;
      }
      for ( ; j < lblNodes.size(); j++) // remove excess nodes
        killNode(lblNodes.remove(lblNodes.size()-1));
    }
  }
  
  // stage all changes
  private void chargeTheForce() {
    for (String lbl1 : this.nodes.keySet()) {
      for (String lbl2 : this.nodes.keySet()) {
        for (Node n1 : this.nodes.get(lbl1)) {
          for (Node n2 : this.nodes.get(lbl2)) {
            if (n1 == n2) continue;
            float springLen = getW() / (lbl1 == lbl2 ? 100 : 7);
            springLen += 2 * sqrt(n1.getRadius() + n2.getRadius());
            n1.stage(n1.particleForce(n2));
            n1.stage(n1.springForce(n2, springLen));
          }
        }
      }
    }
  }
  
  // accumulate all changes
  private void useTheForce() {
    for (String lbl : this.nodes.keySet())
      for (Node node : this.nodes.get(lbl))
        node.accumulate();
  }
  
  /* node fixing */
  public void fixNodes(String[] ids) {
    // use hashmap like set
    HashMap<String, String> idSet = new HashMap<String, String>();
    for (String id : ids) idSet.put(id, null);
    // iterate thru nodes looking for nodes with ids in idSet to fix
    for (String lbl : this.nodes.keySet()) {
      ArrayList<Node> lblNodes = this.nodes.get(lbl);
      for (int i = lblNodes.size()-1; i >= 0; i--) {
        Node n = lblNodes.get(i);
        if (idSet.containsKey(n.getId()))
          this.fixedNodes.add(lblNodes.remove(i));
      }
    }
  }
  
  // unfixes all fixed nodes
  public void unfixNodes() {
    for (int i = this.fixedNodes.size()-1; i >= 0; i--) {
      Node node = this.fixedNodes.remove(i);
      this.nodes.get(node.getLabel()).add(0, node);
    }
  }
  
  /* draw */
  private void drawDyingNodes(float x, float y, float w, float h) {
    for (int i = this.dyingNodes.size()-1; i >= 0; i--) {
      Node node = this.dyingNodes.get(i);
      if (node.getRadius() < 1) {
        this.dyingNodes.remove(node); // when small enough
      } else {
        node.draw(x, y, w, h);
      }
    }
  }
  
  private void drawFixedNodes(float x, float y, float w, float h) {
    float nodeW = w / this.fixedNodes.size();
    y += h * (FIXED_DIM_PERCENT + 1) / 2;
    for (int i = 0; i < this.fixedNodes.size(); i++) {
      this.fixedNodes.get(i).drawFixed(x + (i + 0.5) * nodeW, y, w, h);
    }
  }
  
  public void draw(float x, float y, float w, float h) {
    chargeTheForce();
    useTheForce();

    for (String lbl : this.nodes.keySet())
      for (Node node : this.nodes.get(lbl))
        node.draw(x, y, w, h);
    drawDyingNodes(x, y, w, h);
    drawFixedNodes(x, y, w, h);
  }
  
  /* mouse interactions */
  private Node onWhich() {
    Node which = null;
    for (String lbl : this.nodes.keySet())
      for (Node n : this.nodes.get(lbl))
        if (n.isOver()) which = n;
    for (Node n : this.fixedNodes)
      if (n.isOver()) which = n;
    return which;
  }
  
  public void onOver() {
    Node over = onWhich();
    if (over != null) tooltips.add(over);
  }
}