@isTest
private class grqWsDccaInvoiceServiceTest {
    @testSetup
    static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c req=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_Tran__c  tran = new g_Tran__c();
        tran.Acc__c =req.Acc__c;
        tran.tp__c = 'Payment';
        tran.STA__c = 'Completed';
        tran.RQ__c = req.id;
        insert tran;
    }
    static testmethod void test() {
         g_Req__c  req = [SELECT id, Acc__c FROM g_Req__c LIMIT 1];

        g_reqitem__c reqItem = [SELECT id FROM g_reqitem__c LIMIT 1];
        g_Tran__c tran = [select id, Name, md__c, RQ__r.name, A__c from g_Tran__c limit 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockBatchGen());
            grqWsDccaInvoiceService obj = new grqWsDccaInvoiceService();
            grqWsDccaInvoiceService.invWsCreation(tran, tran.id, reqItem.id);
        Test.stopTest();
    }
    static testmethod void test1() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockBatchGen());
            grqWsDccaInvoiceService obj = new grqWsDccaInvoiceService();
            grqWsDccaInvoiceService.dccaInvoiceCall('req');
        Test.stopTest();
    }
    public class MockBatchGen implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"inv":[{"refNo":"85302920190918", "payMethod":"Cash", "invNo":"T2019101937911", "invAmount":"15020.00", "error":null, "dccaSrId":"a1C6F00000SkX8WUAV"}]}');
            res.setStatusCode(200);
            return res;
        }
    }
}