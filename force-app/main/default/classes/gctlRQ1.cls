public class gctlRQ1 {
    public List < g_Srvc__c > srvLst {
        set;
        get;
    }
    public List < String > srvList {
        set;
        get;
    }
    public List < String > srvTrnsList {
        set;
        get;
    }
    public Account A {
        set;
        get;
    }
    public User U {
        set;
        get;
    }
    public List < String > defdocLblList {
        set;
        get;
    }
    public List < String > docLblList {
        set;
        get;
    }
    public List < String > infoDocLst {
        set;
        get;
    }
    public List < D > docList {
        set;
        get;
    }
    public List < D > docTrnsList {
        set;
        get;
    }
    public transient String imageBase64 {
        get;
        set;
    }
    public String docName {
        get;
        set;
    }
    public String rqNo {
        get;
        set;
    }
    public g_Req__c rq {
        get;
        set;
    }
    public String err {
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
    public Boolean isNew {
        get;
        set;
    }
    public String pid {
        set;
        get;
    }
    public String insurancereq {
        set;
        get;
    }
    public String ped {
        set;
        get;
    }
    public String eed {
        set;
        get;
    }
    public String dob {
        set;
        get;
    }
    public String ved {
        set;
        get;
    }
    //public g_Req__c req{get;set;}
    public g_Srvc__c srv {
        get;
        set;
    }
    public Account Acc {
        get;
        set;
    }
    public gu.pgMode md {
        get;
        set;
    }
    public g_srvc_definition__c sd {
        get;
        set;
    }
    public List < string > priorityList {
        set;
        get;
    }
    public Map < String, String > slaMp {
        set;
        get;
    }
    public String oldRqId {
        set;
        get;
    }
    public String depListStr {
        set;
        get;
    }
    public Boolean isInsAct {
        set;
        get;
    }
    public String rqId {
        set;
        get;
    }
    public String isdoc {
        set;
        get;
    }
    public string isVisaTransfer {
        set;
        get;
    }
    public string xxx {
        set;
        get;
    }
    /*for countries not having fitst name*/
    public String firstNameCountries {
        get;
        set;
    }
    public String prk {
        set;
        get;
    }
    public String preConId {
        set;
        get;
    }
    public Contact preCon {
        set;
        get;
    }
    public Boolean isactiveDep {
        set;
        get;
    }
    //public Boolean isConGV {set;get;}
    //public List<string> srvCode {set;get;}
    public gctlRQ1() {
        isactiveDep = false;
        firstNameCountries = System.Label.countriesFirstName;
    }

    public PageReference redirectReq() {
        /*for countries not having fitst name*/
        firstNameCountries = System.Label.countriesFirstName;
        List < g_req__c > req1 = [Select id, name, AT__c, ATV__c, (SELECT id, name, itm__r.cd__c, AD__c, exp__c, ATV__c FROM Items__r) from g_req__c where Acc__c =: U.contact.account.id And srvc__r.uid__c = '322'
            and sta__c != 'Cancelled'
            order by createddate desc
        ];
        if (req1 != null && req1.size() > 0) {
            return new PageReference('/grqfl?rid=' + req1[0].id + '&id=' + req1[0].id);
        }
        return null;
    }


    public PageReference redirectService() {
        Pagereference ref = null;
        Boolean hasAccess2;
        String srvDefId;
        /*for countries not having fitst name*/
        firstNameCountries = System.Label.countriesFirstName;
        srvLst = new List < g_Srvc__c > ();
        rq = new g_Req__c();
        isInsAct = false;
        docLblList = new List < String > ();
        docList = new List < D > ();
        docTrnsList = new List < D > ();
        priorityList = new List < String > ();
        depListStr = '';
        slaMp = new Map < String, String > ();
        srvList = new List < String > ();
        srvTrnsList = new List < String > ();
        rqNo = '';
        pid = '';
        ped = '';
        dob = '';
        isVisaTransfer = '';
        ved = '';
        eed = '';
        String sdid = ApexPages.CurrentPage().getParameters().get('sid');
        String preConId = ApexPages.CurrentPage().getParameters().get('conId');
        // preConId = ApexPages.CurrentPage().getParameters().get('cid');/*FLD - added prm email*/
        U = [select id, FirstName, LastName, contact.account.mtc__c, contact.account.Name, contact.account.Email__c, contact.account.Phone, MobilePhone, accountid,
            contact.account.id, contact.account.agv__c, contact.account.Legal_Framework__c, contact.account.adb__c, contact.account.PRM_Email__c, contact.account.xcuzn__c, contact.account.xcublg__c, contact.account.bgb__c, contact.account.bgnr__c, contact.account.bg__c, contact.account.loc__c, contact.account.Type, contact.account.Prk__c, contact.account.Park__c, contact.account.lcsnc__c, contact.account.lcsncnt__c, contact.account.lcedt__c, contact.account.psasnc__c, contact.account.psasncnt__c, contact.account.ecsnc__c, contact.account.ecsncnt__c, contact.account.cosnc__c, contact.account.cosncnt__c, contact.account.bgsnc__c, contact.account.bgsncnt__c, contact.account.snc__c, contact.account.info__c, contact.account.vestd__c, contact.account.vbtemp__c, contact.account.vbvv__c,
            contact.account.lc__c, contact.account.vcspe__c, contact.account.vbtst__c, contact.account.ccrm_sfid__c, contact.account.ORACLE_PARTY_ID__c, contact.account.lcsta__c, contact.account.lctp__c, contact.account.session__c, contact.account.vctemp__c, contact.account.vvsfp__c, Contact.Account.mvsfp__c, contact.account.lcrndt__c, contact.account.os__c, contact.rol__c from User where id =: UserInfo.getUserId() limit 1
        ];
        sd = [select id, Name, sd__c, Category__c, Sub_Category__c, pyChk__c, srvlbl__c, docslbl__c, srvdocs__c, srvtdocs__c, vtyp__c, srat__c, srv__c, srvt__c, slbl__c, ptype__c, skpsd__c, cv__c, insreq__c, (select id, xoi__c, kstp__c, Short_Label__c, Service_Type__c, Sub_Category__c, uid__c, name, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c, consta__c, sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c, stg__r.reqq__c from srvc__r where AccTp__c includes(: U.contact.account.Type) and actv__c = true order by sord__c) from g_srvc_definition__c where id =: sdid]; //where AccTp__c in ('Customer - External; Customer - LAS','Customer - External')
        hasAccess2 = gU.canAccess2(sdid, false, null);
        System.debug(':::hasAccess2==>' + hasAccess2);
        if (preConId != null) {
            preCon = [select id, nc__c, jd__c, flnm__c, name, p__c, jb__r.name, Photo_ID__c, STA__c, rped__c, Salutation, firstName, middleName, LastName, Email, MobilePhone, eidid__c, rol__c, xped__c from contact where id =: preConId][0];
        }
        if (!hasAccess2)
            pgHide = true;
        else {
            pgHide = false;
            System.debug(':::sd==>' + sd);
            if (!sd.skpsd__c) {
                Acc = U.contact.account;
                //srv = [select id,xoi__c,uid__c,name,lbl__c,dsc__c,Prk__c,AccTp__c,conrol__c,consta__c,sprrole__c,sprsta__c,ckgsnc__c,snc__c,stg__r.pg__c,stg__r.apx__c,stg__r.reqq__c from g_Srvc__c where id=: rq.srvc__c limit 1];
                system.debug('@@@@@@@@@@ACC:' + Acc);
                //priority assignment        
                if (String.isNotBlank(sd.ptype__c)) {
                    list < String > prLst = (sd.ptype__c).split(';');
                    for (String str: prLst) {
                        list < String > slaLst = str.split(':');
                        slaMp.put(slaLst[0], slaLst[1]);
                    }
                    priorityList.addAll(slaMp.keySet());
                }
                if (sd.srvc__r != null && !sd.srvc__r.isEmpty()) {
                    srvLst = sd.srvc__r;
                    srv = srvLst[0];
                    rq.ConRol__c = srv.conrol__c;
                    rq.ConSTA__c = srv.consta__c;
                    system.debug('srvc::' + srv);
                }
                if (String.isNotBlank(sd.docslbl__c)) {
                    docLblList = sd.docslbl__c.split(';');
                    defdocLblList = sd.docslbl__c.split('#');
                }
                if (defdocLblList != null && defdocLblList.size() > 0) {
                    docLblList = defdocLblList[0].split(';');
                }
                if (defdocLblList != null && defdocLblList.size() > 1) {
                    infoDocLst = defdocLblList[1].split(';');
                }


                if (String.isNotBlank(sd.srvtdocs__c)) {
                    List < String > dLst = sd.srvtdocs__c.split(';');
                    List < String > enableOCRLst = gu.csStr('enableOCR').split(';');
                    List < String > optDocsLst = gu.csStr('OptionsDocs').split(';');
                    integer val = 0;
                    for (String docNm: dLst) {
                        List < String > docNmLst = docNm.split(':');
                        D obj = new D();
                        obj.DocName = docNmLst[0];
                        obj.DocLabel = docNmLst[1];
                        if (enableOCRLst.contains(docNmLst[0]))
                            obj.parse = true;
                        else
                            obj.parse = false;
                        if (optDocsLst.contains(docNmLst[0]))
                            obj.isOptional = true;
                        else
                            obj.isOptional = false;
                        if (val == 0) obj.isSaveRQ = true;
                        else obj.isSaveRQ = false;
                        val = val + 1;
                        docTrnsList.add(obj);
                    }
                }
                if (String.isNotBlank(sd.srvdocs__c)) {
                    List < String > dLst = sd.srvdocs__c.split(';');
                    List < String > enableOCRLst = gu.csStr('enableOCR').split(';');
                    List < String > optDocsLst = gu.csStr('OptionsDocs').split(';');

                    integer val = 0;
                    for (String docNm: dLst) {
                        List < String > docNmLst = docNm.split(':');
                        D obj = new D();
                        obj.DocName = docNmLst[0];
                        obj.DocLabel = docNmLst[1];
                        if (docNmLst != null && docNmLst.size() == 3)
                            obj.tmpltId = docNmLst[2];
                        if (enableOCRLst.contains(docNmLst[0]))
                            obj.parse = true;
                        else
                            obj.parse = false;
                        if (optDocsLst.contains(docNmLst[0]))
                            obj.isOptional = true;
                        else
                            obj.isOptional = false;
                        if (val == 0) obj.isSaveRQ = true;
                        else obj.isSaveRQ = false;
                        val = val + 1;
                        docList.add(obj);
                    }
                }

                if (String.isNotBlank(sd.srv__c))
                    srvList = sd.srv__c.split(';');
                if (String.isNotBlank(sd.srvt__c))
                    srvTrnsList = sd.srvt__c.split(';');
                rq.acc__c = U.contact.account.id;
                rq.xaloc__c = U.contact.account.loc__c;
                if (String.isNotBlank(U.MobilePhone)) {
                    String mph = U.MobilePhone;
                    rq.rmob__c = mph.replaceAll('\\D', '').replaceFirst('971', '').replaceFirst('0', '');
                }

                rq.xbrnd__c = U.contact.account.xcuzn__c;
                rq.xbn__c = U.contact.account.xcublg__c;
                rq.xceml__c = U.contact.account.Email__c;
                rq.xoln__c = U.contact.account.Phone;
                rq.mtc__c = U.contact.account.mtc__c;

                if (sd.pyChk__c) {
                    rq.srvc__c = srv.id;
                    rq.STA__c = 'Open';
                    upsert rq;
                    ref = new Pagereference('/grqpy?id=' + rq.id);
                    ref.setRedirect(true);
                } else {
                    rqId = Apexpages.currentPage().getParameters().get('id');
                    isdoc = Apexpages.currentPage().getParameters().get('d');
                    String istrns = Apexpages.currentPage().getParameters().get('vt');
                    System.debug(':::sd==>' + sd);
                    System.debug(':::rqId==>' + rqId);
                    if (String.isNotBlank(istrns) && (istrns == 'y' || istrns == 'int' || istrns == 'b' || istrns == 'nb'))
                        isVisaTransfer = istrns;
                    if (String.isNotBlank(rqId))
                        loadData(rqId);
                    else {
                        if (sd.cv__c == 'Freelancer') {

                            List < g_req__c > req1 = [Select id, name, AT__c, ATV__c, srvc__r.AddOnSrv__c, (SELECT id, name, AD__c, ATV__c, exp__c, itm__r.cd__c FROM Items__r) from g_req__c where Acc__c =: U.contact.account.id And srvc__r.uid__c = '322'
                                and sta__c != 'Cancelled'
                                order by createddate desc
                            ]; //,CAS__c,xcacp__c
                            if (req1 != null && req1.size() > 0) {
                                return new PageReference('/grqfl?id=' + req1[0].id); // new PageReference('/'+req1[0].id);
                            }
                            rq.xaccbrand__c = Acc.Prk__c;
                            rq.srvc__c = Label.Freelancer_Srvid;
                        }
                        System.debug(':::sd cv==>' + sd.cv__c);
                        if ((String.isBlank(sd.cv__c) || (String.isNotBlank(sd.cv__c) && sd.cv__c != 'Freelancer')) && hasSanctions) {
                            pgHide = true;
                            system.debug('hasSanctionshasSanctionshasSanctions--' + pgHide);
                        }
                    }
                    if (Acc.Prk__c == 'Dubai Internet City') {
                        prk = 'dic';
                    } else if (Acc.Prk__c == 'Dubai Media City') {
                        prk = 'dmc';
                    } else if (Acc.Prk__c == 'Dubai Design District') {
                        prk = 'ddd';
                    } else if (Acc.Prk__c == 'Dubai Knowledge Park') {
                        prk = 'dkp';
                    } else {
                        prk = 'dmc';
                    }

                }
                //if(!accesssOk){pgHide=true;}
            } else if (sd.srvc__r != null && !sd.srvc__r.isEmpty()) {
                srvLst = sd.srvc__r;
                ref = new Pagereference('/' + srvLst[0].stg__r.pg__c + '?sid=' + srvLst[0].id);
                ref.setRedirect(true);
            }
            /*Sorting  service List*/
            // srvLst.sort();

            List < g_Srvc__c > finalList = new List < g_Srvc__c > ();
            for (Integer i = srvLst.size() - 1; i >= 0; i--) {
                finalList.add(srvLst.get(i));
                //srvCode.add(srvLst.get(i).uid__c);
            }
            srvLst = new List < g_Srvc__c > ();
            srvLst = finalList.clone();
        }
        if (rq.srvc__r.uid__c == '923') {
            fetchFreelansDepInfo();
        }
        return ref;
    }

    public void loadData(String rqid) {
        rq = [select id, xppsfv__c, vfsFlag__c, xcflst__c, cldt__c, scFlg__c, Full_Name__c, xui__c, xeng__c, xcst__c, xengp__c, xengt__c, STA__c, xvnum__c, acc__r.name, PRM_Name__c, PRM_Email__c, PRM_MobileNo__c, PRM_LandlineNo__c, xadtx2__c, ATV__c, xeidav__c, xaccbrand__c, inUAE__c, xvn__c, xcddocs__c, is_sponsered_fl__c, activitiesFL__c, segmentFL__c, xcsrs__c, xoca__c, xosa__c, xdedc__c, xdedln__c, xadtx1__c, srvc__c, srvc__r.uid__c, srvc__r.kstp__c, xard__c, srvc__r.category__c, xcsfn__c, xnry__c, xcstp__c, ConRol__c, consta__c, Con__c, Con__r.Photo_ID__c, con__r.xped__c, xcspb__c, Spr__c, xcsnc__c, xcsp__c, xrp__c, xrpid__c, xrped__c, xphid__c, acc__c, xadh__c, name, xaed__c, InsChk__c, e__c, xaloc__c, rmob__c, xbrnd__c, xbn__c, xoln__c, mtc__c, xcnc__c, xcp__c, xcfn__c, xcln__c, xcmn__c, xcmon__c, xcfan__c, Gender__c, xcbd__c, xcbc__c, xceml__c, xcfnar__c, xcmnar__c, xclnar__c, xclng__c, xcmonar__c, xcjb__c, xceidid__c, xceidedt__c, xcql__c, xcfs__c, xcot__c, xcof__c, xcemrt__c, xccty__c, xcstrt__c, xcarea__c, xcpobx__c, xcpobxarea__c, xcpic__c, xcpip__c, xcpid__c, xcped__c, xcrlg__c, xcms__c, xcbp__c, xcpobar__c, xcnp__c, xcslt__c, xcmbs__c, xcma__c, xcmta__c, xcmoa__c, xcha__c, xchph__c, xcmob__c, AT__c,
            con__r.name, srvc__r.AddOnSrv__c, xsgv__c, noFnm__c, xddatc__c, Visa_Type__c, Con__r.rol__c, Con__r.xsgv__c, (SELECT id, name, AD__c, itm__r.cd__C, exp__c, ATV__c FROM Items__r) from g_req__c where id =: rqid and Acc__c =: U.contact.account.id
        ];
        rqNo = rq.name;

        if (rq.xaed__c != null)
            ved = dtStr(rq.xaed__c);
        if (rq.xceidedt__c != null)
            eed = dtStr(rq.xceidedt__c);
        if (rq.con__r.xped__c != null) {
            Date dt = (rq.con__r.xped__c).addDays(-20);
            if (dt > date.today())
                isInsAct = true;
        }
        Map < string, Attachment > attMp = new Map < string, Attachment > ();
        List < g_reqDoc__c > rdocList = [select id from g_reqDoc__c where RQ__c =: rqid and Req__c = true and reqAts__c = true and upOk__c = true];
        for (Attachment att: [select id, name, body, parentid from Attachment where parentid =: rdocList]) {
            attMp.put(att.name.split('\\.')[0], att);
        }
        if (String.isBlank(isVisaTransfer)) {
            for (D doc: docList) {
                if (attMp != null && attMp.containskey(doc.DocName)) {
                    Attachment att = attMp.get(doc.DocName);
                    doc.attId = att.Id;
                    doc.attName = att.name;
                }
            }
        } else {
            for (D doc: docTrnsList) {
                if (attMp != null && attMp.containskey(doc.DocName)) {
                    Attachment att = attMp.get(doc.DocName);
                    doc.attId = att.Id;
                    doc.attName = att.name;
                }
            }
        }
        if (String.isNotBlank(rq.spr__c))
            fetchDependentInfo();
    }
    public void fetchFreelansDepInfo() {
        try {
            List < contact > depList = [select id, name, rol__c from contact where AccountId =: U.contact.account.id AND STA__c IN('Active') AND rol__c IN('Spouse', 'Child')];
            if (depList != null && !depList.isEmpty()) {
                isactiveDep = true;
                depListStr = JSON.serialize(depList);
            }

        } catch (exception ex) {
            gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    }

    public PageReference saveRequestInfo() {
        system.debug('saveRequestInfo::::Today');
        Pagereference ref = null;
        try {

            rq.STA__c = 'Draft';
            system.debug('Visa No:' + rq.e__c);
            system.debug('srvc::' + rq.srvc__c);
            //String visaNo = Apexpages.currentPage().getParameters().get('visaNo');
            List < g_Req__c > reqList = [select id, xsgv__c, noFnm__c, xddatc__c, Visa_Type__c, xadtx1__c, xvn__c, xcnc__c, xcp__c, xcfn__c, xcln__c, xcmn__c, xcfanar__c, xcmon__c, xcfan__c, Con__r.xsgv__c, Gender__c, xcbd__c, xcbc__c, xceml__c, xcfnar__c, xcmnar__c, xclnar__c, xclng__c, xcmonar__c, xcjb__c, xceidid__c, xceidedt__c, xcql__c, xcfs__c, xcot__c, xcof__c, xcemrt__c, xccty__c, xcstrt__c, xcarea__c, xcpobx__c, xcpobxarea__c, xcpic__c, xcpip__c, xcpid__c, xcped__c, xcrlg__c, xcms__c, xcbp__c, xcpobar__c, xcnp__c, xcslt__c, xcmbs__c, xcma__c, xcmta__c, xcmoa__c, xcha__c, xchph__c, xcmob__c, xrp__c, xrpid__c, xrped__c
                from g_Req__c where Acc__c =: Acc.id and srvc__r.uid__c in ('058', '074') and e__c =: rq.e__c and lastmodifieddate = LAST_N_DAYS: 120 order by lastmodifieddate desc limit 1
            ];
            // List<Contact> conLst = [select id,nc__c,p__c,RP_Expiry_Due__c,Spon__c,snc__c,sp__c,rp__c,rpid__c,rped__c,mbs__c,ma__c,mta__c,moa__c,ha__c,HomePhone,firstname,middlename,lastname,MobilePhone,mon__c,fan__c,Gender__c,Birthdate,bc__c,Email,fnar__c,mnar__c,lnar__c,lng__c,mona__c,jb__c,eidid__c,eidedt__c,ql__c,ot__c,fs__c,of__c,emrt__c,cty__c,strt__c,area__c,pobx__c,pobxarea__c,pic__c,pip__c,pid__c,ped__c,rlg__c,ms__c,bp__c,bpa__c,np__c,Salutation from Contact where id=:rq.Con__c ];
            system.debug('reqList -- ' + reqList);
            if (reqList != null && !reqList.isEmpty()) {
                rq.xcnc__c = reqList[0].xcnc__c;
                rq.xcp__c = reqList[0].xcp__c;
                rq.xcfn__c = reqList[0].xcfn__c;
                rq.xcln__c = reqList[0].xcln__c;
                rq.xcmn__c = reqList[0].xcmn__c;
                rq.xcmon__c = reqList[0].xcmon__c;
                rq.xcfan__c = reqList[0].xcfan__c;
                rq.xcfanar__c = reqList[0].xcfanar__c;
                rq.Gender__c = reqList[0].Gender__c;
                rq.xcbd__c = reqList[0].xcbd__c;
                rq.xcbc__c = reqList[0].xcbc__c;
                rq.xceml__c = reqList[0].xceml__c;
                rq.xcfnar__c = reqList[0].xcfnar__c;
                rq.xcmnar__c = reqList[0].xcmnar__c;
                rq.xclnar__c = reqList[0].xclnar__c;
                rq.xclng__c = reqList[0].xclng__c;
                rq.xcmonar__c = reqList[0].xcmonar__c;
                rq.xcjb__c = reqList[0].xcjb__c;
                rq.xceidid__c = reqList[0].xceidid__c;
                rq.xceidedt__c = reqList[0].xceidedt__c;
                rq.xcql__c = reqList[0].xcql__c;
                rq.xcfs__c = reqList[0].xcfs__c;
                rq.xcot__c = reqList[0].xcot__c;
                rq.xcof__c = reqList[0].xcof__c;
                rq.xcemrt__c = reqList[0].xcemrt__c;
                rq.xccty__c = reqList[0].xccty__c;
                rq.xcstrt__c = reqList[0].xcstrt__c;
                rq.xcarea__c = reqList[0].xcarea__c;
                rq.xcpobx__c = reqList[0].xcpobx__c;
                rq.xcpobxarea__c = reqList[0].xcpobxarea__c;
                rq.xcpic__c = reqList[0].xcpic__c;
                rq.xcpip__c = reqList[0].xcpip__c;
                rq.xcpid__c = reqList[0].xcpid__c;
                rq.xcped__c = reqList[0].xcped__c;
                rq.xcrlg__c = reqList[0].xcrlg__c;
                rq.xcms__c = reqList[0].xcms__c;
                rq.xcbp__c = reqList[0].xcbp__c;
                rq.xcpobar__c = reqList[0].xcpobar__c;
                rq.xcnp__c = reqList[0].xcnp__c;
                rq.xcslt__c = reqList[0].xcslt__c;
                rq.xcha__c = reqList[0].xcha__c;
                rq.xchph__c = reqList[0].xchph__c;
                rq.os__c = 'Under_Review';
                if (String.isNotBlank(reqList[0].xcmob__c)) {
                    String mobileNo = reqList[0].xcmob__c;
                    rq.xcmob__c = mobileNo.replaceAll('\\D', '').replaceFirst('971', '').replaceFirst('0', '');
                }
                rq.xrp__c = reqList[0].xrp__c;
                rq.xrpid__c = reqList[0].xrpid__c;
                rq.xrped__c = reqList[0].xrped__c;

                if (String.isNotBlank(ved)) {
                    rq.xaed__c = strDate(ved);
                }
                upsert rq;
                oldRqId = reqList[0].id;
                copyDocuments();
                String isTrnsfer = 'n';
                if ((String.isNotBlank(isVisaTransfer) && isVisaTransfer == 'y'))
                    isTrnsfer = 'y';

                ref = new PageReference('/' + rq.id);
                ref.setRedirect(true);
                return ref;
            }


            return null;
        } catch (DMLException exDML) {
            system.debug('DMLExceptionEEEEEE: ' + exDML);
            for (Integer i = 0; i < exDML.getNumDml(); i++) {
                if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    System.Debug('** Exception:' + exDML.getDmlMessage(i));
                    gu.AddErrorMsg(Label.msgException);
                }
            }
            return null;
        } catch (exception ex) {
            gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            return null;
        }
    }

    public PageReference saveAdhoc() {
        update rq;
        loadData(rqId);
        return null;
    }
    public PageReference saveApplicantInfo() {
        system.debug('invoke save applicant::::::');
        Pagereference ref = null;
        try {


            rq.STA__c = 'Draft';
            system.debug('request -- ' + rq);
            system.debug('###################applicant:######################');
            system.debug('applicant:' + rq.Con__c);
            system.debug('srvc::' + rq.srvc__c);


            //List<g_Req__c> reqList = [select id,Con__c,Con__r.nc__c,Con__r.p__c,Con__r.firstname,Con__r.middlename,Con__r.lastname,Con__r.mon__c,Con__r.fan__c,Con__r.Gender__c,Con__r.Birthdate,Con__r.bc__c,Con__r.Email,Con__r.fnar__c,Con__r.mnar__c,Con__r.lnar__c,Con__r.lng__c,Con__r.mona__c,Con__r.jb__c,Con__r.eidid__c,Con__r.eidedt__c,Con__r.ql__c,Con__r.ot__c,Con__r.fs__c,Con__r.of__c,Con__r.emrt__c,Con__r.cty__c,Con__r.strt__c,Con__r.area__c,Con__r.pobx__c,Con__r.pobxarea__c,Con__r.pic__c,Con__r.pip__c,Con__r.pid__c,Con__r.ped__c,Con__r.rlg__c,Con__r.ms__c,Con__r.bp__c,Con__r.bpa__c,Con__r.np__c,Con__r.Salutation from g_Req__c where srvc__r.uid__c='001' and Con__c=:rq.Con__c order by createddate desc limit 1];
            List < Contact > conLst = [select id, id__c, nc__c, rol__c, p__c, Proc__c, RP_Expiry_Due__c, mn__c, Spon__c, snc__c, sp__c, rp__c, rpid__c, rped__c, mbs__c, ma__c, mta__c, moa__c, ha__c, rpui__c, HomePhone, firstname, middlename, lastname, MobilePhone, mon__c, fan__c, Gender__c, Birthdate, bc__c, Email, fnar__c, mnar__c, lnar__c, lng__c, mona__c, jb__c, eidid__c, eidedt__c, ql__c, ot__c, fs__c, of__c, emrt__c, cty__c, strt__c, area__c, pobx__c, pobxarea__c, pic__c, pip__c, pid__c, ped__c, rlg__c, ms__c, bp__c, bpa__c, np__c, Salutation, xsgv__c from Contact where id =: rq.Con__c];
            system.debug('contact mona__c::::::' + conLst[0].mona__c);
            // isConGV = conLst[0].xsgv__c ;
            system.debug('Golden visa flag:::' + conLst[0].xsgv__c);
            if (conLst != null && !conLst.isEmpty()) {
                rq.xcnc__c = conLst[0].nc__c;
                rq.xcp__c = conLst[0].p__c;
                //sd.Category__c=='Employees' &&
                if (!((sd.Sub_Category__c == 'Renewals' && srv.uid__c != 'gv') && (sd.cv__c == 'VisaCorrection' || (sd.cv__c == 'VisaRenewal' && srv.uid__c != '071')))) {
                    rq.xcfn__c = conLst[0].firstname;
                    rq.xcln__c = conLst[0].lastname;
                    rq.xcmn__c = conLst[0].middlename;
                    rq.xcmn__c = conLst[0].mn__c;
                    rq.xcfnar__c = conLst[0].fnar__c;
                    rq.xcmnar__c = conLst[0].mnar__c;
                    rq.xclnar__c = conLst[0].lnar__c;
                    rq.xcfan__c = conLst[0].fan__c;

                }
                rq.os__c = 'Under_Review';
                rq.xcsrs__c = conLst[0].rol__c;
                rq.xcmon__c = conLst[0].mon__c;
                rq.Gender__c = conLst[0].Gender__c;
                rq.xcbd__c = conLst[0].Birthdate;
                rq.xcbc__c = conLst[0].bc__c;
                rq.xceml__c = conLst[0].Email;

                rq.xclng__c = conLst[0].lng__c;
                rq.xcmonar__c = conLst[0].mona__c;
                rq.xcjb__c = conLst[0].jb__c;
                rq.xceidid__c = conLst[0].eidid__c;
                rq.xceidedt__c = conLst[0].eidedt__c;
                rq.xcql__c = conLst[0].ql__c;
                rq.xcfs__c = conLst[0].fs__c;
                rq.xcot__c = conLst[0].ot__c;
                rq.xcof__c = conLst[0].of__c;
                rq.xcemrt__c = conLst[0].emrt__c;
                rq.xccty__c = conLst[0].cty__c;
                rq.xcstrt__c = conLst[0].strt__c;
                rq.xcarea__c = conLst[0].area__c;
                rq.xcpobx__c = conLst[0].pobx__c;
                rq.xcpobxarea__c = conLst[0].pobxarea__c;
                rq.xcpic__c = conLst[0].pic__c;
                rq.xcpip__c = conLst[0].pip__c;
                rq.xcpid__c = conLst[0].pid__c;
                rq.xcped__c = conLst[0].ped__c;
                rq.xcrlg__c = conLst[0].rlg__c;
                system.debug('---MS---' + conLst[0].ms__c + '---Contact id---' + conLst[0].id);
                rq.xcms__c = conLst[0].ms__c;
                rq.xcbp__c = conLst[0].bp__c;
                rq.xcpobar__c = conLst[0].bpa__c;
                rq.xcnp__c = conLst[0].np__c;
                rq.xcslt__c = conLst[0].Salutation;
                rq.xcmbs__c = conLst[0].mbs__c;
                rq.xcma__c = conLst[0].ma__c;
                rq.xcmta__c = conLst[0].mta__c;
                rq.xcmoa__c = conLst[0].moa__c;
                rq.xcha__c = conLst[0].ha__c;
                rq.xchph__c = conLst[0].HomePhone;
                if (String.isNotBlank(conLst[0].MobilePhone)) {
                    String mph = conLst[0].MobilePhone;
                    rq.xcmob__c = mph.replaceAll('\\D', '').replaceFirst('971', '').replaceFirst('0', '');
                }
                rq.xrp__c = conLst[0].rp__c;
                rq.xui__c = conLst[0].rpui__c;
                rq.xrpid__c = conLst[0].rpid__c;
                rq.xrped__c = conLst[0].rped__c;
                rq.Spr__c = conLst[0].Spon__c;
                rq.xcsnc__c = conLst[0].snc__c;
                rq.xcsp__c = conLst[0].sp__c;
                rq.xcid__c = conLst[0].id__c;
                rq.xceidid__c = conLst[0].eidid__c;
                rq.xceidedt__c = conLst[0].eidedt__c;



                //rq.xcsp__c = conLst[0].sp__c;
                //rq.xdedln__c=conLst[0].Account.l__c;
                //rq.xdedc__c=conLst[0].Account.NameS;
                String adhocNew = String.isNotBlank(rq.xadh__c) ? rq.xadh__c : '';
                system.debug('request mona__c::::::' + rq.xcmonar__c);
                //Added for Renewal of Non sponsered ID card
                if (srv.uid__c == '071') { // || srv.uid__c == '382' || srv.uid__c == '383'|| srv.uid__c == '384'
                    system.debug('Golden visa flag:::' + conLst[0].xsgv__c);
                    if (conLst[0].xsgv__c) {
                        // adhocNew += 'gid;';
                    } else {
                        //  adhocNew += 'id;';
                    }
                }
                if (srv.Sub_Category__c == System.Label.AXS2_ServiceTypeRenewal || srv.Sub_Category__c == System.Label.AXS2_ServiceTypeIDRenewal || (srv.Sub_Category__c == System.Label.AXS2_ServiceTypeCancel && adhocNew.contains('ins;'))) {
                    adhocNew = adhocNew.replace('pt', '').replace('pnt', '');
                    if (conLst[0].RP_Expiry_Due__c != 0 && (conLst[0].RP_Expiry_Due__c > 30 && conLst[0].RP_Expiry_Due__c < 90)) adhocNew += 'pt;';
                    if (conLst[0].RP_Expiry_Due__c != 0 && conLst[0].RP_Expiry_Due__c > 90) {
                        if (srv.Sub_Category__c == System.Label.AXS2_ServiceTypeCancel) adhocNew += 'ptn;';
                        else adhocNew += 'pnt;';
                    } /* adhocNew += 'pnt;'; */
                    system.debug('pro checkbox' + conLst[0].Proc__c);
                    if (conLst[0].Proc__c) rq.xadh__c = adhocNew + 'xpc;';
                    else rq.xadh__c = adhocNew;
                }

                if (sd.vtyp__c == 'egv')
                    rq.cldt__c = date.today();


                updateArbicName();
                upsert rq;


                //  oldRqId = reqList[0].id;
                //g_Req__c rqupdated =  [select id,name from g_Req__c where id=:rq.id];
                // rqNo = rqupdated.name;
                // copyDocuments(rq);
                String isTrnsfer = 'n';
                if ((String.isNotBlank(isVisaTransfer) && isVisaTransfer == 'y'))
                    isTrnsfer = 'y';

                ref = new Pagereference('/grqsdr?sid=' + sd.id + '&id=' + rq.id + '&d=n&vt=' + isTrnsfer);
                //ref = new Pagereference('/grqsdr?sid='+sd.id+'&id='+rq.id+'&d=n&vt='+isTrnsfer+'&gv='+conLst[0].xsgv__c);
                ref.setRedirect(true);
                return ref;
            }


            return null;
        } catch (DMLException exDML) {
            system.debug('DMLExceptionEEEEEE: ' + exDML);
            for (Integer i = 0; i < exDML.getNumDml(); i++) {
                if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    System.Debug('** Exception:' + exDML.getDmlMessage(i));
                    gu.AddErrorMsg(Label.msgException);
                }
            }
            return null;
        } catch (exception ex) {
            gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            return null;
        }
    }
    public void updateArbicName() {
        system.debug('updateArbicName::::');
        String gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
        if (String.isNotBlank(rq.xcfn__c)) rq.xcfnar__c = GDRFAUtil.engToArabicStr(rq.xcfn__c, gApiToken);
        if (String.isNotBlank(rq.xcmn__c)) rq.xcmnar__c = GDRFAUtil.engToArabicStr(rq.xcmn__c, gApiToken);
        if (String.isNotBlank(rq.xcln__c)) rq.xclnar__c = GDRFAUtil.engToArabicStr(rq.xcln__c, gApiToken);
    }
    /* public void updateArbicName() {   
system.debug('updateArbicName::::');    
String gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
gApiToken='eyJhbGciOiJIUzI1NiIsImtpZCI6IkY3QzdERTM0N0FFNEI5OEUyNDQ4NjMyQjk4Qzc0NjQ0M0Y2OUFDMjBEODc0MDU1RjVFMTBDQjRFRTI0QjZDMUQiLCJ0eXAiOiJKV1QifQ.eyJzdWIiOiI4NUQ2NUNENzY2ODMxMzM0RjY0QzZCQTQ0OUNDM0I4OTc2NDkxREI2QjIzRDZENzgwNDQ2RUU5QzBCMTIxNzc4IiwianRpIjoiZUhuVVdWYUY5dy9VdlJWaTc3NGw1eHIzMlZqTmVBSG95aUpiWmduTEdVbmF1MmJxRTE1L1JjSHh1MmlxVThUUjFtMExLNCt1YTB3a0hSZHcyalc1MUEiLCJ1c2VyUHVibGljSWQiOiIyNjNjZGU4Mi1lZGRlLTRlMGQtOGE5Ni1lN2I4YzMyNjVhMjciLCJ1c2VybmFtZSI6InRscXlwMTMiLCJyb2xlIjoiZWRucmQiLCJlbWFpbCI6ImRlcGVuZGVudHZpc2FAYXhzLmFlIiwiaXNJbmRpdmlkdWFsIjoiRmFsc2UiLCJ1c2VyVHlwZSI6ImVzdGFibGlzaG1lbnQiLCJlc3RhYl9jb2RlIjoiMjIwMDAwNjQiLCJhcGlrZXkiOiJ1elhJUUhyZ2hMY3ZlNUEwWTNTMTl1Ukg2SUtYOVAwSyIsImVzdGFiX3BpZCI6Ijk3ZGE1MTgwLTE1Y2QtNDE1Ny1iOTVkLWUwODMxZjFmNWY1MSIsImlzRnJlZVpvbmUiOiJGYWxzZSIsIm5iZiI6MTY0MDgyOTYzNiwiZXhwIjoxNjQwOTE2MDM2LCJpYXQiOjE2NDA4Mjk2MzYsImlzcyI6IkU5RTY4ODhDRjMxRkYzRDBBNEY4QzQ4NjI4RUMyODg5MDkzNjQ4MjAzQTQ3QjVENkRBMEYxM0VCMDJCN0U2NTAiLCJhdWQiOiIzNEMwQTFGNTE1OTY3RTNGMTc3NDkwOEI3RThDNTQzNjkyOTZBMUNBOEY1RkM2NEU0MDdGQzhFMkQwOTQ1QjlBIn0.qsKaqXkSc6ECIzeiQOBU0b8utYy7Il51ssUZ_wmBGEY';
List <String> arbicNationLst = label.AXSArabic.split(';');
List <String> gccNationLst = label.GCCNations.split(';');
if(String.isNotBlank(rq.xcnc__c) && !arbicNationLst.contains(rq.xcnc__c) && !gccNationLst.contains(rq.xcnc__c)){
if(String.isNotBlank(rq.xcfn__c))   
rq.xcfnar__c = GDRFAUtil.engToArabicStr(rq.xcfn__c, gApiToken);   
if(String.isNotBlank(rq.xcmn__c))    
rq.xcmnar__c = GDRFAUtil.engToArabicStr(rq.xcmn__c, gApiToken);     
if(String.isNotBlank(rq.xcln__c)) 
rq.xclnar__c = GDRFAUtil.engToArabicStr(rq.xcln__c, gApiToken); 
}        

}*/
    public void validateVisa() {
        system.debug('visa::' + rq.e__c);
        List < Contact > conLst = [select Account.lc__c, Account.Name, id, nc__c, p__c, RP_Expiry_Due__c, Spon__c, snc__c, sp__c, rp__c, rpid__c, rped__c, mbs__c, ma__c, mta__c, moa__c, ha__c, HomePhone, firstname, middlename, lastname, MobilePhone, mon__c, fan__c, Gender__c, Birthdate, bc__c, Email, fnar__c, mnar__c, lnar__c, lng__c, mona__c, jb__c, eidid__c, eidedt__c, ql__c, ot__c, fs__c, of__c, emrt__c, cty__c, strt__c, area__c, pobx__c, pobxarea__c, pic__c, pip__c, pid__c, ped__c, rlg__c, ms__c, bp__c, bpa__c, np__c, Salutation from Contact where STA__c = 'Active'
            and rp__c =: rq.e__c and rol__c = 'Employee'
        ]; // and rped__c > NEXT_N_DAYS:90

        if (conLst != null && !conLst.isEmpty()) {

            Date rpVilidity = Date.today().addDays(90);
            system.debug('visa::' + conLst[0].rped__c + '-' + rpVilidity);

            if (conLst[0].rped__c < rpVilidity) {
                isVisaTransfer = 'n';
                gu.addWarningMsg('Active Employee record exist; please arrange to cancel the existing visa after that proceed the new visa request.');

            } else {
                isVisaTransfer = 'int';
                rq.Con__c = conLst[0].id;
                rq.xcnc__c = conLst[0].nc__c;
                rq.xcp__c = conLst[0].p__c;
                /*if(!(srv.uid__c=='010' || srv.uid__c=='015'|| srv.uid__c=='188'|| srv.uid__c=='189')){*/
                /*rq.xcfn__c =  conLst[0].firstname;
rq.xcln__c = conLst[0].lastname;
rq.xcmn__c = conLst[0].middlename;
rq.xcfan__c = conLst[0].fan__c;
rq.xcfnar__c = conLst[0].fnar__c;
rq.xcmnar__c =  conLst[0].mnar__c;
rq.xclnar__c =  conLst[0].lnar__c;*/
                rq.xcmon__c = conLst[0].mon__c;
                rq.Gender__c = conLst[0].Gender__c;
                rq.xcbd__c = conLst[0].Birthdate;
                rq.xcbc__c = conLst[0].bc__c;
                rq.xceml__c = conLst[0].Email;
                rq.xclng__c = conLst[0].lng__c;
                rq.xcmonar__c = conLst[0].mona__c;
                //rq.xcjb__c = conLst[0].jb__c;
                rq.xceidid__c = conLst[0].eidid__c;
                rq.xceidedt__c = conLst[0].eidedt__c;
                rq.xcql__c = conLst[0].ql__c;
                rq.xcfs__c = conLst[0].fs__c;
                rq.xcot__c = conLst[0].ot__c;
                rq.xcof__c = conLst[0].of__c;
                rq.xcemrt__c = conLst[0].emrt__c;
                rq.xccty__c = conLst[0].cty__c;
                rq.xcstrt__c = conLst[0].strt__c;
                rq.xcarea__c = conLst[0].area__c;
                rq.xcpobx__c = conLst[0].pobx__c;
                rq.xcpobxarea__c = conLst[0].pobxarea__c;
                rq.xcpic__c = conLst[0].pic__c;
                rq.xcpip__c = conLst[0].pip__c;
                rq.xcpid__c = conLst[0].pid__c;
                rq.xcped__c = conLst[0].ped__c;
                rq.xcrlg__c = conLst[0].rlg__c;
                rq.xcms__c = conLst[0].ms__c;
                rq.xcbp__c = conLst[0].bp__c;
                rq.xcpobar__c = conLst[0].bpa__c;
                rq.xcnp__c = conLst[0].np__c;
                rq.xcslt__c = conLst[0].Salutation;
                //rq.xcmbs__c = conLst[0].mbs__c;
                //rq.xcma__c = conLst[0].ma__c;
                //rq.xcmta__c = conLst[0].mta__c;
                //rq.xcmoa__c = conLst[0].moa__c;  
                rq.xcha__c = conLst[0].ha__c;
                rq.xchph__c = conLst[0].HomePhone;
                if (String.isNotBlank(conLst[0].MobilePhone)) {
                    String mph = conLst[0].MobilePhone;
                    rq.xcmob__c = mph.replaceAll('\\D', '').replaceFirst('971', '').replaceFirst('0', '');
                }
                //rq.xcmob__c = conLst[0].MobilePhone;  
                rq.xrp__c = conLst[0].rp__c;
                rq.xrpid__c = conLst[0].rpid__c;
                rq.xrped__c = conLst[0].rped__c;
                rq.Spr__c = conLst[0].Spon__c;
                rq.xcsnc__c = conLst[0].snc__c;
                rq.xcsp__c = conLst[0].sp__c;
                rq.xdedln__c = conLst[0].Account.lc__c;
                rq.xdedc__c = conLst[0].Account.Name;
            }

        } else
            isVisaTransfer = '';
        system.debug('isVisaTransfer::' + isVisaTransfer);
    }
    public PageReference saveDraft() {
        system.debug('inisde save');
        Pagereference ref = null;
        string ischeckbox = Apexpages.currentPage().getParameters().get('insurancereq');
        string lpage = Apexpages.currentPage().getParameters().get('landingpage');
        String xadhval = Apexpages.currentPage().getParameters().get('xadhvals');
        try {
            system.debug('pid::' + pid);
            if (String.isNotBlank(pid)) {
                rq.xcpid__c = strDate(pid);
            }
            if (String.isNotBlank(ped)) {
                rq.xcped__c = strDate(ped);
            }
            if (String.isNotBlank(dob)) {
                rq.xcbd__c = strDate(dob);
            }
            if (String.isNotBlank(ved)) {
                rq.xaed__c = strDate(ved);
            }
            if (String.isNotBlank(eed)) {
                rq.xceidedt__c = strDate(eed);
            }
            if (rq.xadh__c != null && (rq.xadh__c).contains('la')) {
                //rq.xeidav__c='Yes';
            }
            system.debug('ischeckbox----' + ischeckbox);
            system.debug('lpage---' + lpage);
            system.debug('xadhval----' + xadhval);
            if (String.isNotBlank(ischeckbox)) {
                if (ischeckbox == 'true') {
                    rq.InsChk__c = true;
                    rq.xadh__c = xadhval;
                } else {
                    rq.InsChk__c = false;
                    rq.xadh__c = xadhval;
                }

            }
            if (srv.uid__c != null && srv.uid__c == '199' && rq.xcsrs__c == 'Spouse') {
                rq.xcms__c = 'Married';
            }
            system.debug('srv.uid__c::' + srv.uid__c);
            system.debug('sd.vtyp__c::' + sd.vtyp__c);
            if (srv.uid__c == 'uae') {
                rq.scFlg__c = true;

            }
            system.debug('---rq.xcms__c---' + rq.xcms__c);
            system.debug('---rq.srv.uid__c---' + srv.uid__c);
            rq.STA__c = 'Draft';
            if (srv.uid__c == '923') {
                /*FLD - VMKR*/
                system.debug('req -- ' + rq);
                system.debug('req.xfme__c -- ' + rq.xfme__c);
                List < Contact > applicant = [select id, sta__c, name from contact where accountid =: u.contact.account.id and rol__c = 'Employee'
                    and rp__c != null and rp__c != '' limit 1
                ];
                system.debug('applicant -- ' + applicant);
                if (applicant != null && applicant.size() > 0)
                    rq.Con__c = applicant[0].id;
                else {
                    Contact con = [select id, sta__c, name from contact where accountid =: u.contact.account.id limit 1];
                    rq.Con__c = con.id;
                }
                rq.STA__c = 'Under Review';
                rq.xdsd__c = System.now();
            }

            //Mission Visa - Set temporary staff job id
            if (srv.uid__c == '301') {
                rq.xcjb__c = Label.TemporaryStaffJobId;
            }

            if (sd.cv__c == 'Freelancer' && String.isNotBlank(rq.xcp__c)) {
                docName = 'Passport - first page';
                Boolean flg = grqWsOnboard.validateFreelancer(rq);
                if (flg) {
                    gu.AddErrorMsg(Label.msgFlValid);
                    return ref;
                }
                /*Set<String> gccNations = new Set<String>{'Bahrain','Kuwait','Oman','Qatar','Saudi Arabia','United Arab Emirates'}; 
if(gccNations.contains(rq.xcnc__c)){
rq.xeidav__c = 'Yes';  
} */
            }
            updateArbicName();
            upsert rq;
            //Database.UpsertResult  SR = Database.upsert(rq);
            system.debug('Rq Id::' + rq.id);
            system.debug('docName: ' + docName);

            //if(Sr.success){    
            saveAttachment();
            //}
            String isTrnsfer = 'n';
            if ((String.isNotBlank(isVisaTransfer) && isVisaTransfer == 'y') || (String.isNotBlank(rq.xcspb__c) && rq.xcspb__c == 'Parent Company'))
                isTrnsfer = 'y';
            else if (String.isNotBlank(isVisaTransfer))
                isTrnsfer = isVisaTransfer; //int
            String landpage = 'y';
            if (String.isNotBlank(lpage) && (lpage == 'lp')) {
                landpage = 'n';
            }
            system.debug('tst1::' + sd.cv__c);
            if (sd.cv__c == 'Freelancer') {
                system.debug('tst2::');
                if (String.isNotBlank(Acc.ccrm_sfid__c))
                    grqWsOnboard.updateFrlAccInfo(rq, Acc.ccrm_sfid__c);
                system.debug('tst2::');
                String cd = ApexPages.currentPage().getParameters().get('i');
                ref = new Pagereference('/obrqfl?sid=' + sd.id + '&id=' + rq.id + '&d=' + landpage + '&vt=' + isTrnsfer);
            } else if (srv.uid__c == 'uae' && !(rq.xadh__c).contains('sd')) {
                ref = new Pagereference('/' + rq.id);
            } else if (srv.uid__c == '923') {
                /* FLD - vmkr */
                ref = new PageReference('/apex/grqSInfo?id=' + rq.Id);
            } else
                ref = new Pagereference('/grqsdr?sid=' + sd.id + '&id=' + rq.id + '&d=' + landpage + '&vt=' + isTrnsfer);

            ref.setRedirect(true);
            return ref;



        } catch (DMLException exDML) {
            system.debug('DMLExceptionEEEEEE: ' + exDML);
            for (Integer i = 0; i < exDML.getNumDml(); i++) {
                if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    System.Debug('** Exception:' + exDML.getDmlMessage(i));
                    gu.AddErrorMsg(Label.msgException);
                }
            }
            return ref;
        } catch (exception ex) {
            gu.AddErrorMsg(ex.getStackTraceString());
            return null; //ex + ' gctlReq01'
        }

    }
    public List < g_reqitemDoc__c > srvDoc {
        get;
        set;
    }
    public PageReference saveDraft1() {
        Pagereference ref = null;
        string ischeckbox = Apexpages.currentPage().getParameters().get('insurancereq');
        try {
            if (String.isNotBlank(ischeckbox)) {
                if (ischeckbox == 'true') {
                    rq.InsChk__c = true;
                } else {
                    rq.InsChk__c = false;
                }
            }
            rq.STA__c = 'Draft';
            Database.UpsertResult SR = Database.upsert(rq);
            srvDoc = [select Name, lbl__c, id, Req__c from g_reqitemDoc__c where Re__c =: rq.name and Req__c = true];
            if (String.isNotBlank(sd.srvdocs__c)) {
                List < String > dLst = sd.srvdocs__c.split(';');
                List < String > enableOCRLst = gu.csStr('enableOCR').split(';');
                List < String > optDocsLst = gu.csStr('OptionsDocs').split(';');
                docTrnsList = new List < D > ();
                integer val = 0;
                for (g_reqitemDoc__c s: srvDoc) {
                    D obj = new D();
                    obj.DocName = s.name;
                    obj.DocLabel = s.lbl__c;
                    if (enableOCRLst.contains(s.name)) obj.parse = true;
                    else obj.parse = false;
                    obj.isOptional = s.Req__c;
                    val = val + 1;
                    docTrnsList.add(obj);
                }
            }
            return null;
        } catch (DMLException exDML) {
            system.debug('DMLExceptionEEEEEE: ' + exDML);
            for (Integer i = 0; i < exDML.getNumDml(); i++) {
                if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                    System.Debug('** Exception:' + exDML.getDmlMessage(i));
                    gu.AddErrorMsg(Label.msgException);
                }
            }
            return ref;
        } catch (exception ex) {
            gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            return null;
        }
    }

    public void copyDocuments() {

        List < Attachment > clnAttchLst = new List < Attachment > ();
        Map < string, Attachment > attMp = new Map < string, Attachment > ();
        List < String > dList = new List < String > ();
        for (D doc: docList)
            dList.add(doc.DocName);
        Attachment orgObj = null;
        Attachment cloneObj = null;
        List < g_reqDoc__c > rdocList = [select id from g_reqDoc__c where RQ__c =: oldRqId and Req__c = true and reqAts__c = true and upOk__c = true]; //and  name=:dList
        for (Attachment att: [select id, name, body, parentid from Attachment where parentid =: rdocList]) {
            attMp.put(att.name.split('\\.')[0], att);
        }
        for (g_reqitemDoc__c doc: [select id, Name, reqItm__r.xcp__c, reqItm__r.rq__c, reqDoc__c from g_reqitemDoc__c where reqItm__r.rq__c =: rq.id and Req__c = true and reqAts__c = true and upOk__c = false order by createddate]) {

            if (attMp != null && attMp.containsKey(doc.Name)) {
                orgObj = attMp.get(doc.Name);
                cloneObj = orgObj.clone(false, true, false, false);
                cloneObj.parentid = doc.reqDoc__c;
                clnAttchLst.add(cloneObj);
            }
        }
        if (clnAttchLst != null && !clnAttchLst.isEmpty())
            insert clnAttchLst;
        Map < string, Attachment > docMp = new Map < string, Attachment > ();
        for (Attachment att: [select id, name, parent.name from Attachment where id =: clnAttchLst])
            docMp.put(att.parent.name, att);
        for (D doc: docList) {
            if (docMp != null && docMp.containskey(doc.DocName)) {
                Attachment att = docMp.get(doc.DocName);
                doc.attId = att.Id;
                doc.attName = att.name;
            }

        }
    }

    public void saveAttachment() {
        try {
            system.debug('Rq Id::' + rq.id);
            system.debug('docName: ' + docName);
            List < g_reqDoc__c > rqDocList = [select id, RQ__r.name from g_reqDoc__c where RQ__c =: rq.id and name =: docName];
            if (rqDocList != null && !rqDocList.isEmpty() && String.isNotBlank(imageBase64)) {
                rqNo = rqDocList[0].RQ__r.name;
                Attachment A = new Attachment(Body = EncodingUtil.base64Decode(imageBase64), Name = docName + '.jpg', ParentId = rqDocList[0].id);
                insert A;
                if (String.isBlank(isVisaTransfer)) {
                    for (D doc: docList) {
                        if (doc.DocName == docName) {
                            doc.attId = A.Id;
                            doc.attName = docName + '.jpg';
                        }
                    }
                } else {
                    for (D doc: docTrnsList) {
                        if (doc.DocName == docName) {
                            doc.attId = A.Id;
                            doc.attName = docName + '.jpg';
                        }
                    }
                }
                if (gU.csStr('Photo').toLowerCase().contains(docName.toLowerCase())) {
                    if (rq.xphid__c == null) {
                        rq.xphid__c = A.Id;
                        update rq;
                    }
                    if (rq.xphid__c != A.Id) {
                        rq.xphid__c = A.Id;
                        update rq;
                    }
                    g_req__c rr = [Select id, Con__r.id, Con__r.Photo_ID__c, Con__r.xsgv__c from g_req__c where id =: rq.id limit 1];
                    if (rr.Con__r != null) {
                        Contact c = rr.Con__r;
                        c.Photo_ID__c = A.Id;
                        update C;
                    }
                }
            }
        } catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
    }
    public void deleteAttach() {
        try {
            string attId = Apexpages.currentPage().getParameters().get('attId');
            system.debug('deleteAttach attId >>' + attId);
            Attachment A = new Attachment(Id = attId);
            delete A;
            if (String.isBlank(isVisaTransfer)) {
                for (D doc: docList) {
                    if (doc.attId == attId) {
                        doc.attId = '';
                        doc.attName = '';
                    }
                }
            } else {
                for (D doc: docTrnsList) {
                    if (doc.attId == attId) {
                        doc.attId = '';
                        doc.attName = '';
                    }
                }
            }
        } catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
        }
    }
    //public Pagereference nextPage() { PageReference ref = null; Boolean isUpFlg = false; Set < String > docReqList = new Set < String > (); system.debug('isVisaTransfer::' + isVisaTransfer); if (String.isNotBlank(rq.Id)) { for (g_reqDoc__c d: [Select Id, name, upOk__c From g_reqDoc__c where RQ__c =: rq.Id and Req__c = true and IsDeleted = false]) { if (!d.upOk__c) { isUpFlg = true; docReqList.add(d.name); } } } else { if (String.isBlank(isVisaTransfer)) { for (D doc: docList) { system.debug('doc name::' + doc.DocName + ': optional::' + doc.isOptional); if (!doc.isOptional && String.isBlank(doc.attId)) { docReqList.add(doc.DocName); isUpFlg = true; } } } else { for (D doc: docTrnsList) { if (!doc.isOptional && String.isBlank(doc.attId)) { docReqList.add(doc.DocName); isUpFlg = true; } } } } if (isUpFlg) { gU.AddErrorMsg('Please upload all mandatory documents.'); for (String docName: docReqList) gU.AddErrorMsg(docName); } else { if (sd.cv__c != 'Freelancer') { updateAdhocItems(); } if (sd.cv__c == 'Freelancer' || sd.vtyp__c == 'egv') { rq.STA__c = 'Open'; Database.UpsertResult SR = Database.upsert(rq); } ref = new PageReference('/' + rq.id); ref.setRedirect(true); } return ref; }
    public Pagereference nextPage() {
        PageReference ref = null;
        Boolean isUpFlg = false;
        Set < String > docReqList = new Set < String > ();
        system.debug('isVisaTransfer::' + isVisaTransfer);
        if (String.isNotBlank(rq.Id)) {
            for (g_reqDoc__c d: [Select Id, name, upOk__c From g_reqDoc__c where RQ__c =: rq.Id and Req__c = true and IsDeleted = false]) {
                if (!d.upOk__c) {
                    isUpFlg = true;
                    docReqList.add(d.name);
                }
            }
        } else {
            if (String.isBlank(isVisaTransfer)) {
                for (D doc: docList) {
                    system.debug('doc name::' + doc.DocName + ': optional::' + doc.isOptional);
                    if (!doc.isOptional && String.isBlank(doc.attId)) {
                        docReqList.add(doc.DocName);
                        isUpFlg = true;
                    }
                }
            } else {
                for (D doc: docTrnsList) {
                    if (!doc.isOptional && String.isBlank(doc.attId)) {
                        docReqList.add(doc.DocName);
                        isUpFlg = true;
                    }
                }
            }
        }
        if (isUpFlg) {
            gU.AddErrorMsg('Please upload all mandatory documents.');
            for (String docName: docReqList) gU.AddErrorMsg(docName);
        } else {
            if (sd.cv__c != 'Freelancer') {
                updateAdhocItems();
            }
            if (sd.cv__c == 'Freelancer' || sd.vtyp__c == 'egv') {
                rq.STA__c = 'Open';
                Database.UpsertResult SR = Database.upsert(rq);
            }
            ref = new PageReference('/' + rq.id);
            if (srv.uid__c == '071' && !isUpFlg) {
                ref = new PageReference('/' + srv.stg__r.pg__c + '?id=' + rq.id);
            }
            ref.setRedirect(true);
        }
        return ref;
    }


    public void fetchDependentInfo() {
        try {
            system.debug('Sponsor::' + rq.spr__c);
            List < contact > depList = [select id, name, rol__c from contact where Spon__c =: rq.spr__c AND STA__c IN('Active', 'Draft') AND rol__c IN('Spouse', 'Child')];
            if (depList != null && !depList.isEmpty()) depListStr = JSON.serialize(depList); /*system.debug('depListStr ---- '+depListStr);*/
        } catch (exception ex) {
            gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    }

    public void updateAdhocItems() {
        try {
            system.debug('adhoc ::' + rq.xadh__c);
            if (String.isNotBlank(eed)) {
                rq.xceidedt__c = strDate(eed);
            }
            if (sd.cv__c == 'VisaRenewal' || sd.cv__c == 'VisaCorrection' || sd.cv__c == 'updateAttr') {
                rq.scFlg__c = true;
            }
            update rq;
        } catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
    }


    public Boolean hasSanctions {
        get {
            grqH.rH h = new grqH.rH();
            System.debug('::rq:::' + rq);
            System.debug('::srv:::' + srv);
            System.debug('::Acc:::' + Acc);
            return !h.BC(rq, srv, Acc);
        }

    }
    public String dtStr(Date dt) {
        String strSt = ((dt.day() > 9) ? String.valueOf(dt.day()) : '0' + dt.day()) + '/' + ((dt.month() > 9) ? String.valueOf(dt.month()) : '0' + dt.month()) + '/' + dt.year();
        return strSt;
    }
    public Date strDate(String dt) {

        //List<string> lst = pid.split('/');
        List < string > lst = dt.split('/');
        return lst != null && lst.size() > 0 ? Date.newInstance(integer.valueOf(lst[2]), integer.valueOf(lst[1]), integer.valueOf(lst[0])) : null;


    }
    private Boolean accesssOk {
        get {
            Boolean acsOk = gu.canReqSrvc(rq.srvc__c, false, null);
            if (!acsOk) {
                if (true) {
                    gu.addWarningMsg(Label.msgNoPrivilege);
                } else {
                    gu.addInfoMsg(Label.msgReadOnly);
                }
            }
            return acsOk;
        }
    }

    private Boolean srvAccesssOk {
        get {
            Boolean acsOk = gu.canAccess2(rq.srvc__r.sdg__c, false, null);
            if (!acsOk) {
                gu.addWarningMsg('You don’t have sufficient access for this service please contact your General Manager for permissions');
            }
            return acsOk;
        }
    }

    public class D {
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
        public String tmpltId {
            get;
            set;
        }
        public String attId {
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
}