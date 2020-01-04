# Robotic-Arm-Interface

<h3> Project Abstract </h3>
The Robotic Arm Interface is a program to control a six servo Robotic Arm. To control the Arm three systems work together. The Arm uses an Arduino to control the servos. The Positioning System uses an Arduino to model an individuals arm using gyroscopic accelerometers. The Interface communicates with the Robotic Arm and the Positioning System via serial communication by sending and receiving instructions. Upon connection to the Robotic Arm or the Position System, the Interface will request the state of that system, the state being the current values (servo angle or sensor value) and current pin values. The Position System sends a constant live stream of data to the Interface which will be translated into servo angle measures. The Interface has two modes, automatic and manual. Automatic mode utilizes the Position System, manual mode allows the user to enter each servo angle measure.  

<h3> Arm Interface </h3>
The Arm Interface is a GUI that allows the user to control the position of the Arm, the pin connections of the Arm and the pin connectoin of the Position System. The Position System sends constant live updates of each sensors values, these values are used to model the Arm to the human arm. The Position System is only used when auto mode is activated. The values of each sensor and angle of each servo are displayed on the Interface for the user to monitor. 

<h3> Robotic Arm </h3>
The Robotic Arm is a six servo system attached to a rotatable base. The Arm is very similar to a human arm as it uses two servos to imitate a shoulder joint (body and shoulder), an elbow servo, two servos to imitate a wrist (wrist and hand rotator), and a hand servo. The Arm's servo angle measures and pins can be set from the Interface. 

<h3> Position System </h3>
The Position System uses three MPU6050 gyroscopic accelerometer sensors and an emg sensor to model a human arm. One gyroscope will be positioned on the back of the arm (on the tricep) to model the shoulder rotation and angle. Another gyroscope will be on the forearm to model the elbow angle. The final gyroscope will be on the hand to model the wrist angle and rotation. The emg sensor will be attached to the forearm and will be used to activate and deactivate hand control. The Position System's pins can be set from the Interface. 

<h3> Communication </h3>
Serial communication is used to pass instructions back and forth between the systems. Each system has an instruction interpreter that will decode any serial input received. If the input is a valid instruction it will execute an action based upon the instructionID. An instruction is made up of an instructionID followed by data values seperated by spaces. Ex: "instrID 1 2 3". The instruction intepreter parses the serial input by attempting to extract the instructionID and data members. If successful, the instrucion will be executed. Many instructions (such as servoAngles) will repeat between systems however, different systems will execute the instructions differently. When the Interface sends the servoAngles instruction it is setting the Arms servo angles. When the Robotic Arm sends the servoAngles instruction (after receiving the armState instruction) it is updating the Interface with the current angle values.  

<h4> Interface to Robotic Arm or Position System Instructions </h4>

- Set Robot Pins:    "servoPins 13 12 11 10 9 8"          
   - "servoPins bodyPin shoulderPin elbowPin wristPin handRotPin handPin"
- Set Robot Angles:  "servoAngles 90 90 0 90 135 45"      
   - "servoAngles bAngle sAngle eAngle wAngle hrAngle hAngle"
- Set Sensor Pins:   "sensorPins 13 12 11 10"             
   - "sensorPins gyro1 gyro2 gyro3 emg"
- Get Arm State:     "armState"                           Requests current servo pins and angles.
- Get Sensor State:  "sensorState"                        Requests current sensor pins and values.

<h4> Robotic Arm to Interface Instructions </h4>

- Send Robot Pins    "servoPins 13 12 11 10 9 8"          Caused by armState instruction.
- Send Robot Angles  "servoAngles 90 90 0 90 135 45"      Caused by armState instruction.

<h4> Position System to Interface Instructions </h4>

- Send Sensor Pins "sensorPins 13 12 11 10"               Caused by sensorState instruction
- Send Sensor Values "sensorValues 0 1 2 3 4 5 6 7 8 9"   Sent on an interval to update Interface with current values. 
   - "SensorValues g1_pitch g1_roll g1_yaw g2_pitch g2_roll g2_yaw g3_pitch g3_roll g3_yaw emg_value"
