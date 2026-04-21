trigger emailMessageTrigger on EmailMessage (after insert,before insert) {
    if(trigger.isBefore && trigger.isInsert){
        emailMessageHandler.appendCaseNumber(trigger.new);
    }
    if(trigger.isAfter && trigger.isInsert){
        emailMessageHandler.updateCase(trigger.new);
    }
}