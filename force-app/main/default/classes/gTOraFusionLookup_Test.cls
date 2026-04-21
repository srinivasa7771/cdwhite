@isTest
public class gTOraFusionLookup_Test {
    @testSetup static void setup() {
        ORAMETA__c orm = new ORAMETA__c();
        orm.TYPE__c = 'AXS-CM-Refund to AD';
        orm.SERVICE_TYPE__c = 'CREDIT_MEMO';
        orm.BRAND__c= 'AXS';
        orm.PAYMENT_METHOD__c= 'CUSTOMER DEPOSIT';
        insert orm;
    }
    static testmethod void meth1() {
        gTOraFusionLookup cls = new gTOraFusionLookup();
        Map <String, ORAMETA__c> ormMap = gTOraFusionLookup.getOraMetaLookup();
    }

}