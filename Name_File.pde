//For allowing the user to name their file

//Variables for solely file name input
String fileName = "";
boolean inputFileName = false;
String incompleteFileName = "";
PFont exportFont;
boolean recordingCondition = false;

void fileNameInput() //User's name
{
  int x = width/4;
  int y = height/2;
  if (!inputFileName & keyPressed & !typing)
  {
    typing = true;
    if (key == RETURN || key == ENTER)
    {
      fileName = incompleteFileName;
      inputFileName = true;
      recordingCondition = true;
      println("File will be name: " + fileName); //Feedback
      background(255); //Clear screen
      redraw();
    }
    if (key == BACKSPACE & typing)
    {
      if (incompleteFileName.length() > 0)
      {
        incompleteFileName = incompleteFileName.substring(0, incompleteFileName.length() - 1); //Delete last character
        fill(0); //Change background to black
        rect(x, y-25, x, 25); //Overwrite
        fill(255); //Change back to white for redraw
        background(255);
        redraw(); //Restart the draw function
      }
    }
    if (Character.isLetterOrDigit(key))
    {
      incompleteFileName = incompleteFileName + key;
    }
  }
  if (!inputFileName) //Remove text after finished inputting
  {
    fill(0); //Change letters to black
    stroke(0);
    //    stroke(0, 85, 255);
    strokeWeight(4);
    line(x, y + 100, x + 500, y + 100); //For UI
    //    fill(0, 85, 255);
    textFont(exportFont);
    text("Export 'Handwritten' Note to Watercolor Bot", x-80, 200); //Welcome Screen
    textFont(exportFont);
    text("Type your file name and press enter to save", x-80, y);
    fill(255, 0, 0);
    textFont(nameInputFont);
    text(incompleteFileName, x + 50, y + 100);
  }
}

