public class crctnob extends pgBsCtrl {
    public boolean docFlg {
        set;
        get;
    }
    public list < g_reqDoc__c > gAllDocLst {
        get;
        set;
    }
    public list < D > Docs {
        get;
        set;
    }
    public string rqid {
        get;
        set;
    }
    public List < g_reqitem__c > ritm {
        set;
        get;
    }
    public g_req__c rq {
        set;
        get;
    }
    public List < CrtnReasons > cReasons {
        set;
        get;
    }
    public gctlRequ componentOne {
        get;
        set;
    }
    public list < DAS > dasLst {
        get;
        set;
    }
    public string usrComments {
        set;
        get;
    }
    public string errMsg {
        set;
        get;
    }
    public String reqDocId2 {
        get;
        set;
    }
    public void deleteAttachment2() { system.debug('deleteAttachment2 reqDocId2 >>' + reqDocId2); Attachment A = new Attachment(Id = reqDocId2); delete A; }
    public crctnob() {
        if (String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id')) != null) {
            ritm = new List < g_reqitem__c > ();
            rqid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
            rq = [select id, xadh__c, xcamc__c, nt__c, xppsfv__c, InsChk__c, acc__r.Prk__c, sta__c, srvc__r.stg__r.docq__c, srvc__r.uid__c, xcs__c, crflg__c from g_req__c where id =: rqid];
            ritm = [select id, name, xcnotes__c, xcln__c, xcp__c from g_reqitem__c where rq__c =: rqid and sta__r.staown__c = 'Customer' and sta__r.statype__c = 'Correction' ];
        }
        gAllDocLst = new List < g_reqDoc__c > ();
        docFlg = false;
        system.debug('ritm -- ' + ritm);
        cReasons = new List < CrtnReasons > ();
        if (ritm != null && ritm.size() > 0) {
            for (g_reqitem__c r: ritm) {
                CrtnReasons cr = new CrtnReasons();
                cr.rqItmName = r.xcln__c;
                cr.crtnMsg = r.xcnotes__c;
                cr.ppNo = r.xcp__c;
                cReasons.add(cr);
            }
        }
        system.debug('cReasons -- ' + cReasons);
        loadData();
    }
    public void reRender(Id id) {
        system.debug('-------------reRender -- ' + id);
        rqid = id;
        loadData();
        system.debug('-------------reRender -- end');
    }
    public boolean loadData() {
        Docs = new list < D > ();
        List < g_reqDoc__c > tempDocLst = new List < g_reqDoc__c > ();
        tempDocLst = [Select Id, Name, mxAts__c, mnAts__c, ats__c, Req__c, nt__c, or__c, reqAts__c,
            reqOr__c, tplt__c, tplt2__c,  upOk__c, mbr__c, mbr__r.Name, Doc_Description__c,
                Download_Doc_Link__c From g_reqDoc__c where RQ__c =: rqid and Req__c = true and nc__c = true and IsDeleted = false order by ord__c NULLS LAST];
        if (tempDocLst != null && !tempDocLst.isEmpty()) docFlg = true;
        system.debug('tempDocLst rq.rDocs__r >>>1');
        gAllDocLst = [Select Id, Name, mxAts__c, mnAts__c, ats__c, Req__c, nt__c, or__c, reqAts__c,
            reqOr__c, tplt__c, tplt2__c, upOk__c, mbr__c, mbr__r.Name, Doc_Description__c, Download_Doc_Link__c From g_reqDoc__c where RQ__c =: rqid order by ord__c NULLS LAST];
        system.debug('gAllDocLst >>>' + gAllDocLst);
        system.debug('tempDocLst rq.rDocs__r >>>3');
        map < Id, g_reqDoc__c > mD = new map < Id, g_reqDoc__c > ();
        system.debug('tempDocLst rq.rDocs__r >>>6');
        for (g_reqDoc__c dc: tempDocLst) {
            system.debug('dc.Name >>' + dc.Name);
            mD.put(dc.Id, null);
            Docs.add(new D(dc));
        }
        mD = new map < Id, g_reqDoc__c > ([Select Id, Name, (Select Id, Name, CreatedDate, CreatedBy.ProfileId, CreatedById From Attachments where isDeleted = false),
            (Select Id, reqItm__c, reqItm__r.rq__r.Service_Code__c, reqItm__r.xcfn__c,
                reqItm__r.xcln__c, reqItm__r.nc__c, reqItm__r.STA__c, reqItm__r.STA__r.cd__c,
                reqItm__r.itm__r.dSTA__c, reqItm__r.itm__r.Name, reqItm__r.itm__r.lbl__c,
                lbl__C From Docs__r where isDeleted = false),
            ord__c, ats__c, Req__c, Doc_Description__c, Download_Doc_Link__c From g_reqDoc__c where id in: mD.KeySet() ORDER BY ord__c]);
        for (D doc: Docs) {
            g_reqDoc__c dc = mD.get(doc.Doc.Id);
            doc.addAttachments(dc.Attachments);
            doc.doc.ord__c = dc.ord__c;
            set < String > rqItms = new set < String > ();
            for (g_reqitemDoc__c i: dc.Docs__r) {
                if (i.reqItm__r.rq__r.Service_Code__c == '216') doc.dsc = '( for ' + i.reqItm__r.xcfn__c + ' ' + i.reqItm__r.xcln__c + ' )';
                rqItms.add(i.reqItm__r.itm__r.lbl__c);
                doc.VF = false;
            }
            String sIs = '';
            Integer i = 0;
            for (String itm: rqItms) {
                sIs = (sIs == '' ? '' : sIs + (i == rqItms.size() - 1 ? ' and ' : ', ')) + itm;
                i++;
            }
            doc.Info = 'Needed for ' + sIs;
            /* rq.xcddocs__c;
            doc.Info='Needed for IBM Ireland Product Distribution Limited';
        */ }
        system.debug('1 Docs >>>>>>>' + Docs);
        reArrangeDocs();
        return true;
    }
    public void reArrangeDocs() {
        system.debug('reArrangeDocs >>>' + Docs);
        list < D > dUploadLst = new list < D > ();
        list < D > dUploadedLst = new list < D > ();
        if (Docs != null && Docs.size() > 0) {
            for (D d: Docs) {
                if (d.Ats == null || d.doUp || (d.doc.ats__c == 0 && d.doc.Req__c)) {
                    dUploadLst.add(d);
                }
                else dUploadedLst.add(d);
            }
            Docs = new list < D > ();
            Docs.addAll(dUploadLst);
            Docs.addAll(dUploadedLst);
            system.debug('new Docs_crtn >>' + Docs);
        }
        if (Docs != null && Docs.size() > 0) {
            dasLst = new List < DAS > ();
            List < DAS > dasUploadLst = new List < DAS > ();
            List < DAS > dasUploadedLst = new List < DAS > ();
            for (D d: Docs) {
                system.debug('d.Doc.mxAts__c_crtn>>' + d.Doc.mxAts__c);
                system.debug('d.Ats.size()_crtn>>' + d.Ats.size());
                if (d.cnUp || (d.Doc.mxAts__c == null && d.Ats.size() == 0)) {
                    DAS ds = new DAS();
                    ds.d = d;
                    ds.att = null;
                    ds.upload = true;
                    ds.minAttDon = ((d.Ats.size() == 0 || d.Ats.size() < d.Doc.mnAts__c) ? false : true);
                    dasUploadLst.add(ds);
                }
                if (d.Ats != null && d.Ats.size() > 0) {
                    for (Attach at: d.Ats) {
                        DAS ds = new DAS();
                        ds.d = d;
                        ds.att = at;
                        ds.a = at.A;
                        ds.upload = false;
                        ds.minAttDon = ((d.Ats.size() == 0 || d.Ats.size() < d.Doc.mnAts__c) ? false : true);
                        dasUploadedLst.add(ds);
                    }
                }
            }
            dasLst.addAll(dasUploadLst);
            dasLst.addAll(dasUploadedLst);
            system.debug('dasLst_crtn >>>' + dasLst);
        }
    }
    public void saveReq() {
        system.debug('rq=1123=' + rq);
        system.debug('rq==' + rq.srvc__r.uid__c);
        List < g_reqitem__c > riLst = new List < g_reqitem__c > ();
        if (nD) {
            gU.addInfoMsg(Label.msgNoDocuments);
            errMsg = Label.msgNoDocuments;
        }
        else {
            if (rq.srvc__r.uid__c == '220') {
                riLst = [select id, RQ__r.Name, RQ__r.Service_Code__c, itm__c, sta__c, sta__r.Next_Status__c, ccrmid__c, rc__c from g_reqitem__c where RQ__c =: rq.id and itm__r.cd__c in ('ddd')];
            }
            else {
                riLst = [select id, RQ__r.Name, RQ__r.Service_Code__c, itm__c, sta__c, sta__r.Next_Status__c,
                    ccrmid__c, rc__c from g_reqitem__c where RQ__c =: rq.id and itm__r.cd__c in ('dr',
                    'br', 'se', 'hsc') and sta__r.name = 'Requires Correction'];
            }
            System.debug('===riLst==' + riLst);
            if (riLst != null && !riLst.isEmpty()) {
                String sts = '', reqjs = '';
                list<ws_call__c> lstWsCall = new list<ws_call__c>();
                list<g_reqitem__c> lstrqItm  = new list<g_reqitem__c>();
                list<String> lstData = new list<String>();
                list<String> lstOrderId = new list<String>();
                ws_call__c wscall = new ws_call__c();
                for (g_reqitem__c objItm: riLst) {
                    /* ws_call__c ws = new ws_call__c();
                    */ system.debug('--usrComments--' + usrComments);
                    if (objItm.RQ__r.Service_Code__c == '220') {
                        reqjs = '{ "serviceRequests": [ { "axsRefNo": "' + objItm.RQ__r.Name + '", "customerFeedback":"' + usrComments + '"} ] } ';
                        System.debug('===reqjs==' + reqjs);
                        wscall.rq_jsn__c = reqjs;
                        wscall.ws_typ__c = 'License Amendments';
                        wscall.mtd_nm__c = 'statusUpdate';
                        wscall.intsts__c = 'Ready for Integration';
                        wscall.rq_itm__c = objItm.id;
                        wscall.adhoc_text1__c = usrComments;
                        /*lstData.add('{ "serviceRequests": [ { "axsRefNo": "' + objItm.RQ__r.Name + '", "customerFeedback":"' + usrComments + '"} ] } ');
                    */ }
                    else {
                        /* reqjs = '{"methodName":"updateWorkOrder", "data":[{"workOrderId":"' + objItm.ccrmid__c + '", "status":"Submitted", "description":"' + usrComments + '"}]}';
                        */ /*HttpResponse response = grqWsOnboard.ccrmStatusUpdate(reqjs);
                        */ lstData.add('{"workOrderId":"' + objItm.ccrmid__c + '", "status":"Submitted", "description":"' + usrComments + '"}');
                        /*   lstOrderId.add(objItm.ccrmid__c);
                        ws.rq_jsn__c = reqjs;
                        ws.intsts__c = 'Ready for Integration';
                        ws.rq_itm__c = objItm.id;
                        ws.pmid__c = objItm.ccrmid__c;
                        ws.ws_typ__c = 'Onboarding';
                        ws.mtd_nm__c = 'updateCRMStatus';
                        */ wscall.mtd_nm__c = 'updateCRMStatus';
                        wscall.ws_typ__c = 'Onboarding';
                        wscall.intsts__c = 'Ready for Integration';
                        wscall.rq_itm__c = objItm.id;
                        wscall.pmid__c = objItm.ccrmid__c;
                    }
                    /*lstWsCall.add(ws);
                    if (Schema.sObjectType.ws_call__c.isCreateable()) {
                        insert ws;
                    }
                    */ System.debug('===ws==' + lstWsCall);
                    if (String.isNotBlank(objItm.sta__r.Next_Status__c)) {
                        objItm.sta__c = objItm.sta__r.Next_Status__c;
                    }
                    objItm.rc__c = false;
                    lstrqItm.add(objItm);
                    /*update riLst;
                */ }
                String strdata = '';
                if (!lstData.isEmpty()) {
                    for (String str:lstData ) {
                        strdata = strdata+', '+str;
                    }
                    system.debug(strdata);
                    reqjs = '{"methodName":"updateWorkOrder", "data":['+ strdata.substring(1, strdata.length())+']}';
                    wscall.rq_jsn__c = reqjs;
                }
                lstWsCall.add(wscall);
                if (!lstrqItm.isEmpty()) {
                    if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                        update lstrqItm;
                    }
                }
                if (!lstWsCall.isEmpty()) {
                    if (Schema.sObjectType.ws_call__c.isCreateable()) {
                        insert lstWsCall;
                    }
                }
                if (rq.xcs__c) {
                    rq.xcs__c = false;
                }
                rq.sta__c = 'Under Review';
                if (Schema.sObjectType.g_req__c.isUpdateable()) {
                    update rq;
                }
            }
        }
    }
    public Boolean nD {
        get {
            if (rq.rDocs__r == null) {
                return false;
            }
            for (g_reqDoc__c d: [select id, upOk__c, (select id from Attachments) from g_reqDoc__c where RQ__c =: rq.id  and Req__c = true and nc__c=true]) {
                if (d.Attachments.size()==0) {
                    return true;
                }
            }
            return false;
        }
    }
    public class D {
        public g_reqDoc__c Doc {
            get;
            set;
        }
        public D(g_reqDoc__c dc) {
            Doc = dc;
        }
        public Boolean VF {
            get;
            set;
        }
        {
            VF = false;
        }
        public Boolean cnUp {
            get {
                return (Doc.reqAts__c && Ats.size() < Doc.mxAts__c || Doc.mxAts__c == null);
            }
        }
        public Boolean doUp {
            get {
                return ((Doc.reqAts__c && Ats.size() < Doc.mnAts__c));
            }
        }
        public list < Attach > Ats {
            get;
            set;
        }
        {
            Ats = new list < Attach > ();
        }
        public void addAttachments(list < Attachment > lA) {
            for (Attachment a: lA) {
                Ats.add(new Attach(a));
            }
        }
        public String Info {
            get;
            set;
        }
        public String dsc {
            get;
            set;
        }
    }
    public class Attach {
        public Attach(Attachment att) {
            A = att;
        }
        public Attachment A {
            get;
            set;
        }
        public Boolean crtbyPU {
            get {
                return gU.isPortalUser(A.CreatedBy.ProfileId);
            }
        }
    }
    public class DAS {
        /*Docs with single attach */ public D d {
            get;
            set;
        }
        public Attach Att {
            get;
            set;
        }
        public Attachment a {
            get;
            set;
        }
        public Boolean upload {
            get;
            set;
        }
        public Boolean minAttDon {
            get;
            set;
        }
        public Boolean hasAtt {
            get {
                return (Att != null);
            }
        }
    }
    public class CrtnReasons {
        /*for itemwise reasons*/ public String rqItmName {
            get;
            set;
        }
        public String crtnMsg {
            get;
            set;
        }
        public String ppNo {
            get;
            set;
        }
    }
}