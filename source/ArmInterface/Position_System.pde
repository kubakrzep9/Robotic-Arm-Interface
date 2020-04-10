// The Position_System class is used to maintain all of the sensors information such as pins and current values. 
//
// All value arrays in the Position_System class will use a common array format: 
// // [0] sg_r, [1] sg_p, [2] sg_y, [3] eg_r, [4] eg_p, [5] eg_y, [6] wg_r, [7] wg_p, [8] wg_y, [9] pressure 

class Position_System{
  private final String[] sensor_names= {"S. Gyro", "E. Gyro", "W. Gyro"};
    
  private ArrayList<MPU6050_Sensor> gyroscopes;
  public Pressure_Gauge ups_pressure;
  
  private boolean state_received = false;
  private boolean received_pins = false;
  private boolean received_values = false;
  
  private int num_data; 
  private int num_gyro_angles;
  private int num_total_gyro_angles;
  
  public int num_sensors;
  public int num_MPU6050;
  public int num_pressure;
  public int num_values;
  private String system_id = "UPS";
  private String mode;
  
  Position_System(){ 
    mode = "manual";
    num_MPU6050 = 3;
    num_pressure = 1;
    num_sensors = num_MPU6050 + num_pressure;
    num_values = (num_MPU6050 * MPU6050_Sensor.num_angles)+num_pressure;
    gyroscopes = new ArrayList(num_sensors);
    for(int i=0; i<num_MPU6050; i++){ 
      MPU6050_Sensor gyro = new MPU6050_Sensor(sensor_names[i]);
      gyroscopes.add(gyro); 
    }
    num_gyro_angles = MPU6050_Sensor.num_angles;
    num_total_gyro_angles = num_MPU6050 * num_gyro_angles;
    num_data = num_total_gyro_angles+num_pressure;
    ups_pressure = new Pressure_Gauge("UPS Press");
  }
  
  public boolean setMode(String m){
    if(m.equals("auto") || m.equals("manual")){ mode = m; return true; } 
    else{ return false; }
  }
  
  public String getMode(){ return mode; }
  
  public String getSystemID(){ return system_id; }
  
  /*** State Functions ***/
  // The state is received when the pin and sensor values are receieved at least once. 
  public boolean get_state_received(){ return state_received; }
  public void set_state_received(boolean state){ state_received = state; }
  public boolean check_state(){ return received_pins && received_values; }
  
  /*** Sensor (as a group) Functions ***/
  // Setter and getter functions for the values and pins in the postion system. 
  // All arrays follow the format: [0] Flex, [1] EMG, [2]Gyro.
  
  // Name getter
  public String[] getSensorNames(){ return sensor_names; }
  
  public String[] getGyroAngleNames(){ return gyroscopes.get(0).getAngleNames();};
  
  // Value getter
  public int[] getValues(){
    int values[] = new int[num_data];
    int val_i = 0;
    for(int i=0; i<num_MPU6050; i++){ 
      int angles[] = gyroscopes.get(i).getAngles();
      for(int j=0; j<num_gyro_angles; j++){ values[val_i] = angles[j]; val_i++; }
    }
    values[num_MPU6050] = ups_pressure.getValue();
    return values;
  }
  
  // Pin getter
  public int[] getPins(){ 
    int pins[] = new int [num_sensors];
    for(int i=0; i<num_MPU6050; i++){ pins[i] = gyroscopes.get(i).getPin(); }
    pins[num_MPU6050] = ups_pressure.getPin();
    return pins;
  }
  
  // Value setter
  public void setValues(int[] vals){   
    if(vals.length != num_data){ return; }
    int val_i = 0;
    for(int i=0; i<num_MPU6050; i++){ 
      int angles[] = {vals[val_i], vals[val_i+1], vals[val_i+2]}; val_i += 3; 
      gyroscopes.get(i).setAngles(angles); 
    } 
    ups_pressure.setValue(vals[num_total_gyro_angles]);
    if(!received_values){ received_values = true; }  
  }
  
  // Pin setter
  public void setPins(int[] pins){ 
    if(pins.length != num_sensors){ return; }
    for(int i=0; i<num_MPU6050; i++){ gyroscopes.get(i).setPin(pins[i]); }
    ups_pressure.setPin(pins[num_MPU6050]);
    if(!received_pins){ received_pins = true; }
  }   
}
