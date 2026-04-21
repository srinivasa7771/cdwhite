@IsTest
public class LeaseRenewalFetchAccInfoTest {

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
        r.InsChk__c = true;
        r.ccrmldid__c = r.Id;
        r.xcp__c = 'PROP1';
        update r;

    }

    @IsTest
    static void testFetchAccInfo_Success() {

        g_Req__c req = [
            SELECT Id, ccrmldid__c
            FROM g_Req__c
            LIMIT 1
        ];

        Id fakeQuoteId = '0Q0000000000000';

        Id renewalOppId = req.ccrmldid__c;

        String paymentScheduleJson =
        '{' +
            '"quote":"' + fakeQuoteId + '", ' +
            '"term":"1", ' +
            '"description":"Lease Fee Term-1", ' +
            '"chargeCode":"RENT", ' +
            '"propertyCode":"PROP1", ' +
            '"tenantCode":"TEN1", ' +
            '"billedAmount":1000, ' +
            '"vatAmount":50, ' +
            '"totalAmountIncludingVat":1050, ' +
            '"dueDate":"' + String.valueOf(Date.today()) + '", ' +
            '"chargeFrom":"' + String.valueOf(Date.today().addDays(-10)) + '", ' +
            '"chargeTo":"' + String.valueOf(Date.today().addDays(20)) + '"' +
        '}';

        String jsonResponse =
        '{' +
        '"skipLeaseValidations":"true", ' +
        '"quotes":[' +
            '{' +
            '"status":"Approved", ' +
            '"opportunityId":"' + renewalOppId + '", ' +
            '"quoteId":"' + fakeQuoteId + '", ' +
            '"totalLandQtAmt":100000, ' +
            '"units":[' +
                '{' +
                '"unitCategory":"Residential", ' +
                '"unitsubCategory":"Apartment"' +
                '}' +
            ']' +
            '}' +
        '], ' +
        '"paymentSchedules":[' + paymentScheduleJson + ']' +
        '}';

        ws_call__c ws = new ws_call__c(
            rq_jsn__c = jsonResponse,
            ws_typ__c = 'LeaseRenewal',
            intsts__c = 'Ready for Integration'
        );
        insert ws;

        Test.startTest();
            LeaseRenewalFetchAccInfo.fetchAccInfo(
                ws,
                req.Id,
                req.Id
            );
        Test.stopTest();

        // Assertions
        ws_call__c wsUpdated = [
            SELECT intsts__c, err_msg__c, res_jsn__c
            FROM ws_call__c
            WHERE Id = :ws.Id
        ];

        System.assertNotEquals(null, wsUpdated.res_jsn__c, 'Response JSON should be saved');
        System.assertNotEquals('Failed', wsUpdated.intsts__c, 'WS should not fail');

        g_Req__c reqUpdated = [
            SELECT xadtx1__c, xadtx3__c, xtpa__c, parCat__c, xcamc__c
            FROM g_Req__c
            WHERE Id = :req.Id
        ];

        System.assertNotEquals(null, reqUpdated.xadtx1__c, 'Processed payment JSON should be saved');
        System.assertEquals('Residential', reqUpdated.parCat__c);
        System.assertEquals('Apartment', reqUpdated.xcamc__c);
        System.assert(reqUpdated.xtpa__c > 0, 'Total payable amount should be populated');
    }

    @IsTest
    static void testFetchAccInfo_BlankJson() {

        g_Req__c req = [
            SELECT Id
            FROM g_Req__c
            LIMIT 1
        ];

        ws_call__c ws = new ws_call__c(
            rq_jsn__c = '',
            ws_typ__c = 'LeaseRenewal',
            intsts__c = 'Ready for Integration'
        );
        insert ws;

        Test.startTest();
            LeaseRenewalFetchAccInfo.fetchAccInfo(
                ws,
                req.Id,
                req.Id
            );
        Test.stopTest();

        ws_call__c wsUpdated = [
            SELECT intsts__c, err_msg__c
            FROM ws_call__c
            WHERE Id = :ws.Id
        ];

        System.assertEquals('Failed', wsUpdated.intsts__c);
        System.assert(wsUpdated.err_msg__c.contains('blank'));
    }
}