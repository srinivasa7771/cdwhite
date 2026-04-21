@isTest
private class ClaimValidateTest {

     private static testmethod void  testClaimValidate(){

      list<gStg__c> stgs=new list<gStg__c>();
      stgs.add(new gStg__c(Name='parserAPIKey',Checkbox_Value__c=false,Text_Value__c='61347f4a4f793c1a90597d9e626d582ed86657c7',Number_Value__c=0,Currency_Value__c=0));
      stgs.add(new gStg__c(Name='parserAppDocId',Checkbox_Value__c=false,Text_Value__c='xsqivpmatwvj',Number_Value__c=0,Currency_Value__c=0));
      stgs.add(new gStg__c(Name='parserStmtDocId',Checkbox_Value__c=false,Text_Value__c='phhameyagqoz',Number_Value__c=0,Currency_Value__c=0));
       stgs.add(new gStg__c(Name='parserFileSize',Checkbox_Value__c=false,Text_Value__c='',Number_Value__c=3000000,Currency_Value__c=0));

        insert stgs;
        testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
        list<g_srvcitm__c> itms = [select id,Finance_Group__c from g_srvcitm__c where srvc__c=:s.id];
        for (g_srvcitm__c itm : itms)
            itm.Finance_Group__c = 'DNRD';
        update itms;
         Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
            Contact emp=testData.conCrt(sp,a.Id,'Active','Employee','Pass2','Egypt');
            g_Req__c r=testData.reqCrt(a.Id,s.Id,emp.Id,'Open',stg.reqq__c);
         g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c,RQ__c=r.Id,TP__c='Payment');
        insert T;
         g_reqitem__c i = r.Items__r[0];
      /*List<reconcil__c> lst = new List<reconcil__c>();
      lst.add(new reconcil__c(name = 'Test1',cdt__c = date.today(), iRef__c = '20102666341', A__c =552.50,Tp__c = 'Claim',Finance_Group__c = 'DNRD'));
      lst.add(new reconcil__c(name = 'Test2',cdt__c = date.today(), iRef__c = '20102666342', A__c =552.50,Tp__c = 'Claim',Finance_Group__c = 'DNRD'));
      lst.add(new reconcil__c(name = 'Test3',cdt__c = date.today(), iRef__c = '20102666343', A__c =552.50,Tp__c = 'Claim',Finance_Group__c = 'DNRD'));
      insert lst;*/
      List<g_TranItem__c> TIs = new List<g_TranItem__c>();
      TIs.add(new g_TranItem__c(itm__c = i.Id, T__c = T.Id,iRef__c = '20102666341', A__c =552.50,Tp__c = 'Claim'));
       TIs.add(new g_TranItem__c(itm__c = i.Id, T__c = T.Id,iRef__c = '20102666342', A__c =552.50,Tp__c = 'Claim'));
       TIs.add(new g_TranItem__c(itm__c = i.Id, T__c = T.Id,iRef__c = '20102666343', A__c =552.50,Tp__c = 'Claim'));
       insert  TIs;
      Test.startTest();

      ClaimValidate ctrl = new ClaimValidate();
      //List<selectOption> lst1 =ctrl.getFGLst();
      ctrl.fileType = 'DNRD';
      g_TranItem__c ti = new g_TranItem__c();
      ti.End_Date__c = date.today();
      ctrl.ti = ti;
      ctrl.nameFile = 'testfile.pdf';
      ctrl.contentFile = blob.valueOf('testfile');
      ctrl.contentStmtFile = blob.valueOf('testfile1');
      Test.setMock(HttpCalloutMock.class, new MockDocParserIdCall());
      ctrl.appNoUpload();
      Test.setMock(HttpCalloutMock.class, new MockDocParserAppInfo());
      ctrl.appValidate();
      Test.setMock(HttpCalloutMock.class, new MockDocParserStmtInfo());
      ctrl.validate();
      ctrl.nextPage();
      ctrl.exportDetails();
      Test.stopTest();
    }
     private static testmethod void  testClaimValidate1(){
      list<gStg__c> stgs=new list<gStg__c>();
      stgs.add(new gStg__c(Name='parserAPIKey',Checkbox_Value__c=false,Text_Value__c='61347f4a4f793c1a90597d9e626d582ed86657c7',Number_Value__c=0,Currency_Value__c=0));
      stgs.add(new gStg__c(Name='parserAppDocId',Checkbox_Value__c=false,Text_Value__c='xsqivpmatwvj',Number_Value__c=0,Currency_Value__c=0));
      stgs.add(new gStg__c(Name='parserStmtDocId',Checkbox_Value__c=false,Text_Value__c='phhameyagqoz',Number_Value__c=0,Currency_Value__c=0));
      insert stgs;
      Test.startTest();

      ClaimValidate ctrl = new ClaimValidate();
      //List<selectOption> lst =ctrl.getFGLst();
      ctrl.fileType = 'EIDA';
      g_TranItem__c ti = new g_TranItem__c();
      ti.End_Date__c = date.today();
      ctrl.ti = ti;
      ctrl.nameFile = 'testfile.pdf';
      ctrl.contentFile = blob.valueOf('"118030100023613792  01/03/2018 03:49 tecomi16 eidanew     DR 350.00  2.50 0.13 N/A 150992808 42748601032018TI000 Transaction from EIDA "');
      ctrl.appNoUpload();

      Test.stopTest();
    }
     private static testmethod void  testClaimValidate2(){
       list<gStg__c> stgs=new list<gStg__c>();
      stgs.add(new gStg__c(Name='parserAPIKey',Checkbox_Value__c=false,Text_Value__c='61347f4a4f793c1a90597d9e626d582ed86657c7',Number_Value__c=0,Currency_Value__c=0));
      stgs.add(new gStg__c(Name='parserAppDocId',Checkbox_Value__c=false,Text_Value__c='xsqivpmatwvj',Number_Value__c=0,Currency_Value__c=0));
      stgs.add(new gStg__c(Name='parserStmtDocId',Checkbox_Value__c=false,Text_Value__c='phhameyagqoz',Number_Value__c=0,Currency_Value__c=0));
      stgs.add(new gStg__c(Name='parserFileSize',Checkbox_Value__c=false,Text_Value__c='',Number_Value__c=3000000,Currency_Value__c=0));
       insert stgs;
        testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
        list<g_srvcitm__c> itms = [select id,Finance_Group__c from g_srvcitm__c where srvc__c=:s.id];
        for (g_srvcitm__c itm : itms)
            itm.Finance_Group__c = 'DNRD';
        update itms;
         Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
            Contact emp=testData.conCrt(sp,a.Id,'Active','Employee','Pass2','Egypt');
            g_Req__c r=testData.reqCrt(a.Id,s.Id,emp.Id,'Open',stg.reqq__c);
         g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c,RQ__c=r.Id,TP__c='Payment');
          insert T;
         g_reqitem__c i = r.Items__r[0];
      /*List<reconcil__c> lst = new List<reconcil__c>();
      lst.add(new reconcil__c(name = 'Test1',cdt__c = date.today(), iRef__c = '20102666341', A__c =552.50,Tp__c = 'Claim',Finance_Group__c = 'DNRD'));
      lst.add(new reconcil__c(name = 'Test2',cdt__c = date.today(), iRef__c = '20102666342', A__c =552.50,Tp__c = 'Claim',Finance_Group__c = 'DNRD'));
      lst.add(new reconcil__c(name = 'Test3',cdt__c = date.today(), iRef__c = '20102666343', A__c =552.50,Tp__c = 'Claim',Finance_Group__c = 'DNRD'));
      insert lst;*/
      List<g_TranItem__c> TIs = new List<g_TranItem__c>();
      TIs.add(new g_TranItem__c(itm__c = i.Id, T__c = T.Id,iRef__c = '20102666341', A__c =552.50,Tp__c = 'Claim'));
       TIs.add(new g_TranItem__c(itm__c = i.Id, T__c = T.Id,iRef__c = '20102666342', A__c =552.50,Tp__c = 'Claim'));
       TIs.add(new g_TranItem__c(itm__c = i.Id, T__c = T.Id,iRef__c = '20102666343', A__c =552.50,Tp__c = 'Claim'));
       insert  TIs;
      Test.startTest();

      ClaimValidate ctrl = new ClaimValidate();
      //List<selectOption> lst1 =ctrl.getFGLst();
      ctrl.fileType = 'DNRD';
      g_TranItem__c ti = new g_TranItem__c();
      ti.End_Date__c = date.today();
      ctrl.ti = ti;
      ctrl.nameFile = 'testfile.pdf';
      ctrl.nameStmtFile = 'testfile1.pdf';
      ctrl.contentFile = blob.valueOf('testfile');
      ctrl.contentStmtFile = blob.valueOf('testfile1');
      Test.setMock(HttpCalloutMock.class, new MockDocParserIdCall());
      ctrl.appNoUpload();
      Test.setMock(HttpCalloutMock.class, new MockDocParserErrInfo());
      ctrl.appValidate();
      Test.setMock(HttpCalloutMock.class, new MockDocParserErrInfo());
      ctrl.validate();
      ctrl.nextPage();
      ctrl.exportDetails();
      Test.stopTest();
    }
     private static testmethod void  testClaimValidate3(){
       list<gStg__c> stgs=new list<gStg__c>();
      stgs.add(new gStg__c(Name='parserAPIKey',Checkbox_Value__c=false,Text_Value__c='61347f4a4f793c1a90597d9e626d582ed86657c7',Number_Value__c=0,Currency_Value__c=0));
      stgs.add(new gStg__c(Name='parserAppDocId',Checkbox_Value__c=false,Text_Value__c='xsqivpmatwvj',Number_Value__c=0,Currency_Value__c=0));
      stgs.add(new gStg__c(Name='parserEIDAId',Checkbox_Value__c=false,Text_Value__c='ljyqedcmjgqy',Number_Value__c=0,Currency_Value__c=0));
      stgs.add(new gStg__c(Name='parserEVisionId',Checkbox_Value__c=false,Text_Value__c='afvlyskunblz',Number_Value__c=0,Currency_Value__c=0));
      stgs.add(new gStg__c(Name='parserVISAId',Checkbox_Value__c=false,Text_Value__c='rjfzayhnauiw',Number_Value__c=0,Currency_Value__c=0));
      stgs.add(new gStg__c(Name='parserStmtDocId',Checkbox_Value__c=false,Text_Value__c='phhameyagqoz',Number_Value__c=0,Currency_Value__c=0));
      stgs.add(new gStg__c(Name='parserFileSize',Checkbox_Value__c=false,Text_Value__c='',Number_Value__c=3000000,Currency_Value__c=0));
       insert stgs;
        testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
        list<g_srvcitm__c> itms = [select id,Finance_Group__c from g_srvcitm__c where srvc__c=:s.id];
        for (g_srvcitm__c itm : itms)
            itm.Finance_Group__c = 'E-Vision';
        update itms;
         Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
            Contact emp=testData.conCrt(sp,a.Id,'Active','Employee','Pass2','Egypt');
            g_Req__c r=testData.reqCrt(a.Id,s.Id,emp.Id,'Open',stg.reqq__c);
         g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c,RQ__c=r.Id,TP__c='Payment');
          insert T;
         g_reqitem__c i = r.Items__r[0];
      /*List<reconcil__c> lst = new List<reconcil__c>();
      lst.add(new reconcil__c(name = 'Test1',cdt__c = date.today(), iRef__c = '20102666341', A__c =552.50,Tp__c = 'Claim',Finance_Group__c = 'DNRD'));
      lst.add(new reconcil__c(name = 'Test2',cdt__c = date.today(), iRef__c = '20102666342', A__c =552.50,Tp__c = 'Claim',Finance_Group__c = 'DNRD'));
      lst.add(new reconcil__c(name = 'Test3',cdt__c = date.today(), iRef__c = '20102666343', A__c =552.50,Tp__c = 'Claim',Finance_Group__c = 'DNRD'));
      insert lst;*/
      List<g_TranItem__c> TIs = new List<g_TranItem__c>();
      TIs.add(new g_TranItem__c(itm__c = i.Id, T__c = T.Id,iRef__c = '20102666341', A__c =552.50,Tp__c = 'Claim'));
       TIs.add(new g_TranItem__c(itm__c = i.Id, T__c = T.Id,iRef__c = '20102666342', A__c =552.50,Tp__c = 'Claim'));
       TIs.add(new g_TranItem__c(itm__c = i.Id, T__c = T.Id,iRef__c = '20102666343', A__c =552.50,Tp__c = 'Claim'));
       insert  TIs;
      Test.startTest();

      ClaimValidate ctrl = new ClaimValidate();
      //List<selectOption> lst1 =ctrl.getFGLst();
      ctrl.fileType = 'ALL';
       g_TranItem__c ti = new g_TranItem__c();
      ti.End_Date__c = date.today();
      ctrl.ti = ti;
      ctrl.nameFile = 'testfile.pdf';
      ctrl.nameStmtFile = 'testfile1.pdf';
      ctrl.ePFile = 'testfile2.pdf';
      ctrl.contentFile = blob.valueOf('testfile');
      ctrl.contentEPFile = blob.valueOf('testfile2');
      ctrl.contentStmtFile = blob.valueOf('testfile1');
      Test.setMock(HttpCalloutMock.class, new MockDocParserIdCall());
      ctrl.appNoUpload();
      Test.setMock(HttpCalloutMock.class, new MockDocParserAppInfo());
      ctrl.appValidate();

      Test.stopTest();
    }
    public class MockDocParserIdCall implements HttpCalloutMock  {
       public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id":"455456546457575757"}');
        res.setStatusCode(200);
        return res;
     }
    }
   public class MockDocParserAppInfo implements HttpCalloutMock  {
       public HTTPResponse respond(HTTPRequest req) {
         system.debug('req::'+req.getBody() );
         system.debug('req1::'+req.getEndpoint() );
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if (req.getEndpoint().contains('xsqivpmatwvj'))
          res.setBody('{{"table_data": [{"key_0": 20102666340,"key_1": "201/2018/7222808","key_2": "18/03/2018","key_3": "Urgent","key_4": 552.50, "key_5": "NOQODI-EXPRESS PAY", "key_6": 33353062},{"key_0": 20102666341,"key_1": "201/2018/7222808","key_2": "18/03/2018","key_3": "Urgent","key_4": 552.50, "key_5": "NOQODI-EXPRESS PAY", "key_6": 33310000}]}}');
        else if (req.getEndpoint().contains('rjfzayhnauiw'))
          res.setBody('{{"table_data": [{"key_0":"","key_1":20102666340,"key_2":"test","key_3":33353062,"key_4":552.50,"key_5":"NOQODI-EXPRESS PAY","key_6":33353062},{"key_0":"","key_1":20102666340,"key_2":"test","key_3":33310000,"key_4":552.50,"key_5":"NOQODI-EXPRESS PAY","key_6":33310000}] }}');
        else if (req.getEndpoint().contains('afvlyskunblz'))
          res.setBody('{{"table_data": [{"key_0":38886185,"key_1":"mkutty","key_2":"eForm Vision","key_3":20166820180296130,"key_4":436.75,"key_5":"NOQODI-EXPRESS PAY","key_6":33353062},{"key_0":38887110,"key_1":"mkutty","key_2":"eForm Vision","key_3":20132120180181126,"key_4":552.50,"key_5":"NOQODI-EXPRESS PAY","key_6":33310000}] }}');
        else if (req.getEndpoint().contains('phhameyagqoz'))
          res.setBody('{{"table_data": [{"key_0":"","key_1":38886185,"key_2":"eForm Vision","key_3":20166820180296130,"key_4":436.75,"key_5":436.75,"key_6":""},{"key_0":"","key_1":38887110,"key_2":"eForm Vision","key_3":20132120180181126,"key_4":552.50,"key_5":552.50,"key_6":""}] }}');
        else
          res.setBody('{{"table_data": [{"key_0": 20102666340,"key_1": "201/2018/7222808","key_2": "18/03/2018","key_3": "Urgent","key_4": 552.50, "key_5": "NOQODI-EXPRESS PAY", "key_6": 33353062},{"key_0": 20102666341,"key_1": "201/2018/7222808","key_2": "18/03/2018","key_3": "Urgent","key_4": 552.50, "key_5": "NOQODI-EXPRESS PAY", "key_6": 33310000}]}}');

        res.setStatusCode(200);
        return res;
     }
    }
   public class MockDocParserStmtInfo implements HttpCalloutMock  {
       public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
           res.setBody('{{"table_data": [{"key_0": "","key_1": "33310000","key_2": "mmeethal","key_3": "eForm Vision","key_4": "eForm Vision Charges", "key_5": "515.75", "key_6": ""},{"key_0": "","key_1": "33310000","key_2": "mmeethal","key_3": "eForm Vision","key_4": "eForm Vision Charges", "key_5": "3.00", "key_6": ""},{"key_0": "","key_1": "33310000","key_2": "mmeethal","key_3": "eForm Vision","key_4": "eForm Vision Charges", "key_5": "0.75", "key_6": ""}]}}');
        res.setStatusCode(200);
        return res;
     }
    }
    public class MockDocParserErrInfo implements HttpCalloutMock  {
       public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
           res.setBody('{"error": "records not yet processed"}');
        res.setStatusCode(200);
        return res;
     }
    }
}