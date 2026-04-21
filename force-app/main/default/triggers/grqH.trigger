trigger grqH on g_Req__c(before insert,after insert,before update,after update,before delete,after delete) {
    if(trigger.isBefore){
        if(grqH.rBefore){
            grqH.rBefore=false;
            grqH.rH o=new grqH.rH();
            if(trigger.isInsert){o.hIB(trigger.new);}
            else if(trigger.isUpdate){o.hUB(trigger.newMap,trigger.oldMap);}
            else if(trigger.isDelete){o.hDB(trigger.oldMap);}
            grqH.rAfter=true;
        }
    } 
    else if(trigger.isAfter){
        if(grqH.rAfter){
            grqH.rAfter=false;
            grqH.rH o=new grqH.rH();
            if(trigger.isInsert){o.hIA(trigger.new);}
            else if(trigger.isUpdate){o.hUA(trigger.newMap,trigger.oldMap);}
            else if(trigger.isDelete){o.hDA(trigger.oldMap);}
        }
        if(trigger.isUpdate){grqH.rH o=new grqH.rH();o.clearProcessFlg(trigger.new,trigger.oldMap);} 
    }
}