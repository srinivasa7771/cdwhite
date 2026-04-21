public with sharing class gctlRequ extends cmpBsCtrl {
    public String empid {
        get;
        set;
    }
    public String encid {
        get;
        set;
    }
    public String sid {
        get;
        set;
    }
    public String pid {
        get;
        set;
    }
    public Boolean isgu {
        get;
        set;
    }
    public g_Req__c rq {
        get;
        set;
    }
    //dsgu--documents submitted
    public String pt {
        get;
        set;
    }
    public boolean flag {
        get;
        set;
    }
    public String pDsc {
        get;
        set;
    }
    public Boolean pgHide {
        get;
        set;
    }
    public Boolean ispu {
        get;
        set;
    }
    public string lcl {
        get {
            return UserInfo.getLocale();
        }
    }
    public list < D > Docs {
        get;
        set;
    }
    /*U_S DFZC Start*/
    public list < D > exMemDocs {
        get;
        set;
    }
    public list < g_reqDoc__c > gExmemDocLst {
        get;
        set;
    }
    public list < DAS > exMemDasLst {
        get;
        set;
    }
    /*U_S DFZC End */
    public list < g_reqDoc__c > gAllDocLst {
        get;
        set;
    }
    public string attchedDocID {
        set;
        get;
    }
    public transient String imageBase64 {
        get;
        set;
    }
    public transient String pdfimageBase64 {
        get;
        set;
    }
    public String reqDocId {
        get;
        set;
    }
    public String reqDocId2 {
        get;
        set;
    }
    public String docName {
        get;
        set;
    }
    public String sDocName {
        get;
        set;
    }
    public String fileSrc {
        get;
        set;
    }
    public Boolean incType {
        get;
        set;
    }
    public Boolean offType {
        get;
        set;
    }
    public String rgUnit {
        get;
        set;
    }
    public String priorityType {
        get;
        set;
    }
    public String dummyadh {
        get;
        set;
    }
    public boolean grpflg {
        set;
        get;
    }
    public boolean dUflg {
        set;
        get;
    }
    public list < DAS > dasLst {
        get;
        set;
    }
    public List < String > docMsgLst {
        get;
        set;
    }
    public String docType {
        get;
        set;
    }
    public String srNo {
        get;
        set;
    }
    public String Dm {
        get;
        set;
    }
    public Boolean seqFlag {
        get;
        set;
    }
    public Boolean hasRq {
        get;
        set;
    }
    public List < D2 > docList {
        set;
        get;
    }
    public String errMsg {
        get;
        set;
    }
    public User U {
        set;
        get;
    }
    public g_Srvc__c srv {
        get;
        set;
    }
    public String rqPtype {
        get;
        set;
    }
    public g_srvc_definition__c sd {
        get;
        set;
    }
    public List < g_Srvc__c > srvLst {
        set;
        get;
    }
    public String s3url {
        get;
        set;
    }
    public String exPPDoc {
        get;
        set;
    }
    public Blob uploadedFile {
        get;
        set;
    }
    public String fileName {
        get;
        set;
    }
    public String parentRecordId {
        get;
        set;
    }
    public Boolean isFContU {
        set;
        get;
    }
    public String sdid;
    public String userAgent {
        get {
            return ApexPages.currentPage().getHeaders().get('USER-AGENT');
        }
    }
    public Boolean isMobile {
        get {
            if (userAgent.contains('Windows')) return false;
            else return true;
        }
    }
    public crctnob componentOne {
        get;
        set;
    }
    public String otpResult {
        get;
        set;
    }
    public String mobNum {
        get;
        set;
    }
    public String conEmail {
        get;
        set;
    }
    public Boolean isMobileOTP {
        get;
        set;
    }
    public String otpVal {
        get;
        set;
    }
    public String otpReqId {
        get;
        set;
    }
    Static String strDocToIgnore = 'MoA or AoA Amendment of Company'; /*MS 1.1*/
    //*** ------- Initialization --------------------------------------------------------------------------------
    public gctlRequ(ApexPages.StandardController c) {
        system.debug('In Standard Constructor');
        if (ApexPages.currentPage().getParameters().get('id') != null) {
            rq = fetchREQ(ApexPages.currentPage().getParameters().get('id'));
        }
        system.debug('rq' + rq);
        gAllDocLst = new List < g_reqDoc__c > ();
        gExmemDocLst = new List < g_reqDoc__c > ();
        init();
        docList = new List < D2 > ();
    }
    public PageReference saveDraft1() {
        system.debug('status - gctlRequ' + rq.sta__c);
        system.debug('service code' + rq.srvc__r.uid__c);
        String rquestId = ApexPages.CurrentPage().getParameters().get('id');
        String sid = ApexPages.CurrentPage().getParameters().get('sid');
        system.debug('rq-65 --' + rq);
        rq = fetchREQ(rquestId);
        system.debug('rq-67 --' + rq);
        String oldSta = rq.sta__c;
        if (string.isBlank(rq.sta__c) || rq.sta__c == 'Completed' || rq.sta__c == 'Open') {
            rq.sta__c = 'Draft';
        }
        system.debug('<ApplicantDetailController> SAVE DRAFT::');
        try {
            upsert rq;
            if (sid != null) {
                rq.srvc__c = sid;
            }
            PageReference pageRef = new PageReference('/' + rq.id);
            init(rquestId);
            return null;
        } catch (DMLException exDML) {
            System.Debug('**  exDML.getDmlType(i) : ' + exDML.getNumDml() + '   **StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION: ' + StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION);
            return null;
        } catch (exception ex) {
            System.Debug('** gctlrq01 Exception:' + ex.getMessage());
            return null;
        }
    }
    public gctlRequ() {
        system.debug('In gctlRequ Constructor');
        if (ApexPages.currentPage().getParameters().get('id') != null) {
            rq = fetchREQ(ApexPages.currentPage().getParameters().get('id'));
            System.debug('*** rq :2' + rq);
            System.debug('rq.srvc__r.sdg__r.ptype__c ' + rq.srvc__r.sdg__r.ptype__c);
            rqPtype = rq.srvc__r.sdg__r.ptype__c;
        }
        gAllDocLst = new List < g_reqDoc__c > ();
        gExmemDocLst = new List < g_reqDoc__c > ();
        init();
        docList = new List < D2 > ();
    }
    public void init(String id) {
        rq = fetchREQ(id);
        System.debug('*** rq :2' + rq);
        System.debug('rq.srvc__r.sdg__r.ptype__c ' + rq.srvc__r.sdg__r.ptype__c);
        rqPtype = rq.srvc__r.sdg__r.ptype__c;
        gAllDocLst = new List < g_reqDoc__c > ();
        init();
        docList = new List < D2 > ();
    }
    public void init() {
        System.debug('*** rq :1' + rq);
        seqFlag = false;
        Boolean hasAccess2;
        String srvDefId;
        if (rq != null && rq.id != null) {
            hasRq = true;
        } else {
            hasRq = false;
        }
        ispu = gU.isPortalUser(UserInfo.getProfileId());
        isgu = gu.isGuestUser(userInfo.getProfileId());
        if (rq != null && rq.id != null) {
            try {
                pgHide = false;
                laodData();
                Validate();
                srv = [select id, AddOnSrv__c, uid__c, name, sdg__c, sdg__r.sd__c, sdg__r.ptype__c, sdg__r.docslbl__c, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c, consta__c, sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c, stg__r.reqq__c from g_Srvc__c where id =: rq.srvc__c limit 1];
                srvDefId = srv.sdg__c;
                if (string.isNotBlank(srvDefId)) {
                    hasAccess2 = gU.canAccess2(srvDefId, false, null);
                } else {
                    hasAccess2 = true;
                }
                if (!hasAccess2) {
                    pgHide = true;
                } else {
                    pgHide = false;
                }
                if (!ispu) {
                    pgHide = false;
                }
            } catch (exception ex) {
                gU.AddErrorMsg(ex);
            }
        }
    }
    public Contact emp {
        get;
        set;
    }
    public pagereference authenticateUser() {
        empid = ApexPages.currentPage().getParameters().get('empid');
        encid = ApexPages.currentPage().getParameters().get('enc');
        sid = ApexPages.currentPage().getParameters().get('sid');
        isgu = gu.isGuestUser(userInfo.getProfileId());
        pagereference pg = null;
        if (gu.isGuestUser(userInfo.getProfileId())) {
            System.debug('** Is Guest User');
            if ((rq.srvc__r.uid__c != 'dnc' && (empid == '' || empid == null || encid == '' || encid == null || !DEG_Checksum(empid, encid)) && !Test.isRunningTest())) {
                pg = new pagereference('/apex/AccesDeniedPage');
            }
        }
        if (String.isNotBlank(empid)) {
            emp = [select id, name, rped__c, RP_Expiry_Status__c, sta__c from Contact where idtxt__c =: empid limit 1];
        } else {
            return null;
        }
        return pg;
    }
    public boolean laodData() {
        rq = fetchREQ(rq.id);
        if (Label.FitOutContractorUser == UserInfo.getUserName()) {
            isFContU = true;
        }
        sid = ApexPages.CurrentPage().getParameters().get('sid');
        pid = ApexPages.CurrentPage().getParameters().get('pid');
        isgu = gu.isGuestUser(userInfo.getProfileId());
        system.debug('sid -- ' + sid + ' && ');
        Docs = new list < D > ();
        exMemDocs = new list < D > (); /*U_S DFZC*/
        docMsgLst = new List < String > ();
        priorityType = 'nf';
        if (rq == null) return null;
        if (String.isNotBlank(rq.xadh__c) && (rq.xadh__c).contains('ef;')) priorityType = 'ef';
        else if (String.isNotBlank(rq.xadh__c) && (rq.xadh__c).contains('pf;')) priorityType = 'pf';
        if (String.isNotBlank(rq.xadh__c) && (rq.xadh__c).contains('ic;')) {
            incType = true;
            if ((rq.xadh__c).contains('ofl;')) {
                offType = true;
            } else {
                offType = false;
            }
        } else {
            incType = false;
            offType = false;
        }
        if (String.isNotBlank(rq.parCat__c) && (rq.parCat__c != 'Land' || (rq.parCat__c == 'Land' && rq.xvtyp__c == 'DDA'))) strDocToIgnore += ',Attested Power of Attorney';
        List < g_reqDoc__c > tempDocLst = new List < g_reqDoc__c > (); /*tempDocLst = rq.rDocs__r;*/
        List < g_reqDoc__c > exMemppDocList = new List < g_reqDoc__c > (); /*U_S*/
        for (g_reqDoc__c objDoc: rq.rDocs__r) {
            system.debug('objDoc===' + objDoc.Name);
            String docname = objDoc.Name.split('-')[0].trim();
            if (!strDocToIgnore.contains(docname) && !objDoc.Name.startsWith('Exmem')) /*MS 1.1*/ {
                tempDocLst.add(objDoc);
            }
            if (objDoc.Name.startsWith('Exmem')) {
                exMemppDocList.add(objDoc);
                system.debug('--exMemppDocList--' + exMemppDocList);
            }
        }
        system.debug('tempDocLst rq.rDocs__r >>>1');
        gAllDocLst = [Select Id, Name, lbl__c, mxAts__c, mnAts__c, ats__c, Req__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, upOk__c, mbr__c, mbr__r.Name, Doc_Description__c, Download_Doc_Link__c From g_reqDoc__c where RQ__c =: rq.id and(Not Name Like: strDocToIgnore + '%') order by ord__c NULLS LAST]; /*MS 1.1*/
        gExmemDocLst = [Select Id, Name, lbl__c, mxAts__c, mnAts__c, ats__c, Req__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, upOk__c, mbr__c, mbr__r.Name, Doc_Description__c, Download_Doc_Link__c From g_reqDoc__c where RQ__c =: rq.id and Name Like 'Exmem%'
            order by ord__c NULLS LAST
        ]; /*U_S DFZC*/
        system.debug('gAllDocLst >>>' + gAllDocLst);
        system.debug('gExmemDocLst >>>' + gExmemDocLst);
        system.debug('tempDocLst rq.rDocs__r >>>3');
        map < Id, g_reqDoc__c > mD = new map < Id, g_reqDoc__c > ();
        map < Id, g_reqDoc__c > exMemD = new map < Id, g_reqDoc__c > ();
        system.debug('sDocName >>' + sDocName);
        List < String > sDocLst = new List < String > ();
        List < String > sDocNameLst = new List < String > ();
        if (sDocName != null && sDocName != '') {
            sDocLst = sDocName.split(';');
            for (String s: sDocLst) {
                system.debug('s >>' + s);
                List < String > sLst = s.split(':');
                system.debug('sLst >>' + sLst);
                sDocNameLst.add(sLst[0]);
            }
            system.debug('sDocNameLst >>' + sDocNameLst);
            tempDocLst = gAllDocLst;
            exMemppDocList = gExmemDocLst; /*U_S DFZC*/
            system.debug('new tempDocLst >>>' + tempDocLst);
            system.debug('new exMemppDocList >>>' + exMemppDocList);
        }
        system.debug('tempDocLst rq.rDocs__r >>>6');
        for (g_reqDoc__c dc: tempDocLst) {
            system.debug('dc.Name >>' + dc.Name);
            if (sDocName != null && sDocName != '') {
                /*if(sDocName ==dc.Name){*/
                if (sDocNameLst.contains(dc.Name)) {
                    mD.put(dc.Id, null);
                    Docs.add(new D(dc));
                }
            } else {
                mD.put(dc.Id, null);
                Docs.add(new D(dc));
            }
        } /*U_S DFZC Start*/
        if (exMemppDocList != null && !exMemppDocList.isEmpty()) {
            for (g_reqDoc__c objExPP: exMemppDocList) {
                system.debug('objExPP.Name >>' + objExPP.Name);
                exMemD.put(objExPP.Id, null);
                system.debug('exMemD >>' + exMemD);
                exMemDocs.add(new D(objExPP));
                system.debug('exMemDocs >>' + exMemDocs);
            } /*U_S DFZC End*/
        }
        system.debug('mdkeyset===' + md.KeySet());
        system.debug('exMemD===' + exMemD.KeySet());
        mD = new map < Id, g_reqDoc__c > ([Select Id, Name, lbl__c, (Select Id, Name, CreatedDate, CreatedBy.ProfileId, CreatedById From Attachments where isDeleted = false), (Select Id, reqItm__c, reqItm__r.rq__r.Service_Code__c, reqItm__r.xcfn__c, reqItm__r.xcln__c, reqItm__r.nc__c, reqItm__r.STA__c, reqItm__r.STA__r.cd__c, reqItm__r.itm__r.dSTA__c, reqItm__r.itm__r.Name, reqItm__r.itm__r.lbl__c, lbl__C, reqItm__r.itm__r.cd__c From Docs__r where isDeleted = false), ord__c, ats__c, Req__c, Doc_Description__c, Download_Doc_Link__c From g_reqDoc__c where id in: mD.KeySet() ORDER BY ord__c]);
        exMemD = new map < Id, g_reqDoc__c > ([Select Id, Name, lbl__c, (Select Id, Name, CreatedDate, CreatedBy.ProfileId, CreatedById From Attachments where isDeleted = false), (Select Id, reqItm__c, reqItm__r.rq__r.Service_Code__c, reqItm__r.xcfn__c, reqItm__r.xcln__c, reqItm__r.nc__c, reqItm__r.STA__c, reqItm__r.STA__r.cd__c, reqItm__r.itm__r.dSTA__c, reqItm__r.itm__r.Name, reqItm__r.itm__r.lbl__c, lbl__C, reqItm__r.itm__r.cd__c From Docs__r where isDeleted = false), ord__c, ats__c, Req__c, Doc_Description__c, Download_Doc_Link__c From g_reqDoc__c where id in: exMemD.KeySet() ORDER BY ord__c]);
        for (D doc: Docs) {
            g_reqDoc__c dc = mD.get(doc.Doc.Id);
            doc.addAttachments(dc.Attachments);
            doc.doc.ord__c = dc.ord__c;
            set < String > rqItms = new set < String > ();
            for (g_reqitemDoc__c i: dc.Docs__r) {
                if (i.reqItm__r.rq__r.Service_Code__c == '216' && (i.lbl__c).contains(i.reqItm__r.itm__r.cd__c)) {
                    String nm = (String.isBlank(i.reqItm__r.xcfn__c)) ? i.reqItm__r.xcln__c : i.reqItm__r.xcfn__c + ' ' + i.reqItm__r.xcln__c;
                    doc.dsc = (i.lbl__c).replace('- ' + i.reqItm__r.itm__r.cd__c, (nm != null) ? '- ' + nm : ''); /*MS 1.1*/
                    if (dc.name.contains('Attested Power of Attorney')) {
                        /* doc.dsc  = '';*/ }
                }
                rqItms.add(ispu ? i.reqItm__r.itm__r.lbl__c : i.reqItm__r.itm__r.Name);
                doc.VF = rq.STA__c == 'Draft' || rq.STA__c == 'Open' ? false : (!(i.reqItm__r.nc__c) || i.reqItm__r.itm__r.dSTA__c != i.reqItm__r.STA__r.cd__c);
            }
            String sIs = '';
            Integer i = 0;
            for (String itm: rqItms) {
                sIs = (sIs == '' ? '' : sIs + (i == rqItms.size() - 1 ? ' and ' : ', ')) + itm;
                i++;
            }
            doc.Info = 'Needed for ' + sIs; /* rq.xcddocs__c; doc.Info='Needed for IBM Ireland Product Distribution Limited';*/
            String reqFor = '';
            if (rq.xcddocs__c != null && rq.xcddocs__c != '') {
                List < String > doclst = rq.xcddocs__c.split(';');
                for (String x: doclst) {
                    if (x.contains(':')) {
                        List < String > lx = x.split(':');
                        if ((dc.Name).contains(lx[0])) {
                            if (String.isBlank(reqFor)) {
                                if (lx != null && lx.size() > 0) {
                                    reqFor = '<li>' + lx[1] + '</li>';
                                }
                            } else {
                                if (lx != null && lx.size() > 0) {
                                    reqFor = reqFor + '<li>' + lx[1] + '</li>';
                                }
                            }
                        }
                    }
                }
            }
            if (String.isNotBlank(reqFor)) {
                doc.Info = 'Needed for ShareHolder : ' + '<ol>' + reqFor + '</ol>';
            }
        }
        system.debug('1 Docs >>>>>>>' + Docs);
        for (D exMemdoc: exMemDocs) {
            g_reqDoc__c exMemdc = exMemD.get(exMemdoc.Doc.Id);
            exMemdoc.addAttachments(exMemdc.Attachments);
            set < String > rqItms = new set < String > ();
        }
        reArrangeDocs();
        return true;
    }
    public void reArrangeDocs() {
        list < D > dUploadLst = new list < D > ();
        list < D > dUploadedLst = new list < D > ();
        list < D > exMemdUploadLst = new list < D > (); /*U_S DFZC */
        list < D > exMemdUploadedLst = new list < D > (); /*U_S DFZC */
        grpflg = false;
        dUflg = false;
        if (Docs != null && Docs.size() > 0) {
            for (D d: Docs) {
                if (d.Ats == null || d.doUp || (d.doc.ats__c == 0 && d.doc.Req__c)) {
                    dUploadLst.add(d);
                } else dUploadedLst.add(d);
            }
            Docs = new list < D > ();
            Docs.addAll(dUploadLst);
            Docs.addAll(dUploadedLst);
        } /*U_S DFZC Start*/
        if (exMemDocs != null && exMemDocs.size() > 0) {
            system.debug('---exMemDocs---1' + exMemDocs);
            for (D exMemd: exMemDocs) {
                if (exMemd.Doc.name.startsWith('Exmem')) {
                    if (exMemd.Ats == null || exMemd.doUp || (exMemd.doc.ats__c == 0 && exMemd.doc.Req__c)) {
                        exMemdUploadLst.add(exMemd);
                    } else exMemdUploadedLst.add(exMemd);
                }
            }
            system.debug('exMemdUploadLst -- ' + JSON.serialize(exMemdUploadLst));
            system.debug('exMemdUploadedLst -- ' + JSON.serialize(exMemdUploadedLst));
            exMemDocs = new list < D > ();
            exMemDocs.addAll(exMemdUploadLst);
            exMemDocs.addAll(exMemdUploadedLst);
            system.debug('exMemDocs --2 ' + JSON.serialize(exMemDocs));
        }
        if (exMemDocs != null && exMemDocs.size() > 0) {
            system.debug('---exMemDocs---3' + exMemDocs);
            exMemDasLst = new List < DAS > ();
            List < DAS > exMemdasUploadLst = new List < DAS > ();
            List < DAS > exMemdasUploadedLst = new List < DAS > ();
            for (D exMemdoc: exMemDocs) {
                if (exMemdoc.cnUp || (exMemdoc.Doc.mxAts__c == null && exMemdoc.Ats.size() == 0)) {
                    DAS exMemds = new DAS();
                    exMemds.d = exMemdoc;
                    exMemds.att = null;
                    exMemds.upload = true;
                    exMemds.minAttDon = ((exMemdoc.Ats.size() == 0 || exMemdoc.Ats.size() < exMemdoc.Doc.mnAts__c) ? false : true);
                    exMemdasUploadLst.add(exMemds);
                    system.debug('---exMemdasUploadLst---' + exMemdasUploadLst);
                }
                if (exMemdoc.Ats != null && exMemdoc.Ats.size() > 0) {
                    for (Attach at: exMemdoc.Ats) {
                        DAS exMemds = new DAS();
                        exMemds.d = exMemdoc;
                        exMemds.att = at;
                        exMemds.a = at.A;
                        exMemds.upload = false;
                        exMemds.minAttDon = ((exMemdoc.Ats.size() == 0 || exMemdoc.Ats.size() < exMemdoc.Doc.mnAts__c) ? false : true);
                        exMemdasUploadedLst.add(exMemds);
                        system.debug('---exMemdasUploadedLst---' + exMemdasUploadedLst);
                    }
                }
            }
            exMemDasLst.addAll(exMemdasUploadLst);
            exMemDasLst.addAll(exMemdasUploadedLst);
            system.debug('--exMemDasLst--' + exMemDasLst);
        } /*U_S DFZC End*/
        docMsgLst = new List < String > ();
        if (Docs != null && Docs.size() > 0) {
            dasLst = new List < DAS > ();
            List < DAS > dasUploadLst = new List < DAS > ();
            List < DAS > dasUploadedLst = new List < DAS > ();
            for (D d: Docs) {
                if (d.cnUp || (d.Doc.mxAts__c == null && d.Ats.size() == 0)) {
                    DAS ds = new DAS();
                    ds.d = d;
                    ds.att = null;
                    ds.upload = true;
                    ds.minAttDon = ((d.Ats.size() == 0 || d.Ats.size() < d.Doc.mnAts__c) ? false : true);
                    if (d.Ats == null || d.doUp) {
                        docMsgLst.add(d.doc.name);
                    }
                    if (rq.srvc__r.uid__c == '208' || rq.srvc__r.uid__c == '216' || rq.srvc__r.uid__c == '327' || rq.srvc__r.uid__c == '220') {
                        if (String.isBlank(d.Doc.tplt__c) || (String.isNotBlank(d.Doc.tplt__c) && rq.piFlg__c)) dUflg = true;
                    } else if (String.isBlank(d.Doc.tplt__c) || (String.isNotBlank(d.Doc.tplt__c) && rq.piFlg__c)) dUflg = true;
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
            system.debug('dasLst >>>' + dasLst);
        }
    } //*** ------- Wrappers --------------------------------------------------------------------------------
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
        } {
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
        } {
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
        /*Docs with single attach*/
        public D d {
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
        } /* have atleat one file attachted*/
    }
    public static boolean DEG_Checksum(String msg, String encText) {
        String eCd = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', blob.valueOf('P@ssw0rdAXSHRMS' + msg))).toUpperCase();
        System.debug('** eCd:' + eCd);
        System.debug('** encText:' + encText);
        return eCd == encText;
    }
    private void Validate() {
        gU.checkNav();
    }
    public g_Req__c fetchREQ(ID rqid) {
        String m_SOQL;
        String m_SOQL1;
        g_Req__c rqt = [Select id, xadh__c, name, Acc__r.clt__c, xadtx5__c, Acc__r.lc__c, xuvdet__c, xcddocs__c, xadtx3__c, xadtx2__c, xadtx4__c, xadtx1__c, srvc__r.sdg__r.ptype__c, srvc__r.stg__r.docq__c, srvc__r.sdg__c, xcamc__c From g_Req__c where id =: rqid];
        m_SOQL = rqt.srvc__r.stg__r.docq__c;
        m_SOQL1 = rqt.srvc__r.sdg__r.ptype__c;
        system.debug('m_SOQL >>>' + m_SOQL);
        g_Req__c rRqt = (g_Req__c) Database.query(m_SOQL + ' where id=\'' + rqt.Id + '\' and isDeleted = false');
        rRqt.xadtx2__c = rqt.xadtx2__c;
        rRqt.xadtx3__c = rqt.xadtx3__c;
        rRqt.xadtx4__c = rqt.xadtx4__c;
        rRqt.xuvdet__c = rqt.xuvdet__c;
        rRqt.xcddocs__c = rqt.xcddocs__c;
        rRqt.xadtx1__c = rqt.xadtx1__c;
        return rRqt;
    }
    @TestVisible private Boolean hasAccess() {
        if (rq == null) {
            return true;
        }
        Boolean blOk = gU.canReqSrvc(rq.srvc__c, false, 'grqup');
        if (!blOk) {
            gU.addInfoMsg(Label.msgNoPrivilege);
        }
        if (rq.STA__c != 'Open' && rq.STA__c != 'Under Review' && rq.STA__c != 'In Process') {
            blOk = false;
        }
        if (rq.Items__r == null) {
            gU.AddWarningMsg(Label.msgNoItems);
            blOk = false;
        } else if (rq.Items__r.size() < 0) {
            gU.AddWarningMsg(Label.msgNoItems);
            blOk = false;
        }
        return blOk;
    }
    //*** ------- DB Handlers --------------------------------------------------------------------------------  
    public void createRQ() {
        sdid = ApexPages.CurrentPage().getParameters().get('sid');
        String xtcdl = ApexPages.CurrentPage().getParameters().get('xtcdl');
        try {
            rq.STA__c = 'Open';
            List < User > u = [SELECT Name, AccountId FROM User WHERE Id =: UserInfo.getUserId()];
            rq.Acc__c = u[0].AccountId;
            if (String.isNotBlank(dummyadh)) {
                g_req__c DummyReq = (g_req__c) JSON.deserialize(dummyadh, g_req__c.Class);
                system.debug('DummyReq:::::' + DummyReq);
                Map < String, Schema.SObjectField > fields = Schema.getGlobalDescribe().get('g_req__c').getDescribe().fields.getMap();
                for (Schema.SObjectField fieldRef: fields.values()) {
                    Schema.DescribeFieldResult fieldResult = fieldRef.getDescribe();
                    if (fieldResult.isUpdateable()) {
                        if (DummyReq.get(fieldRef) != null) {
                            System.debug('DummyReq.get(fieldRef): ' + DummyReq.get(fieldRef));
                            rq.put(fieldRef, DummyReq.get(fieldRef));
                        }
                    }
                }
            }
            upsert rq;
        } catch (Exception e) {
            errMsg = e.getMessage();
            system.debug('ErrMsg>>>>>' + errMsg);
        }
    }
    public void setGreqitemDocRequired(String reqDocId) {
        List < g_reqitemDoc__c > rdocList = [select id, name, Req__c, reqAts__c from g_reqitemDoc__c where reqDoc__c =: reqDocId];
        if (rdocList != null && rdocList.size() > 0) {
            if (!rdocList[0].Req__c) {
                rdocList[0].Req__c = true;
                rdocList[0].reqAts__c = true;
                update rdocList;
            }
        }
    }
    public String getReqDocId(String rqid, String attName) {
        attName = (attName.remove(';')).trim().toLowerCase();
        List < g_reqDoc__c > rdocList = [select id, name, lbl__c from g_reqDoc__c where RQ__c =: rqid];
        Map < String, String > dIdNamMap = new Map < String, String > ();
        for (g_reqDoc__c r: rdocList) {
            if (String.isNotBlank(r.lbl__c)) dIdNamMap.put((r.lbl__c).trim().toLowerCase(), r.id);
            else dIdNamMap.put((r.name).trim().toLowerCase(), r.id);
        }
        return dIdNamMap.get(attName);
    }
    public PageReference saveRequest() {
        update rq;
        saveAttachment();
        return null;
    }
    public void callLAWS() {
        if (String.isNotBlank(rq.xadtx3__c)) {
            rq.xadtx3__c = rq.xadtx3__c.replaceAll('""', 'null');
        }
        update rq;
        DccaBatchUtil.exchLaCreation(rq.id);
    }
    public String docId {
        get;
        set;
    }
    public String ddaDocName {
        get;
        set;
    }
    public transient String docBase64 {
        get;
        set;
    }
    public String otpSentMobileOREmail {
        get;
        set;
    }
    public void getDDADoc() {
        system.debug('docId -- ' + docId);
        system.debug('ddaDocName -- ' + ddaDocName);
        if (!String.isBlank(docId) && docId.length() >= 15 && docId.length() <= 18) {
            String rqBody = '{ "Method": "GetDocumentById", "Data": { "documentId": "' + docId + '" } }';
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept', 'application/json');
            request.setEndpoint('callout:DCCA_Auth/apexrest/LicenseService');
            request.setMethod('GET');
            request.setBody(rqBody);
            request.setTimeout(60000);
            HttpResponse response = h.send(request);
            system.debug('--response --' + response.getBody());
            docBase64 = response.getBody();
            system.debug('--docBase64--' + docBase64);
        } else if (!String.isBlank(docId)) {
            String originalUrl = docId;
            String substringToRemove = 'https://dubaiholding.sharepoint.com';
            String serviceName = 'INTEGRATIO_INBOUND_FROMDCCASE/2.0/TriggerInboundFromDCCAServers';
            String cleanedUrl = originalUrl.replace(substringToRemove, '');
            String rqBody = '{ "User": "IntegrationUser", "Token": "07D92428-7B9C-4088-920F-81B48C762904", "Method": "GetDocumentSF", "Data": { "site": "' + cleanedUrl + '", "url": "' + cleanedUrl + '" } }';
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept', 'application/json');
            request.setEndpoint('callout:OIC_Integration_PROD/' + serviceName);
            request.setMethod('GET');
            request.setBody(rqBody);
            request.setTimeout(60000);
            HttpResponse response = h.send(request);
            docBase64 = response.getBody();
            system.debug('--response11 --' + response.getBody());
        }
    }
    public PageReference saveAttachment() {
        Boolean rDirect = false; /*U_S DFZC Start*/
        Boolean reCallWs = false;
        list < g_reqDoc__c > docList = [SELECT Id, Name FROM g_reqDoc__c WHERE(Name LIKE '%Emirates Id%'
            OR Name LIKE '%Visa Page%') AND dda_att__c = null AND RQ__c =: rq.id];
        if (docList != null && docList.size() > 0) {
            reCallWs = true;
            system.debug('in this recall');
        } /*U_S DFZC End*/
        if (rq != null && rq.id != null) {
            rDirect = true;
        } else {
            rDirect = false;
        }
        if (rq != null && rq.id == null) {
            createRQ();
        }
        if (rq.id == null) {
            return null;
        }
        String attName = '';
        try {
            attName = docName;
            if (attName != null) {
                attName = attName.toLowerCase();
                if (attName.contains('.jpg')) {
                    attName = attName.replace('.jpg', ';');
                }
                if (attName.contains('.pdf')) {
                    attName = attName.replace('.pdf', ';');
                } /*U_S DFZC Start*/
                if (attName.contains('existing member')) {
                    attName = attName.replace('existing member', 'Exmem');
                    system.debug('attName::0' + attName);
                } /*U_S DFZC End*/
                system.debug('attName::' + attName);
            }
            if (reqDocId == null || reqDocId == '') {
                reqDocId = getReqDocId(rq.id, attName);
                system.debug('reqDocId -- ' + reqDocId);
            }
            String pdfdocName = docName;
            if (docName.contains('EIDA Application form')) {
                if (docName.contains('.jpg')) {
                    pdfdocName = docName.replace('.jpg', '.pdf');
                }
                Attachment pdfA = new Attachment(Body = EncodingUtil.base64Decode(imageBase64), Name = pdfdocName, ParentId = reqDocId);
                pdfA.ContentType = 'application/pdf';
                insert pdfA;
            }
            if (rq.srvc__r.uid__c == '216') {
                String doclbl = grqWsOnboard.updateRqDocs(reqDocId);
                docName = docName.replace(docName.substringBefore('.'), doclbl);
            }
            if (rq.srvc__r.uid__c == '220' || rq.srvc__r.uid__c == '216' || rq.srvc__r.uid__c == '208' || rq.srvc__r.uid__c == '200' || rq.srvc__r.uid__c == '201') {
                Integer lastDot = docName.lastIndexOf('.');
                String baseName;
                if (lastDot > -1) {
                    baseName = docName.substring(0, lastDot);
                } else {
                    baseName = docName;
                }
                String newFileName = baseName + '.pdf';
                docName = newFileName;
            }
            Attachment A = new Attachment(Body = EncodingUtil.base64Decode(imageBase64), Name = docName, ParentId = reqDocId);
            system.debug('A:' + A);
            system.debug('2 A>>>' + A);
            system.debug('reqDocId -- ' + reqDocId);
            insert A;
            attchedDocID = A.id;
            system.debug('docName::' + docName);
            List < g_reqDoc__c > rqDocList = new List < g_reqDoc__c > ();
            List < g_reqitemDoc__c > rqItmList = new List < g_reqitemDoc__c > ();
            if (rq.srvc__r.uid__c == '220' && (docName.toLowerCase().contains('emirates id') || docName.toLowerCase().contains('visa page') || docName.toLowerCase().contains('ric form') || docName.toLowerCase().contains('passport copy') || docName.toLowerCase().contains('trade license copy'))) {
                System.debug('==b==rq.xadtx3__c====' + rq.xadtx3__c);
                Map < String, String > ocrDDACountries = new Map < String, String > ();
                for (Country__c c: [Select id, Name, cntdda__c from Country__c limit 500]) {
                    if (String.isNotBlank(c.cntdda__c)) ocrDDACountries.put(c.name, c.cntdda__c);
                }
                if (String.ISNOTBLANK(rq.xadtx3__c)) {
                    rq.xadtx3__c = rq.xadtx3__c.replaceAll('""', 'null');
                }
                LARequestWrapper adhoc3Data = (LARequestWrapper) System.JSON.deserialize(rq.xadtx3__c, LARequestWrapper.class);
                system.debug('adhoc3Data -- ' + adhoc3Data);
                List < g_reqDoc__c > rqDocs = [select id, ppn__c, name, epu__c from g_reqDoc__c where id =: reqDocId limit 1];
                Attachment objAtt = [select id from attachment where id =: A.id];
                Attachment newA;
                List < LARequestWrapper.Members > mlst = new List < LARequestWrapper.Members > ();
                List < LARequestWrapper > larwrplst = new List < LARequestWrapper > ();
                LARequestWrapper lawrp = new LARequestWrapper();
                List < LARequestWrapper.ServiceRequests > serviceRequests = new List < LARequestWrapper.ServiceRequests > ();
                LARequestWrapper.ServiceRequests sr = new LARequestWrapper.ServiceRequests();
                sr.serviceId = adhoc3Data.serviceRequests[0].serviceId;
                sr.axsRefNo = adhoc3Data.serviceRequests[0].axsRefNo;
                sr.licenseNo = adhoc3Data.serviceRequests[0].licenseNo;
                sr.isPaid = adhoc3Data.serviceRequests[0].isPaid;
                map < string, string > ppMapwithdocid = new map < string, string > ();
                for (LARequestWrapper.Members m: adhoc3Data.serviceRequests[0].members) {
                    String memName = (docName.contains('-')) ? docName.split('-')[docName.split('-').size() - 1].trim() : '';
                    String memName1 = (memName.contains('.')) ? memName.split('\\.')[0].trim() : '';
                    system.debug('---exPPDoc--' + exPPDoc);
                    system.debug('---docName--' + docName);
                    system.debug('---docId--' + docId);
                    system.debug('---ppMapwithdocid--' + ppMapwithdocid);
                    String extractedName = exPPDoc.substringAfter(' - ');
                    if (m.actionType == 'ADD' || m.actionType == 'UPDATEINFO' || m.actionType == 'DataUpdate') {
                        if (m.actionType == 'UPDATEINFO' || m.actionType == 'DataUpdate') {
                            string memberName = m.firstName.trim() + ' ' + m.lastName.trim();
                            if ((exPPDoc == 'Passport Copy' || memberName == extractedName) && !string.isblank(docId) && !ppMapwithdocid.containskey(docId)) {
                                ppMapwithdocid.put(exPPDoc, docId);
                                system.debug('---ppMapwithdocid----' + ppMapwithdocid);
                                if (string.isblank(m.passports[0].uploadedExDoc)) m.passports[0].uploadedExDoc = ppMapwithdocid.get(exPPDoc);
                            }
                        }
                        if (m.actionType == 'ADD') {
                            m.passports[0].uploadedExDoc = '';
                        }
                        if (String.isBlank(m.attachmentId) && docName.toLowerCase().contains('passport copy')) {
                            m.attachmentId = attchedDocID;
                        }
                        if (memName1 == m.firstName + ' ' + m.lastName) {
                            if (String.isBlank(m.EIDfId) && docName.toLowerCase().contains('emirates id - front')) {
                                system.debug('attchedDocID -- ' + attchedDocID);
                                m.EIDfId = attchedDocID;
                            }
                            if (String.isBlank(m.EIDbId) && docName.toLowerCase().contains('emirates id - back')) {
                                system.debug('attchedDocID -- ' + attchedDocID);
                                m.EIDbId = attchedDocID;
                            }
                            if (String.isBlank(m.visaId) && docName.toLowerCase().contains('visa page')) {
                                system.debug('attchedDocID -- ' + attchedDocID);
                                m.visaId = attchedDocID;
                            }
                        }
                    }
                    if (ocrDDACountries.containsKey(m.nationality)) {
                        m.nationality = ocrDDACountries.get(m.nationality);
                    }
                    mlst.add(m);
                }
                sr.members = mlst;
                serviceRequests.add(sr);
                lawrp.serviceRequests = serviceRequests;
                rq.xadtx3__c = JSON.serialize(lawrp, true);
                if (docName.toLowerCase().contains('passport copy') || docName.toLowerCase().contains('trade license') || reCallWs) {
                    callLAWS();
                } else {
                    update rq;
                }
                rq = fetchREQ(rq.id);
                if ((rq.xcamc__c == 'Change of General Manager' || rq.xcamc__c == 'Appoint/Change of Secretary') && docName.toLowerCase().contains('passport copy') && !string.isblank(docId)) {
                    rqDocs[0].epu__c = true;
                    update rqDocs[0];
                }
                if (!string.isblank(rq.xcddocs__c) && (rq.xcamc__c == 'Change of Director - Add New' || rq.xcamc__c == 'Change of Director - Add and Remove')) {
                    List < dccabatchutil.laah2Warp > lsWap = (List < dccabatchutil.laah2Warp > ) System.JSON.deserialize(rq.xadtx2__c, List < dccabatchutil.laah2Warp > .class);
                    string attchName, ricName, ppNumber = '';
                    map < string, string > ppMap = new map < string, string > ();
                    for (dccabatchutil.laah2Warp mp: lsWap) {
                        attchName = mp.firstName + ' ' + mp.lastName;
                        attchName = attchName.trim();
                        if (!ppMap.containsKey(attchName)) {
                            ppMap.put(attchName, mp.ppNum);
                        }
                        if (ppMap.containsKey(attchName) && docName.contains(attchName)) {
                            ppNumber = ppMap.get(attchName);
                            ricName = docName.replace('Passport Copy', 'RIC Form');
                        }
                    }
                    List < g_reqDoc__c > rqDocsRic = [select id, ppn__c, name from g_reqDoc__c where RQ__c =: rq.id and name like: '%' + ricName + '%'
                        and ppn__c = null limit 1
                    ];
                    if ((rqDocs.size() > 0 && rqDocsRic.size() > 0) || docName.toLowerCase().contains('existing member passport')) {
                        system.debug('--ppNumber3--' + ppNumber);
                        system.debug('--docid--' + docid);
                        if (docName.toLowerCase().contains('passport copy') && (string.isblank(rqDocs[0].ppn__c) || docName.toLowerCase().contains('existing member passport'))) {
                            /*U_S*/
                            system.debug('---Inside Exmemdoc');
                            if (!string.isblank(exPPDoc)) {
                                rqDocs[0].epu__c = true;
                                system.debug('--EPU--1' + rqDocs[0].epu__c);
                            }
                            system.debug('--EPU--' + rqDocs[0].epu__c);
                            rqDocs[0].ppn__c = ppNumber;
                            if (rqDocsRic.size() > 0) rqDocsRic[0].ppn__c = ppNumber;
                            update rqDocs;
                            update rqDocsRic;
                        }
                    }
                }
                return new PageReference('/lrqup?id=' + rq.Id);
            }
            if (rq.srvc__r.uid__c == '216' && (rq.sta__c == 'Under Review' || rq.crflg__c || attName.containsIgnoreCase('Ejari certificate') || attName.containsIgnoreCase('PSA Agreement'))) {
                List < g_reqDoc__c > rqDoclst = [select id, name, rq__r.acc__r.clt__c, rq__r.xvtyp__c, rq__r.acc__c, rq__r.csp__c, rq__r.acc__r.ccrm_sfid__c, rq__r.xdccaRq__c, (select id, reqItm__c from Docs__r) from g_reqDoc__c where id =: reqDocId]; /*MS1.1*/
                if (rqDoclst != null && !rqDoclst.isEmpty()) {
                    ws_call__c wc = new ws_call__c();
                    wc.intsts__c = 'Ready for Integration';
                    wc.rq_itm__c = rqDoclst[0].Docs__r[0].reqItm__c;
                    if (rqDoclst[0].rq__r.Acc__r.clt__c != 'Land' || rqDoclst[0].rq__r.xvtyp__c == 'DDA') {
                        if (attName.containsIgnoreCase('PSA Agreement')) {
                            wc.rq_jsn__c = A.id;
                            wc.pmid__c = rqDoclst[0].rq__r.acc__r.ccrm_sfid__c;
                            wc.ws_typ__c = 'DDA Amendments';
                            wc.mtd_nm__c = 'uploadDoc';
                            wc.adhoc_text1__c = docName;
                        } else if (rq.sta__c == 'Under Review' || rq.crflg__c) {
                            List < g_reqitem__c > riLst = [select id from g_reqitem__c where RQ__c =: rq.id and itm__r.cd__c = 'dr'];
                            wc.rq_itm__c = riLst[0].id;
                            wc.pmid__c = A.id;
                            wc.ws_typ__c = 'Onboarding';
                            wc.mtd_nm__c = 'uploadDoc';
                            wc.adhoc_text1__c = docName;
                        }
                    } /*Update BY Meenu to push call for review land doc to ccrm  MS 1.1 */
                    else if (rqDoclst[0].rq__r.Acc__r.clt__c == 'Land' && rqDoclst[0].rq__r.xvtyp__c == 'DED') {
                        wc.ws_typ__c = 'Onboarding';
                        wc.mtd_nm__c = 'uploadDoc1';
                        wc.res_jsn__c = rqDoclst[0].id;
                    }
                    insert wc;
                    if (attName.containsIgnoreCase('PSA Agreement')) {
                        Account acc = new Account(id = rqDoclst[0].rq__r.acc__c, stapsa__c = 'Signed');
                        update acc;
                    }
                }
            }
            if (rq.srvc__r.uid__c == '196' && attName.containsIgnoreCase('Insurance Policy')) {
                List < g_reqitem__c > riLst = [select id from g_reqitem__c where RQ__c =: rq.id and itm__r.cd__c = 'dr'];
                ws_call__c wss = new ws_call__c();
                wss.rq_jsn__c = A.id;
                wss.ws_typ__c = 'axsLeaseRenewal';
                wss.mtd_nm__c = 'BankAccUpdate';
                wss.rq_itm__c = riLst[0].Id;
                wss.intsts__c = 'Ready for Integration';
                insert wss;
            }
            if (!isgu) {
                setGreqitemDocRequired(reqDocId);
                if (attName.contains('Copy Of Entry Permit') || attName.contains('New Entry Permit')) {
                    rq.xepAtt__c = A.Id;
                    update rq;
                }
                system.debug('attName>>>' + attName);
                if (gU.csStr('Photo').toLowerCase().contains(attName.toLowerCase())) {
                    if (rq.xphid__c == null) {
                        rq.xphid__c = A.Id;
                        update rq;
                    }
                    if (rq.xphid__c != A.Id) {
                        rq.xphid__c = A.Id;
                        update rq;
                    }
                    if (rq.Con__r != null && rq.srvc__r.uid__c != '050' && rq.srvc__r.uid__c != '051' && rq.srvc__r.uid__c != '052') {
                        Contact c = rq.Con__r;
                        c.Photo_ID__c = A.Id;
                        update C;
                    }
                }
            }
            init();
            System.debug('saveAttachment <nP> : ' + nP + '<nD> :' + nD); /*MS 1.1*/
            if (!nD && ((!nP && ispu) || (rq.srvc__r.uid__c == '208' && rq.xpmsle__c && !rq.xcawp__c && rq.xdrv__c) || rq.srvc__r.uid__c == 'apt') && (rq.srvc__r.uid__c != '216' && rq.parcat__c != 'Land') && (rq.srvc__r.uid__c != '327' && rq.os__c != 'Contractor Appointed')) {
                updateItemSTA();
            }
            if (!nP && !nD && ispu) {
                markRQUR();
            }
            system.debug('------pageController-------call reRender -- ');
            if (pageController != null) {
                componentOne = (crctnob) pageController;
                componentOne.reRender(rq.id);
            }
            return null;
        } catch (Exception e) {
            system.debug('exception::' + e.getStackTraceString());
            system.debug('exception::' + e);
        }
        system.debug('rDirect >>>' + rDirect);
        if (!nP && !nD && (rq.srvc__r.uid__c == 'uma' || rq.srvc__r.uid__c == 'uae' || rq.srvc__r.uid__c == 'tad' || rq.srvc__r.uid__c == '162' || rq.srvc__r.uid__c == '199')) {
            return null; /*rq.STA__c = 'open';update rq;  return new PageReference('/apex/' + rq.Id );*/
        }
        if (!nP && !nD && ispu && rq.srvc__r.uid__c != '216' && rq.srvc__r.uid__c != '220' && rq.srvc__r.uid__c != 'aml' && rq.srvc__r.uid__c != '135' && rq.srvc__r.uid__c != '136') {
            rq.STA__c = 'Under Review';
            update rq;
            if (rq.srvc__r.uid__c == '149' || rq.srvc__r.uid__c == '152') {
                system.debug('rq.srvc__r.uid__c -- ' + rq.srvc__r.uid__c);
                new ParkingM().pushReqItemsCrctn(rq.Id, new list < g_reqitem__c > ());
            }
            gu.AddSuccessMsg('Your request has been submitted successfully,');
            System.debug('====in here====');
            return new PageReference('/apex/grqSInfo?id=' + rq.Id);
        }
        if (!rDirect) {
            String rUrl = Apexpages.currentPage().getUrl();
            rUrl = rUrl.substringBefore('?');
            system.debug('rUrl>>' + rUrl);
            Pagereference ref = new Pagereference(rUrl + '?sid=' + sdid + '&id=' + rq.id);
            ref.setRedirect(true);
            return ref;
        } else {
            return null;
        }
    }
    public void deleteAttachment() {
        try {
            Attachment A = new Attachment(Id = reqDocId);
            delete A;
            init();
        } catch (Exception e) {
            gU.AddErrorMsg(e);
        }
    }
    public void deleteAttachment2() {
        try {
            system.debug('deleteAttachment2 reqDocId2 >>' + reqDocId2);
            Attachment A = new Attachment(Id = reqDocId2);
            Attachment att = [select id, parentid from Attachment where id =: reqDocId2];
            system.debug('---att---' + att);
            g_reqDoc__c rqdoc = [select id, ppn__c, epu__c, dda_att__c from g_reqDoc__c where id =: att.parentid];
            if (rqdoc.epu__c) {
                rqdoc.epu__c = false;
                update rqdoc;
            }
            if (!string.isblank(rq.xcamc__c) && rq.xcamc__c != 'Remove Director') rq.xoca__c = false;
            if (rq.srvc__r.uid__c == '220' && String.isNotBlank(rq.xadtx3__c)) {
                LARequestWrapper adhoc3Data = (LARequestWrapper) System.JSON.deserialize(rq.xadtx3__c, LARequestWrapper.class);
                List < LARequestWrapper.Members > memlst = new List < LARequestWrapper.Members > ();
                for (LARequestWrapper.Members m: adhoc3Data.serviceRequests[0].members) {
                    system.debug('--attachmentId--' + m.attachmentId);
                    system.debug('--reqDocId2--' + reqDocId2);
                    if (m.attachmentId != reqDocId2) memlst.add(m);
                    system.debug('--memlst--' + memlst);
                }
                adhoc3Data.serviceRequests[0].members = memlst;
                rq.xadtx3__c = JSON.serialize(adhoc3Data, true);
            }
            update rq;
            delete A;
            init();
            laodData();
        } catch (Exception e) {
            gU.AddErrorMsg(e);
        }
    }
    public void resetDoc() {
        try {
            system.debug('In resetDoc rq###' + rq);
            if (rq != null && rq.id != null) {
                hasRq = true;
                laodData();
            } else {
                hasRq = false;
                docWithNoRQ();
            }
            system.debug('In resetDoc rq>>>' + rq);
        } catch (Exception e) {
            gU.AddErrorMsg(e);
        }
    }
    public PageReference docWithNoRQ() {
        docList = new List < D2 > ();
        system.debug('sDocName' + sDocName);
        if (String.isNotBlank(sDocName)) {
            List < String > dLst = sDocName.split(';');
            integer val = 0;
            system.debug('dLst' + dLst);
            for (String docNm: dLst) {
                system.debug('docNm' + docNm);
                List < String > docNmLst = docNm.split(':');
                system.debug('docNmLst' + docNmLst);
                D2 obj = new D2();
                obj.DocName = docNmLst[0];
                obj.DocLabel = docNmLst[1];
                obj.parse = false;
                obj.isOptional = false;
                system.debug('val' + val);
                if (val == 0) obj.isSaveRQ = true;
                else obj.isSaveRQ = false;
                val = val + 1;
                docList.add(obj);
            }
        }
        system.debug('docList>>' + docList);
        return null;
    }
    public class D2 {
        public string DocName {
            get;
            set;
        }
        public string DocLabel {
            get;
            set;
        }
        public string DocType {
            get;
            set;
        }
        public String attId {
            get;
            set;
        }
        public String tmpltId {
            get;
            set;
        }
        public String attName {
            get;
            set;
        }
        public boolean parse {
            get;
            set;
        }
        public boolean isSaveRQ {
            get;
            set;
        }
        public boolean isOptional {
            get;
            set;
        }
    }
    public PageReference saveContinue() {
        try {
            System.debug('*** rq :' + rq);
            if (!nP && !nD && nCou && ispu) {
                List < g_reqitem__c > courBk = [SELECT Id, RQ__c, sta__c, sta__r.Courier_Stage__c, sta__r.cd__c, Name, xcasc__c, exp__c from g_reqitem__c where RQ__c =: rq.id order by createdDate desc limit 1];
                g_reqitem__c ri;
                Boolean isCour = false;
                for (g_reqitem__c i: courBk) {
                    if (i.sta__r.Courier_Stage__c == 'Collection' || i.sta__r.Courier_Stage__c == 'Delivery') {
                        ri = i;
                    }
                }
                XMLParserforEmpostWebservice cour = new XMLParserforEmpostWebservice();
                if (ri != null && (ri.sta__r.Courier_Stage__c == 'Collection' || ri.sta__r.Courier_Stage__c == 'Delivery') && !isCour) {
                    cour.courierBooking(ri, rq, false, '');
                    isCour = false;
                }
            }
            Map < String, String > response = pushParkingData();
            if (response.get('ResponseCode') != '0') {
                gU.AddErrorMsg(response.get('errMessage'));
                return null;
            }
            list < g_reqDoc__c > toU = new list < g_reqDoc__c > ();
            return getNextPage(true);
        } catch (Exception e) {
            gU.AddErrorMsg(e);
            return null;
        }
    }
    public PageReference nextPage() {
        system.debug('nextPage::::::');
        try {
            return getNextPage(true);
        } catch (exception ex) {
            gU.AddErrorMsg(ex);
            return null;
        }
    }
    public PageReference getNextPage(Boolean frcChk) {
        if (rq.srvc__r.uid__c == '220') {
            rq = fetchREQ(rq.id);
        }
        system.debug('***********1');
        system.debug('nd::::' + nd);
        system.debug('frcChk:::' + frcChk);
        system.debug('req.dsgu__c:::' + rq.dsgu__c);
        system.debug('req.xdrv__c:::' + rq.xdrv__c);
        if (nD && frcChk && rq.xdrv__c == false) {
            gU.AddErrorMsg('Please upload all mandatory documents.');
            return null;
        }
        if (nD && frcChk && rq.xdrv__c == false && rq.dsgu__c == true && rq.srvc__r.uid__c == '208') {
            gU.AddErrorMsg('Please upload all mandatory documents.');
            return null;
        }
        if (!(nD && frcChk) && rq.dsgu__c == false && rq.srvc__r.uid__c == '208') {
            gU.AddWarningMsg(' Please confirm that all the uploaded documents are correct before proceeding .');
            return null;
        }
        system.debug('tst1::');
        if (rq.srvc__r.uid__c == '208') {
            system.debug('uid before rq updaye::');
            try {
                update rq;
            } catch (exception e) {
                system.debug('ex::' + e.getStackTraceString());
            }
        }
        BusinessHours mBH = [SELECT Id FROM BusinessHours WHERE id =: gU.csStr('BH')];
        if (!nD && rq.xpmsle__c && (rq.srvc__r.uid__c == '208' || rq.srvc__r.uid__c == '221') && !rq.xcawp__c) {
            system.debug('$$$$$');
            shiftItemsSLA(rq.id, mBH.id);
            rq.STA__c = 'Under Review';
            update rq;
            gu.AddSuccessMsg('Your request has been submitted successfully,');
            System.debug('====in here====');
            return new PageReference('/apex/grqSInfo?id=' + rq.Id);
        }
        if (!nD && !rq.xcawp__c && (rq.xmloc__c || ((rq.srvc__r.uid__c == '208' || rq.srvc__r.uid__c == '221') && rq.xtpa__c == 0))) {
            
            shiftItemsSLA(rq.id, mBH.id);
            rq.STA__c = 'Under Review';
            update rq;
            gu.AddSuccessMsg('Your request has been submitted successfully,');
            System.debug('====in here====');
            return new PageReference('/apex/grqSInfo?id=' + rq.Id);
        }
        if (!nP && !nD && rq.srvc__r.uid__c == 'aml') {
            List < g_reqitem__c > riLst = [select id from g_reqitem__c where RQ__c =: rq.id];
            if (riLst != null && !riLst.isEmpty()) {
                grqWsDcca.serviceRequest reqjsRq = new grqWsDcca.serviceRequest();
                grqWsDcca.serviceReq req = new grqWsDcca.serviceReq();
                req.service = 'Submission of Annual Financial Statement';
                req.serNm = 'Submission of Annual Financial Statement';
                system.debug('justification::' + rq.xadtx4__c);
                req.cFRNotes = rq.xadtx4__c;
                if (rq.dsgu__c) req.attaFlag = true;
                else req.attaFlag = false;
                List < grqWsDcca.serviceReq > lst = new List < grqWsDcca.serviceReq > ();
                lst.add(req);
                reqjsRq.serviceRequest = lst;
                String rqbody = JSON.serialize(reqjsRq);
                ws_call__c ws = new ws_call__c();
                ws.rq_jsn__c = rqbody;
                ws.ws_typ__c = 'DCCA Letters';
                ws.mtd_nm__c = 'auditform';
                ws.uid__c = rq.id + '' + '' + ws.mtd_nm__c + system.now();
                ws.rq_itm__c = riLst[0].id;
                ws.intsts__c = 'Ready for Integration';
                insert ws;
            }
            gu.AddSuccessMsg('Your request has been submitted successfully,');
            System.debug('====in here====');
            return new PageReference('/apex/grqSInfo?id=' + rq.Id);
        }
        if (!nP && !nD && rq.srvc__r.uid__c == '001') {
            rq.STA__c = 'Under Review';
            update rq;
            gu.AddSuccessMsg('Your request has been submitted successfully,');
            System.debug('====in here====');
            return new PageReference('/apex/grqSInfo?id=' + rq.Id);
        }
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        system.debug('***********4' + retURL);
        if (retURL != null & !isgu) {
            return new PageReference(retURL);
        }
        if (nP && !isgu) {
            system.debug('***********45');
            String usrComments = ApexPages.currentPage().getParameters().get('c');
            String rc = ApexPages.currentPage().getParameters().get('rc');
            if (rc != null && rc == 'y') {
                return new PageReference('/apex/grqpy?id=' + rq.Id + '&rc=y&c=' + usrComments);
            } else if (rq.srvc__r.uid__c == '216') {
                return new PageReference('/apex/grqpyNIC?id=' + rq.Id + '&cn=' + rq.srvc__r.uid__c);
            } else {
                return new PageReference('/apex/grqpy?id=' + rq.Id);
            }
        }
        if (isgu) {
            system.debug('isgu::::' + isgu);
            if (!nP && !nD && nRV) {
                if (rq.srvc__r.uid__c == 'dnc') {
                    rq.STA__c = 'Under Review';
                    update rq;
                }
                System.debug('====in here====');
                return new PageReference('/apex/grqSInfo?id=' + rq.Id);
            } else {
                if (rq.srvc__r.uid__c == 'dnc') {
                    return new PageReference('/apex/grqpy?id=' + rq.Id + '&RefNum=' + rq.Name + '&empid=' + empid + '&enc=' + encid);
                } else {
                    return new PageReference('/apex/info?id=' + rq.Id + '&RefNum=' + rq.Name + '&empid=' + empid + '&enc=' + encid);
                }
            }
        }
        if (!nP && !nD && rq.STA__c == 'Open' && (ispu || rq.srvc__r.uid__c == '216')) {
            if (rq.srvc__r.uid__c == gu.csStr('ParkingActivation') || rq.srvc__r.uid__c == gu.csStr('ParkingModification')) {
                markRQUR();
            }
            rq.STA__c = 'Under Review';
            update rq;
        }
        system.debug('***********49');
        if ((ispu && (rq.srvc__r.uid__c == '221' || rq.srvc__r.uid__c == '223'))) {
            system.debug('*********** in5 ');
            try {
                rq.STA__c = 'Under Review';
                update rq;
                return new PageReference('/apex/spg?id=' + rq.Id + '&cn=' + rq.srvc__r.uid__c + '&sc=thk2');
            } catch (Exception ex) {
                system.debug('ex >> ' + ex);
            }
        }
        system.debug('***********99');
        try {
            gu.AddSuccessMsg('Your request has been submitted successfully to axs backoffice-1.');
            if (rq.srvc__r.uid__c == gu.csStr('ParkingActivation') || rq.srvc__r.uid__c == gu.csStr('ParkingModification')) {
                gu.AddSuccessMsg('Your request has been submitted successfully,');
                return new PageReference('/apex/spg?id=' + rq.Id + '&cn=' + rq.srvc__r.uid__c);
            }
            system.debug('***********46');
            if (rq.srvc__r.uid__c == '327') {
                updateItemSTA();
                rq.os__c = 'Contractor Submitted';
                update rq;
                String rqbody = rq.xadtx2__c;
                ws_call__c ws = new ws_call__c();
                ws.rq_jsn__c = rqbody;
                ws.ws_typ__c = 'Fitout';
                ws.mtd_nm__c = 'CreateRequest';
                ws.uid__c = rq.id + '-' + ws.mtd_nm__c + system.now();
                ws.rq_itm__c = rq.Items__r[0].id;
                ws.intsts__c = 'Ready for Integration';
                insert ws;
                return new PageReference('/apex/grqSInfo?id=' + rq.Id);
            }
            if (!nP && !nD && nRV) {
                if (rq.srvc__r.uid__c == '220' && String.isNotEmpty(rq.xdei__c)) {
                    grqWsOnboard.docsWSCallToDDA(rq.id, '');
                    ws_call__c ws = new ws_call__c();
                    ws.ws_typ__c = 'License Amendments';
                    ws.mtd_nm__c = 'statusUpdate';
                    ws.intsts__c = 'Ready for Integration';
                    ws.rq_itm__c = rq.Items__r[0].id;
                    insert ws;
                }
                System.debug('====in here====');
                return new PageReference('/apex/grqSInfo?id=' + rq.Id);
            }
        } catch (Exception ex) {}
        return (new ApexPages.StandardController(rq)).view();
    }
    public Boolean nCou {
        get {
            for (g_reqitem__c i: rq.Items__r) {
                if (i.Courier_Stage__c == 'Collection') {
                    return true;
                }
            }
            return false;
        }
    }
    public Boolean nP {
        get {
            for (g_reqitem__c i: rq.Items__r) {
                if (i.AD__c > 0) {
                    return true;
                }
            }
            return false;
        }
    }
    public Boolean nRV {
        get {
            for (g_reqitem__c i: rq.Items__r) {
                if (i.AP__c == 0 && i.AD__c == 0 && (i.STA__r.cd__c == 'n' || i.STA__r.cd__c == 'rv')) {
                    return true;
                }
            }
            return false;
        }
    }
    public Boolean nD {
        get {
            for (g_reqDoc__c d: [Select Id, Name, mxAts__c, mnAts__c, ats__c, Req__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, upOk__c, mbr__c, mbr__r.Name, (select id from Attachments) From g_reqDoc__c where RQ__c =: rq.Id and Req__c = true and IsDeleted = false]) {
                if (d.Attachments.size() == 0) return true;
            }
            return false;
        }
    }
    public Boolean nPD {
        get {
            for (g_reqDoc__c d: [Select Id, Name, mxAts__c, mnAts__c, ats__c, Req__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, upOk__c, mbr__c, mbr__r.Name From g_reqDoc__c where RQ__c =: rq.id and Req__c = true and(name like 'Passport Copy%'
                    or name like 'Trade License%') and IsDeleted = false]) {
                if (!d.upOk__c) {
                    return true;
                }
            }
            return false;
        }
    }

    public void markRQUR() {
        set < String > svrItms = new set < String > ();
        List < g_reqitem__c > itmIds = [SELECT Id, RQ__c, sta__c, itm__c from g_reqitem__c where RQ__c =: rq.id and sta__r.cd__c = 'cr'
            and isdeleted = false order by createdDate desc
        ];
        for (g_reqitem__c i: itmIds) {
            svrItms.add(i.itm__c);
        }
        Map < String, String > itmscds = new Map < String, String > ();
        for (g_srvcitm_Status__c sta: [Select Id, Name, itm__c From g_srvcitm_Status__c where cd__c = 'rv'
                and itm__c in: svrItms and isdeleted = false
            ]) {
            itmscds.put(sta.itm__c, sta.id);
        }
        for (g_reqitem__c i: itmIds) {
            if (itmscds != null && itmscds.containsKey(i.itm__c)) {
                i.sta__c = itmscds.get(i.itm__c);
            }
        }
        if (!itmIds.isEmpty()) {
            update itmIds;
        }
    }
    /*MS 1.1 starts*/
    public void updateItemSTA() {
        map < Id, g_reqitem__c > mapRqItId = new map < Id, g_reqitem__c > ();
        list < g_reqitem__c > Itms = new list < g_reqitem__c > ();
        boolean isReqCompleted = false;
        boolean isReqUndr = false;
        List < g_reqitem__c > itmIds = new List < g_reqitem__c > ();
        map < Id, Map < String, String >> mapnxtSts = new map < Id, Map < String, String >> ();
        list < String > lstItmCd = new list < String > ();
        List < String > lstStsCd = new List < String > ();
        map < String, list < g_reqitem__c >> mapRqItem = new map < String, list < g_reqitem__c >> ();
        for (g_reqitem__c objItem: [SELECT Id, RQ__c, xr__c, xdcdocs__c, xcdocs__c, xcnotes__c, RQ__r.srvc__c, RQ__r.srvc__r.UID__c, sta__c, sta__r.statype__c, sta__r.Next_Status__c, sta__r.Next_Status__r.rqSTA__c, sta__r.Next_Status__r.xcsits__c, itm__c, itm__r.cd__c from g_reqitem__c where RQ__c =: rq.id and sta__r.Next_Status__c != null and isdeleted = false order by createdDate desc]) {
            itmIds.add(objItem);
            if (objItem.sta__r.Next_Status__r.xcsits__c != null && objItem.sta__r.Next_Status__r.xcsits__c != '' && objItem.RQ__r.srvc__r.UID__c != '220') {
                List < String > lst = objItem.sta__r.Next_Status__r.xcsits__c.split(';');
                Map < String, String > mapcd;
                mapcd = mapnxtSts.containskey(objItem.RQ__r.srvc__c) ? mapnxtSts.get(objItem.RQ__r.srvc__c) : new Map < String, String > ();
                String itKey = '';
                for (String str: lst) {
                    lstItmCd.add(str.split(':')[0]);
                    lstStsCd.add(str.split(':')[1]);
                    mapcd.put(str.split(':')[0], str.split(':')[1]);
                    itKey = objItem.RQ__c + '##' + str.split(':')[0];
                }
                mapnxtSts.put(objItem.RQ__r.srvc__c, mapcd);
                list < g_reqitem__c > lstItms;
                lstItms = mapRqItem.containsKey(itKey) ? mapRqItem.get(itKey) : new list < g_reqitem__c > ();
                lstItms.add(objItem);
                mapRqItem.put(itKey, lstItms);
            }
        }
        system.debug('mapRqItem2324====' + mapRqItem);
        map < String, List < g_srvcitm_Status__c >> mapSrvItem = new map < String, List < g_srvcitm_Status__c >> ();
        if (!mapnxtSts.isEmpty()) {
            for (g_srvcitm_Status__c objSrvItemSts: [select id, uid__c, itm__r.srvc__c, itm__r.cd__c, cd__c from g_srvcitm_Status__c where itm__r.srvc__c =: mapnxtSts.keySet() and itm__r.cd__c IN: lstItmCd and cd__c IN: lstStsCd]) {
                String mapKey = objSrvItemSts.itm__r.srvc__c + '##' + objSrvItemSts.itm__r.cd__c + '##' + objSrvItemSts.cd__c;
                List < g_srvcitm_Status__c > lstSrvSts;
                lstSrvSts = mapSrvItem.containsKey(mapKey) ? mapSrvItem.get(mapKey) : new List < g_srvcitm_Status__c > ();
                lstSrvSts.add(objSrvItemSts);
                mapSrvItem.put(mapKey, lstSrvSts);
            }
        }
        for (g_reqitem__c i: itmIds) {
            if (i.sta__r.Next_Status__r.xcsits__c != null && i.sta__r.Next_Status__r.xcsits__c != '' && i.RQ__r.srvc__r.UID__c != '220') {
                List < String > lst = i.sta__r.Next_Status__r.xcsits__c.split(';');
                List < g_srvcitm_Status__c > lstSrv = new List < g_srvcitm_Status__c > ();
                Map < String, String > itmMp = new Map < String, String > ();
                Map < String, String > stsMp = new Map < String, String > ();
                for (String str: lst) itmMp.put(str.split(':')[0], str.split(':')[1]);
                system.debug('itmMp::' + itmMp);
                String mapSrKey = i.RQ__r.srvc__c + '##' + itmMp.keySet() + '##' + itmMp.values();
                if (mapSrvItem.containsKey(mapSrKey) && !mapSrvItem.get(mapSrKey).isEmpty()) lstSrv = mapSrvItem.get(mapSrKey);
                for (g_srvcitm_Status__c sts: lstSrv) stsMp.put(sts.uid__c, sts.id);
                system.debug('stsMp::' + stsMp);
                for (string strKey: itmMp.keySet()) {
                    String itmKey = i.RQ__c + '##' + strKey;
                    system.debug('itmKey====' + itmKey);
                    system.debug('mapRqItem====' + mapRqItem.get(itmKey));
                    for (g_reqitem__c ri: mapRqItem.get(itmKey)) {
                        String stsCode = itmMp.get(ri.itm__r.cd__c);
                        system.debug('stsCode::' + stsCode + ':' + ri.itm__r.cd__c + stsCode);
                        if (!mapRqItId.containsKey(ri.id)) mapRqItId.put(ri.id, new g_reqitem__c(id = ri.id, sta__c = stsMp.get(ri.itm__r.uid__c + stsCode)));
                    }
                }
            }
            if (String.isNotBlank(i.sta__r.statype__c) && i.sta__r.statype__c == 'Correction') {
                if (mapRqItId.containsKey(i.id)) {
                    g_reqitem__c rqitm = mapRqItId.get(i.id);
                    rqitm.xcdocs__c = '';
                    rqitm.xr__c = '';
                    rqitm.xcnotes__c = '';
                    rqitm.xdcdocs__c = '';
                    mapRqItId.put(i.id, rqitm);
                } else {
                    i.xcdocs__c = '';
                    i.xcnotes__c = '';
                    i.xr__c = '';
                    i.xdcdocs__c = '';
                    mapRqItId.put(i.id, i);
                }
            }
            if (i.sta__r.Next_Status__c != null && String.isNotBlank(i.sta__r.Next_Status__r.rqSTA__c)) {
                rq.STA__c = i.sta__r.Next_Status__r.rqSTA__c;
                isReqCompleted = true;
                system.debug('rq.STA__c ::::::' + rq.STA__c);
            }
            if (i.sta__r.Next_Status__c != null && String.isBlank(i.sta__r.Next_Status__r.rqSTA__c)) {
                system.debug('Next status update::::::::');
                isReqUndr = true;
                rq.STA__c = 'Under Review';
            }
            if (i.sta__r.Next_Status__c != null) {
                if (mapRqItId.containsKey(i.id)) {
                    g_reqitem__c ritm = mapRqItId.get(i.id);
                    ritm.sta__c = i.sta__r.Next_Status__c;
                    mapRqItId.put(i.id, ritm);
                } else {
                    i.sta__c = i.sta__r.Next_Status__c;
                    mapRqItId.put(i.id, i);
                }
            }
        }
        system.debug('Line#88---Itms::' + Itms);
        if (!mapRqItId.isEmpty()) {
            update mapRqItId.values();
            if (isReqCompleted || isReqUndr) update rq;
        }
    }
    public void markRQCMP() {
        set < String > svrItms = new set < String > ();
        List < g_reqitem__c > itmIds = [SELECT Id, RQ__c, sta__c, itm__c from g_reqitem__c where RQ__c =: rq.id and sta__r.cd__c = 'rrv'
            and isdeleted = false order by createdDate desc
        ];
        for (g_reqitem__c i: itmIds) svrItms.add(i.itm__c);
        Map < String, String > itmscds = new Map < String, String > ();
        for (g_srvcitm_Status__c sta: [Select Id, Name, itm__c From g_srvcitm_Status__c where cd__c = 'ok'
                and itm__c in: svrItms and isdeleted = false
            ]) itmscds.put(sta.itm__c, sta.id);
        for (g_reqitem__c i: itmIds) {
            if (itmscds != null && itmscds.containsKey(i.itm__c)) i.sta__c = itmscds.get(i.itm__c);
        }
        if (!itmIds.isEmpty()) {
            update itmIds;
            rq.STA__c = 'Completed';
            update rq;
        }
    }
    public void shiftItemsSLA(String rid, String mBHId) {
        List < g_reqitem__c > itemsToShift = [Select CreatedDate, exp__c, sta__r.rqSTA__c, sta__r.slaa__c, sta__r.slaXP__c, sta__r.slaN__c, RQ__c, sta__r.Tp__c, dtsc__c, itmCd__c, sta__r.Milestone__c, sta__r.Shift_At__c, sta__r.Shift_Items__c, sta__r.slaat__c, xited__c, dtic__c, xcsla__c, fpd__c, islax__c, islan__c, dtieclsx__c, dtieclsn__c, dtielx__c, dtieln__c, slaXP__c, slaN__c from g_reqitem__c Where RQ__c =: rid and itm__r.cd__c = 'dr'
            AND isDeleted = false
        ];
        if (itemsToShift != null && itemsToShift.size() > 0) grqSlaH.shiftItems(itemsToShift, true, mBHId, null, null);
    }
    public void fetchLeaseInfo() {
        string contractNo = Apexpages.currentPage().getParameters().get('contractNo');
        system.debug('contractNo::' + contractNo);
        system.debug('uid::' + rq.srvc__r.uid__c);
        system.debug('lic::' + rq.Acc__r.lc__c);
        String contractsStr = '';
        if (rq.srvc__r.uid__c == '216') {
            List < PMSContractDataWrapper.ContractInformation > contractlist = gwsPMSIntegration.getEjariContractInfoByContractNo(contractNo);
            if (contractlist != null && !contractlist.isEmpty()) contractsStr = JSON.serialize(contractlist);
        } else {
            List < PMSDataWrapper.ContractInformation > contractlist = gwsPMSIntegration.getEjariContractInfoByLicenseNo(rq.Acc__r.lc__c);
            if (contractlist != null && !contractlist.isEmpty()) contractsStr = JSON.serialize(contractlist);
        }
        if (String.isNotBlank(contractsStr)) {
            rq.activitiesFL__c = String.escapeSingleQuotes(contractsStr).replace('\\\'', '');
            update rq;
        }
    }
    public PageReference updateLeaseInfo() {
        PageReference ref = null;
        String attName = '';
        attName = docName;
        system.debug('attName1::' + attName);
        if (attName != null) {
            attName = attName.toLowerCase();
            if (attName.contains('.jpg')) attName = attName.replace('.jpg', ';');
            if (attName.contains('.pdf')) attName = attName.replace('.pdf', ';');
            system.debug('attName::' + attName);
        }
        if (reqDocId == null || reqDocId == '') reqDocId = getReqDocId(rq.id, attName);
        rq = fetchREQ(rq.id);
        rq.xopn__c = rgUnit;
        gwsPMSIntegration.updateLeaseInfo(rq);
        Attachment A = new Attachment(Body = EncodingUtil.base64Decode(imageBase64), Name = docName, ParentId = reqDocId);
        system.debug('A:' + A);
        system.debug('2 A>>>' + A);
        insert A;
        ref = new PageReference('/' + rq.id);
        return ref;
    }
    public Map < String, String > pushParkingData() {
        Map < String, String > response = new Map < String, String > ();
        response.put('ResponseCode', '0');
        response.put('errMessage', '');
        if (rq.STA__c == 'Open' && !nD) {
            ParkingM pm = new ParkingM();
            response = pm.pushReqItems(rq.Id, new list < g_reqitem__c > ());
        }
        System.debug('<pushParkingData> : ' + response);
        return response;
    }
    public PageReference updatePrirityItm() {
        PageReference ref = null;
        string prType = Apexpages.currentPage().getParameters().get('prType');
        String adhoc = '';
        priorityType = prType;
        if (string.isNotBlank(rq.xadh__c)) adhoc = rq.xadh__c;
        if (string.isNotBlank(adhoc)) adhoc = adhoc.replace('ef;', '').replace('pf;', '');
        if (string.isNotBlank(adhoc) && prType == 'nf') adhoc = adhoc.replace('ef;', '').replace('pf;', '');
        if (string.isNotBlank(adhoc) && prType == 'pf') adhoc = adhoc.replace('ef;', '');
        if (string.isNotBlank(adhoc) && prType == 'ef') adhoc = adhoc.replace('pf;', '');
        system.debug('prType::' + prType);
        if (String.isNotBlank(prType) && (prType == 'ef' || prType == 'pf')) rq.xadh__c = adhoc + prType + ';';
        else rq.xadh__c = adhoc;
        update rq;
        String pageName = ApexPages.currentPage().getUrl().split('apex/')[1].split('\\?')[0];
        ref = new PageReference('/' + pageName + '?id=' + rq.id);
        ref.setRedirect(true);
        return ref;
    }
    public PageReference updateIncItm() {
        PageReference ref = null;
        incType = Apexpages.currentPage().getParameters().get('incType') == 'true' ? true : false;
        String adhoc = rq.xadh__c;
        if (string.isNotBlank(adhoc)) adhoc = adhoc.replace('ic;', '').replace('ofl;', '');
        system.debug('incType::' + incType);
        String pageName = ApexPages.currentPage().getUrl().split('apex/')[1].split('\\?')[0];
        system.debug('Apexpages.pageNamepageName2()::' + pageName);
        if (incType) rq.xadh__c = adhoc + 'ic;';
        else rq.xadh__c = adhoc;
        update rq;
        ref = new PageReference('/' + pageName + '?id=' + rq.id);
        return ref;
    }
    public PageReference updateOfflItm() {
        PageReference ref = null;
        offType = Apexpages.currentPage().getParameters().get('offType') == 'true' ? true : false;
        String adhoc = rq.xadh__c;
        if (string.isNotBlank(adhoc)) adhoc = adhoc.replace('ofl;', '');
        system.debug('offType::' + offType);
        if (offType) rq.xadh__c = adhoc + 'ofl;';
        else rq.xadh__c = adhoc;
        update rq;
        String pageName = ApexPages.currentPage().getUrl().split('apex/')[1].split('\\?')[0];
        ref = new PageReference('/' + pageName + '?id=' + rq.id);
        return ref;
    }
    public PageReference updateDocValidity() {
        PageReference ref = null;
        try {
            update rq;
            if (rq.srvc__r.uid__c == '216') {
                if (!nD && rq.xdrv__c) ref = new PageReference('/grqpy?id=' + rq.id);
                else ref = new PageReference('/lerqob?id=' + rq.id);
            } else ref = new PageReference('/lrqup?id=' + rq.id);
            ref.setRedirect(true);
        } catch (Exception ex) {
            system.debug('ex::' + ex.getStackTraceString());
        }
        return ref;
    }
    public PageReference paymentPage() {
        return new pagereference('/apex/grqpymi??empid=TG1647&enc=1245652097735B7F37FE7D402B2C9B3CCC67292A&pid=00328000018PBLv&sid=a0L2000000YQVLDEA5');
    }
    public Pagereference creditcatdPay() {
        gU.DEG_PrepareCall(200.00, 'AET20195fd');
        system.debug('After prepare call#####################################');
        return null;
    }
    public void sendOtp() {
        otpSentMobileOREmail = 'Mobile Number';
        otpReqId = SMSService.sendOTP(mobNum, '');
    }
    public void sendEmailOTP() {
        otpSentMobileOREmail = 'Email Address';
        gU.sendEmailOTP('LA', conEmail, rq);
    }
    public String validateOtp() {
        try {
            otpResult = '';
            otpResult = gU.validateOtp('LA', rq, null, otpVal, isMobileOTP, otpReqId);
        } catch (Exception e) {
            gU.AddErrorMsg('OTP validation failed, regenerate the OTP and verify.');
            return null;
        }
        return null;
    }

}