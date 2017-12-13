public Frame[] makeFrames(Table raw) {
  return new Frame[]{
    new Intro(raw), 
    new Frame0(raw), 
    new Frame1(raw),
    new Frame2(raw),
    new Frame3(raw),
    new Frame4(raw),
    new Frame5(raw),
    new Frame6(raw),
    new Frame7(raw),
    new Frame8(raw),
    new Frame9(raw),
    new Frame10(raw)
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
    BubbleChart bchart = new BubbleChart(platformsForYears.get(2008), "platform", platformStrs, "sales", platforms);
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

class Frame2 extends Frame {
  public Frame2(Table raw) {
    super(raw);
    this.title = "1995: Playstation dominates the market with superior hardware";
    this.text =  "After 9 and half years after launch in 1995, the PlayStation, developed by Sony Computer Entertainment, became the first video game console to ship 100 million units.";
  }

  public Chart transition(Chart chart) {
    //5 years after PS1 was released, giving more data to show about its dominance in the market
    BubbleChart bchart = new BubbleChart(platformsForYears.get(1995), "platform", platformStrs, "sales", platforms);
    return bchart;
  }
}

class Frame3 extends Frame {
  public Frame3(Table raw) {
    super(raw);
    this.title = "2000: Microsoft's Xbox was introduced";
    this.text = "The Xbox was released in 2000, but the PlayStation's dominance expands";
  }

  public Chart transition(Chart chart) {
    //4 years after PS2 was released, giving more data to show about its dominance in the market
    BubbleChart bchart = new BubbleChart(platformsForYears.get(2000), "platform", platformStrs, "sales", platforms);
    return bchart;
  }
}

class Frame4 extends Frame {
  public Frame4(Table raw) {
    super(raw);
    this.title = "2004: Playstation 2 continues dominance";
    this.text = "The PlayStation 2, released in 2000, was just as dominant as it only took 6 years to ship 100 million units";
  }

  public Chart transition(Chart chart) {
    //4 years after PS2 was released, giving more data to show about its dominance in the market
    BubbleChart bchart = new BubbleChart(platformsForYears.get(2004), "platform", platformStrs, "sales", platforms);
    return bchart;
  }
}

class Frame5 extends Frame {
  public Frame5(Table raw) {
    super(raw);
    this.title = "2005: The return of handhelds";
    this.text = "The release of the Nintendo DS, with its touch-screen technology, marked the return of handheld gaming";
  }

  public Chart transition(Chart chart) {
    BubbleChart bchart = new BubbleChart(platformsForYears.get(2005), "platform", platformStrs, "sales", platforms);
    return bchart;
  }
}

class Frame6 extends Frame {
  public Frame6(Table raw) {
    super(raw);
    this.title = "2006: Nintendo surges";
    this.text = "The release of the Nintendo Wii in 2006 popularized Nintendo with its Wii remote that allowed" +
                "players to control using gestures and button presses using its accelerometer and infrared technology";
  }

  public Chart transition(Chart chart) {
    BubbleChart bchart = new BubbleChart(platformsForYears.get(2006), "platform", platformStrs, "sales", platforms);
    return bchart;
  }
}

class Frame7 extends Frame {
  public Frame7(Table raw) {
    super(raw);
    this.title = "2007: Home console power struggle";
    this.text = "The home console market shows a power struggle between the Nintendo Wii, the Microsoft Xbox360 (with Full HD games), and the Sony PlayStation 3 (with BlueRay drive).";
  }

  public Chart transition(Chart chart) {
    BubbleChart bchart = new BubbleChart(platformsForYears.get(2007), "platform", platformStrs, "sales", platforms);
    return bchart;
  }
}

class Frame8 extends Frame {
  public Frame8(Table raw) {
    super(raw);
    this.title = "2009: Video game market continues to show strong performance";
    this.text = "The market continues to grow with constructive competition between the major players of the market";
  }

  public Chart transition(Chart chart) {
    BubbleChart bchart = new BubbleChart(platformsForYears.get(2009), "platform", platformStrs, "sales", platforms);
    return bchart;
  }
}

class Frame9 extends Frame {
  public Frame9(Table raw) {
    super(raw);
    this.title = "2010-11: Begin of the decline in the video game market";
    this.text = "2010 marks the year where the general video game market showed a decline after historical performances in 08-09";
  }

  public Chart transition(Chart chart) {
    BubbleChart bchart = new BubbleChart(platformsForYears.get(2011), "platform", platformStrs, "sales", platforms);
    return bchart;
  }
}

class Frame10 extends Frame {
  public Frame10(Table raw) {
    super(raw);
    this.title = "2013: Release of Xbox One and PlayStation 4";
    this.text = "The new iterations of the two major home consoles led to a brief increase in video game sales but the market still trended downwards";
  }

  public Chart transition(Chart chart) {
    BubbleChart bchart = new BubbleChart(platformsForYears.get(2013), "platform", platformStrs, "sales", platforms);
    return bchart;
  }
}