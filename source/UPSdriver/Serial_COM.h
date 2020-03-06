// This is a Serial communication library designed to send and receive instructions to 
// and from another microcontroller or program.  
class Serial_COM{
  public:
    virtual void instructionInterpreter(String); // will define/use these in driver
    String makeInstruction(String, String[], int, char*);
    String makeInstruction(String, int[], int, char*);
    int sendInstruction(String);
    void start();

  private:
    const int BUFFER_SIZE   = 256; // Maximum number of characters read from Serial at one time *allocation of space for another arduino
    const int INSTR_DELAY   = 100; // Minimum delay time to send an instruction.
    const int MAX_DATA      = 20;  // Maximum number of expected data members. SUBJECT TO CHANGE BY PROGRAMMER. *10 is 1 datamem but 2 char

  // extracting out the data and intrucitonID from serial input
    int getSize(String, char*); 
    void parseInstruction(String, String[], int, char*);
    void extractIntData(String[], int[], int);
};


/**********************/
/*** PUBLIC METHODS ***/
/**********************/


// Initialization method for the Serial_COM class. Cannot set Serial baud rate (Serial.begin()) in constructor. 
void Serial_COM::start(){ Serial.begin(9600); }


// Sends the instruction via Serial; delay is to ensure instruction is completely sent.
int Serial_COM::sendInstruction(String instruction){ Serial.println(instruction); delay(INSTR_DELAY); }


// Makes an instruction from a set of int data.  
String Serial_COM::makeInstruction(String instructionID, int data[], int arrSize, char *delimiter=" "){
  String instruction = instructionID;
  for(int i=0; i<arrSize; i++){ instruction = instruction + delimiter + String(data[i]); }
  return instruction;
}


// Makes an instruction from a set of String data. *for floats or create another with double * can have  different
String Serial_COM::makeInstruction(String instructionID, String data[], int arrSize, char *delimiter=" "){
  String instruction = instructionID;
  for(int i=0; i<arrSize; i++){ instruction = instruction + delimiter + data[i]; }
  return instruction;
}


/***********************/
/*** PRIVATE METHODS ***/
/***********************/


// Returns the number of tokens an instruction has. A token is either an instructionID
// or a piece of data. Each token is seperated by a delimiter; the default delimiter is 
// a space " ". If the number of tokens is larger than the maximum number of expected 
// tokens, the method will return -1. This can be caught to terminate analyzing the 
// Serial input as it is not a valid instruction.
//
// Example instruction "instrID 1 2 3" where "instrID", "1", "2", "3", and "4" are
// the tokens of the instruction.  
int Serial_COM::getSize(String instruction, char *delimiter=" "){    
  int instr_size = 0;
  char input[BUFFER_SIZE];
  char *pch;
    
  instruction.toCharArray(input, BUFFER_SIZE);
  pch = strtok(input, delimiter);
  for(;pch != NULL && instr_size < MAX_DATA; instr_size++){ String token(pch); pch = strtok(NULL, delimiter); }
  if(instr_size >= MAX_DATA){return -1;}
  
  return instr_size;
}


// Parses an instruction received from Serial. The first token, the zeroeth element of parsed_instr, 
// is the instructionID which is used to specify which instruction to execute. The tokens following the
// instructionID are the arguments to the instruction. 
void Serial_COM::parseInstruction(String instruction, String parsed_instr[], int arrSize, char *delimiter=" "){
  char input[BUFFER_SIZE];
  instruction.toCharArray(input, BUFFER_SIZE);
  char *pch;

  pch = strtok(input, delimiter);
  for(int i=0; i<arrSize && pch != NULL; i++){
     String token(pch);    
     parsed_instr[i] = token;
     pch = strtok(NULL, delimiter);
  }
}  


// Extracts integer values from parsed_instr. The zeroeth element of parsed_instr is the instructionID 
// and the rest are the data values.  
void Serial_COM::extractIntData(String parsed_instr[], int extractedData[], int arrSize){
  for(int i=0; i<arrSize; i++){ extractedData[i] = parsed_instr[i+1].toInt(); }
}
