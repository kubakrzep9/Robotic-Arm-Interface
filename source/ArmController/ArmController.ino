#include <TimedAction.h>

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

String RA_id = "RA";


int delay_time = 2000;
void update_method(){ send_values(); }
TimedAction update_values = TimedAction(delay_time, update_method); // Can comment when not in use during testing


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
  //update_values.check();
  if(Serial.available()){ serial_com.instructionInterpreter(Serial.readStringUntil('\n')); }  
  // if in automode
  // make small increment

}

// When an instruction is received it is sent to the instructionInterpreter where it will
// be parsed to determine the instructionID and data values. If the instruction is valid, the 
// instructionID will be used to determine what to do. 
//
// Instruction format: "dest_id instr_id data1 data2 ... "
void Serial_COM::instructionInterpreter(String input){
  String stateID = "state";
  String setPinsID = "set_pins";
  String moveArmID = "move";
  String UPS_valuesID = "mapped_values";

  String buffer_array[serial_com.MAX_DATA];
  
  // Tokenizing input 
  int input_size = parseInput(input, buffer_array); // input_size = num(meta_data) + num(data)
  if(input_size == -1){ return;}   // invalid instruction, invalid number of data.

  // Extracting instruction ID and instruction arguments
  String src_id = buffer_array[0]; 
  String dest_id = buffer_array[1]; 
  String instr_id  = buffer_array[2]; 

  if(dest_id != RA_id){ return; }

  // Validating that 'input' contains the right amount of tokens for the each instr_id.
  // The number of tokens is the 'instr_size'.  
  int instr_size = 0;
  int num_data = 0;
  int num_meta_data = serial_com.num_meta_data;
  if(instr_id == setPinsID){ 
    num_data = robot.num_servos + ps.num_sensors;
    instr_size = num_meta_data + num_data; // "GUI RA set_pins b s e w h h_rttr press"  10 tokens
    if(input_size != instr_size){ Serial.println("[RA] Invalid set_pins instruction."); return; }
  }
  else if(instr_id == moveArmID){ 
    num_data = robot.num_servos;
    instr_size = num_meta_data + num_data; // "GUI RA move b s e w h h_rttr"   9 tokens
    if(input_size != instr_size){ Serial.println("[RA] Invalid move instruction."); return; }
  }else if(instr_id == UPS_valuesID){
    num_data = robot.num_servos + ps.num_sensors;
    instr_size = num_meta_data + num_data;
    if(input_size != instr_size){ Serial.println("[RA] Invalid mapped_value instruction from UPS."); return; }
  }
  
  const int data_size = num_data;
  int data[data_size]; // will hold only data values, no meta data.
  
  // Extracting data values from instruction  
  if(instr_id == setPinsID || instr_id == moveArmID || instr_id == UPS_valuesID){ extractIntData(buffer_array, data, data_size); }
  
  // Executing instruction
       if(instr_id == stateID){ send_pins(); send_values();           }
  else if(instr_id == setPinsID){ set_pins(data); send_pins();        }  
  else if(instr_id == moveArmID){ move_arm(data); send_values();      }
  else if(instr_id == UPS_valuesID){ analyze_values(data, data_size); }
  else if(instr_id == "quit"   ){ exit(0);                            }
  else{ Serial.print("[RA] Sending back: "); Serial.println(input);   }
}

// Here is the access point of where the RA receives the "mapped_values" instruction
// from the UPS. The last element of data[] is the pressure gauge value from the UPS. 
// The first six are the mapped_values intended to be each servo angle measure.  
//
// Intended behavior: if gyro angles are ALL within range (0-180), move servos to 
// gyro angles. Match pressure gauge of ps (this) to ups pressure gauge, by moving the hand. 
//
// Need to figure out what data to use. 
void analyze_values(int data[], int data_size){
  Serial.print("Analyzing values from UPS: ");
  for(int i=0; i<data_size; i++){
    Serial.print(data[i]);Serial.print(" ");
  } Serial.println("");
}

// Sends pins to the GUI. Called when "state" or "set_pins" instruction is received. 
void send_pins(){
  int num_robot_pins = robot.num_servos; 
  int total_pins = num_robot_pins + ps.num_sensors;
  int all_pins[total_pins];
  String src_id = RA_id;
  String dest_id = "GUI"; 

  
  robot.get_value("pins", all_pins);       // only sets elements 0 - 5
  all_pins[num_robot_pins] = ps.get_pin(); // setting element 6
  serial_com.sendInstruction(src_id, dest_id, "pins", all_pins, total_pins);
}

// Sends values to the GUI. Called when "state" or "move" instruction is received. 
void send_values(){
  int num_servos = robot.num_servos; 
  int total_values = num_servos + ps.num_sensors;
  int all_values[total_values];
  String src_id = RA_id;
  String dest_id = "GUI"; 

  robot.get_value("angles", all_values);       // only sets elements 0 - 5
  all_values[num_servos] = ps.get_value(); // setting element 6
  serial_com.sendInstruction(src_id, dest_id, "values", all_values, total_values);
}

// Elements 0-5 are servo pins, element 6 is pressure pin
void set_pins(int data[]){
  robot.setPins(data); // Only reads elements 0-5
  ps.set_pin(data[robot.num_servos]);
}

void move_arm(int data[]){ robot.moveArm(data); }
