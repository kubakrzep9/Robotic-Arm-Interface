// GUI_Settings contains the general GUI elements and settings. The home screen 
// display section and options menu are defined here. All text not on dynamic
// features (those are in the Widgets class) are here. 

class GUI_Settings{ 
  private int MAX_WIDTH = 1000;
  private int MAX_HEIGHT = 1000;
  private int GUI_WIDTH  = 750;
  private int GUI_HEIGHT = 310;
  
  private boolean auto_mode = false;
  private boolean options_mode = false;
 
  private Position_System position_system;
  private Robot robot;

  public boolean get_auto_mode(){ return auto_mode; }
  public void set_auto_mode(boolean bool){ auto_mode = bool; }
  public boolean get_options_mode(){ return options_mode; }
  public void set_options_mode(boolean bool){ options_mode = bool; }

  GUI_Settings(Position_System ps, Robot r){
   this.position_system = ps;
   this.robot = r;
   setup_GUI();
  }

  // Initializes the max gui size.
  void setup_GUI(){ surface.setSize(MAX_WIDTH, MAX_HEIGHT); }
 
  /***********************/
  /*** GUI Main Screen ***/
  /***********************/
  
  // Displays the main (home) screen of the GUI. The main screen displays 
  void main_screen(){
    int heading_font = 1;
    int text_font    = 2;

    // Screen initialization
    background(247, 247, 247);   
    surface.setSize(GUI_WIDTH, GUI_HEIGHT);
    
    /**************************************************************************************/
    /*** Display Section - left side of interface, displays all sensor and servo values ***/
    /**************************************************************************************/
    
    // Posiiton sensor names and values
    int header_y = 30;
    int sensor_x = 35;
    int sensor_y = 50;
    String sensor_names[] = position_system.getSensorNames();
    String value_names[]  = position_system.getGyroAngleNames();
    int sensor_values[]   = position_system.getSensorValues(); // first 9 are gyros 10 is emg
    int num_MPU6050  = position_system.num_MPU6050;
    int num_angles   = value_names.length;
    int name_indent  = 20;
    int value_indent = name_indent+50;
    
    int val_i = 0;
    int i = 0;
    display_text("POSITION SENSORS", 75, header_y, CENTER, fonts.get(heading_font));
    for(; i<num_MPU6050; i++){ 
      sensor_y = 50+(i*70);
      display_text(sensor_names[i],    sensor_x,    sensor_y, LEFT, fonts.get(text_font)); // sensor names
      for(int j=0; j<num_angles; j++, val_i++){  
        display_text(value_names[j],   sensor_x+name_indent, sensor_y+17*(j+1), LEFT, fonts.get(text_font)); // angle names   
        display_text(sensor_values[val_i], sensor_x+value_indent, sensor_y+17*(j+1), LEFT, fonts.get(text_font)); // sensor values
      } 
    }
    
    
    
    int emg_y = 275;
    display_text(sensor_names[i],  sensor_x,              emg_y, LEFT, fonts.get(text_font)); // sensor names
    display_text(sensor_values[val_i], sensor_x+value_indent, emg_y, LEFT, fonts.get(text_font)); // sensor values

    // Robotic arm servo names and values
    int margin = 25;
    int servo_x = 170;
    int servo_y = 50;
    String[] servo_names  = robot.getServoNames();
    int[]    servo_angles = robot.getServoAngles();
    
    int num_servos = Robot.num_servos;
    display_text("ROBOTIC ARM", 205, header_y, CENTER, fonts.get(heading_font));
    for(i=0; i<num_servos; i++){
      display_text(servo_names[i],  servo_x, servo_y+margin*(i), LEFT, fonts.get(text_font)); // servo names
      display_text(servo_angles[i], servo_x+70, servo_y+margin*(i), LEFT, fonts.get(text_font)); // servo values
    }
    
    // White mode box and text
    int mode_x = 420;
    int mode_y = 290;
    stroke(255, 255, 255);
    fill(255, 255, 255);   
    rect(320, 280, 195, 15); // x, y, w, h
    if(auto_mode){ display_text("MODE: AUTO ",  mode_x, mode_y, CENTER, fonts.get(text_font)); }
    else{          display_text("MODE: MANUAL", mode_x, mode_y, CENTER, fonts.get(text_font)); }
    
    // Options menu
    if(options_mode){
      int options_y = 126;    

      /************************************************************************************************/
      /*** Options Menu - "One time settings". Should only need to set values in options menu once. ***/
      /************************************************************************************************/
      
      int header_x = 320; //500
      display_text("PORT SELECTION", header_x, header_y, LEFT, fonts.get(heading_font));
      display_text("PIN SELECTION",  header_x, 90,       LEFT, fonts.get(heading_font));
      
      display_text("POSITION SENSORS",   680, header_y+20, CENTER, fonts.get(text_font));
      display_text("ROBOTIC ARM",        525, header_y+20, CENTER, fonts.get(text_font));

      int sensor_pin_x = 630;
      int servo_pin_x = 335; 
      int[] sensor_pins = position_system.getSensorPins();
      int[] servo_pins  = robot.getServoPins();
      int num_sensors = sensor_names.length;
      int servo_iterations = num_servos/2; // 2 columns of 3 pins
      
      for(i=0; i<num_sensors; i++){
        display_text(sensor_names[i],  sensor_pin_x,      options_y+margin*(i), LEFT, fonts.get(text_font)); // sensor names 
        display_text(sensor_pins[i],   sensor_pin_x+60,   options_y+margin*(i), LEFT, fonts.get(text_font)); // sensor pins
      }
    
      // Iterates 3 times, placing essentially 3 columns of text
      for(i=0; i<servo_iterations; i++){
        display_text(servo_names[i],   servo_pin_x,       options_y+margin*(i), LEFT, fonts.get(text_font)); // servo names
        display_text(servo_pins[i],    servo_pin_x+60,    options_y+margin*(i), LEFT, fonts.get(text_font)); // servo pins
        display_text(servo_names[i+3], servo_pin_x + 135, options_y+margin*(i), LEFT, fonts.get(text_font)); // servo names
        display_text(servo_pins[i+3],  servo_pin_x+ 215,  options_y+margin*(i), LEFT, fonts.get(text_font)); // servo pins
      }
    }    
  }
  
  /*************************************/
  /*** GUI display helper functions ****/
  /*************************************/
  
  // Used to format the font and alignment of a string as text.
  public void display_text(String text, int xcoord, int ycoord, int alignment, PFont f){
    fill(0, 0, 0);
    textFont(f);
    textAlign(alignment);
    text(text, xcoord, ycoord);   
  }
  
  // Used to format the font and alignment of an integer as text.
  public void display_text(int num, int xcoord, int ycoord, int alignment, PFont f){
    fill(0, 0, 0);
    textFont(f);
    textAlign(alignment);
    text(num, xcoord, ycoord);  
  }
  
  // Dispay format function, used to wrap integer data between [  ].  
  public String format_int_data(int val){ String str = "[ " + Integer.toString(val) + " ]"; return str; }
}
