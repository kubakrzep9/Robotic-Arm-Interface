// The Position_System class is used to maintain all of the sensors information such as pins and current values. 
//
// All arrays in the Position_System class will use a common array format: 
// 
//         [0] Flex, [1] EMG, [2] Gyro

class Position_System{
  private final String[] sensor_names= {"S. Gyro", "E. Gyro", "W. Gyro", "EMG"};
    
  private ArrayList<MPU6050_Sensor> gyroscopes;
  private EMG_Sensor emg;
  
  private boolean state_received = false;
  private boolean received_pins = false;
  private boolean received_values = false;
  
  private int num_data; 
  private int num_gyro_angles;
  
  public int num_sensors;
  public int num_MPU6050;
  public int num_emg;
  
  
  Position_System(){ 
    num_sensors = sensor_names.length; // same as num_MPU6050 + num_emg
    num_MPU6050 = 3;
    num_emg = 1;
    gyroscopes = new ArrayList(num_sensors);
    for(int i=0; i<num_MPU6050; i++){ 
      MPU6050_Sensor gyro = new MPU6050_Sensor(sensor_names[i]);
      gyroscopes.add(gyro); 
    }
    num_gyro_angles = gyroscopes.get(0).num_angles;
    num_data = (num_MPU6050*num_gyro_angles)+num_emg;
    emg = new EMG_Sensor(sensor_names[num_MPU6050]); 
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
  
  public String[] getGyroAngleNames(){ return gyroscopes.get(0).getAngleNames();};
  
  // Value getter
  public int[] getSensorValues(){
    int values[] = new int[num_data];
    for(int i=0; i<num_MPU6050; i++){ 
      int angles[] = gyroscopes.get(i).getAngles();
      for(int j=0; j<num_gyro_angles; j++){ values[i] = angles[j];}
    }
    values[num_data-1] = emg.getValue(); 
    return values;
  }
  
  // Pin getter
  public int[] getSensorPins(){ 
    int pins[] = new int [num_sensors];
    for(int i=0; i<num_MPU6050; i++){ pins[i] = gyroscopes.get(i).getPin(); }
    pins[num_MPU6050] = emg.getPin();
    return pins;
  }
  
  // Value setter
  public void setSensorValues(int[] vals){ 
    if(vals.length != num_data){ return; }
    for(int i=0; i<num_MPU6050; i+=3){ 
      int angles[] = {vals[i], vals[i+1], vals[i+2]};
      gyroscopes.get(i).setAngles(angles); 
    } 
    emg.setValue(vals[num_data-1]);
    if(!received_values){ received_values = true; }
  }
  
  // Pin setter
  public void setSensorPins(int[] pins){ 
    if(pins.length != num_sensors){ return; }
    for(int i=0; i<num_MPU6050; i++){ gyroscopes.get(i).setPin(pins[i]); }
    emg.setPin(pins[num_MPU6050]);
    if(!received_pins){ received_pins = true; }
  }   
 
 
 
 
  class EMG_Sensor{
    private int pin;
    private int value;
    private String _name;
    
    EMG_Sensor(String n){
      pin = 0;
      value = 0;
      _name = n;
    }
    
    //Setters and getters
    void setPin(int p){ pin = p;        }
    int getPin(){ return pin;           }
    void setValue(int v){ value = v;    }
    int getValue(){ return value;       }
    void set_Name(String n){ _name = n; }
    String get_Name(){ return _name;    }
  };
 
 
  
  class MPU6050_Sensor{
    private int num_angles;
    private int pin;
    private int roll;
    private int pitch;
    private int yaw;
    private String name;
    private String[] angle_names = {"roll", "pitch", "yaw"};
    
    MPU6050_Sensor(String _name){
      num_angles = 3;
      pin        = 0;
      roll       = 0;
      pitch      = 0;
      yaw        = 0; 
      name       = _name;
    }  
    
    // Setters and getters 
    public int[] getAngles(){ 
      int angles[] = {roll, pitch, yaw}; 
      return angles; 
    } 
    public void setAngles(int angles[]){ 
      roll  = angles[0];
      pitch = angles[1];
      yaw   = angles[2];
    }
    public String[] getAngleNames(){ return angle_names; }
    public int getPin(){ return pin;                     }
    public void setPin(int _pin){ this.pin = _pin;       }
    public String get_Name(){ return name;               }
    public void set_Name(String _name){ name = _name;    }
  }
}
