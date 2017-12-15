public class Button {
  float x;
  float y;
  float w; 
  float h;
  float mouseposX;
  float mouseposY;
  boolean overButton; 
  boolean buttonOn = true;
  color c1 = color(0);
  color c2 = color(255);
  String title;
 
  Button(float x, float y, float w, float h, String title) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.title = title;
  }
  
  void buttonSet() {
    buttonOn = true;
  }
 
  void buttonSelect() {
    mouseposX = mouseX;
    mouseposY = mouseY;
    if (mouseposX >= x && mouseposX <= (x + w) && mouseposY >= y && mouseposY <= (y + h)) {
      overButton = true;
    } else overButton = false;
  }
 
  void onClick(){
      buttonSelect();
      if(overButton && buttonOn){
         buttonOn = false; 
      } else if (overButton && !buttonOn){
         buttonOn = true; 
      }    
  }
  
  void draw() {
    buttonSelect();
    if(overButton){
        fill(c1); 
      } else{
        fill(c2); 
      }
    color textC = color(0);
     if(buttonOn){
        fill(c1); 
        if(overButton){
          fill(c2); 
          textC = color(#696969);
        }
     } else {
        fill(c2);
        textC = color(#696969);
        if(overButton)  {
            fill(c1);
            textC = color(0);
        }
     }
    
    stroke(0);
    rect(x, y, w, h, 7);
    fill(textC);
    textAlign(CENTER);
    text(title, x + 50, y + 20);
  }
}

//public class nintendoButton extends Button{
//    nintendoButton(float x, float y, float w, float h){
//       super(x, y, w, h);
//    }
//}


//public class psButton extends Button{
//    psButton(float x, float y, float w, float h){
//       super(x, y, w, h);
//    }
//}

//public class xboxButton extends Button{
//    xboxButton(float x, float y, float w, float h){
//       super(x, y, w, h);
//    }
//}

//public class segaButton extends Button{
//    segaButton(float x, float y, float w, float h){
//       super(x, y, w, h);
//    }
//}

//public class Button extends Button{
//    segaButton(float x, float y, float w, float h){
//       super(x, y, w, h);
//    }
//}