global class dccaServiceRqBatch implements Database.Batchable < sObject > , Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        string type = 'DCCA Letters'; //AND mtd_nm__c = \'dccaServiceRq\'
        String query = 'Select Id, err_cd__c, pmid__c, xwsc__c, intsts__c, rq_itm__r.itm__r.rv__c, rq_itm__r.itm__r.dcca_refId__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Name, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.itm__r.dcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.xdmpn__c from ws_call__c where ws_typ__c = :type  AND intsts__c =\'Ready for Integration\' ';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <ws_call__c> scope) {
        List<ws_call__c> wsList = new List<ws_call__c>();
        List < Id > rgItmId = new List < Id > ();
        List<g_Req__c> rqList = new List<g_Req__c>();
        map < Id, String > mbrIdMap = new map < Id, String > ();
        map < Id, String > rqItmDocReq = new map < Id, String > ();
        map < Id, String > rqIdMap = new map < Id, String > ();
        boolean sucflag ;

        List<Id> regList = new List<Id>();
        map<Id, Attachment> regMap = new map<Id, Attachment>();

        for (ws_call__c ws: scope) {
            regList.add(ws.rq_itm__r.RQ__r.Id);
        }

        List < Attachment > attList = [Select Id, Body, Description, Name, ParentId from Attachment where ParentId in:regList ];

        for (Attachment a: attList) {
            regMap.put(a.ParentId, a);
        }

        for (ws_call__c ws: scope) {

            if (ws.intsts__c == 'Ready for Integration' ) {

                grqWsDcca.serviceRequest reqjsRq =  (grqWsDcca.serviceRequest) JSON.deserialize(ws.rq_jsn__c, grqWsDcca.serviceRequest.class);

                if (regMap.get(ws.rq_itm__r.RQ__r.Id) != null && (ws.mtd_nm__c != 'dccaApproval' && ws.mtd_nm__c != 'uploadDoc')) {
                    reqjsRq.serviceRequest[0].attach = EncodingUtil.base64Encode(regMap.get(ws.rq_itm__r.RQ__r.Id).Body);
                }
                system.debug('JJ reqjsRq'+reqjsRq);
                system.debug('JJ 123'+ws.rq_itm__r.RQ__r.Acc__r.lc__c);
                if (reqjsRq.serviceRequest[0].licenseNo == null) {reqjsRq.serviceRequest[0].licenseNo = ws.rq_itm__r.RQ__r.Acc__r.lc__c;}
                if (reqjsRq.serviceRequest[0].refAXS == null) {reqjsRq.serviceRequest[0].refAXS = ws.rq_itm__r.RQ__r.Name;}
                if (reqjsRq.serviceRequest[0].extAXS == null) {reqjsRq.serviceRequest[0].extAXS = ws.rq_itm__r.RQ__r.Id;}

                reqjsRq.serviceRequest[0].service=ws.rq_itm__r.itm__r.dcca_refId__c;
                String jsonBody = JSON.serialize(reqjsRq);

                if (ws.mtd_nm__c == 'dccaApproval') {
                    mbrIdMap.put(ws.rq_itm__r.Id, ws.rq_itm__r.RQ__c);
                    rgItmId.add(ws.rq_itm__r.Id);
                    rqItmDocReq.put(ws.rq_itm__r.Id, ws.rq_itm__r.itm__r.dcr__c);
                    rqIdMap.put(ws.rq_itm__r.Id, ws.rq_itm__r.RQ__r.Id);
                    system.debug('rqItmDocReq'+rqItmDocReq);
                }

                Http h = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('accept', 'application/json');
                request.setEndpoint('callout:DCCA_Auth/apexrest/createServiceRequest/'); //services/data/v39.0
                request.setTimeout(120000);

                request.setMethod('POST');
                //request.setBody('{"serviceRequest":[{"service":"a150k000000BreMAAS", "refAXS":"43056120180327", "licenseNo":"17351", "isSucess":null, "isPaid":true, "extAXS":"a0EN000000FAvbMMAT"}]}');
                request.setBody(jsonBody);//jsonBody
                try {

                    response = h.send(request);
                    if (response.getStatusCode() == 200) {
                        system.debug('Sucess');
                        sucflag=true;
                        system.debug('response'+response.getBody());
                        ws.res_jsn__c=response.getBody();
                        grqWsDcca.serviceRequest resSrRq =  (grqWsDcca.serviceRequest) JSON.deserialize(response.getBody(), grqWsDcca.serviceRequest.class);
                        System.debug('Response sucess' +resSrRq.serviceRequest[0]);
                        if (resSrRq.serviceRequest[0].isSucces == true ) {
                            System.debug('Inside sucess' +resSrRq.serviceRequest[0].isSucces);
                            ws.intsts__c = 'Success';
                            if (resSrRq.serviceRequest[0].dccapermtNo != null) {
                                g_Req__c rq = new g_Req__c();  rq.id = ws.rq_itm__r.RQ__r.Id; rq.xdmpn__c = resSrRq.serviceRequest[0].dccapermtNo;rqList.add(rq);
                            }
                        }else {
                            System.debug('Inside failed' +resSrRq.serviceRequest[0].isSucces);
                            ws.intsts__c = 'Failed';ws.err_msg__c = resSrRq.serviceRequest[0].errorMessage;
                        }
                    }else { ws.intsts__c = 'Failed';ws.err_msg__c = response.getBody() ;  }
                }catch (System.CalloutException e) {

                    System.debug('Callout error: ' + e);
                    ws.res_jsn__c= String.ValueOF(e);
                    ws.intsts__c = 'Failed';
                    sucflag=false;
                }

                //  }
                wsList.add(ws);
            }

        }

        Update wsList; system.debug('Before Calling Upload'+rqItmDocReq);
        if (rqList != null && rqList.size()>0) {Update rqList;}
        if (wsList != null && rqItmDocReq != null) {
            if (wsList.size()>0 && rqItmDocReq.size()>0 && sucflag == true ) {   grqWsDocInsH.uploadLetterDoc(rgItmId, mbrIdMap, rqItmDocReq, rqIdMap, 'DCCA Letters', 'uploadDoc'); } }
    }

    global void finish(Database.BatchableContext BC) {}
    global class deserializeResponse
    {
        public String id;
        public String access_token;
    }
}