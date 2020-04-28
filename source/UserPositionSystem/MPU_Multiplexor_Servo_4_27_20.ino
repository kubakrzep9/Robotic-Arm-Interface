
#include <MPU6050.h>
#include <Wire.h> // library for i2c communication
#include <Servo.h> // library for servo
Servo wrist;
Servo elbow;
int servo_pin1 = 1;
int servo_pin2 = 2;
MPU6050 mpu;
int16_t ax, ay, az; // the values will be unsigned 16 bit integers
int16_t gx, gy, gz;
int16_t wrist_roll; 
int16_t elbow_pitch;


void TCA9548A(uint8_t bus)
{
  Wire.beginTransmission(0x70);  // TCA9548A address is 0x70
  Wire.write(1 << bus);          // send byte to select bus (bus #1, for example, is SDA1 SCL1 on multiplexor)
  Wire.endTransmission();
}

void setup() {
  Wire.begin();
  Serial.begin(9600);
  wrist.attach(servo_pin1);
  elbow.attach(servo_pin2);

  TCA9548A(1); // Set multiplexer to bus 1
  mpu.initialize(); // initializing sensor on bus 1
  
  TCA9548A(2); // Set multiplexer to bus 2
  mpu.initialize(); // initializing sensor on bus 2 
  

}

void loop() {
  TCA9548A(1);
  mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz); // getting raw x,y,z values from gyroscope & accelerometer on bus 1
 
  wrist_roll = map(ax, -17000, 17000, 0, 180); // wrist motion mapped to degrees

  Serial.print("#1 ax: ");
  Serial.println(ax); // printing value (for test)
  Serial.print("Wrist roll: ");
  Serial.println(ax); // printing value (for test)
  
  wrist.write(wrist_roll); // wrist is failing but values on serial look okay
  
  TCA9548A(2);
  mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz); // getting values on bus 2
  
  elbow_pitch = map(ay, -17000, 17000, 0, 180); // wrist motion mapped to degrees
  
  Serial.print("#2 ay: ");
  Serial.println(ay); // printing value (for test)
  Serial.print("Elbow Pitch: ");
  Serial.println(elbow_pitch); // printing value (for test)
  
  elbow.write(elbow_pitch); // Elbow works fine 
  delay(1000); 
}
