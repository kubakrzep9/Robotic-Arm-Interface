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
    
    println("RECEIVED: " + message);
    println_console("RECEIVED: " + message);
    instructionInterpreter(message);
  }
}

// When an instruction is received it is sent to the instruction interpretter, where it will be parsed
// to determine the instructionID and data values. If the instruction is valid, the instructionID will
// be used to determine which branch to execute.
void instructionInterpreter(String instruction){
  String parsed_instruction[] = instruction.split(" ");
    if(parsed_instruction[0].equals("servoPins")  || parsed_instruction[0].equals("servoAngles") ||
       parsed_instruction[0].equals("sensorPins") || parsed_instruction[0].equals("sensorValues")){
      int data[] = extract_instruction_data(parsed_instruction);
      if(data[0] == ERROR_VAL){ String error = "Instruction datatype error (Corrupt data?)"; println(error); println_console(error); return;  }
            
           if(parsed_instruction[0].equals("servoPins")){    robot.setServoPins(data);              }
      else if(parsed_instruction[0].equals("servoAngles")){  robot.setServoAngles(data);            }
      else if(parsed_instruction[0].equals("sensorPins")){   position_system.setSensorPins(data);   }
      else if(parsed_instruction[0].equals("sensorValues")){ position_system.setSensorValues(data); }
      
      if(!robot.get_state_received()){ if(robot.check_state()){ robot.set_state_received(true); } }
      if(!position_system.get_state_received()){ if(position_system.check_state()){ position_system.set_state_received(true); } }
   }
}

// Extracts the integer data from an instruction. An instruction is an instructionID followed by 
// data members and so the first piece of data is in element 1 of parsed_instruction.
int[] extract_instruction_data(String parsed_instruction[]){
  int size = parsed_instruction.length;
  String string_data[] = new String[size-1];
  int i = 0;
  
  for(;i<size-1; i++){ string_data[i] = parsed_instruction[i+1]; }
  int data[] = stringArr_to_intArr(string_data);
  
  return data;
}

// Converts and returns a string array into an integer array. Returns ERROR_VAL
// if a string element cannot be converted into a string. 
int[] stringArr_to_intArr(String str[]){
  boolean valid_data = true;
  int size = str.length;
  int intArr[] = new int[size];
  
  // Validating servo input is within range [0-180]  
  for(int i=0; i<size; i++){ 
    try{ intArr[i] = Integer.parseInt(str[i]); }
    catch(Exception e){ 
      // End of instructions seem to have "\\s", last token cannot be cast to int without removing it
      try{intArr[i] = Integer.parseInt(str[i].replaceAll("\\s","")); }
      catch(Exception e2){ valid_data = false; }
    }
  }
  
  if(valid_data){ return intArr; }
  else{ int errorArr[] = {ERROR_VAL}; return errorArr;  }
}

/*************************************/
/*** Sending Instruction Functions ***/ 
/*************************************/

// Wrapper function to connect serial ports. 
void connectPorts(){ serial.connectionFunction(); }

// Returns an instruction based on group_name. An instruction is an instructionID followed
// by data values seperated by spaces. Ex: "instrID 1 2 3 4 5 6". The instructionID and data
// values are determined by the group_name. 
String makeInstruction(String group_name){
  String input[] = getInputText(group_name);
  int input_status = validateInput(input, group_name);
  if(input_status == 0 || input_status == 2){ return "invalid"; }
  
  String instructionID = "";
  if(group_name.equals("servo angle input fields")){     instructionID = "servoAngles"; }
  else if(group_name.equals("servo pin input fields")){  instructionID = "servoPins";   }
  else if(group_name.equals("sensor pin input fields")){ instructionID = "sensorPins";  }
  else{ w.println_console_timed("Invalid group_name for instruction"); }
  
  String instruction = instructionID;
  int size = input.length;
  
  for(int i=0; i<size; i++){ instruction = instruction+" "+input[i]; }
  int int_input[] = strArr_to_intArr(input);

  // Update GUI. Updating GUI version of robot and position system. 
  if(group_name.equals("servo angle input fields")){     robot.setServoAngles(int_input);           }
  else if(group_name.equals("servo pin input fields")){  robot.setServoPins(int_input);             }
  else if(group_name.equals("sensor pin input fields")){ position_system.setSensorPins(int_input);  }
  
  // Return instruction to be sent
  println(instruction);
  w.println_console_timed(instruction);
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
void sendInstruction(String group_name){ 
  String armStateID = "armState";
  String sensorStateID = "sensorState";
  
  String instruction = "";
  Serial port = null;
  boolean input_instruction = true;
  if(group_name.equals(armStateID) || group_name.equals(sensorStateID)){ input_instruction = false; }

  if(group_name.equals("servo angle input fields") || 
     group_name.equals("servo pin input fields")   ||
     group_name.equals(armStateID)){ port = serial.getPort("Port 1"); }
  else if(group_name.equals("sensor pin input fields") ||
          group_name.equals(sensorStateID)){ port = serial.getPort("Port 2"); }
  
  if(input_instruction){ instruction = makeInstruction(group_name); }
  else{ instruction = group_name; }
    
  if(!instruction.equals("invalid")){ 
    try{ port.write(instruction); }
    catch(Exception e){ println("Can't sent instruction"); w.println_message_box("ERROR: Can't sent instruction"); }
  }
}

// Returns the current value of a set of values identified by group_name. 
// group_name = "servo angle input fields" returns the current angles of each servo in the robot. 
int[] getCurrentValues(String group_name){
    int[] current_values = new int[1];
    if(group_name.equals("servo angle input fields")){     current_values = robot.getServoAngles();          }
    else if(group_name.equals("servo pin input fields")){  current_values = robot.getServoPins();            }
    else if(group_name.equals("sensor pin input fields")){ current_values = position_system.getSensorPins(); }
    return current_values;
}
