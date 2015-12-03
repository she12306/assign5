PImage startPlain, startHover;
PImage treasure, fighter, enemyLeft;
PImage end2, end1;
PImage shoot;
PImage bg1, bg2, hp;
float scrollRight;
int n;

int gameState;
final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_LOSE = 2;

int enemyState;
final int ENEMY_LINE = 0;
final int ENEMY_SLASH = 1;
final int ENEMY_QUAD = 2;

int hpBar;
final int HP_PERCENT = 2;
final int HP_MAX = 100 * HP_PERCENT;

PImage [] enemyPlanes = new PImage [5];
float enemyLine [][] = new float [5][2];       
float enemySlash [][] = new float [5][2];
float enemyQuad [][] = new float [8][2];  
float lineCount;
float QuadCount;

//flames
int timer;
int current;
PImage [] booms = new PImage [5];
float boomsPlace [][] = new float [5][2]; 

//place
float treasureX;
float treasureY;
float fighterX;
float fighterY;
float enemyFlyY;
float [] shootX = new float [5];
float [] shootY = new float [5];

//speed
float fighterSpeed;
float enemySpeed;
int shootSpeed;
float addSpeed ;

//input
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

//shoot
int bullet = 0;
boolean [] shootLimit = new boolean[5];

void setup () {  
  
  size (640,480) ;
  frameRate(60);
  textSize(20);  
  textAlign(CENTER);
    
  for ( int i = 0; i < 5; i++ ){
    booms[i] = loadImage ("img/flame" + (i+1) + ".png" );
  }
  
  startPlain = loadImage ("img/start2.png");
  startHover = loadImage ("img/start1.png");  
  bg1 = loadImage ("img/bg1.png");
  bg2 = loadImage ("img/bg2.png");
  hp= loadImage ("img/hp.png");
  treasure = loadImage ("img/treasure.png");
  fighter = loadImage ("img/fighter.png");
  enemyLeft = loadImage ("img/enemy.png");  
  end2 = loadImage ("img/end2.png");
  end1 = loadImage ("img/end1.png");
  shoot = loadImage ("img/shoot.png");
  
  gameState = 0;
  enemyState = 0;
  hpBar = 20 * HP_PERCENT;
  
  treasureX = floor( random(50, width - 40) );
  treasureY = floor( random(50, height - 60) );
  fighterX = width - 65 ;
  fighterY = height / 2 ; 

  //speed
  fighterSpeed = 5 ;
  enemySpeed = 4 ;
  shootSpeed = 3 ;
  addSpeed =0.02;
  
  //flames : Out of Canva
  timer = 0;
  current = 0;
  for ( int i = 0; i < boomsPlace.length; i ++){
    boomsPlace [i][0] = 1000;
    boomsPlace [i][1] = 1000;
  }

  //shoot : No Bullets in the air
  for (int i =0; i < shootLimit.length ; i ++){
    shootLimit[i] = false;
  }

  //enemy : draw LINE 
  lineCount = 0;  
  QuadCount = -60; 
  enemyFlyY = floor( random(80, 400) );   
  
  for (int i = 0; i < 5; i++){
   enemyPlanes [i] = loadImage ("img/enemy.png");  
   enemyLine [i][0] = lineCount;
   enemyLine [i][1] = enemyFlyY; 
   lineCount -= 80;
  }

}

void draw() { 
  background(255) ;   
  
  switch (gameState) {
    case GAME_START:
      image (startPlain, 0, 0);
      
      if ( mouseX > 200 && mouseX < 460 
        && mouseY > 370 && mouseY < 420){
        image(startHover, 0, 0);
      }
    break;  
    case GAME_RUN:
    
    //background_scrolling
      image (bg2, scrollRight, 0);
      image (bg1, scrollRight - width, 0);
      image (bg2, scrollRight - width * 2, 0); 
      
      scrollRight += 2;
      scrollRight %= width * 2;
      
      String word= "Score:"+n;
      fill(255);
      text(word,60,460);
      
    //treasure_draw
      image (treasure, treasureX, treasureY);    
      
    //treasure_avoid repeat
      if(treasureX >= (width - 65) - treasure.width 
        && treasureX <= (width - 65) + fighter.width 
        && treasureY >= (height / 2) - treasure.height
        && treasureY <= (height / 2) + fighter.height){  
        treasureX = floor( random(50, width - 40) );
        treasureY = floor( random(50, height - 60) );
      }    
      
    //Fighter_move
      image(fighter, fighterX, fighterY);
      
      if (upPressed && fighterY > 0) {
        fighterY -= fighterSpeed ;
      }
      if (downPressed && fighterY < height - 50) {
        fighterY += fighterSpeed ;
      }
      if (leftPressed && fighterX > 0) {
        fighterX -= fighterSpeed ;
      }
      if (rightPressed && fighterX < width - 50) {
        fighterX += fighterSpeed ;
      }  
        
    //Flames_burning
      image(booms[current], boomsPlace[current][0], boomsPlace[current][1]);
      
      timer ++;
      if ( timer % (60/10) == 0){
        current ++;
      } 
      if ( current > 4){
        current = 0;
      }
      
    //Flames_keep_burning   
      if(timer > 31){
        for (int i = 0; i < 5; i ++){
          boomsPlace [i][0] = 1000;
          boomsPlace [i][1] = 1000;
        }
      }   
      
    //Shoot_bullet_fly
      for (int i = 0; i < 5; i ++){
        if (shootLimit[i] == true){
          image (shoot, shootX[i], shootY[i]);
          shootX[i] -= shootSpeed;
        }
        if (shootX[i] < - shoot.width){
          shootLimit[i] = false;
        }
      }
    
      switch (enemyState) { 
        case ENEMY_LINE :        
        
          for ( int i = 0; i < 5; i++ ){
            image(enemyPlanes[i], enemyLine [i][0], enemyLine [i][1]);
            
            for (int j = 0; j < 5; j++ ){
              if(shootX[j] >= enemyLine [i][0] - shoot.width 
                && shootX[j] <= enemyLine[i][0] + enemyLeft.width 
                && shootY[j] >= enemyLine [i][1] - shoot.height 
                && shootY[j] <= enemyLine [i][1] + enemyLeft.height
                && shootLimit[j] == true){
                for (int k = 0;  k < 5; k++ ){
                  boomsPlace [k][0] = enemyLine [i][0];
                  boomsPlace [k][1] = enemyLine [i][1];
                }    
                enemyLine [i][1] = -1000;
                enemyFlyY = floor( random(30,240) );
                shootLimit[j] = false;
                timer = 0;
                scoreChange();
              }
            }  
            
            if(fighterX >= enemyLine [i][0] - fighter.width 
              && fighterX <= enemyLine[i][0] + enemyLeft.width 
              && fighterY >= enemyLine [i][1] - fighter.height 
              && fighterY <= enemyLine [i][1] + enemyLeft.height){
              for (int j = 0;  j < 5; j++){
                boomsPlace [j][0] = enemyLine [i][0];
                boomsPlace [j][1] = enemyLine [i][1];
              }
              hpBar -= 20 * HP_PERCENT;            
              enemyLine [i][1] = -1000;
              enemyFlyY = floor( random(30,240) );
              timer = 0;  

            } else if (hpBar <= 0) {
              gameState = 2 ;
              hpBar = 20 * HP_PERCENT;
              fighterX = (width - 65);
              fighterY = height / 2 ;
            } else {
              enemyLine [i][0] += enemySpeed;
              enemyLine [i][0] %= width * 2;
            }      
          }
          
          if (enemyLine [enemyLine.length - 1][0] > width + 100 ) {        
            //enemyFlyX = -100 ;
            //enemyFlyX += enemySpeed ;
            enemyFlyY = floor( random(30,240) );
            
            lineCount = 0;  
            for (int i = 0; i < 5; i++){
              enemySlash [i][0] = lineCount;
              enemySlash [i][1] = enemyFlyY - lineCount / 2;
              lineCount -= 80;                 
            }
            enemyState = 1;
          }
        break ;             
        case ENEMY_SLASH :

          for (int i = 0; i < 5; i++ ){
            image(enemyPlanes[i], enemySlash [i][0] , enemySlash [i][1]);
            
            for(int j = 0; j < 5; j++){
              if ( shootX[j] >= enemySlash [i][0] - shoot.width 
                && shootX[j] <= enemySlash[i][0] + enemyLeft.width 
                && shootY[j] >= enemySlash [i][1] - shoot.height 
                && shootY[j] <= enemySlash [i][1] + enemyLeft.height
                && shootLimit[j] == true){
                for(int k = 0;  k < 5; k++ ){
                  boomsPlace [k][0] = enemySlash [i][0];
                  boomsPlace [k][1] = enemySlash [i][1];
                }     
                enemySlash [i][1] = -1000;
                enemyFlyY = floor( random(30,240) );
                shootLimit[j] = false;
                timer = 0;
                scoreChange();
              }
            }   
            if ( fighterX >= enemySlash [i][0] - fighter.width 
              && fighterX <= enemySlash[i][0] + enemyLeft.width 
              && fighterY >= enemySlash [i][1] - fighter.height 
              && fighterY <= enemySlash [i][1] + enemyLeft.height){
              for (int j = 0;  j < 5; j++ ){
                 boomsPlace [j][0] = enemySlash [i][0];
                 boomsPlace [j][1] = enemySlash [i][1];
               }
              enemySlash [i][1] = -1000;
              enemyFlyY = floor( random(200,280) );
              timer = 0; 
              hpBar -= 20 * HP_PERCENT;
              //enemyFlyX = -100 ;
            } else if (hpBar <= 0) {
              gameState = 2 ;
              hpBar = 20 * HP_PERCENT;
              fighterX = (width - 65);
              fighterY = height / 2 ;
            } else {
              enemySlash [i][0] += enemySpeed;
              enemySlash [i][0] %= width * 2;
            }         
          }
          
          if (enemySlash [4][0] > width + 100){
            enemyFlyY = floor( random(200,280) );
            enemyState = 2 ;
            
            lineCount = 0;  
            QuadCount = -60; 
            for ( int i = 0; i < 8; i ++ ) {
              if ( i < 3 ) {
                enemyQuad [i][0] = lineCount;
                enemyQuad [i][1] = enemyFlyY - lineCount;
                lineCount -= 60;
              } else if ( i == 3 ){
                enemyQuad [i][0] = lineCount;
                enemyQuad [i][1] = enemyFlyY - QuadCount;
                lineCount -= 60;
                QuadCount += 60;
              } else if ( i > 3 && i <= 5 ){
                  enemyQuad [i][0] = lineCount;
                  enemyQuad [i][1] = enemyFlyY + QuadCount;
                  lineCount += 60;
                  QuadCount -= 60;
              } else {
                  enemyQuad [i][0] = lineCount;
                  enemyQuad [i][1] = enemyFlyY + QuadCount;
                  lineCount += 60;
                  QuadCount += 60;
              }            
            }     
          }
        break ;         
        case ENEMY_QUAD :
        
          for( int i = 0; i < 8; i++ ){
            image(enemyLeft, enemyQuad [i][0], enemyQuad [i][1]);     
                  
            for( int j = 0; j < 5; j++ ){
              if ( shootX[j] >= enemyQuad [i][0] - shoot.width 
                && shootX[j] <= enemyQuad [i][0] + enemyLeft.width 
                && shootY[j] >= enemyQuad [i][1] - shoot.height 
                && shootY[j] <= enemyQuad [i][1] + enemyLeft.height
                && shootLimit[j] == true){
                for (int s = 0;  s < 5; s++){
                  boomsPlace [s][0] = enemyQuad [i][0];
                  boomsPlace [s][1] = enemyQuad [i][1];
                }
                enemyQuad [i][1] = -1000;
                enemyFlyY = floor( random(30,240) );
                shootLimit[j] = false;
                timer = 0; 
                scoreChange();
              }
            }       
                
            if ( fighterX >= enemyQuad [i][0] - fighter.width 
              && fighterX <= enemyQuad[i][0] + enemyLeft.width 
              && fighterY >= enemyQuad [i][1] - fighter.height  
              && fighterY <= enemyQuad [i][1] + enemyLeft.height){
                
              for ( int j = 0;  j < 5; j++ ){
                boomsPlace [j][0] = enemyQuad [i][0];
                boomsPlace [j][1] = enemyQuad [i][1];
              }
                
              hpBar -= 20 * HP_PERCENT;
              enemyQuad [i][1] = -1000;
              enemyFlyY = floor( random(50,420) );
              timer = 0; 
              
            } else if ( hpBar <= 0 ) {
              gameState = 2 ;
              hpBar = 20 * HP_PERCENT;
              fighterX = 575 ;
              fighterY = height/2 ;
            } else {
              enemyQuad [i][0] += enemySpeed;
              enemyQuad [i][0] %= width * 3;
            }     
          }
                
          if(enemyQuad [4][0] > width + 300 ){
            enemyFlyY = floor( random(80,400) );
            
            lineCount = 0;       
            for (int i = 0; i < 5; i++ ){
              enemyLine [i][1] = enemyFlyY; 
              enemyLine [i][0] = lineCount;
              lineCount -= 80;
            }
            
            enemyState = 0 ;            
          }  
          
        break ;
        default :
        break ;
      }

     //HP_BAR_draw
      fill (#FF0000);
      rect (35, 15, hpBar, 30);
      image(hp, 28, 15); 
      
      /* HP + 10 */         
        if ( fighterX >= treasureX - fighter.width 
          && fighterX <= treasureX + treasure.width
          && fighterY >= treasureY - fighter.height
          && fighterY <= treasureY + treasure.height) {
            
          if (hpBar <= HP_MAX) {
            if (hpBar < HP_MAX) {
              hpBar += 10 * HP_PERCENT;
            }
            treasureX = floor( random(50,600) );         
            treasureY = floor( random(50,420) );
          }
        }    
    break ;     
    case GAME_LOSE :
      image(end2, 0, 0);  
      
      if ( mouseX > 200 && mouseX < 470 
        && mouseY > 300 && mouseY < 350){
            image(end1, 0, 0);
      }
    break ;
    default :
    break ;
  }
  
}

void keyPressed (){
  if (key == CODED) {
    switch ( keyCode ) {
      case UP :
        upPressed = true ;
        break ;
      case DOWN :
        downPressed = true ;
        break ;
      case LEFT :
        leftPressed = true ;
        break ;
      case RIGHT :
        rightPressed = true ;
        break ;
    }
  }
}
  
void keyReleased () {
  if (key == CODED) {
    switch ( keyCode ) {
      case UP : 
        upPressed = false ;
        break ;
      case DOWN :
        downPressed = false ;
        break ;
      case LEFT :
        leftPressed = false ;
        break ;
      case RIGHT :
        rightPressed = false ;
        break ;
    }  
  }  
  if ( keyCode == ' ' ){
    if ( gameState ==  1 ){
      if ( shootLimit[bullet] == false ) {
        shootLimit[bullet] = true;
        shootX[bullet] = fighterX - 10;
        shootY[bullet] = fighterY + fighter.height/2;
        bullet ++;
      }   
      if ( bullet > 4 ) {
        bullet = 0;
      }
    }
  }
}

void mousePressed (){

  if ( gameState == 0 
    && mouseX > 200 && mouseX < 460 && mouseY > 370 && mouseY < 420){
    if ( mouseButton == LEFT) {
      gameState = 1;
      mouseButton = RIGHT;
    } 
  } else if ( gameState == 2
    && mouseX > 200 && mouseX < 470 && mouseY > 300 && mouseY < 350){
    if( mouseButton == LEFT ){
      treasureX = floor( random(50,600) );
      treasureY = floor( random(50,420) );
      
      enemyState = 0;      
      lineCount = 0;       
      for (int i = 0; i < 5; i++ ){
        boomsPlace [i][0] = 1000;
        boomsPlace [i][1] = 1000;
        shootLimit[i] = false;
        enemyLine [i][0] = lineCount;
        enemyLine [i][1] = enemyFlyY; 
        lineCount -= 80;
      }
      gameState = 1 ; 
    }
  }
  
}

void scoreChange(){
 n+=20;
}
