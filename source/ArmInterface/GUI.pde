// GUI_Settings contains the general GUI elements and settings. The home screen 
// display section and options menu are defined here. All text not on dynamic
// features (those are in the Widgets class) are here. 

class GUI_Settings{ 
  private int MAX_WIDTH = 1000;
  private int MAX_HEIGHT = 1000;
  private int GUI_WIDTH  = 800;//750;
  private int GUI_HEIGHT = 330;//310;
  
  private boolean auto_mode = false;
  private boolean options_mode = false;
 
  private Position_System ups;
  private Robot robot;

  public boolean get_auto_mode(){ return auto_mode; }
  public void set_auto_mode(boolean bool){ auto_mode = bool; }
  public boolean get_options_mode(){ return options_mode; }
  public void set_options_mode(boolean bool){ options_mode = bool; }

  GUI_Settings(Position_System _ups, Robot r){
   this.ups = _ups;
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
    int sensor_x = 25;
    int sensor_y = 50;
    String sensor_names[] = ups.getSensorNames();
    String value_names[]  = ups.getGyroAngleNames();
    int sensor_values[]   = ups.getValues(); // first 9 are gyros 10 is pressure gauge
    int num_MPU6050  = ups.num_MPU6050;
    int num_angles   = value_names.length;
    int name_indent  = 20;
    int value_indent = name_indent+50;
    
    int val_i = 0;
    int i = 0;
    display_text("USER POSITION SYSTEM", 75, header_y, CENTER, fonts.get(heading_font));
    for(; i<num_MPU6050; i++){ 
      sensor_y = 50+(i*70);
      display_text(sensor_names[i],    sensor_x,    sensor_y, LEFT, fonts.get(text_font)); // sensor names
      for(int j=0; j<num_angles; j++, val_i++){  
        display_text(value_names[j],   sensor_x+name_indent, sensor_y+17*(j+1), LEFT, fonts.get(text_font)); // angle names   
        display_text(sensor_values[val_i], sensor_x+value_indent, sensor_y+17*(j+1), LEFT, fonts.get(text_font)); // sensor values
      } 
    }
    
    int total_angles = num_MPU6050 * num_angles;
    int box_y = 40;
    for(int j=0; j<total_angles; j++){
      if(j%3 == 0 && j != 0){ box_y += 34; } // spacing between two gyros
      else{ box_y += 18; }                   // spacing between angles of one gyro
      if(sensor_values[j] > 180 || sensor_values[j] < 0){ fill(128,0,0); } // out of range (red)
      else{ fill(0,128,0); }                                               // in range (green)
      //stroke(255, 255, 255);
      rect(115, box_y, 10, 10); // x, y, w, h
    }
 
    String ups_press_name = ups.ups_pressure.get_Name();
    int ups_press_value   = ups.ups_pressure.getValue();    
    int pressure_y = 275;
    display_text(ups_press_name,  sensor_x,                  pressure_y, LEFT, fonts.get(text_font)); // sensor names
    display_text(ups_press_value, sensor_x+value_indent, pressure_y, LEFT, fonts.get(text_font)); // sensor values

    // Robotic arm servo names and values
    int margin = 25;
    int servo_x = 170;
    int servo_y = 50;
    String[] servo_names  = robot.getServoNames();
    int[]    servo_angles = robot.getServoAngles();
    
    int num_servos = Robot.num_servos;
    display_text("ROBOTIC ARM", 225, header_y, CENTER, fonts.get(heading_font));
    for(i=0; i<num_servos; i++){
      display_text(servo_names[i],  servo_x, servo_y+margin*(i), LEFT, fonts.get(text_font)); // servo names
      display_text(servo_angles[i], servo_x+70, servo_y+margin*(i), LEFT, fonts.get(text_font)); // servo values
    }
    
    String ra_press_name = robot.ra_pressure.get_Name();
    int ra_press_value   = robot.ra_pressure.getValue();

    display_text(ra_press_name,  servo_x,              pressure_y, LEFT, fonts.get(text_font)); // sensor names
    display_text(ra_press_value, servo_x+value_indent, pressure_y, LEFT, fonts.get(text_font)); // sensor values
    
    // White mode box and text
    int mode_x = 515;
    int mode_y = 310;
    stroke(255, 255, 255);
    fill(255, 255, 255);   
    rect(mode_x-60, mode_y-11, 110, 15); // x, y, w, h
    if(auto_mode){ display_text("MODE: AUTO ",  mode_x, mode_y, CENTER, fonts.get(text_font)); }
    else{          display_text("MODE: MANUAL", mode_x, mode_y, CENTER, fonts.get(text_font)); }
    
    // Options menu
    if(options_mode){
      int options_y = 126;    

      /************************************************************************************************/
      /*** Options Menu - "One time settings". Should only need to set values in options menu once. ***/
      /************************************************************************************************/
      
      int header_x = 350; //500
      int link_x = 725;
      
      display_text("PORT SELECTION", header_x, header_y, LEFT, fonts.get(heading_font)); 
      display_text("UPS to RA Link",  link_x, header_y+20, CENTER, fonts.get(text_font));
      display_text("User Position System",    570, header_y+20, CENTER, fonts.get(text_font));

      // White box indicating whether PS to RA Link was established
      fill(255, 255, 255);   
      rect(link_x-55, 55, 110, 15); // x, y, w, h
      String link_text = "UNCONNECTED";
      if(UPS_RA_Link){ link_text = "CONNECTED"; }
      display_text(link_text, link_x, 67, CENTER, fonts.get(text_font));
      
      int servo_pin_x = 390;       
      int sensor_pin_x = servo_pin_x + 290;//680;
      int[] sensor_pins = ups.getPins();
      int[] servo_pins  = robot.getServoPins();
      int num_sensors = sensor_names.length;
      int servo_iterations = num_servos/2; // 2 columns of 3 pins
     
      display_text("PIN SELECTION",  header_x, 90,       LEFT, fonts.get(heading_font));
      
      int col_2_name_gap = 135;
      int col_2_value_gap = 210;
          
      // Iterates 3 times, placing 3 rows of text
      for(i=0; i<servo_iterations; i++){
        display_text(servo_names[i],   servo_pin_x,       options_y+margin*(i), LEFT, fonts.get(text_font)); // servo names
        display_text(servo_pins[i],    servo_pin_x+70,    options_y+margin*(i), LEFT, fonts.get(text_font)); // servo pins
        display_text(servo_names[i+3], servo_pin_x + col_2_name_gap, options_y+margin*(i), LEFT, fonts.get(text_font)); // servo names
        display_text(servo_pins[i+3],  servo_pin_x+ col_2_value_gap,  options_y+margin*(i), LEFT, fonts.get(text_font)); // servo pins
      }
       
     int ra_press_pin = robot.ra_pressure.getPin();
     // RA Pressure Gauge 
      display_text(ra_press_name,  servo_pin_x + col_2_name_gap,  options_y+margin*(i), LEFT, fonts.get(text_font)); // sensor names 
      display_text(ra_press_pin,   servo_pin_x + col_2_value_gap,  options_y+margin*(i), LEFT, fonts.get(text_font)); // sensor pins
      
      int col_3_value_gap = 65;
      
      for(i=0; i<num_sensors; i++){
        display_text(sensor_names[i],  sensor_pin_x,      options_y+margin*(i), LEFT, fonts.get(text_font)); // sensor names 
        display_text(sensor_pins[i],   sensor_pin_x+col_3_value_gap,   options_y+margin*(i), LEFT, fonts.get(text_font)); // sensor pins
      }
      
      int ups_press_pin = ups.ups_pressure.getPin();
      // UPS Pressure Gauge 
      display_text(ups_press_name,  sensor_pin_x,      options_y+margin*(i), LEFT, fonts.get(text_font)); // sensor names 
      display_text(ups_press_pin,   sensor_pin_x+col_3_value_gap,   options_y+margin*(i), LEFT, fonts.get(text_font)); // sensor pins
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
