@isTest
private class CouriersummaryTest {
    @testSetup static void setup() {

        List < gStg__c > lstGStg = new List < gStg__c > ();

        gStg__c bh = new gStg__c(name = 'BH', Text_Value__c = '01m20000000BKEa');
        lstGStg.add(bh);
        gStg__c sla = new gStg__c(name = 'slaExpiry', Number_Value__c = 50);
        lstGStg.add(sla);
        gStg__c cour = new gStg__c(name = 'Courier_login', Text_Value__c = '61812, 61812, AXSEMPOST');
        lstGStg.add(cour);
        insert lstGStg;

    }
    static testMethod void doTest() {

        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        Account a = testData.accCrt(false);
        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp = testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r = testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_reqitem__c rItm = [select id from g_reqitem__c limit 1];
        g_cmb__c cmb = new g_cmb__c();
        cmb.itm__c = rItm.id;
        insert cmb;
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Couriersummary ctrl = new Couriersummary(new ApexPages.StandardController(cmb));
        ctrl.lstSTA=ctrl.lstSTA;
        ctrl.fromDate = date.today();
        ctrl.toDate = date.today().addDays(5);
        ctrl.CouriersummaryMethod();
        Test.stopTest();
    }
    static testMethod void doTest1() {

        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        Account a = testData.accCrt(false);
        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp = testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r = testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_reqitem__c rItm = [select id from g_reqitem__c limit 1];
        g_cmb__c cmb = new g_cmb__c();
        cmb.itm__c = rItm.id;
        cmb.xawb__c = 24;
        cmb.sta__c = 'Alloted';
        insert cmb;
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Couriersummary ctrl = new Couriersummary(new ApexPages.StandardController(cmb));
        ctrl.fromDate = date.today();
        ctrl.toDate = date.today().addDays(5);
        ctrl.CouriersummaryMethod();
        ctrl.lstAXS = ctrl.lstAXS;
        ctrl.ConfirmImg = ctrl.ConfirmImg;
        ctrl.ErrorImg = ctrl.ErrorImg;
        Test.stopTest();
    }
    private class WebServiceMockImpl implements WebServiceMock {
        public void doInvoke(
            Object stub, Object request, Map < String, Object > response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType) {
            if (request instanceof EmpostWebservice.Login_element)
                response.put('response_x', new EmpostWebservice.LoginResponse_element());
            if (request instanceof EmpostWebservice.GetStatusSummary_element) {
                EmpostWebservice.GetStatusSummaryResponse_element res = new EmpostWebservice.GetStatusSummaryResponse_element();
                res.GetStatusSummaryResult = '{"summary" : [{"status" : "Alloted", "count" : "2"}, {"status" : "Cancelled", "count" : "0"}]}';
                response.put('response_x', res);
            }

            return;
        }
    }
}