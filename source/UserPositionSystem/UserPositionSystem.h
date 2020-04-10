#ifndef USER_POSITION_SYSTEM_H
#define USER_POSITION_SYSTEM_H


class UserPositionSystem{
  public:
    static const int num_gyros = 3;
    static const int num_gyro_angles = 3;
    static const int num_gyro_values = num_gyros * num_gyro_angles;
    static const int num_pressure = 1;
    static const int num_all_sensors = num_gyros + num_pressure;
    static const int num_all_values  = num_gyros * num_gyro_angles + num_pressure;
    
    UserPositionSystem();
    void setPins(int[]);
    void getData(String, int[]);
    void setMode(String);
    String getMode();

    //////////////////////////////////////////////////////////
    // JAKUB TESTING VARIABLES.                             //
    // These represent the values and pins that would be    //
    // taken from the Gyroscope and Pressure_Gauge classes. //
    int _pins[num_all_sensors];                             //
    int _values[num_all_values];                            //
    ///////////////////////////////////////////////////////////

  private:
    String mode = "";
    //Gyroscope gyros[num_gyros];    // Sophies class  
    //Pressure_Gauge pressure_gauge; // Julias class 
};


UserPositionSystem::UserPositionSystem(){
  //////////////////
  // TESTING ONLY //
  //////////////////
  for(int i=0; i<num_all_values; i++){ _values[i] = i; /*((i*i)-3)*i;*/ } // assigning random values.
  mode = "manual"; //default
}



void UserPositionSystem::setPins(int pins[]){ 
  for(int i=0; i<num_gyros; i++){
    //gyros[i].pin = default_pins[i];
  }

  //pressure_gauge.pin = default_pins[num_gyros]; 

  //////////////////
  // TESTING ONLY //
  //////////////////
  for(int i=0; i<num_all_sensors; i++){ _pins[i] = pins[i]; }
}


void UserPositionSystem::getData(String type, int return_array[]){
  if(type == "values"){
    // Call method to get current readings. Method should save those 
    // readings into the respective gyroscope angle variables. 
    for(int i=0; i<num_gyros; i++){ 
      // return_array[i] = gyros[i].roll; 
      // return_array[i+1] = gyros[i].pitch; 
      // return_array[i+2] = gyros[i].yaw; 
    }
    // return_array[num_gyros] = pressure_gauge.pin;

    //////////////////
    // TESTING ONLY //
    //////////////////
    for(int i=0; i<num_all_values; i++){ return_array[i] = _values[i]; } 
  }
  else if(type == "pins"){ 
    for(int i=0; i<num_gyros; i++){ 
      // return_array[i] = gyros[i].pin; 
    }
    // return_array[num_gyros] = pressure_gauge.pin;

    //////////////////
    // TESTING ONLY //
    //////////////////
    for(int i=0; i<num_all_sensors; i++){ return_array[i] = _pins[i]; } 
  }
}

void UserPositionSystem::setMode(String m){
  if(m == "auto" || m == "manual"){ mode = m; }
}

String UserPositionSystem::getMode(){ return mode; }

#endif
