@isTest
private class BatchCancelRequestsTest {
   @testSetup
    static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');
        g_req__c rq = testData.reqCrt(a.Id, s.Id, null, 'Draft', 'SELECT ID, Name, sta__c from g_req__c ');
    }

    @IsTest(SeeAllData=false)
    static void test1() {
        List<g_req__c> rq = [SELECT ID, Name, srvc__c, srvc__r.uid__c, sta__c, rist__c, updSTA__c, (Select id, name, sta__r.name, itm__c from items__r) from g_req__c limit 1];
        database.executeBatch(new BatchCancelRequests(), 1);
    }
}