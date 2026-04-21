public class RequestDiscountItemService {

    public Static void updateDiscountonRequestItem(Map<Id, Request_Discount__c> newMap, Map<Id, Request_Discount__c> oldMap) {
        Set<String> parentIds = new Set<String>();
        Map<ID, g_reqitem__c> parentItems = new Map<ID, g_reqitem__c>();
        Map<Id, Request_Discount__c> rdMap = new Map<Id, Request_Discount__c>([SELECT Id, Status__c, g_reqitem__c, Service_Charge__c, Service_Cost__c, EService_Charge__c,
                                                                             EService_Cost__c From Request_Discount__c Where Id IN :newMap.keyset()]);

        for (Request_Discount__c rd : rdMap.values()) {

            if (rd.Status__c == 'Approved') {

                parentIds.add(rd.g_reqitem__c);

            }

        }
        system.debug('parentIds'+parentIds);
        if (parentIds.size()>0) {
            parentItems = new Map<Id, g_reqitem__c>([SELECT id, cN__c, cXP__c, scN__c, scXP__c,
                (SELECT ID, Service_Charge__c, Service_Cost__c, EService_Charge__c, EService_Cost__c FROM Request_Discounts__r) FROM g_reqitem__c WHERE ID IN :parentIds]);
            system.debug('parentItems'+parentItems);
            for (Request_Discount__c disc: rdMap.values()) {
                g_reqitem__c myParentItem = parentItems.get(disc.g_reqitem__c);
                myParentItem.cN__c = disc.Service_Cost__c;
                myParentItem.cXP__c=disc.EService_Cost__c;
                myParentItem.scN__c = disc.Service_Charge__c;
                myParentItem.scXP__c=disc.EService_Charge__c;
            }

        }
        if (parentItems.size()>0) {
            if (Schema.sObjectType.g_reqitemDoc__c.isUpdateable()) { update parentItems.values(); }

        }

    }

}