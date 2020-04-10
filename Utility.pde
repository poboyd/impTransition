class Utility {
        
  
  List<Field> getAllFields(List<Field> fields, Class<?> type) {
    fields.addAll(Arrays.asList(type.getDeclaredFields()));

    // get any extend fields as well 
    if (type.getSuperclass() != null) {
        getAllFields(fields, type.getSuperclass());
    }

    return fields;
  }

  String getObjectJson(Object instance)
  {         
     Class thisClass = instance.getClass();
     String jsonPropertyData="{class:"+thisClass.getCanonicalName().toString();
                         
     List<Field> allfields = getAllFields(new LinkedList<Field>(), thisClass);    
             
     for (int ii = 0; ii < allfields.size(); ii++) {              
        try{               
             String fieldName = allfields.get(ii).getName().toString(); //<>//
             String fieldValue = trim(allfields.get(ii).get(instance).toString()); //<>//
                          
             Class<?> fieldType = allfields.get(ii).getType();
                          
             if (fieldType.equals(ArrayList.class))
             {   //println( "ArrayList:" + fieldName + " fieldValue:" + fieldValue + " Type:" + fieldType.getCanonicalName());  
                 String newJson =  fieldName + ":["   ;  
                 
                 ArrayList objectChildren = (ArrayList) allfields.get(ii).get(instance);
                 for (int x=0; x<objectChildren.size(); x++) {
                   
                   if (x>0) newJson+=",";
                   newJson += getObjectJson( objectChildren.get(x));
                   
                   //println( "ArrayList objects:" + newJson);
                 }
                 
                 // resures through arraylist here
                 
                 jsonPropertyData += "," + newJson + "]";
                 
             }
             else{  
                if (!fieldName.startsWith("this$")){ 
                  String newJson =  fieldName + ":" +  trim(fieldValue);                   //<>//
                  jsonPropertyData += "," + newJson;
                  //println( "fieldName:" + fieldName + " fieldValue:" + fieldValue + " Type:" + fieldType.getCanonicalName());
                }
             }
             
         }   
       catch (ReflectiveOperationException e) {     
         // Ignore private field errors, couldnt find a better way to ignore private fields    
         //println( "ReflectiveOperationException:   " + e.toString() );
        }
        
       //println( "Type:   " + thisClass.getDeclaredFields()[i].getType().toString() );
     }                                          
        
     jsonPropertyData += "}";
     
    // println( "getObjectJson:   " + jsonPropertyData );
     
     return jsonPropertyData;   
  }
  
  
  
  

  
  void setObjectFromJson(Object thisthis, Object instance, String jsonArrayData){
       Class thisClass = instance.getClass();   
       String getClass = thisClass.getCanonicalName().toString();
       
       //println("thisClass: "+thisClass.toString());
        
       boolean foundMatch = false;
        
       JSONArray jsonArray = parseJSONArray(jsonArrayData);
       JSONObject json = parseJSONObject(jsonArray.getJSONObject(0).toString());
       
       for (int i = 0; i < jsonArray.size(); i++) {  
           String jsondata = jsonArray.getJSONObject(i).toString();
           json = parseJSONObject(jsondata);
                      
           // Search for class name in this Json element, see if it matches our Object instance class
           for (Object key : json.keys()) {       
              String keyStr = (String)key;
              Object keyvalue = json.get(keyStr);      
              //println( "keyStr.startsWith(getclass): " + keyStr.startsWith("getclass") + "  keyvalue.toString().equals(getClass.toString()):" + keyvalue.toString().equals(getClass.toString()) );
              if (keyStr.startsWith("class") && keyvalue.toString().equals(getClass.toString()) ){                                    //<>//
                  //println( "FOUND Matching getClass:" + getClass + " keyvalue:" + keyvalue.toString() );
                  foundMatch = true;
                  break;                
              }                       
           }   
           
           if (foundMatch)
             break;           
       }
       
       if (!foundMatch){
          //println( "setObjectFromJson NO MATCH FOUND FOR  " + getClass ); //<>//
          return;
       }
               
       for (Object key : json.keys()) {        //<>//
          String keyStr = (String)key;
          Object keyvalue = json.get(keyStr);
          
          try{
            if (!keyStr.startsWith("this") && !keyStr.startsWith("class") ){
              Field field = thisClass.getField(keyStr);
              field.setAccessible(true);                    
                                                                                                                                                                                                           
              if (field.getType().equals(ArrayList.class))
              {                                        
                JSONArray arrayListObjects = parseJSONArray( keyvalue.toString() );                
               
                ArrayList<Object> objectsArray = new ArrayList<Object>();
            
                //println( "Found ArrayList:" + keyvalue.toString() );
            
                for (int i = 0; i < arrayListObjects.size(); i++) {                    
                                           
                    JSONObject objectjson = arrayListObjects.getJSONObject(i);                                                                            
                    
                    String newObjectJsonClass = getJSONValue(objectjson.toString(), "class").replace("impTransition.", "impTransition$").trim();                                    
                    //println( "Adding array object:" + i + "   newObjectJsonClass: -"  + newObjectJsonClass + "-");                                                                                                                                                                              
                                                                                                     
                    Class c = Class.forName(newObjectJsonClass);      
                    
                    Object newObject = null;
                    
                    
                    // We are assuming the object has a contructor like... Actor(String thisname, int thistype)
                    Constructor[] allConstructors = c.getDeclaredConstructors();                   
                    for (Constructor ctor : allConstructors) {
                      //Class<?>[] pType  = ctor.getParameterTypes(); 
                      //println( "ctor: " + ctor.toString() + "    pType:" + pType.toString());
                      newObject =  ctor.newInstance(thisthis, (java.lang.String)"Name", (int)0);                     
                      break;
                    }
                                                                                                
                    //println( "newObject:" + newObject.toString());                                         
                                          
                    utility.setObjectFromJson(thisthis,  newObject , "[" + objectjson.toString() + "]");
                    objectsArray.add(newObject);                                          
                  }   
                  
                  field.set(instance, objectsArray);
                 
              }                                                                                                                                                                                                                                                           
              else if (field.getType().toString()=="float")
              {
                field.set(instance, (float)keyvalue);
              }
              else
               field.set(instance, keyvalue);
               
              //println("SET field.getType(): "+ field.getType().toString() + "  keyvalue:" + keyvalue.toString() );
            }
            
          }catch (Exception ex){
            // ignore unknown fields            
            println( "setObjectFromJson field " + keyStr + " error:   " + ex.toString() );
            //throw ex;
          }          
          //println("key: "+ keyStr + " value: " + keyvalue);
      }
       
      //println(getObjectJson(instance));                                    
  }


  public String getJSONValue(String JSONString, String Field)
  {
       return JSONString.substring(JSONString.indexOf(Field), JSONString.indexOf("\n", JSONString.indexOf(Field))).replace(Field+"\": \"", "").replace("\"", "").replace(",","");   
  }

  boolean fileExists(String path) {
    File file=new File(path);
    println(file.getName());
    boolean exists = file.exists();
    if (exists) {
      println("true");
      return true;
    }
    else {
      println("false");
      return false;
    }
  } 

}
