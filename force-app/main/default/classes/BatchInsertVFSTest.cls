@isTest
public class BatchInsertVFSTest {

      static TestMethod void doTest() {
              Test.startTest();
              testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_reqMbr__c objM = new g_reqMbr__c();
          ws_call__c cc= new ws_call__c();
          String x ='{"country":"Eritrea", "countrycode":"xer", "certificate":"Education certificate", "university":"ww", "colladdress":"3232", "contactnum":"527876543", "contactperson":"sdsd", "accid":"'+
              r.Acc__c+'", "reqstID":"'+r.id+'"}';
          cc.rq_jsn__c=x;
          x='{"country":"Eritrea", "countrycode":"xer", "certificate":"Education certificate", "university":"ww", "colladdress":"3232", "contactnum":"527876543", "contactperson":"sdsd", "accid":"0012000001G8hoXAAR", "reqstID":"a0E1s0000022gemEAA"}';
          cc.ws_typ__c='AutoInsertVFS';
          cc.intsts__c='Ready for Integration';
          insert cc;
          Database.executeBatch(new BatchInsertVFS());
          BatchInsertVFS.insertVFSReq(x);
          Test.stopTest();
    }

}