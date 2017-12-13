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
    new BubbleUpdateFrame(
      "2004: The peak of the Playstation 2",
      "Released in 2000, the PlayStation 2 is the most popular console " +
      "of all time, supported by a library of popular and exclusive game " +
      "franchises, such as 'Grand Theft Auto', 'Meta Gear Solid', and " +
      "'Dragon Quest'.",
      2004
    ),
    new BubbleUpdateFrame(
      "2005: The return of handhelds",
      "Nintendo releases the DS. Sporting a touch interface, it introduces a " +
      "series of non-traditional games, such as 'Brain Training' and 'Nintendogs', " +
      "that attract a wider and more varied audience than before.",
      2005
    ),
    new BubbleUpdateFrame(
      "2006: Nintendo surges forward",
      "Encouraged by the success of the DS, Nintendo next releases " +
      "the Wii. A breakthrough in motion sensing technology, the Wii remote " +
      "provided another highly accessible interface for non-traditional " +
      "gamers, supported by classics like 'Wii Sports' and 'Wii Play'.",
      2006
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
      "2 years later, the console market continued to show strong performances " +
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
    String[] yearStrs = new String[years.size()];
    for (int i = 0; i < years.size(); i++) yearStrs[i] = String.valueOf(years.get(i));
    StackedBarChart sbchart = new StackedBarChart(platformsByYears, "year", yearStrs, "physical_sales", platformStrs, platforms);
    return sbchart;
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
      ((BubbleChart)chart).updateNodes(tbl);
      return chart;
    } else {
      return new BubbleChart(tbl, "platform", platformStrs, "sales", platforms); 
    }
  }
}

class Frame11 extends Frame {
  public Frame11() {
    this.title = "2013: A new hope?";
    this.text = "The simultaneous release of the Xbox One and PlayStation 4 revitalizes " +
                "the market...";
  }

  public Chart transition(Chart chart) {
    BubbleChart bchart = new BubbleChart(platformsForYears.get(2013), "platform", platformStrs, "sales", platforms);
    return bchart;
  }
}