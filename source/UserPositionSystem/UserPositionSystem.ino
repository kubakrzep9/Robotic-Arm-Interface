#include <TimedAction.h>
#include "Serial_COM.h"
#include "UserPositionSystem.h"

// NOTE: 
// Since the mega will be connected to two serial ports I am 
// not sure which port (Serial or Serial1) would connect to 
// the GUI and which would connect to Serial1. For now I am 
// assuming (Serial) will be the port connected to the GUI and
// (Serial1) will be the port connected to the RA.




Serial_COM serial_com;
UserPositionSystem ups;

String UPS_id = "UPS";

// Sends current UPS sensor values every delay_time microseconds.
// auto mode - RA and UPS
// manual mode - UPS
int delay_time = 2000;
void update_method(){ 
  send_values("GUI"); 
  if(ups.getMode() == "auto"){send_values("RA"); }
}
TimedAction update_values = TimedAction(delay_time, update_method); // Can comment when not in use during testing

void setup() {
  int pins[] = {7, 8, 9, 10};
  serial_com.start();
  ups.setPins(pins);
}

void loop() {
  //update_values.check(); // uncomment to send updates 
   
  // Listening for GUI
  if(Serial.available()){ serial_com.instructionInterpreter(Serial.readStringUntil('\n'));}  
  // Listening for Robotic Arm
  //if(Serial1.available()){ serial_com.instructionInterpreter(Serial1.readStringUntil('\n'));}
}




// When an instruction is received it is sent to the instructionInterpreter where it will
// be parsed to determine the instructionID and data values. If the instruction is valid, the 
// instructionID will be used to determine what method to execute. 
//
// src_id: Source ID 
// dest_id: Destination ID
// instr_id: Instruction ID 
//
// Instruction format: "src_id dest_id instr_id data1 data2 ... "
void Serial_COM::instructionInterpreter(String input){
  String stateID = "state";
  String setPinsID = "set_pins";
  String modeID = "mode";
 
  String buffer_array[serial_com.MAX_DATA];
  
  // Tokenizing input 
  int input_size = parseInput(input, buffer_array); // input_size = num(meta_data) + num(data)
  if(input_size == -1){ return; }   // invalid instruction, invalid number of data.

  // Extracting instruction ID and instruction arguments
  String src_id = buffer_array[0]; 
  String dest_id = buffer_array[1]; 
  String instr_id  = buffer_array[2]; 

  if(dest_id != UPS_id){serial_com.passInstruction(src_id, dest_id, input); }

  // Validating that 'input' contains the right amount of tokens for the each instr_id.
  // The number of tokens is the 'instr_size'.  
  
  int instr_size = 0;
  int num_data = 0;
  String str_data = "";
  if(instr_id == setPinsID){ 
    num_data = ups.num_all_sensors;
    instr_size = serial_com.num_meta_data + num_data; // "GUI UPS set_pins g1 g2 g3 press"  7 tokens
    if(input_size != instr_size){ Serial.println("[UPS] Invalid set_pins instruction."); return; }
  }else if(instr_id == modeID){
    str_data = buffer_array[3];
  }
  
  
  const int data_size = num_data;
  int data[data_size]; // will hold only data values, no meta data.
  
  // Extracting data values from instruction  
  if(instr_id == setPinsID){ extractIntData(buffer_array, data, data_size); }
  
  // Executing instruction
       if(instr_id == stateID  ){ send_pins(); send_values("GUI");   } // Since we are always sending
  else if(instr_id == setPinsID){ set_pins(data); send_pins();       } // back the result of an instruction 
  else if(instr_id == modeID   ){ set_mode(str_data); send_mode();   } // the GUI will reflect whether
  else if(instr_id == "quit"   ){ exit(0);                           } // the instruction was successful
  else{ Serial.print("[UPS] Sending back: "); Serial.println(input); } // or not.
}


// Sets operation mode set by GUI.
void set_mode(String mode){ ups.setMode(mode); }

// Sends an instuction containing the current mode of the UPS.
void send_mode(){
  String src_id = "UPS";
  String dest_id = "GUI";
  String instr_id = "mode";
  String mode = ups.getMode();
  serial_com.sendInstruction(src_id, dest_id, instr_id, mode);
}

// Sets the pins of the UPS to the pins array passed in.
void set_pins(int pins[]){ ups.setPins(pins); }

// Sends an instruction containing all the pin values of the UPS.
//
// Example: "UPS GUI pins 1 2 3 4"
void send_pins(){
  int num_pins = ups.num_all_sensors;
  int pins[num_pins];
  String src_id = UPS_id;
  String dest_id = "GUI";
  String instr_id = "pins";

  ups.getData(instr_id, pins);
  serial_com.sendInstruction(src_id, dest_id, instr_id, pins, num_pins);
}

// Sends an instruction containing all the values of the UPS.
//
// dest_id can either be "GUI" or "RA"
//
// Example: "UPS GUI values 1 2 3 4 5 6 7 8 9 10"
void send_values(String d_id){
  int num_values = ups.num_all_values;
  int values[num_values];
  String src_id = UPS_id;
  String dest_id = d_id;
  String instr_id ="values";

  ups.getData(instr_id, values);
  serial_com.sendInstruction(src_id, dest_id, instr_id, values, num_values);
}
