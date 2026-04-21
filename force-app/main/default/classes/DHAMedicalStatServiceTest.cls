@isTest
private class DHAMedicalStatServiceTest {
  static testMethod void testMedicalFitStatus() {
      Test.startTest();
	   		testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
            Contact emp=testData.conCrt(sp,a.Id,'Active','Employee','Pass2','Egypt');
            g_Req__c r=testData.reqCrtOptItems(a.Id,s.Id,emp.Id,'Open',stg.reqq__c,'md');
           List<g_reqitem__c>  riItmLst =[select id,xf__c from g_reqitem__c where itm__r.cd__c ='md'];
           if(riItmLst != null && !riItmLst.isEmpty()){
              riItmLst[0].xf__c = '411079996364';
               update riItmLst;
           }
              
            RestRequest request = new RestRequest();
            RestResponse response = new RestResponse();
            request.requestURI = '/services/apexrest/dhamedservc/';
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueOf('{"appicationNum" : "411079996364","status":"5" }');
            RestContext.request = request;
            RestContext.response = response;
            
            DHAMedicalStatService.doPost();
        if(riItmLst != null && !riItmLst.isEmpty()){
          g_reqitem__c riUpdate =   [select id,sta__r.cd__c from g_reqitem__c where id=:riItmLst[0].id];
          system.assertEquals(riUpdate.sta__r.cd__c, 'ok');
          }
      Test.stopTest();
  }
    static testMethod void testMedicalUnFitStatus() {
      Test.startTest();
	   		testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
            Contact emp=testData.conCrt(sp,a.Id,'Active','Employee','Pass2','Egypt');
            g_Req__c r=testData.reqCrtOptItems(a.Id,s.Id,emp.Id,'Open',stg.reqq__c,'md');
           List<g_reqitem__c>  riItmLst =[select id,xf__c from g_reqitem__c where itm__r.cd__c ='md'];
           if(riItmLst != null && !riItmLst.isEmpty()){
              riItmLst[0].xf__c = '411079996364';
               update riItmLst;
           }
              
            RestRequest request = new RestRequest();
            RestResponse response = new RestResponse();
            request.requestURI = '/services/apexrest/dhamedservc/';
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueOf('{"appicationNum" : "411079996364","status":"8" }');
            RestContext.request = request;
            RestContext.response = response;
            
            DHAMedicalStatService.doPost();
        if(riItmLst != null && !riItmLst.isEmpty()){
          g_reqitem__c riUpdate =   [select id,sta__r.cd__c from g_reqitem__c where id=:riItmLst[0].id];
          system.assertEquals(riUpdate.sta__r.cd__c, 'u');
          }
      Test.stopTest();
  }
    static testMethod void testMedicalNotMatchedRequest() {
      Test.startTest();
	   		testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
            Contact emp=testData.conCrt(sp,a.Id,'Active','Employee','Pass2','Egypt');
            g_Req__c r=testData.reqCrtOptItems(a.Id,s.Id,emp.Id,'Open',stg.reqq__c,'md');
           List<g_reqitem__c>  riItmLst =[select id,xf__c from g_reqitem__c where itm__r.cd__c ='md'];
           if(riItmLst != null && !riItmLst.isEmpty()){
              riItmLst[0].xf__c = '411079996365';
               update riItmLst;
           }
              
            RestRequest request = new RestRequest();
            RestResponse response = new RestResponse();
            request.requestURI = '/services/apexrest/dhamedservc/';
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueOf('{"appicationNum" : "411079996364","status":"8" }');
            RestContext.request = request;
            RestContext.response = response;
            
            DHAMedicalStatService.doPost();
      
      Test.stopTest();
  }
     static testMethod void testMedicalEmptyRequest() {
      Test.startTest();
	   		testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null,a.Id,'Active','Employee','Pass1','Egypt');
            Contact emp=testData.conCrt(sp,a.Id,'Active','Employee','Pass2','Egypt');
            g_Req__c r=testData.reqCrtOptItems(a.Id,s.Id,emp.Id,'Open',stg.reqq__c,'md');
           List<g_reqitem__c>  riItmLst =[select id,xf__c from g_reqitem__c where itm__r.cd__c ='md'];
           if(riItmLst != null && !riItmLst.isEmpty()){
              riItmLst[0].xf__c = '411079996365';
               update riItmLst;
           }
              
            RestRequest request = new RestRequest();
            RestResponse response = new RestResponse();
            request.requestURI = '/services/apexrest/dhamedservc/';
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueOf('{"appicationNum" : "","status":"8" }');
            RestContext.request = request;
            RestContext.response = response;
            
            DHAMedicalStatService.doPost();
      
      Test.stopTest();
  }
}