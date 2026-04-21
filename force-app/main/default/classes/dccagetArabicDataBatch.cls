global class dccagetArabicDataBatch implements Database.Batchable < sObject > , Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        string type = 'DCCA Letters'; //AND mtd_nm__c = \'dccaServiceRq\'
        String query = 'Select Id,err_cd__c,pmid__c,xwsc__c,intsts__c,rq_itm__r.itm__r.rv__c,rq_itm__r.itm__r.dcca_refId__c,err_msg__c,mtd_nm__c,rq_itm__c,rq_itm__r.id,rq_itm__r.itm__r.id,rq_itm__r.RQ__r.Id,rq_itm__r.RQ__r.Name,rq_itm__r.RQ__r.Acc__r.lc__c,rq_itm__r.RQ__r.Acc__r.id,rq_itm__r.RQ__c,rq_itm__r.RQ__r.Con__r.Id,rq_itm__r.STA__r.Next_Status__c,rq_itm__r.STA__r.Next_Status__r.rqSTA__c,is_pro__c,rq_jsn__c,res_jsn__c,uid__c,ws_typ__c,rq_itm__r.itm__r.dcr__c,rq_itm__r.RQ__r.Service_Code__c, rq_itm__r.RQ__r.xdmpn__c from ws_call__c where ws_typ__c = :type  AND intsts__c =\'Ready for Integration\' AND mtd_nm__c = \'getArabicData\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <ws_call__c> scope) {
        List<ws_call__c> wsList = new List<ws_call__c>();
        List < Id > accId = new List < Id > ();
        List<g_Req__c> rqList = new List<g_Req__c>();
        List<g_reqitem__c> rqItmList = new List<g_reqitem__c>();
        boolean sucflag ;
        List<Id> regList = new List<Id>();
        List < acc_sharehd__c > shList = new List < acc_sharehd__c > ();
        List < acc_sharehd__c > newshList = new List < acc_sharehd__c > ();
        Map<string,List<acc_sharehd__c>> accSHMap= new Map<string,List<acc_sharehd__c>>();

        for (ws_call__c ws: scope) {
            accId.add(ws.rq_itm__r.RQ__r.Acc__r.Id);
        }

        shList = [Select Id,shName__c,shNameArb__c,accsh__c, accsh__r.lc__c,Postion__c from acc_sharehd__c where accsh__c in:accId];

        for (acc_sharehd__c sh: shList) {
            if (!accSHMap.containsKey(sh.accsh__r.lc__c)){
                accSHMap.put(sh.accsh__r.lc__c,new List<acc_sharehd__c>{sh});
            } else{accSHMap.get(sh.accsh__r.lc__c).add(sh); }
        }
        system.debug('accSHMap JJJ'+accSHMap);

        for (ws_call__c ws: scope) {

            if (ws.intsts__c == 'Ready for Integration' ) {

                grqWsDcca.IdentityInfo idInfo = new grqWsDcca.IdentityInfo();
                grqWsDcca.shareHolder shareH = new grqWsDcca.shareHolder();
                List<grqWsDcca.shareHolder> shholderList = new List<grqWsDcca.shareHolder>();

                idInfo.licNo = ws.rq_itm__r.RQ__r.Acc__r.lc__c;
                String jsonBody = JSON.serialize(idInfo);
                ws.rq_jsn__c = jsonBody;

                system.debug('jsonBody JJJ'+jsonBody);

                Http h = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Content-Type','application/json');
                request.setHeader('accept','application/json');
                request.setEndpoint('callout:DCCA_Auth/apexrest/shareShareHolderInfo/');
                request.setTimeout(120000);
                request.setMethod('POST');
                request.setBody(jsonBody);//jsonBody
                try {
                    response = h.send(request);
                    if (response.getStatusCode() == 200) {
                        system.debug('Sucess');
                        sucflag=true;
                        system.debug('response'+response.getBody());
                        ws.res_jsn__c=response.getBody();

                        System.debug('response.getBody();' +response.getBody());

                        grqWsDcca.IdentityInfo  reqjsRq =  ( grqWsDcca.IdentityInfo ) JSON.deserialize( ws.res_jsn__c, grqWsDcca.IdentityInfo.class);
                        system.debug('reqjsRq JJJ'+reqjsRq);
                        ws.intsts__c = 'Success';
                        shholderList = reqjsRq.shholder;
                        List < acc_sharehd__c > getShList;
                        if (accSHMap.containsKey(reqjsRq.licNo)){ getShList=accSHMap.get(reqjsRq.licNo);}
                        if (getShList!=null){
                            for (acc_sharehd__c sh:getShList){
                                for (grqWsDcca.shareHolder resSh:shholderList){
                                    if (sh.shName__c == resSh.name && sh.Postion__c == resSh.pos ){
                                        acc_sharehd__c s = new acc_sharehd__c();s.id= sh.id; s.shNameArb__c= resSh.arbnm;
                                        newshList.add(s);
                                    }
                                }
                            }
                        }
                        if (newshList!=null){
                            SObjectAccessDecision secDec = Security.stripInaccessible(AccessType.UPDATABLE, newshList);
                            update secDec.getRecords();
                        }

                        g_reqitem__c ri = new g_reqitem__c();
                        ri.id = ws.rq_itm__r.id;
                        if (ws.rq_itm__r.STA__r.Next_Status__c!=null)ri.sta__c = ws.rq_itm__r.STA__r.Next_Status__c;
                        rqItmList.add(ri);
                        String rqSTA=ws.rq_itm__r.STA__r.Next_Status__r.rqSTA__c;
                        if (rqSTA!=null && rqSTA.length()>0){
                            rqList.add(new g_Req__c(id=ws.rq_itm__r.RQ__c,STA__c=ws.rq_itm__r.STA__r.Next_Status__r.rqSTA__c));
                        }

                        if (rqItmList!=null && rqItmList.size()>0){
                            SObjectAccessDecision secDec2 = Security.stripInaccessible(AccessType.UPDATABLE, rqItmList);
                            update secDec2.getRecords();
                        }

                    }else {ws.intsts__c = 'Failed';ws.err_msg__c = response.getBody() ;}
                }catch (System.CalloutException e) {ws.res_jsn__c= String.ValueOF(e); ws.intsts__c = 'Failed'; sucflag=false;}

                wsList.add(ws);
            }
        }

        Update wsList;
        if (rqList!=null && rqList.size()>0){Update rqList;}

    }

    global void finish(Database.BatchableContext BC) {}
    global class deserializeResponse
    {
        public String id;
        public String access_token;
    }
}