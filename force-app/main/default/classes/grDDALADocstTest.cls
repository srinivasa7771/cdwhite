@isTest
public class grDDALADocstTest {
    static testmethod void peMethod() {
        Test.startTest() ;
        ws_call__c ws = new ws_call__c();
        ws.mtd_nm__c='LADocs';
        insert ws;
        List<id> laddList = new List<id>();
        LADocs__e lde=new LADocs__e();
        lde.wsid__c=ws.id;
        Database.saveresult sr=EventBus.publish(lde);
        Test.stopTest();
    }

}