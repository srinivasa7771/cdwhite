@isTest(SeeAllData=false)
public class WsParkingCCRMTest {

    @testSetup
    static void setup() {

        testData.init();
        Account a=testData.accCrt(false);
        a.ORACLE_PARTY_ID__c = '10009999';
        update a;

        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();
        testData.bRulesItemCrt();

        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);

        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;

        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];

        Contact c = new Contact(Id=conLst[0].Id, mbs__c=500000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3)); update c;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];

        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);

        insert new gStg__c(Name='srvc_pRenewal', Checkbox_Value__c=true, Text_Value__c=s.id, Number_Value__c=1, Currency_Value__c=1);
    }

    static testmethod void testMethod1() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockGetResp());

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/parkingservices/';
        String postData = '{"methodName":"updateAmount", "axsReqId":"114212020211103", "noOfSlots":"2", "reqStatus":"", "totalAmount":null}';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        WsParkingCCRM.parkingservices();

        postData = '{"methodName":"", "axsReqId":"114212020211103", "noOfSlots":"2", "reqStatus":"", "totalAmount":null}';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        WsParkingCCRM.parkingservices();

        postData = '{"methodName":"updateAmount", "axsReqId":"", "noOfSlots":"2", "reqStatus":"", "totalAmount":null}';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        WsParkingCCRM.parkingservices();

        postData = '{"methodName":"parkingrenewal", "axsReqId":"114212020211103", "noOfSlots":"2", "reqStatus":"", "totalAmount":null}';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        WsParkingCCRM.parkingservices();

        postData = '{"methodName":"updatestatus", "axsReqId":"114212020211103", "noOfSlots":"2", "reqStatus":"Approved", "totalAmount":null}';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        WsParkingCCRM.parkingservices();

        Test.stopTest();
    }

    static testmethod void testMethod2() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockGetResp());

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/parkingservices/';

        String postData = '{"methodName":"parkingRenewal", "axsReqId":"114035320210530", "reqStatus":"", "agreement":{"totalAmount":"1200", "oraclePartyId":"10009999", "axid":132322, "totalslots":5, "totalAmt":"2000.00", "stDate":null, "sector":null, "orclId":"29258", "expDate":null, "agNo":"AG-060612", "parkingCards":[{"SectorName":"SectorName"}], "cardslist":[{"sfcid":"a4y5D000000CaSuQAK", "sector":"BusinessPark", "cnum":"TestCardT1", "chname":"TestCarHolder1", "cardexpDate":"2017-12-10"}, {"sfcid":"a4y5D000000CaSuQAK", "sector":"BusinessPark", "cnum":"TestCardT1", "chname":"TestCarHolder2", "cardexpDate":"2017-12-10"}]}}';
        //'{"methodName":"", "axsReqId":"", "noOfSlots":"2", "reqStatus":"", "totalAmount":null, "":"10009999"}';

        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;

        WsParkingCCRM.parkingservices();

        Test.stopTest();
    }

    static testmethod void testMethod3() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockGetResp());

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/parkingservices/';
        RestContext.request = req;
        RestContext.response= res;

        g_req__c rq = [SELECT id, name from g_req__c LIMIT 1];
        String postData = '{"methodName":"updatestatus", "axsReqId":"'+ rq.name +'", "noOfSlots":"2", "reqStatus":"Approved", "totalAmount":1200}';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        WsParkingCCRM.parkingservices();

        postData = '{"methodName":"updatestatus", "axsReqId":"'+ rq.name +'", "noOfSlots":"2", "reqStatus":"Refund Generated", "totalAmount":null}';
        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        WsParkingCCRM.parkingservices();

        Test.stopTest();
    }

    static testmethod void testMethod4() {

        List<g_reqitem__c> lstReqItms = [SELECT Id, xcpnc__c, scn__c, Rq__c, sta__c, itm__r.cd__c,
            Name, xr__c, xcdocs__c, xcnotes__c, Time_stamp__c, rq__r.srvc__c, rq__r.srvc__r.UID__c,
            rq__r.Name From g_reqitem__c limit 1];

        Test.startTest();

        try{
            WsParkingCCRM.updateSta(lstReqItms, 'Cancelled');
        }catch (Exception ex) {}

        Test.stopTest();
    }

    public class mockGetResp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String dummyResp = '';
            res.setBody(dummyResp);
            res.setStatusCode(200);

            return res;
        }
    }

}