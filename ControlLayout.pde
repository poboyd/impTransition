
class ControlLayout {   
 
  ControlP5 cp5;
  int col;
  
  PFont pfont;
  ControlFont font; 
  ControlFont fontSmall; 
  
  public ControlLayout(ControlP5 thiscp5){
    cp5 = thiscp5;
  }  
  
  void setup(){       
      
    pfont = createFont("Arial",20,true); // use true/false for smooth/no-smooth
    font = new ControlFont(pfont,15);
    fontSmall = new ControlFont(pfont,14);
    
    cp5.addTextlabel("Restart Demo")     
     .setText("r - restart demo")
     .setPosition(20,20)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 
     
    cp5.addTextlabel("Hide Demo")     
     .setText("d - hide demo")
     .setPosition(20,35)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 
     
    cp5.addTextlabel("Show Demo")     
     .setText("s - show demo")
     .setPosition(20,50)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 
     
     cp5.addTextlabel("add transition")     
     .setText("spc - add transition")
     .setPosition(20,65)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 
     
     cp5.addTextlabel("delete transition")     
     .setText("del - delete transition")
     .setPosition(20,80)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 
     
      cp5.addTextlabel("stop song")     
     .setText("u - stop song")
     .setPosition(20,95)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 
     
      cp5.addTextlabel("start song")     
     .setText("n - start song")
     .setPosition(20,110)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 
     
      cp5.addTextlabel("song forward small")     
     .setText("j - song forward >")
     .setPosition(20,125)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 

     cp5.addTextlabel("song forward large")     
     .setText("k - song forward >>")
     .setPosition(20,140)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 

     cp5.addTextlabel("song back small")     
     .setText("h - song back <")
     .setPosition(20,155)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 

     cp5.addTextlabel("song back large")     
     .setText("g - song back <<")
     .setPosition(20,170)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 

     cp5.addTextlabel("move camera")     
     .setText("arrows - camera move")
     .setPosition(20,185)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 
     
      cp5.addTextlabel("zoom camera")     
     .setText("a z - camera zoom")
     .setPosition(20,200)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 
     
       cp5.addTextlabel("camera home")     
     .setText("q - camera home")
     .setPosition(20,215)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(fontSmall)
     .setColorBackground(#E8B705); 
     
    List actorTypes = Arrays.asList("Grid", "LineEQ", "Walls");    
    cp5.addScrollableList("Types")
     .setPosition(240, 20)          
     .setSize(150, 400)   
     .setBarHeight(20)
     .setItemHeight(30)
     .addItems(actorTypes)
     .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     .setCaptionLabel("Actor")
     .open()
     .setOpen(true)  
     .setFont(font);

   cp5.addButton("Add Actor")
     .setValue(0)
     .setPosition(420,20)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(font)
     .setColorBackground(#09E33A);

   cp5.addButton("Remove Actor")
     .setValue(0)
     .setPosition(420,50)
     .setSize(150,19)
     .setColorBackground(100)     
     .setFont(font)
     .setColorBackground(#EA0520);      
     
   cp5.addScrollableList("Actors")
     .setPosition(590, 20)
     .setSize(200, 400)   
     .setBarHeight(20)
     .setItemHeight(30)     
     .open()
     .hide()
     .setOpen(true)
     .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
     .setFont(font);
         
    cp5.addGroup("actorProperties")
       .setPosition(810,40)
       .setSize(400, 1000)
       .setCaptionLabel("Properties")
       .setBackgroundHeight(300)
       .setBackgroundColor(color(100, 100, 100, 200))
       .setBarHeight(20)
       .hide()
       .setFont(font);
  
   cp5.addButton("Save")
     .setValue(0)
     .setPosition(300,10)
     .setSize(50,19)
     .setColorBackground(100)     
     .setFont(font)
     .setColorBackground(#2A21AD)
     .setGroup("actorProperties");

    cp5.addToggle("enabled")
     .setPosition(10,10)
     .setSize(60,15)     
     .setFont(fontSmall)         
     .setGroup("actorProperties");
 
     cp5.addNumberbox("numberboxSize")
     .setPosition(10,60)
     .setSize(60,20)
     .setCaptionLabel("size")
     .setRange(0,1000)
     .setMultiplier(1) // set the sensitifity of the numberbox   
     .setFont(fontSmall) 
     .setValue(20)
     .setGroup("actorProperties");
  
    cp5.addNumberbox("numberboxStokeWeight")
     .setPosition(10,110)
     .setSize(60,20)
     .setCaptionLabel("stroke weight")
     .setRange(0,1000)
     .setMultiplier(1) // set the sensitifity of the numberbox   
     .setFont(fontSmall) 
     .setValue(20)
     .setGroup("actorProperties");
    
     cp5.addNumberbox("numberboxStokeMode")
     .setPosition(10,160)
     .setSize(60,20)
     .setCaptionLabel("mode")
     .setRange(0,1000)
     .setMultiplier(1) // set the sensitifity of the numberbox   
     .setFont(fontSmall) 
     .setValue(20)
     .setGroup("actorProperties");        
    
     cp5.addColorPicker("colour")
      .setPosition(10, 210)
      .setCaptionLabel("red")
      .setFont(fontSmall) 
      .setColorValue(color(100, 50, 0, 255))
      .setGroup("actorProperties");
   
    
   setLock(cp5.getController("Save"),true);                  
       
    
  }          


  void setLock(controlP5.Controller theController, boolean theValue) {
    theController.setLock(theValue);
    if(theValue) {
      theController.setColorBackground(color(100,100));
    } else {
      theController.setColorBackground(color(col));
    }
  }
  
  void setTransitionActors(Transition transition)
  {      
     if (transition==null)
       return;
      
     setLock(cp5.getController("Save"), true);
         
     cp5.get(ScrollableList.class, "Actors").clear();
     if (!cp5.get(ScrollableList.class, "Actors").isBarVisible())
       cp5.get(ScrollableList.class, "Actors").open();
          
     cp5.get(Group.class, "actorProperties").hide();  
       
     int count=0;
     for (int i = 0; i < transition.actors.size(); i++) {           
        if (!transition.actors.get(i).name.startsWith("dummy")){
          cp5.get(ScrollableList.class, "Actors").addItem(transition.actors.get(i).name,i);
          count++;
         }
     }
     
     if (count==0)
       cp5.get(ScrollableList.class, "Actors").hide();
     else 
       cp5.get(ScrollableList.class, "Actors").show();
          
  }
  
  void showActorControls(Transition transition)
  {           
    if (transition==null || transition.actors==null || transition.actors.size()==0)
       return;
          
    setLock(cp5.getController("Save"), false);
              
    cp5.get(Group.class, "actorProperties").show();                   
    int actorIndex = (int)cp5.getController("Actors").getValue();      
    println("showActorControls Index:" + actorIndex + "  Name:" + transition.actors.get(actorIndex).name);
                            
    cp5.get(Numberbox.class, "numberboxStokeWeight").setValue(transition.actors.get(actorIndex).strokeWeight);
    cp5.get(Numberbox.class, "numberboxSize").setValue(transition.actors.get(actorIndex).strokeWeight);
    cp5.get(Numberbox.class, "numberboxStokeMode").setValue(transition.actors.get(actorIndex).mode);                                          
              
    cp5.get(ColorPicker.class, "colour").setArrayValue(new float[] {transition.actors.get(actorIndex).red, transition.actors.get(actorIndex).green, transition.actors.get(actorIndex).blue, transition.actors.get(actorIndex).alpha});
    
    cp5.get(Toggle.class, "enabled").setValue( transition.actors.get(actorIndex).enabled );    
  }
  
 
  
}
