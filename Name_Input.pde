//For allowing the user to input his/her name

//Variables for solely name input
String name = "";
boolean inputName = false;
String incompleteName = "";
PFont defaultFont;
PFont nameInputFont;
PFont welcomeTitleFont;
PFont percentageFont;

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
      println("Welcome " + name); //Feedback
      text("Welcome " + name, x, y + 40); //Feedback
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
    }
  }
  if (!inputName) //Remove text after finished inputting
  {
    fill(0); //Change letters to black
    stroke(0);
    //    stroke(0, 85, 255);
    strokeWeight(4);
    line(x, y + 100, x + 500, y + 100); //For UI
    //    fill(0, 85, 255);
    textFont(welcomeTitleFont);
    text("Welcome to the Handwriting Font App", 80, 200); //Welcome Screen
    textFont(defaultFont);
    text("Type your name and press enter to save", x-60, y);
    fill(255, 0, 0);
    textFont(nameInputFont);
    text(incompleteName, x + 50, y + 100);
  }
}

