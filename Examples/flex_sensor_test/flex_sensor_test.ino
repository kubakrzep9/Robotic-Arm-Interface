#include <Servo.h>

Servo servo;
int servo_pin = 9;

int flex_pin = A0;
int flex_value = 0;
int servo_position = 0;
int THRESHOLD = 10;


void setup() {
  Serial.begin(9600);
  //pinMode(flex_pin, OUTPUT);
  servo.attach(servo_pin);
}

void loop() {
  flex_value = analogRead(flex_pin);
  servo_function();
  print_info();
  delay(500);
}

void servo_function(){
  // save as temp if it passes threshold save it
  servo_position = map(flex_value, 125, 450, 0, 180); 
  if(servo_position >= 0 && servo_position <= 180){ 
    servo.write(servo_position); 
   }
  
}

void print_info(){
  Serial.print("Flex value: ");
  Serial.println(flex_value);
  Serial.print("   Servo angle: ");
  Serial.println(servo_position);
}
