import java.io.File; //<>//
import java.util.Comparator;

String quote = "";
String guessedQuote = "";
String newFileName = "";
String unScrambledQuote;
String subtitle;
String quotee;
Table table;
TableRow newRow;
float textSizeSize=50;
float unSQTextSize;
float lastUnSQTextSize;
int answerRow=0;
int lastAnswerRow=0;

boolean underScoreToggle;
String underScore="_";
int underScoreTimer;

PImage helpScreen;

int currentCol=0;

String currentData="data/Famous_Quotes.csv";
int currentChoice=1;

boolean mainMenu=true;
boolean addMode=false;
boolean showScrambled=false;
boolean deleteMode=false;
boolean helpMode=false;
boolean selectMode=false;
boolean addFileMode=false;

boolean showQuotee=false;
boolean showScene=false;
boolean alwaysOn=false;

String helpSign="?";

float fileNameX;
float fileNameLeftX;
float fileNameLeftY;
float fileNameRightX;
float fileNameRightY;
float fileNameSpeed;
float scrollTimer;
int scrollNumber;
int scrollMax;
boolean filePicked;

float menuButtonX;
float menuButtonY;
float addButtonX;
float addButtonY;
float playButtonX;
float playButtonY;
float selectButtonX;
float selectButtonY;

float saveButtonX;
float saveButtonY;
float skipButtonX;
float skipButtonY;
float delButtonX;
float delButtonY;
float helpButtonX;
float helpButtonY;
float guessButtonX;
float guessButtonY;
float pickButtonX;
float pickButtonY;
float quoteeButtonX;
float quoteeButtonY;
float sceneButtonX;
float sceneButtonY;
float addFileButtonX;
float addFileButtonY;
float alwaysOnButtonX;
float alwaysOnButtonY;

float buttonW=85;
float buttonH=85;

float timer;
int score;

boolean correct;
boolean incorrect;

void setup() {
  size(1920, 1080);

  fileNameLeftX=width/4;
  fileNameLeftY=height/4*3;
  fileNameRightX=width/4*3;
  fileNameRightY=height/4*3;
  fileNameX=width/2;
  fileNameSpeed=0;
  scrollTimer=0;
  scrollNumber=0;
  filePicked=false;

  menuButtonX=75;
  menuButtonY=75;
  addButtonX=width/4*3;
  addButtonY=height/2;
  playButtonX=width/4;
  playButtonY=height/2;
  selectButtonX=width/2;
  selectButtonY=height/2;

  saveButtonX=100;
  saveButtonY=height-100;
  skipButtonX=width-100;
  skipButtonY=height-250;
  delButtonX=width-100;
  delButtonY=height-100;
  helpButtonX=width-75;
  helpButtonY=75;
  guessButtonX=width/2;
  guessButtonY=height-200;
  pickButtonX=width/2;
  pickButtonY=height-200;
  quoteeButtonX=100;
  quoteeButtonY=height-150;
  sceneButtonX=100;
  sceneButtonY=height-250;
  addFileButtonX=150;
  addFileButtonY=height-150;
  alwaysOnButtonX=250;
  alwaysOnButtonY=height-200;

  timer=0;

  table = loadTable (currentData);

  helpScreen= loadImage("helpScreen.jpg");
  //helpScreen.resize(1920, 1080);
}

void draw() {
  if (timer==0) {
    correct=false;
    incorrect=false;
  } else if (timer>0) {
    timer--;
  }

  if (timer==1) {
    guessedQuote="";
  }

  if (underScoreTimer==0) {
    underScoreToggle=!underScoreToggle;
    underScoreTimer=30;
  } else if (underScoreTimer>0) {
    underScoreTimer--;
  }

  if (underScoreToggle) {
    underScore="|";
  } else {
    underScore="";
  }

  if (alwaysOn) {
    showScene=true;
    showQuotee=true;
  }


  noStroke();

  if (mainMenu==true) {
    background(#7EBEDB);
    fill(255);
    textSize(100);
    text("What's That Quote?", width/2, height/4);
    fill(#F5ED4F);
    ellipse(addButtonX, addButtonY, 300, 300);
    fill(#A8ED71);
    ellipse(playButtonX, playButtonY, 300, 300);
    fill(#EAA31C);
    ellipse(selectButtonX, selectButtonY, 300, 300);
    fill(#505A58);
    textSize(50);
    text("Add Quotes", addButtonX, addButtonY+10);
    text("Start Game", playButtonX, playButtonY+10);
    text("Select", selectButtonX, selectButtonY-10);
    text("Quote List", selectButtonX, selectButtonY+40);
    text("Current Quote List:  "+currentData.substring(5, currentData.length()-4), width/2, height/4*3);
  }

  textAlign(CENTER);
  textSize(textSizeSize);

  if (addMode==true) {
    background(#A2C6C2);
    textSize(25);
    text("Note: Will be saved to currently selected file.", width/2, 50);
    fill(#FF0000);
    text("Must enter ALL Quote, Part and Quotee", width/2, 80);
    textSize(textSizeSize);
    if (quote.length()*textSizeSize*0.55>width) {
      textSizeSize-=0.5; //If quote takes up more than page width, shrink size of the text
    }
    fill(10, 75, 10);
    text(quote+underScore, width/2, height/2);
    showScrambled=false;
    fill(255);
    if (currentCol==0) {
      text("(1/3) Enter Quote:", width/2, height/4);
    } else if (currentCol==1) {
      text("(2/3) Enter Context:", width/2, height/4);
    } else if (currentCol==2) {
      text("(3/3) Enter Quotee/Speaker:", width/2, height/4);
    }
  }

  if (showScrambled==true) {
    background(#A2C6C2);
    textSize(25);
    text("Type your guess then click the button to enter it.", width/2, 50);
    text("You MUST type the entire quote.", width/2, 80);
    text("Don't forget to include ALL punctuation and capitalisation.", width/2, 110);

    if (timer==0) {
      fill(#64FFE9);
      textSize(unSQTextSize);
      text(unScrambledQuote, width/2, height/2-30); //Shows quote with words missing
    } else {
      fill(#64FFE9);
      textSize(lastUnSQTextSize);
      text(table.getString(lastAnswerRow, 0), width/2, height/2-30);
    }

    fill(0);
    textSize(textSizeSize);
    text("Guess:"+guessedQuote+underScore, width/2, height/2+40); //Shows typed quote
    fill(#00F543);
    ellipse(guessButtonX, guessButtonY, 200, 200);
    fill(0);
    textSize(50);
    text("Guess", guessButtonX, guessButtonY+15);

    if (guessedQuote.length()*textSizeSize*0.6>width) {
      textSizeSize-=0.5; //If quote takes up more than page width, shrink size of the text
    }

    if (correct==true) {
      fill(0, 255, 0);
      text("CORRECT", width/2, 175); // tells if guess is right
    }

    if (incorrect==true) {
      fill(255, 0, 0);
      text("INCORRECT", width/2, 175); // tells if guess is wrong
    }

    if (showScene==true) {
      if (timer==0) {
        fill(#535F5E);
        textSize(70);
        text(subtitle, width/2, height/2-220);
      } else {
        fill(#535F5E);
        textSize(70);
        text(table.getString(lastAnswerRow, 1), width/2, height/2-220);
      }
    }

    if (showQuotee==true) {
      if (timer==0) {
        fill(#535F5E);
        textSize(40);
        text(quotee, width/2, height/2-170);
      } else {
        fill(#535F5E);
        textSize(40);
        text(table.getString(lastAnswerRow, 2), width/2, height/2-170);
      }
    }
  }

  if (deleteMode) {
    fill(#E52A19);
    background(0);
    text("Press BACKSPACE to Remove this Quote", width/2, 100);
    textSize(30);
    fill(255);
    text(table.getString(table.getRowCount()-1, 0), width/2, height/2); // shows quote that will get deleted
    textSize(70);
    text(table.getString(table.getRowCount()-1, 1), width/2, height/2-220);
    textSize(40);
    text(table.getString(table.getRowCount()-1, 2), width/2, height/2-170);
  }

  if (addMode&&currentCol==0||deleteMode) {
    noStroke();
    fill(#FF4C31);
    ellipse(delButtonX, delButtonY, 120, 120);
  }

  if (deleteMode) {
    fill(0);
    textSize(25);
    text("ADD", delButtonX, delButtonY+5);
  }

  if (addMode) {
    fill(#55B1FF);
    ellipse(saveButtonX, saveButtonY, 120, 120);            //button shapes
    fill(0);
    textSize(25);
    text("Save", saveButtonX, saveButtonY+5);  //button text
    if (currentCol==0) {
      text("DELETE", delButtonX, delButtonY+5);
    }
  }

  if (addFileMode) {
    background(#A2C6C2);
    fill(255);
    textSize(100);
    text("Enter File Name", width/2, height/4);
    fill(#98F035);
    ellipse(pickButtonX, pickButtonY, 200, 200);
    fill(#F05227);
    ellipse(addFileButtonX, addFileButtonY, 150, 150);
    fill(0);
    textSize(48);
    text("Confirm", pickButtonX, pickButtonY+15);
    textSize(30);
    text("Back", addFileButtonX, addFileButtonY+5);
    textSize(textSizeSize+15);
    if (newFileName.length()*(textSizeSize+15)*0.55>width) {
      textSizeSize-=0.5; //If quote takes up more than page width, shrink size of the text
    }
    fill(10, 75, 10);
    text(newFileName+underScore, width/2, height/2);
    showScrambled=false;
  }

  if (showScrambled) {
    noStroke();
    fill(#D1F728);
    ellipse(skipButtonX, skipButtonY, buttonW, buttonH);
    fill(#F74D81);
    ellipse(quoteeButtonX, quoteeButtonY, buttonW, buttonH);
    fill(#F0AF35);
    ellipse(sceneButtonX, sceneButtonY, buttonW, buttonH);
    if (alwaysOn) {
      fill(#AFFA12);
    } else {
      fill(#FA5412);
    }
    ellipse(alwaysOnButtonX, alwaysOnButtonY, 100, 100);
    fill(220);
    ellipse(helpButtonX, helpButtonY, 100, 100); 
    ellipse(menuButtonX, menuButtonY, 100, 100);
    fill(0);
    textSize(30);
    text("MENU", menuButtonX, menuButtonY+10);
    textSize(18);
    text("SKIP", skipButtonX, skipButtonY+5);
    text("QUOTEE", quoteeButtonX, quoteeButtonY+5);
    text("CONTEXT", sceneButtonX, sceneButtonY+5);
    text("Always On", alwaysOnButtonX, alwaysOnButtonY+5);
  }

  if (selectMode) {
    noStroke();
    background(#A2C6C2);
    fill(255);
    textSize(100);
    text("Select Quotes", width/2, height/4);
    if (fileNameSpeed>0) {
      fileNameSpeed--;
    } else if (fileNameSpeed<0) {
      fileNameSpeed++;
    }
    if (scrollTimer>0) {
      scrollTimer--;
    }
    fileNameX+=fileNameSpeed;
    fill(220);
    ellipse(pickButtonX, pickButtonY, 200, 200);
    fill(#ADF5DD);
    ellipse(addFileButtonX, addFileButtonY, 150, 150);
    fill(0);
    textSize(30);
    text("Create", addFileButtonX, addFileButtonY+5);
    textSize(50);
    if (scrollNumber>0) {
      fill(220);
      ellipse(fileNameLeftX, fileNameLeftY, buttonW, buttonH);
      fill(0);
      text("<", fileNameLeftX-2, fileNameLeftY+15);
    }
    if (scrollNumber<scrollMax-1) {
      fill(220);
      ellipse(fileNameRightX, fileNameRightY, buttonW, buttonH);
      fill(0);
      text(">", fileNameRightX+2, fileNameRightY+15);
    }

    textSize(48);
    if (currentChoice==scrollNumber) {
      text("Selected", pickButtonX, pickButtonY+15);
    } else {
      text("Select", pickButtonX, pickButtonY+15);
    }
    textSize(40);
    fileSelect();
  }

  if (helpMode) {
    background(#659EA8);
    imageMode(CENTER);
    image(helpScreen, width/2, height/2);      // shows help screen
    noStroke();
    fill(220);
    ellipse(helpButtonX, helpButtonY, 100, 100);       //Display of help button
    fill(0);
    textSize(50);
    text(helpSign, helpButtonX+2, helpButtonY+23);
  }

  if (mainMenu==false) {
    fill(220);
    ellipse(menuButtonX, menuButtonY, 100, 100);
    fill(0);
    textSize(30);
    text("MENU", menuButtonX, menuButtonY+10);
  }

  fill(220);
  ellipse(helpButtonX, helpButtonY, 100, 100);       //Display of help button
  fill(0);
  textSize(70);
  text(helpSign, helpButtonX+2, helpButtonY+23);
}

void keyReleased() {
  if (key!=CODED&&key!=BACKSPACE&&key!=ENTER&&addMode==true) {      //typing quote to be added
    quote+=key;
  }

  if (key!=CODED&&key!=BACKSPACE&&key!=ENTER&&showScrambled==true) {   //typing quote to be guessed
    guessedQuote+=key;
  }

  if (key!=CODED&&key!=BACKSPACE&&key!=ENTER&&addFileMode==true) {   //typing quote to be guessed
    newFileName+=key;
  }

  if (key==BACKSPACE&&addMode==true&&deleteMode==false) {
    quote=quote.substring(0, max(0, quote.length()-1)); //backspace (stackoverflow: TechWiz777)
  }

  if (key==BACKSPACE&&showScrambled==true&&deleteMode==false) {
    guessedQuote=guessedQuote.substring(0, max(0, guessedQuote.length()-1)); //backspace (stackoverflow: TechWiz777)
  }

  if (key==BACKSPACE&&addFileMode==true&&deleteMode==false) {
    newFileName=newFileName.substring(0, max(0, newFileName.length()-1)); //backspace (stackoverflow: TechWiz777)
  }

  if (key==BACKSPACE&&deleteMode==true) {
    table.removeRow(table.getRowCount()-1);    //quote deleting function
    saveTable(table, currentData);
  }

  if (key==ENTER&&showScrambled==true&&mainMenu==false) {  //Guess button pressed
    guess();
    textSizeSize=50;
  }

  if (key==ENTER&&addMode==true&&mainMenu==false) {
    saveQuote();
    textSizeSize=50;
  }

  if (key==ENTER&&addFileMode==true&&mainMenu==false) {
    newFile();
    addFileMode=false;
    selectMode=true;
  }
}

void mouseReleased() {

  if (mouseButton==LEFT) {
    if (dist(mouseX, mouseY, delButtonX, delButtonY)<120/2&&table.getRowCount()>0&&table.getColumnCount()>0&&((addMode==true&&currentCol==0)||deleteMode==true)) {       //Delete button pressed
      addMode= !addMode;
      deleteMode= !deleteMode;
    }

    if (dist(mouseX, mouseY, skipButtonX, skipButtonY)<buttonW/2&&table.getRowCount()>0&&table.getColumnCount()>0&&mainMenu==false&&addMode==false&&deleteMode==false||dist(mouseX, mouseY, playButtonX, playButtonY)<100&&mainMenu==true) {  //scramble button pressed
      addMode=false;
      mainMenu=false;
      deleteMode=false;
      incorrect=false;
      correct=false;
      guessedQuote="";
      textSizeSize=50;
      giveScramble();
    }

    if (dist(mouseX, mouseY, quoteeButtonX, quoteeButtonY)<buttonW/2&&showScrambled==true) {
      showQuotee=!showQuotee;
    }

    if (dist(mouseX, mouseY, sceneButtonX, sceneButtonY)<buttonW/2&&showScrambled==true) {
      showScene=!showScene;
    }

    if (dist(mouseX, mouseY, alwaysOnButtonX, alwaysOnButtonY)<50&&showScrambled==true) {
      alwaysOn=!alwaysOn;
      if (alwaysOn==false) {
        showScene=false;
        showQuotee=false;
      }
    }

    if (dist(mouseX, mouseY, addButtonX, addButtonY)<150&&mainMenu==true) {
      mainMenu=false;
      addMode=true;
    }

    if (dist(mouseX, mouseY, selectButtonX, selectButtonY)<150&&mainMenu==true) {
      mainMenu=false;
      selectMode=true;
    }

    if (dist(mouseX, mouseY, fileNameLeftX, fileNameLeftY)<150/2&&selectMode==true&&scrollTimer==0&&scrollNumber>0) { //scroll left
      fileNameSpeed=29; //move names
      scrollTimer=45; //set delay before next move
      scrollNumber--; //decrease current selection
    } //scroll left

    if (dist(mouseX, mouseY, fileNameRightX, fileNameRightY)<150/2&&selectMode==true&&scrollTimer==0&&scrollNumber<scrollMax-1) { //scroll right
      fileNameSpeed=-29; //move names
      scrollTimer=45; //set delay before next move
      scrollNumber++; //increase current selection
    } //scroll right

    if (dist(mouseX, mouseY, saveButtonX, saveButtonY)<buttonW/2&&quote.length()>0&&addMode==true&&mainMenu==false) {  //save quote button pressed
      saveQuote();
      textSizeSize=50;
    }

    if (dist(mouseX, mouseY, helpButtonX, helpButtonY)<50) {    // help button pressed + changes symbol on button
      if (helpMode==true) {
        helpMode=false;
        helpSign="?";
        mainMenu=true;
      } else if (helpMode==false) {
        deleteMode=false;
        showScrambled=false;
        addMode=false;
        selectMode=false;
        helpMode=true;
        helpSign="X";
      }
    }

    if (dist(mouseX, mouseY, menuButtonX, menuButtonY)<50&&mainMenu==false) {    // help button pressed + changes symbol on button
      deleteMode=false;
      showScrambled=false;
      addMode=false;
      helpMode=false;
      selectMode=false;
      textSizeSize=50;
      helpSign="?";
      mainMenu=true;
    }


    if (dist(mouseX, mouseY, guessButtonX, guessButtonY)<100&&showScrambled==true&&mainMenu==false) {  //Guess button pressed
      guess();
      textSizeSize=50;
    }

    if (dist(mouseX, mouseY, pickButtonX, pickButtonY)<100&&selectMode==true&&mainMenu==false) {  //File Select button pressed
      filePicked=true;
    }

    if (dist(mouseX, mouseY, addFileButtonX, addFileButtonY)<75&&(selectMode==true||addFileMode==true)&&mainMenu==false) {  //File Select button pressed
      selectMode=!selectMode;
      addFileMode=!addFileMode;
    }

    if (dist(mouseX, mouseY, pickButtonX, pickButtonY)<100&&addFileMode==true&&mainMenu==false) {
      newFile();
      addFileMode=false;
      selectMode=true;
    }
  }
}

void giveScramble() {
  int ranQuote = int(random(0, table.getRowCount()));
  if (ranQuote==answerRow) {
    ranQuote = int(random(0, table.getRowCount())); //makes it so chance of same row b2b is 1/rowCount^2
  }
  answerRow=ranQuote;
  subtitle = table.getString(ranQuote, 1);
  quotee = table.getString(ranQuote, 2);
  String[] scrambledQuote = split(table.getString(ranQuote, 0), " ");  //Divides quote into multiple strings
  int blankCount=0;
  int blankChance=6;

  for (int i=0; i<scrambledQuote.length; i++) {  //scrambler
    if (int(random(0, blankChance))>=3&&blankCount<scrambledQuote.length*0.5) { 
      scrambledQuote[i]=scrambledQuote[i].replaceAll("[A-Za-z]", "_"); //turns letters into _
      blankCount++;       //blankCount so theres not too many blanks
    } else {
      blankChance++;      //blankChance so theres not too few blanks
    }
  }

  for (int i=0; i < scrambledQuote.length; i++) {
    unScrambledQuote= String.join(" ", scrambledQuote);   //rejoins words in arraylist to create a quote with words missing as one string
  }

  showScrambled=true;
  table.trim(); //removes blank cells
  unSQTextSize=45;
  if (unScrambledQuote.length()>80) {   //Shrink text so it fits on screen
    unSQTextSize-=(unScrambledQuote.length()-50)*0.2;
  }
}

void saveQuote() {
  if (currentCol==0) {
    newRow = table.addRow();
    newRow.setString(0, quote); //saves quote in first column in new row
    currentCol++;
  } else if (currentCol==1) {
    table.setString(table.getRowCount()-1, currentCol, quote);
    currentCol++;
  } else if (currentCol==2) {
    table.setString(table.getRowCount()-1, currentCol, quote);
    currentCol=0;
  }

  saveTable(table, currentData); //saves table with new quote added

  quote="";  //resets typed quote to blank
  textSizeSize=50;

  table.trim();
}

void guess() {
  timer=0;
  incorrect=false;
  correct=false;
  lastAnswerRow=answerRow;
  lastUnSQTextSize=unSQTextSize;
  unSQTextSize=65;

  if (guessedQuote.equals(table.getString(answerRow, 0))) {
    correct=true;
    timer=60;
  }


  if (correct==false) {
    incorrect=true;
    timer=120;
  }

  if (alwaysOn==false) {
    showQuotee=false;
    showScene=false;
  }

  giveScramble();
}

void fileSelect() {
  File[] files = new File(dataPath("")).listFiles(); //array of filenames

  for (int i=0; i<files.length; i++) {

    if (scrollNumber==i) {
      fill(255);
    } else {
      fill(0);
    }

    text(files[i].getName(), fileNameX + i*400, height/2); //display

    if (filePicked&&scrollNumber==i) {
      filePicked=false; //check if select button pressed
      currentData="data/"+files[i].getName(); //changes active file
      table=loadTable(currentData); //loads new file
      currentChoice=i;
      selectMode=false;
      mainMenu=true;  //send to menu after selection
    }
  }

  scrollMax=files.length;
}

void newFile() {
  try {
    File newFile = new File(dataPath(""), newFileName+".csv");
    newFile.createNewFile();
  } 
  catch (IOException e) {
    println("addFile Error");
  }

  newFileName=""; //reset
  textSizeSize=50; //reset
}
