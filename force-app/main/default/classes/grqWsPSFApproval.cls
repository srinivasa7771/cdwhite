public class grqWsPSFApproval {
 public class psfReq {
        public String ReqNo;
        public String AgNumber;
        public String Attachment1Link;
        public String Attachment2Link;
         public String errormsg;
        public String errorcode;

 }

    public static void createPSFAppCall( List < g_reqitem__c > rqItSet, map < Id, g_Req__c > reqMap, String wsTyp, String wsMd) {
        system.debug('Inside createPSFAppCall');
          List<g_reqitem__c> reqItmList = new List<g_reqitem__c>();
      List < ws_call__c > wsList = new List < ws_call__c > ();
        Map<Id, Id> reqItmMap= new  Map<Id, Id> ();
        List<Id> rqId= new List<Id>();

      // reqItmList =[Select Id, RQ__r.id from g_reqitem__c where itm__r.cd__c ='psf' and RQ__r.id in: rqId];
         //
       // for (g_reqitem__c ri :reqItmList) {
          //  reqItmMap.put(ri.RQ__r.id, ri.id);
        //}

        for (g_reqitem__c key:rqItSet) {
            g_Req__c  rq = new g_Req__c();
            rq = reqMap.get(key.id);
            String AgNo;
            String URL1;
            String URL2;
             List<attachment> attList = new  List<attachment> ();
            List<g_Req__c>  allreqList = new List<g_Req__c>();
            for (g_reqitem__c ri: rqItSet) {
                g_Req__c rq2 = reqMap.get(ri.Id);
                allreqList.add(rq2);
             }

      List<g_reqDoc__c> redDocList  = [Select Id, Name, RQ__c from g_reqDoc__c where RQ__c in:allreqList ];
            if (redDocList != null && redDocList.size()>0) {
                attList = [Select Id, Name, Body, parentId From attachment where parentId in:redDocList]; }
            if (attList != null && attList.size()>0) {
                URL1  = String.ValueOf(System.URL.getSalesforceBaseURL().toExternalForm());
                 URL2 = String.ValueOf(System.URL.getSalesforceBaseURL().toExternalForm());
                if (attList.size()>0 && attList[0]!=null) {URL1=URL1 +'/servlet/servlet.FileDownload?file='+attList[0].id;}
                if (attList.size()>1 && attList[1]!=null) {URL2=URL2 +'/servlet/servlet.FileDownload?file='+attList[1].id;}
            }

            if (rq.xadtx3__c != null) {
         grqWsDccaGetService.ResponseData newResp = (grqWsDccaGetService.ResponseData) JSON.deserialize(String.ValueOf(rq.xadtx3__c), grqWsDccaGetService.ResponseData.class);
        List < grqWsDccaGetService.Records > getRecList = new List < grqWsDccaGetService.Records > ();
        if (newResp != null && newResp.Records != null) getRecList = newResp.Records;

        for (grqWsDccaGetService.Records getRec: getRecList) {
            if (getRec.Invoices != null) {
                AgNo=getRec.AgNo;
            }
        }
            }
            string jsonBody;
            psfReq psf= new psfReq();
            psf.ReqNo = rq.Name ;
           psf.AgNumber= AgNo ;
            psf.Attachment1Link= URL1 ;
            psf.Attachment2Link= URL2 ;
            jsonBody = JSON.serialize(psf);

            ws_call__c ws = new ws_call__c();
            ws.rq_jsn__c = jsonBody;
            ws.ws_typ__c = 'TECOMCALL';
            ws.mtd_nm__c ='PSFApp';
            ws.intsts__c = 'Ready for Integration';
            ws.uid__c = rq.id + '' +system.now() +'PSFApp'+ key.id ;
            ws.rq_itm__c =key.id;
            wsList.add(ws);
         }

         Insert wsList;

    }

}