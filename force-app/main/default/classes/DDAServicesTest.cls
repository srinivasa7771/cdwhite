@isTest(SeeAllData=false)
public class DDAServicesTest {
    public static String dummyResp='';
    public static Integer statusCode= 200;
    static testmethod void testUploadDoc() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockGetResp());
        dummyResp = 'test';
        DDAServices.getDDAServices('DCCA_Auth', 'onbordingapi', 'POST', '');
        Test.stopTest();
    }

    static testmethod void documentPushBatch() {

        Test.setMock(HttpCalloutMock.class, new mockGetResp());
        ws_call__c wsCall = new ws_call__c();
        wsCall.ws_typ__c='Onboarding';
        wsCall.mtd_nm__c='ddaupload';
        wsCall.rq_jsn__c='a0PIk000000lPx8MAE';
        wsCall.pmid__c='a1CFV000000VbWL';
        wsCall.adhoc_text1__c='DDA Upload Load Testing 10 25-11';
        wsCall.intsts__c='Ready for Integration';
        insert wsCall;
        dummyResp = '[{"id":"a1JIk000000LvbyMAC"}, {"id":"a1JIk000000LvbzMAC"}, {"id":"a1JIk000000Lvc0MAC"}, {"id":"a1JIk000000Lvc1MAC"}]';
        Test.startTest();
        DocumentPushDDACCRMBatch batch = new DocumentPushDDACCRMBatch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
    static testmethod void documentPushBatchFailedTestCase() {

        Test.setMock(HttpCalloutMock.class, new mockGetResp());
        ws_call__c wsCall = new ws_call__c();
        wsCall.ws_typ__c='Onboarding';
        wsCall.mtd_nm__c='ddaupload';
        wsCall.rq_jsn__c='a0PIk000000lPx8MAE';
        wsCall.pmid__c='a1CFV000000VbWL';
        wsCall.adhoc_text1__c='DDA Upload Load Testing 10 25-11';
        wsCall.intsts__c='Ready for Integration';
        insert wsCall;
        statusCode=400;
        dummyResp = 'Reuqest is not valid';
        Test.startTest();
        DocumentPushDDACCRMBatch batch = new DocumentPushDDACCRMBatch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
    public class mockGetResp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(dummyResp);
            res.setStatusCode(statusCode);

            return res;
        }
    }

}