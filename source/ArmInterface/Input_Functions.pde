// These functions are used to extract and validate user input from input fields.
// When the user wants set pins or move the arm they will enter values into a group
// of input fields. The input is then validated. For pins duplicates are checked. For
// servo angles the input must be within [0-180]. When the user is ready to set their 
// values, they will press the respective button to go through the input extraction
// process. Based on the input group, an instruction will be sent to the respective
// system to reflect the users changes. The Instruction_Functions and Serial_COM 
// tabs contain the info for serial communication. 

/******************************************************/
/*** Input Functions - take and validate user input ***/
/******************************************************/

// Returns the values in the input fields grouped by group_name. Currently
// there are 3 groups: one to set robot pins, one to set position system pins 
// and one to set servo angles of the robot. 
String[] getInputText(String group_name){ return w.getInputFieldText(group_name); }

// Validation function that verifies user input. Input can only be integers, any invalid 
// input will return 0. All empty input fields will return a 2. Partially empty input
// fields will be filled with their respective current values. Valid (and now filled) values 
// will remain in the passed input array and 1 will be returned. 
int validateInput(String dest_id, String group_name, String[] input){ 
  int size = input.length;
  int int_input[] = new int[size];
 
  if(inputIsEmpty(input)){ return 2; }  // User does not want to change anything. Do nothing. User clicked button without setting anything. 
  if(inputIsInvalid(input, int_input)){ // Error, invalid input 
    String error_text = dest_id+" Enter only integers.";
    println_all(error_text);
    return 0; 
  }
  if(group_name.equals(w.RA_angle_input_fields_ID)){   // Validating servo input is within range [0-180]
    if(!inputInRange(int_input)){
      String error_text = dest_id+" Enter only integer angles [0 - 180].";
      println_all(error_text);
      return 0;
    }
  }
  // Filling empty input values with current values to fill instruction.
  fillEmptyInput(input, group_name);
  if(group_name.equals(w.RA_pin_input_fields_ID) || group_name.equals(w.UPS_pin_input_fields_ID)){       
    if(hasDuplicates(strArr_to_intArr(input))){
      String error_text = dest_id+" Pin values must all be unique.";
      println_all(error_text);
      return 0; 
    } 
  }
  return 1;
}

// Validates that all elements of int_input are within the range [0-180].
boolean inputInRange(int int_input[]){ for(int i : int_input){ if(i>180 || i<0){ return false; } } return true; }

// Returns an integer array of the values of the passed String input array. If a value
// cannot be converted, a message will be displayed to the GUI console, however an array 
// will still be returned. It is assumed however, that this function will always receive 
// valid input as the input array is passed into inputIsValid before this function. This 
// function will only execute if inputIsValid returns true. 
int[] strArr_to_intArr(String[] input){
  int size = input.length;
  int intArr[] = new int[size];
  for(int i=0; i<size; i++){
    try{ intArr[i] = Integer.parseInt(input[i]); }
    catch(Exception e){ println_all("Cannot convert String to int"); }
  }
  return intArr;
}

// Creates a set from the input string array to check for duplicates. If an integer
// cannot be added to the set, duplicate, return false. 
boolean hasDuplicates(int input[]){
  Set<Integer> s = new HashSet();
  for(int i : input){ if(s.add(i) == false){ return true; } }  
  return false; 
}

// The passed input array contains the input field values the user entered. The user
// may not have entered values for each input field in the group. The empty input 
// field values will be replaced with the current value respective to the group_name. 
void fillEmptyInput(String[] input, String group_name){
  int[] current_values = getCurrentValues(group_name); 
  int size = input.length;
  for(int i=0; i<size; i++){ if(input[i].equals("")){ input[i] = str(current_values[i]); } }  
}

// Determines whether the elements of the passed input array can be cast into integers or
// are "" (empty). If input contains anything other than an integer or "" the function will
// return true. Valid input returns false. 
boolean inputIsInvalid(String[] input, int[] int_input){
  int size = input.length;
  for(int i=0; i<size; i++){
    try{ int_input[i] = Integer.parseInt(input[i]); }
    catch(Exception e){ if(!input[i].equals("")){return true; } }
  }
  return false;
}

// Checking to see if entire input field group is empty. If it is, the user
// does not want to change anything. An instruction will not be sent. 
boolean inputIsEmpty(String[] input){
  for(String in : input){ if(!in.equals("")){ return false; } }
  return true;
}
