public class BatchVatUpdts implements Database.Batchable <sObject> {
    private String queryString;
    public BatchVatUpdts(Integer mm, Integer yy) {
        queryString = 'SELECT id, Name, TAX_CODE__c, extc__c, TAXCODE_SC__c, extcsc__c, vec__c, vesch__c, vsc__c, vst__c, ' +
            ' itm__c, itm__r.TAX_CODE__c, itm__r.extc__c, itm__r.TAXCODE_SC__c, itm__r.extcsc__c, ' + ' itm__r.vec__c, itm__r.vesch__c, itm__r.vsc__c, itm__r.vst__c' +
            ' From g_reqitem__c WHERE sta__r.Tp__c=\'Open\'' + ' AND CALENDAR_MONTH(CreatedDate)='+ mm + ' AND CALENDAR_YEAR(CreatedDate)='+
            yy + ' AND IsDeleted=false AND TAX_CODE__c=\'\' Limit 9999';
        System.debug('queryString : ' + queryString);
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext bc, List < g_reqitem__c > lstReqI) {
        System.debug('<BatchVatUpdts> lstReqI : ' + lstReqI);
        for (g_reqitem__c rItm : lstReqI) {
            rItm.TAX_CODE__c = rItm.itm__r.TAX_CODE__c;
            rItm.extc__c = rItm.itm__r.extc__c;
            rItm.TAXCODE_SC__c = rItm.itm__r.TAXCODE_SC__c;
            rItm.extcsc__c = rItm.itm__r.extcsc__c;
            rItm.vec__c = rItm.itm__r.vec__c;
            rItm.vesch__c = rItm.itm__r.vesch__c;
            rItm.vsc__c = rItm.itm__r.vsc__c;
            rItm.vst__c = rItm.itm__r.vst__c;
        }
        System.debug('<BatchVatUpdts> lstReqI : ' + lstReqI);
        if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
            update lstReqI;
        }
    }
    public void finish(Database.BatchableContext bc) {
    }
}