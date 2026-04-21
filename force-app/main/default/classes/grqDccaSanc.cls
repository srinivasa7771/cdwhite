public class grqDccaSanc {

    public class SanctionData
    {
        public string licNo;
        public List<Sanction> san;
    }
    public Class Sanction
    {
        public string description;
        public string Status;
        public string axsRefNo;
    }

    public static void khdaSanction(map<String, g_Req__c> dccaReq, String sta) {
        List<ws_call__c> wsList = new List<ws_call__c>();
        List<g_reqitem__c> rqList = new List<g_reqitem__c>();
        map<Id, Id> rqItmMap = new map<Id, Id>();

       rqList =  [select Id, itm__c, itm__r.cd__c, RQ__c, RQ__r.id from g_reqitem__c where itm__r.cd__c='dr' and RQ__c in: dccaReq.values() ];
        for (g_reqitem__c rqItm : rqList) {
            rqItmMap.put(rqItm.RQ__r.id, rqItm.Id);
        }

        for (string req: dccaReq.keyset()) {
            g_Req__c rq = dccaReq.get(req);
            SanctionData scData = new SanctionData();
            List<Sanction> scList = new  List<Sanction>();
            Sanction sc =  new Sanction ();
            sc.axsRefNo = rq.Name;
            sc.description = 'RnL- Required Docs';
            sc.Status= sta;
            scList.add(sc);
            scData.licNo = req;
            scData.san = scList;
            String jsonBody = JSON.serialize(scData);

            ws_call__c ws = new ws_call__c();
             if (rqItmMap.containsKey(rq.id)) {
              ws.rq_itm__c =  rqItmMap.get(rq.id) ;
            }
            ws.rq_jsn__c = jsonBody;
            ws.ws_typ__c = 'DCCA AddRemove Sanction';
            ws.mtd_nm__c = 'dccaAddSanc';
            ws.is_pro__c = true;
            ws.intsts__c = 'Ready for Integration';
            ws.uid__c = rq.id + '' + system.now() +'dccaSanc'+sta ;
            wsList.add(ws);

            if (wsList != null && wsList.size()>0 && !Test.isRunningTest()) {
                Insert wsList;
            }
        }

    }

}