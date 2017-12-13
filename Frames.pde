public Frame[] makeFrames(Table raw) {
  return new Frame[]{
    new Intro(raw),
    new Frame0(raw),
    new Frame1(raw)
  };
}

class Intro extends Frame {
  public Intro(Table raw) {
    super(raw);
    this.title = "The Evolution of Gaming Consoles Since 1980";
    this.text = "Gaming has come a long way, evolving from a niche hobby enjoyed by a " +
                "select few, to a multimillion dollar industry with widespread acceptance. " +
                "That journey has correspondingly seen the concurrent evolution of the " +
                "game console. How have they changed? Where are they going? Scroll down " +
                "to find out!";
  }
  
  public Chart transition(Chart chart) {
    String[] yearStrs = new String[years.size()];
    for (int i = 0; i < years.size(); i++) yearStrs[i] = String.valueOf(years.get(i));
    StackedBarChart sbchart = new StackedBarChart(platformsByYears, "year", yearStrs, "physical_sales", platformStrs, platforms);
    return sbchart;
  }
}

class Frame0 extends Frame {
  public Frame0(Table raw) {
    super(raw);
    this.title = "1980-2: Atari is King";
    this.text = "In 1980-2, the Atari 2600 was by far the most popular game console. " +
                "Still, the market was small as gaming was in its infancy.";
  }
  
  public Chart transition(Chart chart) {
    BubbleChart bchart = new BubbleChart(platformsForYears.get(1996), "platform", platformStrs, "sales", platforms);
    return bchart;
  }
}

class Frame1 extends Frame {
  public Frame1(Table raw) {
    super(raw);
    this.title = "1983: Nintendo Usurps Atari";
    this.text = "In 1983, the video game market crashed and with it, Atari. " +
                "Nintendo steps in with the NES and dominates the market.";
  }
  
  public Chart transition(Chart chart) {
    BubbleChart bchart = new BubbleChart(platformsForYears.get(1983), "platform", platformStrs, "sales", platforms);
    return bchart;
  }
}