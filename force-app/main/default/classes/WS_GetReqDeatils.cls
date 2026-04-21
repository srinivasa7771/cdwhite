@RestResource(urlMapping = '/getDetails/*') global class WS_GetReqDeatils {
    @HttpPost global static void postRequest() {
        RestContext.response.addHeader('Content-Type', 'application/json');
        rqResp resp = new rqResp();
        String reqBody = RestContext.request.requestBody.toString();
        System.debug('reqBody: ' + reqBody);
        list < g_req__c > t;
        String actionMessg = 'AXS10039, AXSE1002';
        WS_GetReqDeatils.ReqData rqData = (WS_GetReqDeatils.ReqData) JSON.deserialize(reqBody, WS_GetReqDeatils.ReqData.class);
        if (rqData.type == 'mobile') {
            String rqNo = rqData.reqNumber + '%';
            t = [SELECT id, Name, Acc__c, Acc__r.VIP__c, SLA_Status__c, amsgs__c, i_STA__c FROM g_req__c WHERE xcmob__c LIKE: rqNo and CreatedDate = last_N_days: 366 limit 1];
        } else {
            String rqNo = rqData.reqNumber + '%';
            t = [SELECT id, prio__c, Name, Acc__c, Acc__r.VIP__c, SLA_Status__c, amsgs__c, i_STA__c FROM g_req__c WHERE Name LIKE: rqNo and CreatedDate = last_N_days: 366 limit 1];
        }
        if (t != null && t.size() > 0) {
            List < g_itmHistorySTA__c > h = [select id, RQ__r.prio__c, name, t__r.ivraction__c,
                t__r.amsgs__c from g_itmHistorySTA__c where t__r.kstp__c = true and RQ__r.Name =: t[0].Name order by createddate desc limit 1];
            if (h != null && h.size() > 0) {
                actionMessg = h[0].t__r.ivraction__c;
            }
            if (actionMessg == null || (actionMessg != null && actionMessg.length() == 0)) {
                actionMessg = 'AXS10002, AXSE1002';
            }
            if (t[0].prio__c == 'Normal') {
                actionMessg = actionMessg.replace('AXSE1002', 'AXSN1001');
            }
            if (t[0].prio__c == 'Express') {
                actionMessg = actionMessg.replace('AXSE1001', 'AXSN1002');
            }
            resp.currentSta = t[0].i_STA__c;
            resp.id = t[0].id;
            resp.sfUrl = '';
            resp.nextOfAction = actionMessg;
            resp.actMsg = actionMessg;
            resp.sla = t[0].SLA_Status__c;
            resp.isVip = String.valueOf(t[0].Acc__r.VIP__c);
            resp.status = 'Success';
            resp.respMsg = 'Activity updated Successfully.';
            resp.respCode = '0';
            resp.accId = t[0].Acc__c;
        } else {
            resp.status = 'Failed';
            resp.respMsg = 'Activity not found.';
            resp.respCode = '1';
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(resp));
    }
    global class ReqData {
        webService String reqNumber;
        webService String type;
    }
    global class rqResp {
        webService String currentSta;
        webService String id;
        webService String sfUrl;
        webService String nextOfAction;
        webService String actMsg;
        webService String sla;
        webService String isVip;
        webService String accId;
        webService String respCode, status, respMsg;
        webService String uid;
    }
}