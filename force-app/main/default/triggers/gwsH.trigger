trigger gwsH on ws_call__c (before insert,after insert) {
    if(trigger.isBefore){
        
    } 
    else if(trigger.isAfter){
        if(gwsH.rAfter){
            //gwsH.rAfter=false;
            gwsH.wsH o=new gwsH.wsH();
            if(trigger.isInsert){o.hIA(trigger.new);}
           /* else if(trigger.isUpdate){o.hUA(trigger.newMap,trigger.oldMap);}
            else if(trigger.isDelete){o.hDA(trigger.oldMap);}*/
        }
       
    }
}