@IsTest
public class UpdateRequestStatusAXSCCRMTest {

    @TestSetup
    static void setupData() {
        testData.init();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        s.uid__c ='196';
        s.Milestone_Stage__c ='';
        s.Milestone_SLA__c ='';
        update s;
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_reqMbr__c objM = new g_reqMbr__c();

        List<g_reqitem__c> items = [select id, itm__c from g_reqitem__c where RQ__c=:r.Id];
        List<g_srvcitm_Status__c> statusRec = [select id, itm__c from g_srvcitm_Status__c where cd__c='ok'];
        // Create Courier Status mapping
        List<Courier_Status__c> csList = new List<Courier_Status__c>();
        for (g_srvcitm_Status__c status : statusRec) {
            csList.add(new Courier_Status__c(
                srvitm__c = status.itm__c,
                Courier_Status__c = 'Active',
                itmSTA__c = status.id,
                curSTA__c =status.Id
            ));
        }
        insert csList;
    }

    // ---------------------------
    // Test: Happy Path
    // ---------------------------
    @IsTest
    static void testUpdateStatus_Success() {

        g_req__c req = [SELECT Id FROM g_req__c LIMIT 1];

        Map<String, Object> reqMap = new Map<String, Object>{
            'requestId' => req.Id,
            'status'    => 'Active'
        };

        RestRequest r = new RestRequest();
        r.requestUri = '/services/apexrest/UpdateRequestsStatusAXSCCRM/';
        r.httpMethod = 'POST';
        r.requestBody = Blob.valueOf(JSON.serialize(reqMap));

        RestContext.request = r;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpdateRequestStatusAXSCCRM.updateStatus();
        Test.stopTest();

        System.assertNotEquals(null, RestContext.response.responseBody);

        UpdateRequestStatusAXSCCRM.UpdateResponse resp =
            (UpdateRequestStatusAXSCCRM.UpdateResponse) JSON.deserialize(
                RestContext.response.responseBody.toString(),
                UpdateRequestStatusAXSCCRM.UpdateResponse.class
            );

        System.assertEquals('200', resp.respCode);
        System.assertEquals(req.Id, resp.requestId);
        System.assertEquals('Completed', resp.newStatus);
    }

    // ---------------------------
    // Test: Blank request body
    // ---------------------------
    @IsTest
    static void testUpdateStatus_BlankBody() {
        RestRequest r = new RestRequest();
        r.requestUri = '/services/apexrest/UpdateRequestsStatusAXSCCRM/';
        r.httpMethod = 'POST';
        r.requestBody = Blob.valueOf('');

        RestContext.request = r;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpdateRequestStatusAXSCCRM.updateStatus();
        Test.stopTest();

        UpdateRequestStatusAXSCCRM.UpdateResponse resp =
            (UpdateRequestStatusAXSCCRM.UpdateResponse) JSON.deserialize(
                RestContext.response.responseBody.toString(),
                UpdateRequestStatusAXSCCRM.UpdateResponse.class
            );

        System.assertEquals('VE_00', resp.respCode);
        System.assert(resp.respMsg.contains('cannot be empty'));
    }

    // ---------------------------
    // Test: Blank requestId
    // ---------------------------
    @IsTest
    static void testUpdateStatus_BlankRequestId() {
        g_req__c req = [SELECT Id FROM g_req__c LIMIT 1];
        Map<String, Object> reqMap = new Map<String, Object>{
            'requestId' => '',
            'status'    => 'Active'
        };

        RestRequest r = new RestRequest();
        r.requestUri = '/services/apexrest/UpdateRequestsStatusAXSCCRM/';
        r.httpMethod = 'POST';
        r.requestBody = Blob.valueOf(JSON.serialize(reqMap));

        RestContext.request = r;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpdateRequestStatusAXSCCRM.updateStatus();
        Test.stopTest();

        UpdateRequestStatusAXSCCRM.UpdateResponse resp =
            (UpdateRequestStatusAXSCCRM.UpdateResponse) JSON.deserialize(
                RestContext.response.responseBody.toString(),
                UpdateRequestStatusAXSCCRM.UpdateResponse.class
            );

        System.assertEquals('VE_01', resp.respCode);
    }

    // ---------------------------
    // Test: Blank status
    // ---------------------------
    @IsTest
    static void testUpdateStatus_BlankStatus() {
        g_req__c req = [SELECT Id FROM g_req__c LIMIT 1];

        Map<String, Object> reqMap = new Map<String, Object>{
            'requestId' => req.Id,
            'status'    => ''
        };

        RestRequest r = new RestRequest();
        r.requestUri = '/services/apexrest/UpdateRequestsStatusAXSCCRM/';
        r.httpMethod = 'POST';
        r.requestBody = Blob.valueOf(JSON.serialize(reqMap));

        RestContext.request = r;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpdateRequestStatusAXSCCRM.updateStatus();
        Test.stopTest();

        UpdateRequestStatusAXSCCRM.UpdateResponse resp =
            (UpdateRequestStatusAXSCCRM.UpdateResponse) JSON.deserialize(
                RestContext.response.responseBody.toString(),
                UpdateRequestStatusAXSCCRM.UpdateResponse.class
            );

        System.assertEquals('VE_02', resp.respCode);
    }
}