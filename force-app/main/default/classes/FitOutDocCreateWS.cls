@RestResource(urlMapping='/createDocs/*')
global class FitOutDocCreateWS {
    @HttpPost
    global static void updateReq() {
        RestRequest request = RestContext.request;
        Map<String, Object> requestData = (Map<String, Object>)JSON.deserializeUntyped(request.requestBody.toString());
        String method=(String)requestData.get('methodName');
        switch on method {
            when 'insertAttachment'{
                insertAttachment(JSON.serialize(requestData.get('data')));
            }
            when 'updateUtilNOC'{
                updateUtilNOC(JSON.serialize(requestData.get('data')));
            }
            when 'updateFitOutType'{
                updateFitOUtType(JSON.serialize(requestData.get('data')));
            }
        }
    }
    global static void insertAttachment(String requestJson) {
        AttachmentInfo docInfo = (AttachmentInfo)JSON.deserialize(requestJson, AttachmentInfo.class);
        g_reqitem__c reqitm = [Select id, RQ__c from g_reqitem__c where ccrmid__c = :docInfo.oraclePartyId LIMIT 1];
        g_reqDoc__c reqDoc = new g_reqDoc__c(RQ__c = reqitm.RQ__c, Name=docInfo.fileName);
        if (Schema.sObjectType.g_reqDoc__c.isCreateable()) {
            insert reqDoc;
        }
        g_reqitemDoc__c reqItmDoc = new g_reqitemDoc__c(Name=docInfo.fileName, lbl__c=docInfo.fileName,
                                                        reqDoc__c=reqDoc.Id, reqItm__c=reqitm.Id, mnAts__c=1, mxAts__c
                                                        =1, Req__c=true, reqAts__c=true);
        if (Schema.sObjectType.g_reqitemDoc__c.isCreateable()) {
            insert reqItmDoc;
        }
        Attachment att = new Attachment(Body = EncodingUtil.base64Decode(docInfo.base64Body), Name = docInfo.fileName, ParentId = reqDoc.Id);
        if (Schema.sObjectType.Attachment.isCreateable()) {
            insert att;
        }
    }
    global static void updateUtilNOC(String requestJson) {
        utilityinfo requestData = (utilityinfo)JSON.deserialize(requestJson, utilityinfo.class);
        g_reqitem__c reqitm = [Select id, RQ__c, ccrmid__c, RQ__r.xcddocs__c from g_reqitem__c where ccrmid__c = :requestData.ccrmid LIMIT 1 ];
        g_Req__c req = new     g_Req__c(id=reqitm.RQ__c);
        req.x30gr__c = requestData.requireUtilNOC;
        /*if (requestData.requireUtilNOC && !reqitm.RQ__r.xcddocs__c.split(';').contains('Existing vs Proposed Load Schedule')) {
            List<String> docsLit = reqitm.RQ__r.xcddocs__c.split(';');
            docsLit.add('Existing vs Proposed Load Schedule;');
            req.xcddocs__c = String.join(docsLit, ';');
        }*/
        if (Schema.sObjectType.g_Req__c.isUpdateable()) {
            update req;
        }
    }
    global static void updateFitOUtType(String requestJson) {
        utilityinfo requestData = (utilityinfo)JSON.deserialize(requestJson, utilityinfo.class);
        g_reqitem__c reqitm = [Select id, RQ__c, ccrmid__c, RQ__r.xcddocs__c from g_reqitem__c where ccrmid__c = :requestData.ccrmid LIMIT 1 ];
        g_Req__c req = new     g_Req__c(id=reqitm.RQ__c);
        req.xfb__c = requestData.fitoutType;
        if (Schema.sObjectType.g_Req__c.isUpdateable()) {
            update req;
        }
    }

    public class AttachmentInfo{
        public String oraclePartyId ;
        public String ddaDocumentId;
        public String base64Body ;
        public String fileName ;
        public String description ;
    }
    public class utilityinfo{
        public string ccrmid ;
        public string fitoutType;
        public boolean requireUtilNOC;
    }
}