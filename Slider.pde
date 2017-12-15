public enum SlideDirection {
  HORIZONTAL, VERTICAL
};

public enum SlideType {
  DISCRETE, CONTINUOUS
};

public class Slider extends ViewPort {
  private SlideDirection dir;
  private SlideType ty;
  private int n;
  private float lo, hi; // continuous
  private color bg, fg;
  protected Block block;
  private boolean dragged = false;
  
  // discrete type
  public Slider(float x, float y, float w, float h, SlideDirection dir, int n, color bg, color fg) {
    super(x, y, w, h);
    this.n = n;
    set(dir, SlideType.DISCRETE, bg, fg);
  }
  
  // continuous type
  public Slider(float x, float y, float w, float h, SlideDirection dir, float lo, float hi, color bg, color fg) {
    super(x, y, w, h);
    this.lo = min(lo, hi);
    this.hi = max(lo, hi);
    set(dir, SlideType.CONTINUOUS, bg, fg);
  }
  
  protected class Block extends ViewPort {
    public Block(float x, float y, float w, float h) {
      super(x, y, w, h);
    }
    
    public float getValue() {
      if (Slider.this.ty == SlideType.DISCRETE) {
        return Slider.this.dir == SlideDirection.VERTICAL ?
          getIndex(getY() - Slider.this.getY(), getH()) :
          getIndex(getX() - Slider.this.getX(), getW());
      } else {
        float percent = Slider.this.dir == SlideDirection.HORIZONTAL ?
          (getX() - Slider.this.getX()) / (Slider.this.getW() - getW()) :
          (getY() - Slider.this.getY()) / (Slider.this.getH() - getH());
        return (Slider.this.hi - Slider.this.lo) * percent + Slider.this.lo;
      }
    }
    
    public void setValue(float val) {
      if (Slider.this.ty == SlideType.DISCRETE) {
        if (val < 0 || val > Slider.this.n) {
          return;
        } else if (Slider.this.dir == SlideDirection.VERTICAL) {
          this.y = Slider.this.getY() + val * getH();
        } else {
          this.x = Slider.this.getX() + val * getW();
        }
      } else {
        float percent = (val - Slider.this.lo) / (Slider.this.hi - Slider.this.lo);
        if (val < Slider.this.lo || val > Slider.this.hi) {
          return;
        } else if (Slider.this.dir == SlideDirection.VERTICAL) {
          this.y = Slider.this.getY() + (Slider.this.getH() - getH()) * percent;
        } else {
          this.x = Slider.this.getX() + (Slider.this.getW() - getW()) * percent;
        }
      }
    }
    
    public void draw() {
      float drawx = getX(), drawy = getY();
      if (Slider.this.ty == SlideType.DISCRETE) {
        if (Slider.this.dir == SlideDirection.VERTICAL) {
          float diff = getIndex(getY() - Slider.this.getY(), getH()) * getH();
          drawy = Slider.this.getY() + diff;
        } else {
          float diff = getIndex(getX() - Slider.this.getX(), getW()) * getW();
          drawx = Slider.this.getX() + diff;
        }
      }
      
      noStroke();
      fill(Slider.this.fg);
      rect(drawx, drawy, getW(), getH());
    }
    
    public void onDrag() {
      if (Slider.this.dir == SlideDirection.VERTICAL) {
        float slideY = Slider.this.getY(), slideH = Slider.this.getH();
        this.y = max(slideY, min(slideY + slideH - getH(), this.y + mouseY - pmouseY));
      } else {
        float slideX = Slider.this.getX(), slideW = Slider.this.getW();
        this.x = max(slideX, min(slideX + slideW - getW(), this.x + mouseX - pmouseX));
      }
    }
  }
  
  /* block methods */
  private Block makeBlock() {
    float w = getW(), h = getH();
    if (this.dir == SlideDirection.HORIZONTAL) {
      w = this.ty == SlideType.DISCRETE ? getW() / this.n : h;
    } else {
      h = this.ty == SlideType.DISCRETE ? getH() / this.n : w;
    }
    return new Block(getX(), getY(), w, h);
  }
  
  /* general */
  protected void set(SlideDirection dir, SlideType ty, color bg, color fg) {
    this.dir = dir;
    this.ty = ty;
    this.bg = bg;
    this.fg = fg;
    this.block = makeBlock();
  }
  
  private int getIndex(float pos, float sectLen) {
    return int(pos / sectLen);
  }
  
  public float getValue() {
    return this.block.getValue();
  }
  
  public void setValue(float val) {
    this.block.setValue(val);
  }
  
  /* draw */
  public void draw() {
    // bg
    noStroke();
    fill(this.bg);
    rect(getX(), getY(), getW(), getH());
    // fg
    this.block.draw();
  }
  
  /* mouse interactions 
   * onDrag, onPress, and onRelease must all be used for slider to work
   */
  public boolean isOver() {
    return mouseX > getX() && mouseX < getX() + getW() &&
           mouseY > getY() && mouseY < getY() + getH();
  }
  
  public void onDrag() {
    if (this.dragged) this.block.onDrag();
  }
  
  public void onPress() {
    this.dragged = true;
  }
  
  public void onRelease() {
    this.dragged = false;
  }
}