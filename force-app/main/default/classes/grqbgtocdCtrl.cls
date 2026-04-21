public class grqbgtocdCtrl {
    public g_Req__c req {
        get;
        set;
    }
    public g_Req__c rq {
        get;
        set;
    }
    public g_Srvc__c srv {
        get;
        set;
    }
    public Account Acc {
        get;
        set;
    }
    public String pyMthd {
        get;
        set;
    }
    public Boolean ispu {
        get;
        set;
    }
    public Boolean isgu {
        get;
        set;
    }
    public String sid {
        get;
        set;
    }
    public String srvcID {
        get;
        set;
    }
    public String reqId {
        get;
        set;
    }
    public String nxtPgUrl {
        get;
        set;
    }
    public User U {
        get;
        set;
    }
    public Map < String, String > slaMp {
        set;
        get;
    }
    public List < string > priorityList {
        set;
        get;
    }
    public string srvDesc {
        get;
        set;
    }
    public string lcl {
        get {
            return UserInfo.getLocale();
        }
    }
    public grqbgtocdCtrl(ApexPages.StandardController controller) {}
    private String m_SOQL;
    public Set < Id > riIds;
    public String pt {
        get;
        set;
    }
    public String pDsc {
        get;
        set;
    } /*public string lcl{get{return UserInfo.getLocale();}} */
    public g_Tran__c T {
        get;
        set;
    }
    public list < itm > Is {
        get;
        set;
    }
    private transient decimal AOP = 0;
    public List < Selectoption > pyMthds {
        get;
        set;
    }
    public Boolean payDone {
        get;
        set;
    }
    public String pdfConfirm {
        get;
        set;
    }
    public Decimal vat {
        get;
        set;
    }
    public Boolean phide {
        get;
        set;
    }
    public grqbgtocdCtrl() {

        isgu = gU.isGuestUser(UserInfo.getProfileId());
        Boolean hasAccess2;
        phide = true;
        reqId = apexpages.currentpage().getparameters().get('id');
        srvcID = ApexPages.CurrentPage().getParameters().get('sid');
        nxtPgUrl = null;
        ispu = gU.isPortalUser(UserInfo.getProfileId());
        slaMp = new Map < String, String > ();
        if (reqId == null) {
            req = new g_Req__c();
            req.srvc__c = ApexPages.CurrentPage().getParameters().get('sid');
            getServ(req.srvc__c);
            if (!ispu && !isgu) {
                getServ(req.srvc__c);
                return;
            }
            //   U = [select id,FirstName,LastName,contact.account.mtc__c,contact.account.Name,contact.account.Email__c,contact.account.Phone,MobilePhone,accountid,
            //          contact.account.id,contact.account.adb__c,contact.account.xcuzn__c,contact.account.xcublg__c,contact.account.bgb__c,contact.account.bgnr__c,contact.account.bg__c,contact.account.loc__c,contact.account.Type,contact.account.Prk__c,contact.account.lcsnc__c,contact.account.lcsncnt__c,contact.account.lcedt__c,contact.account.psasnc__c,contact.account.psasncnt__c,contact.account.ecsnc__c,contact.account.ecsncnt__c,contact.account.cosnc__c,contact.account.cosncnt__c,contact.account.bgsnc__c,contact.account.bgsncnt__c,contact.account.snc__c,contact.account.info__c,contact.account.vestd__c,contact.account.vbtemp__c,contact.account.vbvv__c,
            //         contact.account.lc__c,contact.account.vbtst__c,contact.account.ORACLE_PARTY_ID__c,contact.account.lcsta__c,contact.account.lctp__c,contact.account.session__c,contact.account.vctemp__c,contact.account.vvsfp__c,contact.account.lcrndt__c,contact.account.os__c,contact.account.vespe__c from User where id=:UserInfo.getUserId() limit 1];  

        }

        if (reqId != null) {

            req = [select Id, acc__r.id, Acc__r.Legal_Framework__c, Srvc__r.sdg__c, Srvc__r.sdg__r.sd__c, Srvc__r.sdg__r.ptype__c,
                srvc__c, sta__c, srvc__r.uid__c, srvc__r.Name, srvc__r.stg__c, srvc__r.stg__r.pg__c, srvc__r.AddOnSrv__c, srvc__r.stg__r.reqq__c, xtpa__c,
                srvc__r.stg__r.bopg__c, xcamc__c, xcamdt__c, xnry__c, tob__c, srvc__r.suvtp__c from g_Req__c where id =: reqId
            ];
            getAcc();



            if (String.isNotBlank(req.Srvc__r.sdg__r.ptype__c)) {
                list < String > prLst = (req.Srvc__r.sdg__r.ptype__c).split(';');
                for (String str: prLst) {
                    system.debug('str++' + str);
                    list < String > slaLst = str.split(':');
                    system.debug('slaLst===' + slaLst);
                    slaMp.put(slaLst[0], slaLst[1]);
                }
                system.debug('slaMp++' + slaMp);
                priorityList = new list < String > ();
                priorityList.addAll(slaMp.keySet());
            }
            system.debug('priorityList+++' + priorityList);
            system.debug('req.srvc__r.uid__c >>' + req.srvc__r.uid__c);
            system.debug('req query >>' + req.srvc__r.stg__r.reqq__c);
            //req = fetchREQ(req.id);
            // getServ(req.Srvc__c);
        } else {
            //loadData();
            // md = new gu.pgMode();
        }



    }
    private void getServ(String srvID) {
        if (srvID != null) {
            srv = [select id, sdg__c, sdg__r.docslbl__c, sdg__r.slbl__c, sdg__r.ptype__c, sdg__r.sd__c, uid__c, name, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c, consta__c, sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c, stg__r.reqq__c from g_Srvc__c where id =: srvID limit 1];
            priorityList = new List < String > ();
            slaMp = new Map < String, String > ();
            if (String.isNotBlank(srv.sdg__r.ptype__c)) {
                list < String > prLst = (srv.sdg__r.ptype__c).split(';');
                for (String str: prLst) {
                    list < String > slaLst = str.split(':');
                    slaMp.put(slaLst[0], slaLst[1]);
                }
                priorityList.addAll(slaMp.keySet());
            }

            srvDesc = srv.sdg__r.sd__c;

        }
    }
    public Pagereference processPay() {
        Pagereference ref = null;
        req.srvc__c = ApexPages.CurrentPage().getParameters().get('sid');
        req.Acc__c = Acc.id;
        
        system.debug('sid####' + req.srvc__c);
        system.debug(req.Acc__c);
        //system.debug(req.xtpa__c); 
        
        req.STA__c = 'Under Review';
        getServ(req.srvc__c);
        upsert req;

        if (crtPay('Completed', 'Bank Guarantee', req.id)) {
            ref = new Pagereference('/apex/grqStatus?id=' + req.id);
            payDone = true;
        }
        return ref;
    }
    public PageReference assignAccount() {
        System.debug('req.acc:: ' + req.acc__c);
        try {
            if (req.acc__c != null) getAcc();
            if (Acc.lcsta__c != 'License Under Cancellation' && Acc.lcsta__c != 'License Cancelled') {
                gu.AddErrorMsg('Only Account under License Under Cancellation or License Cancelled are allowed.');
                phide = false;
                return null;
            } else {
                req.srvc__c = ApexPages.CurrentPage().getParameters().get('sid');
                req.xtpa__c = 0;
                upsert req;
            }

        } catch (Exception e) {
            system.debug(e.getStackTraceString());
        }
        return null;

    }
    public void getAcc() {
        Acc = [select id, dedlic__c, lcidt1__c, isDS__c, ecedt__c, ccrm_sfid__c, lcsta__c, Name, Legal_Framework__c, vvsfp__c, lrd__c, onar__c, Phone, adb__c, bgb__c, bgrf__c, bgnr__c, bg__c, lc__c, ORACLE_PARTY_ID__c, loc__c, Type, Prk__c, lcsnc__c, lcsncnt__c, psasnc__c, psasncnt__c, ecsnc__c, ecsncnt__c, cosnc__c, cosncnt__c, bgsnc__c, bgsncnt__c, snc__c, info__c, vestd__c, vbtemp__c, vbvv__c, lcedt__c, vbtst__c, (Select Id, acct__c, act__c, act_type__c, bus_unit__c, dcca_id__c, lic__c, or_prty__c, seg__c, sDate__c from aseg__r), (Select Id, Loc__c, agrno__c, acc__c, bu__c, IsMain__c, IsSub__c, ls_end__c, ls_std__c, active__c, rpi__c, Is_frzn__c from aloc__r where Is_frzn__c = true) from Account where id =: req.Acc__c limit 1];
    }
    @testvisible private Boolean crtPay(String STA, String mthd, String rid) {
        Savepoint sp = null;
        try {
            Is = new list < itm > ();
            pyMthds = new List < Selectoption > ();
            AOP = 0;

            m_SOQL = 'Select  xltr__c,Id,Name,STA__c,AT__c,AP__c,AOP__c,dsc__c,dsc__r.prct__c,spCh__c,rmob__c,xcnc__c,xaloc__c,xbrnd__c,xbn__c, nt__c, xfpc__c, srvc__r.dis_req__c ,srvc__c,srvc__r.name,srvc__r.lbl__c,srvc__r.dsc__c,srvc__r.Prk__c,srvc__r.AccTp__c, srvc__r.ckgsnc__c, srvc__r.Category__c,srvc__r.snc__c,srvc__r.stg__r.pg__c,srvc__r.stg__r.apx__c,srvc__r.stg__r.reqq__c,srvc__r.payMd__c, Acc__r.Name,Acc__r.lc__c, Acc__c,Acc__r.Type,Acc__r.Prk__c,Acc__r.lcsnc__c,Acc__r.lcsncnt__c,Acc__r.psasnc__c,Acc__r.psasncnt__c,Acc__r.ecsnc__c,Acc__r.ecsncnt__c, Acc__r.cosnc__c,Acc__r.cosncnt__c,Acc__r.bgsnc__c,Acc__r.bg__c,Acc__r.bgsncnt__c,Acc__r.snc__c,Acc__r.info__c,Acc__r.vestd__c,Acc__r.vbtemp__c, LastModifiedDate,LastModifiedById,CreatedDate,CreatedById, Acc__r.adb__c,Acc__r.bgb__c,Acc__r.bgnr__c,xtpa__c,srvc__r.uid__c, (Select Id,Name From reqMbrs__r where isDeleted=false), (Select Id,Name,mxAts__c,mnAts__c,ats__c,nt__c,or__c,reqAts__c,reqOr__c,tplt__c,upOk__c,mbr__c,mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false), (Select Id,Name,STA__c,dt__c,A__c,md__c,TP__c From Transactions__r where isDeleted=false), (select id,Name,RQ__c,nc__c,rv__c,m__c,m__r.Name,vSTA__c, AP__c,AD__c,AOP__c,nt__c,xprnt__c,xr__c, Dsc__c,DscApp__c,KF__c,cN__c,scN__c, smN__c,exp__c,cXP__c,scXP__c,smXP__c, itm__c,itm__r.xf__c,itm__r.cd__c,itm__r.Name,itm__r.lbl__c,itm__r.Tp__c,itm__r.Req__c,itm__r.exp__c, itm__r.prcEdt__c,itm__r.dSTA__c, sta__c,sta__r.cd__c,sta__r.Name,sta__r.lbl__c,sta__r.Tp__c,sta__r.rc__c,sta__r.noEXP__c,sta__r.Courier_Stage__c,xcawb__c,xcnopro__c ,xcub__c ,xcco__c,xcasc__c,LastModifiedDate,LastModifiedById,CreatedDate,CreatedById,AV__c,su__c,vsu__c,TAX_CODE__c,extc__c,TAXCODE_SC__c,extcsc__c,vsc__c,vesch__c,vst__c,vec__c,ngs__c,ngsXP__c,tvatp__c,tgop__c,tngop__c,tgovp__c,tvngp__c From Items__r where IsDeleted=false order by itm__r.ord__c),Zone__c,Full_Name__c,CreatedBy.Name From g_Req__c';

            rq = (g_Req__c) Database.query(m_SOQL + ' where id=\'' + rid + '\' and isDeleted = false');
            T = new g_Tran__c(Acc__c = rq.Acc__c, RQ__c = rq.Id, TP__c = 'Payment');
            if (rq.Items__r != null) {
                for (g_reqitem__c i: rq.Items__r) {
                    if (i.AD__c > 0) {
                        Is.add(new itm(i));
                    }
                    AOP += i.AOP__c;
                }
            }
            Integer cnt = 0;
            Decimal Amt2Pay = 0;
            for (itm i: Is) {
                if (i.s) {
                    cnt++;
                    Amt2Pay += i.I.AD__c;
                }
            }
            if (cnt == 0) {
                gU.AddWarningMsg(Label.msgNoItemSlct);
                return false;
            }
            T.STA__c = STA;
            T.TP__c = 'Payment';
            T.md__c = mthd;
            T.dt__c = Date.today();
            sp = Database.setSavepoint();
            system.debug('rq.AP__c::' + rq.AP__c);
            list < g_TranItem__c > TIs = new list < g_TranItem__c > ();
            riIds = new Set < Id > ();
            if (rq.AP__c == 0) {
                system.debug('T223===' + T);
                List < user > ulist = [select id, accountId, ContactId, contact.accountid from user where Id =: userInfo.getUserId()];
                system.debug('T223==User==' + ulist);

                upsert T;
            }
            for (itm i: Is) {
                if (i.s) {
                    system.debug('i===dssds====' + i);
                    if ((i.I.vsc__c != 0 || i.I.vst__c != 0) || (i.I.exp__c && (i.I.vesch__c != 0 || i.I.vec__c != 0))) {
                        Decimal govtFee = i.I.KF__c + i.I.smN__c + (i.I.exp__c ? i.I.smXP__c : 0);
                        Decimal govtVATFee = 0;
                        Decimal nonGovtFee = 0;
                        Decimal vatAmt = 0;
                        Decimal vatAmtGvt = 0;
                        String taxCode = i.I.TAX_CODE__c;
                        String taxCodeGov = i.I.TAXCODE_SC__c;
                        if (i.I.vst__c != 0) {
                            vatAmtGvt = i.I.vst__c;
                            govtVATFee = i.I.cN__c;
                        } else govtFee = govtFee + i.I.cN__c;
                        if (i.I.vsc__c != 0) nonGovtFee = i.I.scN__c;
                        else govtFee = govtFee + i.I.scN__c;
                        if (mthd == 'Cash' && i.I.su__c != null && i.I.su__c > 0) nonGovtFee = nonGovtFee + (i.I.su__c != null ? i.I.su__c : 0) + (i.I.vsu__c != null ? i.I.vsu__c : 0);
                        if (i.I.exp__c && i.I.vesch__c != 0) {
                            taxCode = i.I.extc__c;
                            nonGovtFee = nonGovtFee + i.I.scXP__c;
                        } else if (i.I.exp__c && i.I.vesch__c == 0) {
                            govtFee = govtFee + i.I.scXP__c;
                            taxCodeGov = i.I.extcsc__c;
                        }
                        if (i.I.exp__c && i.I.vec__c != 0) {
                            govtVATFee = govtVATFee + i.I.cXP__c;
                            vatAmtGvt = vatAmtGvt + i.I.vec__c;
                        } else if (i.I.exp__c && i.I.vec__c == 0) {
                            govtFee = govtFee + i.I.cXP__c;
                        }
                        govtFee = govtFee - i.I.tgop__c;
                        govtVATFee = govtVATFee - (i.I.tgovp__c - i.I.tvatp__c);
                        nonGovtFee = nonGovtFee - (i.I.tngop__c - i.I.tvngp__c);
                        vatAmt = i.I.AV__c - vatAmtGvt + i.I.tvatp__c;
                        vatAmtGvt = vatAmtGvt - i.I.tvatp__c;
                        if (govtFee > 0) {
                            TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = govtFee, VAT__c = 0, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = gu.csStr('TAXCodeEXEMPTED')));
                        }
                        if (govtVATFee > 0) {
                            TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = govtVATFee + vatAmtGvt, VAT__c = vatAmtGvt, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = ((taxCodeGov != null && taxCodeGov == 'EXEMPTED') ? gu.csStr('TAXCodeEXEMPTED') : taxCodeGov)));
                        }
                        if (nonGovtFee > 0) {
                            TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = nonGovtFee + vatAmt, VAT__c = vatAmt, ngs__c = true, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = ((taxCode != null && taxCode == 'EXEMPTED') ? gu.csStr('TAXCodeEXEMPTED') : taxCode)));
                        }
                    } else {
                        TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = i.I.AD__c, VAT__c = 0, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = gu.csStr('TAXCodeEXEMPTED')));
                        if (mthd == 'Cash' && i.I.su__c != null && i.I.su__c > 0) TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = (i.I.su__c != null ? i.I.su__c : 0) + (i.I.vsu__c != null ? i.I.vsu__c : 0), VAT__c = (i.I.vsu__c != null ? i.I.vsu__c : 0), ngs__c = true, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = i.I.TAX_CODE__c));
                    }
                    riIds.add(i.I.Id);
                }
            }
            if (TIs.size() > 0 && rq.AP__c == 0) {
                insert TIs;
            }
            system.debug('rq.STA__c::' + rq.STA__c);
            T = [Select TP__c, RQ__r.name, VAT__c, dt__c, A__c, STA__c, nt__c, md__c, gwdt__c, gwmsg__c, gwrf__c, gwcd__c, Acc__r.adx__c, Acc__r.va__c, Acc__r.vato__c, Acc__r.bg__c, Acc__r.Name, Acc__r.BillingStreet, Acc__r.BillingPostalCode, Acc__r.lc__c, Name, Id, RQ__c, cq__c, cdt__c, ci__c, Bnk__c, Acc__c From g_Tran__c g where id =: T.Id];
            rq.STA__c = 'Under Review';
            update rq;
            grqH.rH h = new grqH.rH();
            system.debug('rq.STA__c::' + rq.STA__c);
            h.AP(rq, T, riIds);
            system.debug('xxxxxxx::');

            return true;
        } catch (exception ex) {
            if (sp != null) {
                Database.rollback(sp);
            }
            system.debug('crtPay Exception::' + ex.getStackTraceString() + '===Message===' + ex.getMessage());
            gU.AddErrorMsg(ex);
            return false;
        }
    }
    public class itm {
        public g_reqitem__c I {
            get;
            set;
        }
        public Boolean s {
            get;
            set;
        }
        public Boolean r {
            get;
            set;
        }
        public itm(g_reqitem__c itm) {
            I = itm;
            s = true;
            r = I.itm__r.Req__c;
        }
    }

}