class Serial_COM{
  public:
    const int BUFFER_LENGTH = 256;
    const int INSTR_DELAY   = 100;
    
    virtual void instructionInterpreter(String);
    int sendMessage(String);

  private:
    void parseInstruction(String, String[], int);
    int extractArguments(String[], int[], int);
};

int Serial_COM::sendMessage(String message){ Serial.println(message); delay(INSTR_DELAY); }



// Parses the instruction sent from the GUI. The first token, first element of parsed_instr, is the
// instructionID which is used to specify which instruction to execute. The tokens following the
// instructionID are the arguments to the instruction. There will either be 6 arguments for the servos,
// 3 arguments for the coordinate or no arguments. 
void Serial_COM::parseInstruction(String instr, String parsed_instr[], int arrSize){
   char input[BUFFER_LENGTH];
   instr.toCharArray(input, BUFFER_LENGTH);
   char *pch;
   pch = strtok(input, " ");
   for(int i=0; i<arrSize && pch != NULL; i++){
      String token(pch);    
      parsed_instr[i] = token;
      pch = strtok(NULL, " ");
   }
}

// Seperates the arguments from the instructionID from the parsed instruction. Returns 0
// if the arguments cannot be extracted. Ex: invalid datatype or invalid number of arguments. 
// Returns 1 otherwise.
//
// NEED TO ERROR HANDLE
// - Check for num arguments
// - Check for invalid datatypes
int Serial_COM::extractArguments(String parsed_instr[], int extractedArgs[], int arrSize){
  //if((sizeof(parsed_instr)-1) != num_sensors){ Serial.println("Invalid num arguments"); }
  for(int i=0; i<arrSize; i++){ extractedArgs[i] = parsed_instr[i+1].toInt(); }
  return 1;
}
