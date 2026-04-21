@isTest
public class courierIntgTest {

    /* failure Cases */
    @isTest static void testCreateReq() {

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        String str         = '{"accName":"Test Account", "oracleID":"29258", "docType":"Lease Document Delivery"}';
        req.requestURI     = '/services/apexrest/courierservices/';
        req.httpMethod     = 'POST';
        req.requestBody = Blob.valueof(str);
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        //Account not found
        courierIntg.createReq();

        //oracleID Blank
        str    = '{"accName":"Test Account", "oracleID":""}';
        req.requestBody = Blob.valueof(str);
        courierIntg.createReq();

        //Invalid JSON
        str    = '{"accName":"Test Account", "oracleID"';
        req.requestBody = Blob.valueof(str);
        courierIntg.createReq();
        Test.stopTest();

    }

    /* Success Case */
    @isTest static void testCreateReq2() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI     = '/services/apexrest/courierservices/';
        req.httpMethod     = 'POST';
        RestContext.request = req;
          RestContext.response = res;

        testData.init();
        Account acc = new Account(Name='Test Account_LDD', ORACLE_PARTY_ID__c = '29258');insert acc;
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s = new g_Srvc__c(Name='Srvc', lbl__c='Srvc', stg__c=stg.Id, uid__c='ldd',
            actv__c=true, ckgsnc__c=true, Prk__c='Dubai Internet City', AccTp__c='Customer - External',
            ConRol__c='Employee', ConSTA__c='Active', payMd__c='Customer Deposit; Cash; Credit / Debit Card',
            Category__c='Employees Services', Sub_Category__c='Renewal Visa', Milestone_Stage__c='Ep;Medical;Rp;',
            Milestone_SLA__c='10;2;6');
        insert s;

        Test.startTest();
        String str = '{"accName":"Test Account", "oracleID":"29258", "conName":"Test Contact", "agNum":"AG-123321", "docType":"Lease Document Delivery", "refMobile":"0500001111", "deliveryZone":"D3", "buildName":"Building 01", "deliveryLoc":"DIAC", "Notes":"Test Notes"}';
        req.requestBody = Blob.valueof(str);
        courierIntg.createReq();

        gStg__c ldd = new gStg__c(name='LDD_SrvcID', Text_Value__c = s.Id); insert ldd;
        courierIntg.createReq();

        Test.stopTest();
    }

    @isTest static void testCourBooking() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI     = '/services/apexrest/createbooking/';
        req.httpMethod     = 'POST';
        RestContext.request = req;
          RestContext.response = res;

        testData.init();
        Account acc = new Account(Name='Test Account_LDD', ORACLE_PARTY_ID__c = '29258');insert acc;
        g_srvc_settings__c stg=testData.stgCrt(); stg.apx__c = 'grqI.ldd'; update stg;
        g_Srvc__c s = new g_Srvc__c(Name='Srvc', lbl__c='Srvc', stg__c=stg.Id, uid__c='ldd',
            actv__c=true, ckgsnc__c=true, Prk__c='Dubai Internet City', AccTp__c='Customer - External',
            ConRol__c='Employee', ConSTA__c='Active', payMd__c='Customer Deposit; Cash; Credit / Debit Card',
            Category__c='Employees Services', Sub_Category__c='Renewal Visa', Milestone_Stage__c='Ep;Medical;Rp;',
            Milestone_SLA__c='10;2;6');
        insert s;

        Contact sp = testData.conCrt(null, acc.Id, 'Active', 'Student', 'test1', 'India');
        g_Req__c r=testData.reqCrt(acc.Id, s.Id, sp.Id, 'Open', stg.reqq__c);

        Test.startTest();
        String str = '{"accName":"Test Account", "oracleID":"29258", "conName":"Test Contact", "agNum":"AG-123321", "docType":"Lease Document Delivery", "refMobile":"0500001111", "deliveryZone":"D3", "buildName":"Building 01", "deliveryLoc":"DIAC", "Notes":"Test Notes"}';
        req.requestBody = Blob.valueof(str);
        CourierBookingIntg.createCourBooking();

        gStg__c ldd = new gStg__c(name='LDD_SrvcID', Text_Value__c=s.Id); insert ldd;

        g_req__c rq     = [SELECT id, Name from g_req__c where id=:r.Id LIMIT 1];
        str = '{"SRN":"'+rq.name+'"}';
        req.requestBody = Blob.valueof(str);
        CourierBookingIntg.createCourBooking();
        Test.stopTest();
    }
}