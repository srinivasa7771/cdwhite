trigger giH on g_reqitem__c (before insert,after insert,before update,after update,before delete,after delete) {
    if(trigger.isBefore){
        grqH.mSTAs=null;
        grqH.mRqs=null;
        grqH.miUsrs=null;
        grqH.miCtcts=null; 
        if(grqH.iBefore){            
            grqH.iBefore=false;
            grqH.iH o=new grqH.iH();
            if(trigger.isInsert){o.hIB(trigger.new);}
            else if(trigger.isUpdate){o.hUB(trigger.newMap,trigger.oldMap);}
            else if(trigger.isDelete){o.hDB(trigger.oldMap);}
            grqH.iAfter=true;
        }
    } 
    else if(trigger.isAfter){
        if(grqH.iAfter){
            grqH.iAfter=false;
            grqH.iH o=new grqH.iH();
            if(trigger.isInsert){o.hIA(trigger.new);}
            else if(trigger.isUpdate){o.hUA(trigger.newMap,trigger.oldMap);}
            else if(trigger.isDelete){o.hDA(trigger.oldMap);}
            grqH.iBefore=true;           
        }
   }
}