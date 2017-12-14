public Frame[] makeFrames() {
  return new Frame[]{
    new Intro(), 
    new BubbleUpdateFrame(
      "1980: Atari is king",
      "In the early 1980s, the Atari 2600 was by far the most popular game console. " +
      "Still, the market was small as gaming was in its infancy.",
      1980
    ), 
    new BubbleUpdateFrame(
      "1983: Nintendo usurps Atari",
      "In 1983, the video game market crashed and with it, Atari. " +
      "Nintendo steps in with the NES and dominates the market.",
      1983
    ),
    new BubbleUpdateFrame(
      "1995: Sony usurps Nintendo",
      "After Nintendo pulls out of a hardware deal with Sony, " +
      "Sony breaks into the console market with the PlayStation, " +
      "sporting then-revolutionary 3D graphics. It quickly overtakes the NES, " +
      "and, after 9 years, becomes the first console to ship 100 " +
      "million units.",
      1995
    ),
    new BubbleUpdateFrame(
      "2001: Microsoft joins the fray",
      "Threatened by Playstation's future in \"living-room computing\", " +
      "Microsoft releases the Xbox. Though they don't quite dethrone " +
      "Sony, Nintendo's market share wanes further, and Microsoft " +
      "gains a foothold.",
      2001
    ),
    new BubbleFixedFrame(
      "2004: The peak of the Playstation 2",
      "Released in 2000, the PlayStation 2 is the most popular console " +
      "of all time, supported by a library of popular and exclusive game " +
      "franchises, such as 'Grand Theft Auto', 'Metal Gear Solid', and " +
      "'Dragon Quest'.",
      2004,
      new String[]{"18", "279", "193", "118", "50"}
    ),
    new BubbleFixedFrame(
      "2005: The return of handhelds",
      "Nintendo releases the DS. Sporting a touch interface, it introduces a " +
      "series of non-traditional games, such as 'Brain Training' and 'Nintendogs', " +
      "that attract a wider and more varied audience than before.",
      2005,
      new String[]{"11", "20", "29", "12", "46"}
    ),
    new BubbleFixedFrame(
      "2006: Nintendo surges forward",
      "Encouraged by the success of the DS, Nintendo next releases " +
      "the Wii. A breakthrough in motion sensing technology, the Wii remote " +
      "provided another highly accessible interface for non-traditional " +
      "gamers, supported by classics like 'Wii Sports' and 'Wii Play'.",
      2006,
      new String[]{"1", "8"}
    ),
    new BubbleUpdateFrame(
      "2007: Console power struggles",
      "In this era, every major console, as with the Wii, had their own " +
      "major breakthroughs. The Xbox 360, released in late-2005, boasted full HD " +
      "graphics, while the PlayStation 3, released in late-2006, incorporated " +
      "Blu-ray technology. Coupled with many blockbuster releases, 2007 was " +
      "was one of the most competitive years for consoles.",
      2007
    ),
    new BubbleUpdateFrame(
      "2009: From strength to strength",
      "2 years later, the console market continues to show strong performances " +
      "by all major players.",
      2009
    ),
    new BubbleUpdateFrame(
      "2010: A declining market",
      "Despite historic highs in 2008-9, the console market starts to decline " +
      "in 2010...",
      2010
    ),
    new BubbleUpdateFrame(
      "",
      "...all the way to 2012, when the market shrinks to nearly the same size " +
      "it was in 2001.",
      2012
    ),
    new BubbleUpdateFrame(
      "2013: A new hope?",
      "The simultaneous release of the Xbox One and PlayStation 4 revitalizes " +
      "the market...",
      2013
    ),
    new BubbleUpdateFrame(
      "",
      "...but only temporarily. By 2016, the console market is only 61% of what " +
      "it was 3 years ago.",
      2016
    ),
    new LineUpdateFrame(
      "Physical console game revenues falling",
      "For several years now, sales have slowly declined for physical console " +
      "games. Where is all the money going? Is gaming simply dying?",
      new String[]{"MMO", "Mobile"}
    ),
    new LineUpdateFrame(
      "PC MMO revenues rising",
      "As graphical and network technologies have improved, massively multiplayer " +
      "online games, typically played on PC, have become increasingly popular. " +
      "Though consoles can support some of these games, PC's support for them is " +
      "significantly more robust.",
      new String[]{"Mobile"}
    ),
    new LineUpdateFrame(
      "But mobile's where it's at!",
      "Remember the DS and Wii? Accessibility is key. As smartphones have become " +
      "more powerful and ubiquitous, mobile gaming revenue has shot up dramatically.",
      new String[]{}
    )
  };
}

class Intro extends Frame {
  public Intro() {
    this.title = "The Evolution of Gaming Consoles Since 1980";
    this.text = "Gaming has come a long way, evolving from a niche hobby enjoyed by a " +
      "select few, to a multimillion dollar industry with widespread acceptance. " +
      "That journey has correspondingly seen the concurrent evolution of the " +
      "game console. How have they changed? Where are they going? Scroll down " +
      "to find out!";
  }

  public Chart transition(Chart chart) {
    String[] yearStrs = new String[platformYears.size()];
    for (int i = 0; i < platformYears.size(); i++) yearStrs[i] = String.valueOf(platformYears.get(i));
    StackedBarChart sbchart = new StackedBarChart(
      platformsByYears,
      "year", yearStrs,
      "physical_sales", platformStrs,
      platforms
    );
    return sbchart;
  }
  
  public void drawLegend(float x, float y, float w, float h) {
  }
}

class BubbleUpdateFrame extends Frame {
  private int year;
  
  public BubbleUpdateFrame(String title, String text, int year) {
    this.title = title;
    this.text = text;
    this.year = year;
  }
  
  public Chart transition(Chart chart) {
    Table tbl = platformsForYears.get(this.year);
    if (chart.getClass() == BubbleChart.class) {
      ((BubbleChart)chart).unfixNodes();
      ((BubbleChart)chart).updateNodes(tbl);
      return chart;
    } else {
      return new BubbleChart(tbl, "id", "platform", platformStrs, "sales", platforms); 
    }
  }
  
  public void drawLegend(float x, float y, float w, float h) {
    float r = 10; // hacky hard code
    stroke(0);
    
    // legend left title
    textFont(createFont(MAIN_FONT + " Bold", FONT_SIZE * 1.5));
    textAlign(LEFT, TOP);
    fill(0);
    text("Platforms", x, y + 5);
    
    // legend colors and tags
    float sectX = x, sectW = w / (platforms.size() * 1.8);
    float sectY = y + (h - FONT_SIZE * 1.5 + TEXT_GAP) / 2 + r;
    textFont(createFont(MAIN_FONT, FONT_SIZE));
    textAlign(CENTER, TOP);
    
    for (String p : platforms.keySet()) {
      // color circle
      fill(platforms.get(p));
      ellipse(sectX + sectW / 2, sectY, r*2, r*2);
      // text
      fill(0);
      text(p, sectX + sectW / 2, sectY + r + TEXT_GAP);
      sectX += sectW;
    }
    
    // seperating
    line(x, y + h, x + w, y + h); // horizontal
    line(sectX, y, sectX, y + h); // vertical
    
    // other info
    fill(255);
    ellipse(sectX + 20 + r, y + 20 + r, r*2, r*2);
    fill(0);
    textAlign(LEFT, TOP);
    float textX = sectX + 20 + TEXT_GAP + r*2;
    text(
      " is one game for one platform, in millions of total physical units sold",
      sectX + 20 + TEXT_GAP + r*2, y + 20,
      w - textX + x, h
    );
  }
}

class BubbleFixedFrame extends BubbleUpdateFrame {
  private String[] fixed;
  
  public BubbleFixedFrame(String title, String text, int year, String[] fixed) {
    super(title, text, year);
    this.fixed = fixed;
  }
  
  public Chart transition(Chart chart) {
    BubbleChart bchart = (BubbleChart)super.transition(chart);
    bchart.fixNodes(fixed);
    return bchart;
  }
}

class LineUpdateFrame extends Frame {
  private String[] hidden;
  
  public LineUpdateFrame(String title, String text, String[] hidden) {
    this.title = title;
    this.text = text;
    this.hidden = hidden;
  }
  
  public Chart transition(Chart chart) {
    LineChart lchart = null;
    
    if (chart.getClass() == LineChart.class) {
      lchart = (LineChart)chart;
      lchart.clearHidden();
    } else {
      String[] yearStrs = new String[revenueYears.size()];
      for (int i = 0; i < revenueYears.size(); i++) yearStrs[i] = String.valueOf(revenueYears.get(i));
      lchart = new LineChart(
        rev,
        "year", yearStrs,
        "revenue, billions of USD", revenueStrs,
        revenues
      );
    }
    
    for (String lbl : this.hidden) lchart.addHidden(lbl);
    
    return lchart;
  }
  
  public void drawLegend(float x, float y, float w, float h) {
    float r = 15; // hacky hard code
    stroke(0);
    
    // legend left title
    textFont(createFont(MAIN_FONT + " Bold", FONT_SIZE * 1.5));
    textAlign(LEFT, TOP);
    fill(0);
    text("Revenues", x, y + 5);
    
    // legend colors and tags
    HashMap<String, Integer> hiddenSet = new HashMap<String, Integer>(); // int is dummy
    for (String s : this.hidden) hiddenSet.put(s, 0); 
    
    float sectX = x, sectW = w / (revenues.size() - hiddenSet.size());
    float sectY = y + (h - FONT_SIZE * 1.5 + TEXT_GAP) / 2 + r;
    textFont(createFont(MAIN_FONT, FONT_SIZE * 1.2));
    textAlign(LEFT, CENTER);   
    
    for (String rev : revenues.keySet()) {
      if (hiddenSet.containsKey(rev)) continue;
      float lineW = r*2 + TEXT_GAP + textWidth(rev);
      // color circle
      fill(revenues.get(rev));
      ellipse(sectX + (sectW - lineW) / 2 + r, sectY, r*2, r*2);
      // text
      fill(0);
      text(rev, sectX + (sectW - lineW) / 2 + r*2 + TEXT_GAP, sectY);
      sectX += sectW;
    }
    
    // separating
    line(x, y + h, x + w, y + h); // horizontal
  }
}