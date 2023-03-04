// Simple neural nets: network
// (c) Alasdair Turner 2009

// Free software: you can redistribute this program and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This class is for the neural network,
// which is hard coded with three layers:
// input, hidden and output

class Network
{
  // this network is hard coded to only have one hidden layer
  int hidden_layers;
  Neuron [] m_input_layer; 
  Neuron [] m_hidden_layer;
  Neuron [] m_hidden_layer2;
  Neuron [] m_hidden_layer3;
  Neuron [] m_output_layer;
  // create a network specifying numbers of inputs, hidden layer neurons
  // and number of outputs, e.g. Network(4,4,3)
  Network(int inputs, int hidden, int outputs)
  {
    hidden_layers = 1;
    m_input_layer = new Neuron [inputs];
    m_hidden_layer = new Neuron [hidden];
    m_output_layer = new Neuron [outputs];
    // set up the network topology
    for (int i = 0; i < m_input_layer.length; i++) {
      m_input_layer[i] = new Neuron();
    }
    // route the input layer to the hidden layer
    for (int j = 0; j < m_hidden_layer.length; j++) {
      m_hidden_layer[j] = new Neuron(m_input_layer);
    }
    // route the hidden layer to the output layer
    for (int k = 0; k < m_output_layer.length; k++) {
      m_output_layer[k] = new Neuron(m_hidden_layer);
    }  
  }
  
  Network(int inputs, int hidden, int hidden2, int outputs)
  {
    hidden_layers = 2;
    m_input_layer = new Neuron [inputs];
    m_hidden_layer = new Neuron [hidden];
    m_hidden_layer2 = new Neuron [hidden2];
    m_output_layer = new Neuron [outputs];
    // set up the network topology
    for (int i = 0; i < m_input_layer.length; i++) {
      m_input_layer[i] = new Neuron();
    }
    // route the input layer to the hidden layer
    for (int j = 0; j < m_hidden_layer.length; j++) {
      m_hidden_layer[j] = new Neuron(m_input_layer);
    }
    // route the input layer to the hidden layer
    for (int jj = 0; jj < m_hidden_layer2.length; jj++) {
      m_hidden_layer2[jj] = new Neuron(m_hidden_layer);
    }
    // route the hidden layer to the output layer
    for (int k = 0; k < m_output_layer.length; k++) {
      m_output_layer[k] = new Neuron(m_hidden_layer2);
    }
    //print("test");
  }
  
  Network(int inputs, int hidden, int hidden2, int hidden3, int outputs)
  {
    hidden_layers = 3;
    m_input_layer = new Neuron [inputs];
    m_hidden_layer = new Neuron [hidden];
    m_hidden_layer2 = new Neuron [hidden2];
    m_hidden_layer3 = new Neuron [hidden3];
    m_output_layer = new Neuron [outputs];
    // set up the network topology
    for (int i = 0; i < m_input_layer.length; i++) {
      m_input_layer[i] = new Neuron();
    }
    // route the input layer to the hidden layer
    for (int j = 0; j < m_hidden_layer.length; j++) {
      m_hidden_layer[j] = new Neuron(m_input_layer);
    }
    // route the input layer to the hidden layer
    for (int jj = 0; jj < m_hidden_layer2.length; jj++) {
      m_hidden_layer2[jj] = new Neuron(m_hidden_layer);
    }
    // route the input layer to the hidden layer
    for (int jj = 0; jj < m_hidden_layer3.length; jj++) {
      m_hidden_layer3[jj] = new Neuron(m_hidden_layer2);
    }
    // route the hidden layer to the output layer
    for (int k = 0; k < m_output_layer.length; k++) {
      m_output_layer[k] = new Neuron(m_hidden_layer3);
    }  
  }
  
  int respond(float [] inputs)
  {
    float [] responses = new float [m_output_layer.length];
    // feed forward
    // simply set the input layer to display the inputs
    for (int i = 0; i < m_input_layer.length; i++) {
      m_input_layer[i].m_output = inputs[i];
      //print(m_input_layer[i].m_output);
    }
    //println();
    // now feed forward through the hidden layer
    for (int j = 0; j < m_hidden_layer.length; j++) {
      m_hidden_layer[j].respond();
      //print(m_hidden_layer[j].m_output);
    }
    //println();
    if(hidden_layers >= 2){
      for (int jj = 0; jj < m_hidden_layer2.length; jj++) {
        m_hidden_layer2[jj].respond();
      }
    }
    if(hidden_layers >= 3){
      for (int jj = 0; jj < m_hidden_layer3.length; jj++) {
        m_hidden_layer3[jj].respond();
      }
    }
    // and finally feed forward to the output layer
    for (int k = 0; k < m_output_layer.length; k++) {
      responses[k] = m_output_layer[k].respond();
    }
    // now check the best response:
    int response = -1;
    float best = max(responses);
    for (int a = 0; a < responses.length; a++) {
      if (responses[a] == best) {
        response = a;
      }
    }
    return response;
  }
  void train(float [] outputs)
  {
    // adjust the output layer
    for (int k = 0; k < m_output_layer.length; k++) {
      m_output_layer[k].finderror(outputs[k]);
      m_output_layer[k].train();
    }
    if(hidden_layers >= 3){
      // propagate back to the hidden layer
      for (int j = 0; j < m_hidden_layer3.length; j++) {
        m_hidden_layer3[j].train();
      }
    }
    if(hidden_layers >= 2){
      // propagate back to the hidden layer
      for (int j = 0; j < m_hidden_layer2.length; j++) {
        m_hidden_layer2[j].train();
      }
    }
    // propagate back to the hidden layer
    for (int j = 0; j < m_hidden_layer.length; j++) {
      m_hidden_layer[j].train();
    }
    // the input layer doesn't learn:
    // it is simply the inputs
  }
  void draw()
  {
    // note, this draw is hard-coded for Network(196,49,10)
    // which reflects my use of the MNIST database of handwritten digits
    for (int i = 0; i < m_input_layer.length; i++) {
      pushMatrix();
      translate((i%14) * width / 25.0 + width * 0.22, (i/14) * height / 25.0 + height * 0.42);
      m_input_layer[i].draw(true);
      popMatrix();
    }
    /*
    for (int j = 0; j < m_hidden_layer.length; j++) {
      pushMatrix();
      translate((j%7) * width / 25.0 + width * 0.36, (j/7) * height / 25.0 + height * 0.12);
      m_hidden_layer[j].draw(false);
      popMatrix();
    }
    */
    // this is slightly tricky -- I've switched the order so the output
    // neurons are arrange 1,2,3...8,9,0 rather than 0,1,2...7,8,9
    // (that's what the (k+9) % 10 is doing)
    for (int k = 0; k < m_output_layer.length; k++) {
      pushMatrix();
      translate(((k+9)%10) * width / 20.0 + width * 0.25, height * 0.05);
      m_output_layer[k].draw(true);
      popMatrix();
    }
  }
}
