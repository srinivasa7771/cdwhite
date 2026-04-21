trigger grqSR on Survey_Request__c (after update) {
    
    if(trigger.isUpdate && trigger.isAfter && grqSRHandler.isSrTrigger){
        grqSRHandler.createCase(Trigger.new);
    } 
}