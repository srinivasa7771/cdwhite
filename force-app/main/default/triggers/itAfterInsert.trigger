trigger itAfterInsert on Issue_Tracker__c (after insert) {
    if (trigger.isAfter && trigger.isInsert) {
      
      List < Issue_Tracker__c > listsupport =trigger.new;
    List < Issue_Tracker__c > newSupList= new List < Issue_Tracker__c >();
    for (Issue_Tracker__c i: listsupport) {
             if(i.Type__c!=null && i.Type__c.trim().length()>0 && !((i.Type__c.trim()).equalsIgnoreCase('Contact us'))){ 
             newSupList.add(i);
             }
    
    }
      supporthandler.IA(newSupList);
       //supporthandler.IA(trigger.new);
    }
}