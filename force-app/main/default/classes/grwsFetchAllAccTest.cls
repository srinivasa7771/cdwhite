@isTest
public class grwsFetchAllAccTest {

    static testMethod void init() {
         testData.init();
        Account  a = new Account(Name='Testing', ORACLE_PARTY_ID__c='123', lc__c='456', lcsta__c='License Issued', lcidt__c=Date.today(), lcedt__c=Date.today().addyears(1));
        insert  a;
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
       g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);

        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;

        g_Req__c r=testData.reqCrt(a.Id, s.Id, sp.Id, 'Open', stg.reqq__c);
        String selectedActs = '[{"name":"Environment", "segId":"a08D000000Zb70DIAR", "allowed":"5", "price":"15000.00", "SegActivities":[{"name":"Research &amp; Development", "actId":"a12D0000001YygKIAS", "price":"15000.00", "docs":[]}]}, {"name":"Specialty Supplies", "segId":"a08D000000Zb6zZIAR", "allowed":"5", "price":"15000.00", "SegActivities":[{"name":"Research &amp; Development", "actId":"a12D0000001Yyd1IAC", "price":"15000.00", "docs":[]}]}]';
        r.xadtx2__c = selectedActs; r.xdccaRq__c='RQ-112233'; update r;
        s.uid__c = '220'; update s;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/getAllaccinfo/';

        String postData = '{"partyId":"123"}';

        req.requestBody = Blob.valueof(postData);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        grwsFetchAllAcc.getAccInfo();
        Test.stopTest();
    }
}