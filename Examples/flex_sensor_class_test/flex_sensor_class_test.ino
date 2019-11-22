#include "flex_sensor.h"

Flex_Sensor flex_sensor("Hello from constructor", A0);

void setup() {
  Serial.begin(9600);
  flex_sensor.print_info();
}

void loop() {
  // put your main code here, to run repeatedly:

}
