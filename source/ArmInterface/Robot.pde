// The Robot class is used to maintain all of the arms information such as pins and current servo angle measures. 
//
// All arrays in the Robot class will use a common array format: 
// 
//          [0] Body, [1] Shoulder, [2] Elbow, [3] Wrist, [4] Hand, [5] Hand Rotator

class Robot{
  private static final int num_servos = 6;
  private static final int num_sensors = 1;
  private final String[] servo_names= {"Body", "Shoulder", "Elbow", "Wrist", "Hand", "Hand RTTR"};
  private ArrayList <Servo> servos;
  public Pressure_Gauge ra_pressure;
  private boolean state_received = false;
  private boolean received_pins = false;
  private boolean received_angles = false;
  private String system_id = "RA";
  
  Robot(){     
    servos = new ArrayList(num_servos);
    for(int i=0; i<num_servos; i++){ servos.add(new Servo(servo_names[i])); }
    ra_pressure = new Pressure_Gauge("RA Press");
  }
  
  public String getSystemID(){ return system_id; }
  
  public int getNumServos(){ return num_servos; }
  
  /*** State Functions ***/
  // The state is received when the pin and servo angles are receieved at least once. 
  public boolean get_state_received(){ return state_received; }
  public void set_state_received(boolean state){ state_received = state; }
  public boolean check_state(){ return received_pins && received_angles; }
  
  /*** Servo (as a group) Functions ***/
  // Setter and getter functions for the servo angles and pins in the robotic arm 
  // All arrays follow the format: [0] Body, [1] Shoulder, [2] Elbow, [3] Wrist, [4] Hand, [5] Hand Rotator
    
  // Name getter
  public String[] getServoNames(){ return servo_names; }
  
  // Angle getter
  public int[] getServoAngles(){
    int[] current_values = new int[num_servos];
    for(int i=0; i< num_servos; i++){ current_values[i] = servos.get(i).getAngle(); }
    return current_values;
  }
  
  // Pin getter
  public int[] getServoPins(){
    int[] pins = new int[num_servos];
    for(int i=0; i< num_servos; i++){ pins[i] = servos.get(i).getPin(); }
    return pins;
  }  
  
  // Angle setter
  public void setServoAngles(int angles[]){
    if(angles.length != num_servos){ return; }
    for(int i=0; i< num_servos; i++){ servos.get(i).setAngle(angles[i]); }
    if(!received_angles){ received_angles = true; }
  }
 
  
  //Pin setter
  public void setServoPins(int pins[]){
    if(pins.length != num_servos){ return; }
    for(int i=0; i< num_servos; i++){ servos.get(i).setPin(pins[i]); }
    if(!received_pins){ received_pins = true; }
  }
  
  
  
  
  // Main class methods to interact with data
  
  public int[] getValues(){
    int all_values[] = new int[num_servos+num_sensors];
    int servo_values[] = getServoAngles();
    for(int i=0; i<num_servos; i++){ all_values[i] = servo_values[i]; }
    all_values[num_servos] = ra_pressure.getValue();
    return all_values;  
  }
  
  public int[] getPins(){
    int all_pins[] = new int[num_servos+num_sensors];
    int servo_pins[] = getServoPins();
    for(int i=0; i<num_servos; i++){ all_pins[i] = servo_pins[i]; }
    all_pins[num_servos] = ra_pressure.getPin();
    return all_pins;  
  }
  
  public void setPins(int all_pins[]){
    int servo_pins[] = new int[num_servos];
    // elements 0 - 5 are servo pins
    for(int i=0; i<num_servos; i++){servo_pins[i] = all_pins[i]; }
    setServoPins(servo_pins);
    ra_pressure.setPin(all_pins[num_servos]);
  }

  public void setValues(int all_values[]){
    int servo_values[] = new int[num_servos];
    // elements 0 - 5 are servo pins
    for(int i=0; i<num_servos; i++){servo_values[i] = all_values[i]; }
    setServoAngles(servo_values);
    ra_pressure.setValue(all_values[num_servos]);
  }
}
