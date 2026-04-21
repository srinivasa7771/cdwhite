global class InsdocUploadBatch implements Database.Batchable < sObject > , Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string type = 'Insurance';
        String query = 'Select Id, err_cd__c, pmid__c, intsts__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.RQ__r.Con__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c from ws_call__c where mtd_nm__c = \'uploadDoc\' AND intsts__c != \'Success\' ';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List < ws_call__c > scope) {
        system.debug('Inside batch');
        List < ws_call__c > updateWs = new List < ws_call__c > ();
        List < ws_call__c > newWsLst = new List < ws_call__c > ();
        List < contact > updatecnts = new List < contact > ();
        List < g_reqitem__c > rgItm = new List < g_reqitem__c > ();
        List < contact > cnLst = new List < contact > ();
        map < Id, String > mapWsCall = new map < Id, String > ();
        for (ws_call__c ws: scope) {
            system.debug('Inside loop1');
            Integer z = Integer.valueOf(Math.floor(Math.random() * (6) + 1));
            System.debug('zzzzzzzzzzz : ' + z);
            Map < String, String > En_D = gctlInsHelper.getSnV(z);
            System.debug('<En_D> : ' + En_D);
            String strSALT = En_D.get('reqSALT');String strIV = En_D.get('reqIV');
            Map < String, String > mapCAlPrm = new Map < String, String > (); Map < String, String > reqCreatMap = new Map < String, String > ();
            reqCreatMap = gctlInsHelper.crtReq('uploadDoc', strSALT, strIV, gctlInsHelper.encryptStr(ws.rq_jsn__c, z), 'POST');
            mapCAlPrm = gctlInsHelper.uploadDoc(reqCreatMap);
            System.debug('<mapCAlPrm> ' + mapCAlPrm);
            reqCreatMap.clear();
              if (!Test.isRunningTest()) {
            String decryptResponse = gctlInsHelper.decryptStr(mapCAlPrm.get('respBody'), z);
            System.debug('<calprem> decryptResponse: ' + decryptResponse);
            gctlInsHelper.Insurance dptData = (gctlInsHelper.Insurance) JSON.deserialize(decryptResponse, gctlInsHelper.Insurance.class);
            System.debug('decncryptParse : ' + dptData);
            List < gctlInsHelper.ErrorInfo > errMsg = dptData.ErrorInfo;
            ws.err_msg__c = String.ValueOf(errMsg);
            if (errMsg.size() == 0) {
                ws.res_jsn__c = String.ValueOf(dptData);
                ws.intsts__c = 'Success';
            }
            else {
                ws.intsts__c = 'Failed';
            }
            updateWs.add(ws);
              } }
        try {
            if (Schema.sObjectType.ws_call__c.isUpdateable()) { if (updateWs.size() > 0) { update updateWs;} }
        } catch (Exception ex) { System.debug('#Exception : ' + ex.getMessage() + ' ' + ex.getLineNumber()); }
    }
    global void finish(Database.BatchableContext BC) {}
}