#include <MPU6050.h>
#include "MPU_6050.h" // library for accelerometer and gyroscope 
#include <Wire.h> // library for i2c communication
#include <Servo.h> // library for servo

Servo wrist;
int16_t pitch;
MPU_6050 sensor;

void setup() {
Serial.begin(9600);
Wire.begin();
sensor.initial(2);
}
void loop() {
pitch = sensor.get_Pitch();
delay(200);
sensor.wrist.write(pitch); 


}
