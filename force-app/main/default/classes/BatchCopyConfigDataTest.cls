@isTest
public class BatchCopyConfigDataTest {
     @testSetup static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);

    }
    static testmethod void test1() {
    List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        g_Srvc__c gs = new g_Srvc__c(id=srvcLst[0].Id, AccTp__c='Customer - External;', copyCofig__c=false, uid__c='ltc');
        update gs;
        Test.startTest();
        BatchCopyConfigData bt = new BatchCopyConfigData();
        database.executeBatch(bt, 2);
        Test.stopTest();
    }

}