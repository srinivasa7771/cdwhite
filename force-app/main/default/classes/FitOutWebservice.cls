public with sharing class FitOutWebservice{
    public static void sendSR(Ws_call__c ws) {
        g_Req__c  lstreq = new g_Req__c();
        lstreq = [Select id, name, skpu__c, srvc__r.uid__c, (select id, name, ccrmid__c, itm__c,
            xcusr__c from Items__r where itm__c = :ws.rq_itm__c) from g_Req__c where id =: ws.uid__c.split('-')[0]];
        HttpResponse response = ccrmCallout(ws.rq_jsn__c, 'fitout');
        Response ccrmRes = (Response)JSON.deserialize(response.getBody(), Response.class);
        if (ccrmRes.isSuccess) {
            g_reqitem__c reqItm = new g_reqitem__c();
            if (lstreq.skpu__c && lstreq.srvc__r.uid__c == '327') {
                lstreq.skpu__c = false;
                if (Schema.sObjectType.g_Req__c.isUpdateable()) {
                    update lstreq;
                }
            }
            reqItm.id = ws.rq_itm__c;
            reqItm.ccrmid__c = ccrmRes.subReqId;
            reqItm.xcusr__c= ccrmRes.subReqRef;
            if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                update reqItm;
            }
            ws.res_jsn__c = ccrmRes.subReqId;
            ws.intsts__c ='Success';
            if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                update ws;
            }
            if (lstreq.srvc__r.uid__c != '196') {
                ws_call__c wsCa = new ws_call__c();
                wsCa.ws_typ__c = 'Fitout';
                wsCa.mtd_nm__c = 'UploadDocs';
                wsCa.uid__c = lstreq.id + '-' + wsCa.mtd_nm__c + system.now();
                wsCa.rq_itm__c = reqItm.id ;
                wsCa.intsts__c = 'Ready for Integration';
                if (Schema.sObjectType.ws_call__c.isCreateable()) {
                    insert wsCa;
                }
            }
        }
        else{
            ws.res_jsn__c = ccrmRes.errorMessage;
            ws.intsts__c ='Failed';
            if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                update ws;
            }
        }
    }
    public static HttpResponse ccrmCallout(String rqJsn, string endpoint) {
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:D3_NC/apexrest/'+endpoint);
        request.setMethod('POST');
        request.setBody(rqJsn);
        return h.send(request);
    }

    public static void sendDocs(Ws_call__c ws) {
        set<id> rdocs = new Set<id>();
        string ccrmId = '';
        String s3DocNameId='';
        String s3url='';
        for (g_reqDoc__c doc : [SELECT Id, name, (select id,
            reqItm__r.ccrmid__c from Docs__r where reqItm__r.ccrmid__c != null) from g_reqDoc__c where id in (select reqDoc__c from g_reqitemDoc__c where reqItm__c = : ws.rq_itm__c) order by createddate]) {
            rdocs.add(doc.Id);
            if ((doc.name).containsIgnoreCase('Drawings (PDF, DWF , DWG format)')) {
                s3DocNameId=doc.id;
            }
        }
        if (ws.rq_itm__r.Name == 'Final Inspection') {
            PageReference pdfCreated = new PageReference('/apex/grqADCPdf?id='+ws.rq_itm__r.RQ__c);
            Blob body = pdfCreated.getContentAsPDF();
            prepDoc('Asset Damage Clearance', 'Asset Damage Clearance.pdf', body, ws.rq_itm__r.ccrmid__c);
        }
        System.debug('rdocs :'+rdocs);
        for (Attachment  att : [select id, parentid, parent.name, name, body from Attachment where parentid in :rdocs]) {
            prepDoc(att.parent.name, att.name, att.body, ws.rq_itm__r.ccrmid__c);
        }// to be refactored
        ws.intsts__c ='Success';
        if (Schema.sObjectType.ws_call__c.isUpdateable()) {
            update ws;
        }

    }
    public static void prepDoc(String DocName, string fileName, blob fileBody, id ccrmId) {
        grqWsOnboard.DocumentInfo doc = new grqWsOnboard.DocumentInfo();
        doc.recid = ccrmId;
        doc.docName = DocName;
        doc.fileName = fileName;
        doc.fileBody = EncodingUtil.base64Encode(fileBody);
        String rqBody = Json.serialize(doc);
        HttpResponse response = ccrmCallout(rqBody, 'createdoc');
    }

    public class fitOutWrapper{
        public string utilNOCId;
        public String contrName;
        public String ctcName;
        public String ctcEmail;
        public String ctcPhone;
        public String bpName;
        public String bpEmail;
        public String bpphone;
        public long licNumber;
        public double fitoutarea;
        public double totalarea;
        public string activities;
        public string subActivities;
        public string agreeNo;
        public string unitNumber;
        public string fitOutType;
        public string axsId;
        public string axsreference;
        public string businessPark;
        public string leaseBP;
        public string notes;
        public string plotNumber;
        public string buildingName;
        public string ddatradelic;
        public subCategory subCatg;
        public string electNOC;public string lvpanelmdb;
        public string mainmet;public string allocload;
        public string submet;public string addload;
        public string smdbref;public string totalconld;
        public string mdbsmdbref;public string lvmdbrev;public string spareLoad;
        public string sourcesubm;
        public string requestType;
        public string insCom;
        public string reasonForRevision;
        public string inspectionType;
    }
    public class InpestionDetails{
        public fitOutWrapper finalInspection;
        public fitOutWrapper firstInspection;
    }
    public class subCategory{
        public List<String> archAct;
        public List<String> mepAct;
        public List<String> structAct;
    }
    public class Response{ public String subReqId ; public string subReqRef; public Boolean isSuccess = false ; public String errorMessage = '' ; }
}