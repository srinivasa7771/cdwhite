@isTest
public class BatchUpdateOPTest {
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
 static testMethod void unitTest() {

     List<g_reqitem__c> riLst = [select id, itm__c, sta__c from g_reqitem__c limit 1];

     if (riLst != null && !riLst.isEmpty()) {
       g_srvcitm__c si= [select id, name from g_srvcitm__c where cd__c = 'pt'];
       list<g_srvcitm_Status__c> stLst = [select id from g_srvcitm_Status__c where itm__c=:si.id limit 1];
       riLst[0].itm__c = si.id;
       riLst[0].sta__c = stLst[0].id;
       update riLst;

     }
     Datetime dt1 = Datetime.now().addyears(-1);
       Test.setCreatedDate(riLst[0].id, dt1);

     Test.startTest();
      g_reqitem__c riUpdate = [select id, itm__r.cd__c, sta__c, createddate, AP__C from g_reqitem__c where id=:riLst[0].id];
     //system.assertEquals(riUpdate.createddate, date.today());
     system.assertEquals(riUpdate.AP__C, 0);
     BatchUpdateOP obj = new BatchUpdateOP('LAST_N_DAYS:10');
     Database.executeBatch(obj, 1);
     Test.stopTest();
 }
}