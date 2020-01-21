#include <TimedAction.h>
#include "SensorSystem.h"
#include "Serial_COM.h"

const int UPDATE_TIME = 2000;
unsigned long _time;

Serial_COM serial_com;

int num_sensors = 0;
SensorSystem sensors;

String setPinsID = "";
String sensorPinsID = "";
String sensorValuesID = "";
String stateID   = "";


// Sends sensor update values to arm interface via serial communication. 
void update_function(){ Serial.println(sensors.updateInstruction()); }
TimedAction update_action = TimedAction(UPDATE_TIME, update_function);
void update_sensors_function(){ sensors.simulate();}
TimedAction update_sensors = TimedAction(UPDATE_TIME/2, update_sensors_function);

void setup(){ 
  Serial.begin(9600); 
  num_sensors    = sensors.num_sensors;
  setPinsID      = sensors.setPinsID;
  sensorPinsID   = sensors.sensorPinsID;
  sensorValuesID = sensors.sensorValuesID;
  stateID        = sensors.sensorStateID;
}

void loop(){ 
  // Check if received anything
  if(Serial.available()){
    String val = Serial.readStringUntil('\n');
    serial_com.instructionInterpreter(val);
  }
  // Check if should send sensor values update
  update_action.check(); 
  // Check if sensor values should iterate (TESTING PURPOSES ONLY)
  update_sensors.check();
}

void sendInstruction(String instrID){ serial_com.sendMessage(sensors.makeInstruction(instrID)); }

// When an instruction is received it is sent to the instruction interpreter where it will
// be parsed to determine the instructionID and arguments. If the instruction is valid, the 
// instructionID will be used to determine which branch to execute. 
void Serial_COM::instructionInterpreter(String instr){
    // Extracting instruction ID and instruction arguments
    int instr_size = num_sensors+1; // 1 instrID + 3 sensors values
    String parsed_instr[instr_size];
    parseInstruction(instr, parsed_instr, instr_size);
    String instructionID = parsed_instr[0]; 
    int args[num_sensors] = {0,0,0};
    
    // Extracting data values from instruction  
    if(instructionID == setPinsID){ extractArguments(parsed_instr, args, instr_size); }

    // Executing instruction based on instructionID
    if(instructionID == stateID){ sendInstruction(sensorPinsID);
                                  sendInstruction(sensorValuesID);    }
    else if(instructionID == setPinsID ){ sensors.setPins(args);      }
    else if(instructionID == "print"   ){ sensors.printInfo();        } // Debugging purposes  
    else if(instructionID == "quit"    ){ exit(0);                    }
    else{ Serial.print("[PS] Sending back: "); Serial.println(instr); }
}
