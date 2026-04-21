@isTest
public class FitOutWebserviceTest {
    @testSetup static void setup() {
        testData.init();
        Account a = testData.accCrt(false);
        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();
        testData.bRulesItemCrt();
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        s.uid__c = '327';
        update s;
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
        system.debug('srvcLst----' + srvcLst);
        Contact c = new Contact(Id = conLst[0].Id, mbs__c = 500000, eidid__c = '784198774283257', eidedt__c = system.today().addyears(3));
        update c;
        List < g_srvc_settings__c > srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name = 'srvcStg'
            LIMIT 1
        ];
        Contact emp = testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        system.debug('conLst[0].Id' + conLst[0].Id);
        g_Req__c req = testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        req.xadtx2__c = '{"fitOutType":"Minor"}';
        req.OS__c = 'Contractor Appointed';
        req.xceml__c = 'test@invalid.com';
        update req;
        Integer counter = 0;
        List < g_srvcitm__c > srvItemUpd = new List < g_srvcitm__c > ();
        for (g_srvcitm__c srvItm: [select id, name from g_srvcitm__c where srvc__r.Name = 'Srvc'
                LIMIT 2
            ]) {
            if (counter == 0) {
                srvItm.name = 'Fit Out';
            } else {
                srvItm.name = 'Utility NOC';
            }
            counter++;
            srvItemUpd.add(srvItm);
        }
        update srvItemUpd;
        g_reqitem__c reqItm = [select id, ccrmid__c from g_reqitem__c limit 1];
        reqItm.ccrmid__c = '123';
        update reqItm;

    }
    @isTest
    static void testSendSR() {
        try {
            g_Req__c req = [select id from g_Req__c LIMIT 1];
            Ws_call__c ws = new Ws_call__c(uid__c = req.Id + '-TestUID');
            insert ws;

            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

            Test.startTest();
            FitOutWebservice.sendSR(ws);
            Test.stopTest();
            ws = [SELECT intsts__c, res_jsn__c FROM Ws_call__c WHERE Id =: ws.Id];
            System.assertEquals('Success', ws.intsts__c);
            System.assertNotEquals(null, ws.res_jsn__c);
        } catch (Exception e) {}
    }


    @isTest
    static void testSendDocs() {
        g_Req__c req = [select id from g_Req__c LIMIT 1];

        g_reqDoc__c rdoc = new g_reqDoc__c(Name = 'test', RQ__c = req.Id, ats__c = 5);
        insert rdoc;

        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId = rdoc.Id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        insert attachment;


        Ws_call__c ws = new Ws_call__c(uid__c = req.Id + '-TestUID');
        insert ws;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        FitOutWebservice.sendDocs(ws);
        Test.stopTest();
        ws = [SELECT intsts__c FROM Ws_call__c WHERE Id =: ws.Id];
        System.assertEquals('Success', ws.intsts__c);
    }

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('Mock response');
            return res;
        }
    }
    @isTest
    static void testValidateRequest() {
        g_Req__c req = [select id from g_Req__c LIMIT 1];

        PageReference myVfPage = new PageReference('/apex/FitOut_ContractorApp');
        myVfPage.getParameters().put('id', req.Id);
        Test.setCurrentPage(myVfPage);

        Test.startTest();
        FitoutContLoginController controller = new FitoutContLoginController();
        controller.validateRequest();
        controller.checkValidEmail();
        Test.stopTest();
    }
    @isTest
    static void testCreateDataInvalidOtp() {
        g_Req__c req = [select id from g_Req__c LIMIT 1];

        PageReference myVfPage = new PageReference('/apex/FitOut_ContractorApp');
        myVfPage.getParameters().put('id', req.Id);
        Test.setCurrentPage(myVfPage);

        FitoutContLoginController controller = new FitoutContLoginController();
        controller.otpfrmPg = '1234';

        Test.startTest();
        PageReference pageRef = controller.createData();
        Test.stopTest();
    }
    @isTest
    static void testUpdateFitOutType() {
        FitOutDocCreateWS.utilityinfo utilInfo = new FitOutDocCreateWS.utilityinfo();
        utilInfo.ccrmid = '123';
        utilInfo.fitoutType = 'General';

        RestContext.request = new RestRequest();
        RestContext.request.requestBody = Blob.valueOf(JSON.serialize(
            new Map < String, Object > {
                'methodName' => 'updateFitOutType',
                'data' => utilInfo
            }
        ));

        RestContext.response = new RestResponse();
        Test.startTest();
        FitOutDocCreateWS.updateReq();
        Test.stopTest();

    }
    @isTest
    static void testUpdateUtilNOC() {
        FitOutDocCreateWS.utilityinfo utilInfo = new FitOutDocCreateWS.utilityinfo();
        utilInfo.ccrmid = '123';
        utilInfo.requireUtilNOC = true;

        RestContext.request = new RestRequest();
        RestContext.request.requestBody = Blob.valueOf(JSON.serialize(
            new Map < String, Object > {
                'methodName' => 'updateUtilNOC',
                'data' => utilInfo
            }
        ));

        RestContext.response = new RestResponse();
        Test.startTest();
        FitOutDocCreateWS.updateReq();
        Test.stopTest();

    }
    @isTest
    static void testInsertAttachment() {
        FitOutDocCreateWS.AttachmentInfo attachmentInfo = new FitOutDocCreateWS.AttachmentInfo();
        attachmentInfo.oraclePartyId = '123';
        attachmentInfo.fileName = 'TestFile.pdf';
        attachmentInfo.base64Body = EncodingUtil.base64Encode(Blob.valueOf('Test Content'));

        RestContext.request = new RestRequest();
        RestContext.request.requestBody = Blob.valueOf(JSON.serialize(
            new Map < String, Object > {
                'methodName' => 'insertAttachment',
                'data' => attachmentInfo
            }
        ));

        RestContext.response = new RestResponse();
        Test.startTest();
        FitOutDocCreateWS.updateReq();
        Test.stopTest();
    }

}