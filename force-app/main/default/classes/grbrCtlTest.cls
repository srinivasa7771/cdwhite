@isTest
public class grbrCtlTest {
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
        Test.startTest();
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        Account a = testData.accCrt(false);
        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp = testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r = testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_reqitem__c rItm = [select id from g_reqitem__c limit 1];
        g_cmb__c cmb = new g_cmb__c();
        cmb.itm__c = rItm.id;
        cmb.xawb__c = 15;
        insert cmb;

      grbrCtl obj=new grbrCtl(new ApexPages.StandardController(r));
      obj.cb=obj.cb;obj.id=obj.id;obj.loc=obj.loc;
      Test.stopTest();

  }
}