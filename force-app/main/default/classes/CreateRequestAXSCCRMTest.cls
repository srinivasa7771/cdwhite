@IsTest
public class CreateRequestAXSCCRMTest {

    @testSetup
    static void setupData() {
        Account acc = new Account(
            Name = 'Test AXS Account',
            Manager_Email__c = 'manager@test.com',
            Manager_Mobile__c = '9999999999'
        );
        insert acc;
        g_srvc_settings__c stg=testData.stgCrt();
        testData.init();
        g_Srvc__c s = new g_Srvc__c(
            Name = 'Srvc',
            lbl__c = 'Srvc',
            stg__c = stg.Id,
            uid__c = '196',
            actv__c = true,
            ckgsnc__c = true,
            Prk__c = 'Dubai Internet City',
            AccTp__c = 'Customer - External',
            ConRol__c = 'Employee',
            ConSTA__c = 'Active',
            payMd__c = 'Advance Deposit; Cash; Credit / Debit Card',
            Category__c = 'Employees Services',
            Sub_Category__c = 'Renewal Visa',
            Milestone_Stage__c = 'Ep;Medical;Rp;',
            Milestone_SLA__c = '10;2;6'
        );
        insert s;

        list<gStg__c> stgs=new list<gStg__c>();
        stgs.add(new gStg__c(Name='srvc_leaserenewal', Checkbox_Value__c=true, Text_Value__c=s.id, Number_Value__c=0, Currency_Value__c=0));
        insert stgs;
    }

    private static void prepareRestContext(String requestBody) {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestUri = '/services/apexrest/CreateRequestsAXSCCRM/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(requestBody);

        RestContext.request = req;
        RestContext.response = res;
    }

    @IsTest
    static void testCreateLeaseRenewalRequest_Success() {

        Account acc = [SELECT Id FROM Account LIMIT 1];

        Map<String, Object> innerReq = new Map<String, Object>{
            'OppdId'         => '006TESTOPP',
            'email'          => 'user@test.com',
            'axsAccId'       => acc.Id,
            'oraclePartyId'  => 'ORCL123',
            'hseStatus'      => 'Applicable',
            'ccrmAccId'      => 'CCRM001',
            'tcode'          => 'TC01',
            'leaseStartDate' => String.valueOf(Date.today())
        };

        Map<String, Object> outerReq = new Map<String, Object>{
            'methodName' => 'createLeaseRenewalRequest',
            'reqJson'    => JSON.serialize(innerReq)
        };

        prepareRestContext(JSON.serialize(outerReq));

        Test.startTest();
        CreateRequestAXSCCRM.createRequest();
        Test.stopTest();

        // Validate response
        String responseBody = RestContext.response.responseBody.toString();
        CreateRequestAXSCCRM.RequestResponse resp =
            (CreateRequestAXSCCRM.RequestResponse)
            JSON.deserialize(responseBody, CreateRequestAXSCCRM.RequestResponse.class);

        System.assertEquals('0', resp.respCode);
        System.assertNotEquals(null, resp.requestId);

        // Validate g_req__c created
        List<g_req__c> reqList = [
            SELECT Id, Acc__c
            FROM g_req__c
            WHERE Acc__c = :acc.Id
        ];
        System.assertEquals(1, reqList.size());

        // Validate ws_call__c created
        List<ws_call__c> wsList = [
            SELECT Id, ws_typ__c
            FROM ws_call__c
            WHERE ws_typ__c = 'axsLeaseRenewal'
        ];
        System.assertEquals(1, wsList.size());
    }

    @IsTest
    static void testCreateRequest_MethodNameBlank() {

        Map<String, Object> outerReq = new Map<String, Object>{
            'methodName' => '',
            'reqJson'    => '{}'
        };

        prepareRestContext(JSON.serialize(outerReq));

        Test.startTest();
        CreateRequestAXSCCRM.createRequest();
        Test.stopTest();

        String responseBody = RestContext.response.responseBody.toString();
        CreateRequestAXSCCRM.RequestResponse resp =
            (CreateRequestAXSCCRM.RequestResponse)
            JSON.deserialize(responseBody, CreateRequestAXSCCRM.RequestResponse.class);

        System.assertEquals('VE_01', resp.respCode);
        System.assert(resp.respMsg.contains('methodName cannot be blank'));
    }

    @IsTest
    static void testCreateLeaseRenewalRequest_MissingFields() {

        Account acc = [SELECT Id FROM Account LIMIT 1];

        Map<String, Object> innerReq = new Map<String, Object>{
            'axsAccId' => acc.Id
            // Missing required fields intentionally
        };

        CreateRequestAXSCCRM.RequestResponse resp =
            CreateRequestAXSCCRM.createLeaseRenewalRequest(
                JSON.serialize(innerReq)
            );

        System.assertEquals('VE_01', resp.respCode);
        System.assert(resp.respMsg.contains('required parameters'));
    }

    @IsTest
    static void testCreateRequest_InvalidJson() {

        prepareRestContext('Invalid JSON');

        Test.startTest();
        CreateRequestAXSCCRM.createRequest();
        Test.stopTest();

        if (RestContext.response.responseBody != null) {
            String responseBody = RestContext.response.responseBody.toString();
            CreateRequestAXSCCRM.RequestResponse resp =
                (CreateRequestAXSCCRM.RequestResponse)
                JSON.deserialize(responseBody, CreateRequestAXSCCRM.RequestResponse.class);

            System.assertEquals('EXC_02', resp.respCode);
        }
    }
}