@isTest
private class PSADocControllerTest {

    // //Added By CB

    @isTest
    static void testUpdatePSASignFields() {
        User runningUser = testData.createportalUser('manager');
        System.runAs(runningUser) {
            PSADocController obj = new PSADocController();

            Test.startTest();
            obj.updatePSASignFields();
            Test.stopTest();
        }
    }

    //End CB

    static testmethod void testAccountSnapshotBatch() {

        Test.setMock(HttpCalloutMock.class, new MockAccountInfo());
        Account a=testData.accCrt(false);
        a.lc__c = '1234';
        update a;
        Test.startTest();
        apexpages.currentpage().getparameters().put('id', a.id);
        PSADocController obj = new PSADocController();
        obj.AccountDetails();

        Test.stopTest();
    }
    public class MockAccountInfo implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"salutation":"Mr.", "passportNo":"TERT345", "nationality":"Test", "mobile":"+971522222222", "lastName":"Sudhakar", "firstName":"Siddharth", "email":"test@test.com", "accLicNo":"11111"}]');
            res.setStatusCode(200);
            return res;
        }
    }

}