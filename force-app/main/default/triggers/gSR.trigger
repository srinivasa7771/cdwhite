trigger gSR on Answer__c (before insert , after insert) {

     grqSurvey.generateResponse(trigger.New, Trigger.isBefore, Trigger.isAfter);

}