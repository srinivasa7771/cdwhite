public class gctlWSPushDDA {

    public gctlWSPushDDA() {}

    Public void createWsCAll() {
        List < ws_call__c > wsCallLst = new List < ws_call__c > ();
        String rID = ApexPages.currentPage().getParameters().get('id');
        system.debug('$$$$$ rID::' + rID);
        List < g_reqitem__c > riLst = [select id, sta__r.cd__c, exp__c, sta__r.ws_typ__c, sta__r.ws_mtd__c from g_reqitem__c where id =: rID
            //RQ__c =: rID and itm__r.cd__c = 'ep'
            //and sta__r.ws_typ__c = 'Immigration EVEP'
            //and sta__r.ws_mtd__c = 'createApplication'
        ];
        if (riLst != null && !riLst.isEmpty()) {
            ws_call__c wc = new ws_call__c();
            wc.rq_itm__c = riLst[0].id;
            wc.ws_typ__c = 'Immigration EVEP';
            wc.mtd_nm__c = 'createApplication';
            wc.intsts__c = 'Ready for Integration';
            // wc.pmid__c = rID;
            List < ws_call__c > lstExistingWS = [SELECT id, name, pmid__c from ws_call__c where rq_itm__c =: rID AND ws_typ__c = 'Immigration EVEP'];
            system.debug('##### lstExistingWS:: ' + lstExistingWS.size());
            if (lstExistingWS.size() == 0) {
                wsCallLst.add(wc);
            }
        }
        if (wsCallLst != null && !wsCallLst.isEmpty()) {
            insert wsCallLst;
        }
    }

    public void pushWsCall() {
        String wid = ApexPages.currentPage().getParameters().get('id');
        List < ws_call__c > wscallList = [select id, mtd_nm__c, ismp__c from ws_call__c where id =: wid and ws_typ__c = 'Immigration EVEP'];
        if (wscallList != null && !wscallList.isEmpty()) {
            String executeBatchName = '';
            if (wscallList[0].mtd_nm__c == 'createApplication') executeBatchName = 'createApplication';
            else if (wscallList[0].mtd_nm__c == 'uploadSingleDocument') executeBatchName = 'uploadSingleDocumentAdh';
            else if (wscallList[0].mtd_nm__c == 'submitPayment') executeBatchName = 'invokePayment';
            wscallList[0].ismp__c = true;
            update wscallList;
            BatchImmigrationApplicationProcess obj = new BatchImmigrationApplicationProcess(executeBatchName, wscallList[0].id);
            Database.executeBatch(obj, 1);
        }
    }

    public void createRQDoc() {
        String wid = ApexPages.currentPage().getParameters().get('id');
        List < ws_call__c > wscallList = [select id, mtd_nm__c, rq_jsn__c, rq_itm__c, rq_itm__r.RQ__c from ws_call__c where id =: wid and ws_typ__c = 'Immigration EVEP'];
        if (wscallList != null && !wscallList.isEmpty() && String.isNotBlank(wscallList[0].rq_jsn__c)) {
            List < String > docLst = (wscallList[0].rq_jsn__c).split('__');
            if (docLst != null && !docLst.isEmpty()) {
                List < g_reqDoc__c > rqdocList = [select id from g_reqDoc__c where RQ__c =: wscallList[0].rq_itm__r.RQ__c and name =: docLst[1]];
                if (rqdocList == null || rqdocList.isEmpty()) {
                    g_reqDoc__c rDoc = new g_reqDoc__c(Name = docLst[1], RQ__c = wscallList[0].rq_itm__r.RQ__c);
                    insert rDoc;
                    g_reqitemDoc__c riDoc = new g_reqitemDoc__c(Name = docLst[1], lbl__c = docLst[1], reqItm__c = wscallList[0].rq_itm__c, reqDoc__c = rDoc.id, Req__c = true, reqOr__c = false, reqAts__c = true, mnAts__c = 0, mxAts__c = 2, Tp__c = 'Others');
                    insert riDoc;
                }
            }
        }
    }
}