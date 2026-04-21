global class InsuranceBatch implements Database.Batchable < sObject > , Database.AllowsCallouts {
    global string type = 'Insurance';
    global String query;
    global InsuranceBatch() {
     query = 'Select Id, Number_Of_Attempts__c, err_cd__c, pmid__c, xwsc__c, intsts__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.xdcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.Con__r.xpno__c, rq_itm__r.RQ__r.Con__r.xped__c, rq_itm__r.RQ__r.xceidid__c, rq_itm__r.RQ__c from ws_call__c where ws_typ__c = :type AND mtd_nm__c = \'generatePolicy\' AND intsts__c =\'Ready for Integration\' AND rq_itm__r.AP__c>0 AND rq_itm__r.AD__c=0';
    }
    global InsuranceBatch(string wsID) {
     query = 'Select Id, Number_Of_Attempts__c, err_cd__c, pmid__c, xwsc__c, intsts__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.xdcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.Con__r.xpno__c, rq_itm__r.RQ__r.Con__r.xped__c, rq_itm__r.RQ__r.xceidid__c, rq_itm__r.RQ__c from ws_call__c where ws_typ__c = :type AND mtd_nm__c = \'generatePolicy\' AND intsts__c =\'Ready for Integration\' AND rq_itm__r.AP__c>0 AND rq_itm__r.AD__c=0 AND id=\'' +
         wsID + '\'';
    }

 global Database.QueryLocator start(Database.BatchableContext BC) {
   system.debug('query::' + query);
   return Database.getQueryLocator(query);
 }

    global void execute(Database.BatchableContext BC, List < ws_call__c > scope) {
        List < ws_call__c > updateWs = new List < ws_call__c > ();
        List < ws_call__c > fupdateWs = new List < ws_call__c > ();
        List < g_reqitem__c > rgItm = new List < g_reqitem__c > ();
        List < g_Req__c > rqLst = new List < g_Req__c > ();
        List<String> rqidLst = new List<String>();
        Map<String, String> eidaAppMap = new Map<String, String>();
        List < Id > rgItmId = new List < Id > ();
        List < contact > cnLst = new List < contact > ();
        map < Id, String > mbrIdMap = new map < Id, String > ();
        map < Id, String > rqIdMap = new map < Id, String > ();
        map < Id, String > rqItmDocReq = new map < Id, String > ();
        List < ws_call__c > insertDoc = new List < ws_call__c > (); /** added by SH, starts **/
        Map < String, String > mapStatusByItem = new Map < String, String > ();
        List < String > itmIDs = new List < String > ();

        for (ws_call__c ws: scope) {
            itmIDs.add(ws.rq_itm__r.itm__r.id);
            if (String.isBlank(ws.rq_itm__r.RQ__r.xceidid__c))
             rqidLst.add(ws.rq_itm__r.RQ__c);
        }
        if (rqidLst != null && !rqidLst.isEmpty()) {
            for (g_reqitem__c ri: [select id, xf__c, RQ__c from g_reqitem__c where itm__r.cd__c='ia' and RQ__c in :rqidLst and xf__c !='']) {
                eidaAppMap.put(ri.RQ__c, ri.xf__c);
            }
        }
        System.debug('<itmIDs> : ' + itmIDs);
        List < g_srvcitm_Status__c > lstSta = [select id, name, cd__c, itm__c from g_srvcitm_Status__c where itm__c =: itmIDs AND cd__c = 'nc'];
        for (g_srvcitm_Status__c stat: lstSta) {
            mapStatusByItem.put(stat.itm__c, stat.id);
        } /** added by SH, ends**/
        for (ws_call__c ws: scope) {
            /*|| ws.intsts__c == 'Failed'*/
            if (ws.intsts__c == 'Ready for Integration') {
                Integer z = Integer.valueOf(Math.floor(Math.random() * (6) + 1));
                System.debug('zzzzzzzzzzz : ' + z);
                Map < String, String > En_D = gctlInsHelper.getSnV(z);
                System.debug('<En_D> : ' + En_D);
                String strSALT = En_D.get('reqSALT');
                String strIV = En_D.get('reqIV');
                Map < String, String > mapCAlPrm = new Map < String, String > ();
                Map < String, String > reqCreatMap = new Map < String, String > ();
                gctlInsHelper.Insurance dptData = new gctlInsHelper.Insurance();
                 String wsToCall = 'PolicyGen';
                  if (Label.ADNIC_CheckForRenewal == 'Y') {
                   wsToCall = String.isNotBlank(ws.rq_itm__r.RQ__r.Con__r.xpno__c) && ws.rq_itm__r.RQ__r.Con__r.xped__c != null && (ws.rq_itm__r.RQ__r.Con__r.xped__c >= System.today()) ? 'PolicyGenRen' : 'PolicyGen';
                  }
               Date sDate = system.today();
                if (ws.rq_itm__r.RQ__r.Con__r.xped__c != null && ws.rq_itm__r.RQ__r.Con__r.xped__c >= System.today() ) {
                 sDate  = (ws.rq_itm__r.RQ__r.Con__r.xped__c).addDays(1);
                }
                String rqJsn = ws.rq_jsn__c;
                 String startDate = '"PolicyStartDate":"'+gctlInsHelper.getFDt('' + String.ValueOf(sDate), '-')+'"';
                   String endDate = '"PolicyEndDate":"'+gctlInsHelper.getFDt('' + String.ValueOf(sDate.addDays(-1).addYears(1)), '-')+'"';
                   String startSub = rqJsn.substringAfter('"PolicyStartDate":"');
                   rqJsn = rqJsn.substringBefore('"PolicyStartDate":"')+startDate+startSub.substringAfter('"');
                    String endSub = rqJsn.substringAfter('"PolicyEndDate":"');
                    rqJsn = rqJsn.substringBefore('"PolicyEndDate":"')+endDate+endSub.substringAfter('"');
                //rqJsn = rqJsn.replace('"PolicyStartDate":"', '"PolicyStartDate":"'+gctlInsHelper.getFDt('' + String.ValueOf(system.today()), '-'));
                //rqJsn = rqJsn.replace('"PolicyEndDate":"', '"PolicyEndDate":"'+gctlInsHelper.getFDt('' + String.ValueOf(System.today().addDays(-1).addYears(1)), '-'));
                if (String.isBlank(ws.rq_itm__r.RQ__r.xceidid__c) && eidaAppMap != null && eidaAppMap.containsKey(ws.rq_itm__r.RQ__c)) {

                   rqJsn = rqJsn.replace('"EmiratesIdApplicationNo":null', '"EmiratesIdApplicationNo":"'+eidaAppMap.get(ws.rq_itm__r.RQ__c)+'"');

                }else if (String.isNotBlank(ws.rq_itm__r.RQ__r.xceidid__c)) {
                   rqJsn = rqJsn.replace('"EmiratesId":null', '"EmiratesId":"'+ws.rq_itm__r.RQ__r.xceidid__c+'"');
                }
                //rqJsn = rqJsn.replaceAll('\n', ', ');
                ws.rq_jsn__c = rqJsn;
                System.debug('rqJsn::: ' + rqJsn);
                 System.debug('ws.rq_jsn__c::: ' + ws.rq_jsn__c);
               reqCreatMap = gctlInsHelper.crtReq(wsToCall, strSALT, strIV, gctlInsHelper.encryptStr(rqJsn, z), 'POST');
                mapCAlPrm = gctlInsHelper.genPolicy(reqCreatMap);
                System.debug('<mapCAlPrm> ' + mapCAlPrm);
                reqCreatMap.clear();
              if (!Test.isRunningTest()) {
                  if (ws.Number_Of_Attempts__c == null) ws.Number_Of_Attempts__c = 0;
                  String decryptResponse = gctlInsHelper.decryptStr(mapCAlPrm.get('respBody'), z);
                  System.debug('<calprem> decryptResponse: ' + decryptResponse);
                  dptData = (gctlInsHelper.Insurance) JSON.deserialize(decryptResponse, gctlInsHelper.Insurance.class);
                  System.debug('decncryptParse : ' + dptData);
                  List < gctlInsHelper.ErrorInfo > errMsg = dptData.ErrorInfo;
                  ws.err_msg__c = String.ValueOf(errMsg);
                  ws.res_jsn__c = String.ValueOf(dptData);
                  string errCode;
                  String errCodeChk = String.ValueOf(errMsg);
                  if ((errMsg.size() == 0 && !(String.ValueOf(dptData)).contains('policyDoc=null')) || errCodeChk.contains('VDB018')) {
                      /*ws.res_jsn__c = String.ValueOf(dptData);
                      */ g_reqitem__c ri = gctlInsHelper.updaterqItm(String.ValueOf(ws.rq_itm__c), ws.rq_itm__r.STA__r.Next_Status__c, dptData);
                      g_Req__c rq = null;
                      if (ws.rq_itm__r.STA__r.Next_Status__r.rqSTA__c != null && ws.rq_itm__r.STA__r.Next_Status__r.rqSTA__c != '') {
                          rq = gctlInsHelper.updaterq(String.ValueOf(ws.rq_itm__r.RQ__r.Id), ws.rq_itm__r.STA__r.Next_Status__r.rqSTA__c);
                          rqLst.add(rq);
                      }
                      contact c = gctlInsHelper.updateCnt(String.ValueOf(ws.rq_itm__r.RQ__r.Con__r.Id), dptData);
                      ws.pmid__c = String.valueOf(dptData.InsuredInfo[0].MemberId);
                      ws.intsts__c = 'Success';
                      mbrIdMap.put(ws.rq_itm__r.Id, ws.pmid__c);
                      rqIdMap.put(ws.rq_itm__r.Id, ws.rq_itm__r.RQ__r.Id);
                      if (ws.rq_itm__r.xdcr__c != null) {
                          rqItmDocReq.put(ws.rq_itm__r.Id, ws.rq_itm__r.xdcr__c);
                      }
                      updateWs.add(ws);
                      rgItm.add(ri);
                      rgItmId.add(ri.id);
                      cnLst.add(c);
                  }
                  else {
                      ws.intsts__c = 'Failed';
                      if ((ws.err_msg__c.contains('ErrorCode=VDB0051') || ws.err_msg__c.contains('ErrorCode=EDB003')) && ws.Number_Of_Attempts__c < 3) {
                          ws.Number_Of_Attempts__c = ws.Number_Of_Attempts__c + 1;
                          ws.intsts__c = 'Ready for Integration';
                      }
                      fupdateWs.add(ws);
                      String errorMsg = '';
                      String errorCode = '';
                      for (gctlInsHelper.ErrorInfo err: errMsg) {
                          errorMsg = errorMsg + err.ErrorMsg + ';';
                          errorCode = err.errorCode + ';';
                      }
                      if (errorMsg != '' && errorMsg.length() > 255) errorMsg = errorMsg.substring(0, 254);
                      g_reqitem__c ri = gctlInsHelper.updaterqItmErrorMsg(String.ValueOf(ws.rq_itm__c), errorMsg);
                      system.debug('JJ dup list error' + rgItm);
                      system.debug('errorCode : ' + errorCode);
                      if (ws.rq_itm__r.RQ__r.Service_Code__c == '162' && String.isNotBlank(errorCode) && errorCode.contains('VDB001')) {
                          system.debug('mapStatusByItem : ' + mapStatusByItem);
                          system.debug('ws.rq_itm__r.itm__r.Id : ' + ws.rq_itm__r.itm__r.Id);
                          /**g_srvcitm_Status__c sta = [select id, name, cd__c from g_srvcitm_Status__c where itm__c=:ws.rq_itm__c AND cd__c = 'nc'];
                          **/ if (mapStatusByItem.containsKey(ws.rq_itm__r.itm__r.Id) && mapStatusByItem.get(ws.rq_itm__r.itm__r.Id) != null) {
                              ri.sta__c = mapStatusByItem.get(ws.rq_itm__r.itm__r.Id);
                          }
                      }
                      rgItm.add(ri);
                  }
              }
                }
          //  }
        }
        try {
            if (rgItm.size() > 0) {
                if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                    update rgItm;
                }
            }
            if (cnLst.size() > 0) {
                if (Schema.sObjectType.contact.isUpdateable()) {
                    update cnLst;
                }
            }
            if (rqLst.size() > 0) {
                if (Schema.sObjectType.g_Req__c.isUpdateable()) {
                    update rqLst;
                }
            }
            if (updateWs.size() > 0) {
                if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                    update updateWs;
                }
                grqWsInsH.uploadPolicyDoc(rgItmId, mbrIdMap, rqIdMap, 'Insurance', 'uploadDoc');
            } /**grqWsDocInsH.uploadPolicyDoc(rgItmId, mbrIdMap, rqItmDocReq, rqIdMap, 'Insurance', 'uploadDoc'); }**/
            if (fupdateWs.size() > 0) {
                if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                    update fupdateWs;
                }
            }
        } catch (Exception ex) {
            System.debug('#Exception : ' + ex.getMessage() + ' ' + ex.getLineNumber());
        }
    }
 global void finish(Database.BatchableContext BC) {}

    }