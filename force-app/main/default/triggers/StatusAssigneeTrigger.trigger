trigger StatusAssigneeTrigger on g_srvcitm_Status__c (before insert,before update) {
 for (g_srvcitm_Status__c status: Trigger.New){
if(Trigger.isBefore){
        if(Trigger.isInsert  || Trigger.IsUpdate ){
          //  StatusAssigneeTriggerHandler.insertMethod(trigger.newMap);
          List<String> st = new List<String>();
          
          if(status.Assignee__c != Null ){
           st = status.Assignee__c.split(';');    
          }
          if(st.size() > 0){
          String val = '';
          
          for(integer i = 1; i<= st.size();i++){
           val += i + st.get(i-1);  
           
           }
            val += st.size() + 1;
            status.asg__c = val;
            status.Load_Balance__c = st.size();
          }
           
           
          
        }
    }
      
  }  

}