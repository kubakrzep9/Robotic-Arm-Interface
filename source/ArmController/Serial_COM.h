// This is a Serial communication library designed to send and receive instructions to 
// and from another microcontroller or program.  


class Serial_COM{
  public:
    virtual void instructionInterpreter(String); 
    String makeInstruction(String, String, String[], int, char*);
    String makeInstruction(String, String, int[], int, char*);
    void sendInstruction(String, String, int[], int);
    void sendInstruction(String, String, String[], int);
    void start();

    // template< typename T > String makeInstruction(String, T[], int, char*);

  private:
    const int BUFFER_LENGTH = 256; // Maximum number of characters read from Serial at one time. 
    const int INSTR_DELAY   = 100; // Minimum delay time to send an instruction.
    const int MAX_DATA      = 20;  // Maximum number of expected data members. SUBJECT TO CHANGE BY PROGRAMMER.

    const int num_meta_data = 2;   // meta_data is system_id and instr_id
  
    int getSize(String, char*);
    void parseInstruction(String, String[], int, char*);
    void extractIntData(String[], int[], int);
};


// Initialization method for the Serial_COM class. Cannot set Serial baud rate (Serial.begin()) in constructor. 
void Serial_COM::start(){ Serial.begin(9600); }


// Returns the number of tokens an instruction has. Each token is seperated by a 
// a delimiter; the default delimiter is a space " ". If the number of tokens is 
// larger than the maximum number of expected tokens, the method will return -1.
// This can be caught to terminate analyzing the Serial input as it is not a 
// valid instruction. 
//
//
// Does not validate instruction based on size. Only discards serial input
// that, after parsing, results in a number of tokens greater than MAX_DATA. 
int Serial_COM::getSize(String instruction, char *delimiter=" "){    
  int instr_size = 0;
  char input[BUFFER_LENGTH];
  char *pch;
    
  instruction.toCharArray(input, BUFFER_LENGTH);
  pch = strtok(input, delimiter);
  for(;pch != NULL && instr_size < MAX_DATA; instr_size++){ String token(pch); pch = strtok(NULL, delimiter); }
  if(instr_size >= MAX_DATA){return -1;}
  
  return instr_size;
}


// Sends the instruction via Serial; delay is to ensure instruction is completely sent.
void Serial_COM::sendInstruction(String system_id, String instr_id, int data[], int data_size){ 
  String instruction = makeInstruction(system_id, instr_id, data, data_size, " ");
  Serial.println(instruction); 
  delay(INSTR_DELAY); 
}

// Sends the instruction via Serial; delay is to ensure instruction is completely sent.
void Serial_COM::sendInstruction(String system_id, String instr_id, String data[], int data_size){ 
  String instruction = makeInstruction(system_id, instr_id, data, data_size, " ");
  Serial.println(instruction); 
  delay(INSTR_DELAY); 
}

// Makes an instruction from a set of int data.  
String Serial_COM::makeInstruction(String system_id, String instr_id, int data[], int data_size, char *delimiter=" "){
  String instruction = system_id+delimiter+instr_id;
  for(int i=0; i<data_size; i++){ instruction = instruction + delimiter + String(data[i]); }
  return instruction;
}


// Makes an instruction from a set of String data.
String Serial_COM::makeInstruction(String system_id, String instr_id, String data[], int data_size, char *delimiter=" "){
  String instruction = system_id+delimiter+instr_id;
  for(int i=0; i<data_size; i++){ instruction = instruction + delimiter + data[i]; }
  return instruction;
}



// Parses an instruction received from Serial. The first token, the zeroeth element of parsed_instr, 
// is the instructionID which is used to specify which instruction to execute. The tokens following the
// instructionID are the arguments to the instruction. 
void Serial_COM::parseInstruction(String instruction, String parsed_instr[], int arrSize, char *delimiter=" "){
  char input[BUFFER_LENGTH];
  instruction.toCharArray(input, BUFFER_LENGTH);
  char *pch;

  pch = strtok(input, delimiter);
  for(int i=0; i<arrSize && pch != NULL; i++){
     String token(pch);    
     parsed_instr[i] = token;
     pch = strtok(NULL, delimiter);
  }
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
void Serial_COM::extractIntData(String parsed_instr[], int data[], int data_size){
  for(int i=0; i<data_size; i++){ data[i] = parsed_instr[num_meta_data+i].toInt(); }
}
