final int displayWidth = 1200, displayHeight = 800;
final int HPADDING = 100;
final int SCROLL_SPEED = 20;
final String MAIN_FONT = "Arial";
final int FONT_SIZE = 12;
final int TEXT_GAP = 5;
final int TICK_LEN = 5;

// info about tables
IntList years = years();
HashMap<String, Integer> platforms = platforms(); // platform, color
HashMap<String, String> platformsMap = groupPlatforms();
String[] platformStrs = platforms.keySet().toArray(new String[platforms.keySet().size()]);

// tables
Table raw;
Table platformsByYears;
HashMap<Integer, Table> platformsForYears;
ScrollLayout layout = null;

// misc
Tooltips tooltips = null;

void setup() {
  size(displayWidth, displayHeight);
  
  raw = loadTable("data.csv", "header,csv");
  platformsByYears = platformsByYears(raw);
  platformsForYears = new HashMap<Integer, Table>();
  for (int year : years) platformsForYears.put(year, platformsForYear(raw, year));
  
  Frame[] frames = makeFrames();
  layout = new ScrollLayout(HPADDING, 0, displayWidth - 2 * HPADDING, displayHeight, frames);
  
  tooltips = new Tooltips();
}

void draw() {
  background(255);
  mouseOver();
  if (layout != null) layout.draw();
  if (tooltips != null) tooltips.draw();  
}

/* mouse interactions*/
void mouseOver() {
  layout.onOver();
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
  for (int year : years) {
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
  for (String col : new String[]{"name", "genre", "year", "platform", "sales"})
    tbl.addColumn(col);
  // convert
  for (TableRow rawRow : raw.findRows(String.valueOf(year), "year")) {
    TableRow tblRow = tbl.addRow();
    for (String col : new String[]{"name", "genre"})
      tblRow.setString(col, rawRow.getString(col));
    tblRow.setString("platform", platformsMap.get(rawRow.getString("platform")));
    tblRow.setInt("year", rawRow.getInt("year"));
    tblRow.setFloat("sales", rawRow.getFloat("physical_sales"));
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

/* INITIALIZERS, HARDCODED */
IntList years() {
  IntList lst = new IntList();
  for (int i = 1980; i <= 2017; i++) lst.append(i);
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