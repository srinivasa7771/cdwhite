@istest
private class grqSRTest {
    static TestMethod void doTest() {
        gStg__c cs = new gStg__c();
        cs.name = 'BH';
        cs.Text_Value__c = '01m20000000BKEa';
        insert cs;
        gStg__c cs1 = new gStg__c();
        cs1.name = 'slaExpiry';
        cs1.Number_Value__c = 50;
        insert cs1;
        gStg__c cs2 = new gStg__c();
        cs2.name = 'Counter Survey';
        cs2.Text_Value__c = 'a150I000007UwjAQAS';
        insert cs2;

        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact con=testData.conCrt(null, a.Id, 'Active', 'Spouse', 'Pass1', 'Egypt');
        con.rol__c='Spouse';
        update con;
        g_Req__c r=testData.reqCrt(a.Id, s.Id, con.Id, 'Open', stg.reqq__c);
        Survey_Request__c sr = new Survey_Request__c();
        sr.Request__c= r.id;

        insert sr;
        Answer__c ans= new Answer__c();
        ans.Survey_Request__c =sr.id;
        ans.Answer_by_customer__c='test';
        insert ans;
        sr.Survey_Score__c=2;
        update sr;
    }
}