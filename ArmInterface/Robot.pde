// The Robot class is used to maintain all of the arms information such as pins and current servo angle measures. 
//
// All arrays in the Robot class will use a common array format: 
// 
//          [0] Body, [1] Shoulder, [2] Elbow, [3] Wrist, [4] Hand, [5] Hand Rotator

class Robot{
  private static final int num_servos = 6;
  private final String[] servo_names= {"Body", "Shoulder", "Elbow", "Wrist", "Hand", "Hand RTTR"};
  private ArrayList <Servo> servos;
  private boolean state_received = false;
  private boolean received_pins = false;
  private boolean received_angles = false;
  
  Robot(){     
    servos = new ArrayList(num_servos);
    for(int i=0; i<num_servos; i++){ servos.add(new Servo(servo_names[i])); }
  }
  
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
  
  
  
  // Subclass for the Robot class. The robotic arm is made up of 6 servos that control the 
  // arm's motion. 
  class Servo{
    private int pin;
    private int angle;
    private String _name;
    
    Servo(String n){
      pin = 0;
      angle = 0;
      _name = n;
    }
    
    // Setters and Getters for servo data members. 
    private int getAngle(){ return angle;              }
    private void setAngle(int a){ angle = a;           }
    private int getPin(){ return pin;                  }
    private void setPin(int p){ pin = p;               }
    private String get_name(){ return _name;           }
    private void set_name(String n){ _name = n;        }
  }
}
