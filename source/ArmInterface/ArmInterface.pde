 // Written by: Jakub Krzeptowski-Mucha
//
// Program Description: This GUI interfaces with a robotic arm and position sensor system.
// Serial communication is used to send instructions back and forth from the GUI to the 
// robotic arm and positon sensor system. To communicate, each system has an instruction 
// interpreter. A system will receive serial input, pass it to the instruction interpreter and
// determine whether the input was an instruction to execute. In this interface there are two
// modes to control the arm: manual and auto. Manual mode allows the user to enter each servos 
// angle measure. Auto mode uses (WILL USE) a calibrated position system to model a persons arm.
//
// Most Tedious Bug: GUI sensor values were not all updating. Only the shoulder gyroscope
// was updating with the sensorValues update, however all sensor values when receiving the 
// sensorState. The issue was using the wrong array indices when accesssing data. Occured 
// more than once. 
//
//
//
//
// NOTES
//
// USE TRY AND CATCHES 
// - WILL SIMPLIFY WIDGET LIBRARY AND PROVIDE ERROR HANDLING FOR INVALID NAMES
//
//
//
//
//
//
//
//
//
//




import processing.serial.*;
import java.util.*; 

ArrayList <PFont> fonts;
Position_System position_system;
Robot robot;
GUI_Settings gui;
Widgets w;
Serial_COM serial;

// Sets up the font, each system and the GUI. 
void setup(){
  setfonts();
  
  position_system = new Position_System();
  robot = new Robot();
  gui = new GUI_Settings(position_system, robot);
  w = new Widgets(this, robot.getNumServos());  
  serial = new Serial_COM(this);
}

// Draws GUI display.
void draw(){ gui.main_screen(); }

// Instantiates the fonts used in the GUI.
void setfonts(){
  fonts = new ArrayList<PFont>();
  fonts.add(createFont("Liberation Sans bold", 15));  // [0] font for larger headings 
  fonts.add(createFont("Liberation Sans bold", 11));  // [1] font for headings
  fonts.add(createFont("Liberation Sans bold", 10));  // [2] font for button text
  fonts.add(createFont("Liberation Sans bold", 9));   // [3] font for small button text
}

// Returns whether the armState has been received or not. The armState (the pins and angles of the arm)
// is the data contained in the servoPins and servoAngles instructions. 
boolean waiting_for_robot_state(){if(!robot.get_state_received()){ return true; } return false; }

// Thread function that is run when the port to the robot arm is connected. The function 
// will repeatedly request the armState of the arm via Serial communication. When the 
// armState is received, the information will be updated onto the GUI and the thread will
// terminate.
public void requestRobotState(){
  String text = "Requesting armState";
  
  while(waiting_for_robot_state()){
    delay(2000);
    println(text);
    println_console(text);
    sendInstruction("armState");
    delay(2000);
  }
}

// Returns whether the sensorState has been received or not. The sensorState (the pins and values of the sensors)
// is the data contained in the servoPins and servoAngles instructions. 
boolean waiting_for_sensor_state(){if(!position_system.get_state_received()){ return true; } return false; }

// Thread function that is run when the port to the sensor system is connected. The function 
// will repeatedly request the sensorState of the system via Serial communication. When the 
// sensorState is received, the information will be updated onto the GUI and the thread will
// terminate.
public void requestSensorState(){
  String text = "Requesting sensorState";
  
  while(waiting_for_sensor_state()){
    delay(2000);
    println(text);
    println_console(text);
    sendInstruction("sensorState");
    delay(2000);
  }
}
