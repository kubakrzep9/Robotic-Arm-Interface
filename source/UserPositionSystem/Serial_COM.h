// This is a Serial communication library designed to send and receive instructions to 
// and from another microcontroller or program.  

// NOTE:
// Serial1 can only be used with the Arduino Mega. When testing, 
// leave any code with Serial1 commented. 


class Serial_COM{
  public:
    virtual void instructionInterpreter(String); 
    String makeInstruction(String, String, String, int[], int, char*);
    void sendInstruction(String, String, String, int[], int);
    void sendInstruction(String, String, String, String);
    void passInstruction(String, String, String);
    void start();
    const int MAX_DATA      = 20;  // Maximum number of expected data members. SUBJECT TO CHANGE BY PROGRAMMER.


  private:
    const int BUFFER_LENGTH = 256; // Maximum number of characters read from Serial at one time. 
    const int INSTR_DELAY   = 100; // Minimum delay time to send an instruction.
    const int num_meta_data = 3;   // meta_data is src_id dest_id and instr_id
  
    int parseInput(String, String [], char*);
    void extractIntData(String[], int[], int);
};


// Initialization method for the Serial_COM class. Cannot set Serial baud rate (Serial.begin()) in constructor. 
void Serial_COM::start(){ 
  Serial.begin(9600); // Communication to GUI
  // uncomment when using arduino mega
  //Serial1.begin(9600); // Communication to RA 
}


// Returns the number of tokens an instruction has. Each token is seperated by a 
// a delimiter; the default delimiter is a space " ". If the number of tokens is 
// larger than the maximum number of expected tokens the method will return -1.
// This can be caught to terminate analyzing the input as it is not a 
// valid instruction. 
//
// Does not validate instruction based on size. Only discards serial input
// that, after parsing, results in a number of tokens greater than MAX_DATA. 
//
// bufferArray should always be MAX_DATA
int Serial_COM::parseInput(String instruction, String bufferArray[], char *delimiter=" "){    
  int instr_size = 0;
  char input[BUFFER_LENGTH];
  char *pch;
    
  instruction.toCharArray(input, BUFFER_LENGTH);
  pch = strtok(input, delimiter);
  for(;pch != NULL && instr_size < MAX_DATA; instr_size++){ 
    String token(pch); 
    bufferArray[instr_size] = token;
    pch = strtok(NULL, delimiter); 
  }
  if(instr_size >= MAX_DATA){return -1;}
  return instr_size;
}


// Extracts integer values from parsed_instr. The zeroeth and first elements of parsed_instr are the 
// system_id and instr_id, respectively, and the rest are the data values.  
//
// Assuming parsed_instr contains a valid instruction.
//
// According to documentation, if .toInt() fails it returns a long 0. No real way to 
// validate as 0 could be a value from the instruction or the result of a failed .toInt().
//
// Relies on receiving fully valid instructions. 
void Serial_COM::extractIntData(String buffer_array[], int data[], int data_size){
  for(int i=0; i<data_size; i++){ data[i] = buffer_array[num_meta_data+i].toInt(); }
}


// Makes an instruction from a set of int data.  
String Serial_COM::makeInstruction(String src_id, String dest_id, String instr_id, int data[], int data_size, char *delimiter=" "){
  String instruction = src_id+delimiter+dest_id+delimiter+instr_id;
  for(int i=0; i<data_size; i++){ instruction = instruction + delimiter + String(data[i]); }
  return instruction;
}


// Sends the instruction via Serial; delay is to ensure instruction is completely sent.
void Serial_COM::sendInstruction(String src_id, String dest_id, String instr_id, int data[], int data_size){ 
  String instruction = makeInstruction(src_id, dest_id, instr_id, data, data_size, " ");
  passInstruction(src_id, dest_id, instruction); 
}


void Serial_COM::sendInstruction(String src_id, String dest_id, String instr_id, String data){
  String instruction = src_id+" "+dest_id+" "+instr_id+" "+data;
  passInstruction(src_id, dest_id, instruction);
}

// Method is used to pass or send an instruction to its intended destination. If 
// the UPS receives an instruction and the src_id and dest_id are "RA" and "GUI" 
// respectively, then the UPS will pass the instruction along to the GUI.
void Serial_COM::passInstruction(String src_id, String dest_id, String instruction){
  if(dest_id == "GUI"){ Serial.println(instruction); }
  else if (dest_id == "RA"){ Serial.println(instruction);/*Serial1.println(instruction);*/ }  // uncomment when using mega
  delay(INSTR_DELAY);
}
