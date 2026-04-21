public class grqWsDcca {

    public class  IdentityInfo{
        public string licNo ;
        public string error ;
        public List<shareHolder> shholder;
    }

    public class shareHolder{
        public string name ;
        public string  arbnm;
        public String pos;
    }

    public class serviceRequest {
        public List<serviceReq> serviceRequest;
    }

    public class serviceReq {
        public String service;
        public String licenseNo;
        public Boolean isPaid;
        public String refAXS;
        public String extAXS;
        public Boolean isSucces;
        public String errorMessage;
        public String locAdd;
        public String attach;
        public boolean attaFlag;
        public String attName;
        public String status;
        public String nameOD;
        public String serNm;
        public String servPdNm;
        public Date permSd;
        public Date permEd;
        public String dccapermtNo;
        public String cFRReason;
        public String cFRNotes;
        public string nocType;
        public AuditInfo auditedData;
        public mdWrapper.IdentityInfo memInfo;
    }
    public class AuditInfo{
        public String revenues {set;get;}
        public String costofsales {set;get;}
        public String grossprofit {set;get;}
        public String operatingcost {set;get;}
        public String operatingprofit {set;get;}
        public String interestexpenses {set;get;}
        public String depreciation {set;get;}
        public String amortization {set;get;}
        public String otherincomeorloss {set;get;}
        public String netprofit {set;get;}
        public String currentassets {set;get;}
        public String fixedassets {set;get;}
        public String investments {set;get;}
        public String otherassets {set;get;}
        public String currentliabilities {set;get;}
        public String longtermliabilities {set;get;}
        public String sharecapital {set;get;}
        public String retainedearnings {set;get;}
        public String reservesandsurplus {set;get;}
        public string auditfirm {set;get;}
        public date yearstartdate {set;get;}
        public date yearenddate {set;get;}
        public String assest {set;get;}
        public String totalasset {set;get;}
        public String totalequity {set;get;}
        public String totalLiabilities {set;get;}
        //new fields
        public String reasonNewSubmissionDate{set;get;}
        public String reasonNonSubmission {set;get;}
        public String newSubmissionDate {set;get;}
        public String financialYear {set;get;}
        public String ddaId {set;get;}
        public String selectedCurrency {set;get;}
        public String workerCompensation {set;get;}
         public String feesAndTaxes {set;get;}
    }

    public static void createLetter(List < g_reqitem__c > rqItSet, map < Id, g_Req__c > reqMap, String wsTyp, Map<Id, String> wsMd) {
        List < ws_call__c > wsList = new List < ws_call__c > ();

        for (g_reqitem__c ri: rqItSet) {
              String methdname = wsMd.get(ri.id);
            g_Req__c rq = reqMap.get(ri.Id);
            String jsonBody ;
            if (!methdname.contains('getArabicData') ) {

            serviceReq servReq = new serviceReq();
            List<serviceReq> serviceReqList = new List<serviceReq>();
            serviceRequest sr = new serviceRequest();
           //servReq.service =ri.xdcca_refId__c;
            servReq.licenseNo = rq.Acc__r.lc__c;
            servReq.isPaid = true;
            servReq.refAXS =rq.Name;
            servReq.extAXS =rq.id;
            servReq.serNm = ri.Name;
            servReq.nocType =!string.isblank(rq.xnt__c)?rq.xnt__c:'';
                if (rq.xtcdl__c != null) {
                    servReq.nameOD='';
                    List<String> lstStr = rq.xtcdl__c.split(';'); for (String s:lstStr) {if (!s.contains(':')) {s += ':1';} if (!s.contains('Embassy of')) {servReq.nameOD += s+';';}}
                    //servReq.nameOD= rq.xtcdl__c;
                }
    if (rq.xloc__c != null) {
                    servReq.locAdd= rq.xloc__c;
                }

                if (rq.xccn__c != null) { servReq.servPdNm= rq.xccn__c; }

                if (rq.xcpid__c != null) {servReq.permSd= rq.xcpid__c;}

                if (rq.xcped__c != null) { servReq.permEd= rq.xcped__c;}

                If(methdname.contains('dccaApproval') || methdname.contains('uploadDoc')) {
                    servReq.status= 'Forwarded to Back Office';
                    if (ri.Name=='True Copy Attestation') {servReq.status= 'Closed';}
                }  else if (methdname.contains('arabicDataMissing')) {
                    servReq.status= 'Forwarded to Back Office';
                    servReq.cFRReason='Missing/Incorrect information';
                    servReq.cFRNotes='Missing Arabic Data';
                }else{
                    servReq.status= 'Closed';
                    if (servReq.attName == null) {
                        servReq.attName= rq.xltr__c + '.pdf';
                    }
                }

                serviceReqList.add(servReq);
                sr.serviceRequest= serviceReqList;

                jsonBody = JSON.serialize(sr);
            }
            ws_call__c ws = new ws_call__c();
            ws.rq_jsn__c = jsonBody;
            ws.ws_typ__c = wsTyp;
            ws.mtd_nm__c = wsMd.get(ri.id);
            ws.intsts__c = 'Ready for Integration';
            ws.uid__c = rq.id + '' + ri.Id + '' + ri.sta__c + system.today() +wsMd.get(ri.id) ;
            ws.rq_itm__c = ri.id;
            wsList.add(ws);

        }

        try {
            Insert wsList;
        } catch (Exception e) {}

    }

}