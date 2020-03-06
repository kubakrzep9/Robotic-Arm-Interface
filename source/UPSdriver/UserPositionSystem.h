#include <Wire.h> // library for i2c communication
#include "MPU_6050.h";

class UserPositionSystem{
  private:
    const static int num_gyros = 3; // const: can never change, static: one shared variable for all instances of a class.
    MPU_6050 gyroscopes[num_gyros]; // Can only initialize array of gyroscopes to size num_gyros because num_gyros is const static.

  public:
    int num_gyro_angles; 
    int num_all_angles;

    UserPositionSystem();
    void start();
    void get_all_angles(int[]);
    
};


UserPositionSystem::UserPositionSystem(){
  num_gyro_angles = gyroscopes[0].num_angles;
  num_all_angles = num_gyros * num_gyro_angles; // 3*3=9. two const statics being multiplied
}


// DO NOT CALL IN CONSTRUCTOR
void UserPositionSystem::start(){
  Wire.begin();
  for(int i=0; i<num_gyros; i++){ gyroscopes[i].start(); }
}


// This method returns all the angles from each gyro, 9 in total, through "all_angles". 
//
// An index is a number used to depict where you are in an array. If you are at the zeroeth element your index would be 0.
// In this nested for loop, we are going through each gyroscope and getting all the angles for each gyroscope. i is acting
// as the index to determine which gyroscope we are examining. j is used to determine which angle of a gyroscope we are 
// examining. index is used to determine where we are in the all_angles array.
void UserPositionSystem::get_all_angles(int all_angles[]){
  int index = 0;
  for(int i=0; i<num_gyros; i++){ // going through each gyros
    int gyro_angles[num_gyros];
    gyroscopes[i].get_angles(gyro_angles); // getting gyro i's angles
    for(int j=0; j<num_gyro_angles; j++){ // going through each angle of each gyro
      all_angles[index] = gyro_angles[j]; // adding gyro i's angles to all_angles
      index++;
    }
  }
}
