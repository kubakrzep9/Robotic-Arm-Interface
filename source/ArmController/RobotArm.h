#ifndef ROBOTIC_ARM_H
#define ROBOTIC_ARM_H

// Written by: Jakub Krzeptowski-Mucha
//
// Class Description: The RobotArm class is  used to model a 6-servo robotic arm. 
// Using an instructionInterpreter, the RobotArm can be controlled by sending and 
// receiving instructions via Serial communication. Each instruction has an 
// instructionID followed by data values seperated by spaces. 
// Ex: "instrID 1 2 3 4 5 6". 
//
//
// Most tedious bugs:
// - Manipulating (now removed) servo subclass caused Serial communication to stop. 
//   Solution: replace servo subclass with servo struct.
//
// - Attaching servo pins in RobotArm constructor caused undefined behavior. 
// - Moving arm in RobotArm constructor caused undefined behavior.
//   Solution: Limited RobotArm constructor to initializing basic servo information. 
//   Left all Servo and Serial class methods out of constructor. 
//     
//
// All arrays in the Robot class will use a common array format: 
// 
//          [0] Body, [1] Shoulder, [2] Elbow, [3] Wrist, [4] Hand, [5] Hand Rotator
//
//

#include <Servo.h>

struct _servo{
    int pin     = 0;
    int angle   = 0;
    String _name = "";
    Servo servo;
};

class RobotArm{
  public:
    static const int DELAY_TIME = 100;
    static const int BAUDRATE   = 9600;    
    static const int num_servos = 6;

    RobotArm();
    void setPins(int[]); 
    void moveArm(int[]);
    void initialPosition();
    void sendState();
    void print_info();      

  private: 
    _servo servos[num_servos];
    String makeInstruction(String);
    void sendInstruction(String);
};

// Constructor, called when object is created. Sets the name and angle of each servo 
// in the robotic arm. 
RobotArm::RobotArm(){
  int default_angle = 0; 
  String names[] = {"body", "shoulder", "elbow", "wrist", "hand", "hand rotator"};

  for(int i=0; i<num_servos; i++){ 
      servos[i].angle = default_angle;
      servos[i]._name  = names[i];
  }
}

/*********************/
/*** Arm Functions ***/
/*********************/

// Sets and attaches the arms servo pins to the passed pins array.
void RobotArm::setPins(int pins[]){ 
  for(int i=0; i<num_servos; i++){ 
      servos[i].pin = pins[i]; 
      servos[i].servo.attach(pins[i]); 
  } 
  delay(DELAY_TIME);
}

// Writes to the arms servos to move. Each servo keeps track of it's current angle. 
//
// The wrist servo (i = 3) has 270 degrees of motion, all other servos only go up to 
// 180 degrees. Using the map function, will use the wrist servo as if it were a 180 
// degree servo. 
//
// Delay is used in between moving each servo to all each servo to fully move to it's
// position. 
void RobotArm::moveArm(int angles[]){
  for(int i=0; i<num_servos; i++){
    servos[i].angle = angles[i];
    if(i != 3){ servos[i].servo.write(angles[i]); } 
    else{ servos[i].servo.write(map(angles[i], 0, 270, 0, 180)); } // Wrist servo
    delay(DELAY_TIME);
  }
}

// The starting orientation for the robot arm. In this current intial position, the
// arm is pointed straight up. 
void RobotArm::initialPosition(){
  int init_pos[] = {90,90,90,90,90,90};
  moveArm(init_pos);
}

/*****************************/
/*** Instruction Functions ***/
/*****************************/

// Sends the current pins and angles of the servos in the robotic arm, when the
// armState is requested. 
void RobotArm::sendState(){
  sendInstruction("servoPins");
  sendInstruction("servoAngles");
}

// Returns a String instruction containing an instructionID followed by data values 
// seperated by white spaces. Ex: "servoPins 1 2 3 4 5 6". 
String RobotArm::makeInstruction(String instructionID){
  String instruction = instructionID;
  String robot_data[num_servos];

       if(instructionID == "servoPins"){   for(int i=0; i<num_servos;i++){ robot_data[i] = String(servos[i].pin);   } }
  else if(instructionID == "servoAngles"){ for(int i=0; i<num_servos;i++){ robot_data[i] = String(servos[i].angle); } }
  for(int i=0; i<num_servos; i++){ instruction = instruction + " " + robot_data[i]; }

  return instruction;
} 

// Sends instruction via serial communication. The instruction is built using 
// the passed in instructionID. The respective data values are attached to the 
// instructionID in makeInstruction().
void RobotArm::sendInstruction(String instructionID){ 
  String instruction = makeInstruction(instructionID);
  Serial.println(instruction); 
  delay(DELAY_TIME); 
}

#endif
