trigger RequestDiscountTrigger on Request_Discounti__c(before insert, after insert, before update, after update, before delete, after delete, after unDelete) {
    system.debug('run');
    TriggerDispatcher.run(new RequestDiscountTriggerHandler(),'RequestDiscountTrigger');
}