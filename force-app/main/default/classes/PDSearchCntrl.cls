public class PDSearchCntrl {
    public String passPrt { get; set; }
    public String selCatg { get; set; }
    public String selItm { get; set; }
    public String selStat { get; set; }
    public String zone { get; set; }

    public List<rqDocWrapper> finalListRqDoc{get;set;}
    public Transient  List<g_reqitem__c> reqItmList{get;set;}
    public Transient  List<g_reqitem__c> finalListRqItm{get;set;}
    public Transient map<String, g_reqitem__c> mapRefReqItm {get;set;}

    List<selectOption> categoryOption;
     List<selectOption> itemOptions ;
    List<selectOption> statusOptions ;

    public List<selectOption> getCatOpt() {categoryOption = new List<selectOption>();return categoryOption;}

    public List<selectOption> getItmOpt() {return itemOptions;}

    public List<selectOption> getStsOpt() {statusOptions = new List<selectOption>();return statusOptions;}
    /*
    public PDSearchCntrl() {
        queryReqDoc();
    }
    */

    public PageReference cleanDataTable() {finalListRqDoc = new List<rqDocWrapper>();return null;}
    public PageReference queryReqDoc() {
        finalListRqDoc = new List<rqDocWrapper>();
        Map<string, string> DocRqMp = new Map<string, string>();
        Map<string, g_Req__c> rqIdObj = new Map<string, g_Req__c>();
        List<g_Req__c>  rqLst= new List<g_Req__c>();
        system.debug('passPrt >>::'+passPrt);
        if (passPrt.trim()!=null) rqLst = [select id, name, xcp__c, Con__r.flnm__c from g_Req__c where AP__C>0 and STA__c!='Completed' AND xcp__c LIKE :passPrt.trim()+'%'];
        system.debug('rqLst >>::'+rqLst);
        if (rqLst != null && rqLst.size()>0) for (g_Req__c rq: rqLst) {
            rqIdObj.put(rq.id, rq);
        }
        system.debug('rqIdObj::'+rqIdObj);
        /* g_Req__c rq = (g_Req__c)Database.query(rq.srvc__r.stg__r.reqq__c + ' where id=\'' + String.escapeSingleQuotes(String.valueOf(rq.id)) + '\' and isDeleted = false');
        */  for (g_reqitemDoc__c doc : [select id, reqDoc__c, reqItm__r.RQ__c, reqItm__r.itm__r.cd__c from g_reqitemDoc__c where reqItm__r.RQ__c =:rqIdObj.keySet() order by createddate]) {
            DocRqMp.put(doc.reqDoc__c, doc.reqItm__r.RQ__c);
        }
        system.debug('DocRqMp::'+DocRqMp);
        for (Attachment  att : [select id, parentid,
            name from Attachment where parentid=:DocRqMp.keySet() AND (name LIKE '%Passport%' OR name LIKE '%Entry Permit%' OR name LIKE  '%_eVisa.pdf%' OR name LIKE '%LA Status Change%' OR name LIKE '%change_status%' OR Name LIKE '%Visa Copy%')]) {
            rqDocWrapper dwrap = new rqDocWrapper();
            DocumentInfo doc = new DocumentInfo();
            doc.attid = att.id;
            doc.fileName = att.name;
            /*doc.fileBody = EncodingUtil.base64Encode(att.body);
            */ dwrap.doc = doc;
            dwrap.rq = rqIdObj.get(DocRqMp.get(att.parentid));
            dwrap.passportNo = dwrap.rq.xcp__c;
            finalListRqDoc.add(dwrap);
        }
        system.debug('finalListRqDoc::'+finalListRqDoc);
        return null;
    }

   @testvisible class rqDocWrapper{
        public String passportNo{get;set;}
        public g_Req__c rq{get;set;}
        public DocumentInfo doc{get;set;}
    }
    public class DocumentInfo {
        public string attid{get;set;}
        public string recid{get;set;}
        public string fileName{get;set;}
        public string fileType{get;set;}
        //public string fileBody{get;set;}

    }

}