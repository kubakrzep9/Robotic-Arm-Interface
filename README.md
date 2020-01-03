# Robotic-Arm-Interface

<h3> Project Abstract </h3>
The Robotic Arm Interface is a program to control a six servo Robotic Arm. To control the Arm three systems work together. The Arm uses an Arduino to control the servos. The Positioning System uses an Arduino to model an individuals arm using gyroscopic accelerometers. The GUI communicates with the Robotic Arm and the Positioning System via serial communication by sending and receiving instructions. 

<h3> Communication </h3>
Serial communication is used in this interface. Each of the three systems contains an instruction interpreter that will decode serial input to determine whether an instruction was sent or not. An instruction is an instructionID followed by data members all seperated by spaces. The instructionID determines what the interpreter should do. 
Ex: "instrID 1 2 3". 

<h3> Robotic Arm </h3>
The Arm is a 6 servo system that gives the Arm 360 degrees of control within it's reach. The Arm is exactly like a human arm where it has a body, shoulder, elbow, wrist, hand and hand rotator servos. The Arms servo angle measures and pins can be set. 

<h3> Position System </h3>
The Position System uses 3 gyroscopic accelerometer sensors and an emg sensor to model a human arm. On gyroscope will go on the back of the arm (on the tricep) to model the shoulder rotation and angle. Another gyroscope will be somewhere on the forearm to model the elbow angle. The final gyroscope will be on the hand to model the wrist angle and rotation. The emg sensor will be attached to the forearm and will be used to activate and deactivate hand control.  

<h3> List of Instructions </h3>
Serial communication is used as the method of communication between the systems. Each system has an instruction interpreter that will decode any serial input received. If the input is a valid instruction it will execute an action based upon the instructionID. An instrucion is made up of an instructionID followed by data values seperated by spaces. Ex: "instrID 1 2 3". The instruction intepreter attempts to parse the serial input by extracting the instructionID and data members. If sucessful, the instrucion will be executed. 

<h4> Interface to Robotic Arm or Position System Instructions </h4>

- Set Robot Pins:    "servoPins 13 12 11 10 9 8"
- Set Robot Angles:  "servoAngles 90 90 0 90 135 45" 
- Set Sensor Pins:   "sensorPins 13 12 11"
- Get Arm State:     "armState" 
  - Requests current servo pins and angles.
- Get Sensor State:  "sensorState"
  - Requests current sensor pins and values.

<h4> Robotic Arm to Interface Instructions </h4>
