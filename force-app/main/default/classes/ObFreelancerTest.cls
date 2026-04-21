@isTest(SeeAllData=false)
public class ObFreelancerTest {
 @testSetup
    static void setup() {/*MS*/
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
        r.xadtx2__c = selectedActs; r.xdccaRq__c='RQ-112233';r.xaccbrand__c = 'Dubai Media City'; update r;

        List<g_srvcitm__c> srvitm = [select id from g_srvcitm__c where srvc__r.Name='Srvc' LIMIT 1];
        List<g_srvcitm_Status__c> stng = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc' LIMIT 1];
        g_reqitem__c rqitem = new g_reqitem__c(Name='License_Registration_Request', RQ__c=r.Id, itm__c=srvitm[0].Id, sta__c=stng[0].Id);
        insert rqitem;

        Courier_Status__c cStat = new Courier_Status__c(srvitm__c=srvitm[0].Id, curSTA__c=stng[0].Id, itmSTA__c=stng[0].Id, Courier_Status__c='Courier Initiated');
        insert cStat;

        g_reqDoc__c rdoc= new g_reqDoc__c(Name='Signed AOA', RQ__c=r.Id, ats__c=1);
        insert rdoc;
        g_reqitemDoc__c rrdocitm = new g_reqitemDoc__c(name='Application Form', lbl__c='Application Form', reqItm__c=rqitem.Id, reqDoc__c=rdoc.Id, mnAts__c=1, Req__c=true, reqAts__c=true);
        insert rrdocitm;
        Attachment att = new Attachment(name='Application Form', parentId=rdoc.Id, body= Blob.valueOf('TEST'));
        insert att;

        ws_call__c wc = new ws_call__c(pmid__c = accLst[0].Id, ws_typ__c = 'Onboarding', mtd_nm__c = 'fetchAccInfo', intsts__c = 'Ready for Integration');
        ws_call__c wc2 = new ws_call__c(pmid__c = accLst[0].Id, ws_typ__c = 'Onboarding', mtd_nm__c = 'uploadDoc', intsts__c = 'Ready for Integration', rq_itm__c=rqitem.Id);
        ws_call__c wc3 = new ws_call__c(pmid__c = accLst[0].Id, ws_typ__c = 'Onboarding', mtd_nm__c = 'getNewReqDetails', intsts__c = 'Ready for Integration', rq_itm__c=rqitem.Id);
        ws_call__c wc4 = new ws_call__c(pmid__c = accLst[0].Id, ws_typ__c = 'Onboarding', mtd_nm__c = 'updateStatus', intsts__c = 'Ready for Integration', rq_itm__c=rqitem.Id);
        ws_call__c wc5 = new ws_call__c(pmid__c = accLst[0].Id, ws_typ__c = 'Onboarding', mtd_nm__c = 'createRequest', intsts__c = 'Ready for Integration', rq_itm__c=rqitem.Id);

        List<ws_call__c> lstWs = new List<ws_call__c>();
        lstws.add(wc); lstws.add(wc2); lstws.add(wc3); lstws.add(wc4); lstws.add(wc5);
        insert lstws;

    }
    static testmethod void testUploadDoc() {
        Test.startTest();
         g_req__c r = [SELECT id, name, xadtx5__c, mtnm__c, isAMLCompleted__c, isMOAAmd__c,
             xvtyp__c, parcat__c, Acc__r.clt__c, sta__c, xfb__c, acc__c, xcslt__c, xcfn__c, xcln__c,
             xceml__c, xcmob__c, xaccbrand__c, xchph__c, xcnc__c, xcp__c, ccrmldid__c, os__c FROM g_req__c LIMIT 1];
        ObFreelancer ob = new ObFreelancer();
        ob.createAccount(r, 'test@test.com', 'Axs@1234578');
        Test.stopTest();
    }
}