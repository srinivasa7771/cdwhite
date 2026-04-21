global class dccaStatusUpdBatch implements Database.Batchable < sObject > , Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        string type = 'DCCA update status'; //AND mtd_nm__c = \'dccaServiceRq\'
        String query = 'Select Id, err_cd__c, pmid__c, xwsc__c, intsts__c, rq_itm__r.STA__r.exsyst__c, rq_itm__r.itm__r.rv__c, rq_itm__r.itm__r.dcca_refId__c, err_msg__c, mtd_nm__c, rq_itm__c, rq_itm__r.id, rq_itm__r.itm__r.id, rq_itm__r.RQ__r.Id, rq_itm__r.RQ__r.Name, rq_itm__r.RQ__r.Acc__r.lc__c, rq_itm__r.RQ__r.Acc__r.id, rq_itm__r.RQ__r.Con__r.Id, rq_itm__r.STA__r.Next_Status__c, rq_itm__r.STA__r.Next_Status__r.rqSTA__c, is_pro__c, rq_jsn__c, res_jsn__c, uid__c, ws_typ__c, rq_itm__r.itm__r.dcr__c, rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.xdei__c, rq_itm__r.RQ__r.xdmpn__c from ws_call__c where ws_typ__c = :type  AND intsts__c =\'Ready for Integration\' AND mtd_nm__c = \'dccaUpdStatus\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <ws_call__c> scope) {
        List<ws_call__c> wsList = new List<ws_call__c>();
        List < Id > accId = new List < Id > ();
        List<g_Req__c> rqList = new List<g_Req__c>();
        String jsonBody ='' ;
        List<String> reqNo = new List <String>();
        Map<string, loc__c> regOffMap = new Map<string, loc__c>();
        for (ws_call__c ws: scope) {
            if (ws.rq_itm__r.RQ__r.Service_Code__c =='208') reqNo.add(ws.rq_itm__r.RQ__r.Acc__r.id);
        }
        List<loc__c> regOff = [Select Id, acc__r.id, agrno__c, offno__c, aroffno__c, flr__c,
            arflr__c, Bldg__c, arBldg__c, bu__c, arbu__c, ls_end__c, ls_std__c  from loc__c where acc__c in :reqNo and IsActive__c = true and isregof__c=true];
        if (regOff != null && regOff.size()>0) {
            for (loc__c lc : regOff) {
                regOffMap.put(lc.acc__r.id, lc);
            }
        }
        for (ws_call__c ws: scope) {
            system.debug(ws.Id);
            if (ws.intsts__c == 'Ready for Integration' ) {
                grqWsExtStatusUpd.RequestRecords reqjsRq =  (grqWsExtStatusUpd.RequestRecords) JSON.deserialize(ws.rq_jsn__c, grqWsExtStatusUpd.RequestRecords.class);
                map<String, String> stsUpdMap = new map<String, String>();
                list<String> splitList = new list<String> ();
                if (regOffMap.containsKey(String.ValueOf(ws.rq_itm__r.RQ__r.Acc__r.id))) {
                    grqWsExtStatusUpd.RegisterAddress addregOff= new grqWsExtStatusUpd.RegisterAddress();
                    loc__c regloc = new loc__c();
                    regloc =  regOffMap.get(String.ValueOf(ws.rq_itm__r.RQ__r.Acc__r.id))  ;
                    addregOff.aggNo = regloc.agrno__c;
                    addregOff.unitNo = regloc.offno__c;
                    addregOff.floor = regloc.flr__c;
                    addregOff.buildingname = regloc.Bldg__c;
                    addregOff.businessUnit = regloc.bu__c;
                    addregOff.unitNoArb = regloc.aroffno__c;
                    addregOff.floorArb = regloc.arflr__c;
                    addregOff.buildingnameArb = regloc.arBldg__c;
                    addregOff.businessUnitArb = regloc.arbu__c;
                    addregOff.lsStart = String.ValueOf(regloc.ls_std__c);
                    addregOff.lsEnd = String.ValueOf(regloc.ls_end__c);
                    system.debug('addregOff'+addregOff);
                    try{
                        reqjsRq.rec[0].regAdd = addregOff;
                    }
                    catch (Exception e) {
                        System.debug(e.getMessage());
                    }
                }
                system.debug('reqjsRq'+reqjsRq);
                if (ws.rq_itm__r.STA__r.exsyst__c != null) {
                    string wsexsyst = ws.rq_itm__r.STA__r.exsyst__c;
                    if (wsexsyst != null) {
                        splitList = wsexsyst.split(';');
                        for (string st : splitList ) {
                            list<string> crtmap = st.split(':');
                            stsUpdMap.put(crtmap[0], crtmap[1]);
                        }
                        for (string stsUp : stsUpdMap.keySet()) {
                            if (stsUp.contains('dcca')) {
                                reqjsRq.rec[0].status = stsUpdMap.get(stsUp);
                            }
                        }
                    }
                }
                if (reqjsRq != null) {
                    jsonBody = JSON.serialize(reqjsRq);
                    system.debug('jsonBody'+jsonBody);
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
                        system.debug('response'+response.getBody());
                        ws.res_jsn__c=response.getBody();
                        System.debug('response.getBody();' +response.getBody());
                        grqWsExtStatusUpd.RequestRecords resJs =  (grqWsExtStatusUpd.RequestRecords) JSON.deserialize(response.getBody(), grqWsExtStatusUpd.RequestRecords.class);
                        system.debug('JJ' +resJs );
                        if (resJs != null && String.isBlank(resJs.rec[0].error)) {
                            ws.intsts__c = 'Success';
                        }
                        else{
                            ws.intsts__c = 'Failed';
                            ws.err_msg__c = resJs.rec[0].error;
                        }
                    }
                    else {
                        ws.intsts__c = 'Failed';
                        ws.err_msg__c = response.getBody() ;
                    }
                }
                catch (System.CalloutException e) {
                    ws.res_jsn__c= String.ValueOF(e);
                    ws.intsts__c = 'Failed';
                }
                wsList.add(ws);
            }
        }
        Update wsList;
    }
    global void finish(Database.BatchableContext BC) {}
    global class deserializeResponse
    {
        public String id;
        public String access_token;
    }
}