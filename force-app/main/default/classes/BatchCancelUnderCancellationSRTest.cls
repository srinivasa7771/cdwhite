@isTest
public class BatchCancelUnderCancellationSRTest {

    Static testmethod void method1() {
        BatchTransctionOraFuTest.init();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        s.uid__c = '208';
        update s;
        a.lcsta__c = 'License Under Cancellation';
        update a;
        g_Req__c r=testData.reqCrt(a.Id, s.Id, null, 'Open', stg.reqq__c);
        Test.startTest();
        database.executebatch(new BatchCancelUnderCancellationSR(a.Id), 1);
        Test.stopTest();
    }
}