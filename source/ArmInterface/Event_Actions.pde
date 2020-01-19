// Button and input field event actions. Each function corresponds to a button action. The controlEvent 
// function corresponds to a user selected value from a drop down list. 

import controlP5.*;

/****************************/
/*** Button Event Actions ***/
/****************************/

// Activates auto mode. On the GUI, causes the mode to display "MODE: AUTO" and swaps the auto
// button with the manual button. Auto mode enables the position system and begins (WILL BEGIN)
// modeling an individuals arm. 
void auto(){
  String text = "Auto mode activated.";
  println(text);
  println_console(text);
  w.autoWidgets();
  gui.set_auto_mode(true);
  
  //setAutoMode(True);
}

// Activates manual mode. On the GUI, causes the mode to display "MODE: MANUAL" and swaps the manual
// button with the auto button. Manual mode enables the user the enter each servos angle measure.  
void manual(){
  String text = "Manual mode activated.";
  println(text);
  println_console(text);
  w.manWidgets();
  gui.set_auto_mode(false);
  
  // setAutoMode(False);
}

// Shows options widgets and hides console. The options widgets allow the user to set the
// port of each system and to set the pins of each of the sensors and servos used.
void options(){
  w.optionsWidgets();
  gui.set_options_mode(true);
}

// Shows console (message box) and hides widgets shown by options button.
void console(){
  w.consoleWidgets();
  gui.set_options_mode(false);
}

// Sends instruction to move the arm.
// Ex: "servoAngles 180 0 90 0 90 90".
void go(){
  sendInstruction("servo angle input fields");
  w.clearTextFields("angles");
}

// Attempts to connect set serial ports. The ports are set via two drop down menus in the 
// options settings. Ports must be unique, an error is printed to the GUI console if not. 
// Can connect one port at a time or both at the same time. Prints error to GUI if port 
// cannot be connected to. 
void ports(){ connectPorts(); }      

// Send instruction to set the pins of the robot arm and the position system.
// The pins button eventAction contains an algorithm to determine whether 
// an instruction should be sent to a system or not. In other words, if the user
// only inputs the pins to one system, that system will only receive an instruction
// to update it's pins. If the user inputs the pins to both systems, both systems
// will receive an instruction. 
// Ex: "servoPins 1 2 3 4 5 6"
//     "sensorPins 7 8 9"
void pins(){
  sendInstruction("servo pin input fields");
  sendInstruction("sensor pin input fields");
  w.clearTextFields("pins");
}

/**************************************/
/*** Dropdown List Control Function ***/
/**************************************/

// Function allows the ability access each event. In this case we select a port from the 
// dropdownlist and connect to it
void controlEvent(ControlEvent theEvent) {
  // Connecting Position System port
  if(theEvent.getName().equals("port 1")){
    int index = int(theEvent.getController().getValue());
     if(index > 0){
       if(!serial.port_connected("port 1")){
          serial.setPortName("port 1", w.getItemDropDownList(w.available_ports1, index), index);
       }
     }
  }
  // Connecting Robotic Arm port
   if(theEvent.getName().equals("port 2")){
     int index = int(theEvent.getController().getValue());
     if(index > 0){
       if(!serial.port_connected("port 2")){
          serial.setPortName("port 2", w.getItemDropDownList(w.available_ports2, index), index);
       }
     }
  }
}

/************************/
/*** Console Function ***/
/************************/

// Wrapper function to print onto the GUI console. 
void println_console(String text){ w.println_console_timed(text); }
