public class Tooltips {
  private ArrayList<Tooltip> tooltips;
  
  public Tooltips() {
    this.tooltips = new ArrayList<Tooltip>();
  }
  
  public void add(Tooltip tt) {
    this.tooltips.add(tt);
  }
  
  public void draw() {
    for (Tooltip tt : this.tooltips) tt.drawTooltip();
    this.tooltips.clear();
  }
}

public interface Tooltip {
  public void drawTooltip();
}