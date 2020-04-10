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



class Pressure_Gauge{
  private int pin;
  private int value;
  private String _name;
  
  Pressure_Gauge(String n){
    pin = 0;
    value = 0;
    _name = n;
  }
  
  //Setters and getters
  private void setPin(int p){ pin = p;        }
  public int getPin(){ return pin;           }
  private void setValue(int v){ value = v;    }
  public int getValue(){ return value;       }
  private void set_Name(String n){ _name = n; }
  public String get_Name(){ return _name;    }
};
 
 

class MPU6050_Sensor{
  public static final int num_angles = 3;
  private int pin;
  private int roll;
  private int pitch;
  private int yaw;
  private String name;
  private String[] angle_names = {"roll", "pitch", "yaw"};
  
  MPU6050_Sensor(String _name){
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
