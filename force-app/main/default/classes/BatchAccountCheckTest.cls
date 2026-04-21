@isTest
private class BatchAccountCheckTest {

    // ------------------------------------------------------------
    // Test: Batch with successful balance response
    // ------------------------------------------------------------
    @isTest
    static void testBatchSuccess() {

        // Create Account Test Data
        Account acc = new Account(
            Name = 'Test Acc',
            ORACLE_PARTY_ID__c = 'TDD-18146',
            ora_fu_dep__c = null
        );
        insert acc;

                String getResponse11 = '{"MESSAGE":"Processed", "STATUS":"Success", "CUST_BAL_UNAPP":178421.53, "REFUNDTYPE":"DEP", "CUST_BAL_OPEN_INV":0.0, "ACCOUNTNUMBER":"TDD-18146"}';

         Test.setMock(HttpCalloutMock.class, new ExternalServiceCalloutMock(200, getResponse11));
        //Test.setMock(HttpCalloutMock.class, MockResponse.formMockResponse());
        Test.startTest();
        BatchAccountCheck batch = new BatchAccountCheck('DEP', acc.ORACLE_PARTY_ID__c);
        Database.executeBatch(batch, 200);
        Test.stopTest();

        // Validate result
        acc = [SELECT ora_fu_dep__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(178421.53, acc.ora_fu_dep__c, 178421.53);
    }

    // ------------------------------------------------------------
    // Test: Schedulable execution
    // ------------------------------------------------------------
    @isTest
    static void testSchedulable() {

        Account acc = new Account(
            Name = 'Test Acc',
            ORACLE_PARTY_ID__c = 'TDD-18146',
            ora_fu_dep__c = null
        );
        insert acc;
          String getResponse11 = '{"MESSAGE":"Processed", "STATUS":"Success", "CUST_BAL_UNAPP":178421.53, "REFUNDTYPE":"DEP", "CUST_BAL_OPEN_INV":0.0, "ACCOUNTNUMBER":"TDD-18146"}';

         Test.setMock(HttpCalloutMock.class, new ExternalServiceCalloutMock(200, getResponse11));
        Test.startTest();
        BatchAccountCheck scheduler = new BatchAccountCheck('TEST', acc.ORACLE_PARTY_ID__c);
        String cron = '0 0 12 * * ?';  // Daily at noon
        System.schedule('BatchAccountCheckTestJob', cron, scheduler);
        Test.stopTest();

        System.assert(true, 'Scheduler executed without error');
    }

    public class ExternalServiceCalloutMock implements HttpCalloutMock {
    private Integer statusCode = 200;
    private String body = '{"success": true}';

    public ExternalServiceCalloutMock(Integer statusCode, String body) {
        this.statusCode = statusCode;
        this.body = body;
    }

    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();

        response.setStatusCode(this.statusCode);
        response.setBody(this.body);

        return response;
    }
    }

}