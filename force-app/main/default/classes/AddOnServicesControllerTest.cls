// not using the class in any Vfpage --
@isTest
private class AddOnServicesControllerTest {
     static testmethod void test1() {
           testData.init();
         Account a=testData.accCrt(false);
          Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
          Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
           g_srvc_settings__c stg=testData.stgCrt();
          g_Srvc__c s=testData.srvcCrt(stg.Id);
        g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
          List<g_Req__c> rq = [select id from g_Req__c LIMIT 1];
         Test.startTest();
   String id = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
      AddOnServicesController ac = new AddOnServicesController();
         Test.stopTest();
    }
}