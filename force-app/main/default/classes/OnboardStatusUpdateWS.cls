@RestResource(urlMapping='/updateonboardstatus/*')
global class OnboardStatusUpdateWS {

    @HttpPost
    global static void updateonboardstatus() {
        String reqBody  = RestContext.request.requestBody.toString();
        RestContext.response.addHeader('Content-Type', 'application/json');
        Response res = new Response();
        //return res;

        system.debug('Req Body::'+reqBody);
        try{
            StatusInfo rqData = (StatusInfo)JSON.deserialize(reqBody, StatusInfo.class);
            if (rqData != null && rqData.recId != null ) {
                updateOnboardRequest(rqData);
            }

            res.isSuccess = true;
            res.respMsg = 'success';

        }catch (Exception ex) {res.isSuccess = false;res.respMsg = ex.getMessage();}

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(res));
    }

    public static void updateOnboardRequest(StatusInfo info) {
        try{
            boolean isCallfetch = false;
            system.debug('info >> '+ info);
            Contact con;
            Account acc;
            List<g_Req__c> rqLst = new  List<g_Req__c>();
            List<g_reqitem__c> riLst = new List<g_reqitem__c>();
            Boolean updateccrm = false;
            if (info.recId.startsWith('0Q0')) {
                riLst = [select id, itm__c, RQ__c, RQ__r.Acc__c, itm__r.cd__c, sta__c, sta__r.cd__c,
                    sta__r.xcsits__c, ccrmid__c, xcnotes__c, xcdocs__c, xdcca_refId__c,
                        xdcr__c, xaf__c from g_reqitem__c where(rq__c =: info.reqId or rq__r.Name =: info.reqId)  and itm__r.cd__c='ob'];
                // itm__r.srvc__r.uid__c = '216' and   /*MS 1.1*/
                updateccrm = true;
            }else{
                riLst = [select id, itm__c, RQ__c, RQ__r.Acc__c, RQ__r.xvtyp__c, RQ__r.Acc__r.clt__c,
                    itm__r.cd__c, sta__c, sta__r.cd__c, sta__r.xcsits__c, ccrmid__c, xcnotes__c, xcdocs__c,
                    xdcca_refId__c, xdcr__c, xdcdocs__c from g_reqitem__c where itm__r.srvc__r.uid__c in ('216',
                    '322', '327') and ccrmid__c=:info.recId ];
                /*MS 1.1*/// rq__c=:info.reqId and itm__r.srvc__r.uid__c = '216' and
            }

            system.debug('riLst >>'+riLst);
            List<Courier_Status__c> nxtStLst = null;

            if (riLst != null && !riLst.isEmpty()) {
                system.debug('In acc riLst');
                nxtStLst = [select id, itmSTA__c, itmSTA__r.name, srvitm__r.name, curSTA__c, curSTA__r.xcsits__c,
                    curSTA__r.name, curSTA__r.cd__c, curSTA__r.uid__c, curSTA__r.rqSTA__c,
                        Courier_Status__c from Courier_Status__c where srvitm__c =:riLst[0].itm__c  and Courier_Status__c=:info.status ];
                if (nxtStLst != null && !nxtStLst.isEmpty()) {
                    riLst[0].sta__c = nxtStLst[0].itmSTA__c;
                    riLst[0].xcnotes__c = info.description;
                    if (String.isBlank(riLst[0].ccrmid__c) || updateccrm) {riLst[0].ccrmid__c = info.recId;}
                    System.debug('nxtStLst[0].curSTA__c :: ' + nxtStLst[0].curSTA__c);
                    if (nxtStLst != null && !nxtStLst.isEmpty() && String.isNotBlank( nxtStLst[0].curSTA__r.uid__c) && (nxtStLst[0].curSTA__r.uid__c=='216obci' || nxtStLst[0].curSTA__r.uid__c=='216drpna' || nxtStLst[0].curSTA__r.uid__c=='216drna' || nxtStLst[0].curSTA__r.uid__c=='216drrc' )) {
                        //|| (riLst[0].itm__r.cd__c == 'nl' && nxtStLst[0].curSTA__r.cd__c == 'pai')
                        if (String.isNotBlank(info.jsonStr) && info.jsonStr.length() <50 )
                            riLst[0].xaf__c = info.jsonStr;

                        /*MS 1.1 start*/
                         isCallfetch = true;
                    }

                    if (String.isNotBlank(info.jsonStr) && !info.jsonStr.startsWith('a0') && !info.wsType.equalsIgnoreCase('fitout')) {
                        Set<String> skpDocs = new Set<String>( gu.csStr('skipddadocs').split(';'));
                        String docStr = '';
                        if (riLst[0].RQ__r.xvtyp__c == 'DED' && riLst[0].RQ__r.Acc__r.clt__c == 'Land') {
                            OnboardStatusUpdateWS.DocsInfo wo = (OnboardStatusUpdateWS.DocsInfo) Json.deserialize(info.jsonStr, OnboardStatusUpdateWS.DocsInfo.class);
                            system.debug('wo===='+wo);
                            map<String, string> mapDocrec = new map<String, String>();
                            if (wo != null  && wo.requiredDocs != null && !wo.requiredDocs.isEmpty()) {
                                system.debug('wo===='+wo.requiredDocs);
                                for (OnboardStatusUpdateWS.Docdesc objDocDesc: wo.requiredDocs) {
                                    system.debug('recId==='+objDocDesc.recId);
                                    system.debug('docs==='+objDocDesc.docs);
                                    objDocDesc.recId = info.recId;
                                    for (String docName : objDocDesc.docs) {
                                        if (!skpDocs.contains(docName)) {
                                            docStr += docName + ';';
                                        }
                                        mapDocrec.put(docName, info.recId);
                                    }
                                }
                            }
                            if (wo != null  && wo.requiredDocs != null) {
                                String xcdoc = formatDoc(riLst[0].RQ__c, docStr, mapDocrec);
                                g_req__c objRQ = new g_req__c(Id=  riLst[0].rq__c, xcddocs__c = xcdoc);
                                if (Schema.sObjectType.g_req__c.isUpdateable()) {
                                    update objRQ;
                                }
                            }
                        }
                        else {
                            /* need to review for FZ llc */ WorkOrderInfo wo = (WorkOrderInfo) Json.deserialize( info.jsonStr, WorkOrderInfo.class );
                            /*riLst[0].xdcca_refId__c = wo.ddaReqId;
                            */ for (String str : wo.docs) {
                                if (!skpDocs.contains(str)) docStr += str + ';';
                            }
                            riLst[0].xdcdocs__c = docStr;
                        }
                        /*end-- Added to format doc for land to add version */ /*riLst[0].xdcca_refId__c = wo.ddaReqId;
                        */ /* String docStr = '';
                        Set<String> skpDocs = new Set<String>(gu.csStr('skipddadocs').split(';'));
                        for (String str : wo.docs) {
                            if (!skpDocs.contains(str))docStr+=str+';';
                        }
                        riLst[0].xdcdocs__c = docStr;
                    */ }
                    if (nxtStLst != null && !nxtStLst.isEmpty() && String.isNotBlank(nxtStLst[0].curSTA__r.xcsits__c)) {
                        List < String > lst = nxtStLst[0].curSTA__r.xcsits__c.split(';');
                        Map < String, String > itmMp = new Map < String, String > ();
                        Map < String, String > stsMp = new Map < String, String > ();
                        for (String str: lst) itmMp.put(str.split(':')[0], str.split(':')[1]);
                        system.debug('itmMp::' + itmMp);
                        for (g_srvcitm_Status__c sts: [select id, cd__c, uid__c from g_srvcitm_Status__c where  itm__r.cd__c =: itmMp.keySet() and cd__c =: itmMp.values()]) stsMp.put(sts.uid__c,
                            sts.id);
                        system.debug('stsMp::' + stsMp);
                        for (g_reqitem__c ri: [select id, sta__c, sta__r.cd__c, itm__r.cd__c,
                            itm__r.uid__c from g_reqitem__c where rq__c =: riLst[0].RQ__c and itm__r.cd__c =: itmMp.keySet() FOR UPDATE]) {
                            String stsCode = itmMp.get(ri.itm__r.cd__c);
                            if (ri.sta__r.cd__c != stsCode && ri.sta__r.cd__c == 'n') {
                                system.debug('stsCode::' + stsCode + ':' + ri.itm__r.cd__c + stsCode);
                                riLst.add(new g_reqitem__c(id = ri.id, sta__c = stsMp.get(ri.itm__r.uid__c + stsCode)));
                            }
                        }
                        system.debug('rqItmList::' + riLst);
                    }

                    system.debug('before riLst >>:'+riLst);
                    if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                        update riLst;
                    }
                    if (String.isNotBlank(nxtStLst[0].curSTA__r.rqSTA__c)  ) {
                        /*g_req__c rqToUpdt = new g_req__c(id=riLst[0].RQ__c, STA__c =nxtStLst[0].curSTA__r.rqSTA__c);*/
                        g_req__c rqToUpdt = new g_req__c();
                        rqToUpdt = [select id, xcddocs__c from g_req__c where id = :riLst[0].RQ__c];
                        rqToUpdt.STA__c =nxtStLst[0].curSTA__r.rqSTA__c;
                        system.debug('Courier_Status__c***'+nxtStLst[0].Courier_Status__c);
                        if (rqToUpdt != null && String.isNotBlank(info.jsonStr) && info.wsType.equalsIgnoreCase('fitout') && nxtStLst[0].Courier_Status__c == 'Call for Review') {
                            fitoutInfo fitOut =(fitoutInfo) Json.deserialize(info.jsonStr, fitoutInfo.class);
                            List<String> docs = new List<String>();
                            if (!String.isBlank(rqToUpdt.xcddocs__c)) {
                                docs.addAll(rqToUpdt.xcddocs__c.split(';'));
                            }
                            if (fitOut != null && !String.isBlank(fitOut.documentslist)) {
                                docs.addAll(fitOut.documentslist.split(';'));
                            }
                            if (!docs.isEmpty()) {
                                rqToUpdt.xcddocs__c = String.join(docs, ';');
                            }
                            grqH.rAfter = true;
                        }
                        if (Schema.sObjectType.g_req__c.isUpdateable()) {
                            update rqToUpdt;
                        }
                        if (nxtStLst[0].curSTA__r.rqSTA__c == 'Rejected') {

                            List<user> usrLst = [select id from user where contact.accountid=:riLst[0].RQ__r.Acc__c and isActive=true and profile.name='z'];
                            system.debug('enqueue job to deactivate the user >>  usrLst[0].id :' +  usrLst[0].id);
                            if (usrLst != null && !usrLst.isEmpty()) { System.enqueueJob(new OnboardQueueable('revokeUserAccess', usrLst[0].id)); }
                        }
                    }
                    system.debug('Updated riLst >>:'+riLst);

                if (isCallfetch) { callFetchAcc(info.accid); }
            }
        }
        else{
                ws_call__c wc = new ws_call__c(pmid__c = info.accid, ws_typ__c = 'Onboarding', mtd_nm__c = 'fetchAccInfo', intsts__c = 'Ready for Integration');
                /*insert wc; */
            }
        }catch (Exception ex) {
            system.debug('ex::'+ex.getStackTraceString());
            ws_call__c wc = new ws_call__c();
            wc.pmid__c = info.accid;
            wc.ws_typ__c = 'Onboarding';
            wc.mtd_nm__c = 'fetchAccInfoError';
            wc.intsts__c = 'Failed';
            wc.err_msg__c = ' >>'+ ex.getMessage() + ' -- '+ex.getStackTraceString();
            if (Schema.sObjectType.ws_call__c.isCreateable()) {
                insert wc;
            }
        }
    }

    public static Date strDate(String dt) {
        if (String.isBlank(dt)) {return null;}
        dt = dt.split(' ')[0];
        List<string> lst = dt.split('-');
        return dt != null?(Date.newInstance(integer.valueOf(lst[0]) , integer.valueOf(lst[1]), integer.valueOf(lst[2]))):null;
    }

    /**
MS1.1 fetch account info
*/
    @future
    public Static void callFetchAcc(String accId) {
        ws_call__c wc = new ws_call__c();
        wc.pmid__c = accId;
        wc.ws_typ__c = 'Onboarding';
        wc.mtd_nm__c = 'fetchAccInfo';
        wc.intsts__c = 'Ready for Integration';
        if (Schema.sObjectType.ws_call__c.isCreateable()) {
            insert wc;
        }
    }

    public Static String formatDoc(String rqid, String docstr, map<String, string> mapDocrec) {
        string forDoc = '';
        system.debug('docstr====='+docstr);
        system.debug('mapDocrec====='+mapDocrec);
        list<String> lstDocs = docstr.split(';');
        map<String, String> mapDocDesc = new map<String, String>();
        map<String, String> mapDocItm =  new map<String, String>();
        for (g_reqitem__c objItm: [select id, name, itm__c, itmCd__c, ccrmid__c from g_reqitem__c where RQ__c =: rqid and ccrmid__c IN: mapDocrec.values()]) {
            mapDocItm.put(objItm.ccrmid__c, objItm.itmCd__c);
        }
        for (g_reqitemDoc__c reqItmDoc : [select id, name,  reqItm__r.itmCd__c ,
            reqItm__r.ccrmid__c  from  g_reqitemDoc__c where reqItm__r.RQ__c =: rqid ]) /*and reqItm__r.ccrmid__c IN: mapDocrec.values()*/ {
            mapDocItm.put(reqItmDoc.reqItm__r.ccrmid__c, reqItmDoc.reqItm__r.itmCd__c);
            string docName = reqItmDoc.name;
            if (docName.indexof('-v') != -1) {
                docName = docName.subString(0, docName.indexof('-v'));
            }
            system.debug('docName===232=='+docName );
            boolean isExtDoc = false;
            for (String strMapKey: mapDocDesc.keyset()) {
                if (strMapKey.containsIgnoreCase(docName)) {
                    isExtDoc = true;
                    String docdec = mapDocDesc.get(docName);
                    Integer vnum = Integer.valueoF(docdec.split(':')[0]);
                    vnum = vnum+1;
                    mapDocDesc.put(docName, vnum+':'+reqItmDoc.reqItm__r.itmCd__c);
                }
            }
            if (!isExtDoc) {
                mapDocDesc.put(docName, 0+':'+reqItmDoc.reqItm__r.itmCd__c);
            }
        }
        system.debug('lstDocs====='+lstDocs);
        system.debug('mapDocDesc====='+mapDocDesc);
        system.debug('mapDocItm====='+mapDocItm);
        for (String doc: lstDocs) {
            system.debug('doc=='+doc);
            doc = doc;
            system.debug('mapDocrec=='+mapDocItm.get(mapDocrec.get(doc)));
            String itmCd = mapDocItm.get(mapDocrec.get(doc));
            Boolean isExtDoc = false;
            for (String strMapKey: mapDocDesc.keyset()) {
                if (strMapKey.containsIgnoreCase(doc)) {
                    isExtDoc = true;
                    String docdec = mapDocDesc.get(doc);
                    Integer vnum = Integer.valueOf(docdec.split(':')[0]);
                    vnum = vnum+1;
                    /*String itmCd = mapDocItm.get(mapDocrec.get(doc));
                    */ forDoc+= doc+'-v'+vnum+'~cr';
                    if (String.isNotBlank(itmCd)) {
                        forDoc+= ':'+itmCd;
                    }
                }
            }
            if (!isExtDoc) {
                system.debug('mapDocItm.get(mapDocrec.get(\'doc\'))===='+mapDocItm.get(mapDocrec.get(doc)));
                system.debug('forDoc == 11='+forDoc);
                if (mapDocItm.containskey(mapDocrec.get(doc))) forDoc+=  doc+'~cr'+':'+itmCd;
                else forDoc+=  doc+'~cr';
            }
            forDoc+= ';';
        }
        system.debug('forDoc====='+forDoc);
        return String.isNotBlank(forDoc)? forDoc : null;
    }

    public class StatusInfo{
        public string recId;
        public string rectype;
        public string reqId;
        public string accid;
        public string status;
        public string description;
        public string wsType;
        public string jsonStr;
    }
    public class WorkOrderInfo{
        public string ddaReqId;
        public Set<String> docs;
    }
    public class fitoutInfo{
        public String eleDeptComments;
        public String mechDeptComments;
        public string documentslist;
    }

    Public class Response{
        public String respMsg;
        public boolean isSuccess;
    }
    public class RequireCorrection{
        public String Reason{get;set;}
        public list<String> reqDocList{get;set;}
        public String description{get;set;}
    }
    public class InitiateOnboarding{
        public String axsAccId{get;set;}
    }

    public class DocsInfo {
        public list < Docdesc > requiredDocs;
        public string ddaReqId;
    }

    public class Docdesc {
        public String recId;
        public set < String > docs;
    }
}