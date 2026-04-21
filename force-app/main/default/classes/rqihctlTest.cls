@isTest
private class rqihctlTest {
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
        g_reqitem__c rItm = [select id, name from g_reqitem__c limit 1];
        g_reqitem__History rItmhst = new g_reqitem__History(ParentId=rItm.id, Field='xr__c');
        insert rItmhst;
        Test.startTest();
         ApexPages.currentPage().getParameters().put('id', rItm.id);
         rqihctl ctrl = new rqihctl();
         ctrl.getHistories();

        Test.stopTest();

 }
    static testMethod void doTest1() {
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        Account a = testData.accCrt(false);
        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp = testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r = testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_reqitem__c rItm = [select id, name from g_reqitem__c limit 1];

        List<g_reqitem__History> rItmhstlst = new List<g_reqitem__History>();
        g_reqitem__History rItmhst = new g_reqitem__History(ParentId=rItm.id, Field='xfld__c');
        rItmhstlst.add(rItmhst);
        rItmhst = new g_reqitem__History(ParentId=rItm.id, Field='xfld__c');
        rItmhstlst.add(rItmhst);

        insert rItmhstlst;
        Test.startTest();
         ApexPages.currentPage().getParameters().put('id', rItm.id);
         rqihctl ctrl = new rqihctl();
         ctrl.getHistories();

        Test.stopTest();

 }

}