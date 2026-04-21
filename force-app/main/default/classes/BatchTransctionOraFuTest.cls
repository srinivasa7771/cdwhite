@isTest
public class BatchTransctionOraFuTest {

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
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment', sta__c='Completed', dt__c=Date.today());
        g_Tran__c T1 = new g_Tran__c(md__c='Customer Deposit', Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment', sta__c='Completed', dt__c=Date.today());
        insert new List<g_Tran__c>{T, T1};
        Test.startTest();
        BatchTransctionOraFu bc = new BatchTransctionOraFu(Date.today().addDays(-1).format(), Date.today().addDays(1).format());
        bc = new BatchTransctionOraFu(T.id);
        Id jobid= Database.executeBatch(bc, 5);
        bc = new BatchTransctionOraFu(T1.id);
        Id jobid2= Database.executeBatch(bc, 5);
        bc = new BatchTransctionOraFu(Date.today().addDays(-1).format(), Date.today().addDays(1).format(), '', '', Date.today());
         bc = new BatchTransctionOraFu(Date.today().addDays(-1).format(), Date.today().addDays(1).format(), '');
         bc = new BatchTransctionOraFu(Date.today().addDays(-1).format(), Date.today().addDays(1).format(), '', 'ONLY_RECEIPT');
         bc = new BatchTransctionOraFu(Date.today().addDays(-1).format(), Date.today().addDays(1).format(), '', 'ONLY_INVOICE');
          bc = new BatchTransctionOraFu(Date.today().addDays(-1).format(), Date.today().addDays(1).format(), '', 'ONLY_RECEIPT', '');
         bc = new BatchTransctionOraFu(Date.today().addDays(-1).format(), Date.today().addDays(1).format(), '', 'ONLY_INVOICE', '');
        bc = new BatchTransctionOraFu(Date.today().addDays(-1).format(), Date.today().addDays(1).format(), '', 'ONLY_INVOICE', '', 1);

        bc = new BatchTransctionOraFu(Date.today().addDays(-1).format(), Date.today().addDays(1).format(), '', 'ONLY_INVOICE', '', 1);
        bc = new BatchTransctionOraFu(Date.today().addDays(-1).format(), Date.today().addDays(1).format(), '', 'DM', 1, 1);
        bc = new BatchTransctionOraFu(Date.today().addDays(-1).format(), Date.today().addDays(1).format(), '', 'DUMMY_RECEIPT', 1, 1);
        bc = new BatchTransctionOraFu(Date.today().addDays(-1).format(), Date.today().addDays(1).format(), '', 'DM', '', 1, 1);
        bc = new BatchTransctionOraFu(Date.today().addDays(-1).format(), Date.today().addDays(1).format(), '', 'DUMMY_RECEIPT', '', 1, 1);

        Test.stopTest();
    }
}