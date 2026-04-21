@isTest
public class grqwsLookupsTest {

    static testMethod void unitTest1() {
        list<gStg__c> stgs=new list<gStg__c>();
        stgs.add(new gStg__c(Name='GDRFAAPIKey', Checkbox_Value__c=true, Text_Value__c='test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFAUsr', Checkbox_Value__c=true, Text_Value__c='test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFAPwd', Checkbox_Value__c=true, Text_Value__c='test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFALookupAPI', Checkbox_Value__c=true, Text_Value__c='test', Number_Value__c=0, Currency_Value__c=0));
        insert stgs;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockApplicationProcess());
        grqwsLookups.upsertLookUpInfo('test', 'test');
        Test.stopTest();
    }
      public class MockApplicationProcess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{ "loopkupId" : "Test1", "parentLookupId" : "test1", "name" : { "ar" : "test1", "en" : "test1" }  }]');
            res.setStatusCode(200);
            return res;
        }
    }
}