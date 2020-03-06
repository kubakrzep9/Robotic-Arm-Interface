#include "Serial_COM.h"
#include "UserPositionSystem.h"

Serial_COM serial_com;
UserPositionSystem ups;

void setup() {
  serial_com.start();
  ups.start();
}


void loop() { 
  if(Serial.available()){ serial_com.instructionInterpreter(Serial.readStringUntil('\n')); } 
}


// When an instruction is received it is sent to the instruction interpreter where it will
// be parsed to determine the instructionID and arguments. If the instruction is valid, the 
// instructionID will be used to determine which branch to execute. 
void Serial_COM::instructionInterpreter(String input){
  int instr_size = getSize(input);  // instr_size = 1 instrID + num(data)
  if(instr_size == -1){ return; }   // invalid instruction, invalid number of data. 
       
  // Extracting instruction ID and instruction arguments
  String parsed_instr[instr_size];
  parseInstruction(input, parsed_instr, instr_size, " "); 
  String instructionID = parsed_instr[0]; 
  int num_data = instr_size-1; // subtracting instructionID
  int data[num_data]; 
  
  if(instr_size > 1){ extractIntData(parsed_instr, data, instr_size); }

  // Executing based on instructionID.
  if(instructionID == "getAngles"){ 
    // sends current angles of ups
    int arr_size = ups.num_all_angles;
    int angles[arr_size];    
    ups.get_all_angles(angles);
    serial_com.sendInstruction(serial_com.makeInstruction("gyroAngles",angles, arr_size, " "));                
  }else if(instructionID == "setPins"){ 
    // sets pins of ups to the data from the instruction
    Serial.println("Set ups pins");
  }else if(instructionID == "upsState"){ // this instruction will only read "upsState", there is no data 
    // sends current pins and current angles of ups
    Serial.println("Send ups state");
  }else{ Serial.print("Sending back: "); Serial.println(input);}
}
