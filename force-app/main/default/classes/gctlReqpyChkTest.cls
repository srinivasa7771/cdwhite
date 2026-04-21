@isTest
private class gctlReqpyChkTest {
static testMethod void doTest() {
        boolean blV;String sV;
       testData.init(); /*MS*/
      list<gStg__c> stgs=new list<gStg__c>();
        stgs.add(new gStg__c(Name='NI-APIKEY', Checkbox_Value__c=true, Text_Value__c='test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='NIENDPOINT', Checkbox_Value__c=true, Text_Value__c='test', Number_Value__c=0, Currency_Value__c=0));
         stgs.add(new gStg__c(Name='NIPAYMENTURL', Checkbox_Value__c=true, Text_Value__c='test', Number_Value__c=0, Currency_Value__c=0));
         stgs.add(new gStg__c(name='AdditionalParking', Text_Value__c = '154'));
          insert stgs;
           Test.startTest();

        gctlReqpyChk obj = new gctlReqpyChk();
      //obj.prcssPay();
     obj.prcssPayRef('');
    obj.getPaymentResponse('');
    //obj.getJsonResponse('', '');
    obj.Chk();
    obj.parseDateDEG('02-02-2019 09:26:19.000+0000');
    String str = obj.lcl;
   List<g_Tran__c> trnLst = [select id from g_Tran__c where createddate=last_n_days:2 and md__c='Credit / Debit Card' limit 3];
   // obj.loadData(trnLst[0].id);
        Test.stopTest();

}
}