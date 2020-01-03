// The Position_System class is used to maintain all of the sensors information such as pins and current values. 
//
// All arrays in the Position_System class will use a common array format: 
// 
//         [0] Flex, [1] EMG, [2] Gyro

class Position_System{
  private final String[] sensor_names= {"Flex", "EMG", "Gyro"};
  ArrayList<Sensor> sensors;
  int num_sensors;
  private boolean state_received = false;
  private boolean received_pins = false;
  private boolean received_values = false;
  
  Position_System(){    
    num_sensors = sensor_names.length;
    sensors = new ArrayList(num_sensors);
    for(int i=0; i<num_sensors; i++){ 
      Sensor sensor = new Sensor(sensor_names[i]);
      sensors.add(sensor); 
    }
  }
  
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
  
  // Value getter
  public int[] getSensorValues(){
    int values[] = new int[num_sensors];
    for(int i=0; i<num_sensors; i++){ values[i] = sensors.get(i).get_value(); } 
    return values;
  }
  
  // Pin getter
  public int[] getSensorPins(){ 
    int pins[] = new int [num_sensors];
    for(int i=0; i<num_sensors; i++){ pins[i] = sensors.get(i).get_pin(); }
    return pins;
  }
  
  // Value setter
  public void setSensorValues(int[] vals){ 
    if(vals.length != num_sensors){ return; }
    for(int i=0; i<num_sensors; i++){ sensors.get(i).set_value(vals[i]); } 
    if(!received_values){ received_values = true; }
  }
  
  // Pin setter
  public void setSensorPins(int[] pins){ 
    if(pins.length != num_sensors){ return; }
    for(int i=0; i<num_sensors; i++){ sensors.get(i).set_pin(pins[i]); } 
    if(!received_pins){ received_pins = true; }
  }   
 
 
 
  // Generic Sensor subclass to store information about the sensors in the Positioning System.
  class Sensor{
    private int value;
    private int pin;
    private String name = "null";
    
    Sensor(String _name){
      value = 0;
      pin   = 0;
      name  = _name; 
    }  
    
    // Setters and getters for Sensor data members. 
    public int get_value(){ return value; }
    private void set_value(int val){ this.value = val; }
    public int get_pin(){ return pin; }
    private void set_pin(int val){ this.pin = val; }
    public String get_name(){ return name; }
    private void set_name(String _name){ name = _name; }
  }
}
