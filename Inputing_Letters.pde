//Returning letters - the word processing aspect
char inputKey = 'a';
String document = "";
boolean preventRepeat = true;
int inputHeight = ((4*inputCanvasHeight)/7);
int inputHeightBelowLine = ((3*inputCanvasHeight)/7);
int xPosition = 10; //Starting x point
int yPosition = inputHeight + 50; //Starting y point
int resetX = 100; //For starting new lines
int leftMargin = resetX - 20; //For margin line
char nextLetter;
int lineNumber = 1;
boolean settingUp = true;
boolean print = true;
boolean donePrinting = false;
int wordLength;
int stringLength;
int startPreviousWord;
String previousWord;
int footerHeight = 20;
boolean showExample = true;
boolean quotationOrientation = false; //Start with open quote

//UI
PFont UIFont;
color backgroundColor = color(240, 231, 232); //Background color of output sheet

//Font size
float fontSize = 12;
float fontSizeMultiple = 1.0/18.0;
float scale = 1;

//Adjustable
int spaceBetweenLetters = 10;
int spaceValue = 20;
int defaultPeriod = 5;

void returnLetters()
{
  if (doneCreating)
  {
    firstTimeSetup(); //Setup canvas
    userInterface(); //UI
    typeLetters();
    printShapes();
  }
}

void firstTimeSetup()
{
  if (settingUp)
  {
    //Add functions that should only trigger once
    background(backgroundColor); //Make background gray ish
    referenceLines();
    println("About to add buttons and sliders"); //Debugging
    addButtonsAndSliders();
    displayAllLetters(); //For feedback
    settingUp = false;
  }
}

void referenceLines()
{
  strokeWeight(2); //Set stroke weight
  stroke(106, 150, 208); //Set stroke color to blue
  float multiplyer = fontSize * fontSizeMultiple;
  for (int i = inputHeight + 50; i < height - footerHeight - 10; i = i + int ( (multiplyer * inputHeight)))
  {
    line(10, i, width - 10, i); //Draw lines
  }
  stroke(255, 102, 102); //Light red
  line (leftMargin, inputHeight, leftMargin, height - footerHeight); //Left margin line
}

void userInterface()
{
  fontValue();
  documentStats();
}

void typeLetters() //Get string document
{
  if (keyPressed & !typing)
  {
    inputKey = key;
    specialKeys();
    regularKeys();
    println(document); //Debugging
  }
}

void regularKeys()
{
  if (Character.isLetterOrDigit(inputKey))
  {
    if (!showExample)
    {
      typing = true;
      document = document + key;
    } else //if showExample is true
    {
      background(backgroundColor);
      referenceLines(); //Refresh screen
      document = "";
      showExample = false;
    }
  }
}

void specialKeys()
{
  backspaceKey();
  returnKey();
  spacebar();
  periodKey();
  exclamationKey();
  colonKey();
  commaKey();
  hyphenKey();
  quotationKey();
  leftParenthesisKey();
  rightParenthesisKey();
  apostropheKey();
}

void printShapes() //Reading and interpreting string
{
  xPosition = resetX; //Reset x
  stringLength = 0; //Reset string length
  wordLength = 0; //Reset word length
  //  startPreviousWord = 0; //Reset start of previous word
  lineNumber = 1; //Reset line
  for (int i = 0; i < document.length (); i++)
  {
    nextLetter = document.charAt(i);
    readSpecialChar();
    for (int j = 0; j < 52; j++)
    {
      if (nextLetter == letters[j])
      {
        setScale(j); //Set font size
        float deltaX = xPosition - (scale * letterSmallestX[j]);
        float deltaY = yPosition - (scale * letterLargestY[j]);
        int x = 0/* xPosition - letterSmallestX[j] */; //Have very most left point at position
        int y = ((lineNumber-1) * int((fontSize * fontSizeMultiple) * inputHeight))/* + (yPosition - letterLargestY[j])*/; //Take into account which line and makes all the smallest Y values on the same line
        shape(letterShapes[j], deltaX, y + deltaY); //Add pshape
        xPosition = xPosition + int(scale * letterWidth[j]) + int(scale * spaceBetweenLetters); //Move to new position
        wordLength = wordLength + int(scale * letterWidth[j]) + int(scale * spaceBetweenLetters); //Increase width of word
        resetScale(j); //Reset font size
      }
    }
  }
  wrapText();
}

void readSpecialChar()
{
  readSpace();
  readReturn();
  readPeriod();
  readExclamation();
  readColon();
  readComma();
  readHyphen();
  readQuotation();
  readLeftParenthesis();
  readRightParenthesis();
  readApostrophe();
}

void backspaceKey() //backspace
{
  if (inputKey == BACKSPACE & !preventRepeat)
  {
    if (document.length() > 0)
    {
      document = document.substring(0, document.length() - 1); //Delete last character
      background(backgroundColor); //Clear/refresh screen
      referenceLines(); //Add lines again
      checkKeyPress();
    }
  }
}

void readSpace()
{
  if (nextLetter == ' ')
  {
    xPosition = xPosition + spaceValue;
    stringLength = stringLength + wordLength + int((fontSize * fontSizeMultiple) * spaceValue); //New total string length
    wordLength = 0; //Reset word length
  }
}

void spacebar() //spacebar
{
  if (inputKey == ' ' & !preventRepeat)
  {    
    document = document + " "; //Add space
    String[] list = split(document, " "); //Split at spaces
    println("There are " + (list.length-1) + " words"); //Feedback, subtract one to compensate and make correct
    startPreviousWord = 0;
    for (int i = 0; i < list.length-2; i++)
    {
      startPreviousWord = startPreviousWord + list[i].length() + 1;
    }
    println("Start of previous word: " + startPreviousWord); //Debuggging
    checkKeyPress();
  }
}

void readReturn() //interpret return key
{
  if (nextLetter == '~')
  {
    lineNumber = lineNumber + 1; //New line
    xPosition = resetX; //Reset x value
    stringLength = 0; //Reset string length
  }
}

void returnKey() //return key
{
  if (inputKey == RETURN || inputKey == ENTER)
  {
    if (!preventRepeat)
    {
      document = document + "~"; //Add ~ to indicate space
      println("NEW LINE"); //Feedback
      checkKeyPress();
    }
  }
}

void readPeriod()
{
  if (nextLetter == '.')
  {
    float size = ((fontSize * fontSizeMultiple) * defaultPeriod);
    int x = xPosition;
    //    println(lineNumber-1); //Debugging
    int y = ((lineNumber-1) * int((fontSize * fontSizeMultiple) * inputHeight)) + yPosition - int(size);
    fill(0);
    stroke(0);
    strokeWeight(1);
    ellipse(x, y, size, size); //Draw period
    xPosition = xPosition + int(size) + spaceBetweenLetters; //Move xPosition
  }
}

void periodKey()
{
  if (inputKey == '.' & !preventRepeat)
  {
    document = document + ".";
    checkKeyPress();
  }
}

void readExclamation()
{
  if (nextLetter == '!')
  {
    float size = ((fontSize * fontSizeMultiple) * defaultPeriod);
    int x = xPosition;
    //    println(lineNumber-1); //Debugging
    int y = ((lineNumber-1) * int((fontSize * fontSizeMultiple) * inputHeight)) + yPosition - int(size);
    fill(0);
    stroke(0);
    strokeWeight(1);
    ellipse(x, y, size, size); //Draw period
    int heightOfExclamation = int((fontSize * fontSizeMultiple) * (inputHeight-20));
    int yVertex = y - heightOfExclamation;
    triangle(x-(size/2), yVertex, x + (size/2), yVertex, x, y - 5); //Draw top part of exclamation point
    xPosition = xPosition + int(size) + spaceBetweenLetters; //Move xPosition
  }
}

void exclamationKey()
{
  if (inputKey == '!' & !preventRepeat)
  {
    document = document + "!";
    checkKeyPress();
  }
}

void readColon()
{
  if (nextLetter == ':')
  {
    float size = ((fontSize * fontSizeMultiple) * defaultPeriod);
    int x = xPosition;
    int y = ((lineNumber-1) * int((fontSize * fontSizeMultiple) * inputHeight)) + yPosition - int((fontSize * fontSizeMultiple) * (inputHeight-25));
    int spacing = int((fontSize * fontSizeMultiple) * (inputHeight-35));
    fill(0);
    stroke(0);
    strokeWeight(1);
    ellipse(x, y, size, size); //Draw higher dot
    ellipse(x, y + spacing, size, size); //Draw lower dot
    xPosition = xPosition + int(size) + spaceBetweenLetters; //Move xPosition
  }
}

void colonKey()
{
  if (inputKey == ':' & !preventRepeat)
  {
    document = document + ":";
    checkKeyPress();
  }
}

void readComma()
{
  if (nextLetter == ',')
  {
    float size = ((fontSize * fontSizeMultiple) * defaultPeriod);
    int x = xPosition;
    int y = ((lineNumber-1) * int((fontSize * fontSizeMultiple) * inputHeight)) + yPosition - int(size);
    fill(0);
    stroke(0);
    strokeWeight(1);
    ellipse(x, y, size, size); //Draw dot
    arc(x, y + (size/2), size, 3 * size, -3 * PI/4, PI/2); //Draw arc below dot
    xPosition = xPosition + int(size) + spaceBetweenLetters; //Move xPosition
  }
}

void commaKey()
{
  if (inputKey == ',' & !preventRepeat)
  {
    document = document + ",";
    checkKeyPress();
  }
}

void readHyphen()
{
  if (nextLetter == '-')
  {
    float size = ((fontSize * fontSizeMultiple) * defaultPeriod);
    int x = xPosition;
    //    println((int((fontSize * fontSizeMultiple) * inputHeight)/2));
    //    println(yPosition);
    int y = ((lineNumber-1) * int((fontSize * fontSizeMultiple) * inputHeight)) + yPosition - (int((fontSize * fontSizeMultiple) * inputHeight)/3);
    line(x, y, x + (int((fontSize * fontSizeMultiple) * inputHeight)/10), y); //Draw line for hyphen
    xPosition = xPosition + (int((fontSize * fontSizeMultiple) * inputHeight)/10) + spaceBetweenLetters; //Move curser over
  }
}

void hyphenKey()
{
  if (inputKey == '-' & !preventRepeat)
  {
    document = document + "-";
    checkKeyPress();
  }
}

void readQuotation()
{
  if (nextLetter == '"')
  {
    float size = ((fontSize * fontSizeMultiple) * defaultPeriod);
    int x = xPosition;
    int xSpacing = int((fontSize * fontSizeMultiple) * 5);
    int y = ((lineNumber-1) * int((fontSize * fontSizeMultiple) * inputHeight)) + yPosition- int((fontSize * fontSizeMultiple) * (inputHeight-20));
    if (quotationOrientation = true) //If close quote
    {
      arc(x, y, 2 * size, 5 * size, -PI/3, -PI/6); //Left quote
      arc(x + xSpacing, y, 2 * size, 5 * size, -PI/3, -PI/6); //Right quote
      quotationOrientation = false;
    } else //Open quote
    {
      arc(x, y, 2 * size, 5 * size, -PI/3, -PI/6); //Left quote
      arc(x + xSpacing, y, 2 * size, 5 * size, -2*PI/3, -5 * PI/6); //Right quote
      quotationOrientation = true;
    }
    xPosition = xPosition + xSpacing + int(4 * size); //Move curser
  }
}

void quotationKey()
{
  if (inputKey == '"' & !preventRepeat)
  {
    document = document + '"';
    checkKeyPress();
  }
}

void readApostrophe()
{
  String apostrophe = "' ";
  if (nextLetter == apostrophe.charAt(0))
  {
    float size = ((fontSize * fontSizeMultiple) * defaultPeriod);
    int x = xPosition;
    int y = ((lineNumber-1) * int((fontSize * fontSizeMultiple) * inputHeight)) + yPosition- int((fontSize * fontSizeMultiple) * (inputHeight-20));
    arc(x, y, 2 * size, 5 * size, -PI/3, -PI/6); //Left quote
    xPosition = xPosition + int(4 * size); //Move position
  }
}

void apostropheKey()
{
  String apostrophe = "' ";
  if (inputKey == apostrophe.charAt(0) & !preventRepeat)
  {
    document = document + "'";
    checkKeyPress();
  }
}

void readLeftParenthesis()
{
  if (nextLetter == '(')
  {
    int x = xPosition;
    int y = ((lineNumber-1) * int((fontSize * fontSizeMultiple) * inputHeight)) + yPosition - (int((fontSize * fontSizeMultiple) * inputHeight)/3);
    float xSize = 2 * ((fontSize * fontSizeMultiple) * defaultPeriod);
    float ySize = int(((fontSize * fontSizeMultiple) * 3 *(inputHeight-10))/4);
    noFill();
    strokeWeight(2);
    arc(x, y - 2, xSize, ySize, HALF_PI, 3 * HALF_PI);
    xPosition = xPosition + int(xSize) + 10; //Move curser over
    strokeWeight(1);
  }
}

void leftParenthesisKey()
{
  if (inputKey == '(' & !preventRepeat)
  {
    document = document + "(";
    checkKeyPress();
  }
}

void readRightParenthesis()
{
  if (nextLetter == ')')
  {
    int x = xPosition;
    int y = ((lineNumber-1) * int((fontSize * fontSizeMultiple) * inputHeight)) + yPosition - (int((fontSize * fontSizeMultiple) * inputHeight)/3);
    float xSize = 2 * ((fontSize * fontSizeMultiple) * defaultPeriod);
    float ySize = int(((fontSize * fontSizeMultiple) * 3 * (inputHeight-10))/4);
    noFill();
    strokeWeight(2);
    arc(x, y - 2, xSize, ySize, -HALF_PI, HALF_PI);
    xPosition = xPosition + int(xSize) + 10; //Move curser over
    strokeWeight(1);
  }
}

void rightParenthesisKey()
{
  if (inputKey == ')' & !preventRepeat)
  {
    document = document + ")";
    checkKeyPress();
  }
}

void checkKeyPress()
{
  if (keyPressed)
  {
    preventRepeat = true;
  }
}

void wrapText()
{
  if (stringLength > width)
  {
    if (document.charAt(document.length()-1) != '~')
    {
      //      println("Document length exceded line"); //Feedback
      //      println(stringLength); //Debugging
      previousWord = document.substring(startPreviousWord, document.length()); //Find previous word
      document = document.substring(0, startPreviousWord) + "~" + previousWord; //Add line break after last complete word
      println(document); //Feedback
      background(backgroundColor); //Clear/refresh screen
      referenceLines(); //Add lines again
      stringLength = 0; //Reset
      wordLength = 0; //Reset
      startPreviousWord = 0; //Reset
    }
  }
}

void setScale(int i)
{
  scale = fontSize * fontSizeMultiple;
  letterShapes[i].scale(scale); //Scale to new font size
}

void resetScale(int i)
{
  scale = 1/scale;
  letterShapes[i].scale(scale); //Scale back to original
}

void fontValue()
{
  fill(255); //White fill
  strokeWeight(2); //Stroke
  stroke(0); //Set color of stroke: black
  textFont(UIFont); //Set font
  rect(60 + (8*((width-20)/40)), 10, ((width-20)/40), ((width-20)/40)); //Make rectangle
  fill(0);
  text(int(fontSize), 63 + (8*((width-20)/40)), 5+((width-20)/40)); //Display text
}

void documentStats()
{
  fill(255); //White fill
  strokeWeight(2); //Stroke
  stroke(0); //Set color of stroke: black
  textFont(UIFont); //Set font
  rect(10, height - footerHeight - 5, width - 20, footerHeight); //Make rectangle
  fill(0);
  String[] list = split(document, " "); //Split at spaces
  String[] linesList = split(document, "~"); //Split at line breaks
  int wordCount;
  int letterCountNoSpaces;
  if (list.length < 0)
  {
    wordCount = 0;
  } else
  {
    wordCount = list.length;
    wordCount = wordCount + linesList.length - 1;
  }
  if (document.length() - wordCount < 0)
  {
    letterCountNoSpaces = 0;
  } else
  {
    letterCountNoSpaces = document.length() - wordCount;
  }
  int letterCountSpaces = document.length();
  int numOfLines = linesList.length;
  int spaceBetweenStats = width/4;
  text("Letters (with spaces): " + letterCountSpaces, 20, height - 10);
  text("Letters (no spaces): " + letterCountNoSpaces, 20 + spaceBetweenStats, height - 10);
  text("Words: " + wordCount, 20 + (2 * spaceBetweenStats), height - 10);
  text("Lines: " + numOfLines, 20 + (3 * spaceBetweenStats), height - 10);
}

void displayAllLetters()
{
  document = "abcdefghijklmnopqrstuvwxyz~ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  println("Press any key to begin typing"); //Feedback
  showExample = true;
}

