public class grqWsExtStatusUpd {
    public static void statusUpdate(List < g_reqitem__c > rqItSet, map < Id, g_Req__c > reqMap, String wsTyp, Map<Id, String> wsMd) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        for (g_reqitem__c ri: rqItSet) {
            String methdname = wsMd.get(ri.id);
            g_Req__c rq = reqMap.get(ri.Id);
            String jsonBody ;
            RequestRecords rqRec = new RequestRecords();

            requestInner newRq = new requestInner();
            list<requestInner> newRqList  = new list<requestInner> ();

            newRq.dccaReqId = rq.xdei__c;
            newRq.refAxs = rq.Name;
            newRq.timeStamp = ri.Time_stamp__c;
            if (ri.xcawb__c != null)
            newRq.awbNo = String.ValueOf(ri.xcawb__c);
            List<RegisterAddress> reqAdLst = new List<RegisterAddress>();
            RegisterAddress reqAd = new RegisterAddress();
            If(rq.xvn__c != null) {

                String regOffice = rq.xvn__c ;
               String[] st = regOffice.split(';');
               reqAd.aggNo = st[0];
                reqAdLst.add(reqAd);
               newRq.MainAdd = reqAdLst;

            }

            newRqList.add(newRq);
            rqRec.rec = newRqList;
            jsonBody = JSON.serialize(rqRec);
            System.debug('grqWsExtStatusUpd json'+jsonBody);

            if (methdname.contains('dccaUpdStatus') || methdname.contains('dccaRegOff') ) {
                System.debug('grqWsExtStatusUpd Inside dccaUpdStatus');
                ws_call__c ws = new ws_call__c();
                ws.rq_jsn__c = jsonBody;
                ws.ws_typ__c = wsTyp;
                ws.mtd_nm__c = wsMd.get(ri.id);
                //ws.is_pro__c = true;
                ws.intsts__c = 'Ready for Integration';
                ws.uid__c = rq.id + '' + ri.Id + '' + ri.sta__c + system.Now() +wsMd.get(ri.id) ;
                ws.rq_itm__c = ri.id;
                wsList.add(ws);
            }
        }

        if (wsList.size()>0) {
            System.debug('grqWsExtStatusUpd List wsList');
            Insert wsList;
        }
    }

    public class  requestInner{
        public string refAxs  ;
        public string status ;
        public string timeStamp ;
        public string error  ;
        public string awbNo ;
        public string dccaReqId;
        public string regOff;
        public RegisterAddress regAdd;
           public List<RegisterAddress> MainAdd;
        public Boolean custConf;
    }

    public class RegisterAddress
    {
        public string aggNo;
        public string unitNo;
        public string floor;
        public string buildingname;
        public string businessUnit;
        public string unitNoArb;
        public string floorArb;
        public string buildingnameArb;
        public string businessUnitArb;
        public string lsStart;
        public string lsEnd;
    }

    public class RequestRecords{
        public list<requestInner> rec ;
    }

}