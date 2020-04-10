// Serial_COM contains the serial communication ports for the robotic arm and positioning system.
// The ports are set through drop down menus. The user must select a port to connect to and press
// the ports button. If the port connection is successful a message will be printed to display what 
// port is connected to what. If the connection is unsuccessful an error message will be displayed. 

import processing.serial.*;

class Serial_COM{  
  private myPort port1;
  private PApplet parent;
  
  public int num_meta_data = 3; // src_id, dest_id, instr_id
  
  Serial_COM(PApplet p){
    port1 = new myPort("Port 1");
    parent = p;
  }
  
  // Called when user tries to set and connect ports. The function checks if both port selections are
  // empty (user pressed ports button without setting ports). The function also verifies the ports are
  // unique. If both ports aren't set or the ports aren't unique, an error message will be displayed and 
  // the function will return. 
  public void connectionFunction(){
    int port1_index = port1.index;
     
    if(port1_index == 0){ println_all("Port not selected."); }
    else if(port1_index > 0){ connectPort(parent, port1); }
     
  }
    
  // Function to set the port name and drop down menu index for a port.
  public void setPortName(String port_number, String port_name, int index){
    if(port_number.equals("port 1")){ port1.setNameAndIndex(port_name, index); }
  }
  
  // Returns whether the port specified by port_number has been connected. 
  public boolean port_connected(String port_number){
    if(port_number.equals("port 1")){ return port1.port_connected; }
    return false;
  }
  
  // Tries to connect Port, displays status onto console when finished.
  public void connectPort(PApplet parent, myPort myport){ 
    String text = _connectPort(parent, myport); 
    println_all(text);
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
      if(myport.myPort_name.equals(port1.myPort_name)){ thread("requestUPSState");   } // Get current servo pins and angle measuers
      if(UPS_RA_Link){ thread("requestRobotState"); }
    } 
    catch( Exception e){ // If failed, display error message
      status = "Can't connect " + port_name + " to: " + port_connection_name; 
      myport.port_connected = false;
    }
    
    return status;
  }
  
  // Returns the Serial port of the myPort identified by port_name
  Serial getPort(String port_name){
    if(port_name.equals(port1.getMyPort_Name())){ return port1.getConnection(); }
    return null;
  }  
  
  // Displays what port1 and port2 are connected to onto the GUI console. 
  void printPorts(){
    String port1_text = port1.myPort_name+": "+port1.name;
    println_all(port1_text);
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
