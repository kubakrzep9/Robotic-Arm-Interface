//#include <Wire.h> // library for i2c communication
#include <Servo.h> // library for servo
#include <MPU6050.h>


class MPU_6050 {
  public:
    const static int num_angles = 3; // number of angles a gyro can read. roll(x), pitch(y), yaw(z) 
    MPU6050 sensor;     
    int16_t accel[num_angles]; // [0]:x, [1]:y, [2]:z
    int16_t gyro[num_angles];  // [0]:x, [1]:y, [2]:z
    
    void start();
    void get_angles(int[]);

  private:
    void map_to_angles(int16_t[], int[]);
    void get_record_current();
    
};


/**********************/
/*** PUBLIC METHODS ***/
/**********************/


// DO NOT CALL IN ANY CONSTRUCTOR
void MPU_6050::start(){
  sensor.initialize();
}


// Sets "angles" to either the set of current accel or gyro values.
void MPU_6050::get_angles(int angles[]){
  get_record_current();
  map_to_angles(accel, angles); // use either accel or gyro 
}


/***********************/
/*** PRIVATE METHODS ***/
/***********************/


// Note casting from int16_t (unsigned) to int (signed). 
// Don't think this should be an issue. 
void MPU_6050::map_to_angles(int16_t data[], int mapped_angles[]){
  for(int i=0; i<num_angles; i++){
    mapped_angles[i] = map(data[i], -17000, 17000, 0, 180);
  }
}


// Getting raw x,y,z values from gyroscope & accelerometer.
void MPU_6050::get_record_current() { // get motion function in class
  sensor.getMotion6(accel[0], accel[1], accel[2], gyro[0], gyro[1], gyro[2]);
  delay(20); // Necessary? Maybe not...  
}
