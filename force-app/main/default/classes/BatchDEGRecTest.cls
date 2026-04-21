@isTest
private class BatchDEGRecTest {
    private static testMethod void BatchDEGRecTest() {
        new BatchDEGRec();

    }
    @IsTest
    private static  void recTest() {

          testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_reqMbr__c objM = new g_reqMbr__c();

       list<gStg__c> stgs=new list<gStg__c>();
        stgs.add(new gStg__c(Name='NI-APIKEY', Checkbox_Value__c=true, Text_Value__c='test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='NIENDPOINT', Checkbox_Value__c=true, Text_Value__c='test', Number_Value__c=0, Currency_Value__c=0));
         stgs.add(new gStg__c(Name='NIPAYMENTURL', Checkbox_Value__c=true, Text_Value__c='test', Number_Value__c=0, Currency_Value__c=0));
         stgs.add(new gStg__c(name='AdditionalParking', Text_Value__c = '154'));
          insert stgs;
          g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment', md__c='Credit Card', sta__c='Open');
         insert T;
        Test.setCreatedDate(T.Id, DateTime.newInstance(2020, 03, 03));
         Test.startTest();
        try{
           database.executeBatch(new BatchDEGRec(), 1);
        }catch (Exception e) {}
        Test.stopTest();
    }
}