@istest
private class SMSServiceTest {
  @testSetup
    static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
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
        String selectedActs = '[{"name":"Environment", "segId":"a08D000000Zb70DIAR", "allowed":"5", "price":"15000.00", "SegActivities":[{"name":"Research &amp; Development", "actId":"a12D0000001YygKIAS", "price":"15000.00", "docs":[]}]}, {"name":"Specialty Supplies", "segId":"a08D000000Zb6zZIAR", "allowed":"5", "price":"15000.00", "SegActivities":[{"name":"Research &amp; Development", "actId":"a12D0000001Yyd1IAC", "price":"15000.00", "docs":[]}]}]';
        r.xadtx2__c = selectedActs; r.xdccaRq__c='RQ-112233'; update r;

        List<g_srvcitm__c> srvitm = [select id, cd__c from g_srvcitm__c where srvc__r.Name='Srvc' LIMIT 1];
        srvitm[0].cd__c = 'frl';
        update srvitm;
        List<g_srvcitm_Status__c> stng = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc' LIMIT 1];
        g_reqitem__c rqitem = new g_reqitem__c(Name='License_Registration_Request', RQ__c=r.Id, itm__c=srvitm[0].Id, sta__c=stng[0].Id);
        insert rqitem;

    }

  static testmethod void test1() {

        RestRequest req = new RestRequest();

        RestResponse res = new RestResponse();
        req.requestURI = '/smsservices/'; //Request URL
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();

            Test.setMock(HttpCalloutMock.class, new MockSMSService());
            SMSService obj = new SMSService();
            try{
                SMSService.postData();
            }Catch(Exception e) {
                system.debug('Exception:::::::::::::');
            }
    g_req__c rq =   [select id from g_req__c limit 1];
        String rid=    SMSService.sendOTP('00971554480164', rq.id);

        Test.stopTest();
    }
  static testmethod void test2() {

        RestRequest req = new RestRequest();

        RestResponse res = new RestResponse();
        req.requestURI = '/smsservices/'; //Request URL
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();

            Test.setMock(HttpCalloutMock.class, new MockSMSService());

    SMSService.otpValidate('tst', '123456');

        Test.stopTest();
    }
    public class MockSMSService implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            if (req.getEndpoint().contains('destination'))
               res.setBody('{"reqNumber":"101711220210303", "mobileNumber":"+971554480164", "status":"Sent", "message":"tst"}');
            else
              res.setBody('{"reqNumber":"101711220210303", "mobileNumber":"+971554480164", "status":"Sent", "destination":"+971554480164"}');
            res.setStatusCode(200);
            return res;
        }
    }
}