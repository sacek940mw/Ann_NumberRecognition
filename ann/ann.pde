
import g4p_controls.*;
/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/2292*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
// Simple neural nets
// (c) Alasdair Turner 2009

// Free software: you can redistribute this program and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

Network neuralnet;

PFont font;

int testCount = 0;
int trainCount = 0;
int matching = 0;
int trainings = 0;

boolean b_dataloaded = false;

boolean draw = false, gui_change = true;
// left click to test, right click (or ctrl+click on a Mac) to train
boolean b_train = false, b_test = false, test = false;
int last_response = -1, last_actual = -1;

void setup()
{
  size(400,500);
  createGUI();

  font = loadFont("LucidaSans-20.vlw");
  textFont(font);
  
  setupSigmoid();
  loadData();  
  
  trainings = 100;
  
  neuralnet = new Network(196,50,10);
  //neuralnet = new Network(196,50,10);
  //neuralnet = new Network(196,25,10);
  //neuralnet = new Network(196,100,50,10);
  //neuralnet = new Network(196,100,25,10);
  //neuralnet = new Network(196,50,25,10);
  //neuralnet = new Network(196,50,15,10);
  //neuralnet = new Network(196,100,50,25,10);

  background(220,204,255);
  noStroke();
  smooth();
  pushMatrix();
  neuralnet.draw();
  popMatrix();
  fill(0);
}

void draw()
{ 
  //if (gui_change == true) {
      //gui_change = false;
      // draw
      
   // }
    
  if(draw == true){
    if(trainCount < trainings){
      b_train = true;
    }else if(testCount < 100){
      b_test = true;
    }else if(testCount == 100){
      //println("trainCount: " + trainCount + ";  testCount: " + testCount + ";  matching: " + matching);
      draw = false;
    }
    
    
    int response = -1, actual = -1;
    if (!b_dataloaded) {
      loadData();
      b_dataloaded = true;
      b_test = true;
    }
    
    if (b_train) {
    // this allows some fast training without displaying:
    for(int j=0; j<10; j++){
      for (int i = 0; i < 500; i++) {
      // select a random training input and train
      int row = (int) floor(random(0,training_set.length));
      response = neuralnet.respond(training_set[row].inputs);
      actual = training_set[row].output;
      neuralnet.train(training_set[row].outputs);
      last_response = response;
      last_actual = actual;
    }
      trainCount++;
      }    
    }
    else if (b_test) {
      testCount += 1000;
      for(int i=0; i<1000; i++){
        int row = (int) floor(random(0,testing_set.length));
        response = neuralnet.respond(testing_set[row].inputs);
        actual = testing_set[row].output;
        if(response == actual){
          matching++; 
        }
      }
      last_response = response;
      last_actual = actual;
      println("trainCount: " + trainCount + ";  testCount: " + testCount + ";  matching: " + matching);
    }else if(test){
        int row = (int) floor(random(0,testing_set.length));
        response = neuralnet.respond(testing_set[row].inputs);
        actual = testing_set[row].output;
        last_response = response;
        last_actual = actual;
    }
    test = false;
    
    if (b_train || b_test || test) {
      /*
      gui_change = false;
      // draw
      background(220,204,255);
      noStroke();
      smooth();
      pushMatrix();
      neuralnet.draw();
      popMatrix();
      b_train = b_test = false;
      fill(0);
      text(str(response),350,27);
      text(str(actual),350,275);
      */
      last_response = response;
      last_actual = actual;
    }
    
    fill(0);
  }
  background(220,204,255);
      noStroke();
      smooth();
      pushMatrix();
      neuralnet.draw();
      popMatrix();
      b_train = b_test = false;
      fill(0);
      text(str(last_response),350,27);
      text(str(last_actual),350,275);
  
}
/*
void mousePressed() 
{
  if (mouseButton == LEFT) {
    b_test = true;
    println("trainCount: " + trainCount + ";  testCount: " + testCount + ";  matching: " + matching + ";  matching: " + matching);
  }
  else {
    b_train = true;
  }
}
*/
