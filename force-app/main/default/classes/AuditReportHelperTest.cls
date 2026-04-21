@isTest
public class AuditReportHelperTest {

    // Mock class to simulate HTTP response
    public class MockAFSHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);

            // Mock JSON body that matches the structure of your AFSRequests and openAFSRequests classes
            String mockJson = '{"openAFSRequests":[{"totalAmountToPay":"10020.00", "invoiceItems":[{"name":"Audited Financial Statement Submission Overdue", "fineOrFee":"Fine", "amount":10000}, {"name":"Knowledge Dirham", "fineOrFee":"Fine", "amount":10}, {"name":"Innovation Dirham", "fineOrFee":"Fine", "amount":10}], "financialYearStart":"2023-09-01", "financialYearEnd":"2024-08-31", "financialYear":2023, "ddaId":"1a1CFV000000mB612AE", "axsRefNo":null, "status":"Awaiting Submission", "attachments":[{"uploadedContentId":"069FV000001JdJdYAK", "isUploaded":true, "isMandatory":true, "fileName":"Engagement Letter from the Appointed Auditor", "ddaId":"a3eFV0000001VWPYA2"}], "subRequests":[{"type":"AFS Penalty", "status":"Approved", "requestSubmissionDate":null, "isRejected":false, "isApproved":true, "inProgress":false}]}], "license":93353}';

            res.setBody(mockJson);
            return res;
        }
    }

    @isTest
    static void testGetPreviousReqDetails() {
        // Register the mock class
        Test.setMock(HttpCalloutMock.class, new MockAFSHttpResponseGenerator());

        // Call the method with mock callout
        Test.startTest();
        List<openAFSRequests> result = AuditReportHelper.getPreviousReqDetails('93353');
        Test.stopTest();

        // Validate results
        System.assertNotEquals(null, result, 'Returned list should not be null');
        System.assertEquals(1, result.size(), 'There should be one request returned');

        openAFSRequests req = result[0];

        System.assertEquals('10020.00', req.totalAmountToPay);
        System.assertEquals(3, req.invoiceItems.size());
        System.assertEquals('2023-09-01', req.financialYearStart);
        System.assertEquals('Awaiting Submission', req.status);
        System.assertEquals(true, req.attachments[0].isUploaded);
        System.assertEquals('AFS Penalty', req.subRequests[0].type);
    }
}