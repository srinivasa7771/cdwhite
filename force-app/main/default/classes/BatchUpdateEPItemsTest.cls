@IsTest
public class BatchUpdateEPItemsTest {

    @testSetup
    static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');
        Contact con =  testData.conCrt(null, a.id, 'Active', 'Employee', 'testQ123Z', 'India');
        g_req__c rq = testData.reqCrt(a.Id, s.Id, con.id, 'Open', 'SELECT ID, Name, sta__c from g_req__c ');
    }

    @IsTest(SeeAllData=false)
    static void test1() {
        List<g_req__c> rq = [SELECT ID, Name, srvc__c, srvc__r.uid__c, sta__c, rist__c, updSTA__c, (Select id, name, sta__r.name, sta__r.id, itm__c from items__r) from g_req__c limit 1];
        list<g_srvcitm_Status__c> STAs=[select id, name, noEXP__c from g_srvcitm_Status__c where srv_code__c=:rq[0].srvc__r.uid__c and Tp__c='Completed' and itm__c=:rq[0].items__r[0].itm__c];

        g_Milestone__c mls = new g_Milestone__c(Request__c=rq[0].id);
        insert mls;

        g_itmHistorySTA__c hist = new g_itmHistorySTA__c(itm__c= rq[0].items__r[0].id, RQ__c=rq[0].id, t__c=STAs[0].id, f__c=rq[0].items__r[0].sta__r.id, Milestone__c=mls.id);
        insert hist;

        database.executeBatch(new BatchUpdateEPItems(), 1);
    }
}