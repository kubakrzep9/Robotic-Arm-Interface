# Robotic-Arm-Interface

<h3> Project Abstract </h3>
The Robotic Arm Interface is a program to control a six servo Robotic Arm. To control the Arm three systems work together. The Arm uses an Arduino to control the servos. The Positioning System uses another Arduino to model an individuals arm using gyroscopic accelerometers. The GUI communicates with the Robotic Arm and the Positioning System via serial communication by sending and receiving instructions. 

Communication
Serial communication is used in this interface. Each of the three systems contains an instruction interpreter that will decode serial input to determine whether an instruction was sent or not. An instruction is an instructionID followed by data members all seperated by spaces. The instructionID determines what the interpreter should do. 
Ex: "instrID 1 2 3". 

List of Instructions
- Set Robot Pins:    "servoPins 13 12 11 10 9 8"
- Set Robot Angles:  "servoAngles 90 90 0 90 135 45" 
- Set Sensor Pins:   "sensorPins 13 12 11"
- Get Arm State:     "armState" 
  - Requests current servo pins and angles.
- Get Sensor State:  "sensorState"
  - Requests current sensor pins and values.
  
Robotic Arm
The Arm is a 6 servo system that gives the Arm 360 degrees of control within it's reach. The Arm is exactly like a human arm where it has a body, shoulder, elbow, wrist, hand and hand rotator servos. The Arms servo angle measures and pins can be set. 

Position System 
The Position System uses 3 gyroscopic accelerometer sensors and an emg sensor to model a human arm. On gyroscope will go on the back of the arm (on the tricep) to model the shoulder rotation and angle. Another gyroscope will be somewhere on the forearm to model the elbow angle. The final gyroscope will be on the hand to model the wrist angle and rotation. The emg sensor will be attached to the forearm and will be used to activate and deactivate hand control.  
