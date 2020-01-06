// This class contains all the dynamic elements of the GUI. The key elements of this class are features that the 
// user can interact with: buttons, drop down, input fields. These features can be shown and hidden on the GUI. 
// The buttons allow the user to navigate the menus, submit values or exit the program. The drop downs allow the 
// user to select the ports for the Positioning System and the Robotic Arm. The input fields allow the user to 
// manually change the robotic arm servo angles or the pins of the arm or sensor system. 

import controlP5.*;

class Widgets{ 
  private ControlP5 widget_control;
  private final PApplet theParent; 
  private DropdownList available_ports1;
  private DropdownList available_ports2;
  private Textarea message_box;
  private String message_box_text = "";
  private ArrayList<String> servo_angle_input_fields;
  private ArrayList<String> servo_pin_input_fields;
  private ArrayList<String> sensor_pin_input_fields;  
  private int num_servos;
 
  private final String empty_entry = "--------------------";

  // Console box dimensions
  private int console_main_x      = 320;
  private int console_main_y      = 15;
  private int console_main_width  = 410;
  private int console_main_height = 255;
  
  private int console_options_x      = 320;
  private int console_options_y      = 200;
  private int console_options_width  = 270;
  private int console_options_height = 70;
//message_box.setPosition(320,185).setSize(220,85); }

  // Constructor to initialize all widgets
  Widgets(final PApplet parent, int num_s){
    theParent                = parent;
    widget_control           = new ControlP5(theParent);
    servo_angle_input_fields = new ArrayList<String>();
    servo_pin_input_fields   = new ArrayList<String>();
    sensor_pin_input_fields  = new ArrayList<String>();
    num_servos = num_s;
    
   /*********************/
   /****** Buttons ******/
   /*********************/
    
    /**************************************************/
    /*** Submission bar - the 'row' where all the   ***/
    /*** buttons that send instructions reside on. ***/
    /*************************************************/
    int submission_bar_y = 255;
    int font_size         = 3;
    int sub_btn_width    = 60;
    int sub_btn_height   = 15;
    int pins_x = 670; 
    
    // Moves arm when in manual mode
    widget_control.addButton("go")       
      .setPosition(270, submission_bar_y-65)              
      .setSize(20, sub_btn_height)                    
      .setFont(fonts.get(font_size))              
      .hide()                             
    ;
    
    // Attempts to connects ports
    widget_control.addButton("ports")       
      .setPosition(pins_x-70, submission_bar_y)              
      .setSize(sub_btn_width, sub_btn_height)                    
      .setFont(fonts.get(font_size))              
      .hide()                             
    ;
    
    // Sets pins 
    widget_control.addButton("pins")       
      .setPosition(pins_x, submission_bar_y)              
      .setSize(sub_btn_width, sub_btn_height)
      .setFont(fonts.get(font_size))              
      .hide()                             
    ;

   /*********************************************************/  
   /*** Navigation bar - the 'row' where all the buttons  ***/
   /*** that make actions to the GUI reside on.           ***/
   /*********************************************************/
   int nav_btn_height = 15;
   int nav_btn_width = 60;
   int btn_space = 10;
   int nav_bar_y = 280;
   int auto_manual_x = 530;
   int options_console_x = auto_manual_x+nav_btn_width+btn_space;
   int exit_x = options_console_x+nav_btn_width+btn_space;

   // Sets auto mode
    widget_control.addButton("auto")       
      .setPosition(auto_manual_x, nav_bar_y)              
      .setSize(nav_btn_width, nav_btn_height)                    
      .setFont(fonts.get(3))              
      .hide()                             
    ;
    
    // Sets manual mode
    widget_control.addButton("manual")       
      .setPosition(auto_manual_x, nav_bar_y)              
      .setSize(nav_btn_width, nav_btn_height)                    
      .setFont(fonts.get(3))              
      .hide()                             
    ;

    // Options button
    widget_control.addButton("options")       
      .setPosition(options_console_x, nav_bar_y)
      .setSize(nav_btn_width, nav_btn_height)                    
      .setFont(fonts.get(3))              
      .hide()                             
    ;
    
    // Console button
    widget_control.addButton("console")       
      .setPosition(options_console_x, nav_bar_y)
      .setSize(nav_btn_width, nav_btn_height)                    
      .setFont(fonts.get(3))              
      .hide()                             
    ;
    
    // Exit button
    widget_control.addButton("exit")       
      .setPosition(exit_x, nav_bar_y)              
      .setSize(nav_btn_width, nav_btn_height)                    
      .setFont(fonts.get(3))              
      .hide()                             
    ;
    
    /*********************************************/
    /***** Main screen message box (console) *****/
    /*********************************************/
    message_box = widget_control.addTextarea("message box")
     .setPosition(console_main_x,console_main_y)
     .setSize(console_main_width,console_main_height)
     //.setPosition(320,15)
     //.setSize(360,255)
     .show()
     .setLineHeight(16)
     .setColor(color(0)) // font
     .setColorBackground(0xffffffff) // background
   ;
     
    /******************************************/
    /***** Input texfields for Servo angle ****/
    /******************************************/
    String input_field_names_servos[] = {"input body", "input shoulder", "input elbow", "input wrist", "input hand", "input handRotator"};
    int size = input_field_names_servos.length;
    int input_servo_x = 270;
    int input_servo_y = 40;
    int input_width = 20;
    int input_height = 15;
       
    for(int i=0; i<size; i++){
      servo_angle_input_fields.add(input_field_names_servos[i]);
      widget_control.addTextfield(input_field_names_servos[i])
        .setPosition(input_servo_x,input_servo_y+25*i)
        .setSize(input_width, input_height)
        .setFont(fonts.get(3))
        .setColorBackground(0xffffffff)
        .setColor(0)
        .setFocus(true)
        .setAutoClear(false)
        .hide()
        .getCaptionLabel().setVisible(false)
      ;
    }
     
    /*********************************************/
    /****** Input texfields for Servo pins  ******/
    /*********************************************/
    for(int i=0; i<num_servos; i++){ servo_pin_input_fields.add(i, "0"); }
    
    String input_field_names_servo_pins[] = {"pin body", "pin shoulder", "pin elbow", "pin wrist", "pin hand", "pin handRotator"};
    size = 3; // 6 servos, 2 columns of 3
    int input_servo_pin_x  = 575;
    int input_servo_pin_y = 115;
    int input_pin_width   = 13;
    int input_pin_height  = 15;
 
    for(int i=0; i<size; i++){
      // first columnm
      servo_pin_input_fields.set(i,input_field_names_servo_pins[i]);
      widget_control.addTextfield(input_field_names_servo_pins[i])
        .setPosition(input_servo_pin_x-155,input_servo_pin_y+25*i)
        .setSize(input_pin_width, input_pin_height)
        .setFont(fonts.get(3))
        .setColorBackground(0xffffffff)
        .setColor(0)
        .setFocus(true)
        .setAutoClear(false)
        .hide()
        .getCaptionLabel().setVisible(false)
      ;
     
      // second column
      servo_pin_input_fields.set(i+3,input_field_names_servo_pins[i+3]);
      widget_control.addTextfield(input_field_names_servo_pins[i+3])
        .setPosition(input_servo_pin_x,input_servo_pin_y+25*i)
        .setSize(input_pin_width, input_pin_height)
        .setFont(fonts.get(3))
        .setColorBackground(0xffffffff)
        .setColor(0)
        .setFocus(true)
        .setAutoClear(false)
        .hide()
        .getCaptionLabel().setVisible(false)
      ;
    } 
    
    /**********************************************/
    /****** Input texfields for Sensor pins  ******/
    /**********************************************/
    String input_field_names_sensor_pins[] = {"pin gyro shoulder", "pin gyro elbow", "pin gryo wrist", "pin emg"};
    size = input_field_names_sensor_pins.length; // 1 column of 4 sensors
    int input_sensor_pin_x = 715; 
    int input_sensor_pin_y = 115; 
    
    for(int i=0; i<size; i++){
      // first columnm
      sensor_pin_input_fields.add(input_field_names_sensor_pins[i]);
      widget_control.addTextfield(input_field_names_sensor_pins[i])
        .setPosition(input_sensor_pin_x,input_sensor_pin_y+25*i)
        .setSize(input_pin_width, input_pin_height)
        .setFont(fonts.get(3))
        .setColorBackground(0xffffffff)
        .setColor(0)
        .setFocus(true)
        .setAutoClear(false)
        .hide()
        .getCaptionLabel().setVisible(false)
      ;
    }
    
    int drop_down_width = 100;
    int drop_down_height = 100;
    int dd_port1_x = 490;
    int dd_port2_x = 630;
    int dd_port_y = 55;

    /******************************************/
    /***** Port Selection Dropdown List 1 *****/
    /******************************************/
    available_ports1 = widget_control.addDropdownList("port 1")
        .setPosition(dd_port1_x, dd_port_y)//.setPosition(360, 50)
        .setFont(fonts.get(3))
        .setSize(drop_down_width, drop_down_height)
        .hide()
    ;
        
    /******************************************/
    /***** Port Selection Dropdown List 2 *****/
    /******************************************/
    available_ports2 = widget_control.addDropdownList("port 2")
        .setPosition(dd_port2_x, dd_port_y)//.setPosition(540, 50)
        .setFont(fonts.get(3))
        .setSize(drop_down_width, drop_down_height)
        .hide()
    ;
  
    customizeDDL(available_ports1);
    customizeDDL(available_ports2);
    
    mainScreenWidgets();
  }
  
  /************************************/
  /*** Preconfigured Screen Widgets ***/
  /************************************/
  
  // Load main screen widgets. Console is it's largest size.
  public void mainScreenWidgets(){
    showWidgets("message box");
    showWidgets("auto");
    showWidgets("options");
    showWidgets("exit");
    showWidgets("servo angle input fields");
    showWidgets("go");
    
    message_box.scroll(1);
    println_console_timed("Starting up");
  }
  
  // Load auto widgets
  public void autoWidgets(){
    hideWidgets("auto");
    hideWidgets("servo angle input fields");
    hideWidgets("go");
    showWidgets("manual"); 
    clearTextFields("angles");
  }
  
  // Load manual widgets
  public void manWidgets(){
    hideWidgets("manual");
    showWidgets("auto");
    showWidgets("servo angle input fields");
    showWidgets("go"); 
  }
  
  // Load options widgets
  public void optionsWidgets(){
    hideWidgets("options");
    showWidgets("console");
    showWidgets("ports");
    showWidgets("ports drop down");
    showWidgets("pins");
    showWidgets("servo pin input fields");
    showWidgets("sensor pin input fields");
    close_port_drop_downs();  
    consoleOptions();
  }
  
  // Load console widgets.
  public void consoleWidgets(){
    hideWidgets("console");
    hideWidgets("ports");
    hideWidgets("ports drop down");
    hideWidgets("pins");
    hideWidgets("servo pin input fields");
    hideWidgets("sensor pin input fields");
    showWidgets("options");
    consoleMain();
    clearTextFields("pins");
  }
   
  /************************/
  /*** Widget functions ***/
  /************************/
  
  // go element to desired xy coordinate 
  public void moveElement(String name, int x, int y){ widget_control.getController(name).setPosition(x,y); }
  
  // Convenience function used easily hide all buttons and input fields
  public void resetElements(){ hideWidgets("all"); }
    
  // Convenience function to easily display any GUI element or group of elements (buttons, input fields).
  // Used when preparing GUI to display a specific screen.
  public void showWidgets(String name){
    if(name.equals("message box")){ message_box.show(); }
    else if(name.equals("auto"       )){ widget_control.getController("auto").show();    }
    else if(name.equals("manual"     )){ widget_control.getController("manual").show();  }
    else if(name.equals("go"         )){ widget_control.getController("go").show();      }
    else if(name.equals("ports"      )){ widget_control.getController("ports").show();   }
    else if(name.equals("pins"       )){ widget_control.getController("pins").show();    }
    else if(name.equals("options"    )){ widget_control.getController("options").show(); }
    else if(name.equals("console"    )){ widget_control.getController("console").show(); }
    else if(name.equals("exit"       )){ widget_control.getController("exit").show();    }  
    else if(name.equals("ports drop down")){ widget_control.getController("port 1").show(); widget_control.getController("port 2").show(); }
    else if(name.equals("servo angle input fields")){ for( String fieldName : servo_angle_input_fields){ widget_control.getController(fieldName).show(); } }
    else if(name.equals("servo pin input fields"  )){ for( String fieldName : servo_pin_input_fields){ widget_control.getController(fieldName).show(); } }
    else if(name.equals("sensor pin input fields" )){ for( String fieldName : sensor_pin_input_fields){ widget_control.getController(fieldName).show(); } }
  }

  // Convenience function to easily hide any and all GUI element or groups of elements (buttons, input fields). 
  // Used when preparing GUI to display a specific screen.
  public void hideWidgets(String name){
    if(name.equals("message box") || name.equals("all")){ message_box.hide(); }
    if(name.equals("auto")        || name.equals("all")){ widget_control.getController("auto").hide();    }
    if(name.equals("manual")      || name.equals("all")){ widget_control.getController("manual").hide();  }
    if(name.equals("go")          || name.equals("all")){ widget_control.getController("go").hide();      }
    if(name.equals("ports")       || name.equals("all")){ widget_control.getController("ports").hide();   }
    if(name.equals("pins")        || name.equals("all")){ widget_control.getController("pins").hide();    }
    if(name.equals("options")     || name.equals("all")){ widget_control.getController("options").hide(); }
    if(name.equals("console")     || name.equals("all")){ widget_control.getController("console").hide(); }
    if(name.equals("exit")        || name.equals("all")){ widget_control.getController("exit").hide();    }
    if(name.equals("ports drop down") || name.equals("all")){ widget_control.getController("port 1").hide(); widget_control.getController("port 2").hide(); }
    if(name.equals("servo angle input fields") || name.equals("all")){ for( String fieldName : servo_angle_input_fields){ widget_control.getController(fieldName).hide(); } }
    if(name.equals("servo pin input fields")   || name.equals("all")){ for( String fieldName : servo_pin_input_fields){ widget_control.getController(fieldName).hide(); } }
    if(name.equals("sensor pin input fields")  || name.equals("all")){ for( String fieldName : sensor_pin_input_fields){ widget_control.getController(fieldName).hide(); } }
  }
  
  /***************************************/
  /*** Console (Message box) Functions ***/
  /***************************************/
  // Appends text to the end of the text area. text must be a string without "\n". 
  // println_message_box will append a newline char at the end of the text. 
  public void println_message_box(String text){ 
    message_box_text += text + "\n";
    message_box.setText(message_box_text);  
  }
  
  // Function to add a zero to single digits to give a two digit format. Any number 0 - 9 would be assigend to
  // have a zero in front of itself. 
  private String _addZero(int num){
    String str = "";
    if(num < 10){ str = "0" + str(num); } 
    else{ str = str(num); } 
    return str;
  }
  
  // Time library is in 24-hr format, this function returns the 12-hr format of the hour. 
  private String twelve_hr_hour_format(int hour){
    int h = hour();
    if(h > 12){ h = h -12; }
    return str(h);
  }
  
  // Returns a string of the current time in 12-hr format
  private String twelve_hr_format(){
    String _hour = twelve_hr_hour_format(hour());
    String _minute = _addZero(minute());
    String _second = _addZero(second());  
    String _time = _hour+" : "+_minute+" : "+_second;
    return _time;
  }
  
  // Prints the 24 hr time right before the text pased in to the function.
  public void println_console_timed(String text){
    String _time = twelve_hr_format();
    
    message_box_text += _time + " - " + text + "\n";
    message_box.setText(message_box_text);  
  }
  
  // Function to print multiple lines onto the console but only one time for the entire print section. 
  public void multi_line_println_console_timed(String lines[]){
    String text = "";
    String _time = twelve_hr_format();
    String white_space = "";
    int num_lines = lines.length;
    
    for(int i=0; i<9; i++){ white_space += "-"; } // ROUGH ESTIMATE, meant to replace time on other lines
    for(int i=0; i<num_lines; i++){
      if(i != 0){ message_box_text += white_space+ " - " + lines[i] + "\n";}
      else{ message_box_text += _time + " - " + lines[i] + "\n"; }
    }
    
    message_box.setText(message_box_text);  
  } 

  // Consoles main position and size
  private void consoleMain(){ message_box.setPosition(console_main_x,console_main_y).setSize(console_main_width,console_main_height); }

  // Consoles position and size in options menu 
  private void consoleOptions(){ message_box.setPosition(console_options_x,console_options_y).setSize(console_options_width, console_options_height); }
  
  /*****************************/
  /*** Input Field Functions ***/
  /*****************************/
  
  // Returns a String array of input field values. Each input field has a fieldName
  // in the ControlP5 object. To get each value the cp5 object is accessed for the 
  // input field value using fieldName. 
  private String[] _getInputHelper(String name, ArrayList<String> fieldNames){
    String nullSet[] = new String[1]; //return nothing if name doesn't match
    try{
      int size = fieldNames.size();
      String textFields[] = new String[size];
      for(int i=0; i<size; i++){ textFields[i] = widget_control.get(Textfield.class, fieldNames.get(i)).getText(); }
      return textFields;
    }catch(Exception e){ println("Cannot access '"+name+"'. " + e); }
    return nullSet; 
  }
  
  // Used to retrieve user input from the input fields according to a name provided as an argument. The name 
  // is used to decide which input fields to read from. 
  public String[] getInputFieldText(String name){
     String nullSet[] = new String[1]; //return nothing if name doesn't match
    
    if(name.equals("servo angle input fields")){
      int size = servo_angle_input_fields.size();
      String textFields[] = new String[size];
      // Extracting each value from input fields grouped by name.
      for(int i=0; i<size; i++){ textFields[i] = widget_control.get(Textfield.class, servo_angle_input_fields.get(i)).getText(); }
      return textFields;
    }
    else if(name.equals("servo pin input fields")){  return _getInputHelper("servo pin input fields", servo_pin_input_fields);  }
    else if(name.equals("sensor pin input fields")){ return _getInputHelper("sensor pin input fields", sensor_pin_input_fields); }
    else{ println("Invalid input field group name"); return nullSet; }
  }
  
  // Clears all text fields from the Template Input Screen. Used to clear input fields after user has 
  // submitted their inputs. Also used to clear input fields, if there is anything on them, when 
  // switching screens. Otherwise, the input fields will retain an old value. 
  public void clearTextFields(String name){
    if(name.equals("angles")){ for(String str : servo_angle_input_fields){ widget_control.get(Textfield.class, str).setText(""); } }
    else if(name.equals("pins")){
      for(String str : servo_pin_input_fields){ widget_control.get(Textfield.class, str).setText("");   }
      for(String str : sensor_pin_input_fields){ widget_control.get(Textfield.class, str).setText("");  }
    }
  }
  
  /********************************/
  /*** Drop Down Menu Functions ***/
  /********************************/
  // Hides drop down options.
  void close_port_drop_downs(){
    available_ports1.close();
    available_ports2.close();
  }
  
  // Convenience function to customize a DropdownList
  void customizeDDL(DropdownList ddl) {
    int box_height = 17;
    String portsAvailable[] = Serial.list();
    int size = portsAvailable.length; 
    
    ddl.setBackgroundColor(color(190));
    ddl.setItemHeight(box_height);
    ddl.setBarHeight(box_height);
    //Adding ports to DropdownList
    ddl.addItem(empty_entry, 0);
    for (int i=1;i<=size;i++){ ddl.addItem(portsAvailable[i-1], i); }
    ddl.setColorActive(color(255, 128));
  }
 
  // Returns item from DropDownList at a specific index
  public String getItemDropDownList(DropdownList ddl, int index){ 
    java.util.Map<java.lang.String,java.lang.Object> item = ddl.getItem(index);
    return item.get("text").toString();
  } 
}
