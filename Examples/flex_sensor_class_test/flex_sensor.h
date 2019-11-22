class Flex_Sensor{
  private:
    int flex_pin = A0;
    const float VCC = 4.98;
    const float R_DIV = 99800;  
    const float STRAIGHT_RESISTANCE = 33900;
    //const float BEND_RESISTANCE = 

  public:
    Flex_Sensor(){
      
    }

    Flex_Sensor(String text, int f_pin){
      Serial.println(text);

      flex_pin = f_pin;
    }

    void print_info();  
};

void Flex_Sensor::print_info(){
  Serial.print("Voltage: ");
  Serial.println(VCC);
}  
