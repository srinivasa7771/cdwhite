@isTest
private class gctlPaymentHistoryTest {
    
      static testMethod void unitTest01() {
        testData.init();
        list<gStg__c> stgs=new list<gStg__c>();
        stgs.add(new gStg__c(Name='GDRFAEntryPermitID',Checkbox_Value__c=true,Text_Value__c='Test',Number_Value__c=0,Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFAResidenceID',Checkbox_Value__c=true,Text_Value__c='Test',Number_Value__c=0,Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFARenewResidenceID',Checkbox_Value__c=true,Text_Value__c='Test',Number_Value__c=0,Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFACancelResidenceID',Checkbox_Value__c=true,Text_Value__c='Test',Number_Value__c=0,Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFAAPI',Checkbox_Value__c=true,Text_Value__c='Test',Number_Value__c=0,Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFAAPIKey',Checkbox_Value__c=true,Text_Value__c='Test',Number_Value__c=0,Currency_Value__c=0));
        stgs.add(new gStg__c(Name='OCR_APIKEY',Checkbox_Value__c=true,Text_Value__c='Test',Number_Value__c=0,Currency_Value__c=0));
        stgs.add(new gStg__c(Name='OCR_ENDPOINT',Checkbox_Value__c=true,Text_Value__c='Test',Number_Value__c=0,Currency_Value__c=0));
        stgs.add(new gStg__c(Name='RP_Cancel',Checkbox_Value__c=true,Text_Value__c='Test',Number_Value__c=0,Currency_Value__c=0));
        insert stgs;
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false); 
        Contact emp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
        g_jb__c jb = new g_jb__c(Name='SENIOR ENGINEER',cd__c='1210002',jtar__c='مدير',uid__c='SENIOR ENGINEER');insert jb;
        g_Req__c r=testData.reqCrtOptItems(a.Id,s.Id,emp.Id,'Open',stg.reqq__c,'ep,rp');
        
        Test.startTest();
          
          apexpages.currentpage().getparameters().put('id', r.id);
          gctlPaymentHistory obj = new gctlPaymentHistory();
        Test.stopTest();
    }

}