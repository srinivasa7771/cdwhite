@isTest
public class ctrlgetEDRScaseTest {
    static testmethod void test1() {
        Account acc = new Account(name='testAcc', lc__c='101');
        string jsonStr = '{"methodname":"getcases", "data":{"licenseNum":"101"}}';
        string jsonStrAtt = '{"methodname":"getAttachment", "data":{"parentRecId" : "a6k6F000000NBSW", "docId" : "0691m000001FlvD"}}';
         //String dummyResp = DDAServices.getDDAServices('DCCA_Auth', 'onbordingapi', 'POST', jsonStrAtt);
         String dummyRespCs = '[ { "statushistory": null, "status": "Referred to Court", "edrsId": "a6k6F000000Ev9oQAC", "docs": [{ "isMandatory": false, "docType": "Court Referral Letter", "docName": "Court Referral Letter - V1.pdf", "docId": "00P6F00003X7IggUAF", "activityId": null }, { "isMandatory": false, "docType": "Investigation Minute", "docName": "Investigation Minute EDRS-006698 - V1.pdf", "docId": "00P6F00003X7IcnUAF", "activityId": null }, { "isMandatory": false, "docType": "Dispute Form", "docName": "Dispute Form EDRS-006698 - V1.pdf", "docId": "00P6F00003Wd1rKUAR", "activityId": null }], "created": "2021-12-22T08:02:34.000Z", "closed": null, "caseno": "EDRS-006698" }]';
        List<object> csList= (List<object>) JSON.deserializeUntyped(dummyRespCs);
       // Map<String, Object> csMap = (Map<String, Object>) JSON.deserializeUntyped(dummyRespCs);
       // Map<String, Object> metadata_Map = (Map<String, Object>) JSON.deserializeUntyped(dummyResp);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockGetEdrsCases());
        //ApexPages.currentPage().getParameters().put('parentRecId', (String)csMap.get('edrsId'));
        ctrlgetEDRScase ctrl = new ctrlgetEDRScase();
        //if (metadata_Map.containsKey('filebody')) {
           // ctrl.docPage = (String)metadata_Map.get('filebody');
        //} else {
           // ctrl.docpage = '';
        //}
        ctrl.getCaseList();
        ctrl.nameFormat('edrs case');
        //ApexPages.currentPage().getParameters().put('docId', (String)csMap.get('docId'));
        //ApexPages.currentPage().getParameters().put('cn', (String)csMap.get('caseno'));
        ctrlgetEDRScase.edrsCaseInfo ed = new ctrlgetEDRScase.edrsCaseInfo();
        ed.caseno='cs1';ed.created=system.now();ed.closed=system.now();ed.status='cs1';ed.edrsId='cs1';ed.empName='cs1';ed.personName='cs1';
        ctrlgetEDRScase.attachments att = new ctrlgetEDRScase.attachments();
        att.docName='crl';att.docType='ref';att.docId='a69';
         ctrlgetEDRScase.Status st = new ctrlgetEDRScase.Status();
        st.status='under review';st.started=system.now();st.completed=system.now();
        //ctrl.getAttachmentList();
        ctrl.getCaseHistory();
        test.stopTest();

    }
    public class mockGetEdrsCases implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String dummyResp = '[ { "statushistory": null, "status": "Referred to Court", "edrsId": "a6k6F000000Ev9oQAC", "docs": [{ "isMandatory": false, "docType": "Court Referral Letter", "docName": "Court Referral Letter - V1.pdf", "docId": "00P6F00003X7IggUAF", "activityId": null }, { "isMandatory": false, "docType": "Investigation Minute", "docName": "Investigation Minute EDRS-006698 - V1.pdf", "docId": "00P6F00003X7IcnUAF", "activityId": null }, { "isMandatory": false, "docType": "Dispute Form", "docName": "Dispute Form EDRS-006698 - V1.pdf", "docId": "00P6F00003Wd1rKUAR", "activityId": null }], "created": "2021-12-22T08:02:34.000Z", "closed": null, "caseno": "EDRS-006698" }, { "statushistory": [{ "status": "Receipt of Application", "started": "2021-12-22T08:16:02.000Z", "completed": "2021-12-23T05:38:46.000Z" }, { "status": "Request Under Review", "started": "2021-12-23T05:38:46.000Z", "completed": "2022-01-03T10:41:43.000Z" }, { "status": "Request sent for document upload", "started": "2021-12-23T05:39:04.000Z", "completed": "2022-01-03T10:36:31.000Z" }, { "status": "IM Created", "started": "2022-01-03T10:41:43.000Z", "completed": "2022-01-03T10:46:23.000Z" }, { "status": "Referred to Court", "started": "2022-01-03T10:46:23.000Z", "completed": null }], "status": "Referred to Court", "edrsId": "a6k6F000000Ev9tQAC", "docs": [{ "isMandatory": false, "docType": "Court Referral Letter", "docName": "Court Referral Letter - V1.pdf", "docId": "00P6F00003X7IhZUAV", "activityId": null }, { "isMandatory": false, "docType": "Investigation Minute", "docName": "Investigation Minute EDRS-006699 - V1.pdf", "docId": "00P6F00003X7IXHUA3", "activityId": null }, { "isMandatory": false, "docType": "Dispute Form", "docName": "Dispute Form EDRS-006699 - V1.pdf", "docId": "00P6F00003Wd29RUAR", "activityId": null }], "created": "2021-12-22T08:16:02.000Z", "closed": null, "caseno": "EDRS-006699" } ]';
            res.setBody(dummyResp);
            res.setStatusCode(200);
            return res;
        }
    }
}