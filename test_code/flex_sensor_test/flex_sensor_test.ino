int flex_pin = A0;
int flex_value = 0;
int servo_position = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  flex_value = analogRead(flex_pin);
  servo_position = map(flex_value, 600, 900, 0, 180); 
  print_info();
  delay(500);
}

void print_info(){
  Serial.print("Flex value: ");
  Serial.print(flex_value);
  Serial.print("   Servo angle: ");
  Serial.println(servo_position);
}
