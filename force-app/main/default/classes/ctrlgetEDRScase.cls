public class ctrlgetEDRScase {

    public String infoListStr{get;set;}
    public String edrsCaseHistory{get;set;}
    public List<edrsCaseInfo> caseList{get;set;}
    public string docPage {get; set;}
    public String parentRecId {get; set;}
    public List<edrsCaseInfo> infoList {get; set;}
    public List<Status> caseHisList {get; set;}
    public boolean showData{get;set;}
    public void getAttachmentList() {

        String docId = apexpages.currentpage().getparameters().get('docId');
        String parentId = apexpages.currentpage().getparameters().get('parentId');
        system.debug(docId+ '---'+parentRecId);
        string jsonStr = '{"methodname":"getAttachment", "data":{"parentRecId":"'+parentId+'", "docId" : "'+docId+'"}}';
        // jsonStr='{"methodname":"getAttachment", "data":{"parentRecId" : "a6k6F000000NBSW", "docId" : "0691m000001FlvD"}}'; dummy request
        system.debug(jsonStr);
        String responseBody = DDAServices.getDDAServices('DCCA_Auth', 'onbordingapi', 'POST', jsonStr);
        system.debug(responseBody);
        Map<String, Object> metadata_Map = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        if (metadata_Map.containsKey('filebody')) {
            docPage = (String)metadata_Map.get('filebody');
        } else {
            docpage = '';
        }

    }
    public void getCaseList() {
        showData=false;
        user usr =[select id, contact.account.lc__c from User where id =: UserInfo.getUserId() limit 1];
        string jsonStr = '{"methodname":"getcases", "data":{"licenseNum":"'+usr.contact.account.lc__c+'"}}';
        //string jsonStr = '{"methodname":"getcases", "data":{"licenseNum":"20979"}}'; //dummy request
        system.debug('---jsonStr---'+jsonStr);
        String responseBody = DDAServices.getDDAServices('DCCA_Auth', 'onbordingapi', 'POST', jsonStr);
        // responseBody = '[ { "statushistory": null, "status": "Referred to Court", "edrsId": "a6k6F000000Ev9oQAC", "docs": [{ "isMandatory": false, "docType": "Court Referral Letter", "docName": "Court Referral Letter - V1.pdf", "docId": "00P6F00003X7IggUAF", "activityId": null }, { "isMandatory": false, "docType": "Investigation Minute", "docName": "Investigation Minute EDRS-006698 - V1.pdf", "docId": "00P6F00003X7IcnUAF", "activityId": null }, { "isMandatory": false, "docType": "Dispute Form", "docName": "Dispute Form EDRS-006698 - V1.pdf", "docId": "00P6F00003Wd1rKUAR", "activityId": null }], "created": "2021-12-22T08:02:34.000Z", "closed": null, "caseno": "EDRS-006698" }, { "statushistory": [{ "status": "Receipt of Application", "started": "2021-12-22T08:16:02.000Z", "completed": "2021-12-23T05:38:46.000Z" }, { "status": "Request Under Review", "started": "2021-12-23T05:38:46.000Z", "completed": "2022-01-03T10:41:43.000Z" }, { "status": "Request sent for document upload", "started": "2021-12-23T05:39:04.000Z", "completed": "2022-01-03T10:36:31.000Z" }, { "status": "IM Created", "started": "2022-01-03T10:41:43.000Z", "completed": "2022-01-03T10:46:23.000Z" }, { "status": "Referred to Court", "started": "2022-01-03T10:46:23.000Z", "completed": null }], "status": "Referred to Court", "edrsId": "a6k6F000000Ev9tQAC", "docs": [{ "isMandatory": false, "docType": "Court Referral Letter", "docName": "Court Referral Letter - V1.pdf", "docId": "00P6F00003X7IhZUAV", "activityId": null }, { "isMandatory": false, "docType": "Investigation Minute", "docName": "Investigation Minute EDRS-006699 - V1.pdf", "docId": "00P6F00003X7IXHUA3", "activityId": null }, { "isMandatory": false, "docType": "Dispute Form", "docName": "Dispute Form EDRS-006699 - V1.pdf", "docId": "00P6F00003Wd29RUAR", "activityId": null }], "created": "2021-12-22T08:16:02.000Z", "closed": null, "caseno": "EDRS-006699" } ]';
        system.debug('---responseBody---'+responseBody);
        infoList = new List<edrsCaseInfo>();
        caseHisList = new List<Status> ();
        caseList = new List<edrsCaseInfo>();
        if (!string.isBlank(responseBody)) {
        caseList= (List<edrsCaseInfo>)System.JSON.deserialize(responseBody, List<edrsCaseInfo>.class);
        system.debug('caseList -- '+JSON.serialize(caseList));
        if (caseList != null && !caseList.isEmpty()) {
            showData=true;
            for (edrsCaseInfo obj:caseList) {
                obj.empName=nameFormat(obj.empName);
                obj.personName=nameFormat(obj.personName);
                infoList.add(obj);
                infoListStr = JSON.serialize(infoList);
                system.debug('---infoListStr---'+infoListStr);
                edrsCaseHistory =JSON.serialize(caseHisList);

            }

        }
        }

    }
    public void getCaseHistory() {
        String caseNum = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('cn'));
        system.debug('caseNum -- '+caseNum);
        for (ctrlgetEDRScase.edrsCaseInfo c:caseList) {
            if (c.caseno == caseNum) {
                edrsCaseHistory = JSON.serialize(c.statushistory);
                system.debug('edrsCaseHistory -- '+edrsCaseHistory);
            }
        }
    }

    public class edrsCaseInfo{
        public string caseno{get; set;}
        public dateTime created{get; set;}
        public dateTime closed{get; set;}
        public string status{get; set;}
        public string edrsId{get;set;}
        public string empName{get;set;}
        public string personName{get;set;}
        public List<attachments> docs{get; set;}
        public List<Status> statushistory{get; set;}
    }
    public class attachments{
        public String docName{get; set;}
        public String docType{get; set;}
        public String docId{get; set;}
    }
    public class Status{
        public string status{get; set;}
        public dateTime started{get; set;}
        public dateTime completed{get; set;}
    }
    public String nameFormat (String name) {
        String result = '';
        if (name != null && name != '') {
            for (String iter : name.split('[ ]+')) {
                if (iter != null && iter != '') {
                    if (iter.length() > 1) {
                        result += iter.substring(0, 1).toUpperCase() + iter.substring(1, iter.length()) + ' ';
                    }
                    else {
                        result += iter.substring(0, 1).toUpperCase() + ' ';
                    }
                }
            }
            result = result.substring(0, result.length() - 1);
        }
        return result;
    }

}