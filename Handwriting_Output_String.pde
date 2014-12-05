/*Kevin Hou - created 10/6/14
 
 Computational Design!
 
 Title: Handwriting Font App
 Imagined, Designed, and Programmed by: Kevin Hou
 Date: October 30, 2014
 
 Description: This app allows you to input your handwriting and type in it. It returns
 a pdf vector file that you can then print on the watercolor bot. There is a typing interface
 built into the app.
 
 Sources of ideas and inspiration:
 * Similar idea to what was seen in Her: http://en.wikipedia.org/wiki/Her_(film)
 * Microsoft office word typing interface
 
 Includes code from:
 * Adding sliders and buttons for control P5 using the format from the PomPom maker
 
 Added More Code on October 23
 *Apostrophe
 
 */
//Rearchitectured version of Handwriting_Output_List_With_Capitals
//Uses strings to keep track of the key inputs (for backspace purposes)

//ControlP5 Libraries
import controlP5.*;
import processing.pdf.*;
ControlP5 cp5;

//Canvas setup
int canvasWidth = width-200;
int canvasHeight = height-200;
int inputCanvasWidth = 100;
int inputCanvasHeight = 100;

//Letters
char[] letters = {
  'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
}; //With capitals
String[] capital = {
  "Lowercase", "Capital"
}; //Lowercase or uppercase
PShape[] letterShapes = new PShape[letters.length];
int letter = 0;
int letterWidth[] = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}; //52 values
int letterHeight[] = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}; //52 values
int letterSmallestX[] = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}; //52 values
int letterLargestX[] = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}; //52 values
int letterSmallestY[] = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}; //52 values
int letterLargestY[] = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}; //52 values
int smallestX = 100;
int largestX = 0;
int smallestY = 100;
int largestY = 0;

//Booleans
Boolean typing = false;
Boolean export = false;

//File input
 String filePath = "Handwriting_Input_List_With_Capitals/" /*application.macosx/"*/;
int numOfPoints = 0;

//Button variables
int unitButtonX = (width-20)/20;
int unitButtonY = (width-20)/40;

void setup()
{
  size(displayWidth-200, displayHeight - 200, P2D); //Set size of canvas - P2D used for PShapes
  setupFonts();
  background(255); //Background is white
  cp5 = new ControlP5(this); //Create a ContorlP5 object to draw sliders and buttons
}

void draw()
{
  nameInput();
  if (!export)
  {
    createPShapes();
    returnLetters();
  }
  if (export)
  {
    exportPDF();
  }
}

//General functions

void keyReleased()
{
  typing = false;
  preventRepeat = false;
}

void setupFonts()
{
  welcomeTitleFont = createFont("Waltograph", 70, true); //Set font for welcome title
  defaultFont = createFont("Waltograph", 50, true); //Set font for basic text
  nameInputFont = createFont("Delevane", 70, true); //Set font for name input
  percentageFont = createFont("Herculanum", 70, true); //Set font for percentage
  UIFont = createFont("Helvetica Neue", 16, true); //Set font for user interface
  exportFont = createFont("Papyrus", 40, true); //Set font for PDF export
}

//Buttons and their functions
void addButtonsAndSliders() //Add buttons and sliders
{
  println("Added buttons and sliders"); //Debugging
  fill(0, 0, 255);
  cp5.addButton("clearScreen") //Clear screen button
      .setBroadcast(false)
      .setPosition(10, 10)
        .setSize(((width-20)/40), ((width-20)/40))
          .setLabel("Clear")
            .setBroadcast(true)
              .getCaptionLabel().setFont(createFont("Arial", 10)).toUpperCase(false).align(CENTER, CENTER)
                ;

  cp5.addButton("exitProgram") //Clear screen button
      .setBroadcast(false)
      .setPosition(width - 10 - ((width-20)/20), 10)
        .setSize(((width-20)/20), ((width-20)/40))
          .setLabel("Exit")
            .setBroadcast(true)
              .getCaptionLabel().setFont(createFont("Arial", 10)).toUpperCase(false).align(CENTER, CENTER)
                ;

  cp5.addButton("exportPDFButton") //Clear screen button
      .setBroadcast(false)
      .setPosition(width - 20 - (2 * (width-20)/20), 10)
        .setSize(((width-20)/20), ((width-20)/40))
          .setLabel("Export")
            .setBroadcast(true)
              .getCaptionLabel().setFont(createFont("Arial", 10)).toUpperCase(false).align(CENTER, CENTER)
                ;

  cp5.addButton("black") //Clear screen button
      .setBroadcast(false)
      .setPosition(20 + (((width-20)/20)), 10)
        .setSize(((width-20)/20), ((width-20)/40))
          .setLabel("Black")
            .setBroadcast(true)
              .getCaptionLabel().setFont(createFont("Arial", 10)).toUpperCase(false).align(CENTER, CENTER)
                ;

  cp5.addButton("red") //Clear screen button
      .setBroadcast(false)
      .setPosition(30 + (2*((width-20)/20)), 10)
        .setSize(((width-20)/20), ((width-20)/40))
          .setLabel("Red")
            .setBroadcast(true)
              .getCaptionLabel().setFont(createFont("Arial", 10)).toUpperCase(false).align(CENTER, CENTER)
                ;

  cp5.addButton("fontSizeUp") //Clear screen button
      .setBroadcast(false)
      .setPosition(40 + (3*((width-20)/20)), 10)
        .setSize(((width-20)/40), ((width-20)/40))
          .setLabel("+")
            .setBroadcast(true)
              .getCaptionLabel().setFont(createFont("Arial", 10)).toUpperCase(false).align(CENTER, CENTER)
                ;

  cp5.addButton("fontSizeDown") //Clear screen button
      .setBroadcast(false)
      .setPosition(50 + (7*((width-20)/40)), 10)
        .setSize(((width-20)/40), ((width-20)/40))
          .setLabel("-")
            .setBroadcast(true)
              .getCaptionLabel().setFont(createFont("Arial", 10)).toUpperCase(false).align(CENTER, CENTER)
                ;
}

void clearScreen()
{
  background(backgroundColor); //Clear screen
  xPosition = resetX; //Reset xPosition
  lineNumber = 1; //Reset line number
  document = ""; //Reset document
  referenceLines(); //Draw reference lines again
}

void exitProgram()
{
  println("Thanks you for using the Handwriting Font App"); //Feedback
  exit(); //Exit
}

void fontSizeUp()
{
  fontSize = fontSize + 1.0; //Increase font size
  println("Font size is now: " + int(fontSize)); //User feedback
  background(255); //Clear/refresh screen
  referenceLines(); //Add lines again
}

void fontSizeDown()
{
  fontSize = fontSize - 1.0; //Decrease font size
  println("Font size is now: " + int(fontSize)); //User feedback
  background(255); //Clear/refresh screen
  referenceLines(); //Add lines again
}

void exportPDFButton()
{
  export = true;
}

void exportPDF() //Export file for watercolor bot
{
  background(255); //Clear screen
  fileNameInput(); //Run file name input function
  if (fileName == "Cancel" || fileName == "CANCEL" || fileName == "cancel")
  {
    recordingCondition = false;
    export = false;
  }
  if (recordingCondition == true)
  {
    beginRecord(PDF, fileName + ".pdf");
    typeLetters(); //Interpret the document string
    printShapes(); //Print shapes
    endRecord(); //Finish recording
    println("File saved as: " + fileName + ".pdf");
    export = false; //Reset
    referenceLines();
    recordingCondition = false; //Reset
    inputFileName = false; //Reset
    fileName = ""; //Reset file name
    incompleteFileName = ""; //Reset incomplete file name
  }
}

