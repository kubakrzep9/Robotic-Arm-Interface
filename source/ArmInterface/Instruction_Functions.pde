// The functions for Serial Communication are listed below. They are seperated by "Receiving Instruction Functions"
// and "Sending Instruction Functions". 
// 
// Receiving Instruction Functions Description - serialEvent() is automatically called when serial input is received. 
// The input is passed into the instructionInterpreter() where it will attempt to parse the serial input. An instruction 
// will have an instructionID followed by data values seperated by spaces. Ex: "instrID 1 2 3 4 5 6". If the serial input
// is a valid instruction, the instructionID will be used to determine what to do. In this case, either the arm's or  
// position systems pins will be set or the arms servo angle measures. 
//
// Sending Instruction Functions Description - Instructions can be sent by pressing certain buttons on the GUI. 
// Instructions described in "Instructions" section. The user fills in the input fields for a system (ex: arm pins). 
// The user presses the respective button and if the input is valid, an instruction will be sent to reflect the 
// users changes. 
//
// Instructions 
// - Note: at least one value must be input for an instruction to be sent. If no values are entered and a button 
//   is pressed, nothing will happen. If anything but an integer is entered, an error will be printed on the 
//   GUI console. 
// - When in manual mode, pressing the go button after entering servo angle measures will send the "servoAngles" 
//   instruction. This instruction moves the arm to the users specified position. Ex: "servoAngles 90 90 90 90 0 0".
// - Pressing the pins button after entering pin values will send the "servoPins" and or "sensorPins" instruction. 
//   If the user only enters pin values for one system, the unchanged system will not received an instruction. 
//   Ex: "servoPins 13 12 11 10 9 8", "sensorPins 7 6 5"
//   Note: The robotic arm and position system are on seperate Arduino boards so they may have the same pin values. 
//   Only pins within the same system must be unique.

int ERROR_VAL = -9999;

/***************************************/
/*** Receiving Instruction Functions ***/ 
/***************************************/

// Serial communication function that is activated when serial input is received. The serial input is 
// sent to the instruction interpreter to do decide what to do. 
void serialEvent(Serial port){
  port.bufferUntil('\n');
  
  String message = port.readStringUntil('\n');
  if(message != null){  
    // removing last character, which is ' '
    if(message.length() > 0) { message = message.substring(0, message.length() - 1); }
    
    println_all("RECEIVED: " + message);
    instructionInterpreter(message);
  }
}

// When an instruction is received it is sent to the instruction interpretter, where it will be parsed
// to determine the instructionID and data values. If the instruction is valid, the instructionID will
// be used to determine which branch to execute.
//
// [0] = dest_id
// [1] = instruction_id
// [2], ..., [n] = data

void instructionInterpreter(String instruction){
  String robot_id = robot.getSystemID();
  String ups_id = position_system.getSystemID();
  
  String parsed_instruction[] = instruction.split(" ");
  boolean valid_instr = true; 
  // Extractable data type containers
  int int_array_data[] = {1}; // Always gets overwritten to new array when used.
  boolean bool_data = false;
  // meta data to interpret instruction 
  String src_id = parsed_instruction[0];
  String dest_id = parsed_instruction[1];
  String instr_id = parsed_instruction[2];



  //Validating and extracting int data from relevant instructions 
  if(instr_id.equals("pins") || instr_id.equals("values")){ 
    int size = parsed_instruction.length;
    int num_meta_data = 3;
    int num_data = size - num_meta_data;
       
    // Validating number of data
    if(instr_id.equals("pins")){
      if(src_id.equals(robot_id)){
        if(num_data != (Robot.num_servos + Robot.num_sensors)){ println_all(dest_id+" Invalid number of data in "+instr_id+" instruction."); return; } }
      else if(src_id.equals(ups_id)){
        if(num_data != position_system.num_sensors){ println_all(dest_id+" Invalid number of data in "+instr_id+" instruction."); return; } }
    }else if(instr_id.equals("values")){
      if(src_id.equals(robot_id)){
        if(num_data != (Robot.num_servos + Robot.num_sensors)){ println_all(dest_id+" Invalid number of data in "+instr_id+" instruction."); return; } }
      else if(src_id.equals(ups_id)){
        if(num_data != position_system.num_data){ println_all(dest_id+" Invalid number of data in "+instr_id+" instruction."); return; } }
    }
       int_array_data = new int[num_data];
       valid_instr = validate_extract_int_data(src_id, instr_id, parsed_instruction, int_array_data);  
       if(!valid_instr){ return;  }     
    
  }else if(instr_id.equals("ups_ra_link")){ bool_data = extract_link_data(parsed_instruction); }
    
  // Decision structure to execute instructions
  if(src_id.equals(robot_id)){     
     // executing instructions
          if(instr_id.equals("pins")){   robot.setPins(int_array_data);   }
     else if(instr_id.equals("values")){ robot.setValues(int_array_data); }  
  }  
  else if(src_id.equals(ups_id)){
     // executing instructions
          if(instr_id.equals("pins")){       position_system.setPins(int_array_data);       }
     else if(instr_id.equals("values")){     position_system.setValues(int_array_data);     }  
     else if(instr_id.equals("mode")){  
       String mode = parsed_instruction[3];
       mode = mode.substring(0,mode.length()-1);    // removing mystery char. Trim() couldnt even delete
       if(position_system.setMode(mode)){
         if(mode.equals("auto")){
           w.autoWidgets();
           gui.set_auto_mode(true);
         }else if(mode.equals("manual")){
           w.manWidgets();
           gui.set_auto_mode(false);
         }
       }
     }
     else if(instr_id.equals("ps_ra_link")){ UPS_RA_Link = bool_data; }
  }else{ println_all("Invalid instruction: \""+instruction+"\"");}
  
  if(!robot.get_state_received()){ if(robot.check_state()){ robot.set_state_received(true); } }
  if(!position_system.get_state_received()){ if(position_system.check_state()){ position_system.set_state_received(true); } }
}

boolean extract_link_data(String parsed_instruction[]){ 
  if(parsed_instruction[1].equals("connected")){ return true; }
  return false;
}

// Extracts the integer data from an instruction. An instruction is "systemID instrID data1 data2 ... ".
// The first piece of data is in element 2 of parsed_instruction.
boolean validate_extract_int_data(String src_id, String instr_id, String parsed_instruction[], int ret_arr[]){
  int size = parsed_instruction.length;
  int num_meta_data = serial.num_meta_data;
  int num_data = size - num_meta_data;
  
  // Validating int datatypes
  String string_data[] = new String[num_data];
  for(int i=0; i<num_data; i++){ string_data[i] = parsed_instruction[num_meta_data+i]; }
  boolean valid = stringArr_to_intArr(string_data, ret_arr);
  if(!valid){ println_all(src_id+" "+instr_id+" instruction datatype error"); }
  return valid;
}

// Converts and returns a string array into an integer array. Returns ERROR_VAL
// if a string element cannot be converted into a string. 
boolean stringArr_to_intArr(String str[], int ret_arr[]){
  int size = str.length;
    
  // Validating servo input is within range [0-180]  
  for(int i=0; i<size; i++){ 
    try{ ret_arr[i] = Integer.parseInt(str[i]); }
    catch(Exception e){ 
      // End of instructions seem to have "\\s", last token cannot be cast to int without removing it
      try{ret_arr[i] = Integer.parseInt(str[i].replaceAll("\\s","")); }
      catch(Exception e2){ return false; }
    }
  }
  return true;
}

/*************************************/
/*** Sending Instruction Functions ***/ 
/*************************************/

// Wrapper function to connect serial ports. 
void connectPorts(){ serial.connectionFunction(); }

// Returns an instruction based on group_name. An instruction is an instructionID followed
// by data values seperated by spaces. Ex: "instrID 1 2 3 4 5 6". The instructionID and data
// values are determined by the group_name. 
String makeInstruction(String dest_id, String instr_id){
  String group_name = "";
  String error = "invalid";
  if(dest_id.equals("RA")){
    if(instr_id.equals("move")){            group_name = w.RA_angle_input_fields_ID; }
    else if(instr_id.equals("set_pins")){   group_name = w.RA_pin_input_fields_ID;   }
    else{ println_all("Invalid instructionID in makeInstruction()");  return error; }  
  }else if(dest_id.equals("UPS")){
    if(instr_id.equals("set_pins")){        group_name = w.UPS_pin_input_fields_ID;  }
    else{ println_all("Invalid instructionID in makeInstruction()");  return error; }  
  }else{ println_all("Invalid dest_id in makeInstruction()"); return error; }
 
  // Gettin user input 
  String input[] = getInputText(group_name);
  int input_status = validateInput(dest_id, group_name, input);
  if(input_status == 0 || input_status == 2){ return error; }
   
  String instruction = AI_id+" "+dest_id + " " + instr_id;
  int size = input.length;
  for(int i=0; i<size; i++){ instruction = instruction+" "+input[i]; }
    
  // Return instruction to be sent
  return instruction;
}

// Sends an instruction via serial communication. The instruction is built using a group_name which
// identifies if the instruction will be using user input. If the instruction is using input
// the data values are attached to an instructionID to be sent. Users may set the pins of the 
// robot and sensor system as well as the servo angle measures of the robot. 
//
// Example instruction: "servoAngles 90 90 90 90 0 0". 
// This instruction would use group name "servo angle input fields" to get the entered values 
// from the respective input fields. 
void sendInstruction(String dest_id, String instr_id){ 
  String instruction = "";
  Serial port = serial.getPort("Port 1");;
  boolean input_instruction = true;
  String src_id = AI_id;

  if(instr_id.equals("state")){ input_instruction = false; }
  
  if(input_instruction){ instruction = makeInstruction(dest_id, instr_id); }
  else{ instruction = src_id+" "+dest_id+" "+instr_id; }
    
  if(!instruction.equals("invalid")){ 
    try{ port.write(instruction); println_all("SENT: "+instruction);}
    catch(Exception e){ println_all("ERROR: Can't sent instruction"); }
  }
}

// Overloaded method that allows String data to be attached to the instruction. To send any string 
// pass the string into data and pass "" for dest_id and instr_id. Looser sendInstructions method, 
// no validation.
void sendInstruction(String dest_id, String instr_id, String data){ 
  String instruction = "";
  String src_id = AI_id;
  
  Serial port = serial.getPort("Port 1");
  if(dest_id.equals("") && instr_id.equals("")){ instruction = data; }
  else{ instruction = src_id+" "+dest_id+" "+instr_id+" "+data; } 
  
  try{ port.write(instruction); println_all("SENT: "+instruction);  }
  catch(Exception e){ println_all("ERROR: Can't sent instruction"); }
}


// Returns the current value of a set of values identified by group_name. 
// group_name = "servo angle input fields" returns the current angles of each servo in the robot. 
int[] getCurrentValues(String group_name){
    int[] current_values = new int[1];
         if(group_name.equals(w.RA_angle_input_fields_ID)){ current_values = robot.getValues();         }
    else if(group_name.equals(w.RA_pin_input_fields_ID)  ){ current_values = robot.getPins();           }
    else if(group_name.equals(w.UPS_pin_input_fields_ID) ){ current_values = position_system.getPins(); }
    return current_values;
}
