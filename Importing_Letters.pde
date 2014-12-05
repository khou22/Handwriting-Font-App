//Conditions only used in creating PShapes
boolean collectCapital = false;
boolean doneCreating = false;
boolean fileLoaded = false;
boolean allowRecord = true;
boolean verticesDone = false;
boolean firstTime = true;

String line;

void createPShapes()
{
  if (inputName) //make sure user has inputed name
  {
    if (firstTime)
    {
      //      checkErrors(); //Make sure the file exists
      determineProperties(); //Determine all properties first and organize into neat arrays
      firstTime = false;
    }
    checkLetter();
    if (!doneCreating)
    {
      loadFile();
      declareVertices();
      loadingBar();
    }
  }
}

void checkErrors() //See if file exists or if name is not typed correctly
{

  String aFilePath = filePath + name + capitalOrLowercase(0) + letters[0] + ".txt";
  File f = new File(aFilePath); 

  if (!f.exists()) //Function to see if files exists
  {
    println("File doesn't exist");
    println("Open input application to input handwriting under your name");
    //    String[] params = {filePath, "Handwriting_Input_List_With_Capitals.pde"};
    //    open(params); //Open other application
    noLoop(); //Stop looping
    exit(); //Close application
  } else
  {
    String lines[] = loadStrings(aFilePath);
  }
}

void checkLetter()
{
  if (letter >= 26)
  {
    if (!doneCreating & !collectCapital)
    {
      println("Finished creating lowercase shapes"); //Debugging
      collectCapital = true;
    }
  }
  if (letter >= 52)
  {
    if (!doneCreating & collectCapital)
    {
      println("Finished creating capital shapes"); //Debugging
      println(""); //Add empty line
      println("Finished creating all shapes"); //Debugging
      collectCapital = false;
      doneCreating = true;
      background(255); //Clear screen
    }
  }
}

void loadFile()
{
  if (!fileLoaded)
  {
    String lines[] = loadStrings(filePath + name + capitalOrLowercase(letter) + letters[letter] + ".txt");
    numOfPoints = lines.length;
    println("There are " + numOfPoints + " points in PShape '" + letters[letter] + "'");
    fileLoaded = true;
  }
}

void declareVertices()
{
  stroke(0); //Font color to black
  strokeWeight(3); //Stroke weight of letters
  beginRecording();
  if (!verticesDone)
  {
    for (int i = 0; i < numOfPoints; i++)
    {
      String lines[] = loadStrings(filePath + name + capitalOrLowercase(letter) + letters[letter] + ".txt");
      int coordinates[] = int(split(lines[i], ',')); //Extract coordinates from .txt file
      letterShapes[letter].vertex(coordinates[0], coordinates[1]);
    }
    for (int j = numOfPoints-1; j > 0; j = j-1)
    {
      String lines[] = loadStrings(filePath + name + capitalOrLowercase(letter) + letters[letter] + ".txt");
      int coordinates[] = int(split(lines[j], ',')); //Extract coordinates from .txt file
      letterShapes[letter].vertex(coordinates[0], coordinates[1]);
    }
    verticesDone = true;
  }
  endRecording();
}

void beginRecording()
{
  //println("Creating PShape for: " + letters[letter]); //Debugging
  if (allowRecord)
  {
    letterShapes[letter] = createShape();
    letterShapes[letter].beginShape();
    allowRecord = false;
  }
}

void endRecording()
{
  if (!allowRecord & verticesDone)
  {
    letterShapes[letter].endShape();
    if (!allowRecord)
    {
      letter++; //Next letter
    }
    fileLoaded = false;
    allowRecord = true;
    verticesDone = false;
  }
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
  } else
  {
    return "";
  }
}

void determineProperties()
{
  determineWidth();
  determineHeight();
}

void determineWidth() //Put letter width into array with length 52
{
  for (int inputLetter = 0; inputLetter < 52; inputLetter++)
  {
    String lines[] = loadStrings(filePath + name + capitalOrLowercase(inputLetter) + letters[inputLetter] + ".txt");
    int test[] = int(split(lines[0], ',')); //Initialize variables
    smallestX = test[0]; //For some reason adding these three lines of code (one above and below) made the program work
    largestX = test[0];
    for (int i = 0; i < lines.length; i++)
    {
      int coordinates[] = int(split(lines[i], ',')); //Extract coordinates from .txt file
      if (coordinates[0] <= smallestX)
      {
        smallestX = coordinates[0]; //find smallest X
      }
      if (coordinates[0] >= largestX)
      {
        largestX = coordinates[0]; //find largest X
      } else
      {
        //        println("Line " + i + " does not have the largest or smallest"); //For debugging
      }
    }
    letterSmallestX[inputLetter] = smallestX; //Store smallest x coordinate
    letterLargestX[inputLetter] = largestX; //Store largest x coorddinate
    int val = abs(largestX - smallestX); //Find width of letter
    println("(" + smallestX + ", " + largestX + ") Width of letter '" + letters[inputLetter] + "' is " + val);
    letterWidth[inputLetter] = val;
  }
  //  println(letterWidth); //Debugging
}

void determineHeight() //Find height of letter and put them in an array
{
  for (int inputLetter = 0; inputLetter < 52; inputLetter++)
  {
    String lines[] = loadStrings(filePath + name + capitalOrLowercase(inputLetter) + letters[inputLetter] + ".txt");
    int test[] = int(split(lines[0], ',')); //Initialize variables
    smallestY = test[0]; //For some reason adding these three lines of code (one above and below) made the program work
    largestY = test[0];
    for (int i = 0; i < lines.length; i++)
    {
      int coordinates[] = int(split(lines[i], ',')); //Extract coordinates from .txt file
      if (coordinates[1] < smallestY)
      {
        smallestY = coordinates[1]; //find smallest Y
      }
      if (coordinates[1] > largestY)
      {
        largestY = coordinates[1]; //find largest Y
      }
    }
    letterSmallestY[inputLetter] = smallestY; //Store smallest y coordinate
    letterLargestY[inputLetter] = largestY; //Store largest y coordinate
    int val = largestY - smallestY; //Find width of letter
    //    println(smallestY + ", " + largestY); //Debugging
    println("(" + smallestY + ", " + largestY + ") Height of letter '" + letters[inputLetter] + "' is " + val); //Feedback
    letterHeight[inputLetter] = val;
  }
  //  println(letterHeight); //Debugging
}

void loadingBar()
{
  stroke(255);
  fill(255);
  rect((width/2)-70, (height/2)-25, 110, 75); //For refreshing percentages
  float percentageDone = letter/52.0; //Convert to percentage
  //  println(percentageDone); //Debugging
  stroke(0);
  noFill(); //No fill
  ellipse(width/2, height/2, 204, 204); //Outline of progress circle
  float radiansDone = percentageDone * (2 * PI); //Convert to radians
  float colorChange = percentageDone * 255; //Make out of 255 for fill color
  stroke(255 - colorChange, colorChange, 100); //Stroke
  fill(255 - colorChange, colorChange, 100); //Fill
  arc(width/2, height/2, 200, 200, -PI/2, radiansDone - PI/2);
  fill(0); //Set percentage text color to black
  textFont(percentageFont); //Load percentage font
  int displayPercentage = int(percentageDone * 100);
  text(displayPercentage + "%", (width/2)-70, (height/2)+25);
}

