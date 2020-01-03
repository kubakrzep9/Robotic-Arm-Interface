// Written by: Jakub Krzeptowski-Mucha
//
// This program is the brain of the robotic arm. This program sends and receives instructions to interface 
// the robotic arm. Serial input is passed to the instruction interpreter where it is parsed and 
// executed (if valid instruction). The RobotArm.h header file contains all the functions that the instruction 
// interpreter will execute. These functions either send the arm state (pin and current angle of each servo)  
// from the Arduino to the computer, set values, or move the arm to a specified position. An instruction is an 
// instructionID followed by data values seperated by spaces. Ex: "instrID 1 2 3 4 5 6".

#include "RobotArm.h"

const int BUFFER_LENGTH = 256; // Max characters serial buffer can read at once.
int num_servos = 0;

RobotArm robot;

// Sets servo pins, initializes the serial output and moves the arm to it's initial position.  
void setup() { 
  int pins[] = {13,12,11,10,9,8};
  
  num_servos = robot.num_servos;  
  robot.setPins(pins);
  robot.initialPosition();

  Serial.begin(9600);
}

// Constantly listening for instructions being sent from GUI. Once an instruction is received the
// instructionInterpreter will parse and execute the instruction.  
void loop() {
  if(Serial.available()){
    String val = Serial.readStringUntil('\n');
    instructionInterpreter(val);
  }
}

// Parses the instruction. The first token, the zeroeth element of parsed_instr, is the
// instructionID which is used to specify which instruction to execute. The tokens following the
// instructionID are the data values for the instruction. 
void parseInstruction(String instr, String parsed_instr[], int arrSize){
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

// Returns the data values from the parsed instruction through extractedData[], which is passed as a parameter.
void extractData(String parsed_instr[], int extractedData[], int arrSize){
  for(int i=0; i<arrSize; i++){ extractedData[i] = parsed_instr[i+1].toInt(); }
}

// When an instruction is received it is sent to the instructionInterpreter where it will
// be parsed to determine the instructionID and data values. If the instruction is valid, the 
// instructionID will be used to determine what to do. 
void instructionInterpreter(String instr){
    String moveArmID = "servoAngles";
    String setPinsID = "servoPins";
    String stateID   = "armState";

    // Extracting instruction ID and instruction arguments
    int instr_size = num_servos+1; // 1 instructionID + 6 servo values
    String parsed_instr[instr_size];
    parseInstruction(instr, parsed_instr, instr_size);
    String instructionID = parsed_instr[0]; 
    int data[num_servos] = {0,0,0,0,0,0};
    // Extracting data values from instruction  
    if(instructionID == setPinsID || 
       instructionID == moveArmID){ extractData(parsed_instr, data, instr_size); }

    // Executing instruction
         if(instructionID == stateID   ){ robot.sendState();          }
    else if(instructionID == setPinsID ){ robot.setPins(data);        } 
    else if(instructionID == moveArmID ){ robot.moveArm(data);        }
    else if(instructionID == "quit"    ){ exit(0);                    }
    else{ Serial.print("[RA] Sending back: "); Serial.println(instr); }
}
