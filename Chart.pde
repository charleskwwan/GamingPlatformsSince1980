public abstract class Chart {
  protected Table tbl;
  protected String xname, yname;
  protected String[] xlabels, ylabels;
  
  public Chart(Table tbl, String xname, String[] xlabels, String yname, String[] ylabels) {
    this.tbl = tbl;
    this.xname = xname;
    this.xlabels = xlabels;
    this.yname = yname;
    this.ylabels = ylabels;
  }
  
  public abstract void draw(float x, float y, float w, float h);
  public abstract void onOver();
}