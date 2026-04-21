global class InsEidaUpdateBatch implements Database.Batchable < sObject > , Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string type = 'Insurance';
        String query = 'Select Id, err_cd__c, err_msg__c, intsts__c, mtd_nm__c, rq_itm__c, rq_itm__r.RQ__r.Con__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c from ws_call__c where ws_typ__c = :type AND mtd_nm__c = \'UpdateEIDA\' AND intsts__c=\'\' ';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List < ws_call__c > scope) {
        List < ws_call__c > updateWs = new List < ws_call__c > ();
        List < contact > updatecnts = new List < contact > ();
        List < g_reqitem__c > rgItm = new List < g_reqitem__c > ();
        List < contact > cnLst = new List < contact > ();
        for (ws_call__c ws: scope) {
            if (ws.intsts__c != 'Success') {
                Integer z = Integer.valueOf(Math.floor(Math.random() * (6) + 1));
                System.debug('zzzzzzzzzzz : ' + z);
                Map < String, String > En_D = gctlInsHelper.getSnV(z);
                System.debug('<En_D> : ' + En_D);
                String strSALT = En_D.get('reqSALT');
                String strIV = En_D.get('reqIV');
                Map < String, String > mapCAlPrm = new Map < String, String > ();
                Map < String, String > reqCreatMap = new Map < String, String > ();
                reqCreatMap = gctlInsHelper.crtReq('UpdateEIDA', strSALT, strIV, gctlInsHelper.encryptStr(ws.rq_jsn__c, z), 'POST');
                mapCAlPrm = gctlInsHelper.eidaUpdate(reqCreatMap);
                System.debug('<mapCAlPrm> ' + mapCAlPrm);
                reqCreatMap.clear();
                if (!Test.isRunningTest()) {
                String decryptResponse = gctlInsHelper.decryptStr(mapCAlPrm.get('respBody'), z);
                System.debug('<calprem> decryptResponse: ' + decryptResponse);
                gctlInsHelper.Insurance dptData = (gctlInsHelper.Insurance) JSON.deserialize(decryptResponse, gctlInsHelper.Insurance.class);
                System.debug('decncryptParse : ' + dptData);
                List < gctlInsHelper.ErrorInfo > errMsg = dptData.ErrorInfo; ws.err_msg__c = String.ValueOf(errMsg);
                if (errMsg.size() == 0) {
                    ws.res_jsn__c = String.ValueOf(dptData);
                    ws.is_pro__c = true; ws.intsts__c = 'Success';
                    contact c = new contact();c.id = ws.rq_itm__r.RQ__r.Con__c;c.eup__c = true;
                    updatecnts.add(c);
                } else {ws.intsts__c = 'Failed';}
                updateWs.add(ws);
                }
            }
        }
        try {
            if (Schema.sObjectType.ws_call__c.isUpdateable()) { if (updateWs.size() > 0) {update updateWs; } }
            if (Schema.sObjectType.contact.isUpdateable()) { if (updatecnts.size() > 0) { update updatecnts; } }
        } catch (Exception ex) {System.debug('#Exception : ' + ex.getMessage() + ' ' + ex.getLineNumber()); }
    }
    global void finish(Database.BatchableContext BC) {}
}