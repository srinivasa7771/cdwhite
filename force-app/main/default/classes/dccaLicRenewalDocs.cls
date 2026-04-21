global class dccaLicRenewalDocs implements Database.Batchable < sObject > , Database.AllowsCallouts {
global Database.QueryLocator start(Database.BatchableContext BC) {
        string type = 'DCCA License Renewals'; //AND mtd_nm__c = \'dccaServiceRq\'
             String query = 'Select Id, err_cd__c, pmid__c, xwsc__c, intsts__c, rq_itm__r.STA__r.exsyst__c, rq_itm__r.itm__r.rv__c, rq_itm__r.itm__r.dcca_refId__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Name, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.RQ__r.Acc__r.id, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.itm__r.dcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.xdei__c, rq_itm__r.RQ__r.xdmpn__c, rq_itm__r.RQ__r.xmloc__c from ws_call__c where ws_typ__c = :type  AND intsts__c =\'Ready for Integration\' AND (mtd_nm__c = \'LicenseRenewalCopy\' OR mtd_nm__c = \'LicenseRenewalDoc\')';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <ws_call__c> scope) {
        List<ws_call__c> wsList = new List<ws_call__c>();
        List < Id > rqId = new List < Id > ();
         List < Id > rqId2 = new List < Id > ();
        List<g_Req__c> rqList = new List<g_Req__c>();
         grqWsDccaGetService.AttachList mainattlist = new grqWsDccaGetService.AttachList();
                 list<grqWsDccaGetService.Attachments> grattList= new list<grqWsDccaGetService.Attachments>();
        String newjson;
        Map<String, attachment> rqAttchment = new  Map<String, attachment> ();
        Map<String, List<attachment>> rqListAttchment = new  Map<String, List<attachment>> ();
        Map<Id, attachment> rqDocAttchment = new  Map<Id, attachment> ();
        Map<Id, List<attachment>> rqDocListAttchment = new  Map<Id, List<attachment>> ();
        String jsonBody ;
         Set<g_Req__c> updrqList = new Set<g_Req__c>();

         for (ws_call__c ws: scope) {
             rqId.add(ws.rq_itm__r.RQ__r.Id); //&& ws.rq_itm__r.RQ__r.xmloc__c == false
             if (ws.mtd_nm__c == 'LicenseRenewalDoc'  ) {
          rqId2.add(ws.rq_itm__r.RQ__r.Id);
             }
            /**  if (ws.mtd_nm__c == 'LicenseRenewalCopy'  ) {

              }**/
         }

        if (rqId2 != null && rqId2.size()>0) {
           List<g_reqDoc__c> redDocList  = [Select Id, Name, RQ__c from g_reqDoc__c where RQ__c in:rqId2 ];

            List<attachment> attList = [Select Id, Name, Body, parentId From attachment where parentId in:redDocList  ]; //order by CreatedDate desc limit 1
            for (attachment att :attList) {
                if (rqDocListAttchment.containsKey(att.parentId)) {
                    List<attachment> attmtList = new  List<attachment>();
                    attmtList = rqDocListAttchment.get(att.parentId);
                    attmtList.add(att);
                    rqDocListAttchment.put(att.parentId, attmtList);
                }else{
                    rqDocListAttchment.put(att.parentId, new List<attachment> {att});
                }
              // rqDocAttchment.put(att.parentId, att);
            }
            system.debug('rqDocListAttchment'+rqDocListAttchment);

            for (g_reqDoc__c rqDc:redDocList) {
               // If(rqDocAttchment.containsKey(rqDc.Id)) {
                     If(rqDocListAttchment.containsKey(rqDc.Id)) {
                 /**  attachment att = new attachment();
                    att = rqDocAttchment.get(rqDc.Id);**/
                    List<attachment> attLstNew = new List<attachment>();
                    if (rqDocListAttchment.containsKey(rqDc.Id)) attLstNew = rqDocListAttchment.get(rqDc.Id);
                    rqListAttchment.put(String.ValueOf(rqDc.RQ__c+'_'+rqDc.Name), attLstNew);
                  //  rqAttchment.put(String.ValueOf(rqDc.RQ__c+'_'+rqDc.Name), att);
                }

            }

        }
        system.debug('rqListAttchment'+rqListAttchment);

          map<ID , List<attachment>> docListMap = new map<Id , List<attachment>>();

         List<g_Req__c>  reqDocList = new List<g_Req__c>();
            List<attachment> attList = [Select Id, Name, Body, parentId From attachment where parentId in:rqId ORDER BY CreatedDate DESC limit 1 ];

            for (attachment att :attList) {
                List<attachment> attList1 = new  List<attachment>();
                attList1.add(att);
                docListMap.put(att.parentId, attList1);
            }

        for (ws_call__c ws: scope) {

        grqWsDccaGetServiceBatch.AttachList reqjsRq =  (grqWsDccaGetServiceBatch.AttachList) JSON.deserialize(ws.rq_jsn__c, grqWsDccaGetServiceBatch.AttachList.class);

            //system.debug('Doc'+docListMap.get(ws.rq_itm__r.RQ__r.Id)[0].Body);
            if (ws.mtd_nm__c == 'LicenseRenewalDoc') {
                String attStr= ws.rq_itm__r.RQ__r.Id+'_'+ reqjsRq.AttachmentList[0].Name;
              /**  If(rqAttchment.containsKey(attStr)) {
                reqjsRq.AttachmentList[0].attachmentBody =EncodingUtil.base64Encode(rqAttchment.get(attStr).Body);
                    reqjsRq.AttachmentList[0].Name =rqAttchment.get(attStr).Name;}**/

                If(rqListAttchment.containsKey(attStr)) {
                    List<attachment> listattNew= new List<attachment>();
                    listattNew = rqListAttchment.get(attStr);
                    integer i =0;
                    for (attachment att : listattNew) {
                       grqWsDccaGetService.Attachments attIn= new grqWsDccaGetService.Attachments();
                        attIn.parentId = reqjsRq.AttachmentList[0].parentId;
                        attIn.Name = att.Name;
                         attIn.attachmentBody = EncodingUtil.base64Encode(att.Body);
                        grattList.add(attIn);
                         system.debug('grattList'+grattList);
                       // reqjsRq.AttachmentList[i].attachmentBody =EncodingUtil.base64Encode(att.Body);
                       // i++;
                    }
                    mainattlist.AttachmentList = grattList;
                      newjson = JSON.serialize(mainattlist);
                }
                system.debug('newjson'+newjson);
            }else{
         If(docListMap.containsKey(ws.rq_itm__r.RQ__r.Id))
         reqjsRq.AttachmentList[0].attachmentBody = EncodingUtil.base64Encode(docListMap.get(ws.rq_itm__r.RQ__r.Id)[0].Body);

            }
        jsonBody = JSON.serialize(reqjsRq);

            Http h = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('accept', 'application/json');
                request.setEndpoint('callout:DCCA_Auth/apexrest/createAttachment');
                request.setTimeout(120000);

                request.setMethod('POST');
                if (newjson == null) {
                request.setBody(jsonBody);
                }else{
                    request.setBody(newjson);
                }

                     try {

                    response = h.send(request);
                   ws.res_jsn__c=response.getBody();
                            if (response.getStatusCode() == 200) {
                        system.debug('Sucess');
                        system.debug('response'+response.getBody());
                        ws.res_jsn__c=response.getBody();
                        System.debug('response.getBody();' +response.getBody());
                         grqWsDccaGetServiceBatch.AttachList resJs =  (grqWsDccaGetServiceBatch.AttachList) JSON.deserialize(response.getBody(), grqWsDccaGetServiceBatch.AttachList.class);

                     if (resJs != null && resJs.AttachmentList[0].messagecode =='0' ) {
                             ws.intsts__c = 'Success';
                         if ( ws.mtd_nm__c == 'LicenseRenewalCopy') {
                              g_Req__c rqnxt = new g_Req__c();
                             rqnxt.id = ws.rq_itm__r.RQ__r.Id;
                             rqnxt.xlicd__c = true;
                             system.debug('rqnxt'+rqnxt);
                              updrqList.add(rqnxt);
                         }
                 }else{
                             ws.intsts__c = 'Failed';
                             ws.err_msg__c = resJs.AttachmentList[0].message;
                        }

                    }else {ws.intsts__c = 'Failed';ws.err_msg__c = response.getBody() ;}

                }catch (System.CalloutException e) {ws.res_jsn__c= String.ValueOF(e); ws.intsts__c = 'Failed'; }
                wsList.add(ws);
            }
                    if (updrqList != null && updrqList.size()>0) {
                     List<g_Req__c>  lst= new List<g_Req__c>();
                     lst.addAll(updrqList);
                     if (Schema.sObjectType.g_Req__c.isUpdateable()) {
                         update lst;
                     }
                 }
                        if (wsList != null && wsList.size()>0) {Update wsList; }
                }

    global void finish(Database.BatchableContext BC) {}

}