// Written by: Jakub Krzeptowski-Mucha
//
// This program is the brain of the robotic arm. This program sends and receives instructions to interface 
// the robotic arm. Serial input is passed to the instruction interpreter where it is parsed and 
// executed (if valid instruction). The RobotArm.h header file contains all the functions that the instruction 
// interpreter will execute. These functions either send the arm state (pin and current angle of each servo)  
// from the Arduino to the computer, set values, or move the arm to a specified position. An instruction is an 
// instructionID followed by data values seperated by spaces. Ex: "instrID 1 2 3 4 5 6".

#include "Serial_COM.h"
#include "RobotArm.h"
#include "PositionSystem.h"

Serial_COM serial_com;
RobotArm robot;
PositionSystem ps;

// Sets servo pins, initializes the serial output and moves the arm to it's initial position.  
void setup() { 
  int pins[] = {13,12,11,10,9,8};
  
  serial_com.start();
  robot.setPins(pins);
  robot.initialPosition();
  ps.set_pin(7);
}

// Constantly listening for instructions being sent from GUI. Once an instruction is received the
// instructionInterpreter will parse and execute the instruction.  
void loop() {
  if(Serial.available()){ serial_com.instructionInterpreter(Serial.readStringUntil('\n')); }  
}

// When an instruction is received it is sent to the instructionInterpreter where it will
// be parsed to determine the instructionID and data values. If the instruction is valid, the 
// instructionID will be used to determine what to do. 
//
// Instruction format: "system_id instr_id data1 data2 ... "
void Serial_COM::instructionInterpreter(String input){
  String stateID = "state";
  String setPinsID = "set_pins";
  String moveArmID = "move";
 
  int input_size = getSize(input); // input_size = 1 instrID + num(data)
  if(input_size == -1){ return;}   // invalid instruction, invalid number of data.

  // Extracting instruction ID and instruction arguments
  String parsed_instr[input_size];
  parseInstruction(input, parsed_instr, input_size);
  String system_id = parsed_instr[0]; 
  String instr_id  = parsed_instr[1]; 

  // Validating that 'input' contains the right amount of tokens for the each instr_id.
  // The number of tokens is the 'instr_size'.  
  int instr_size = 0;
  int num_data = 0;
  if(instr_id == setPinsID){ 
    num_data = robot.num_servos + ps.num_sensors;
    instr_size = serial_com.num_meta_data + num_data; // "RA set_pins b s e w h h_rttr press"  9 tokens
    if(input_size != instr_size){ Serial.println("[RA] Invalid set_pins instruction."); return; }
  }
  else if(instr_id == moveArmID){ 
    num_data = robot.num_servos;
    instr_size = serial_com.num_meta_data + num_data; // "RA move b s e w h h_rttr"   8 tokens
    if(input_size != instr_size){ Serial.println("[RA] Invalid move instruction."); return; }
  }
  
  const int data_size = num_data;
  int data[data_size]; // will hold only data values, no meta data.
  
  // Extracting data values from instruction  
  if(instr_id == setPinsID || instr_id == moveArmID){ 
    if(!extractIntData(parsed_instr, data, data_size){
      Serial.println("[RA] Invalid data types in instruction;")}
    }
  
  // Executing instruction
       if(instr_id == stateID  ){ send_pins(); send_values();       }
  else if(instr_id == setPinsID){ set_pins(data); send_pins();      }  
  else if(instr_id == moveArmID){ move_arm(data); send_values();    }
  else if(instr_id == "quit"   ){ exit(0);                          }
  else{ Serial.print("[RA] Sending back: "); Serial.println(input); }
}


void send_pins(){
  int num_robot_pins = robot.num_servos; 
  int total_pins = num_robot_pins + ps.num_sensors;
  int all_pins[total_pins];
  
  robot.get_value("pins", all_pins);       // only sets elements 0 - 5
  all_pins[num_robot_pins] = ps.get_pin(); // setting element 6
  serial_com.sendInstruction("RA", "pins", all_pins, total_pins);
}

void send_values(){
  int num_robot_pins = robot.num_servos; 
  int total_pins = num_robot_pins + ps.num_sensors;
  int all_values[total_pins];

  robot.get_value("angles", all_values);       // only sets elements 0 - 5
  all_values[num_robot_pins] = ps.get_value(); // setting element 6
  serial_com.sendInstruction("RA", "values", all_values, total_pins);
}

// Elements 0-5 are servo pins, element 6 is pressure pin
void set_pins(int data[]){
  robot.setPins(data); // Only reads elements 0-5
  ps.set_pin(data[robot.num_servos]);
}

void move_arm(int data[]){ robot.moveArm(data); }
