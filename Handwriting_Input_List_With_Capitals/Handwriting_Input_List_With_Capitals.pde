//Kevin Hou Handwriting Font Program
//Help of Natalie Freed
import controlP5.*; //Import libraries
import processing.pdf.*;

//General variables
boolean mouseClicked = false;
int canvasWidth = 100;
int canvasHeight = 100;
int strokeWeight = 4; //Stroke weight 
char inputKey = 'a';

//Letters
char[] letters = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
String[] capital = {"Lowercase", "Capital"};
int i = 0;

//Booleans
boolean allowRecord = true;
boolean saveButtonPressed = false;
boolean collectLetters = true; //allow collection of writing until after letter z
boolean firstTime = true; //for adding Continue to Writing Buttons
boolean collectCapital = false; //For capital letters

//User
PrintWriter output;

//******************************************************************

void setup()
{
  setupCanvas();
  welcomeInstructions();
  setupFonts(); //Inititate fonts
}

void draw()
{
  nameInput(); //User's name input
  if (inputName) //If finished inputing name
  {
    checkLetter(); //check to see if collected last letter
    if (collectLetters) //make sure won't exceed array length
    {
      traceMouse();
    }
  }
}

//******************************************************************

void traceMouse()
{
  if (allowRecord) //if not recording
  {
    beginRecord();
    allowRecord = false; //now recording
  }
  if (mouseClicked == true && mouseButton != RIGHT) //If mouse is clicked and is not the right click carried over
  {
    line (pmouseX, pmouseY, mouseX, mouseY); //draw line
    if (mouseX != pmouseX || mouseY != pmouseY)
    {
      output.println(mouseX + "," + mouseY);
    }
  }
  exportKey(); //end recording if right click
}

void beginRecord() //begin recording
{
  line(10, (4*canvasHeight)/7, canvasWidth-10, (4*canvasHeight)/7); //Reference line, must go before beginRecord
  beginRecord(PDF, name + "MouseDrawing" + capitalOrLowercase(i) + letters[i] + ".pdf"); //name PDF
  println("Begin recording of: " + capitalOrLowercase(i) + letters[i]); //feedback
  output = createWriter(name + capitalOrLowercase(i) + letters[i] + ".txt"); //Name letter specific file
}

void exportKey()
{
  if (!allowRecord) //if recording
  {
    if (saveButtonPressed) //if save button pressed
    {
      println("Right click"); //feedback
      endRecord(); //finish recording
      output.flush(); //finish writing file
      output.close(); //finish file
      println("Saved recording of letter: " + letters[i]);
      println("PDF file: " + name + "MouseDrawing" + capitalOrLowercase(i) + letters[i] + ".pdf");
      println("TXT file: " + name + capitalOrLowercase(i) + letters[i] + ".pdf");
      background(255); //clear screen
      if (!allowRecord)
      {
        i++; //next letter
        saveButtonPressed = false;
      }
      allowRecord = true;
    }
  }
}
      
void welcomeInstructions()
{
  println("Drag mouse to record letter within square");
  println("Right click to save the current letter");
  println("Make sure you draw the entire letter in one click/drag");
}

void checkLetter()
{
  if (i >= 26)
  {
    if (collectLetters & !collectCapital)
    {
      println("Finished collecting all lowercase letters");
      collectCapital = true; //Now collect capital letters     
    }
  }
  if (i >= 52)
  {
    if (collectLetters & collectCapital)
    {
      println("Finished collecting all capital letters");
      println("Finsihed collecting all letters");
      exit();
      collectCapital = false;
    }
    collectLetters = false;
  }
}

void mouseClicked() //mouse is clicked
{
  if (mouseButton == RIGHT && mouseButton != LEFT); //button clicked is right click
  {
    saveButtonPressed = true;
  }
}

void mouseReleased() //button is released after being clicked
{
  if (mouseButton != LEFT); //button clicked is not the left
  {
    saveButtonPressed = false;
  }
}

void mouseDragged()
{
  mouseClicked = true; //Allow drawing input
}

void mouseMoved()
{
  mouseClicked = false; //Prevent drawing input
}

void setupCanvas()
{
  size (canvasWidth, canvasHeight, P2D);
  background (255);
  fill (0);
  strokeWeight(strokeWeight);
}

String capitalOrLowercase(int val) //Return capital or lowercase
{
  if (val >= 0 & val < 26)
  {
    return capital[0];
  }
  if (val >= 26)
  {
    return capital[1];
  }
  else
  {
    return "";
  }
}

void setupFonts()
{
  defaultFont = createFont("Marker Felt", 22, true); //Set font for basic text
  nameInputFont = createFont("Delevane", 30, true); //Set font for name input
}
