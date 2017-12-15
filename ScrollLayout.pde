public abstract class Frame {
  public String title = "", text = "";
  public abstract Chart transition(Chart chart);
  public abstract void drawLegend(float x, float y, float w, float h);
}

public class ScrollLayout extends ViewPort {
  private ArrayList<Pair<Frame, Float>> frames; // pair<frame, y-offset>
  private Chart chart;
  private int active; // 0 for intro, 1->n for rest
  private float scrolly, totalHeight;
  private Pair<Integer, TransitionValue> legendX;
  public Slider slider;
  public boolean lastFrame = false;
  public Button[] buttons;
  
  public ScrollLayout(
    float x, float y, float w, float h,
    Frame[] frames
  ) {
    super(x, y, w, h);
    this.frames = new ArrayList<Pair<Frame, Float>>();
    this.active = 0;
    this.scrolly = y;
    
    // set chart
    if (frames.length > 0) this.chart = frames[0].transition(null);
    
    // make frames and set total height
    float yoffset = 0;
    for (int i = 0; i < frames.length; i++) {
      Frame frame = frames[i];
      this.frames.add(new Pair(frame, yoffset));
      yoffset += frameHeight(i, frame.title, frame.text);
    }
    this.totalHeight = yoffset + getH()/2; // add getH to allow scrolling
    slider = new Slider(getX(), 0, width / 6, 40, SlideDirection.HORIZONTAL, 39, color(211,211,211), color (0));
    setButtons();     
  }
  
  private void setButtons(){
      buttons = new Button[6];
      int i = 0;
      for (HashMap.Entry<String, Integer> entry : platforms().entrySet()){
         String platform = entry.getKey();
         Button b = new Button(0, 0, 100, 50, platform); 
         b.c2 = color(211,211,211);
         b.c1 = color(255);
         buttons[i] = b;
         i++;
      }
  }
  /* frame methods */
  private float textHeight(String text, float wrapWidth, String fontName, float fontSize) {
    textFont(createFont(fontName, fontSize));
    float textWidth = textWidth(text);
    return 1.3 * (textAscent() + textDescent()) * 
           (int(textWidth / wrapWidth) + (textWidth % wrapWidth > 0 ? 1 : 0));
  }
  
  private float topPadding(int i) {
    return getH() * (i == 0 ? .05 : .35);
  }
  
  private float bottomPadding(int i) {
    return getH() * (i == 0 ? .5 : .05); // .6 for intro for chart
  }
  
  private float frameWidth(int i) {
    return getW() * (i == 0 ? 1 : .25);
  }
  
  private float titleSz(int i) {
    return FONT_SIZE * (i == 0 ? 3 : 1);
  }
  
  private float textSz(int i) {
    return FONT_SIZE * (i == 0 ? 1.5 : 1);
  }
  
  private float frameHeight(int i, String title, String text) {
    String titleFont = MAIN_FONT + " Bold", textFont = MAIN_FONT;
    float paddingHgt = topPadding(i) + bottomPadding(i), wrapWidth = frameWidth(i);
    float titleSize = titleSz(i), textSize = textSz(i);
    return textHeight(title, wrapWidth, titleFont, titleSize) +
           textHeight(text, wrapWidth, textFont, textSize) +
           paddingHgt;
  }
  
  /* drawing */
  private void drawFrameText(int i) {
    if (i < 0 || i >= this.frames.size()) return; // domain
    Frame frame = this.frames.get(i).fst;
    float yoffset = this.scrolly + this.frames.get(i).snd + topPadding(i);
    float frameWidth = frameWidth(i);
    if(i == this.frames.size() -1 ) yoffset = yoffset - 200;
    textAlign(i == 0 ? CENTER : LEFT, TOP);
    // title
    textFont(createFont(MAIN_FONT + " Bold", titleSz(i)));
    text(frame.title, getX(), yoffset, frameWidth, getH());
    yoffset += textHeight(frame.title, frameWidth, MAIN_FONT + " Bold", titleSz(i));
    // text
    textFont(createFont(MAIN_FONT, textSz(i)));
    text(frame.text, getX(), yoffset, frameWidth, getH());
    yoffset += textHeight(frame.text, frameWidth, MAIN_FONT, textSz(i));
  }
  
  private void drawFrameChart(int i) {
    if (i < 0 || i >= this.frames.size()) return; // domain
    Frame frame = this.frames.get(i).fst;
    
    if (this.chart == null) {
      return;
    } else if (i == 0) {
      float y = this.scrolly + this.frames.get(i).snd + 
                frameHeight(i, frame.title, frame.text) - bottomPadding(i);
      float h = bottomPadding(i) * .8;
      this.chart.draw(getX(), y, getW(), h);
    } else if(i == this.frames.size() -1){
      lastFrame = true;
      float xoffset = frameWidth(i) * 1.2;
      float w = (getW() - xoffset) * .8, h = getH() * .6;
      //draw slider
      setSlider();
      slider.draw();
      placeButtons();
      BubbleExploreFrame f = (BubbleExploreFrame)frame;
      this.chart.draw(getX() + (getW() + xoffset - w) / 2, getY() + getH() * .15, w, h);
      int year = (int)slider.getValue() + 1980;
      if (year == 2018) year = 2017;
      String[] ps = onPlatforms();
      this.chart = f.transitionYearPlatforms(this.chart, year, ps);
    } else {
      float xoffset = frameWidth(i) * 1.2;
      float w = (getW() - xoffset) * .8, h = getH() * .6;
      this.chart.draw(getX() + (getW() + xoffset - w) / 2, getY() + getH() * .15, w, h);
    }
  }
 
 private String[] onPlatforms(){
    ArrayList<String> platforms = new ArrayList<String>();
    for(Button b : buttons){
       if(b.buttonOn){
           platforms.add(b.title);
       }
    }
    String[] p = new String[platforms.size()];
    int i = 0;
    for(String s : platforms){
       p[i] = s;
       i++;
    }
    
    return p;
 }
 
 private void placeButtons(){
   int i = this.frames.size() -1;
    float yoffset = this.scrolly + this.frames.get(i).snd + topPadding(i) - 70;
    textFont(createFont(MAIN_FONT, textSz(i)));
    textSize(20);
    text("Platforms:", getX(), yoffset);
    yoffset +=40;
    int a = 0;
    float x1 = getX();
    float x2 = getX() + 110;
    for(Button b : buttons){
      if(a % 2 == 0){
        b.x = x1;
        b.y = yoffset;
      } else{
        b.x = x2;
        b.y = yoffset;
        yoffset += 60;
      }
      a++;
      b.draw();
    }
 }
 private void setSlider(){
      int i = this.frames.size() -1;
      float yoffset = this.scrolly + this.frames.get(i).snd + topPadding(i) - 200;
      slider.y = yoffset + 60;
      slider.block.y = yoffset + 60;
      slider.makeBlock();
      int yearVal = (int)slider.getValue() + (int)1980;
      if (yearVal == 2018) yearVal = 2017;
      textFont(createFont(MAIN_FONT, textSz(i)));
      fill(0);
      textSize(20);
      text("Year: " + yearVal, getX(), slider.y - 25);
      textSize(10);
      text("1980", getX(), slider.y + 25);
      text("2017", getX() + slider.w - 25, slider.y + 25); 
 }
  
  private void drawLegend(int i) {
    float x, y, w, h;
    if (this.active == 0) {
      h = getH() * .1;
      x = getX();
      y = getY() + getH() - h;
      w = getW();
    } else {
      float xoffset = frameWidth(i) * 1.2;
      x = getX() + xoffset;
      y = getY();
      w = getW() - xoffset;
      h = getH() * .1;
    }
    
    if (this.legendX == null ||
        (this.active == 0 && this.legendX.fst != 0) ||
        (this.active > 0 && this.legendX.fst == 0)) {
      this.legendX = new Pair(this.active, TransitionValues.add(width, x, .01));
    } else {
      this.legendX.snd.setFinal(x);
    }
    
    this.frames.get(i).fst.drawLegend(this.legendX.snd.getCurrent(), y, w, h);
  }
  
  public void draw() {
    // text
    fill(0);
    drawFrameText(this.active);
    fill(200);
    drawFrameText(this.active + 1);
    // chart
    drawFrameChart(this.active);
    drawLegend(this.active);
  }
  
  /* mouse interaction methods */
  public void onOver() {
    if (chart != null) chart.onOver();
  }
  
  public void onScrollUp() {
    if (scrolly < 0) scrolly += SCROLL_SPEED;
    if (this.active - 1 >= 0) {
      float prevYOffset = this.frames.get(this.active-1).snd;
      float prevHeight = this.frames.get(this.active).snd - prevYOffset;
      if (this.scrolly + prevYOffset + .7 * prevHeight >= 0) {
        this.active--;
        this.chart = this.frames.get(this.active).fst.transition(this.chart);
      };
    }
  }
  
  public void onScrollDown() {
    if (scrolly > getY() + getH() - this.totalHeight) scrolly -= SCROLL_SPEED;
    if (this.active + 1 < this.frames.size()) {
      float activeYOffset = this.frames.get(this.active).snd;
      float activeHeight = this.frames.get(this.active+1).snd - activeYOffset;
      if (this.scrolly + activeYOffset + .7 * activeHeight < 0) {
        this.active++;
        this.chart = this.frames.get(this.active).fst.transition(this.chart);
      }
    }
  }
}