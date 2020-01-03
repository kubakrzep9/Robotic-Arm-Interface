// Serial_COM contains the serial communication ports for the robotic arm and positioning system.
// The ports are set through drop down menus. The user must select a port to connect to and press
// the ports button. If the port connection is successful a message will be printed to display what 
// port is connected to what. If the connection is unsuccessful an error message will be displayed. 

import processing.serial.*;

class Serial_COM{  
  private myPort port1;
  private myPort port2;
  private PApplet parent;
  
  Serial_COM(PApplet p){
    port1 = new myPort("Port 1");
    port2 = new myPort("Port 2");
    parent = p;
  }
  
  // Called when user tries to set and connect ports. The function checks if both port selections are
  // empty (user pressed ports button without setting ports). The function also verifies the ports are
  // unique. If both ports aren't set or the ports aren't unique, an error message will be displayed and 
  // the function will return. 
  public void connectionFunction(){
    String status = "";    
    boolean error = false;
    int port1_index = port1.index;
    int port2_index = port2.index;
    String port1_name = port1.name;
    String port2_name = port2.name;
    
    if(portsNotSet(port1_index, port2_index)){ // Checking if both ports have not been set yet 
       // Ports have not been selected. Drop down menu indexes = 0.
       status = "Ports not selected.";
       error = true;
    }else if(!portsUnique(port1_name, port2_name)){ // Checking if ports are unique
       // Both ports are the same
      status = "Ports must be unique"; 
      error = true;
    }
    
    if(error){
      // Displays error message
      println(status);
      w.println_console_timed(status);
      return;
    }
     
    if(port1_index > 0){ connectPort(parent, port1); }
    if(port2_index > 0){ connectPort(parent, port2); }
  }
  
  // Checks the index of the selected value in the port drop down menus. By default, the indexs for port 1 
  // port 2 are 0. The port index and port name are set when the user clicks a selection in the drop down menu.
  private boolean portsNotSet(int index1, int index2){ if( index1 == 0 && index2 == 0){ return true; } return false; }
  
  // Checks to see if the user tried to use one port to connect both systems. 
  private boolean portsUnique(String name1, String name2){ if(name1.equals(name2)){ return false; } return true; }
  
  // Function to set the port name and drop down menu index for a port.
  public void setPortName(String port_number, String port_name, int index){
    if(port_number.equals("port 1")){      port1.setNameAndIndex(port_name, index); }
    else if(port_number.equals("port 2")){ port2.setNameAndIndex(port_name, index); }
  }
  
  // Returns whether the port specified by port_number has been connected. 
  public boolean port_connected(String port_number){
    if(port_number.equals("port 1")){       return port1.port_connected; }
    else if(port_number.equals("port 2")){  return port2.port_connected; }
    return false;
  }
  
  // Tries to connect Port, displays status onto console when finished.
  public void connectPort(PApplet parent, myPort myport){ 
    String text = _connectPort(parent, myport); 
    println(text);
    w.println_console_timed(text);
  }
  
  // Tries to connect the serial port to port. If it fails it will print an error message. 
  // If connection is successful, a thread will start requesting the state of the system it 
  // is connected to. 
  private String _connectPort(PApplet parent, myPort myport){
    String status = "";
    String port_name = myport.myPort_name;
    String port_connection_name = myport.name;
    
    try{ // Try to connect to port portConnection 
      myport.connection = new Serial(parent, port_connection_name, 9600); 
      status = port_name + ": " + port_connection_name;
      myport.port_connected = true;
      if(myport.myPort_name.equals(port1.myPort_name))     { thread("requestSensorState"); } // Get current sensor pins and values
      else if(myport.myPort_name.equals(port2.myPort_name)){ thread("requestRobotState");  } // Get current servo pins and angle measuers
    } 
    catch( Exception e){ // If failed, display error message
      status = "Can't connect " + port_name + " to: " + port_connection_name; 
      myport.port_connected = false;
    }
    
    return status;
  }
  
  // Returns the Serial port of the myPort identified by port_name
  Serial getPort(String port_name){
    if(port_name.equals(port1.getMyPort_Name())){      return port1.getConnection(); }
    else if(port_name.equals(port2.getMyPort_Name())){ return port2.getConnection(); }
    return null;
  }  
  
  // Displays what port1 and port2 are connected to onto the GUI console. 
  void printPorts(){
    String port1_text = port1.myPort_name+": "+port1.name;
    String port2_text = port2.myPort_name+": "+port2.name;
    String lines_of_text[] = {port1_text, port2_text};
    w.multi_line_println_console_timed(lines_of_text);
  }



  // Subclass for the Serial_COM class. Serial_COM has two ports, one for the robotic arm and one for the position system. 
  class myPort{
    private String myPort_name;
    private String name;
    private Serial connection;
    private int index;
    private boolean port_connected;
    
    myPort(String my_name){
      myPort_name = my_name;
      name = "not connected";
      index = 0;
      port_connected = false; 
    }
    
    // Setters and getters for myPort data members
    private void setNameAndIndex(String _name, int _index){ name = _name;   index = _index; }
    public String getMyPort_Name(){ return myPort_name; }
    public Serial getConnection(){ return connection; }
  }
}
