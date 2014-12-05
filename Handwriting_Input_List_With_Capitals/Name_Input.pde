//For allowing the user to input his/her name

//Variables for solely name input
String name = "";
boolean inputName = false;
String incompleteName = "";
PFont defaultFont;
PFont nameInputFont;
PFont welcomeTitleFont;
boolean typing;

void nameInput() //User's name
{
  int x = width/4;
  int y = height/2;
  if (!inputName & keyPressed & !typing)
  {
    typing = true;
    if (key == RETURN || key == ENTER)
    {
      name = incompleteName;
      inputName = true;
      println("");
      println("Welcome " + name); //Feedback
      background(255); //Clear screen
      redraw();
    }
    if (key == BACKSPACE & typing)
    {
      if (incompleteName.length() > 0)
      {
        incompleteName = incompleteName.substring(0, incompleteName.length() - 1); //Delete last character
        fill(0); //Change background to black
        rect(x, y-25, x, 25); //Overwrite
        fill(255); //Change back to white for redraw
        background(255);
        redraw(); //Restart the draw function
      }
    }
    if (Character.isLetterOrDigit(key))
    {
      incompleteName = incompleteName + key;
      print(key); //Feedback
    }
  }
  if (!inputName) //Remove text after finished inputting
  {
    fill(0); //Change letters to black
    stroke(0);
//    stroke(0, 85, 255);
    strokeWeight(4);
    line(0, y + 30, width, y + 30); //For UI
    textFont(defaultFont);
    text("Type name", 5, y-15);
    fill(255, 0, 0);
    textFont(nameInputFont);
    text(incompleteName, 10, y+30);
  }
}

void keyReleased()
{
  typing = false;
}
