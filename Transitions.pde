class Transitions {   
  
  public ArrayList<Transition> currentList = new ArrayList<Transition>() ;  // The main transition list when creating transitions
  public ArrayList<Transition> sortedList = new ArrayList<Transition>() ;   // This sorted list only currently gets set at the moment when we save using getTransitionsAsJson()
  
  public ArrayList<ActorOnStage> actorsOnStage = new ArrayList<ActorOnStage>(); //ActorOnStage are the actual displays showing when the song is running 
  
  void add(boolean enabled, float songPosition){
         
    Transition newTransition = new Transition();
    newTransition.enabled = enabled;
    newTransition.songPosition = songPosition;   
    
    currentList.add(newTransition);     
    
    saveFile();
  }     

  void saveFile(){         
    PrintWriter output = createWriter( dataPath("transitions.json"));     
    String getJson = transitions.getTransitionsAsJson();    
    output.println(getJson);
    output.flush(); // Writes the remaining data to the file
    output.close(); 
  }

  boolean loadExistingTransitions(Object thisthis){
    
    if (!utility.fileExists(dataPath("transitions.json")) ){ //<>//
      println("Transitions File does not exist");
      return false; 
    }
      
    File newFile = new File(dataPath("transitions.json")); //<>//
    if (newFile.length() == 0){  //<>// //<>//
      println("Transitions File is empty");
      return false;  //<>//
    }
    
    JSONObject json = loadJSONObject("\\data\\transitions.json");

    JSONArray transitions = json.getJSONArray("transitions");

    for (int i = 0; i < transitions.size(); i++) {
        
        JSONObject transition = transitions.getJSONObject(i);           
    
        Transition newTransition = new Transition();
        
        utility.setObjectFromJson(thisthis, newTransition , "[" + transition.toString() + "]");
        currentList.add(newTransition);          
      }     
      
      
     for (Transition item : currentList){      
        item.selected= false;                   
     }       
     
     return true;
  }

  String getTransitionsAsJson(){
        
    String jsonString = ""; 
                    
    boolean findingTransitions = true;
    int minIndex = 0;
    int maxSize = currentList.size();
    
    // Create a clone of current list to work with
    ArrayList<Transition> workingList = new ArrayList<Transition>() ;    
    for (Transition item : currentList) workingList.add(new Transition(item));
         
    sortedList.clear();
       
    
    while (findingTransitions ){      
        minIndex = 0;
        float minSongPosition = workingList.get(minIndex).songPosition;
              
        // find smallest song position and index in working list
        for(int i = 0; i < workingList.size(); i++){                    
           if (workingList.get(i).songPosition <= minSongPosition ){  
              minIndex = i;
              minSongPosition = workingList.get(i).songPosition;
           }
        }
      
       sortedList.add(workingList.get(minIndex));
       workingList.remove(minIndex);
       
       if (sortedList.size()>=maxSize)
         findingTransitions = false;       
    }       
       
    for(int i = 0; i < sortedList.size(); i++){
      jsonString += (jsonString=="") ? "{transitions:[" : ",";       
      jsonString += utility.getObjectJson(sortedList.get(i));
    }
    
    return jsonString += "]}";
  }     
  
  void draw(AudioPlayer player, int border)
  {                 
      for (Transition item : currentList){ 
        if (item.selected)
          stroke(255, 255, 0);
        else
          stroke(255, 0, 0);
        
        float songPositionLineX = map(item.songPosition, 0, player.length(), 0, width);
        line(songPositionLineX, height/2, songPositionLineX, height);
      }     
  }
  
  boolean selectTransition(AudioPlayer player, int mouseX){              
    boolean itemSelected = false;
    int selectPosition = int( map( mouseX, 0, width, 0, player.length() ) ); 
   
    for (Transition item : currentList){      
        println("item.songPosition: "+ item.songPosition + " selectPosition: " + selectPosition + "  A bs(item.songPosition - selectPosition):" + abs(item.songPosition - selectPosition) );
        if (abs(item.songPosition - selectPosition)<600){
          println("selectTransition: "+ mouseX );
          item.selected = !item.selected;
          itemSelected = item.selected;
        } 
        else 
          item.selected = false;
     }   
     
     return itemSelected;
  }
  
  
  Transition selectedTransition(){                        
    for (Transition item : currentList){      
        if (item.selected)         
          return item;
     }        
     return null;
  }
  
  boolean selectedTransitionContainsActor(int actorToCheck){              
     for (Transition item : currentList){      
        if (item.selected){                  
          for(int i = 0; i < item.actors.size(); i++){       
            if (item.actors.get(i).type == actorToCheck){
               println("selectedTransitionContainsActor:" + true);
               return true;            
            }                 
          }
        }
     }   
     
     return false;
  }
  
  boolean deleteTransitions(){              
    boolean itemDeleted = false;     
    for(int x=currentList.size()-1; x>=0; x--) {
        if(currentList.get(x).selected){
            currentList.remove(x);
            itemDeleted = true;
        }
     }       
    saveFile(); 
    return itemDeleted;
  }
  
  
  void addActor(ControlP5 cp5)  
  {    
    if (cp5==null || selectedTransition()==null)
      return;
      
    Actor newActor=null;
        
    println("Types:" + cp5.getController("Types").getValue());
    
    if (cp5.getController("Types").getValue()==constants.TYPE_Grid){
      newActor = new Actor( "Grid-" +  selectedTransition().actors.size(),  constants.TYPE_Grid);      
    }
    else if (cp5.getController("Types").getValue()==constants.TYPE_LineEQ){
      newActor = new Actor( "LineEQ-" +  selectedTransition().actors.size(),  constants.TYPE_LineEQ);        
    }
    else if (cp5.getController("Types").getValue()==constants.TYPE_Walls){
      newActor = new Actor( "Walls-" +  selectedTransition().actors.size(),  constants.TYPE_Walls);        
    }
              
    if (newActor!=null && !selectedTransitionContainsActor(newActor.type)){
      selectedTransition().actors.add(newActor);
      println("New actor:" + newActor.name);
    }
    
    saveFile();
  }
  
  void removeActor(ControlP5 cp5)  
  {    
    if (cp5==null || selectedTransition()==null)
      return;
            
    int actorIndex = (int)cp5.getController("Actors").getValue();                
    
    println("Remove Actors Index:" + actorIndex + "  Name:" + selectedTransition().actors.get(actorIndex).name);             
    selectedTransition().actors.remove(actorIndex);
    
    saveFile();
  }
   
  void saveActor(ControlP5 cp5)  
  {    
    if (cp5==null || selectedTransition()==null)
      return;
            
    int actorIndex = (int)cp5.getController("Actors").getValue();
    
    selectedTransition().actors.get(actorIndex).size = cp5.get(Numberbox.class, "numberboxSize").getValue();
    selectedTransition().actors.get(actorIndex).strokeWeight = cp5.get(Numberbox.class, "numberboxStokeWeight").getValue();
    selectedTransition().actors.get(actorIndex).mode = (int)cp5.get(Numberbox.class, "numberboxStokeMode").getValue();
          
    
    selectedTransition().actors.get(actorIndex).red = cp5.get(ColorPicker.class, "colour").getArrayValue(0);
    selectedTransition().actors.get(actorIndex).green = cp5.get(ColorPicker.class, "colour").getArrayValue(1);
    selectedTransition().actors.get(actorIndex).blue = cp5.get(ColorPicker.class, "colour").getArrayValue(2);
    selectedTransition().actors.get(actorIndex).alpha = cp5.get(ColorPicker.class, "colour").getArrayValue(3);
    
    selectedTransition().actors.get(actorIndex).enabled =  cp5.get(Toggle.class, "enabled").getBooleanValue();
    
    
    saveFile();
  }
  
  int nextTransitionIndex(int startAtIndex, float songPosition)
  {
     if (startAtIndex==-1 || startAtIndex>= currentList.size()){
       //println("END OF TRANSITIONS");
       return -1;
     }
                
     if(songPosition >= currentList.get(startAtIndex).songPosition){
          println("START RUNNING:" + startAtIndex + " currentList.get(x).songPosition:" + currentList.get(startAtIndex).songPosition  + "  songPosition:" + songPosition);
          return startAtIndex+1;
     }           
     
    return -1;
  }
  
  void addActorsToTheStage(Transition workingTransition){
                   
    for(int ai = 0; ai < workingTransition.actors.size(); ai++){
    
      int  existingActorOnStageIndex = -1;
      
      for(int i = 0; i < actorsOnStage.size(); i++){       
        if (workingTransition.actors.get(ai).type == actorsOnStage.get(i).type){
          existingActorOnStageIndex = ai;         
          updateActorOnStage(workingTransition.actors.get(ai), actorsOnStage.get(i));             
          break;  // Only allow a transition to describe the same actor once 
        }
       }
       
       if (existingActorOnStageIndex==-1){         
         addNewActorOnStage(workingTransition.actors.get(ai));
       }       
    }
    
  }
  
  void addNewActorOnStage(Actor actorDetails){
  
    ActorOnStage actorOnStage=null;
    
    if (actorDetails.type == Constants.TYPE_Grid){
       actorOnStage = new Grid();      
    }
    else if (actorDetails.type == Constants.TYPE_Walls){
       actorOnStage = new Walls();
    }
    else if (actorDetails.type == Constants.TYPE_LineEQ){
       actorOnStage = new LineEQ();
    }
    else {
       // TYPE_None
       return;
    }
       
    copyActorProperties(actorDetails, actorOnStage);    
    actorsOnStage.add(actorOnStage);
    println("addNewActorOnStage:" + utility.getObjectJson(actorOnStage));
  }
    
  void updateActorOnStage(Actor actorDetails, ActorOnStage actorOnStage){             
    copyActorProperties(actorDetails, actorOnStage);
    println("updateActorOnStage:" + utility.getObjectJson(actorOnStage) + "  with transtion actor:" + utility.getObjectJson(actorDetails));
  }
  
  void copyActorProperties(Actor actorDetails, ActorOnStage actorOnStage){
    actorOnStage.enabled = actorDetails.enabled;
    actorOnStage.size = actorDetails.size; 
    actorOnStage.strokeWeight = actorDetails.strokeWeight; 
    actorOnStage.red = actorDetails.red; 
    actorOnStage.green = actorDetails.green; 
    actorOnStage.blue = actorDetails.blue; 
    actorOnStage.alpha = actorDetails.alpha;
    actorOnStage.mode = actorDetails.mode;
  }
    
  void drawActorsOnStage(AudioFFT audioFFT){
                         
     for(int i = 0; i < actorsOnStage.size(); i++){
        actorsOnStage.get(i).draw(audioFFT);
     }                  
  }

  void clearActorsOnStage(){                             
    actorsOnStage.clear();                     
  }

}
