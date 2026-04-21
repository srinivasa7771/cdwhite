trigger RequestDiscountItemTrigger on Request_Discount__c(before insert, after insert, before update, after update, before delete, after delete, after unDelete) {
    system.debug('run');
    TriggerDispatcher.run(new RequestDiscountItemTriggerHandler(),'RequestDiscountItemTrigger');
}