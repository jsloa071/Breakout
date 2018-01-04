/*  Module 5.14  Breakout!
    Question 1              */

//declare # lives and score
int score, lives; 

//declare # brick hits
int hits = 0, hitOrange = 0, hitRed = 0;

//colors
color yellow = color(239,249,15);
color green = color(15,247,28);
color orange = color(247,128,15);
color red = color(247,15,31);

//declare number of bricks 
int numBricks = 64; //8 x 8
//declare arrays for brick x coordinates and y coordinates, and for tracking row number
int[] xCoordArray = new int[numBricks];
int[] yCoordArray = new int[numBricks];
int[] rowNumArray = new int[numBricks];
//declare color array
color[] colorArray = new color[numBricks];

//brick variables (fixed)
final int brickWidth = 90, brickHeight = 20;
int brickHSpacing, brickVSpacing; //horizontal and vertical spacing between bricks

//paddle variables
final int paddleWidth = 80, paddleHeight = 10;
int paddleX, paddleY;

//ball variables
final int ballWidth = 20;
int ballX, ballY, ballSpeedX, ballSpeedY;

//declare boolean for gameover (if true, show gameover screen)
boolean gameover = false;

void setup()
{
  size(800,500);
  rectMode(CENTER);
  
  //initialize lives and score
  score = 0;
  lives = 3;
  
  //initialize brick spacing
  brickHSpacing = (width - (brickWidth*8))/9;
  brickVSpacing = ((height/2) - (brickHeight*8))/9;
  
  //initialize paddle X and assign paddle Y 
  paddleX = width/2;
  paddleY = height - paddleHeight*2;
  
  //initialize ballX and ballY
  ballX = width/2;
  ballY = paddleY - paddleHeight*8;
  ballSpeedX = 3;
  ballSpeedY = -3;
  
  //assign x and y coordinates to brick arrays
  int counter = 0;
  while (counter < numBricks)
  {
    int rowNum = 0;
    while (rowNum < 8)
    {
      int colNum = 0;
      while (colNum < 8)
      {
        yCoordArray[counter] = (((rowNum+1)*brickVSpacing)+(rowNum*brickHeight) + brickHeight/2);
        xCoordArray[counter] = (((colNum+1)*brickHSpacing)+(colNum*brickWidth) + brickWidth/2);
        rowNumArray[counter] = rowNum+1;
        counter++;
        colNum++;
      }
      rowNum++;
    }
  }
}

void draw()
{
  background(0);

  updateDirection();
  updatePaddleX();
  drawBricks();
  drawPaddle();
  drawBall();

  //write score and lives
  text("Score: "+score, 10, height-40);
  text("Lives: "+lives, 10, height-20);
  
  //change screen if gameover
  gameover();
}

//FUNCTIONS:

void updatePaddleX()
{
  //if mouse is in window, update paddleX
  if (dist(mouseX, mouseY, width/2, height/2) < width/2)
  {
    paddleX = mouseX;
  }
}

void drawPaddle()
{
  fill(255);
  stroke(255);
  rect(paddleX, paddleY, paddleWidth, paddleHeight);
}

//function to update direction of ball
void updateDirection()
{
  // if ball collides with top or bottom of screen, change direction
  if  ((ballX+ballWidth/2 > paddleX-paddleWidth/2) && (ballX-ballWidth/2 < paddleX+paddleWidth/2) &&
      (ballY+ballWidth/2 >= paddleY-paddleHeight/2 && (ballY+ballWidth/2 < paddleY+paddleHeight/2)) ||
      (ballY-ballWidth/2 <= 0))
  {
  if (ballY > paddleY-paddleHeight/2)
    {  
      ballY = paddleY-paddleHeight/2;
    }
  else if ((ballY-ballWidth/2 <= 0))
   {
     ballY = ballWidth/2;
   }
    ballSpeedY *= -1;
  }
  //if ball collides with left wall:
  if ((ballX-ballWidth/2) <= 0)
  {
    ballSpeedX *= -1;
    ballX = ballWidth/2;
  }
  //if ball collides with right wall:
  if ((ballX + ballWidth/2) >= width)
  {
    ballSpeedX *= -1;
    ballX = width-ballWidth/2;
  }
  //if paddle misses ball, lose a life and reconfigure direction/speed
  if (ballY+ballWidth/2 > paddleY+paddleHeight/2)
  {
    if (lives > 1)
    {
      lives -= 1;
      newTry();
    }
    //if out of lives: 
    else if (lives == 1)
    {
      gameover = true;
    }
  }
}

void drawBall()
{
  fill(255);
  stroke(0);
  //update x and y
  ballX += ballSpeedX;
  ballY += ballSpeedY;
  ellipse(ballX, ballY, ballWidth, ballWidth);
}

void drawBricks()
{
  int counter = 0;
  while (counter < numBricks)
  {
    int x = xCoordArray[counter];
    int y = yCoordArray[counter];
    //select colors based on row number
    if (rowNumArray[counter] == 1 || rowNumArray[counter] == 2)
    {
      colorArray[counter] = red;
    }
    else if (rowNumArray[counter] == 3 || rowNumArray[counter] == 4)
    {
      colorArray[counter] = orange;
    }
    else if (rowNumArray[counter] == 5 || rowNumArray[counter] ==  6) 
    {
      colorArray[counter] = green;
    }
    else if (rowNumArray[counter] == 7 || rowNumArray[counter] == 8)
    {
      colorArray[counter] = yellow;
    }
  
    fill(colorArray[counter]);
    stroke(255);
    rect(x,y, brickWidth, brickHeight);
    collisionCheck(counter);
    counter++;
  }
}

//check if ball has collided with brick
//if has, increment score, hits, and/or speed
void collisionCheck(int indexNumber)
{
  if ((ballX+ballWidth/2 >= (xCoordArray[indexNumber]-brickWidth/2)) && 
      (ballX-ballWidth/2 <= (xCoordArray[indexNumber]+brickWidth/2)) &&
      (ballY+ballWidth/2 >= (yCoordArray[indexNumber]-brickHeight/2)) &&
      (ballY-ballWidth/2 <= (yCoordArray[indexNumber]+brickHeight/2)))
     {
       xCoordArray[indexNumber] = -100;
       if (colorArray[indexNumber] == yellow)
       {
         score += 1;
       }
       else if (colorArray[indexNumber] == green)
       {
         score += 3;
       }
       else if (colorArray[indexNumber] == orange)
       {
         hitOrange += 1;
         score += 5;
       }
       else if (colorArray[indexNumber] == red)
       {
         hitRed += 1;
         score +=7;
       }
       hits += 1;
       if (hits == 4 || hits == 12 || hitOrange == 1 || hitRed == 1)
       {
         ballSpeedY *= -1.5;
         ballSpeedX *= 1.5;
       }
       else
       {
         ballSpeedY *= -1;
       }
      }
}

//re-initialize ball speed and coordinates if player loses life
void newTry()
{
  ballSpeedX = 3;
  ballSpeedY = -3;
  ballX = width/2;
  ballY = paddleY - paddleHeight*8;
  hits = 0;
}

void gameover()
{
  if (gameover == true)
  {
    background(0);
    textSize(20);
    textAlign(CENTER,CENTER);
    text("GAMEOVER!", width/2, height/2);
    text("Your final score is " + score, width/2, height/2+40);
  }
}