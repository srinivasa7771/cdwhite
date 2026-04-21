@isTest
private class RequestDiscountServiceTest {
 private static testmethod void test1() {
 String rid = getreqId();
  List<Request_Discounti__c> rdlst = [select id from Request_Discounti__c where id=:rid];
  Request_Discounti__c rdi = new Request_Discounti__c(Id=rid, Status__c='Approved');
 update rdi;
 }
 private static testmethod void test2() {
  String rid = getreqId();
  List<Request_Discounti__c> rdlst = [select id from Request_Discounti__c where id=:rid];
  Request_Discounti__c rdi = new Request_Discounti__c(Id=rid, Status__c='Rejected');
 update rdi;
}
private static testmethod void test3() {
  String rid = getreqId();
  List<Request_Discounti__c> rdlst = [select id from Request_Discounti__c where id=:rid];
  List<Request_Discount__c> rdclst = [select id from Request_Discount__c where MRequest_Discount__c =:rid];
  delete rdclst;
  delete rdlst;

}
 public static string getreqId() {
 testData.init();
 Account a=testData.accCrt(false);
         Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        List<g_reqitem__c> rqitmLst = [select id from g_reqitem__c where RQ__c=:r.Id];
  testData.triggersetting('RequestDiscountTrigger', true);
  testData.triggersetting('RequestDiscountItemTrigger', true);
  Request_Discounti__c rd = new Request_Discounti__c();
  rd.Name='test';
  rd.Status__c='Draft';
  insert rd;
  Request_Discount__c rdis = new Request_Discount__c();
  rdis.Name='test discount';
  rdis.MRequest_Discount__c =rd.Id;
  rdis.g_reqitem__c=rqitmLst[0].Id;
  insert rdis;
  List<Request_Discount__c> rddlst = [select id from Request_Discount__c where id=:rdis.id];
  Request_Discount__c rddi = new Request_Discount__c(Id=rdis.id, Service_Cost__c=10, EService_Cost__c=10, Service_Charge__c=10, EService_Charge__c=10);
  update rddi;
  return rd.Id;
 }
}