global class tecomBatch_CourStaUpdt implements Database.Batchable<sObject>, Database.AllowsCallouts{

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id, err_cd__c, pmid__c, xwsc__c, intsts__c, rq_itm__r.itm__r.dcca_refId__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.xdcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.rtacn__c, rq_itm__r.RQ__r.Acc__r.Prk__c from ws_call__c where ws_typ__c = \'Courier Service\' AND mtd_nm__c = \'updateCourSta\' AND intsts__c =\'Ready for Integration\' ORDER BY createdDate';
           System.debug('<tecomBatch_CourStaUpdt::start>');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <ws_call__c> scope) {
        List<ws_call__c> wsList = new List<ws_call__c>();
        List<Id> regList = new List<Id>();

        for (ws_call__c ws: scope) { regList.add(ws.rq_itm__r.RQ__r.Id);}
        System.debug('<tecomBatch_CourStaUpdt::execute>');

        for (ws_call__c ws: scope) {
            if (ws.intsts__c == 'Ready for Integration' ) {
                System.debug('ws.rq_itm__r.RQ__r.Id');

                //grqWsDcca.serviceRequest reqjsRq =  (grqWsDcca.serviceRequest)JSON.deserialize(ws.rq_jsn__c, grqWsDcca.serviceRequest.class);
                //String jsonBody = JSON.serialize(reqjsRq);

                Http h = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Content-Type', 'application/json');
                //request.setHeader('accept', 'application/json');
                String ccrmPrk = Label.CCRMPrk;
                if (String.isNotBlank(ccrmPrk) && ccrmPrk.contains(ws.rq_itm__r.RQ__r.Acc__r.Prk__c)) { /* ws.rq_itm__r.RQ__r.rtacn__c=='CORPCRM'*/
                   request.setEndpoint('callout:CorpCRM/apexrest/csrupdate/'); //services/data/v32.0
                }else{
                    request.setEndpoint('callout:tecom_Courier/apexrest/csrupdate/'); //services/data/v32.0
                }
                request.setTimeout(90000);
                request.setMethod('POST');
                request.setBody(ws.rq_jsn__c);

                try{
                    response = h.send(request);
                    System.debug('tecomBatch_CourStaUpdt <response.getStatusCode> : ' + response.getStatusCode());
                    if (response.getStatusCode() == 200) {
                        system.debug('response'+response.getBody());
                        ws.res_jsn__c=response.getBody();
                        courierIntg.courierResp resSrRq = (courierIntg.courierResp)JSON.deserialize(response.getBody(), courierIntg.courierResp.class);
                        System.debug('Response success' +resSrRq.respCode);
                        if (resSrRq.respCode == '0') {ws.intsts__c = 'Success';ws.err_msg__c = '';
                                                   }else{
                                                       ws.intsts__c = 'Failed';ws.err_msg__c = resSrRq.respMsg;
                                                   }
                    }else{ws.intsts__c = 'Failed';ws.err_msg__c = response.getBody() ;}
                }catch (System.CalloutException e) {System.debug('#Callout Error: ' + e.getMessage()); ws.res_jsn__c= e.getMessage();ws.intsts__c = 'Failed';
                }catch (Exception ex) {System.debug('#EXCEPTION: ' + ex.getMessage() + ' ##StackTrace: ' + ex.getStackTraceString()); ws.res_jsn__c= ex.getMessage();ws.intsts__c = 'Failed';
                }

                wsList.add(ws);
            }
        }

        Update wsList;
    }

    global void finish(Database.BatchableContext BC) {}
    global class deserializeResponse {public String id, access_token;}
}