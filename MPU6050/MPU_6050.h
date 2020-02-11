#include <Wire.h> // library for i2c communication
#include <Servo.h> // library for servo
#include <MPU6050.h>
class MPU_6050 
{
  public:
    Servo wrist;
    MPU6050 sensor;
    int16_t ax, ay, az; // the values will be unsigned 16 bit integers
    int16_t gx, gy, gz;
    int16_t roll;
    int16_t pitch;

    void initial(int servo_pin){
      Wire.begin();
      sensor.initialize();
      wrist.attach(servo_pin);
    }
   
  
     void get_Gyro(int16_t g[]) { // get motion function in class

     sensor.getMotion6(&ax, &ay, &az, &gx, &gy, &gz); // getting raw x,y,z values from gyroscope & accelerometer
     delay(200);
     g[0] = gx;
     g[1] = gy;
     g[2] = gz;
   }
    void get_Acceleration(int16_t a[]) { // get motion function in class
     sensor.getMotion6(&ax, &ay, &az, &gx, &gy, &gz); // getting raw x,y,z values from gyroscope & accelerometer
     delay(200);
     a[0] = ax;
     a[1] = ay; 
     a[2] = az;
   }
   
     int16_t get_Pitch() { // get pitch function in class

     sensor.getMotion6(&ax, &ay, &az, &gx, &gy, &gz); // getting raw x,y,z values from gyroscope & accelerometer
     pitch = ay;
      pitch = map(ay, -17000, 17000, 0, 180);
     return pitch;
   }
      int16_t get_Roll() { // get roll function in class

     sensor.getMotion6(&ax, &ay, &az, &gx, &gy, &gz); // getting raw x,y,z values from gyroscope & accelerometer
     delay(200);
     roll = map(ax, -17000, 17000, 0, 180);;
     return roll;
   }
    
};
