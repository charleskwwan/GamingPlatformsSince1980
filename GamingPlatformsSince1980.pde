final int displayWidth = 1200, displayHeight = 800;
final int HPADDING = 100;
final int SCROLL_SPEED = 20;
final String MAIN_FONT = "Arial";
final int FONT_SIZE = 12;
final int TEXT_GAP = 5;
final int TICK_LEN = 5;

// info about tables
// platform
IntList platformYears = years(1980, 2017);
HashMap<String, Integer> platforms = platforms(); // platform, color
HashMap<String, String> platformsMap = groupPlatforms();
String[] platformStrs = platforms.keySet().toArray(new String[platforms.keySet().size()]);
// revenue
IntList revenueYears = years(2013, 2017);
HashMap<String, Integer> revenues = revenues(); // revenue src, color
String[] revenueStrs = revenues.keySet().toArray(new String[revenues.keySet().size()]);

// tables
Table raw, rev;
Table platformsByYears;
HashMap<Integer, Table> platformsForYears;
ScrollLayout layout = null;

// misc
Tooltips tooltips = null;

Slider slider;

void setup() {
  size(displayWidth, displayHeight);
  pixelDensity(2);
  raw = loadTable("data.csv", "header,csv");
  rev = loadTable("rev.csv", "header,csv");
  platformsByYears = platformsByYears(raw);
  platformsForYears = new HashMap<Integer, Table>();
  for (int year : platformYears) platformsForYears.put(year, platformsForYear(raw, year));
  
  Frame[] frames = makeFrames();
  layout = new ScrollLayout(HPADDING, 0, displayWidth - 2 * HPADDING, displayHeight, frames);
  
  tooltips = new Tooltips();
}

void draw() {
  background(255);
  mouseOver();
  TransitionValues.tick();
  if (layout != null) layout.draw();
  if (tooltips != null) tooltips.draw();
}

/* mouse interactions*/
void mouseOver() {
  layout.onOver();
}

void mousePressed(){
   if(layout != null){
      if(layout.lastFrame){
          layout.slider.onPress();
      }
   }
}

void mouseDragged(){
   if(layout != null){
      if(layout.lastFrame){
          layout.slider.onDrag();
      }
   }
}

void mouseReleased(){
   if(layout != null){
      if(layout.lastFrame){
          layout.slider.onRelease();
      }
   }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e > 0) {
    layout.onScrollDown();
  } else if (e < 0) {
    layout.onScrollUp();
  }
}

/* table functions */
Table platformsByYears(Table raw) {
  Table tbl = new Table();
  // columns
  tbl.addColumn("year");
  for (String platform : platforms.keySet()) tbl.addColumn(platform);
  // initialize rows
  for (int year : platformYears) {
    TableRow newRow = tbl.addRow();
    newRow.setInt("year", year);
    for (String platform : platforms.keySet()) newRow.setFloat(platform, 0);
  }
  // accumulate sales
  for (TableRow rawRow : raw.rows()) {
    int year = rawRow.getInt("year");
    TableRow tblRow = tbl.findRow(String.valueOf(year), "year");
    if (tblRow == null) continue; // invalid year, skip
    String platform = rawRow.getString("platform");
    if (!platformsMap.containsKey(platform)) continue; // ignored platform, skip
    platform = platformsMap.get(platform);
    Float sales = rawRow.getFloat("physical_sales");
    tblRow.setFloat(platform, tblRow.getFloat(platform) + sales);
  }
  
  return tbl;
}

Table platformsForYear(Table raw, int year) {
  Table tbl = new Table();
  // columns
  for (String col : new String[]{"id", "name", "genre", "year", "platform", "sales"})
    tbl.addColumn(col);
  // convert
  for (TableRow rawRow : raw.findRows(String.valueOf(year), "year")) {
    TableRow tblRow = tbl.addRow();
    for (String col : new String[]{"name", "genre"}) // strings
      tblRow.setString(col, rawRow.getString(col));
    for (String col : new String[]{"id", "year"}) // ints
      tblRow.setInt(col, rawRow.getInt(col));
    tblRow.setString("platform", platformsMap.get(rawRow.getString("platform")));
    tblRow.setFloat("sales", rawRow.getFloat("physical_sales"));
  }
  
  return tbl;
}

Table tableForPlatforms(Table raw, String[] platforms) {
  Table tbl = new Table();
  // columns
  for (String col : new String[]{"id", "name", "genre", "year", "platform", "sales"})
    tbl.addColumn(col);
  // convert
  for(String p : platforms){
      for (TableRow rawRow : raw.findRows(p, "platform")) {
    TableRow tblRow = tbl.addRow();
    for (String col : new String[]{"name", "genre"}) // strings
      tblRow.setString(col, rawRow.getString(col));
    for (String col : new String[]{"id", "year"}) // ints
      tblRow.setInt(col, rawRow.getInt(col));
    tblRow.setString("platform", platformsMap.get(rawRow.getString("platform")));
    //tblRow.setFloat("sales", rawRow.getFloat("physical_sales"));
  }
  }
  
  return tbl;
}

Table platformsYearToTable(Table src, int year) {
  Table tbl = new Table();
  // add columns
  tbl.addColumn("platform");
  tbl.addColumn("sales");
  // create rows
  TableRow srcRow = src.findRow(String.valueOf(year), "year");
  for (String platform : platforms.keySet()) {
    TableRow newRow = tbl.addRow();
    newRow.setString("platform", platform);
    newRow.setFloat("sales", srcRow.getFloat(platform));
  }
  
  return tbl;
}

/* button functions */
void mouseClicked(){
  //Use list of buttons in ScrollLayout
  if(layout != null){
     //go through list of buttons to check if clicking on buttos
     for(Button b : layout.buttons){
         b.onClick();
     }
  }
}

/* INITIALIZERS, HARDCODED */
IntList years(int lo, int hi) {
  IntList lst = new IntList();
  for (int i = lo; i <= hi; i++) lst.append(i);
  return lst;
}

HashMap<String, Integer> platforms() {
  HashMap<String, Integer> map = new HashMap<String, Integer>();
  map.put("Handheld", color(0,204,0));
  map.put("Nintendo", color(0,153,255));
  map.put("PlayStation", color(204,0,0));
  map.put("Xbox", color(255,255,0));
  map.put("Sega", color(255,102,0));
  map.put("Atari", color(153,51,204));
  return map;
}

HashMap<String, Integer> revenues() {
  HashMap<String, Integer> map = new HashMap<String, Integer>();
  map.put("Console", color(255,140,0));
  map.put("MMO", color(255,223,0));
  map.put("Mobile", color(139,69,19));
  return map;
}

HashMap<String, String> groupPlatforms() {
  HashMap<String, String> map = new HashMap<String, String>();
  // handheld
  map.put("PSP", "Handheld");
  map.put("PSV", "Handheld");
  map.put("3DS", "Handheld");
  map.put("DS", "Handheld");
  map.put("GB", "Handheld");
  map.put("GBA", "Handheld");
  map.put("NS", "Handheld");
  // nintendo
  map.put("Wii", "Nintendo");
  map.put("WiiU", "Nintendo");
  map.put("GC", "Nintendo");
  map.put("NES", "Nintendo");
  map.put("SNES", "Nintendo");
  map.put("N64", "Nintendo");
  // playstation
  map.put("PS", "PlayStation");
  map.put("PS2", "PlayStation");
  map.put("PS3", "PlayStation");
  map.put("PS4", "PlayStation");
  // xbox
  map.put("XB", "Xbox");
  map.put("X360", "Xbox");
  map.put("XOne", "Xbox");
  // sega
  map.put("GEN", "Sega");
  map.put("SAT", "Sega");
  map.put("DC", "Sega");
  map.put("SCD", "Sega");
  // atari
  map.put("2600", "Atari");
  map.put("7800", "Atari");
  
  return map;
}