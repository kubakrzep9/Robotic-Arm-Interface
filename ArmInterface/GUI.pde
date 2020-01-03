// GUI_Settings contains the general GUI elements and settings. The home screen 
// display section and options menu are defined here. All text not on dynamic
// features (those are in the Widgets class) are here. 

class GUI_Settings{ 
  private int MAX_WIDTH = 1000;
  private int MAX_HEIGHT = 1000;
  private int GUI_WIDTH  = 700;
  private int GUI_HEIGHT = 290;
  
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
    int margin   = 25;
    int header_y = 25;
    int sensor_x = 20;
    int sensor_y = 60;
    String sensor_names[] = position_system.getSensorNames();
    int sensor_values[] = position_system.getSensorValues();
    int size = sensor_names.length;
    display_text("POSITION SENSORS", 75, header_y, CENTER, fonts.get(heading_font));
    for(int i=0; i<size; i++){ 
      display_text(sensor_names[i], sensor_x, sensor_y+margin*(i), LEFT, fonts.get(text_font)); // sensor names
      display_text(/*format_int_data(sensor_values[i])*/sensor_values[i], sensor_x+margin*2, sensor_y+margin*(i), LEFT, fonts.get(text_font)); // sensor values
    }

    // Robotic arm servo names and values
    int servo_x = 145;
    String[] servo_names  = robot.getServoNames();
    int[]    servo_angles = robot.getServoAngles();
    
    size = Robot.num_servos;
    display_text("ROBOTIC ARM", 200, header_y, CENTER, fonts.get(heading_font));
    for(int i=0; i<size; i++){
      display_text(servo_names[i], servo_x+15, sensor_y+margin*(i), LEFT, fonts.get(text_font)); // servo names
      display_text(/*format_int_data(servo_angles[i])*/servo_angles[i], servo_x+90, sensor_y+margin*(i), LEFT, fonts.get(text_font)); // servo values
    }
    
    // White mode box and text
    int mode_x = 395;
    int mode_y = 268;
    stroke(255, 255, 255);
    fill(255, 255, 255);   
    rect(320, 255, 145, 15); // x, y, w, h
    if(auto_mode){ display_text("MODE: AUTO ", mode_x, mode_y, CENTER, fonts.get(text_font)); }
    else{ display_text("MODE: MANUAL", mode_x, mode_y, CENTER, fonts.get(text_font)); }
    
    // Options menu
    if(options_mode){
      int options_x = 335;
      int options_y = 115; 
      int gap = 100;
      
      size = sensor_names.length; // 3 sensors --> (6 servos)/(2 columns). 

      /************************************************************************************************/
      /*** Options Menu - "One time settings". Should only need to set values in options menu once. ***/
      /************************************************************************************************/
      
      int header_x = 500;
      display_text("PORT SELECTION", header_x, header_y, CENTER, fonts.get(heading_font));
      display_text("PIN SELECTION", header_x, 90, CENTER, fonts.get(heading_font));
      
      display_text("POSITION SENSORS",   /*380*/410, header_y+20, CENTER, fonts.get(text_font));
      display_text("ROBOTIC ARM",   /*620*/590, header_y+20, CENTER, fonts.get(text_font));

      int space = 40; 
      int gap_between_servo_pins = 130;
      int servo_pin_x = 490; 
      int[] sensor_pins = position_system.getSensorPins();
      int[] servo_pins  = robot.getServoPins();
    
      // Iterates 3 times, placing essentially 3 columns of text
      for(int i=0; i<size; i++){
        display_text(sensor_names[i], options_x, options_y+margin*(i), LEFT, fonts.get(text_font));                                                              // sensor names 
        display_text(/*format_int_data(sensor_pins[i])*/sensor_pins[i], options_x+space, options_y+margin*(i), LEFT, fonts.get(text_font));                      // sensor pins
        display_text(servo_names[i], options_x+gap, options_y+margin*(i), LEFT, fonts.get(text_font));                                                           // servo names
        display_text(/*format_int_data(servo_pins[i])*/servo_pins[i], servo_pin_x, options_y+margin*(i), LEFT, fonts.get(text_font));                            // servo pins
        display_text(servo_names[i+3], options_x+2*gap+20, options_y+margin*(i), LEFT, fonts.get(text_font));                                                    // servo names
        display_text(/*format_int_data(servo_pins[i+3])*/servo_pins[i+3], servo_pin_x+gap_between_servo_pins, options_y+margin*(i), LEFT, fonts.get(text_font)); // servo pins       
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
