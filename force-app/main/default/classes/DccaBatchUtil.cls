public class DccaBatchUtil {

    public static void exchLaCreation(string rqId) {
        OnboardQueueable obq = new OnboardQueueable('laCreationQ', '', rqId);
        System.enqueueJob(obq);
    }
    public static void exchInvBatch(List < id > wIdLst) {
        System.enqueueJob(new OnboardQueueable('ddaInvUpdate', wIdLst));
    }

    //delay call
    public static void pushCRMDocBatch(List < id > wIdLst) {
        List < ws_call__c > wslst = [Select Id, rq_jsn__c, res_jsn__c, err_msg__c, ws_typ__c, intsts__c, xrno__c, pmid__c, rq_itm__c, rq_itm__r.RQ__c, mtd_nm__c, rq_itm__r.ccrmid__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c, rq_itm__r.RQ__r.xuvdet__c from ws_call__c where id in: wIdLst];
        System.enqueueJob(new OnboardQueueable('pushOBCRMDocBatch', wIdLst), 5);
    }

    /*MS 1.1*/
    public static void pushFlDocBatch(List < id > wIdLst) {
        List < ws_call__c > wslst = [Select Id, rq_jsn__c, res_jsn__c, err_msg__c, ws_typ__c, intsts__c, xrno__c, pmid__c, rq_itm__c, rq_itm__r.RQ__c, mtd_nm__c, rq_itm__r.ccrmid__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c, rq_itm__r.RQ__r.xuvdet__c from ws_call__c where id in: wIdLst];
        System.enqueueJob(new OnboardQueueable('pushFLDocBatch', wIdLst), 5);
    }

    @Future(callout = true) public static void exchStsBatch(List < id > wIdLst) {
        List < ws_call__c > wslst = [Select Id, rq_itm__r.RQ__r.xvnum__c, rq_itm__r.RQ__r.xvn__c, rq_itm__r.RQ__r.xmamd__c, rq_itm__r.RQ__r.xpmsle__c, rq_itm__r.RQ__r.xadtx2__c, DDA_id__c, err_cd__c, pmid__c, xwsc__c, intsts__c, rq_itm__r.STA__r.exsyst__c, rq_itm__r.itm__r.rv__c, rq_itm__r.itm__r.dcca_refId__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Name, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.RQ__r.Acc__r.id, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.itm__r.dcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.xdei__c, rq_itm__r.RQ__r.xdmpn__c from ws_call__c where id =: wIdLst];
        DccaBatchUtil.processStsBatch(wslst);
    }
    public static void exchAccInfoBatch(List < id > wIdLst) {
        List < ws_call__c > wslst = [Select Id, rq_itm__r.rq__r.xdei__c, xrno__c, rq_itm__r.rq__r.xdccaRq__c, adhoc_text1__c, rq_itm__r.RQ__r.xuvdet__c, rq_itm__r.RQ__r.xcfn__c, rq_itm__r.RQ__r.xcmn__c, rq_itm__r.xdcca_refId__c, rq_itm__r.RQ__r.xcln__c, rq_itm__r.RQ__r.xccn__c, rq_itm__r.RQ__r.rtacn__c, rq_itm__r.RQ__r.xbtnm__c, rq_itm__r.RQ__r.xcpic__c, rq_itm__r.RQ__r.Acc__r.SF_CRM_ID__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c, err_msg__c, rq_itm__r.itm__c, rq_itm__r.RQ__r.srvc__r.uid__c, rq_itm__r.RQ__c, rq_itm__r.RQ__r.xadtx2__c, rq_itm__r.RQ__r.xcn__c, rq_itm__r.ccrmid__c, rq_itm__r.sta__c, rq_itm__r.itm__r.cd__c, rq_itm__r.sta__r.cd__c, pmid__c, mtd_nm__c, intsts__c from ws_call__c where id =: wIdLst];
        System.enqueueJob(new OnboardQueueable('fetchAccInfo', wslst[0].id));
    }
    @Future(callout = true)
    public static void exchCRMWOBatch(List < id > wIdLst) {
        List < ws_call__c > wslst = [Select Id, rq_jsn__c, intsts__c, res_jsn__c, err_msg__c from ws_call__c where id =: wIdLst];
        DccaBatchUtil.processCRMWOBatch(wslst[0]);
    }
    @Future(callout = true)
    public static void exchPMSUpdateCCRMBatch(List < id > wIdLst) {
        List < ws_call__c > wslst = [Select Id, rq_itm__r.RQ__r.Acc__r.park__c, adhoc_text1__c, ws_typ__c, rq_itm__r.RQ__r.xopn__c, rq_itm__r.RQ__r.activitiesFL__c, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.itm__c, rq_itm__r.RQ__r.xdccaRq__c, rq_itm__r.RQ__r.xvnum__c, rq_itm__r.RQ__r.xadtx2__c, rq_itm__r.RQ__r.xvn__c, rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c, rq_jsn__c, intsts__c, res_jsn__c, err_msg__c, pmid__c, rq_itm__c, xrno__c from ws_call__c where id =: wIdLst]; /*grqWsOnboard.updateCCRMPMSInfo(wslst[0]);*/
    }
    @Future(callout = true)
    public static void exchCRMStsBatch(List < id > wIdLst) {
        List < ws_call__c > wslst = [Select Id, rq_itm__r.rq__r.xdei__c, xrno__c, rq_itm__r.xaf__c, rq_itm__r.rq__r.xdccaRq__c, adhoc_text1__c, rq_itm__r.RQ__r.xuvdet__c, rq_itm__r.RQ__r.xcfn__c, rq_itm__r.RQ__r.xcmn__c, rq_itm__r.xdcca_refId__c, rq_itm__r.RQ__r.xcln__c, rq_itm__r.RQ__r.xccn__c, rq_itm__r.RQ__r.rtacn__c, rq_itm__r.RQ__r.xbtnm__c, rq_itm__r.RQ__r.xcpic__c, rq_itm__r.RQ__r.Acc__r.SF_CRM_ID__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c, err_msg__c, rq_itm__r.itm__c, rq_itm__r.RQ__r.srvc__r.uid__c, rq_itm__r.RQ__c, rq_itm__r.RQ__r.xadtx2__c, rq_itm__r.RQ__r.xcn__c, rq_itm__r.ccrmid__c, rq_itm__r.sta__c, rq_itm__r.itm__r.cd__c, rq_itm__r.sta__r.cd__c, pmid__c, mtd_nm__c, intsts__c from ws_call__c where id =: wIdLst];
        DccaBatchUtil.processCRMStsBatch(wslst[0]);
    }
    public static void exchcbkBatch(List < id > wIdLst) {
        List < ws_call__c > wslst = [SELECT Id, err_cd__c, rq_jsn__c, pmid__c, xwsc__c, intsts__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.LastModifiedDate, rq_itm__r.RQ__r.Id, rq_itm__r.Sta__c, rq_itm__r.RQ__r.Name, rq_itm__r.sta__r.Name, rq_itm__r.sta__r.rqSTA__c, rq_itm__r.RQ__r.xawb__c, rq_itm__r.RQ__r.xanum__c, rq_itm__r.RQ__r.Zone__c, rq_itm__r.RQ__r.xchn__c, rq_itm__r.RQ__r.rmob__c, rq_itm__r.RQ__r.xaloc__c, rq_itm__r.RQ__r.Full_Name__c, rq_itm__r.RQ__r.Acc__r.Name, rq_itm__r.RQ__r.xbn__c, rq_itm__r.RQ__r.nt__c, rq_itm__r.RQ__r.prntcnt__c, rq_itm__r.RQ__r.xccn__c, rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c, rq_itm__r.RQ__r.xbrnd__c, rq_itm__r.id, rq_itm__r.name, rq_itm__r.sta__r.cd__c, rq_itm__r.sta__r.Courier_Stage__c, rq_itm__r.xcub__c, rq_itm__r.xcasc__c, rq_itm__r.exp__c, rq_itm__r.RQ__r.srvc__r.uid__c from ws_call__c where id =: wIdLst];
        DccaBatchUtil.processCBBatch(wslst[0]);
    }

    public static void exchcbStsBatch(List < id > wIdLst) {
        List < ws_call__c > wslst = [Select Id, err_cd__c, pmid__c, xwsc__c, intsts__c, rq_itm__r.itm__r.dcca_refId__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.xdcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.rtacn__c, rq_itm__r.RQ__r.Acc__r.Prk__c from ws_call__c where id =: wIdLst];
        DccaBatchUtil.processCBStsBatch(wslst[0]);
    }

    @Future(callout = true)
    public static void exchCRMDocBatch(List < id > wIdLst) {
        /* List < ws_call__c > wslst = [Select Id, rq_itm__r.rq__r.xdei__c, xrno__c, rq_itm__r.rq__r.xdccaRq__c, adhoc_text1__c, rq_itm__r.RQ__r.xuvdet__c, rq_itm__r.RQ__r.xcfn__c, rq_itm__r.RQ__r.xcmn__c, rq_itm__r.xdcca_refId__c, rq_itm__r.RQ__r.xcln__c, rq_itm__r.RQ__r.xccn__c, rq_itm__r.RQ__r.rtacn__c, rq_itm__r.RQ__r.xbtnm__c, rq_itm__r.RQ__r.xcpic__c, rq_itm__r.RQ__r.Acc__r.SF_CRM_ID__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c, err_msg__c, rq_itm__r.itm__c, rq_itm__r.RQ__r.srvc__r.uid__c, rq_itm__r.RQ__c, rq_itm__r.RQ__r.xadtx2__c, rq_itm__r.RQ__r.xcn__c, rq_itm__r.ccrmid__c, rq_itm__r.sta__c, rq_itm__r.itm__r.cd__c, rq_itm__r.sta__r.cd__c, pmid__c, mtd_nm__c, intsts__c from ws_call__c where id =: wIdLst];
         for (ws_call__c ws: wslst)
             DccaBatchUtil.processCRMDocBatch(ws);*/
        DccaBatchUtil.pushFlDocBatch(wIdLst);
    }
    public static void exchDocBatch(List < id > wIdLst) {
        System.enqueueJob(new OnboardQueueable('uploadDDADoc', wIdLst));
    }
    @Future(callout = true) public static void exchAddRemoveSancBatch(List < id > wIdLst) {
        List < ws_call__c > wslst = [Select Id, err_cd__c, pmid__c, xwsc__c, intsts__c, rq_itm__r.itm__r.rv__c, rq_itm__r.itm__r.dcca_refId__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Name, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.itm__r.dcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.xdmpn__c from ws_call__c where id =: wIdLst];
        DccaBatchUtil.processSancBatch(wslst);
    }
    @Future(callout = true) public static void exchdccaLtAprovalBatch(List < id > wIdLst) {
        List < ws_call__c > wslst = [Select Id, err_cd__c, pmid__c, xwsc__c, intsts__c, rq_itm__r.itm__r.rv__c, rq_itm__r.itm__r.dcca_refId__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Name, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.itm__r.dcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.xdmpn__c, rq_itm__r.RQ__r.xadtx1__c from ws_call__c where id =: wIdLst and ws_typ__c = 'DCCA Letters'
            AND intsts__c = 'Ready for Integration'
        ];
        DccaBatchUtil.dccaLtAprovalBatch(wslst);
    }
    @Future(callout = true) public static void exchInvYardiBatch(List < id > wIdLst) {
        List < ws_call__c > wslst = [Select Id, rq_jsn__c, intsts__c, res_jsn__c from ws_call__c where id =: wIdLst];
        DccaBatchUtil.processInvYardiFineBatch(wslst);
    }




    @Future(callout = true)
    public static void exchInvDDABatch(List < id > wIdLst) {
        List < ws_call__c > wslst = [Select Id, rq_jsn__c, intsts__c, res_jsn__c from ws_call__c where id =: wIdLst]; //DDA_id__c,DDA_Amt__c,      
        DccaBatchUtil.processInvDDABatch(wslst);
    }

    /*Customer refund attachment push*/
    public static void pushCreateCDBGREFATT(List < id > wIdLst) {
        List < ws_call__c > wsCallList = [Select Id, rq_jsn__c, res_jsn__c, err_msg__c, intsts__c, pmid__c, xrno__c, rq_itm__c, rq_itm__r.RQ__c, mtd_nm__c, rq_itm__r.ccrmid__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c from ws_call__c where id =: wIdLst]; /*DDA_id__c,DDA_Amt__c,*/
        for (ws_call__c objWs: wsCallList) {
            if (objWs.rq_jsn__c != null) {
                gtFussionWs.voidCreateRefundAtt(objWs.rq_jsn__c, objWs.rq_itm__r.RQ__c, objWs.Id);
            }
        }
    }

    /*Customer refund attachment push*/
    public static void pushCreateCDBGREFHISATT(List < id > wIdLst) {
        List < ws_call__c > wsCallList = [Select Id, rq_jsn__c, res_jsn__c, err_msg__c, intsts__c, pmid__c, xrno__c, rq_itm__c, rq_itm__r.RQ__c, mtd_nm__c, rq_itm__r.ccrmid__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c from ws_call__c where id =: wIdLst]; /*DDA_id__c,DDA_Amt__c,*/
        for (ws_call__c objWs: wsCallList) {
            if (objWs.rq_jsn__c != null) {
                gtFussionWs.voidCreateRefundHisAtt(objWs.rq_jsn__c, objWs.rq_itm__r.RQ__c, objWs.Id);
            }
        }
    }

    public static List < ws_call__c > processStsBatch(List < ws_call__c > scope) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        List < Id > accId = new List < Id > ();
        List < g_Req__c > rqList = new List < g_Req__c > ();
        String jsonBody = '';
        List < String > reqNo = new List < String > ();
        Map < string, loc__c > regOffMap = new Map < string, loc__c > ();
        for (ws_call__c ws: scope) {
            if (ws.rq_itm__r.RQ__r.Service_Code__c == '208') reqNo.add(ws.rq_itm__r.RQ__r.Acc__r.id);
        }
        if (reqNo != null && !reqNo.isEmpty()) {
            List < loc__c > regOff = [Select Id, acc__r.id, agrno__c, offno__c, aroffno__c, flr__c, arflr__c, Bldg__c, arBldg__c, bu__c, arbu__c, ls_end__c, ls_std__c from loc__c where acc__c in: reqNo and IsActive__c = true and isregof__c = true];
            if (regOff != null && regOff.size() > 0) {
                for (loc__c lc: regOff) {
                    regOffMap.put(lc.acc__r.id, lc);
                }
            }
        }
        for (ws_call__c ws: scope) {
            system.debug('ws.Id::' + ws.Id);
            if (ws.intsts__c == 'Ready for Integration') {
                grqWsExtStatusUpd.RequestRecords reqjsRq = (grqWsExtStatusUpd.RequestRecords) JSON.deserialize(ws.rq_jsn__c, grqWsExtStatusUpd.RequestRecords.class);
                map < String, String > stsUpdMap = new map < String, String > ();
                list < String > splitList = new list < String > ();
                List < grqWsExtStatusUpd.RegisterAddress > mnAdrLst = new List < grqWsExtStatusUpd.RegisterAddress > ();
                List < g_reqitem__c > rilcList = [select id, xpreno__c, xplt__c, xpltar__c, xasf__c, xcasqm__c, xargno__c, xflr__c, xflrarb__c, xisma__c, xleed__c, xbldg__c, xbldgarb__c from g_reqitem__c where rq__c =: ws.rq_itm__r.RQ__c and xleatp__c = 'PMS Lease'
                    and itm__r.cd__c in ('lc2', 'lc3', 'lc4', 'lc5', 'lc6', 'lc7')
                ];
                if (rilcList != null && !rilcList.isEmpty()) {
                    for (g_reqitem__c ri: rilcList) {
                        if (ri.xisma__c != null && ri.xisma__c) {
                            grqWsExtStatusUpd.RegisterAddress addregOff = new grqWsExtStatusUpd.RegisterAddress();
                            addregOff.aggNo = ri.xargno__c;
                            addregOff.unitNo = ri.xpreno__c;
                            reqjsRq.rec[0].regAdd = addregOff;
                        }
                    }
                } else if (String.isNotBlank(ws.rq_itm__r.RQ__r.xvnum__c) && String.isNotBlank(ws.rq_itm__r.RQ__r.xvn__c)) {
                    grqWsExtStatusUpd.RegisterAddress addregOff = new grqWsExtStatusUpd.RegisterAddress();
                    addregOff.aggNo = (ws.rq_itm__r.RQ__r.xvn__c).split(';')[0];
                    String addr = (ws.rq_itm__r.RQ__r.xvn__c).split(';')[1];
                    if (String.isNotBlank(addr)) {
                        List < String > addrLst = addr.split(',');
                        Map < String, String > addrmp = new Map < String, String > ();
                        for (String str: addrLst) {
                            addrmp.put(str.split(':')[0], str.split(':')[1]);
                        }
                        if (addrmp != null && addrmp.containskey('Premises')) {
                            addregOff.unitNo = addrmp.get('Premises');
                            reqjsRq.rec[0].regAdd = addregOff;
                        }
                    }
                }
                reqjsRq.rec[0].MainAdd = null;
                system.debug('reqjsRq' + reqjsRq);
                if (ws.rq_itm__r.STA__r.exsyst__c != null) {
                    string wsexsyst = ws.rq_itm__r.STA__r.exsyst__c;
                    if (wsexsyst != null) {
                        splitList = wsexsyst.split(';');
                        for (string st: splitList) {
                            list < string > crtmap = st.split(':');
                            stsUpdMap.put(crtmap[0], crtmap[1]);
                        }
                        for (string stsUp: stsUpdMap.keySet()) {
                            if (stsUp.contains('dcca')) {
                                reqjsRq.rec[0].status = stsUpdMap.get(stsUp);
                            }
                        }
                    }
                }
                if (String.isNotBlank(ws.DDA_id__c)) {
                    reqjsRq.rec[0].dccaReqId = ws.DDA_id__c;
                }
                if (reqjsRq != null) {
                    jsonBody = JSON.serialize(reqjsRq);
                    system.debug('jsonBody' + jsonBody);
                }
                Http h = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('accept', 'application/json');
                request.setEndpoint('callout:DCCA_Auth/apexrest/dccaStatusUpdate/');
                request.setTimeout(120000);
                request.setMethod('POST');
                request.setBody(jsonBody);
                try {
                    response = h.send(request);
                    if (response.getStatusCode() == 200) {
                        system.debug('Sucess');
                        system.debug('response' + response.getBody());
                        ws.rq_jsn__c = jsonBody;
                        ws.res_jsn__c = response.getBody();
                        System.debug('response.getBody();' + response.getBody());
                        grqWsExtStatusUpd.RequestRecords resJs = (grqWsExtStatusUpd.RequestRecords) JSON.deserialize(response.getBody(), grqWsExtStatusUpd.RequestRecords.class);
                        system.debug('JJ' + resJs);
                        if (resJs != null && String.isBlank(resJs.rec[0].error)) {
                            ws.intsts__c = 'Success';
                        } else {
                            ws.intsts__c = 'Failed';
                            ws.err_msg__c = resJs.rec[0].error;
                        }
                    } else {
                        ws.intsts__c = 'Failed';
                        ws.err_msg__c = response.getBody();
                    }
                } catch (System.CalloutException e) {
                    ws.res_jsn__c = String.ValueOF(e);
                    ws.intsts__c = 'Failed';
                }
                wsList.add(ws);
            }
        }
        return wsList;
    }
    public static void processAccInfoBatch(ws_call__c wsCall) {
        new BatchOnboardFetchAccInfo().fetchAccInfo(wsCall);
    }
    public static void processCBStsBatch(ws_call__c ws) {

        if (ws.intsts__c == 'Ready for Integration') {
            System.debug('ws.rq_itm__r.RQ__r.Id');
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Content-Type', 'application/json');
            String endpoint = '';
            if (ws.mtd_nm__c == 'updateCourColSta')
                endpoint = Label.CRM_Instance + '/apexrest/cdcollection/';
            else
                endpoint = Label.CRM_Instance + '/apexrest/csrupdate/';
            request.setEndpoint('callout:' + endpoint);
            request.setTimeout(90000);
            request.setMethod('POST');
            request.setBody(ws.rq_jsn__c);

            try {
                response = h.send(request);
                System.debug('tecomBatch_CourStaUpdt <response.getStatusCode> : ' + response.getStatusCode());
                if (response.getStatusCode() == 200) {
                    system.debug('response' + response.getBody());
                    ws.res_jsn__c = response.getBody();
                    courierIntg.courierResp resSrRq = (courierIntg.courierResp) JSON.deserialize(response.getBody(), courierIntg.courierResp.class);
                    System.debug('Response success' + resSrRq.respCode);
                    if (resSrRq.respCode == '0') {
                        ws.intsts__c = 'Success';
                        ws.err_msg__c = '';
                    } else {
                        ws.intsts__c = 'Failed';
                        ws.err_msg__c = resSrRq.respMsg;
                    }
                } else {
                    ws.intsts__c = 'Failed';
                    ws.err_msg__c = response.getBody();
                }
            } catch (System.CalloutException e) {
                System.debug('#Callout Error: ' + e.getMessage());
                ws.res_jsn__c = e.getMessage();
                ws.intsts__c = 'Failed';
            } catch (Exception ex) {
                System.debug('#EXCEPTION: ' + ex.getMessage() + ' ##StackTrace: ' + ex.getStackTraceString());
                ws.res_jsn__c = ex.getMessage();
                ws.intsts__c = 'Failed';
            }

            update ws;
        }

    }
    public static void processCBBatch(ws_call__c ws) {
        try {
            list < g_cmb__c > culst = new list < g_cmb__c > ();
            String CB = '';
            Boolean isAdoch = false;
            String stage = 'Delivery';
            Datetime createdon = Datetime.now();
            if (ws.intsts__c == 'Ready for Integration') {
                XMLParserforEmpostWebservice cour = new XMLParserforEmpostWebservice();
                stage = (ws.rq_itm__r.RQ__r.srvc__r.uid__c == '196') ? 'Delivery' : 'Collection';
                g_reqitem__c ri = new g_reqitem__c(id = ws.rq_itm__r.Id);
                g_req__c rq = new g_req__c(id = ws.rq_itm__r.RQ__r.Id);
                ri.xcub__c = stage;
                ws.intsts__c = 'Failed';
                String uid = ri.id + ws.rq_itm__r.sta__r.cd__c + isAdoch + stage + Datetime.now().format('ddmmyyyyHH');
                cour.uid = uid;
                CB = cour.CreateBooking(rq, stage);
                System.debug('!!!! stage : ' + stage + ' id: ' + rq.id + 'CB:' + CB);
                if (CB != null) {
                    ws.intsts__c = 'Success';
                    culst.add(new g_cmb__c(xawb__c = Long.valueOf(CB), coubdt__c = createdon, uid__c = uid, sta__c = 'At Dispatcher', adh__c = isAdoch, tmpstamp__c = Datetime.now(), itm__c = ri.id, xcb__c = stage, itmsta__c = ws.rq_itm__r.sta__c, xccpd__c = '')); /* lstxml[0].CourierName */
                } else {
                    culst.add(new g_cmb__c(xawb__c = 0, sta__c = 'At Dispatcher', tmpstamp__c = Datetime.now(), uid__c = uid, coubdt__c = createdon, itm__c = ri.id, adh__c = isAdoch, xcb__c = stage, itmsta__c = ws.rq_itm__r.sta__c, xccpd__c = 'NA'));
                }
            }
            if (!culst.isEmpty()) {
                insert culst;
            }
            if ((ws.rq_itm__r.RQ__r.srvc__r.uid__c == '196' || ws.rq_itm__r.RQ__r.srvc__r.uid__c == '197') && String.isNotBlank(CB)) {
                updateCRMCourierStatus(ws, CB);
            }
        } catch (exception ex) {
            ws.err_msg__c = ex.getMessage() + ' -- ' + ex.getStackTraceString();
            ws.intsts__c = 'Failed';
        }
        update ws;
    }
    /***License Amendment********/
    /*US APD2635 Start*/
    public static void cncAssignmentReq(List < Id > wsIdList) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        List < ws_call__c > objWsList = [Select Id, rq_jsn__c, intsts__c, res_jsn__c from ws_call__c where Id IN: wsIdList];
        for (ws_call__c ws: objWsList) {
            if (ws.intsts__c == 'Ready for Integration') {
                Http h = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('accept', 'application/json');
                request.setEndpoint('callout:' + Label.CRM_Instance + '/apexrest/onboarding/');
                String reqJson = '{"methodName":"cmpNameChAssignment","data":[' + ws.rq_jsn__c + ']}';
                request.setTimeout(120000);
                request.setMethod('POST');
                request.setBody(reqJson);
                response = h.send(request);
                String jsonInput = response.getBody().toString();
                List < Object > outerList = (List < Object > ) JSON.deserializeUntyped(jsonInput);
                Map < String, Object > record = (Map < String, Object > ) outerList[0];
                if ((Boolean) record.get('isSuccess') == true) {
                    System.debug('response' + response.getBody());
                    ws.res_jsn__c = response.getBody();
                    ws.intsts__c = 'Success';
                } else {
                    ws.res_jsn__c = response.getBody();
                    ws.intsts__c = 'Failed';
                }
                wsList.add(ws);
            }
        }
        if (wsList != null && wsList.size() > 0) {
            update wsList;
        }
    } /*US APD2635 End*/

    @Future(callout = true)
    public static void excLADDABatch(List < id > wIdLst) {
        System.debug('====wIdLst===' + wIdLst);
        List < ws_call__c > wslst = [Select Id, rq_jsn__c, intsts__c, res_jsn__c, rq_itm__r.RQ__c from ws_call__c where id IN: wIdLst];
        DccaBatchUtil.processLADDABatch(wslst);
    }
    public static void processLADDABatch(List < ws_call__c > scope) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        List < id > rqIds = new List < id > ();
        Map < id, id > rqItmap = new Map < id, id > ();
        String jsonBody = '';
        set < id > wsIds = new set < id > ();
        for (ws_call__c ws: scope) {
            system.debug('--ws--' + ws.rq_jsn__c);
            system.debug('ws.Id::' + ws.Id);
            wsIds.add(ws.id);
            if (ws.intsts__c == 'Ready for Integration') {
                rqIds.add(ws.rq_itm__r.RQ__c);
                rqItmap.put(ws.rq_itm__r.RQ__c, ws.rq_itm__c);
                String reqjsRq = ws.rq_jsn__c;
                system.debug('--reqjsRq--' + reqjsRq);
                if (reqjsRq != null) {
                    system.debug('jsonBody' + jsonBody);
                }
                Http h = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('accept', 'application/json');
                request.setEndpoint('callout:' + Label.LA_DDA_End_Point + '/apexrest/licenseAmendment/upsertServiceRequest');
                request.setTimeout(120000);
                request.setMethod('POST');
                request.setBody(reqjsRq);
                try {
                    response = h.send(request);
                    if (response.getStatusCode() == 200) {
                        system.debug('Sucess');
                        system.debug('response' + response.getBody());
                        ws.res_jsn__c = response.getBody();
                        System.debug('response.getBody();' + response.getBody());
                        LAResponseWrapper resJs = (LAResponseWrapper) JSON.deserialize(response.getBody(), LAResponseWrapper.class);
                        if (resJs != null && resJs.srList != null && resJs.isSuccess == true) {
                            system.debug('--Recevied Reponse--');
                            List < g_reqDoc__c > rqDocListUp = new List < g_reqDoc__c > ();
                            if (resJs.srList[0].srAttachments != null) {
                                Map < String, SrAttachments > attDDAMap = new Map < String, SrAttachments > ();
                                system.debug('======attDDAMap' + attDDAMap);
                                system.debug('======attDDAMap Keyset' + attDDAMap.keyset());
                                map < string, string > ppricMap = new map < string, string > ();
                                map < string, string > ddaAttWithIdMap = new map < string, string > ();
                                string rqDocName = '';
                                for (g_reqDoc__c rqDoc: [select id, PPN__c, name, lbl__c, RQ__r.xcamc__c, RQ__r.name, RQ__r.xadtx3__c, RQ__r.xadtx2__c, epu__c, dda_att__c from g_reqDoc__c where RQ__c =: ws.rq_itm__r.RQ__c AND Req__c = true and dda_att__c = null]) {
                                    /*and epu__c=false]*/
                                    rqDocName = !string.isblank(rqDoc.lbl__c) ? rqDoc.lbl__c : rqDoc.name;
                                    system.debug('--rqDocName--' + rqDocName);
                                    LARequestWrapper adhoc3Data = (LARequestWrapper) System.JSON.deserialize(rqDoc.RQ__r.xadtx3__c, LARequestWrapper.class);
                                    Map < String, String > cusNameMap = new Map < String, String > ();
                                    Map < String, String > nameMap = new Map < String, String > ();
                                    Map < String, String > originalNameMap = new Map < String, String > ();
                                    if (!string.isblank(rqDoc.RQ__r.xadtx2__c) && rqDoc.RQ__r.xcamc__c != 'Appointment of Auditor') {
                                        List < laah2Warp > lsWap = (List < laah2Warp > ) System.JSON.deserialize(rqDoc.RQ__r.xadtx2__c, List < laah2Warp > .class);
                                        for (laah2Warp mp: lsWap) {
                                            if (mp.ppNum != null) {
                                                String name = '';
                                                if (mp.firstName != null) name = mp.firstName;
                                                if (mp.lastName != null) name += ' ' + mp.lastName;
                                                cusNameMap.put(mp.ppNum, name.trim());
                                            }
                                        }
                                        for (LARequestWrapper.Members m: adhoc3Data.serviceRequests[0].members) {
                                            String ppNumber = m.passports[0].docNo;
                                            String name = m.firstName.trim() + ' ' + m.lastName.trim();
                                            originalNameMap.put(ppNumber, name);
                                        }
                                        for (String s: cusNameMap.keySet()) {
                                            nameMap.put(originalNameMap.get(s), cusNameMap.get(s));
                                        }
                                    }
                                    for (SrAttachments ddaAtt: resJs.srList[0].srAttachments) {
                                        system.debug('---ddaAtt---' + ddaAtt.name);
                                        String memName = '';
                                        LARequestWrapper requestData = (LARequestWrapper) System.JSON.deserialize(ws.rq_jsn__c, LARequestWrapper.class);
                                        for (LARequestWrapper.members objMem: requestData.serviceRequests[0].members) {
                                            memName = objMem.firstName.trim() + ' ' + objMem.lastName.trim();
                                        } /*U_S DFZC Start*/
                                        if (!resJs.srList[0].serviceName.containsignoreCase('Director')) {
                                            if (ddaAtt.name.containsignoreCase('Valid Passport Copy of General Manager') || ddaAtt.name.containsignoreCase('Valid Passport Copy of Secretary')) ddaAtt.name = 'Passport Copy';
                                            if (ddaAtt.name.containsignoreCase('Declaration Form')) ddaAtt.name = 'General Manager Declaration';
                                            if (ddaAtt.name.containsignoreCase('Trade License')) ddaAtt.name = 'Trade License Copy';
                                            if (ddaAtt.name.containsignoreCase('RICC Form')) ddaAtt.name = 'RICC Form';
                                            if (ddaAtt.name.containsignoreCase('RIC Form')) ddaAtt.name = 'RIC Form';
                                            if (ddaAtt.name.startswith('Passport - ')) {
                                                ddaAtt.name = 'Exmem Passport Copy - ' + ddaAtt.name.split('-')[1].trim();
                                                system.debug('--Exmem PP Name--' + ddaAtt.name);
                                            }
                                            if (rqDocName.startswith('Exmem Emirates') || rqDocName.startswith('Exmem Visa')) {
                                                ddaAtt.name = 'Exmem' + ' ' + ddaAtt.name;
                                                system.debug('--Exmem Doc Name--' + ddaAtt.name);
                                            } else {
                                                ddaAttWithIdMap.put(ddaAtt.name, ddaAtt.ddaId);
                                            }
                                            ddaAttWithIdMap.put(ddaAtt.name, ddaAtt.ddaId);
                                        }
                                        if (!resJs.srList[0].serviceName.containsignoreCase('Manager') && !resJs.srList[0].serviceName.containsignoreCase('Secretary')) {
                                            if (ddaAtt.name.contains('Resolution') || ddaAtt.name.contains('Passport - ') || ddaAtt.name.contains('Passport Copy - ') || ddaAtt.name.contains('RIC Form - ') || ddaAtt.name.contains('Emirates ID - front - ') || ddaAtt.name.contains('Emirates ID - back - ') || ddaAtt.name.contains('Visa Page - ')) {
                                                string nameSplit = '';
                                                string docNmaeDDA = '';
                                                if (!ddaAtt.name.contains('Resolution')) {
                                                    nameSplit = ddaAtt.name.split('-')[1].trim();
                                                    docNmaeDDA = nameMap.get(nameSplit);
                                                }
                                                if (!string.isblank(docNmaeDDA)) {
                                                    ddaAtt.name = ddaAtt.name.split('-')[0].trim() + ' - ' + nameMap.get(nameSplit);
                                                }
                                                if (ddaAtt.name.startswith('Passport - ')) {
                                                    ddaAtt.name = 'Exmem Passport Copy - ' + ddaAtt.name.split('-')[1].trim();
                                                }
                                                system.debug('---rqDocName---' + rqDocName);
                                                if (rqDocName.startswith('Exmem Emirates') || rqDocName.startswith('Exmem Visa')) {
                                                    ddaAtt.name = 'Exmem' + ' ' + ddaAtt.name;
                                                    system.debug('--ddaAtt.name today--' + ddaAtt.name);
                                                } else {
                                                    ddaAttWithIdMap.put(ddaAtt.name, ddaAtt.ddaId);
                                                }
                                                ddaAttWithIdMap.put(ddaAtt.name, ddaAtt.ddaId);
                                            }
                                        } /*U_S DFZC End*/
                                        system.debug('---ddaAttWithIdMap---' + ddaAttWithIdMap);
                                    } /*for (String ddaDoc: ddaAttWithIdMap.keyset()) { system.debug('---ddaDoc----' + ddaDoc); if (ddaDoc.containsIgnorecase(rqDocName)) { rqDoc.dda_att__c = ddaAttWithIdMap.get(rqDocName.toLowerCase().trim()); rqDocListUp.add(rqDoc); } } */
                                    if ((ddaAttWithIdMap.containsKey(rqDocName)) && !rqDoc.epu__c) {
                                        system.debug('****rqDocName****' + rqDocName);
                                        rqDoc.dda_att__c = ddaAttWithIdMap.get(rqDocName.trim());
                                        system.debug('--rqDoc.dda_att__c--' + rqDoc.dda_att__c);
                                        rqDocListUp.add(rqDoc);
                                    }
                                }
                                update rqDocListUp;
                            }
                            if (resJs.srList[0].SrFees != null) {
                                Map < String, SrFees > feeType = new Map < String, SrFees > ();
                                for (SrFees ddaFee: resJs.srList[0].SrFees) {
                                    feeType.put(ddaFee.axsServItemName, ddaFee);
                                }
                                List < g_reqitem__c > reqItmLst = new List < g_reqitem__c > ();
                                for (g_reqitem__c req: [Select id, Name, scN__c, itm__r.cd__c from g_reqitem__c where Name IN: feeType.Keyset() and RQ__c =: ws.rq_itm__r.RQ__c]) {
                                    SrFees ddaFee = feeType.get(req.Name);
                                    req.scN__c = ddaFee.basicAmount;
                                    reqItmLst.add(req);
                                }
                                update reqItmLst;
                            }
                            ws.intsts__c = 'Success';
                            g_Req__c req = new g_Req__c(id = ws.rq_itm__r.RQ__c);
                            system.debug('--request--' + req);
                            req.xdccaRq__c = resJs.srList[0].reqNo;
                            system.debug('--Recevied Reponse and updated the values--');
                            req.xdei__c = resJs.srList[0].reqid;
                            update req;
                        } else if (resJs != null && resJs.isSuccess == false) {
                            ws.intsts__c = 'Failed';
                            ws.err_msg__c = JSON.serialize(resJs.message);
                        } else {
                            ws.intsts__c = 'Failed';
                            ws.err_msg__c = response.getBody();
                        }
                    } else {
                        ws.intsts__c = 'Failed';
                        ws.err_msg__c = response.getBody();
                    }
                } catch (System.CalloutException e) {
                    ws.res_jsn__c = String.ValueOF(e);
                    ws.intsts__c = 'Failed';
                }
                wsList.add(ws);
            }
        }
        update wsList;
        List < ws_call__c > InvwsList = new List < ws_call__c > ();
        List < g_Tran__c > rql = [Select id, Name, md__c, Rq__r.xdei__c, RQ__r.name, A__c from g_Tran__c where Rq__c in: rqIds and STA__c = 'Completed'
            order by lastmodifieddate desc limit 1
        ];
        for (g_Tran__c T: rql) {
            String itmIs = rqItmap.get(T.Rq__c);
            InvoiceInfoList invList = new InvoiceInfoList();
            List < Invoice > listInv = new List < Invoice > ();
            Invoice newInv = new Invoice();
            newInv.invNo = T.Name;
            newInv.invAmount = String.ValueOf(T.A__c);
            newInv.payMethod = T.md__c;
            newInv.refNo = T.RQ__r.name;
            newInv.dccaSrId = T.RQ__r.xdei__c;
            listInv.add(newInv);
            invList.inv = listInv;
            String invjsonBody = JSON.serialize(invList);
            ws_call__c ws = new ws_call__c();
            ws.rq_jsn__c = invjsonBody;
            ws.rq_itm__c = itmIs;
            ws.ws_typ__c = 'DccaExtraService';
            ws.mtd_nm__c = 'InvoiceCreation';
            ws.intsts__c = 'Ready for Integration';
            ws.uid__c = T.RQ__r.name + system.now() + 'DccaInv';
            InvwsList.add(ws);
        }
        insert InvwsList;
    }

    /* DDA Amdements for crm constcat update */
    public static void exchCRMUpsertContacts(List < Id > wsCallId) {
        //grqWsOnboard.callUpsertContacts(wsCallId[0]);
    }



    @Future(callout = true)
    public static void updateAXSStatusLA(List < Id > wsCallId) {
        System.debug('===wsCallId==' + wsCallId);
        List < ws_call__c > wslst = [Select Id, rq_jsn__c, adhoc_text1__c, intsts__c, res_jsn__c, rq_itm__r.RQ__c, mtd_nm__c, rq_itm__r.RQ__r.Name, rq_itm__r.RQ__r.crflg__c, rq_itm__r.RQ__r.xdei__c, rq_itm__r.rc__c from ws_call__c where id IN: wsCallId];
        List < ws_call__c > wsListupd = new List < ws_call__c > ();
        String reqJson = '';
        if (string.isblank(wslst[0].adhoc_text1__c)) {
            reqJson = '{ "serviceRequests": [ { "axsRefNo": "' + wslst[0].rq_itm__r.RQ__r.Name + '" } ] } ';
        } else {
            reqJson = '{ "serviceRequests": [ { "axsRefNo": "' + wslst[0].rq_itm__r.RQ__r.Name + '","customerFeedback":"' + wslst[0].adhoc_text1__c + '"} ] } ';
        }
        system.debug('---reqJson---' + reqJson);
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:' + Label.LA_DDA_End_Point + '/apexrest/licenseAmendment/axsStatusUpdate');
        request.setTimeout(120000);
        request.setMethod('POST');
        request.setBody(reqJson);
        try {
            response = h.send(request);
            System.debug('===response==' + response);
            if (response.getStatusCode() == 200) {
                grqWsOnboard.docsWSCallToDDA(wslst[0].rq_itm__r.RQ__c, 'Correction');
                system.debug('Sucess');
                system.debug('response' + response.getBody());
                wsLst[0].rq_jsn__c = reqJson;
                wsLst[0].res_jsn__c = response.getBody();
                System.debug('response.getBody();' + response.getBody());
                DccaBatchUtil.LAResponseWrapper resJs = (DccaBatchUtil.LAResponseWrapper) JSON.deserialize(response.getBody(), DccaBatchUtil.LAResponseWrapper.class);
                system.debug('======JJ' + resJs);
                if (resJs != null && resJs.isSuccess == true) {
                    wsLst[0].intsts__c = 'Success';
                } else if (resJs != null && resJs.isSuccess == false) {
                    wsLst[0].intsts__c = 'Failed';
                    wsLst[0].err_msg__c = JSON.serialize(resJs.message);
                } else {
                    wsLst[0].intsts__c = 'Failed';
                    wsLst[0].err_msg__c = response.getBody();
                }
            } else {
                wsLst[0].intsts__c = 'Failed';
                wsLst[0].err_msg__c = response.getBody();
            }
        } catch (System.CalloutException e) {
            wsLst[0].res_jsn__c = String.ValueOF(e);
            wsLst[0].intsts__c = 'Failed';
        }
        wsListupd.add(wsLst[0]);
        update wsListupd;
    }

    /***License Amendment********/


    public static void updateCRMCourierStatus(ws_call__c ws, String awb) {
        serviceReq servReq = new serviceReq();
        List < serviceReq > serviceReqList = new List < serviceReq > ();
        serviceRequest sr = new serviceRequest();
        servReq.SRN = ws.rq_itm__r.RQ__r.Name;
        servReq.AWB = '' + awb; /**servReq.status = rq.sta__c;**/
        servReq.delStatus = ws.rq_itm__r.sta__r.Name;
        servReq.status = ws.rq_itm__r.sta__r.rqSTA__c;
        servReq.timeStamp = '' + ws.rq_itm__r.lastModifiedDate.getTime();
        if (ws.rq_itm__r.RQ__r.srvc__r.uid__c == '197') {
            servReq.acName = ws.rq_itm__r.RQ__r.Acc__r.Name;
            servReq.conName = ws.rq_itm__r.RQ__r.xchn__c;
            servReq.docType = 'Lease Document Collection (Along with Cheque)';
            servReq.refMobile = ws.rq_itm__r.RQ__r.rmob__c;
            servReq.delZone = ws.rq_itm__r.RQ__r.xbrnd__c;
            servReq.bldngName = ws.rq_itm__r.RQ__r.xbn__c;
            servReq.delLoc = ws.rq_itm__r.RQ__r.xaloc__c;
            servReq.notes = ws.rq_itm__r.RQ__r.nt__c;
            servReq.noCheques = (ws.rq_itm__r.RQ__r.prntcnt__c != null) ? String.ValueOf(ws.rq_itm__r.RQ__r.prntcnt__c) : '0';
            servReq.agNo = ws.rq_itm__r.RQ__r.xccn__c;
            servReq.oracleId = ws.rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c;
            servReq.axsReqId = ws.rq_itm__r.RQ__r.Id;
        }
        serviceReqList.add(servReq);
        sr.reqs = serviceReqList;
        String jsonBody = JSON.serialize(sr);
        ws_call__c wscs = new ws_call__c(rq_jsn__c = jsonBody, ws_typ__c = 'Courier Service', mtd_nm__c = 'updateCourSta', intsts__c = 'Ready for Integration', uid__c = ws.rq_itm__r.RQ__r.id + '' + ws.rq_itm__r.Id + '' + ws.rq_itm__r.sta__c + system.now() + 'updateCourSta', rq_itm__c = ws.rq_itm__r.id);
        insert wscs;
    }


    public static void processCRMDocBatch(ws_call__c wsCall) {
        try {
            set < id > rdocs = new Set < id > ();
            wsCall.intsts__c = 'On hold';
            for (Attachment att: [select id, parentid, parent.name, name, body from Attachment where id =: wsCall.pmid__c]) {
                grqWsOnboard.DocumentInfo doc = new grqWsOnboard.DocumentInfo();
                doc.recid = wsCall.rq_itm__r.ccrmid__c;
                system.debug(' doc.recid::' + doc.recid);
                if (String.isNotBlank(wsCall.adhoc_text1__c) && att.parent.name.contains('Passport - first page')) {
                    List < g_reqitemDoc__c > ridocLst = [select id, Req__c, reqAts__c, reqItm__r.itm__r.cd__c, reqItm__r.xcfn__c, reqItm__r.xcln__c, reqItm__r.RQ__r.xccn__c, name, lbl__c, reqDoc__c from g_reqitemDoc__c where reqDoc__c =: att.parentid];
                    if (ridocLst != null && !ridocLst.isEmpty()) doc.docName = 'Valid Passport Copy - ' + (ridocLst[0].reqItm__r.xcfn__c).toLowerCase().capitalize() + ' ' + (ridocLst[0].reqItm__r.xcln__c).toLowerCase().capitalize();
                    else doc.docName = 'Valid Passport Copy';
                    doc.fileName = att.name.replace('Passport - first page', 'Valid Passport Copy');
                } else if (String.isNotBlank(wsCall.adhoc_text1__c)) {
                    doc.docName = (wsCall.adhoc_text1__c).substringBefore('.');
                    doc.fileName = att.name;
                } else {
                    doc.docName = att.parent.name;
                    doc.fileName = att.name;
                }
                doc.accid = wsCall.rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c;
                doc.fileBody = EncodingUtil.base64Encode(att.body);
                String rqBody = Json.serialize(doc);
                Http h = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('accept', 'application/json');
                request.setEndpoint('callout:' + Label.CRM_Instance + '/apexrest/createdoc');
                request.setTimeout(90000);
                request.setMethod('POST');
                request.setBody(rqBody);
                response = h.send(request);
                if (response.getStatusCode() == 200) {
                    system.debug('res::' + response.getBody());
                    wsCall.intsts__c = 'Success';
                }
            }
        } catch (exception ex) {
            wsCall.err_msg__c = ex.getMessage() + ' -- ' + ex.getStackTraceString();
            wsCall.intsts__c = 'Failed';
        }
    }
    public static void processInvDDABatch(List < ws_call__c > wsLst) {
        List < g_Tran__c > tLst = [select id, Name, Rq__r.name, rq__r.xdei__c, md__c, dt__c, (select id, name, A__c, itm__c, itm__r.itm__r.cd__c from Items__r) from g_Tran__c where Name =: wsLst[0].rq_jsn__c and tp__c = 'Payment'
            and STA__c = 'Completed'
        ];
        if (tLst != null && !tLst.isEmpty()) {
            Decimal amnt = 0;
            String invoiceNo = '';
            for (g_TranItem__c tI: tLst[0].Items__r) {
                if (tI.itm__r.itm__r.cd__c == 'rgf' || tI.itm__r.itm__r.cd__c == 'ar' || tI.itm__r.itm__r.cd__c == 'kf' || tI.itm__r.itm__r.cd__c == 'inf' || tI.itm__r.itm__r.cd__c == 'dr') amnt = amnt + tI.A__c;
            }
            List < Invoice > listInv = new List < Invoice > ();
            InvoiceInfoList invList = new InvoiceInfoList();
            Invoice inv1 = new Invoice();
            inv1.payMethod = tLst[0].md__c;
            inv1.refNo = tLst[0].Rq__r.name;
            inv1.axsPaymentDate = String.valueOf(tLst[0].dt__c);
            inv1.invDate = String.valueOf(tLst[0].dt__c);
            inv1.invNo = tLst[0].Name;
            inv1.dccaSrId = tLst[0].rq__r.xdei__c;
            inv1.invAmount = String.valueof(amnt);
            listInv.add(inv1);
            invList.inv = listInv;
            wsLst[0].rq_jsn__c = JSON.serialize(invList);
            wsLst[0].res_jsn__c = grqWsDccaInvoiceService.dccaInvoiceCall(wsLst[0].rq_jsn__c);
            if (wsLst[0].res_jsn__c != null && wsLst[0].res_jsn__c != '') {
                grqWsDccaInvoiceService.InvoiceInfoList reqjsRq = (grqWsDccaInvoiceService.InvoiceInfoList) JSON.deserialize(wsLst[0].res_jsn__c, grqWsDccaInvoiceService.InvoiceInfoList.class);
                system.debug('Inv reqjsRq' + reqjsRq);
                if (reqjsRq != null && reqjsRq.inv[0].error == null) {
                    wsLst[0].intsts__c = 'Success';
                } else {
                    wsLst[0].intsts__c = 'Failed';
                }
            } else {
                wsLst[0].intsts__c = 'Failed';
            }
            if (String.isNotBlank(tLst[0].Rq__r.xdei__c) && wsLst[0].intsts__c == 'Success') {
                String rqBody = '{"methodname":"invoiceinformation","data":[{"requestId":"' + tLst[0].Rq__r.xdei__c + '"}]}';
                String respBody = grqWsOnboard.ddaOnbordingInfo(rqBody);
                if (String.isNotBlank(respBody)) {
                    Map < String, Object > results = (Map < String, Object > ) JSON.deserializeUntyped(respBody);
                    invoiceNo = (String) results.get('invoiceNumber');
                    system.debug('invNo:' + invoiceNo);
                    if (String.isNotBlank(invoiceNo)) {
                        List < g_TranItem__c > tiLst = [select id, DDA_Inv_no__c from g_TranItem__c where T__c =: tLst[0].id and itm__r.itm__r.cd__c in ('dr', 'rgf', 'inf', 'kf')];
                        if (tiLst != null && !tiLst.isEmpty()) {
                            for (g_TranItem__c ti: tiLst) ti.DDA_Inv_no__c = invoiceNo;
                            update tiLst;
                        }
                    }
                }
            }
            update wsLst;
        }
    }

    public static void processCRMWOBatch(ws_call__c wsCall) {
        try {
            HttpResponse response = grqWsOnboard.ccrmStatusUpdate(wsCall.rq_jsn__c);
            if (response.getStatusCode() == 200) {
                String respBody = '';
                if (response.getBody() != null) {
                    respBody = response.getBody();
                }
                System.debug('<response.getBody()> : ' + respBody);
                List < grqWsOnboard.RecInfo > recs = (List < grqWsOnboard.RecInfo > ) JSON.deserialize(respBody, List < grqWsOnboard.RecInfo > .class);
                if (recs[0].isSuccess) {
                    wsCall.intsts__c = 'Success';
                } else {
                    wsCall.intsts__c = 'Failed';
                }
                wsCall.res_jsn__c = respBody;
            } else {
                wsCall.intsts__c = 'Failed';
                if (response.getBody() != null) {
                    wsCall.res_jsn__c = response.getBody();
                }
            }
        } catch (exception ex) {
            wsCall.err_msg__c = ex.getMessage() + ' -- ' + ex.getStackTraceString();
            wsCall.intsts__c = 'Failed';
        }
        update wsCall;
    }
    public static void processCRMStsBatch(ws_call__c wsCall) {
        try {
            String reqBody = '';
            grqWsOnboard.StatusUpdate reqJs = new grqWsOnboard.StatusUpdate();
            reqJs.methodName = 'updatedocument';
            List < grqWsOnboard.RecInfo > rqlst = new List < grqWsOnboard.RecInfo > ();
            grqWsOnboard.RecInfo req = new grqWsOnboard.RecInfo();
            req.documentId = wsCall.rq_itm__r.xaf__c; /*if(string.isNotBlank( wsCall.rq_itm__r.RQ__r.xadtx2__c))  req.description =  wsCall.rq_itm__r.RQ__r.xadtx2__c;  else req.description =  wsCall.rq_itm__r.RQ__r.xcn__c; if(wsCall.rq_itm__r.RQ__r.srvc__r.uid__c == '219')     req.objectType =  'Case'; else if(wsCall.rq_itm__r.RQ__r.srvc__r.uid__c == '216' && wsCall.rq_itm__r.itm__r.cd__c == 'nl' )     req.objectType =  'Opportunity'; else req.objectType =  'Quote';*/
            List < Courier_Status__c > stsList = [select id, Courier_Status__c from Courier_Status__c where srvitm__c =: wsCall.rq_itm__r.itm__c and curSTA__c =: wsCall.rq_itm__r.sta__c];
            if (stsList != null && !stsList.isEmpty()) {
                req.status = stsList[0].Courier_Status__c;
            }
            rqlst.add(req);
            reqJs.data = rqlst; /*if(wsCall.rq_itm__r.sta__r.cd__c == 'v' && (wsCall.rq_itm__r.itm__r.cd__c == 'na' || wsCall.rq_itm__r.itm__r.cd__c == 'dr')){ List<grqWsOnboard.ActivityInfo> tActv =new List<grqWsOnboard.ActivityInfo>(); req.accid = wsCall.rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c; req.businessName1=wsCall.rq_itm__r.RQ__r.xcfn__c; req.businessName2=wsCall.rq_itm__r.RQ__r.xcmn__c; req.businessName3=wsCall.rq_itm__r.RQ__r.xcln__c; req.parentCompany = wsCall.rq_itm__r.RQ__r.xccn__c; req.pcRegNo = wsCall.rq_itm__r.RQ__r.rtacn__c; req.nationality = wsCall.rq_itm__r.RQ__r.xcpic__c; if(wsCall.rq_itm__r.RQ__r.xbtnm__c != null){ req.pcDOI = grqwsOnboard.strDate(wsCall.rq_itm__r.RQ__r.xbtnm__c); } if(String.isNotBlank(wsCall.rq_itm__r.RQ__r.xadtx2__c)){ List<grqWsOnboard.SegmentInfo> lst = (List<grqWsOnboard.SegmentInfo>) json.deserialize(wsCall.rq_itm__r.RQ__r.xadtx2__c, List<grqWsOnboard.SegmentInfo>.class); for(grqWsOnboard.SegmentInfo rec : lst){ tActv.addAll(rec.SegActivities); } req.actvities=tActv; } } */
            reqBody = Json.serialize(reqJs);
            System.debug('reqBody: ' + reqBody);
            HttpResponse response = grqWsOnboard.ccrmStatusUpdate(reqBody); /* Http h = new Http(); HttpRequest request     = new HttpRequest(); HttpResponse response   = new HttpResponse(); request.setHeader('Content-Type','application/json'); request.setHeader('accept','application/json'); request.setEndpoint('callout:TECOM_QA/apexrest/statusUpdate'); request.setTimeout(90000);request.setMethod('POST'); request.setBody(reqBody); response = h.send(request);*/
            if (response.getStatusCode() == 200) {
                String respBody = '';
                if (response.getBody() != null) {
                    respBody = response.getBody();
                }
                System.debug('<response.getBody()> : ' + respBody);
                List < grqWsOnboard.RecInfo > recs = (List < grqWsOnboard.RecInfo > ) JSON.deserialize(respBody, List < grqWsOnboard.RecInfo > .class);
                if (recs[0].isSuccess) {
                    wsCall.intsts__c = 'Success';
                } else {
                    wsCall.intsts__c = 'Failed';
                }
            } else {
                wsCall.intsts__c = 'Failed';
                if (response.getBody() != null) {
                    wsCall.res_jsn__c = response.getBody();
                }
            }
        } catch (exception ex) {
            wsCall.err_msg__c = ex.getMessage() + ' -- ' + ex.getStackTraceString();
            wsCall.intsts__c = 'Failed';
        }
        update wsCall;
    }

    public static void exchDocAmdBatch(List < id > wIdLst) {
        system.Debug('wIdLst-----' + wIdLst);
        System.enqueueJob(new OnboardQueueable('uploadDoc', wIdLst));
    }
    public static void processDocAmdBatch(List < Id > wsidLst) {
        for (id wsid: wsidLst) {
            processDocAmdBatchFt(new List < ID > {
                wsid
            });
        }
    }
    @future(callout = true) public static void processDocAmdBatchFt(List < Id > wsidLst) {
        List < ws_call__c > wsLst = new List < ws_call__c > ();
        try {
            System.debug('====wsidLst==' + wsidLst);
            wsLst = [Select rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c, rq_itm__r.RQ__r.xdccaRq__c, rq_itm__r.RQ__r.xdei__c, rq_itm__r.RQ__r.xcamc__c, rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c, rq_itm__r.RQ__r.Service_Code__c, Id, rq_itm__r.RQ__c, rq_itm__c, rq_jsn__c, pmid__c, intsts__c, ws_typ__c, mtd_nm__c from ws_call__c where id =: wsidLst and ws_typ__c = 'DDA Amendments'
                AND intsts__c = 'Ready for Integration'
                AND mtd_nm__c = 'uploadDoc'
            ];
            System.debug('====wsLst==' + wsLst);
            if (wsLst != null && !wsLst.isEmpty()) {
                List < g_reqitemDoc__c > docRef = new List < g_reqitemDoc__c > ();
                set < id > rdocs = new Set < id > ();
                for (ws_call__c ws: wsLst) {
                    ws.intsts__c = 'On hold';
                    List < Attachment > attList = new List < Attachment > ();
                    attList = [select id, parentid, parent.name, name, body from Attachment where id =: ws.rq_jsn__c];
                    for (Attachment att: attList) {
                        grqWsOnboard.DocumentInfo doc = new grqWsOnboard.DocumentInfo();
                        doc.recid = ws.pmid__c;
                        doc.accid = ws.rq_itm__r.RQ__r.Acc__r.ccrm_sfid__c;
                        system.debug(' doc.recid::' + doc.recid);
                        if (att.parent.name.contains('Passport Copy')) doc.docName = 'Passport - first page';
                        else if (att.parent.name.contains('Emirates ID - front')) doc.docName = 'Emirates ID - front';
                        else if (att.parent.name.contains('Emirates ID - back')) doc.docName = 'Emirates ID - back';
                        else if (att.parent.name.contains('Visa Page')) doc.docName = 'Visa page';
                        else doc.docName = att.parent.name;
                        doc.fileName = doc.docName + '.pdf';
                        doc.fileBody = EncodingUtil.base64Encode(att.body);
                        String rqBody = Json.serialize(doc);
                        Http h = new Http();
                        HttpRequest request = new HttpRequest();
                        HttpResponse response = new HttpResponse();
                        request.setHeader('Content-Type', 'application/json');
                        request.setHeader('accept', 'application/json');
                        request.setEndpoint('callout:' + Label.CRM_Instance + '/apexrest/createdoc');
                        request.setTimeout(90000);
                        request.setMethod('POST');
                        request.setBody(rqBody);
                        response = h.send(request);
                        system.debug('response:::' + response);
                        if (response.getStatusCode() == 200) {
                            system.debug('res::' + response.getBody());
                            ws.intsts__c = 'Success'; /*if (String.isNotBlank(wsLst[0].rq_itm__r.RQ__r.xcamc__c) && (wsLst[0].rq_itm__r.RQ__r.xcamc__c.contains('Secretary') || wsLst[0].rq_itm__r.RQ__r.xcamc__c.contains('Director') || wsLst[0].rq_itm__r.RQ__r.xcamc__c.contains('Manager')) ){ String woId = ''; String reqJson = '{"methodName":"dfzcsecurity","data":[{"workOrderId":"' + woId + '","ServiceName":"' + ws.rq_itm__r.RQ__r.xcamc__c + '","axsId":"' + ws.rq_itm__r.RQ__c + '","ddaRequestId":"' + ws.rq_itm__r.RQ__r.xdei__c + '","ddaReqNumber":"' + ws.rq_itm__r.RQ__r.xdccaRq__c + '","contactIds":["' + ws.pmid__c + '"],"oraclePartyId":"' + ws.rq_itm__r.RQ__r.Acc__r.ORACLE_PARTY_ID__c + '","status":"Submitted","description":"Any detail about work order"}]}'; ws_call__c wcCloned = new ws_call__c(); wcCloned.rq_itm__c = ws.rq_itm__c; wcCloned.ws_typ__c = 'DDA Amendments'; wcCloned.mtd_nm__c = 'dfzcsecurity'; wcCloned.intsts__c = 'Ready for Integration'; wcCloned.rq_jsn__c = reqJson; HttpResponse response1 =  grqWsOnboard.ccrmStatusUpdate(reqJson); wcCloned.res_jsn__c = response1.getBody(); if(response1.getBody() != null){ String respBody1 = response1.getBody(); List < Object > resLst1 = (List < Object > ) JSON.deserializeUntyped(respBody1); for (Object resrec: resLst1) { Map < String, Object > resMap = (Map < String, Object > ) resrec; woId = (String) resMap.get('workOrderId'); } } wcCloned.intsts__c = 'Success'; insert wcCloned; g_reqitem__c ri = new g_reqitem__c(id = wcCloned.rq_itm__c, ccrmid__c = woId); update ri; }*/
                        } else {
                            ws.intsts__c = 'Failed';
                            ws.err_msg__c = response.getBody();
                        }
                    }
                }
            }
        } catch (exception ex) {
            System.debug('===ex==' + ex);
        }
        update wsLst;
    }
    public static void processInvYardiFineBatch(List < ws_call__c > wsLst) {}
    public static void excLADDADocBatch(List < id > wId) {
        System.debug('====wId===' + wId);
        List < ws_call__c > wslst = [Select Id, pmid__c, adhoc_text1__c, rq_jsn__c, intsts__c, res_jsn__c, rq_itm__r.RQ__c, mtd_nm__c, rq_itm__r.RQ__r.id, rq_itm__r.RQ__r.xdei__c, rq_itm__r.RQ__r.xadtx2__c, rq_itm__r.RQ__r.xadtx3__c from ws_call__c where id =: wId]; /*DDA_id__c,DDA_Amt__c,*/
        DccaBatchUtil.processLAAtts(wslst);
    }
    public static void processLAAtts(List < ws_call__c > wsLst) {
        system.debug(wsLst[0].rq_itm__r.RQ__r.id + '=======' + wsLst[0].adhoc_text1__c);
        String uid = 'NA';
        String docNam = wsLst[0].adhoc_text1__c; /* if(wsLst[0].adhoc_text1__c!=null && (docNam.contains('Passport Copy') || docNam.contains('RIC Form'))){ uid=docNam.replace('Passport Copy - ', ''); uid=docNam.replace('RIC Form - ', ''); uid=uid.deleteWhitespace()+'_11'; } String auid='No'; LARequestWrapper adhoc3Data = (LARequestWrapper)System.JSON.deserialize(wsLst[0].rq_itm__r.RQ__r.xadtx3__c,LARequestWrapper.class); for(LARequestWrapper.Members m :adhoc3Data.serviceRequests[0].members){ String umid =m.firstName+m.lastName+'_11'; if(umid==uid){ auid=m.UID; } } String adh2=wsLst[0].rq_itm__r.RQ__r.xadtx2__c; List<laah2Warp> lsWap = (List<laah2Warp>)System.JSON.deserialize(adh2,List<laah2Warp>.class); for(laah2Warp mp :lsWap){ if(auid==mp.UID){ if(docNam.contains('Passport Copy')){ docNam='Passport Copy'+' '+'-'+' '+mp.firstName+' '+mp.lastName; } if(docNam.contains('RIC Form')){ docNam='RIC Form'+' '+'-'+' '+mp.firstName+' '+mp.lastName; } } } */
        List < g_reqDoc__c > rqDocList = [select id, name, dda_att__c, RQ__r.name from g_reqDoc__c where RQ__c =: wsLst[0].rq_itm__r.RQ__r.id and dda_att__c =: wsLst[0].pmid__c limit 1];
        system.debug('=======' + rqDocList);
        List < Attachment > attLaList = [select id, parentid, parent.name, name, body from Attachment where parentid =: rqDocList[0].id Order by createddate Desc];
        system.debug('=======' + attLaList);
        List < ws_call__c > wsListupd = new List < ws_call__c > (); /*for (ws_call__c ws: wsLst) {*/
        if (wsLst[0].mtd_nm__c == 'LADocs' && attLaList != null) {
            /*and name =: docName*/
            for (Attachment att: attLaList) {
                AttReqWrap reqwrp = new AttReqWrap();
                List < Attachments > attrecList = new List < Attachments > ();
                Attachments attrec = new Attachments();
                attrec.ddaId = rqDocList[0].dda_att__c;
                attrec.fileName = rqDocList[0].name + '.pdf';
                Blob bodyBlob = att.Body;
                String bodyStr = EncodingUtil.base64Encode(bodyBlob);
                attrec.base64Body = bodyStr;
                attrecList.add(attrec);
                reqwrp.attachments = attrecList;
                String reqjs = JSON.serialize(reqwrp);
                system.debug('---reqjs---' + reqjs);
                Http h = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('accept', 'application/json');
                request.setEndpoint('callout:' + Label.LA_DDA_End_Point + '/apexrest/licenseAmendment/insertAttachment');
                request.setTimeout(120000);
                request.setMethod('POST');
                request.setBody(reqjs);
                try {
                    response = h.send(request);
                    if (response.getStatusCode() == 200) {
                        system.debug('Sucess');
                        system.debug('response' + response.getBody());
                        wsLst[0].res_jsn__c = response.getBody();
                        System.debug('response.getBody();' + response.getBody());
                        LAResponseWrapper resJs = (LAResponseWrapper) JSON.deserialize(response.getBody(), LAResponseWrapper.class);
                        system.debug('======JJ' + resJs);
                        if (resJs != null && resJs.isSuccess == true) {
                            wsLst[0].intsts__c = 'Success';
                        } else if (resJs != null && resJs.isSuccess == false) {
                            wsLst[0].intsts__c = 'Failed';
                            wsLst[0].err_msg__c = JSON.serialize(resJs.message);
                        } else {
                            wsLst[0].intsts__c = 'Failed';
                            wsLst[0].err_msg__c = response.getBody();
                        }
                    } else {
                        wsLst[0].intsts__c = 'Failed';
                        wsLst[0].err_msg__c = response.getBody();
                    }
                } catch (System.CalloutException e) {
                    wsLst[0].res_jsn__c = String.ValueOF(e);
                    wsLst[0].intsts__c = 'Failed';
                }
                wsListupd.add(wsLst[0]);
                update wsListupd;
            }
        }
    }
    public static void processDocBatch(List < ws_call__c > scope) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        List < Id > rqId = new List < Id > ();
        List < Id > rqId2 = new List < Id > ();
        List < g_Req__c > rqList = new List < g_Req__c > ();
        grqWsDccaGetService.AttachList mainattlist = new grqWsDccaGetService.AttachList();
        list < grqWsDccaGetService.Attachments > grattList = new list < grqWsDccaGetService.Attachments > ();
        String newjson;
        Map < String, attachment > rqAttchment = new Map < String, attachment > ();
        Map < String, List < attachment >> rqListAttchment = new Map < String, List < attachment >> ();
        Map < Id, attachment > rqDocAttchment = new Map < Id, attachment > ();
        Map < Id, List < attachment >> rqDocListAttchment = new Map < Id, List < attachment >> ();
        String jsonBody;
        Set < g_Req__c > updrqList = new Set < g_Req__c > ();
        for (ws_call__c ws: scope) {
            rqId.add(ws.rq_itm__r.RQ__r.Id); /*/&& ws.rq_itm__r.RQ__r.xmloc__c == false */
            if (ws.mtd_nm__c == 'LicenseRenewalDoc' || ws.mtd_nm__c == 'auditFormDocs' || ws.mtd_nm__c == 'membersDocs') {
                rqId2.add(ws.rq_itm__r.RQ__r.Id);
            } /**  if(ws.mtd_nm__c == 'LicenseRenewalCopy'  ){  }**/
        }
        if (rqId2 != null && rqId2.size() > 0) {
            List < g_reqDoc__c > redDocList = [Select Id, Name, RQ__c from g_reqDoc__c where RQ__c in: rqId2];
            List < attachment > attList = [Select Id, Name, Body, parentId From attachment where parentId in: redDocList ORDER BY CreatedDate DESC]; /*/order by CreatedDate desc limit 1 */
            for (attachment att: attList) {
                if (rqDocListAttchment.containsKey(att.parentId)) {
                    List < attachment > attmtList = new List < attachment > ();
                    attmtList = rqDocListAttchment.get(att.parentId);
                    attmtList.add(att);
                    rqDocListAttchment.put(att.parentId, attmtList);
                } else {
                    rqDocListAttchment.put(att.parentId, new List < attachment > {
                        att
                    });
                } /*/ rqDocAttchment.put(att.parentId,att); */
            }
            system.debug('rqDocListAttchment' + rqDocListAttchment);
            for (g_reqDoc__c rqDc: redDocList) {
                /*/ If(rqDocAttchment.containsKey(rqDc.Id)){ */
                If(rqDocListAttchment.containsKey(rqDc.Id)) {
                    /**  attachment att = new attachment(); att = rqDocAttchment.get(rqDc.Id);**/
                    List < attachment > attLstNew = new List < attachment > ();
                    if (rqDocListAttchment.containsKey(rqDc.Id)) attLstNew = rqDocListAttchment.get(rqDc.Id);
                    rqListAttchment.put(String.ValueOf(rqDc.RQ__c + '_' + rqDc.Name), attLstNew); /*/  rqAttchment.put(String.ValueOf(rqDc.RQ__c+'_'+rqDc.Name),att); */
                }
            }
        }
        system.debug('rqListAttchment' + rqListAttchment);
        map < ID, List < attachment >> docListMap = new map < Id, List < attachment >> ();
        List < g_Req__c > reqDocList = new List < g_Req__c > ();
        List < attachment > attList = [Select Id, Name, Body, parentId From attachment where parentId in: rqId ORDER BY CreatedDate DESC limit 1];
        for (attachment att: attList) {
            List < attachment > attList1 = new List < attachment > ();
            attList1.add(att);
            docListMap.put(att.parentId, attList1);
            system.debug('--docListMap--' + docListMap);
        }
        for (ws_call__c ws: scope) {
            grqWsDccaGetServiceBatch.AttachList reqjsRq = (grqWsDccaGetServiceBatch.AttachList) JSON.deserialize(ws.rq_jsn__c, grqWsDccaGetServiceBatch.AttachList.class); /*/system.debug('Doc'+docListMap.get(ws.rq_itm__r.RQ__r.Id)[0].Body); */
            if (ws.mtd_nm__c == 'LicenseRenewalDoc' || ws.mtd_nm__c == 'auditFormDocs' || ws.mtd_nm__c == 'membersDocs') {
                grattList = new list < grqWsDccaGetService.Attachments > ();
                String attStr = ws.rq_itm__r.RQ__r.Id + '_' + reqjsRq.AttachmentList[0].Name; /**  If(rqAttchment.containsKey(attStr)){ reqjsRq.AttachmentList[0].attachmentBody =EncodingUtil.base64Encode(rqAttchment.get(attStr).Body); reqjsRq.AttachmentList[0].Name =rqAttchment.get(attStr).Name;}**/
                system.debug('attStr::' + attStr);
                If(rqListAttchment.containsKey(attStr)) {
                    List < attachment > listattNew = new List < attachment > ();
                    if (ws.mtd_nm__c == 'membersDocs') listattNew.add(rqListAttchment.get(attStr)[0]);
                    else listattNew = rqListAttchment.get(attStr);
                    integer i = 0;
                    for (attachment att: listattNew) {
                        grqWsDccaGetService.Attachments attIn = new grqWsDccaGetService.Attachments();
                        attIn.parentId = reqjsRq.AttachmentList[0].parentId;
                        attIn.Name = att.Name;
                        if (String.isNotBlank(ws.DDA_id__c)) attIn.parentId = ws.DDA_id__c;
                        attIn.attachmentBody = EncodingUtil.base64Encode(att.Body);
                        grattList.add(attIn);
                        system.debug('grattList' + grattList.size()); /*// reqjsRq.AttachmentList[i].attachmentBody =EncodingUtil.base64Encode(att.Body); // i++; */
                    }
                    mainattlist.AttachmentList = grattList;
                    newjson = JSON.serialize(mainattlist);
                }
                system.debug('newjson' + newjson);
            } else {
                system.debug('In Else condition today');
                If(docListMap.containsKey(ws.rq_itm__r.RQ__r.Id)) reqjsRq.AttachmentList[0].attachmentBody = EncodingUtil.base64Encode(docListMap.get(ws.rq_itm__r.RQ__r.Id)[0].Body);
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
            } else {
                request.setBody(newjson);
            }
            try {
                response = h.send(request);
                ws.res_jsn__c = response.getBody();
                if (response.getStatusCode() == 200) {
                    system.debug('Sucess');
                    system.debug('response' + response.getBody());
                    ws.res_jsn__c = response.getBody();
                    System.debug('response.getBody();' + response.getBody());
                    grqWsDccaGetServiceBatch.AttachList resJs = (grqWsDccaGetServiceBatch.AttachList) JSON.deserialize(response.getBody(), grqWsDccaGetServiceBatch.AttachList.class);
                    if (resJs != null && resJs.AttachmentList[0].messagecode == '0') {
                        ws.intsts__c = 'Success';
                        if (ws.mtd_nm__c == 'LicenseRenewalCopy') {
                            g_Req__c rqnxt = new g_Req__c();
                            rqnxt.id = ws.rq_itm__r.RQ__r.Id;
                            rqnxt.xlicd__c = true;
                            system.debug('rqnxt' + rqnxt);
                            updrqList.add(rqnxt);
                        }
                    } else {
                        ws.intsts__c = 'Failed';
                        ws.err_msg__c = resJs.AttachmentList[0].message;
                    }
                } else {
                    ws.intsts__c = 'Failed';
                    ws.err_msg__c = response.getBody();
                }
            } catch (System.CalloutException e) {
                ws.res_jsn__c = String.ValueOF(e);
                ws.intsts__c = 'Failed';
            }
            wsList.add(ws);
        }
        if (updrqList != null && updrqList.size() > 0) {
            List < g_Req__c > lst = new List < g_Req__c > ();
            lst.addAll(updrqList);
            update lst;
        }
        if (wsList != null && wsList.size() > 0) {
            Update wsList;
        }
    }
    public static void processInvFineBatch(List < ws_call__c > wsLst) {
        List < ws_call__c > finalList = new List < ws_call__c > ();
        List < ws_call__c > wsfine = new List < ws_call__c > ();
        Boolean fineflag = false;
        String invoiceNo = '';
        List < ws_call__c > wsInvoice = new List < ws_call__c > ();
        List < ws_call__c > newwsInvoice = new List < ws_call__c > ();
        Map < String, ws_call__c > invMap = new Map < String, ws_call__c > ();
        Map < String, ws_call__c > fineMap = new Map < String, ws_call__c > ();
        Id rqitmid = null;
        g_Tran__c t = null;
        List < id > rqIds = new List < id > ();
        Map < id, id > rqItmap = new Map < id, id > ();
        for (ws_call__c ws: wsLst) {
            if (ws.mtd_nm__c == 'InvoiceCreation') {
                rqIds.add(ws.rq_itm__r.RQ__c);
                rqItmap.put(ws.rq_itm__r.RQ__c, ws.rq_itm__c);
                wsInvoice.add(ws);
                invMap.put(ws.xrno__c, ws);
                rqitmid = ws.rq_itm__c;
            }
        }
        if (wsInvoice != null && wsInvoice.size() > 0 && (wsfine.isEmpty() && fineflag == false)) {
            newwsInvoice.addAll(invMap.values());
            system.debug('newwsInvoice===' + newwsInvoice);
            for (ws_call__c ws: newwsInvoice) {
                /*/wsInvoice */
                t = [select id, Name, Rq__c, Rq__r.xdei__c, RQ__r.xmamd__c, Rq__r.name, md__c, dt__c, rq__r.srvc__r.uid__c from g_Tran__c where RQ__r.Name =: ws.xrno__c and tp__c = 'Payment'
                    and STA__c = 'Completed'
                ][0];
                List < Invoice > listInv = new List < Invoice > ();
                InvoiceInfoList invList = new InvoiceInfoList();
                Invoice inv1 = new Invoice();
                inv1.payMethod = t.md__c;
                inv1.refNo = t.Rq__r.name;
                inv1.axsPaymentDate = String.valueOf(t.dt__c);
                inv1.invDate = String.valueOf(t.dt__c);
                inv1.invNo = t.Name;
                inv1.dccaSrId = ws.DDA_id__c;
                if (t.rq__r.srvc__r.uid__c == '322') {
                    Decimal invAmt = 0;
                    for (g_TranItem__c ti: [select id, A__c from g_TranItem__c where T__c =: t.id and itm__r.itm__r.cd__c in ('frl', 'act', 'kf', 'erf', 'inf')]) invAmt = invAmt + ti.A__c;
                    inv1.invAmount = String.valueof(invAmt);
                } else inv1.invAmount = String.valueof(ws.DDA_Amt__c);
                listInv.add(inv1);
                invList.inv = listInv;
                ws.rq_jsn__c = JSON.serialize(invList);
                ws.res_jsn__c = grqWsDccaInvoiceService.dccaInvoiceCall(ws.rq_jsn__c);
                if (ws.res_jsn__c != null && ws.res_jsn__c != '') {
                    grqWsDccaInvoiceService.InvoiceInfoList reqjsRq = (grqWsDccaInvoiceService.InvoiceInfoList) JSON.deserialize(ws.res_jsn__c, grqWsDccaInvoiceService.InvoiceInfoList.class);
                    system.debug('Inv reqjsRq' + reqjsRq);
                    if (reqjsRq != null && reqjsRq.inv[0].error == null) {
                        ws.intsts__c = 'Success';
                    } else {
                        ws.intsts__c = 'Failed';
                    }
                } else {
                    ws.intsts__c = 'Failed';
                }
                finalList.add(ws);
            }
        }
        if (t != null && t.rq__r.srvc__r.uid__c != '320' && finalList != null && finalList.size() > 0 && finalList[0].intsts__c == 'Success') {
            if (String.isNotBlank(t.Rq__r.xdei__c)) {
                String rqBody = '{"methodname":"invoiceinformation","data":[{"requestId":"' + t.Rq__r.xdei__c + '"}]}';
                String respBody = grqWsOnboard.ddaOnbordingInfo(rqBody);
                if (String.isNotBlank(respBody)) {
                    Map < String, Object > results = (Map < String, Object > ) JSON.deserializeUntyped(respBody);
                    invoiceNo = (String) results.get('invoiceNumber');
                    system.debug('invNo:' + invoiceNo);
                }
            }
            if (t.rq__r.srvc__r.uid__c != '208' || (t.rq__r.srvc__r.uid__c == '208' && t.RQ__r.xmamd__c != null && t.RQ__r.xmamd__c)) {
                List < ws_call__c > stsBatchlst = new List < ws_call__c > ();
                for (ws_call__c ws: [Select Id, err_cd__c, DDA_id__c, pmid__c, xwsc__c, intsts__c, rq_itm__r.STA__r.exsyst__c, rq_itm__r.itm__r.rv__c, rq_itm__r.itm__r.dcca_refId__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Name, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.RQ__r.Acc__r.id, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.itm__r.dcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.xdei__c, rq_itm__r.RQ__r.xdmpn__c, rq_itm__r.RQ__r.xvn__c, rq_itm__r.RQ__r.xvnum__c from ws_call__c where rq_itm__c =: rqitmid and ws_typ__c = 'DCCA update status'
                        and mtd_nm__c in ('dccaUpdStatus', 'dccaRegOff')
                    ]) stsBatchlst.add(ws);
                if (stsBatchlst != null && !stsBatchlst.isEmpty()) {
                    List < ws_call__c > stsBatchRes = processStsBatch(stsBatchlst);
                    finalList.addAll(stsBatchRes);
                }
            }
        }
        if (finalList != null && finalList.size() > 0) {
            update finalList;
        }
        if (String.isNotBlank(invoiceNo)) {
            List < g_TranItem__c > tiLst = [select id, DDA_Inv_no__c from g_TranItem__c where T__c =: t.id and itm__r.itm__r.cd__c not in ('tsf', 'ec', 'psf')];
            if (tiLst != null && !tiLst.isEmpty()) {
                for (g_TranItem__c ti: tiLst) ti.DDA_Inv_no__c = invoiceNo;
                update tiLst;
            }
        }
        List < ws_call__c > docswsList = new List < ws_call__c > ();
        List < g_Req__c > lstreq = new List < g_Req__c > ();
        lstreq = [Select id, Name, Acc__c, Acc__r.lc__c, srvc__c, xadtx4__c, (select id from Items__r where itm__r.cd__c IN('ddd')), (select id, name, lbl__c, dda_att__c, RQ__r.name from rDocs__r where Req__c = true) from g_Req__c where id in: rqIds];
        system.debug('====lstreq===' + lstreq);
        if (lstreq != null && !lstreq.isEmpty() && lstreq != null && lstreq[0].rDocs__r != null) {
            for (g_reqDoc__c rqDoc: lstreq[0].rDocs__r) {
                ws_call__c wc = new ws_call__c();
                wc.rq_itm__c = lstreq[0].Items__r[0].id;
                wc.ws_typ__c = 'License Amendments';
                wc.mtd_nm__c = 'LADocs';
                wc.intsts__c = 'Ready for Integration';
                wc.adhoc_text1__c = !string.isblank(rqDoc.lbl__c) ? rqDoc.lbl__c : rqDoc.name;
                wc.pmid__c = rqDoc.dda_att__c;
                docswsList.add(wc);
                system.debug('***####################***' + docswsList);
            }
        }
        if (docswsList != null && docswsList.size() > 0) insert docswsList;
        system.debug('***####################***' + docswsList);
        
    }
    public static void ladocsevnt(list < LADocs__e > news) {
        for (LADocs__e ladd: news) {
            List < id > laddList = new List < id > ();
            laddList.add(ladd.wsid__c);
            System.enqueueJob(new OnboardQueueable('uploadAMDDoc', laddList));
        }
    }
    public static void processSancBatch(List < ws_call__c > scope) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        for (ws_call__c ws: scope) {
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept', 'application/json');
            request.setEndpoint('callout:DCCA_Auth/apexrest/createSanction/');
            request.setTimeout(120000);
            request.setMethod('POST');
            request.setBody(ws.rq_jsn__c); /*/jsonBody */
            try {
                response = h.send(request);
                if (response.getStatusCode() == 200) {
                    ws.intsts__c = 'Success';
                    ws.res_jsn__c = response.getBody();
                } else {
                    ws.res_jsn__c = response.getBody();
                    ws.intsts__c = 'Failed';
                }
            } catch (System.CalloutException e) {
                System.debug('Callout error: ' + e);
                ws.res_jsn__c = String.ValueOF(e);
                ws.intsts__c = 'Failed';
            }
            wsList.add(ws);
        }
        Update wsList;
    }
    public static void dccaLtAprovalBatch(List < ws_call__c > scope) {
        List < g_reqitem__c > rqItemList = new List < g_reqitem__c > ();
        List < g_srvcitm_Status__c > stsList = [select id from g_srvcitm_Status__c where itm__r.cd__c = 'ma'
            and cd__c =: 'ok'
            limit 1
        ];
        List < ws_call__c > wsList = new List < ws_call__c > ();
        List < ws_call__c > wsDocList = new List < ws_call__c > ();
        List < Id > rgItmId = new List < Id > ();
        List < g_Req__c > rqList = new List < g_Req__c > ();
        map < Id, String > mbrIdMap = new map < Id, String > ();
        map < Id, String > rqItmDocReq = new map < Id, String > ();
        map < Id, String > rqIdMap = new map < Id, String > ();
        boolean sucflag;
        List < Id > regList = new List < Id > ();
        map < Id, Attachment > regMap = new map < Id, Attachment > ();
        for (ws_call__c ws: scope) {
            if (String.isNotBlank(ws.mtd_nm__c) && ws.mtd_nm__c != 'auditform' && ws.mtd_nm__c != 'membersUpd') {
                regList.add(ws.rq_itm__r.RQ__r.Id);
            }
        }
        if (regList != null && !regList.isEmpty()) {
            List < Attachment > attList = [Select Id, Body, Description, Name, ParentId from Attachment where ParentId in: regList];
            for (Attachment a: attList) {
                regMap.put(a.ParentId, a);
            }
        }
        for (ws_call__c ws: scope) {
            if (ws.intsts__c == 'Ready for Integration') {
                grqWsDcca.serviceRequest reqjsRq = (grqWsDcca.serviceRequest) JSON.deserialize(ws.rq_jsn__c, grqWsDcca.serviceRequest.class);
                reqjsRq.serviceRequest[0].service = ws.rq_itm__r.itm__r.dcca_refId__c;
                if (regMap != null && regMap.get(ws.rq_itm__r.RQ__r.Id) != null && (ws.mtd_nm__c != 'dccaApproval' && ws.mtd_nm__c != 'uploadDoc' && ws.mtd_nm__c != 'auditform' && ws.mtd_nm__c != 'membersUpd')) {
                    reqjsRq.serviceRequest[0].attach = EncodingUtil.base64Encode(regMap.get(ws.rq_itm__r.RQ__r.Id).Body);
                }
                if (String.isNotBlank(ws.mtd_nm__c) && ws.mtd_nm__c == 'auditform' && String.isNotBlank(ws.rq_itm__r.RQ__r.xadtx1__c)) {
                    grqWsDcca.AuditInfo ad = (grqWsDcca.AuditInfo) JSON.deserialize(ws.rq_itm__r.RQ__r.xadtx1__c, grqWsDcca.AuditInfo.class);
                    reqjsRq.serviceRequest[0].auditedData = ad;
                    reqjsRq.serviceRequest[0].service = 'Submission of Annual Financial Statement';
                } else if (String.isNotBlank(ws.mtd_nm__c) && ws.mtd_nm__c == 'membersUpd') {
                    reqjsRq.serviceRequest[0].service = 'CPU';
                }
                system.debug('JJ 123' + ws.rq_itm__r.RQ__r.Acc__r.lc__c);
                if (reqjsRq.serviceRequest[0].licenseNo == null) {
                    reqjsRq.serviceRequest[0].licenseNo = ws.rq_itm__r.RQ__r.Acc__r.lc__c;
                }
                if (reqjsRq.serviceRequest[0].refAXS == null) {
                    reqjsRq.serviceRequest[0].refAXS = ws.rq_itm__r.RQ__r.Name;
                }
                if (reqjsRq.serviceRequest[0].extAXS == null) {
                    reqjsRq.serviceRequest[0].extAXS = ws.rq_itm__r.RQ__r.Id;
                }
                String jsonBody = JSON.serialize(reqjsRq);
                system.debug('jsonBody:' + jsonBody);
                if (ws.mtd_nm__c == 'dccaApproval') {
                    mbrIdMap.put(ws.rq_itm__r.Id, ws.rq_itm__r.RQ__c);
                    rgItmId.add(ws.rq_itm__r.Id);
                    rqItmDocReq.put(ws.rq_itm__r.Id, ws.rq_itm__r.itm__r.dcr__c);
                    rqIdMap.put(ws.rq_itm__r.Id, ws.rq_itm__r.RQ__r.Id);
                    system.debug('rqItmDocReq' + rqItmDocReq);
                }
                Http h = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('accept', 'application/json');
                request.setEndpoint('callout:DCCA_Auth/apexrest/createServiceRequest/'); /*/services/data/v39.0 */
                request.setTimeout(120000);
                request.setMethod('POST');
                request.setBody(jsonBody);
                try {
                    response = h.send(request);
                    if (response.getStatusCode() == 200) {
                        system.debug('Sucess');
                        sucflag = true;
                        system.debug('response' + response.getBody());
                        ws.rq_jsn__c = jsonBody;
                        ws.res_jsn__c = response.getBody();
                        grqWsDcca.serviceRequest resSrRq = (grqWsDcca.serviceRequest) JSON.deserialize(response.getBody(), grqWsDcca.serviceRequest.class);
                        System.debug('Response sucess' + resSrRq.serviceRequest[0]);
                        if (resSrRq.serviceRequest[0].isSucces == true) {
                            System.debug('Inside sucess' + resSrRq.serviceRequest[0].isSucces);
                            ws.intsts__c = 'Success';
                            if (resSrRq.serviceRequest[0].dccapermtNo != null) {
                                g_Req__c rq = new g_Req__c();
                                rq.id = ws.rq_itm__r.RQ__r.Id;
                                if (ws.mtd_nm__c == 'auditform' || ws.mtd_nm__c == 'membersUpd') {
                                    rq.xdei__c = resSrRq.serviceRequest[0].dccapermtNo;
                                    if (ws.mtd_nm__c == 'auditform' || (ws.mtd_nm__c == 'membersUpd' && resSrRq.serviceRequest[0].status == 'Request Completed - Information Updated')) {
                                        if (ws.mtd_nm__c == 'membersUpd') {
                                            g_reqitem__c ri = new g_reqitem__c(id = ws.rq_itm__c, sta__c = stsList[0].id);
                                            rqItemList.add(ri);
                                        }
                                        rq.STA__c = 'Completed';
                                        rq.xadtx4__c = reqjsRq.serviceRequest[0].cFRNotes;
                                    }
                                    if (ws.mtd_nm__c == 'membersUpd') {
                                        gU.initiateDocumentUploadOIC(rq, 'ddaupload', 'Child'); /* PJ */
                                    } else if (ws.mtd_nm__c == 'auditform') {
                                        gU.initiateDocumentUploadOIC(rq, 'ddaupload', 'Parent');
                                    } else {
                                        List < g_reqDoc__c > reqDocNameList = [select Id, Name, RQ__c, RQ__r.xdei__c from g_reqDoc__c where RQ__c =: rq.id AND(Req__c = true or ats__c > 0) and IsDeleted = false];
                                        if (reqDocNameList != null && !reqDocNameList.isEmpty()) {
                                            for (g_reqDoc__c rdoc: reqDocNameList) {
                                                grqWsDccaGetService.AttachList attList = new grqWsDccaGetService.AttachList();
                                                List < grqWsDccaGetService.Attachments > attrecList = new List < grqWsDccaGetService.Attachments > ();
                                                grqWsDccaGetService.Attachments attrec = new grqWsDccaGetService.Attachments();
                                                attrec.parentId = rq.xdei__c;
                                                attrec.Name = rdoc.name;
                                                attrecList.add(attrec);
                                                attList.AttachmentList = attrecList;
                                                String reqjs = JSON.serialize(attList);
                                                ws_call__c docws = new ws_call__c();
                                                docws.ws_typ__c = 'DCCA Letters';
                                                docws.mtd_nm__c = (ws.mtd_nm__c == 'auditform' ? 'auditFormDocs' : 'membersDocs');
                                                docws.rq_itm__c = ws.rq_itm__c;
                                                docws.intsts__c = 'Ready for Integration';
                                                docws.rq_jsn__c = reqjs;
                                                wsDocList.add(docws);
                                            }
                                        }
                                    }
                                } else rq.xdmpn__c = resSrRq.serviceRequest[0].dccapermtNo;
                                rqList.add(rq);
                            }
                        } else {
                            System.debug('Inside failed' + resSrRq.serviceRequest[0].isSucces);
                            ws.intsts__c = 'Failed';
                            ws.err_msg__c = resSrRq.serviceRequest[0].errorMessage;
                        }
                    } else {
                        ws.intsts__c = 'Failed';
                        ws.err_msg__c = response.getBody();
                    }
                } catch (System.CalloutException e) {
                    System.debug('Callout error: ' + e);
                    ws.res_jsn__c = String.ValueOF(e);
                    ws.intsts__c = 'Failed';
                    sucflag = false;
                } /*//  } */
                wsList.add(ws);
            }
        }
        Update wsList;
        if (wsDocList != null && !wsDocList.isEmpty()) insert wsDocList;
        system.debug('Before Calling Upload' + rqItmDocReq);
        if (rqItemList != null && rqItemList.size() > 0) {
            update rqItemList;
        }
        if (rqList != null && rqList.size() > 0) {
            Update rqList;
        }
        if (wsList != null && rqItmDocReq != null) {
            if (wsList.size() > 0 && rqItmDocReq.size() > 0 && sucflag == true) {
                grqWsDocInsH.uploadLetterDoc(rgItmId, mbrIdMap, rqItmDocReq, rqIdMap, 'DCCA Letters', 'uploadDoc');
            }
        }
    }
    public class InvoiceInfoList {
        public List < Invoice > inv {
            set;
            get;
        }
    }
    public class Invoice {
        public string invNo {
            set;
            get;
        }
        public string invAmount {
            set;
            get;
        }
        public string payMethod {
            set;
            get;
        }
        public string refNo {
            set;
            get;
        }
        public string dccaSrId {
            set;
            get;
        }
        public string error {
            set;
            get;
        }
        public string axsPaymentDate {
            set;
            get;
        }
        public string invDate {
            set;
            get;
        }
    }
    public class serviceRequest {
        public List < serviceReq > reqs;
    }
    public class serviceReq {
        public String SRN, AWB, status, delStatus, timeStamp, acName, conName, oracleId, docType, refMobile, delZone, bldngName, delLoc, notes, axsReqId, noCheques, agNo;
    }
    public static void processCPUReqs(List < id > wsLst) {
        Map < String, mdWrapper.IdentityInfo > infoListMap = new Map < String, mdWrapper.IdentityInfo > ();
        List < ws_call__c > wscpulist = [Select Id, name, rq_jsn__c, res_jsn__c, pmid__c, Rq_email__c from ws_call__c where id in: wsLst];
        List < mdWrapper > mdList = new List < mdWrapper > ();
        mdList = (List < mdWrapper > ) System.JSON.deserialize(wscpulist[0].res_jsn__c, List < mdWrapper > .class);
        List < g_req__c > cpuList = new List < g_req__c > ();
        List < Account > accList = [select id from account where lc__c =: wscpulist[0].pmid__c];
        List < g_srvc__c > umaList = [select id from g_srvc__c where uid__c = 'uma'
            limit 1
        ];
        for (mdWrapper obj: mdList) {
            for (mdWrapper.IdentityInfo info: obj.IdentityInfo) {
                String identityId = info.identityId;
                if (!infoListMap.containsKey(identityId) && (info.passportInfo.isExpired || info.emiratesIdInfo.isExpired || string.isblank(info.contactDetail.emailAddress) || string.isblank(info.contactDetail.mobileNumber))) {
                    infoListMap.put(identityId, info);
                    g_req__c req = new g_req__c(srvc__c = umaList[0].id, xave__c = wscpulist[0].Rq_email__c, Acc__c = accList[0].id, sta__c = 'Draft', UBO_File_Name__c = identityId, xadtx4__c = JSON.serialize(infoListMap.get(identityId)));
                    cpuList.add(req);
                }
            }
        }
        if (cpuList != null && !cpuList.isEmpty()) insert cpuList;
    }

    public class LAResponseWrapper {
        public List < SrList > srList;
        public String message;
        public Boolean isSuccess;
    }
    public class SrActivities {
        public String segmentName;
        public Integer noOfTitleAndChannels;
        public String name;
        public Boolean isRelatedtoTitles;
        public Boolean isRelatedtoChannel;
        public String ddaId;
        public List < ChannelTitles > channelTitles;
    }

    public class SrList {
        public Decimal totalUnpaidAmount;
        public Decimal totalPaidAmount;
        public Decimal totalAmount;
        public Decimal statusCode;
        public String srStatus;
        public List < SrMembers > srMembers;
        public List < SrMembers > srFines;
        public List < SrFees > srFees;
        public List < SrAttachments > srAttachments;
        public List < SrActivities > srActivities;
        public String reqNo;
        public String reqId;
        public String message;
        public String axsRefNo;
        public String serviceName;
    }


    public class ChannelTitles {
        public String targetedAudience;
        public String requestType;
        public String printingCompany;
        public String name;
        public String licensedTitleChannelDdaId;
        public String languages;
        public String isOnAir;
        public Boolean isNameConfirmed;
        public Boolean isApprovedByNMC;
        public Boolean isActive;
        public String genre;
        public String frequency;
        public String distributionType;
        public String distributionCompany;
        public String background;
        public String areaOfDistribution;
        public String arabicName;
        public String approvalStatus;
    }

    public class SrAttachments {
        public String relationName;
        public String name;
        public Boolean isMandatory;
        public String ddaId;
    }
    public class SrFees {
        public Decimal waivedAmount;
        public String feeType;
        public String axsServItemName;
        public String comments;
        public Decimal basicAmount;
        public Decimal amount;
    }

    public class SrMembers {}
    public class AttReqWrap {
        public List < Attachments > attachments;
    }
    public class Attachments {
        public String fileName;
        public String ddaId;
        public String base64Body;
    }
    public class laah2Warp {
        public String firstName;
        public String lastName;
        public String action;
        public String UID;
        public String ppNum;
    }
    public static void exchOICDocUpload(List < id > wsOICUploadIds) {
        System.enqueueJob(new OnboardQueueable('axesToCCRMDDADocUpload', wsOICUploadIds));
    }
    public static void processOICDocUpload(List < ws_call__c > wsCallRecords) {
        String reqBody = '[';
        Http httpIns = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:OIC_Integration_PROD/AXS_DDA_OR_CCRM_UPLOA_ATTAC/2.0/uploadattachments');
        request.setTimeout(120000);
        request.setMethod('POST');
        List < ws_call__c > wsRecordToUpdate = new List < ws_call__c > ();
        for (ws_call__c ws: wsCallRecords) {
            if (reqBody.length() == 1) {
                reqBody += '{"id":"' + ws.Id + '"}';
            } else {
                reqBody += ',{"id":"' + ws.Id + '"}';
            }
        }
        try {
            reqBody += ']';
            System.debug('reqBody :' + reqBody);
            request.setBody(reqBody);
            System.debug('## processOICDocUpload response  ##:' + request.getBody());
            response = httpIns.send(request);
            System.debug('## processOICDocUpload response  ##:' + response);
            if (response.getStatusCode() != 200 && response.getStatusCode() != 202) {
                for (ws_call__c ws: wsCallRecords) {
                    ws.res_jsn__c = response.getBody();
                    ws.intsts__c = 'Failed';
                    wsRecordToUpdate.add(ws);
                }
            }
        } catch (System.CalloutException e) {
            for (ws_call__c ws: wsCallRecords) {
                ws.res_jsn__c = String.ValueOF(e);
                ws.intsts__c = 'Failed';
                wsRecordToUpdate.add(ws);
            }
        }
        if (wsRecordToUpdate.size() > 0) {
            update wsRecordToUpdate;
        }
    }

    public static void createLeaseRenewalRequest(ws_call__c wsRecord) {
        Map < String, Object > data = (Map < String, Object > ) JSON.deserializeUntyped(wsRecord.res_jsn__c);
        String requestId = (String) data.get('requestId');
        String axsAccId = (String) data.get('axsAccId');
        String renewalOppId = (String) data.get('renewalOppId');
        String ccrmAccId = (String) data.get('ccrmAccId');
        String jsonAcc = BatchOnboardFetchAccInfo.getCCRMAccountInfo(ccrmAccId);
        ws_call__c wsCallRec = new ws_call__c(pmid__c = axsAccId, ws_typ__c = 'LeaseRenewal', mtd_nm__c = 'fetchAccountInfo', rq_jsn__c = jsonAcc, intsts__c = String.isNotBlank(jsonAcc) ? 'Ready for Integration' : 'Failed', err_msg__c = String.isBlank(jsonAcc) ? 'Response <jsonAcc> is blank' : null);
        insert wsCallRec;
        if (wsCallRec.intsts__c == 'Ready for Integration') {
            LeaseRenewalFetchAccInfo.fetchAccInfo(wsCallRec, renewalOppId, requestId);
            wsRecord.intsts__c = 'Success';
            update wsRecord;
        }
    }

    public static void fetchAccountInfoFromCCRM(string ccrmAccId, Id reqId, Id reqAccId, String renewalOppId) {
        String jsonAcc = BatchOnboardFetchAccInfo.getCCRMAccountInfo(ccrmAccId);
        ws_call__c wsCallRec = new ws_call__c(pmid__c = reqAccId, ws_typ__c = 'LeaseRenewal', mtd_nm__c = 'fetchAccountInfo', rq_jsn__c = jsonAcc, intsts__c = String.isNotBlank(jsonAcc) ? 'Ready for Integration' : 'Failed', err_msg__c = String.isBlank(jsonAcc) ? 'Response <jsonAcc> is blank' : null);
        insert wsCallRec;
        if (wsCallRec.intsts__c == 'Ready for Integration') {
            LeaseRenewalFetchAccInfo.fetchAccInfo(wsCallRec, renewalOppId, reqId);
        }
    }
}