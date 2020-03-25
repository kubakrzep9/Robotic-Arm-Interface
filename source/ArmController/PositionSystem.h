#ifndef POSITION_SYSTEM_H
#define POSITION_SYSTEM_H

class PositionSystem{
  public: 
    static const int num_sensors = 1;
    // will be replaced by julias pressure gauge object
    int pin = 0;
    int value = 10;
    
    void set_pin(int p);
    int get_pin ();
    int get_value();
};


void PositionSystem::set_pin(int p){ pin = p; }

int PositionSystem::get_pin(){ return pin; }

int PositionSystem::get_value(){ return value; }

#endif
