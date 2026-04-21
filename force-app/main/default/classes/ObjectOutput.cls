public class ObjectOutput {
    public List<String> objLst {get;set;}
    public Map<String, ObjectWrapper> objMap {get;set;}
  public void getObjects() {
system.debug('invoke');
     objMap = new Map<String, ObjectWrapper>();

        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

    for (Schema.SObjectType objType : globalDescribe.values()) {

        // Describe each object and walk through each field
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

        ObjectWrapper thisObj = new ObjectWrapper();

        thisObj.objApiName = objDescribe.getName();
        thisObj.objPrefix = objDescribe.getKeyPrefix();
        thisObj.objLabel = objDescribe.getLabel();

        objMap.put(thisObj.objApiName, thisObj);
    }
      system.debug('objMap keys'+objMap.keyset());
      system.debug('objMap values ---.'+objMap.values());
       system.debug('objMap ---.'+objMap);

    //  if (!objLst.isEmpty())
    //   objLst.addAll(objMap.keyset());

  }

  public class ObjectWrapper {

    public String objPrefix {get;set;}
    public String objApiName {get;set;}
    public String objLabel {get;set;}

  }

}