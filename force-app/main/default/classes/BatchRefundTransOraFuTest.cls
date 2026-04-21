@isTest
public  class BatchRefundTransOraFuTest {

    @testSetup
    public static void init() {
        List<gStg__c> sList = new List<gStg__c>();
        gStg__c s = new gStg__c(Name='BH');
        s.Text_Value__c = [SELECT Id FROM BusinessHours].id;
        gStg__c s2 = new gStg__c(Name='slaExpiry');
        s2.Number_Value__c = 50;
        sList.add(s);
        sList.add(s2);
        insert sList;
    }

    static testmethod void test1() {

        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, CMDMAPPRes__c=null, DMStatus__c='Success', TP__c='Refund', fwf__c=true, sta__c='Open', dt__c=Date.today());
        g_Tran__c T1 = new g_Tran__c(md__c='Customer Deposit', CMDMAPPRes__c=null, DMStatus__c='Success', Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Refund', fwf__c=true, sta__c='Open', dt__c=Date.today());
        insert new List<g_Tran__c>{T, T1};

        g_Tran__c T2 = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, CMDMAPPRes__c=null, md__c='Cash', DMStatus__c='Success', TP__c='Refund', fwf__c=true, sta__c='Open', dt__c=Date.today());
        g_Tran__c T3 = new g_Tran__c(md__c='Cash', CMDMAPPRes__c=null, DMStatus__c='Success', Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Refund', fwf__c=true, sta__c='Open', dt__c=Date.today());
        insert new List<g_Tran__c>{T2, T3};

        Test.startTest();
        BatchRefundTransOraFu bc = new BatchRefundTransOraFu('2023-07-01', '2025-11-20');
        bc.isTestClass= true;
        Id jobid= Database.executeBatch(bc, 5);

        Test.stopTest();
    }
    static testmethod void test2() {

        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_Tran__c T = new g_Tran__c(md__c='Customer Deposit', Acc__c=r.Acc__c, RQ__c=r.Id, CMDMAPPRes__c=null, DMStatus__c='Success', TP__c='Refund', fwf__c=true, sta__c='Open', dt__c=Date.today());
        g_Tran__c T1 = new g_Tran__c(md__c='Customer Deposit', CMDMAPPRes__c=null, DMStatus__c='Success',
            Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Refund', fwf__c=true, sta__c='Open', BU_Inv__c='test',
            dt__c=Date.today());
        insert new List<g_Tran__c>{T, T1};
            List<ORAMETA__c> oraList = new List<ORAMETA__c>();
        ORAMETA__c ora = new ORAMETA__c();
        ora.SERVICE__c = 'AXS';
        ora.SERVICE_TYPE__c = 'AXS';
        ora.TYPE__c = 'SERVICE';
        ora.BRAND__c = 'AXS';
        ora.PAYMENT_METHOD__c = 'AXSSWAP';
        oraList.add(ora);
        ORAMETA__c ora1 = new ORAMETA__c();
        ora1.SERVICE__c = 'AXS_SERVICE';
        ora1.TYPE__c = 'REFUND';
        ora1.BRAND__c = 'AXS';
        ora1.PAYMENT_METHOD__c = 'CUSTOMER DEPOSIT';
        oraList.add(ora1);
        insert oraList;

        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockLicRenewalres());
        BatchRefundTransOraFu bc = new BatchRefundTransOraFu(T1.id);
        bc.isTestClass= false;
        Id jobid2= Database.executeBatch(bc, 5);

        Test.stopTest();
    }
    static testmethod void test3() {

        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);

        g_Tran__c T2 = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, CMDMAPPRes__c=null, md__c='Cash', DMStatus__c='Success', TP__c='Refund', fwf__c=true, sta__c='Open', dt__c=Date.today());
        g_Tran__c T3 = new g_Tran__c(md__c='Cash', CMDMAPPRes__c=null, DMStatus__c='Success', Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Refund', fwf__c=true, sta__c='Open', dt__c=Date.today());
        insert new List<g_Tran__c>{T2, T3};

        Test.startTest();

        BatchRefundTransOraFu bc = new BatchRefundTransOraFu('2023-07-01', '2025-11-20');
        bc.isTestClass= false;
        Id jobid2= Database.executeBatch(bc, 5);

        Test.stopTest();
    }
   static testmethod void test4() {

        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);

        g_Tran__c T2 = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, CMDMAPPRes__c=null, md__c='Cash', DMStatus__c='Success', TP__c='Refund', fwf__c=true, sta__c='Open', dt__c=Date.today());
        g_Tran__c T3 = new g_Tran__c(md__c='Cash', CMDMAPPRes__c=null, DMStatus__c='Success', Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Refund', fwf__c=true, sta__c='Open', dt__c=Date.today());
        insert new List<g_Tran__c>{T2, T3};

        Test.startTest();

      BatchRefundTransOraFu bc = new BatchRefundTransOraFu('2023-07-01', '2025-11-20');
        bc.isTestClass= false;
        Id jobid2= Database.executeBatch(bc, 5);
        Test.stopTest();
    }
     public class MockLicRenewalres implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"serviceRequest":"Success"}');
            res.setStatusCode(200);
            return res;
        }
      }

}