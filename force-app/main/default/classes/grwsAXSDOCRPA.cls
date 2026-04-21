@RestResource(urlMapping='/grwsAXSDOCRPA/*')
global class grwsAXSDOCRPA {

    @HttpGet
    global static void grwsAXSDOCRPA() {
        RestContext.response.addHeader('Content-Type', 'application/json');
        String reqBody  = RestContext.request.requestBody.toString();
        grwsAXSDOCRPA.rpaReq dptData = (grwsAXSDOCRPA.rpaReq)JSON.deserialize(reqBody, grwsAXSDOCRPA.rpaReq.class);
        String reqNum = dptData.reqNum;
        AXSDocsResponse resp = loadReqDocs(dptData.reqNum);
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }

    @HttpPost
    global static void doPost() {
        RestContext.response.addHeader('Content-Type', 'application/json');
        String reqBody  = RestContext.request.requestBody.toString();
        System.debug('reqBody: ' + reqBody);
        grwsRPA.rpaReq dptData = (grwsRPA.rpaReq)JSON.deserialize(reqBody, grwsRPA.rpaReq.class);
        System.debug('dptData: ' + dptData);
        Boolean expPriority = dptData.expPriority=='1'?true:false;
        String reqNum = dptData.reqNum;
        AXSDocsResponse resp = loadReqDocs(dptData.reqNum);
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }

    public static AXSDocsResponse loadReqDocs(string rqRef) {
        AXSDocsResponse res = new AXSDocsResponse();
        List<AttachmentWrapper> attWrapList = new List<AttachmentWrapper>();
        Map <Id, String > docTypeNameFromId = new Map < Id, String > ();
        Map < Id, String > ItemCodeFromId = new Map < Id, String > ();
        Set < Id > Ids = new Set < Id > ();
        for (g_reqitemDoc__c itmD : [Select Id, Name, Tp__c, reqDoc__r.Name, reqItm__r.itmCd__c,
            reqDoc__r.Id From g_reqitemDoc__c where Req__c=true and reqAts__c=true and upOk__c=true and reqItm__r.RQ__r.name =:rqRef]) {
            Ids.add(itmD.reqDoc__r.Id);
            docTypeNameFromId.put(itmD.reqDoc__r.Id, itmD.Tp__c);
            ItemCodeFromId.put(itmD.reqDoc__r.Id, itmD.reqItm__r.itmCd__c);
        }
        for (Attachment att: [select Id, Name, ParentId, ContentType  from Attachment where ParentId in: Ids]) {
            try {

                AttachmentWrapper aWrap = new AttachmentWrapper();
                aWrap.att = att;
                aWrap.id = att.id;
                aWrap.reqDocName = docTypeNameFromId.get(att.ParentId);
                aWrap.itemCode = ItemCodeFromId.get(att.ParentId);
                if (String.isNotBlank(att.ContentType) && att.ContentType.contains('pdf')) {
                    aWrap.reqDocName='Entry Permit.jpg';
                    att.Name='Entry Permit.jpg';
                    aWrap.url='https://axs.force.com/apex/PdftoJpg?id='+att.id;
                }
                else
                    aWrap.url='https://axs.force.com/servlet/servlet.FileDownload?file='+att.id;
                attWrapList.add(aWrap);
            } catch (Exception e) {
                System.debug('** Exception while iterating attachments: ' + e);
            }
        }
        res.attLst = attWrapList;
        return res;
    }
    global class AttachmentWrapper {
        WebService Attachment att {set;get;}
        WebService String id {set;get;}
        WebService String attCode {set;get;}
        WebService String reqDocName {set;get;}
        WebService String itemCode {set;get;}
        WebService String url {set;get;}

        public AttachmentWrapper() {att = new Attachment();}
    }
    global class AXSDocsResponse {
        WebService list<AttachmentWrapper> attLst {set;get;}
    }

    global class rpaResp {webService String respCode, status, respMsg, SRN, AxsId;}
    global class rpaReq  {webService String reqNum, srvcd, itmCd, expPriority;}
}