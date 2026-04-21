@IsTest
public class BatchCompleteReqTest {

    @testSetup
    static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');
        g_req__c rq = testData.reqCrt(a.Id, s.Id, null, 'Open', 'SELECT ID, Name, sta__c from g_req__c ');
    }

    @IsTest(SeeAllData=false)
    static void test1() {
        List<g_req__c> rq = [SELECT ID, Name, srvc__c, srvc__r.uid__c, sta__c, rist__c, updSTA__c, (Select id, name, sta__r.name, itm__c from items__r) from g_req__c limit 1];
        list<g_srvcitm_Status__c> STAs=[select id, name, noEXP__c from g_srvcitm_Status__c where srv_code__c=:rq[0].srvc__r.uid__c and Tp__c='Cancelled' and itm__c=:rq[0].items__r[0].itm__c];

        rq[0].items__r[0].sta__c = STAs[0].id;
        update rq[0].items__r[0];

        rq[0].sta__c = 'Open';
        update rq[0];

        database.executeBatch(new BatchCompleteReq(rq[0].items__r[0].id), 1);
        database.executeBatch(new BatchCompleteReq(), 1);
    }
}