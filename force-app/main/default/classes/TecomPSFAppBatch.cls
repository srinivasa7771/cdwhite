global class  TecomPSFAppBatch implements Database.Batchable < sObject > , Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        string type = 'TECOMCALL';
        String query = 'Select Id, err_cd__c, xrno__c, pmid__c, xwsc__c, intsts__c, rq_itm__r.itm__r.rv__c, rq_itm__r.itm__r.dcca_refId__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Name, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.itm__r.dcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.xdmpn__c from ws_call__c where ws_typ__c = :type  AND intsts__c =\'Ready for Integration\' ';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <ws_call__c> scope) {
        List<ws_call__c> updList = new List<ws_call__c>();
        for (ws_call__c ws: scope) {
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept', 'application/json');
            request.setEndpoint('callout:tecom_Courier/apexrest/PSFRequest');
            request.setTimeout(120000);
            request.setMethod('POST');
            request.setBody(ws.rq_jsn__c);
            try {
                response = h.send(request);
                system.debug('response'+response.getBody());
                if (response.getStatusCode() == 200) {
                     grqWsPSFApproval.psfReq psfResponse = (grqWsPSFApproval.psfReq) JSON.deserialize( response.getBody(), grqWsPSFApproval.psfReq.class);
                    system.debug('psfResponse'+psfResponse);
                    if (psfResponse != null && psfResponse.errorcode == '0') {
                        ws.intsts__c = 'Success';
                        ws.res_jsn__c = response.getBody() ;
                    }else{
                        ws.intsts__c = 'Failed';  ws.err_msg__c = psfResponse.errormsg; ws.res_jsn__c = response.getBody() ;
                    }

                   }else{
                    ws.intsts__c = 'Failed';
                    ws.res_jsn__c = response.getBody() ;
                   } }catch (System.CalloutException e) {ws.res_jsn__c= String.ValueOF(e); ws.intsts__c = 'Failed'; }
            updList.add(ws);
        }
        if (Schema.sObjectType.g_req__c.isUpdateable()) { if (updList != null && updList.size()>0) { update updList; } }
    }

    global void finish(Database.BatchableContext BC) {}

}