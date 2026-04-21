@isTest
private class BatchContactRPValidityTest {

    static void loadData(String app) {
        testData.init();
        list<gStg__c> stgs=new list<gStg__c>();
        stgs.add(new gStg__c(Name='GDRFAEntryPermitID', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFAResidenceID', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFARenewResidenceID', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFACancelResidenceID', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFAAPI', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFAAPIKey', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='OCR_APIKEY', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='OCR_ENDPOINT', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='RP_Cancel', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        insert stgs;

        Account a=testData.accCrt(false);
        a.ec__c='22000064';
        update a;
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        emp.Email='test@gmail.com';
        emp.nc__c = 'Egypt';
        emp.firstname = 'Ahmed';
        emp.e__c = '201/2022/23455';
        emp.Birthdate = date.today();
        update emp;
      }
    static testMethod void unitTest01() {
        Test.startTest();
        loadData('');
        Test.setMock(HttpCalloutMock.class, new MockApplicationProcess('Application'));
        Database.executeBatch(new BatchContactRPValidity('Employee'));
        Test.stopTest();
    }
    static testMethod void unitTest02() {
        Test.startTest();
        loadData('');
        Test.setMock(HttpCalloutMock.class, new MockApplicationProcess('Application'));
        ApplicationDetailsWrapper wrp = new ApplicationDetailsWrapper();
        wrp.applicationId = '';wrp.applicationId = '';wrp.sponsorEstCode = '';wrp.applicantEstCode = '';
         wrp.paymentDate = '';wrp.contactMobilePhone = '';wrp.createdOn = '';
        contact con = [select id from contact limit 1];
        BatchContactRPValidity obj = new BatchContactRPValidity(con.id);

        Database.executeBatch(obj);
        Test.stopTest();
    }
    public class MockApplicationProcess implements HttpCalloutMock {
        public String responseBody;
        public Integer statusCode;
        public MockApplicationProcess(String appName) {
         if (appName=='Application') {
                statusCode=200;
                responseBody = '{"IssueDate":"2021-08-10", "expiryDate":"2025-08-10", "IsSuccess":true}';
            } else if (appName=='ApplicationFailed') {
                statusCode=400;
                responseBody = '{"errorMsg":[{"messageEn":"We encountered unexpected behavior. Please try again later.", "messageAr":"نواجه مشكله غير متوقعه. الرجاء المحاوله لاحقا"}], "IsSuccess":false}';
            }
        }
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(responseBody);
            res.setStatusCode(200);
            return res;
        }
    }
}