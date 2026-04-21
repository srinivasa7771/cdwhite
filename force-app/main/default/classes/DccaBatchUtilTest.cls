/*U_S DFZC made the changes in the class*/
@isTest(SeeAllData = false)
public class DccaBatchUtilTest {

    @testSetup
    static void setup() {
        testData.init();
        Account a = testData.accCrt(false);
        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();
        testData.bRulesItemCrt();
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);

        g_srvc_definition__c sd = new g_srvc_definition__c(Name = 'test', ptype__c = 'Normal:10 Days;Express:3 Days;', cv__c = 'NewVisa', sd__c = 'Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>', docslbl__c = 'Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List < Contact > conLst = [select id from Contact where firstName = 'fName'
            LIMIT 1
        ];
        List < Account > accLst = [select id from Account where Name = 'Acc'
            LIMIT 1
        ];
        List < g_Srvc__c > srvcLst = [select id from g_Srvc__c where Name = 'Srvc'
            LIMIT 1
        ];
        Contact c = new Contact(Id = conLst[0].Id, mbs__c = 5000, eidid__c = '784198774283257', eidedt__c = system.today().addyears(3));
        update c;
        List < g_srvc_settings__c > srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name = 'srvcStg'
            LIMIT 1
        ];

        Contact emp = testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r = testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        String selectedActs = '[{"name":"Environment","segId":"a08D000000Zb70DIAR","allowed":"5","price":"15000.00","SegActivities":[{"name":"Research &amp; Development","actId":"a12D0000001YygKIAS","price":"15000.00","docs":[]}]},{"name":"Specialty Supplies","segId":"a08D000000Zb6zZIAR","allowed":"5","price":"15000.00","SegActivities":[{"name":"Research &amp; Development","actId":"a12D0000001Yyd1IAC","price":"15000.00","docs":[]}]}]';
        r.xadtx2__c = selectedActs;
        r.xdccaRq__c = 'RQ-112233';
        update r;

        List < g_srvcitm__c > srvitm = [select id, cd__c from g_srvcitm__c where srvc__r.Name = 'Srvc'
            LIMIT 1
        ];
        srvitm[0].cd__c = 'kf';
        List < g_srvcitm_Status__c > stng = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name = 'Srvc'
            LIMIT 1
        ];
        g_reqitem__c rqitem = new g_reqitem__c(Name = 'License_Registration_Request', RQ__c = r.Id, itm__c = srvitm[0].Id, sta__c = stng[0].Id);
        insert rqitem;

        List < g_srvcitm__c > srvitm1 = [select id, cd__c from g_srvcitm__c where srvc__r.Name = 'Srvc'
            AND cd__c != 'kf'
            LIMIT 1
        ];
        srvitm1[0].cd__c = 'ddd';
        update srvitm1;

        g_reqitem__c rqitem1 = new g_reqitem__c(Name = 'License_Registration_Request', RQ__c = r.Id, itm__c = srvitm1[0].Id, sta__c = stng[0].Id);
        insert rqitem1;

        Courier_Status__c cStat = new Courier_Status__c(srvitm__c = srvitm[0].Id, curSTA__c = stng[0].Id, itmSTA__c = stng[0].Id, Courier_Status__c = 'Courier Initiated');
        insert cStat;

        g_reqDoc__c rdoc = new g_reqDoc__c(Name = 'Valid Passport Copy', RQ__c = r.Id, ats__c = 1);
        insert rdoc;
        g_reqitemDoc__c rrdocitm = new g_reqitemDoc__c(name = 'Valid Passport Copy', lbl__c = 'Valid Passport Copy', reqItm__c = rqitem.Id, reqDoc__c = rdoc.Id, mnAts__c = 1, Req__c = true, reqAts__c = true);
        insert rrdocitm;
        Attachment att = new Attachment(name = 'Valid Passport Copy', parentId = rdoc.Id, body = Blob.valueOf('TEST'));
        insert att;
        rdoc.dda_att__c = att.id;
        update rdoc;
        g_Tran__c T = new g_Tran__c(Acc__c = accLst[0].Id, RQ__c = r.Id, dt__c = system.today(), TP__c = 'Payment', STA__c = 'Completed', md__c = 'Credit / Debit Card');
        insert T;
        List < g_TranItem__c > TIs = new List < g_TranItem__c > ();
        TIs.add(new g_TranItem__c(itm__c = rqitem.Id, T__c = T.Id, iRef__c = '20102666341', A__c = 552.50, Tp__c = 'Payment', STA__c = 'Completed'));
        insert TIs;

        ws_call__c wc1 = new ws_call__c(pmid__c = att.id, adhoc_text1__c = 'Passport', ws_typ__c = 'Onboarding', mtd_nm__c = 'exchCRMDocBatch', intsts__c = 'Ready for Integration', rq_itm__c = rqitem.Id);

        T = [Select id, name from g_Tran__c limit 1];
        ws_call__c wc2 = new ws_call__c(rq_jsn__c = T.name, ws_typ__c = 'Onboarding', mtd_nm__c = 'processInvDDABatch', intsts__c = 'Ready for Integration', rq_itm__c = rqitem.Id);
        ws_call__c wc3 = new ws_call__c(rq_jsn__c = T.name, ws_typ__c = 'Onboarding', mtd_nm__c = 'exchCRMStsBatch', intsts__c = 'Ready for Integration', rq_itm__c = rqitem.Id);

        ws_call__c wc4 = new ws_call__c(rq_jsn__c = 'Import Success: Legal Name C-C c' + T.name, ws_typ__c = 'Onboarding', mtd_nm__c = 'exchCRMStsBatch', intsts__c = 'Ready for Integration', rq_itm__c = rqitem.Id);
        ws_call__c wc5 = new ws_call__c(rq_jsn__c = T.name, ws_typ__c = 'Courier Booking', mtd_nm__c = 'Courier Booking', intsts__c = 'Ready for Integration', rq_itm__c = rqitem.Id);
        ws_call__c wc6 = new ws_call__c(rq_jsn__c = T.name, ws_typ__c = 'Courier Service', mtd_nm__c = 'updateCourSta', intsts__c = 'Ready for Integration', rq_itm__c = rqitem.Id);
        ws_call__c wc7 = new ws_call__c(rq_jsn__c = T.name, ws_typ__c = 'Onboarding', mtd_nm__c = 'updateCRMStatus', intsts__c = 'Ready for Integration', rq_itm__c = rqitem.Id);

        ws_call__c wc8 = new ws_call__c(pmid__c = att.id, adhoc_text1__c = 'Passport', ws_typ__c = 'Onboarding', mtd_nm__c = 'LADocs', intsts__c = 'Ready for Integration', rq_itm__c = rqitem.Id);
        ws_call__c wc9 = new ws_call__c(pmid__c = att.id, adhoc_text1__c = 'Passport', ws_typ__c = 'DCCA Letters', mtd_nm__c = 'membersDocs', intsts__c = 'Ready for Integration', rq_itm__c = rqitem.Id, rq_jsn__c = '{"AttachmentList":[{"parentId":"a1CFV0000011siS2AQ","Name":"Valid Passport Copy","messagecode":null,"message":null,"attachmentBody":null}]}');
        ws_call__c wc10 = new ws_call__c(pmid__c = att.id, adhoc_text1__c = 'Passport', ws_typ__c = 'DCCA Letters', mtd_nm__c = 'InvoiceCreation', intsts__c = 'Ready for Integration', rq_itm__c = rqitem.Id, rq_jsn__c = '{"AttachmentList":[{"parentId":"a1CFV0000011siS2AQ","Name":"Valid Passport Copy","messagecode":null,"message":null,"attachmentBody":null}]}');

        List < ws_call__c > lstWs = new List < ws_call__c > ();
        lstws.add(wc1);
        lstws.add(wc2);
        lstws.add(wc3);
        lstws.add(wc5);
        lstws.add(wc6);
        lstws.add(wc7);
        lstws.add(wc8);
        lstws.add(wc9);
        lstws.add(wc10); //lstws.add(wc3); lstws.add(wc4); lstws.add(wc5);
        insert lstws;

        ws_call__c ws = new ws_call__c();
        ws.intsts__c = 'Ready for Integration';
        ws.mtd_nm__c = 'ddaupload';
        ws.pmid__c = '';
        ws.rq_itm__c = rqitem.Id;
        ws.rq_jsn__c = rqitem.Id;
        ws.ws_typ__c = 'Onboarding';
        insert ws;


    }

    static testmethod void test_exchCRMDocBatch() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new mockGetResp());
        List < id > wIdLst = new List < id > ();
        List < ws_call__c > lstWs = [Select id from ws_call__c WHERE mtd_nm__c = 'exchCRMDocBatch'];
        wIdLst.add(lstWs[0].id);
        DccaBatchUtil.exchCRMDocBatch(wIdLst);

        Test.stopTest();
    }


    static testmethod void test_processInvDDABatch() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new mockProcessInvDDABatch());
        List < id > wIdLst = new List < id > ();
        List < ws_call__c > lstWs = [Select id from ws_call__c WHERE mtd_nm__c = 'processInvDDABatch'];
        wIdLst.add(lstWs[0].id);
        DccaBatchUtil.exchInvDDABatch(wIdLst);

        Test.stopTest();
    }

    static testmethod void test_processcbkBatch() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new mockProcesscbkBatch());
        List < id > wIdLst = new List < id > ();
        List < ws_call__c > lstWs = [Select id from ws_call__c WHERE mtd_nm__c = 'Courier Booking'];
        wIdLst.add(lstWs[0].id);
        DccaBatchUtil.exchcbkBatch(wIdLst);

        Test.stopTest();
    }
    static testmethod void test_processcbkStsBatch() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new mockProcesscbkBatch());
        g_Srvc__c srvc = [select id, uid__c from g_Srvc__c limit 1];
        srvc.uid__c = '197';
        update srvc;
        List < id > wIdLst = new List < id > ();
        List < ws_call__c > lstWs = [SELECT Id, err_cd__c, rq_jsn__c, pmid__c, xwsc__c, intsts__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.LastModifiedDate, rq_itm__r.RQ__r.Id, rq_itm__r.Sta__c, rq_itm__r.RQ__r.Name, rq_itm__r.sta__r.Name, rq_itm__r.sta__r.rqSTA__c, rq_itm__r.RQ__r.xawb__c, rq_itm__r.RQ__r.xanum__c, rq_itm__r.RQ__r.Zone__c, rq_itm__r.RQ__r.xchn__c, rq_itm__r.RQ__r.rmob__c, rq_itm__r.RQ__r.xaloc__c, rq_itm__r.RQ__r.Full_Name__c, rq_itm__r.RQ__r.Acc__r.Name, rq_itm__r.RQ__r.xbn__c, rq_itm__r.RQ__r.nt__c, rq_itm__r.RQ__r.prntcnt__c, rq_itm__r.RQ__r.xccn__c, rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c, rq_itm__r.RQ__r.xbrnd__c, rq_itm__r.id, rq_itm__r.name, rq_itm__r.sta__r.cd__c, rq_itm__r.sta__r.Courier_Stage__c, rq_itm__r.xcub__c, rq_itm__r.xcasc__c, rq_itm__r.exp__c, rq_itm__r.RQ__r.srvc__r.uid__c from ws_call__c WHERE mtd_nm__c = 'updateCourSta'];
        wIdLst.add(lstWs[0].id);
        DccaBatchUtil.exchcbStsBatch(wIdLst);
        DccaBatchUtil.updateCRMCourierStatus(lstWs[0], '3253255');
        Test.stopTest();
    }

    static testmethod void test_exchCRMStsBatch() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new mockExchCRMStsBatch());
        List < id > wIdLst = new List < id > ();
        List < ws_call__c > lstWs = [Select id from ws_call__c WHERE mtd_nm__c = 'exchCRMStsBatch'];
        wIdLst.add(lstWs[0].id);
        DccaBatchUtil.exchCRMStsBatch(wIdLst);

        Test.stopTest();
    }
    static testmethod void test_exchCRMWOBatch() {
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new mockExchCRMStsBatch());
        List < id > wIdLst = new List < id > ();
        List < ws_call__c > lstWs = [Select id from ws_call__c WHERE mtd_nm__c = 'updateCRMStatus'];
        wIdLst.add(lstWs[0].id);
        DccaBatchUtil.exchCRMWOBatch(wIdLst);

        Test.stopTest();
    }

    /*static testmethod void test_exchInvYardiBatch(){
Test.startTest();

Test.setMock(WebServiceMock.class, new mockProcessInvYardiFineBatch());
List<id> wIdLst = new List<id>();
List<ws_call__c> lstWs = [Select id from ws_call__c WHERE mtd_nm__c='exchCRMStsBatch'];
wIdLst.add(lstWs[0].id);
DccaBatchUtil.exchInvYardiBatch(wIdLst); 

Test.stopTest();
}   */


    static testmethod void test_CommonCases() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockProcessInvDDABatch());
        List < ws_call__c > lstWsRec = [SELECT Id, err_cd__c, rq_jsn__c, adhoc_text1__c, pmid__c, xwsc__c, intsts__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.LastModifiedDate, rq_itm__r.RQ__r.Id, rq_itm__r.Sta__c, rq_itm__r.RQ__r.Name, rq_itm__r.sta__r.Name, rq_itm__r.sta__r.rqSTA__c, rq_itm__r.RQ__r.xawb__c, rq_itm__r.RQ__r.xanum__c, rq_itm__r.RQ__r.Zone__c, rq_itm__r.RQ__r.xchn__c, rq_itm__r.RQ__r.rmob__c, rq_itm__r.RQ__r.xaloc__c, rq_itm__r.RQ__r.Full_Name__c, rq_itm__r.RQ__r.Acc__r.Name, rq_itm__r.RQ__r.xbn__c, rq_itm__r.RQ__r.nt__c, rq_itm__r.RQ__r.prntcnt__c, rq_itm__r.RQ__r.xccn__c, rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c, rq_itm__r.RQ__r.xbrnd__c, rq_itm__r.id, rq_itm__r.name, rq_itm__r.sta__r.cd__c, rq_itm__r.sta__r.Courier_Stage__c, rq_itm__r.xcub__c, rq_itm__r.xcasc__c, rq_itm__r.exp__c, rq_itm__r.RQ__r.srvc__r.uid__c from ws_call__c where mtd_nm__c = 'InvoiceCreation'];

        DccaBatchUtil.exchInvBatch(new List < Id > {
            lstWsRec[0].Id
        });
        //DccaBatchUtil.exchStsBatch(new List<String>());
        //DccaBatchUtil.exchAccInfoBatch(new List<String>());

        Test.stopTest();
    }

    static testMethod void testMethods() {

        List < ws_call__c > lstWs = [SELECT Id FROM ws_call__c LIMIT 1];

        //DccaBatchUtil.exchStsBatch(new List<Id> { lstWs[0].Id });
        DccaBatchUtil.exchPMSUpdateCCRMBatch(new List < Id > {
            lstWs[0].Id
        });
        DccaBatchUtil.exchCRMStsBatch(new List < Id > {
            lstWs[0].Id
        });

        //DccaBatchUtil.exchAddRemoveSancBatch(new List<Id> { lstWs[0].Id });
        DccaBatchUtil.exchdccaLtAprovalBatch(new List < Id > {
            lstWs[0].Id
        });
        DccaBatchUtil.exchInvYardiBatch(new List < Id > {
            lstWs[0].Id
        });
        //DccaBatchUtil.processStsBatch(new List<ws_call__c> { lstWs[0] });
        DccaBatchUtil.excLADDABatch(new List < Id > {
            lstWs[0].Id
        });
        //DccaBatchUtil.exchCRMUpsertContacts(new List<Id> { lstWs[0].Id });
        //DccaBatchUtil.updateAXSStatusLA(new List<Id> { lstWs[0].Id });

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockProcessInvDDABatch());
        List < ws_call__c > lstWsRec = [SELECT Id, err_cd__c, rq_jsn__c, pmid__c, xwsc__c, intsts__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.LastModifiedDate, rq_itm__r.RQ__r.Id, rq_itm__r.Sta__c, rq_itm__r.RQ__r.Name, rq_itm__r.sta__r.Name, rq_itm__r.sta__r.rqSTA__c, rq_itm__r.RQ__r.xawb__c, rq_itm__r.RQ__r.xanum__c, rq_itm__r.RQ__r.Zone__c, rq_itm__r.RQ__r.xchn__c, rq_itm__r.RQ__r.rmob__c, rq_itm__r.RQ__r.xaloc__c, rq_itm__r.RQ__r.Full_Name__c, rq_itm__r.RQ__r.Acc__r.Name, rq_itm__r.RQ__r.xbn__c, rq_itm__r.RQ__r.nt__c, rq_itm__r.RQ__r.prntcnt__c, rq_itm__r.RQ__r.xccn__c, rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c, rq_itm__r.RQ__r.xbrnd__c, rq_itm__r.id, rq_itm__r.name, rq_itm__r.sta__r.cd__c, rq_itm__r.sta__r.Courier_Stage__c, rq_itm__r.xcub__c, rq_itm__r.xcasc__c, rq_itm__r.exp__c, rq_itm__r.RQ__r.srvc__r.uid__c from ws_call__c WHERE mtd_nm__c = 'membersDocs'];
        DccaBatchUtil.exchDocBatch(new List < Id > {
            lstWsRec[0].Id
        });
        Test.stopTest();
    }


    static testMethod void testDoccaBatch() { // PJ

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockProcessInvDDABatch());
        List < ws_call__c > lstWs = [SELECT Id, err_cd__c, rq_jsn__c, adhoc_text1__c, pmid__c, xwsc__c, intsts__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.LastModifiedDate, rq_itm__r.RQ__r.Id, rq_itm__r.Sta__c, rq_itm__r.RQ__r.Name, rq_itm__r.sta__r.Name, rq_itm__r.sta__r.rqSTA__c, rq_itm__r.RQ__r.xawb__c, rq_itm__r.RQ__r.xanum__c, rq_itm__r.RQ__r.Zone__c, rq_itm__r.RQ__r.xchn__c, rq_itm__r.RQ__r.rmob__c, rq_itm__r.RQ__r.xaloc__c, rq_itm__r.RQ__r.Full_Name__c, rq_itm__r.RQ__r.Acc__r.Name, rq_itm__r.RQ__r.xbn__c, rq_itm__r.RQ__r.nt__c, rq_itm__r.RQ__r.prntcnt__c, rq_itm__r.RQ__r.xccn__c, rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c, rq_itm__r.RQ__r.xbrnd__c, rq_itm__r.id, rq_itm__r.name, rq_itm__r.sta__r.cd__c, rq_itm__r.sta__r.Courier_Stage__c, rq_itm__r.xcub__c, rq_itm__r.xcasc__c, rq_itm__r.exp__c, rq_itm__r.RQ__r.srvc__r.uid__c from ws_call__c where mtd_nm__c = 'ddaupload'];

        //List<ws_call__c> lstWs = [ SELECT Id FROM ws_call__c ];

        DccaBatchUtil.processSancBatch(lstWs);
        List < ws_call__c > lstWsRec = [SELECT Id, err_cd__c, rq_jsn__c, adhoc_text1__c, pmid__c, xwsc__c, intsts__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.LastModifiedDate, rq_itm__r.RQ__r.Id, rq_itm__r.Sta__c, rq_itm__r.RQ__r.Name, rq_itm__r.sta__r.Name, rq_itm__r.sta__r.rqSTA__c, rq_itm__r.RQ__r.xawb__c, rq_itm__r.RQ__r.xanum__c, rq_itm__r.RQ__r.Zone__c, rq_itm__r.RQ__r.xchn__c, rq_itm__r.RQ__r.rmob__c, rq_itm__r.RQ__r.xaloc__c, rq_itm__r.RQ__r.Full_Name__c, rq_itm__r.RQ__r.Acc__r.Name, rq_itm__r.RQ__r.xbn__c, rq_itm__r.RQ__r.nt__c, rq_itm__r.RQ__r.prntcnt__c, rq_itm__r.RQ__r.xccn__c, rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c, rq_itm__r.RQ__r.xbrnd__c, rq_itm__r.id, rq_itm__r.name, rq_itm__r.sta__r.cd__c, rq_itm__r.sta__r.Courier_Stage__c, rq_itm__r.xcub__c, rq_itm__r.xcasc__c, rq_itm__r.exp__c, rq_itm__r.RQ__r.srvc__r.uid__c from ws_call__c where mtd_nm__c = 'LADocs'];

        DccaBatchUtil.processLAAtts(lstWsRec);

        ws_call__c ws = new ws_call__c();
        ws.mtd_nm__c = 'LADocs';
        insert ws;
        Blob b = Blob.valueOf('Test Data');
        List < id > laddList = new List < id > ();
        LADocs__e lde = new LADocs__e();
        lde.wsid__c = ws.id;
        //Database.saveresult sr=EventBus.publish(lde);
        DccaBatchUtil.ladocsevnt(new List < LADocs__e > {
            lde
        });

        Test.setMock(HttpCalloutMock.class, new mockExchFailedResponse());
        // DccaBatchUtil.exchOICDocUpload(new List<Id> { lstWs[0].Id });
        DccaBatchUtil.pushCreateCDBGREFATT(new List < Id > {
            ws.id
        });
        DccaBatchUtil.pushCreateCDBGREFHISATT(new List < Id > {
            ws.id
        });

        Test.stopTest();


    }

    //###################################################################################
    // mockResp classes

    public class mockProcessInvDDABatch implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String dummyResp = '{"inv":[{"refNo":"85302920190918","payMethod":"Cash","invNo":"T2019101937911","invAmount":"15020.00","error":null,"dccaSrId":"a1C6F00000SkX8WUAV"}]}';
            res.setBody(dummyResp);
            res.setStatusCode(200);
            return res;
        }
    }
    public class mockProcesscbkBatch implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String dummyResp = '{"inv":[{"refNo":"85302920190918","payMethod":"Cash","invNo":"T2019101937911","invAmount":"15020.00","error":null,"dccaSrId":"a1C6F00000SkX8WUAV"}]}';
            res.setBody(dummyResp);
            res.setStatusCode(200);
            return res;
        }
    }

    public class mockExchCRMStsBatch implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String dummyResp = '[{"isSuccess":true}]';
            res.setBody(dummyResp);
            res.setStatusCode(200);
            return res;
        }
    }

    public class mockExchFailedResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String dummyResp = '[{"isSuccess":true}]';
            res.setBody(dummyResp);
            res.setStatusCode(400);
            return res;
        }
    }


    public class mockGetResp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String dummyResp = '[{"key1":"46956","city":"dubai","value":"Telnet Communications Tech LLC","product_type":"1","id":"5584","name_slug":"telnet-communications-tech-llc"}]';
            //String dummyResp ='[{"segmentId":"a089000000SmL2bAAF","Segment":"Media and Marketing Consultancy","Price":15000.00,"Label":"Media and Marketing Consultancy","Description":null,"Brand":"Dubai Studio City","AllowedActivites":1,"Activities":[{"Price":15000.00,"Name":"Media and Marketing Consultancy","Label":"Media and Marketing Consultancy","isRelatedtoTitles":false,"isRelatedtoChannel":false,"doclist":[""],"Description":"Companies providing media and marketing consultancy services to other firms, including \r\nplanning,  brand  strategies,  marketing  strategies,  designing  marketing  promotions, \r\ncampaigns development and determining sales process.","BusinessUnit":"Dubai Studio City","activityId":"a1290000007ysr9AAA"}]},{"segmentId":"a089000000SmL2gAAF","Segment":"Digital Content Creation","Price":15000.00,"Label":"Digital Content Creation","Description":null,"Brand":"Dubai Studio City","AllowedActivites":2,"Activities":[{"Price":15000.00,"Name":"Animation","Label":"Animation","isRelatedtoTitles":false,"isRelatedtoChannel":false,"doclist":[""],"Description":"Companies involved in the creation of animated content, such as animated films,\ndocumentaries, TV shows and TV commercials.","BusinessUnit":"Dubai Studio City","activityId":"a1290000007ysrUAAQ"},{"Price":15000.00,"Name":"Video Games","Label":"Video Games","isRelatedtoTitles":false,"isRelatedtoChannel":false,"doclist":[""],"Description":"Companies specialised in developing and implementing the art or process of preparing \nvideo games, and/or electronic or computerised game played by manipulating images on a \nvideo display or television screen.","BusinessUnit":"Dubai Studio City","activityId":"a1290000007ysrTAAQ"}]},{"segmentId":"a08D000000Zb6yvIAB","Segment":"Property Management Services","Price":15000.00,"Label":"Property Management Services","Description":"Branches of existing companies or other licensed commercial entities or companies incorporated\nin the Free Zone to manage commercial and residential property located within the Free Zone\nonly.","Brand":"Dubai Studio City","AllowedActivites":1,"Activities":[{"Price":15000.00,"Name":"Property Management","Label":"Property Management","isRelatedtoTitles":false,"isRelatedtoChannel":false,"doclist":[{"isMandatory":true,"docName":"A valid No Objection Certificate from the Real Estate Regulatory Agency (RERA)"}],"Description":"Branches of existing companies or other licensed commercial entities or companies\nincorporated in the Free Zone to manage the leasing and administration of commercial and\nresidential property located within the Free Zone only","BusinessUnit":"Dubai Studio City","activityId":"a12D0000001YyYUIA0"},{"Price":15000.00,"Name":"Commercial Developer","Label":"Commercial Developer","isRelatedtoTitles":false,"isRelatedtoChannel":false,"doclist":[{"isMandatory":true,"docName":"Title Deed / Usufruct Title Deed issued by the Dubai Land Department"}],"Description":"Branches of existing companies or other licensed commercial entities or companies\nincorporated in the Free Zone that has purchased or leased land with the intention of\nconstructing premises for commercial purpose.  This will also allow the Licensee to\ncollaborate with the Master Developer under the terms of the Master Developers Property\nManagement and Leasing Agreement - PMLA)","BusinessUnit":"Dubai Studio City","activityId":"a12D0000001YyYSIA0"},{"Price":15000.00,"Name":"Administration office","Label":"Administration office","isRelatedtoTitles":false,"isRelatedtoChannel":false,"doclist":[{"isMandatory":true,"docName":"Copy of Contract signed between Building Developer and Property Management"},{"isMandatory":true,"docName":"Copy of Contract signed between Property Management and Leasing Company"},{"isMandatory":true,"docName":"Property Management Services Guideline"},{"isMandatory":true,"docName":"Original Title Deed issued by Dubai Land Department for verification"},{"isMandatory":true,"docName":"A copy of Certificate from Center for Healthcare Planning and Quality"}],"Description":"Branches of existing companies or other licensed commercial entities or companies\nincorporated in the Free Zone to manage the construction process of the Licensees\npremises in the Free Zone.  An Administration Office activity licence does not otherwise\npermit the Licensee to undertake any business activity from the Free Zone","BusinessUnit":"Dubai Studio City","activityId":"a12D0000001YyYQIA0"},{"Price":15000.00,"Name":"Residential Developer","Label":"Residential Developer","isRelatedtoTitles":false,"isRelatedtoChannel":false,"doclist":[{"isMandatory":true,"docName":"Title Deed / Usufruct Title Deed issued by the Dubai Land Department"}],"Description":"Branches of existing companies or other licensed commercial entities or companies\nincorporated in the Free Zone that has purchased or leased land with the intention of\nconstructing a building for residential purpose.","BusinessUnit":"Dubai Studio City","activityId":"a12D0000001YzruIAC"}]},{"segmentId":"a08D000000Zb6z3IAB","Segment":"Film Support Services","Price":15000.00,"Label":"Film Support Services","Description":null,"Brand":"Dubai Studio City","AllowedActivites":2,"Activities":[{"Price":15000.00,"Name":"Talent Management","Label":"Talent Management","isRelatedtoTitles":false,"isRelatedtoChannel":false,"doclist":[""],"Description":"Companies that represent talent and involved in sourcing talent for film, television, media\nand entertainment industry.  Talent shall include:  actors, directors, musicians, singers,\ndancers, script writers, TV/radio presenters, set and stage designers, art directors, visual\nartists, performing artists, recording artists and literary artists.","BusinessUnit":"Dubai Studio City","activityId":"a12D0000001YyZYIA0"},{"Price":15000.00,"Name":"Casting Agency","Label":"Casting Agency","isRelatedtoTitles":false,"isRelatedtoChannel":false,"doclist":[""],"Description":"Companies  involved  in  sourcing  talent  for  the  media  entertainment  industry  and\nproviding services for hiring actors.","BusinessUnit":"Dubai Studio City","activityId":"a12D0000001YyZXIA0"}]}]';
            res.setBody(dummyResp);
            res.setStatusCode(200);
            return res;
        }
    }

    public class mockProcessInvYardiFineBatch implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map < String, Object > response, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            response.put('response_x', '{"Legal Name":"Dubai Design District FZ LLC","yardiInvoice":"C-207526;R-105809;","axsinvoice":"C-207528;R-105810","status ":"Success"}');
        }
    }
}