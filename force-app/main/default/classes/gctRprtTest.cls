@isTest(SeeAllData=true)
private class gctRprtTest {
static testMethod void doTest() {
Test.startTest();
 // testData.init();
            Profile p = [SELECT Id FROM Profile WHERE Name='Z'];

            List<User> u = [SELECT Id FROM User  WHERE ProfileId=:p.id AND IsActive=true LIMIT 5 ];

         /**   g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Student', 'test1', 'India');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Student', 'test12', 'India');

            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment');

        **/

                for (Integer i=0;i <= 4;i++) {
             System.runAs(u[i]) {

            gctRprt obj=new gctRprt();
             }
            }

Test.stopTest();
}

}