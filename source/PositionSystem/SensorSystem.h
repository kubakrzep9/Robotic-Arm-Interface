
// The MPU6050 is a six-axis gyroscopic accelerometer. The SensorSystem uses the 
// pitch, roll and yaw angle measures produced by the gyroscope. 
struct MPU6050_Sensor{
  int num_angles = 3; // roll, pitch, yaw
  int pin      = 0; 
  int roll     = 0;
  int pitch    = 0;
  int yaw      = 0;
  String _name = "MPU6050";
};

// An EMG sensor is used to detect muscle contraction on the forearm. This contraction
// will signal an event to turn on and off. In the RoboticArm's case, the arm's hand will
// open and close based upon the EMG sensor. 
struct EMG_Sensor{
  int pin      = 0;
  int value    = 0;
  String _name = "EMG";
};




class SensorSystem{
  public:
    static const int num_MPU6050 = 3;
    static const int num_EMG = 1;
    int num_sensors = 0;
   
    String sensorStateID  = "sensorState";
    String setPinsID      = "setPins";
    String sensorPinsID   = "sensorPins";
    String sensorValuesID = "sensorValues";
    
    SensorSystem();

    // Triggered by instruction
    void setPins(int[]);

    String makeInstruction(String);

    // Update Function 
    String updateInstruction();
    
    // Debugging functions
    void simulate();
    void printInfo();
    void printMPU6050Info(MPU6050_Sensor);
    void printEMGInfo(EMG_Sensor);
  

  private:
    MPU6050_Sensor MPU6050_sensors[num_MPU6050];
    EMG_Sensor emg_sensor;

    // Sensor Functions
    void setMPU6050Angles(MPU6050_Sensor&  , int[]);
    void setMPU6050Pins(int[]);
    void setEMGValue(int);
    void setEMGPin(int);    
   
};



/************************/
/*** Sensor Functions ***/
/************************/

SensorSystem::SensorSystem(){
  String MPU6050_names[]     = {"shoulder", "elbow", "wrist"};
  int default_MPU6050_pins[] = {13,12,11};
  
  for(int i=0; i<num_MPU6050; i++){
    MPU6050_sensors[i]._name = MPU6050_names[i]; 
    MPU6050_sensors[i].pin   = default_MPU6050_pins[i];
  }
  setEMGPin(10);
  num_sensors = num_MPU6050 + num_EMG;
}

// [0] roll, [1] pitch, [2] yaw
void SensorSystem::setMPU6050Angles(MPU6050_Sensor &s, int angles[]){
  s.roll  = angles[0];
  s.pitch = angles[1];
  s.yaw   = angles[2];
}

// Sets the three MPU6050 sensor pins.
void SensorSystem::setMPU6050Pins(int pins[]){ for(int i=0; i<num_MPU6050; i++){ MPU6050_sensors[i].pin = pins[i]; pinMode(pins[i], INPUT); } }

// Sets the EMG value.
void SensorSystem::setEMGValue(int value){ emg_sensor.value = value; }

// Sets the EMG pin.
void SensorSystem::setEMGPin(int pin){ emg_sensor.pin = pin; }

// Called by instruction interpreter. Sets the MPU6050 sensor and EMG sensor pins. The first 
// num_MPU6050 elements of pins[] are MPU6050 pins, the last element is the EMG pin.  
void SensorSystem::setPins(int pins[]){
  int MPU6050_pins[num_MPU6050] = {0, 0, 0};
  int EMG_pin = pins[num_MPU6050]; // EMG pin is last element of pins[]. [0-2] are MPU6050 pins, [3] is EMG pin.
  for(int i=0; i<num_MPU6050; i++){ MPU6050_pins[i] = pins[i]; } //MPU6050 pins are first 3 elements of pins[].

  setMPU6050Pins(MPU6050_pins);
  setEMGPin(EMG_pin);
}


/*****************************/
/*** Instruction Functions ***/
/*****************************/

String SensorSystem::updateInstruction(){ return makeInstruction(sensorValuesID); }


String SensorSystem::makeInstruction(String instructionID){
  int num_data = 0;
  if(instructionID == sensorPinsID){ num_data = num_sensors; } // 4 Sensors
  else if(instructionID == sensorValuesID){ // 3 MPU6050 Sensors, each has 3 angle values. 1 EMG value.
     num_data = num_MPU6050*MPU6050_sensors[0].num_angles + num_EMG;     
  }
  String instruction = instructionID;
  String sensor_data[num_data]; 

  if(instructionID == sensorPinsID){        
     for(int i=0; i<num_data; i++){ sensor_data[i] = String(MPU6050_sensors[i].pin);   }
     sensor_data[num_MPU6050] = emg_sensor.pin; 
  }
  else if(instructionID == sensorValuesID){ 
    for(int i=0; i<num_data-1; i+= 3){ 
      sensor_data[i] = String(MPU6050_sensors[i].roll); 
      sensor_data[i+1] = String(MPU6050_sensors[i].pitch); 
      sensor_data[i+2] = String(MPU6050_sensors[i].yaw); 
    } 
    sensor_data[num_data-1] = emg_sensor.value;
  }
  for(int i=0; i<num_data; i++){ instruction = instruction + " " + sensor_data[i]; }  
  return instruction;
}


/***************************/
/*** Debugging Functions ***/
/***************************/

// Simulating reading random data. 
void SensorSystem::simulate(){
  randomSeed(analogRead(0));
  
  for(int i=0; i<num_MPU6050; i++){
    int sensor_values[3] = {0,0,0}; // roll, pitch, yaw
    for(int i=0; i<num_MPU6050; i++){ sensor_values[i] = random(1425); }
    setMPU6050Angles(MPU6050_sensors[i], sensor_values);
  }

  setEMGValue(random(132432));
}

// Prints the name, roll, pitch, yaw and pin values of a MPU6050_sensor.
void SensorSystem::printMPU6050Info(MPU6050_Sensor s){
  Serial.print(s._name); Serial.print(" roll("); Serial.print(s.roll); Serial.print(") pitch("); Serial.print(s.pitch);
  Serial.print(") yaw("); Serial.print(s.yaw); Serial.print(") pin("); Serial.print(s.pin); Serial.println(")");
}

void SensorSystem::printEMGInfo(EMG_Sensor s){
  Serial.print(s._name); Serial.print(" value("); Serial.print(s.value); Serial.print(") pin("); Serial.print(s.pin); Serial.println(")");
}

// Debugging function. Used to see all sensor values
void SensorSystem::printInfo(){
  Serial.println("POSITION SYSTEM INFO");
  for(int i=0; i<num_MPU6050; i++){ printMPU6050Info(MPU6050_sensors[i]); }
  printEMGInfo(emg_sensor);
  Serial.println("");
}
