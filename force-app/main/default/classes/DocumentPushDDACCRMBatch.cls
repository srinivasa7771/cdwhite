global class DocumentPushDDACCRMBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(Label.DocumentPushSOQL);
    }

    global void execute(Database.BatchableContext bc, List<ws_call__c> wsCallRecords) {
        set<id> wscallsIds = new set<id>();
        for (ws_call__c objWs:wsCallRecords) {
            wscallsIds.add(objWs.id);
        }
        System.debug('wsCallRecords :'+wsCallRecords.size());
        List<ws_call__c> wsList=new List<ws_call__c>();
        if (wscallsIds != null && wscallsIds.size()>0 ) {
            wsList=[select id, rq_jsn__c, res_jsn__c, adhoc_text1__c, mtd_nm__c, ismp__c, ws_typ__c,
                pmid__c, rq_itm__c, intsts__c, rq_itm__r.rq__r.createddate from ws_call__c where id in:wscallsIds order by rq_itm__r.rq__r.createddate desc];
        }
        //Organization axs_Org = [Select Id, Name, IsSandbox from Organization];
        //String namedCreds = axs_Org.IsSandbox ? 'callout:OIC_Integration_UAT' : 'callout:OIC_Integration_PROD';

        String reqBody='[';
        Http httpIns = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('Callout:OIC_Integration_PROD/AXS_DDA_OR_CCRM_UPLOA_ATTAC/1.0/uploadattachments');
        request.setTimeout(120000);
        request.setMethod('POST');
        List <ws_call__c> wsRecordToUpdate = new List <ws_call__c> ();
        for (ws_call__c ws: wsList) {
            if (reqBody.length() ==1) {
                reqBody += '{"id":"'+ws.Id+'"}';
            }
            else{
                reqBody += ', {"id":"'+ws.Id+'"}';
            }
        }
        try {
            reqBody +=']';
            System.debug('reqBody :'+reqBody);
            request.setBody(reqBody);
            System.debug('## processOICDocUpload response  ##:'+request.getBody());
            response = httpIns.send(request);
            System.debug('## processOICDocUpload response  ##:'+response);
            if (response.getStatusCode() != 200 && response.getStatusCode() != 202) {
                for (ws_call__c ws: wsList) {
                    ws.res_jsn__c = response.getBody();
                    ws.intsts__c = 'Failed';
                    wsRecordToUpdate.add(ws);
                }
            }
        } catch (System.CalloutException e) {
            System.debug('Callout error: ' + e);
            for (ws_call__c ws: wsList) {
                ws.res_jsn__c = String.ValueOF(e);
                ws.intsts__c = 'Failed';
                wsRecordToUpdate.add(ws);
            }
        }
        if (wsRecordToUpdate.size() > 0) {
            if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                update wsRecordToUpdate;
            }
        }

    }

    global void finish(Database.BatchableContext bc) {

    }

}