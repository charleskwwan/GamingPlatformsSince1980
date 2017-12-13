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

public abstract class Tooltip {
  public void drawDefault(String[] lines) { // default lines on white bg rect
    textFont(createFont(MAIN_FONT, FONT_SIZE));
    textAlign(LEFT, TOP);
    FloatList lineLengths = new FloatList();
    for (String l : lines) lineLengths.append(textWidth(l));
    float longest = lineLengths.max();
    
    // rect
    stroke(0);
    fill(255);
    float h = lines.length * (textAscent() + textDescent()) + 2 * TEXT_GAP;
    rect(mouseX, mouseY - h - TEXT_GAP, longest + 2 * TEXT_GAP, h);
    // text
    fill(0);
    for (int i = 0; i < lines.length; i++)
      text(lines[i], mouseX + TEXT_GAP, mouseY - h + i * (textAscent() + textDescent()));
  }
  
  public abstract void drawTooltip();
}