public class gctlTop {
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
    public String ref {
        get;
        set;
    }
    public Boolean isgu {
        get;
        set;
    }
    public String paymentLink {
        get;
        set;
    }
    public String referenceNo {
        get;
        set;
    }
    public g_Req__c rq {
        get;
        set;
    }
    private String m_SOQL;
    public Set < Id > riIds;
    public String pt {
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
    public Boolean pgEdit {
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
    public String pyMthd {
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
    public Decimal rqXtpa {
        get;
        set;
    }
    public Account Acc {
        get;
        set;
    }
    public List < msg > msgLst {
        get;
        set;
    }
    public String rqid {
        get;
        set;
    }
    public String tcDate {
        get;
        set;
    }
    //*** ------- Initialization --------------------------------------------------------------------------------
    public gctlTop(ApexPages.StandardController c) {
        payDone = false;
    }
    private void init() {
        try {
            loadData(); /*/Validate();*/
            if (T != null && T.md__c != null) {
                pyMthd = T.md__c;
            }
            system.debug('T.cq__c >>>' + T.cq__c);
            system.debug('T.cdt__c >>>' + T.cdt__c);
            system.debug('T.ci__c >>>' + T.ci__c);
            system.debug('T.Bnk__c >>>' + T.Bnk__c);
            system.debug('Init pyMthd >>>' + pyMthd);
        } catch (exception ex) {
            gU.AddErrorMsg(ex);
        }
    }

    private void loadData() {
        Is = new list < itm > ();
        pyMthds = new List < Selectoption > ();
        AOP = 0;
        rq = fetchRQ(rqId);
        system.debug('qry::>>>' + rq.srvc__r.stg__r.payq__c);
        if (T == null) {
            T = fetchPreTransaction();
        }
        system.debug('0 T >>>' + T);
        if (m_SOQL == null) {
            m_SOQL = rq.srvc__r.stg__r.payq__c;
        } /*//rq=(g_Req__c)Database.query(m_SOQL+' where id=\''+rq.Id+'\' and isDeleted = false'); // T = new g_Tran__c(Acc__c=rq.Acc__c,RQ__c=rq.Id,TP__c='Payment'); */
        if (rq.Items__r != null) {
            for (g_reqitem__c i: rq.Items__r) {
                system.debug('i.AD__c>>>' + i.AD__c);
                if (i.AD__c > 0) {
                    Is.add(new itm(i));
                }
                AOP += i.AOP__c;
            }
        }
        if (AOP > 0) {
            gu.addInfoMsg('There are open (incomplete) payments of total AED ' + AOP.format());
        }
        pyMthds.add(new SelectOption('', '--None--'));
        if (rq.srvc__r.payMd__c != null) {
            for (String p: rq.srvc__r.payMd__c.split('\\;')) {
                pyMthds.add(new SelectOption(p, p));
            }
        }
    }



    public pagereference Chk() {
        system.debug('tsts:::');
        pgHide = true;
        pgEdit = false;
        try {
            if (apexpages.currentpage().getparameters().get('ref') != null && apexpages.currentpage().getparameters().get('ref') != '') {
                prcssPayRef(apexpages.currentpage().getparameters().get('ref'));
            } else if (apexpages.currentpage().getparameters().get('id') != null && apexpages.currentpage().getparameters().get('id') != '') {
                rqid = apexpages.currentpage().getparameters().get('id'); /*//rqid=fetchRQ(apexpages.currentpage().getparameters().get('id')); //system.debug('rq.STA__c>>>'+rq.STA__c);*/
                ispu = gU.isPortalUser(UserInfo.getProfileId());
                init();
            }
            if (apexpages.currentpage().getparameters().get('m') != null && apexpages.currentpage().getparameters().get('m') != '' && apexpages.currentpage().getparameters().get('m') == 'e') {
                if (rq.STA__c == 'Open' || rq.STA__c == 'In Process') {
                    pgEdit = true;
                }
            }
            if (apexpages.currentpage().getparameters().get('m') != null && apexpages.currentpage().getparameters().get('m') != '' && apexpages.currentpage().getparameters().get('m') == 'p') {
                if (rq.STA__c == 'Open' || rq.STA__c == 'In Process') {
                    payDone = true;
                }
            }
        } catch (exception ex) {
            system.debug('exe::' + ex.getStackTraceString());
            gU.AddErrorMsg(ex);
        }
        system.debug('now rq >> ' + rq);
        if (!payDone && ((rq != null && rq.STA__c == 'Completed') || (T != null && T.md__c != null))) {
            PageReference pageRef = new PageReference('/apex/grqpyinfo?tid=' + T.id + '&m=v');
            return pageRef;
        } else {
            pgHide = false;
        }
        return null;
    }


    public g_Req__c fetchRQ(ID rid) {
        g_Req__c rqt = [Select id, srvc__r.stg__r.payq__c From g_Req__c where id =: rid];
        system.debug('qry::' + rqt.srvc__r.stg__r.payq__c);
        if (m_SOQL == null) {
            m_SOQL = rqt.srvc__r.stg__r.payq__c;
        }
        rq = (g_Req__c) Database.query(m_SOQL + ' where id=\'' + rqt.Id + '\' and isDeleted = false');
        system.debug('Fetched rq>>>' + rq);
        system.debug('Fetched rq.items >>>' + rq.Items__r);
        return rq;
    }

    public g_Tran__c fetchPreTransaction() {
        // list<g_Tran__c>  rqtrans =  database.query(Label.qryTrn+' where RQ__c=\''+rq.id+'\' and isDeleted=false LIMIT 999');
        list < g_Tran__c > rqtrans = database.query('Select TP__c,RQ__r.name,VAT__c,dt__c,A__c,STA__c,nt__c,md__c,gwdt__c,gwmsg__c,gwrf__c,gwcd__c,Acc__r.adx__c,Acc__r.va__c,Acc__r.vato__c,Acc__r.bg__c,Acc__r.Name,Acc__r.BillingStreet,Acc__r.BillingPostalCode,Acc__r.lc__c,Name,Id,RQ__c,cq__c,cdt__c,ci__c,Bnk__c,Acc__c From g_Tran__c where RQ__c=\'' + rq.id + '\' and isDeleted=false LIMIT 999');
        if (rqtrans != null && rqtrans.size() > 0) {
            return rqtrans[0];
        } else {
            return new g_Tran__c(Acc__c = rq.Acc__c, RQ__c = rq.Id, TP__c = 'Payment');
        }
    }

    public pagereference editModeRq() {
        PageReference pageRef = new PageReference('/apex/grqtopup?id=' + rq.id + '&cn=tad&m=v');
        return pageRef;
    }
    public void selectedPT() {
        string pyMType = Apexpages.currentPage().getParameters().get('pyMType');
        system.debug('pyMType >>>' + pyMType);
        if (pyMType == 'Wire') {
            pyMthd = 'Wire Transfer';
        } else if (pyMType == 'Cheque') {
            pyMthd = 'Cheque';
        } else if (pyMType == 'Card') {
            pyMthd = 'Credit / Debit Card';
        } else if (pyMType == 'Cash') {
            pyMthd = 'Cash';
        } else if (pyMType == 'Customer Deposit') {
            pyMthd = 'Customer Deposit';
        }
        system.debug('pyMthd >>>' + pyMthd);
        T.md__c = pyMthd;
        system.debug('test T >>>' + T);
    }
    private void Validate() {
        if (!hasAccess()) {
            pgHide = true;
        }
        gU.checkNav();
    }
    private Boolean hasAccess() {
        Boolean blOk = gU.canReqSrvc(rq.srvc__c, true, 'grqpy');
        if (!blOk) {
            gU.addInfoMsg(Label.msgNoPrivilege);
        }
        if (rq.STA__c != 'Open' && rq.STA__c != 'Under Review' && rq.STA__c != 'In Process') {
            gu.addInfoMsg('Request is ' + rq.STA__c);
            blOk = false;
        } /* if(Is.size()<=0 || rq.AT__c <=0){gU.addInfoMsg(Label.msgNoAmount);blOk=false;}*/
        if (rq.Items__r == null) {
            gU.addInfoMsg('Missing required items');
            blOk = false;
        } else if (rq.Items__r.size() < 0) {
            gU.addInfoMsg(Label.msgNoItems);
            blOk = false;
        }
        if (nD) {
            gU.addInfoMsg(Label.msgNoDocuments);
            blOk = false;
        }
        if (pyMthds.size() <= 1) {
            gU.AddErrorMsg('Settings Error: Canot identify supported payment types');
            blOk = false;
        }
        return blOk;
    }




    public Boolean nD {
        get {
            if (rq.rDocs__r == null) {
                return false;
            }
            for (g_reqDoc__c d: rq.rDocs__r) {
                if (!d.upOk__c) {
                    return true;
                }
            }
            return false;
        }
    }

    //*** ------- DB Handlers --------------------------------------------------------------------------------  

    private Boolean crtPay(String STA, String mthd, String ref) {
        Savepoint sp = null;
        try {
            Integer cnt = 0;
            Decimal Amt2Pay = 0;
            for (itm i: Is) {
                if (i.s) {
                    cnt++;
                    Amt2Pay += i.I.AD__c;
                }
            }
            if (cnt == 0) {
                gU.AddWarningMsg(Label.msgNoItemSlct); /*/return false;*/
            }
            if (mthd == 'Credit / Debit Card') T.gwrf__c = ref;
            T.STA__c = STA;
            T.md__c = mthd;
            T.dt__c = Date.today();
            sp = Database.setSavepoint();
            if (mthd == 'Customer Deposit') {
                Account A = [select Id, adb__c, vato__c, va__c from Account where id =: T.Acc__c FOR UPDATE];
                if (A.adb__c < Amt2Pay) {
                    gU.AddWarningMsg(Label.msgNoADBlnc);
                    pyMthd = '';
                    loadData();
                    return false;
                }
            }
            list < g_TranItem__c > TIs = new list < g_TranItem__c > ();
            riIds = new Set < Id > ();
            upsert T;
            for (itm i: Is) {
                if (i.s) {
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
            if (TIs.size() > 0) {
                insert TIs;
            }
            if ((rq.STA__c == 'Open' || rq.STA__c == 'In Process') && STA == 'Completed') {
                rq.STA__c = 'Under Review';
                update rq;
            }
            T = [Select TP__c, RQ__r.name, VAT__c, dt__c, A__c, STA__c, nt__c, md__c, gwdt__c, gwmsg__c, gwrf__c, gwcd__c, Acc__r.adx__c, Acc__r.va__c, Acc__r.vato__c, Acc__r.bg__c, Acc__r.Name, Acc__r.BillingStreet, Acc__r.BillingPostalCode, Acc__r.lc__c, Name, Id, RQ__c, cq__c, cdt__c, ci__c, Bnk__c, Acc__c From g_Tran__c g where id =: T.Id];
            grqH.rH h = new grqH.rH(); /*/h.transItms=TIs;*/
            h.AP(rq, T, riIds);
            return true;
        } catch (exception ex) {
            if (sp != null) {
                Database.rollback(sp);
            }
            gU.AddErrorMsg(ex);
            return false;
        }
    }



    private Pagereference processPay() {
        try {
            if (rq.srvc__r.uid__c == gu.csStr('AdditionalParking')) {
                Map < String, String > response = new ParkingM().getAmntAP(Date.newInstance(rq.xaed__c.year(), rq.xaed__c.month(), rq.xaed__c.day()), rq.xanum__c);
                Decimal amnt = Math.round(Decimal.valueOf(response.get('amount')) * rq.xrap__c);
                if (response.get('errorCode') == '0' && !rq.xdapp__c && Math.round(rq.xtpa__c) != amnt) {
                    gU.addErrorMsg('There\'s change in price, please refresh the page for updated amount and try again.');
                    rq.xtpa__c = amnt;
                    update rq;
                    return null;
                } else if (response.get('errorCode') != '0') {
                    gU.addErrorMsg('Error while updating the price, please contact your administrator.');
                    return null;
                }
            }
            if (pyMthd == 'Customer Deposit' || pyMthd == 'Debit Memo' || (pyMthd == 'Cash' && (rq.srvc__r.uid__c == '205' || rq.srvc__r.uid__c == '204' || rq.srvc__r.uid__c == '206'))) {
                clrChqInfo(); /*/rcc*/
                List <g_reqitem__c> courBk = [SELECT Id, RQ__c, sta__c, xcub__c, sta__r.Courier_Stage__c, sta__r.next_status__r.Courier_Stage__c, sta__r.cd__c, Name, xcasc__c, exp__c from g_reqitem__c where (sta__r.Courier_Stage__c != null or sta__r.next_status__r.Courier_Stage__c != null) and id in: rq.Items__r order by createdDate desc limit 1];
                g_reqitem__c ri;
                for (g_reqitem__c i: courBk) {
                    if (i.sta__r.Courier_Stage__c == 'Collection' || i.sta__r.next_status__r.Courier_Stage__c == 'Collection' || i.sta__r.Courier_Stage__c == 'Delivery') {
                        ri = i;
                    }
                }
                XMLParserforEmpostWebservice cour = new XMLParserforEmpostWebservice();
                if (ri != null && (ri.sta__r.Courier_Stage__c == 'Collection' || ri.sta__r.Courier_Stage__c == 'Delivery' || ri.sta__r.next_status__r.Courier_Stage__c == 'Collection')) {
                    if (ri.sta__r.next_status__r.Courier_Stage__c == 'Collection') {
                        ri.sta__r.Courier_Stage__c = ri.sta__r.next_status__r.Courier_Stage__c;
                    }
                    cour.courierBooking(ri, rq, false, '');
                } /*/ added for correction component*/
                String rc = ApexPages.currentPage().getParameters().get('rc');
                List < g_reqitem__c > rqItmLst = new List < g_reqitem__c > ();
                if (rq.Items__r != null && rc != null && rc == 'y') {
                    String usrComments = ApexPages.currentPage().getParameters().get('c');
                    for (g_reqitem__c rii: rq.Items__r) {
                        if (rc == 'y' && rii.sta__r.Next_Status__c != null && rii.sta__r.staown__c == 'Customer') {
                            rii.sta__c = rii.sta__r.next_status__c;
                            rii.xcdocs__c = '';
                            rii.xcnotes__c = '';
                            rii.xr__c = '';
                            rqItmLst.add(rii);
                        }
                    }
                    update rqItmLst;
                    List < FeedItem > fdItmLst = new List < FeedItem > ();
                    FeedItem fd = null;
                    if (usrComments != null && usrComments != '') {
                        fd = createFeedItem(usrComments);
                        fdItmLst.add(fd);
                    }
                    rq.xcn__c = '';
                    rq.xcs__c = false;
                    update rq;
                    fd = createFeedItem(Label.msgCRFeed);
                    fdItmLst.add(fd);
                    insert fdItmLst;
                } /*/ end of cc*/
                if (crtPay('Completed', pyMthd, '')) {
                    gU.AddSuccessMsg('Payment has been processed successfully. Reference Number: ' + T.Name);
                    payDone = true;
                    pdfConfirm = 'apex/grqpyinfo?tid=' + T.Id;
                    return null;
                }
            } else if (pyMthd == 'Cash' || pyMthd == 'Bank Letter') {
                system.debug('processPay pyMthd >>>' + pyMthd);
                clrChqInfo();
                system.debug('2 T >>>' + T);
                if (crtPay('Open', pyMthd, '')) {
                    gU.AddSuccessMsg('Transaction has been registered successfully. Reference Number: ' + T.Name + '. Once we receive the payment, the transaction will be completed automatically');
                    payDone = true;
                    pdfConfirm = 'apex/grqpyinfo?tid=' + T.Id;
                    system.debug('pdfConfirm >>>' + pdfConfirm);
                    return null;
                }
            } else if (pyMthd == 'Wire Transfer' || pyMthd == 'Cheque') {
                system.debug('processPay pyMthd >>>' + pyMthd);
                if (crtPay('Open', pyMthd, '')) {
                    gU.AddSuccessMsg('Transaction has been registered successfully. Reference Number: ' + T.Name + '. Once we receive the payment, the transaction will be completed automatically');
                    payDone = true;
                    pdfConfirm = 'apex/grqpyinfo?tid=' + T.Id;
                    return null;
                }
            } else if (pyMthd == 'Credit / Debit Card') {
                system.debug('processPay pyMthd >>>' + pyMthd);
                clrChqInfo();
                system.debug(T.A__c);
                system.debug(T.Id);
                if (crtPay('Open', pyMthd, referenceNo)) {
                    gU.AddInfoMsg('Transaction has been registered successfully. Reference Number: ' + T.Name + '. You will be redirected to the Payment Gateway to process your payment');
                    system.debug('nefore prepare cal;#####################################');
                    gU.DEG_PrepareCall(T.A__c, T.Id);
                    system.debug('After prepare call#####################################');
                    payDone = true;
                    pdfConfirm = null;
                    return null;
                }
            } else {
                gU.AddWarningMsg(Label.msgNoPayMethod);
                payDone = false;
                pdfConfirm = null;
                return null;
            }
            System.debug('--PayDone-- : ' + Paydone);
            if (payDone) {}
        } catch (exception ex) {
            gU.AddErrorMsg(ex);
        }
        return null;
    }
    private void clrChqInfo() {
        T.cq__c = null;
        T.cdt__c = null;
        T.ci__c = null;
        T.Bnk__c = null;
        system.debug('T >>>' + T);
    }
    private FeedItem createFeedItem(String txt) {
        FeedItem fd = new FeedItem();
        fd.body = txt;
        fd.ParentId = rq.id;
        fd.Type = 'TextPost';
        fd.Visibility = 'AllUsers';
        return fd;
    }

    public PageReference save() {
        pagereference ref = null;
        Boolean cardPay = false;
        if (pyMthd == 'Credit / Debit Card') {
            cardPay = crtPayCard();
        }
        if (tcDate != null && tcDate != null != null) {
            system.debug('tcDate >>>' + tcDate);
            String[] strDate = tcDate.split('/');
            if (strDate.size() > 2) {
                Integer myIntDate = integer.valueOf(strDate[1]);
                Integer myIntMonth = integer.valueOf(strDate[0]);
                Integer myIntYear = integer.valueOf(strDate[2]);
                Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
                T.cdt__c = d;
                system.debug('T.cdt__c >>>' + T.cdt__c);
            }
        }
        saveReq();
        loadData();
        processPay();
        if (pyMthd == 'Credit / Debit Card' && cardPay) ref = new PageReference(paymentLink);
        else if (pyMthd != 'Credit / Debit Card') {
            /*/ref = new pagereference('/apex/grqtopup?id=' + rq.Id+'&cn=' + rq.srvc__r.uid__c+'&m=p');*/
            payDone = true;
            ref = new PageReference('/apex/grqpyinfo?tid=' + T.Id); /*/return null;*/
        } else {
            gU.addWarningMsg('PayLink Not Found');
            return null;
        }
        system.debug('ref>>>' + ref);
        ref.setRedirect(true);
        return ref; /*/new pagereference('/apex/grqpyBAL?id=' + rq.Id+'&cn=' + rq.srvc__r.uid__c);*/
    }

    public Boolean saveReq() {
        system.debug('rq.xtpa__c  >>>' + rq.xtpa__c);
        boolean isv = true;
        if (rq.srvc__r.uid__c == 'tbg') {
            Decimal BG = rq.Acc__r.bg__c == null ? 0 : rq.Acc__r.bg__c;
            if (System.Math.mod(rq.xtpa__c.longValue(), gU.csCurr('minBG').longValue()) != 0) {
                /*/r.addError(Label.msgBGMLTP);*/
                gU.addWarningMsg(Label.msgBGMLTP);
                isv = false;
            }
            if (rq.xtpa__c + BG > gU.csCurr('maxBG') && rq.sta__c != 'Cancelled' && rq.STA__c != 'Rejected') {
                gU.addWarningMsg(Label.msgBGOL.replaceAll('XX', (gU.csCurr('maxBG') - BG).format()));
                isv = false;
            }
        } /*//  if(isv){*/
        update rq;
        list < g_reqitem__c > tU = new list < g_reqitem__c > ();
        for (g_reqitem__c i: [select Id, RQ__c, scN__c from g_reqitem__c where isDeleted = false and RQ__c =: rq.id]) {
            i.scN__c = rq.xtpa__c;
            tU.add(i);
        }
        system.debug('tU >>>' + tU);
        if (tU.size() > 0) {
            update tU;
            system.debug('tU >>>' + tU);
        } /*/   }*/
        return true;
    }

    public void CnclPayment() {
        try {
            String aid = ApexPages.currentPage().getParameters().get('aid');
            if (aid == null) {
                gU.addWarningMsg(Label.msgPayNoCancel);
                return;
            }
            for (g_Tran__c tr: rq.Transactions__r) {
                if (aid == tr.ID && tr.STA__c == 'Open' && tr.md__c != 'Credit / Debit Card' && tr.TP__c == 'Payment') {
                    tr.STA__c = 'Cancelled';
                    update tr;
                    gU.AddSuccessMsg('Succenssfully cancelled transaction: ' + tr.Name);
                    return;
                }
            }
            gU.addWarningMsg(Label.msgPayNoCancel);
        } catch (exception ex) {
            gU.AddErrorMsg(ex);
        }
    }
    public pagereference authenticateUser() {
        String empid = ApexPages.currentPage().getParameters().get('empid');
        encid = ApexPages.currentPage().getParameters().get('enc');
        sid = ApexPages.currentPage().getParameters().get('sid');
        isgu = gu.isGuestUser(userInfo.getProfileId());
        pagereference pg = null;
        if (gu.isGuestUser(userInfo.getProfileId())) {
            System.debug('** Is Guest User');
            if (((empid == '' || empid == null || encid == '' || encid == null || !DEG_Checksum(empid, encid)) && !Test.isRunningTest())) {
                pg = new pagereference('/apex/AccesDeniedPage');
            }
        } else {
            return null;
        }
        return pg;
    }
    public static boolean DEG_Checksum(String msg, String encText) {
        String eCd = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', blob.valueOf('P@ssw0rdAXSHRMS' + msg))).toUpperCase();
        System.debug('** eCd:' + eCd);
        System.debug('** encText:' + encText);
        return eCd == encText;
    }
    //*** ------- Wrappers --------------------------------------------------------------------------------
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
    public class Trn {
        public g_Tran__c T {
            get;
            set;
        }
        public Trn(g_Tran__c trn) {
            T = trn;
        }
    }



    public String getCurrentUrl() {
        String BaseURL = ApexPages.currentPage().getHeaders().get('Host'); /*/pageReference cView = new ApexPages.StandardController(c).view();*/
        string fullURL = 'https://' + BaseURL;
        system.debug('fullURL >>> ' + fullURL);
        return fullURL;
    }

    public boolean crtPayCard() {
        String accessToken = '';
        PageReference ref = null;
        String niAPIKey = gU.csStr('NI-APIKEY');
        String niEndPoint = gU.csStr('NIENDPOINT');
        String niPayUrl = gU.csStr('NIPAYMENTURL');
        String returnURL = gU.csStr('RETURNURL');
        String email = UserInfo.getUserEmail();
        try {
            HttpRequest req = New HttpRequest(); /*req.setHeader('Content-Type', 'application/x-www-form-urlencoded;grant_type:client_credentials');17062025*/
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded'); /* // basic + API key will be chnagedin production*/
            req.setHeader('Authorization', 'Basic:' + niAPIKey);
            req.setMethod('POST');
            req.setBody('grant_type=client_credentials'); /*/ no change in end point move it to custom settings*/
            req.setEndpoint(niEndPoint);
            Http http = New Http();
            system.debug('Grant type header set');
            HTTPResponse res = http.send(req);
            system.debug('res' + res.getBody());
            String resStr = res.getBody();
            accessToken = getJsonResponse(resStr, 'AccessToken');
            
        } catch (Exception e) {}
        try {
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'application/vnd.ni-payment.v2+json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            req.setHeader('Accept', 'application/vnd.ni-payment.v2+json');
            req.setMethod('POST');
            Decimal amount = rq.xtpa__c * 100; /*/  Decimal amount = rq.AT__c*100;*/
            system.debug('json::{"action":"SALE","amount":{"currencyCode":"AED","value": ' + integer.valueOf(amount) + '},"language": "en","merchantAttributes":{"redirectUrl":"https://pgso-axs.cs31.force.com/grqpyc", grqtopup "skipConfirmationPage":true},"emailAddress":"srinivasa.varanasi@gmail.com"}');
            req.setBody('{"action":"SALE","amount":{"currencyCode":"AED","value": ' + integer.valueOf(amount) + '},"language": "en","merchantAttributes":{"redirectUrl":"' + getCurrentUrl() + '/apex/grqtop", "skipConfirmationPage":true} ,"emailAddress":"' + email + '"}'); /*/key will be chnage in production  outlet Ref#d0e91b8f-476d-4a4b-aae7-075755b0159a'); */
            req.setEndpoint(niPayUrl);
            Http http = New Http();
            system.debug('Grant type header set');
            HTTPResponse res = http.send(req);
            system.debug('res' + res.getBody());
            String resStr = res.getBody();
            paymentLink = getJsonResponse(resStr, 'PaymentLink');
            referenceNo = getJsonResponse(resStr, 'reference');
            system.debug('@@@@@@@@@@@@@@@@ Order Ref##############');
            system.debug('referenceNo::' + referenceNo);
            system.debug('@@@@@@@@@@@@@@@@ Order Ref##############');
            system.debug('link::' + paymentLink);
        } catch (Exception e) {}
        if (paymentLink != '') {
            /*//crtPay('Open','Credit / Debit Card',referenceNo); //ref = new PageReference(paymentLink); //ref.setRedirect(true);*/
            return true;
        }
        return false;
    }

    private string getJsonResponse(String jsonStr, String jsonType) {
        String res = '';
        try {
            /* //String accessToken = '{ "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIxMDhmNWQ4Yy03ZDU5LTQ3ZWUtYWJjNC03MzVlMjE0NjNhMGIiLCJleHAiOjE1NjEyOTQzNjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IkJlYXJlciIsImF6cCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjQ5YTU5YjdlLTY4MjctNDk5ZC05MWI4LTM3ZGUxY2VhNTllZSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIiwiY2xpZW50SWQiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJjbGllbnRIb3N0IjoiMTAxLjUzLjE2NC44IiwicmVhbG0iOiJuaSIsImdpdmVuX25hbWUiOiJFLUNvbSBBY2NvdW50IiwiY2xpZW50QWRkcmVzcyI6IjEwMS41My4xNjQuOCIsImhpZXJhcmNoeVJlZnMiOlsiMTE0NGRmZDktZjUyYS00NGQxLTkwN2QtY2NkM2Y4M2E2MjIyIl19.qA9epI6Nj4IqLBoWiq58SzE3FFmESTtA5ndsA-PuvvtaNcJPhZgLNKVJNnc2ejXuw8Tjb4t6gqAHfGgGFHjxVzqq1kyizFcj7dCxT2IDK2kHL6ziZ-TtmxuFs50N5qFpVcqgtv05QXzWnNbUf_NgHS_rM5F2nO8v9IeKSpmYhA_IQFOfhy1slraR2WJi7muk5Od3yW1FtLa9ldn3S92FscMWM-nS-MHBdq8y6vpTMz9f2Z4AwHCcAOp4jeydFS4S_PkhJDpEiKEdkKpU8FvYCEIQ9SoZsbG4eoBIYRz6NSSvQHjGkmYBA6wg5irZFVJpqubX1C1PPuHGV3NLJNNRQg", "expires_in": 300, "refresh_expires_in": 1800, "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIwZDRkMWQ5OC0xMjRiLTQ2NDUtODMzYi0wYzA1MjE1NjA5YjkiLCJleHAiOjE1NjEyOTU4NjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IlJlZnJlc2giLCJhenAiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI0OWE1OWI3ZS02ODI3LTQ5OWQtOTFiOC0zN2RlMWNlYTU5ZWUiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIn0.eIf5FjbWEE3OBwTJJA0cO96iI5Q1tflioCVhPMoA-xPPs90HGXQp9-CsBIG6PCXTYS6g3zD5hwP48CZ7kQXbyqHYRUzLfV3z3oJfJ95YhBCdcJh4DWBc11eAj2TmHmJ3Ih6zvHYkY4404rvWRAaiIKHFOtAf5sOt0R94nK_uu8MPSNbJJRqRSOnjgGzVI7AdC_nrn2joO4gN9DKu49eCcHH2lndXAW8e3fOeqxWSuNNlkHv1PXajy0v6veIFjjtlz2wRLdWoMU7VCM_kSZ7Qx-JQraqU0os6lefPgRAQUY225bQsR9ELGf8nTxpwRpkZDeE5wYmFwXPv-sS9xOU5aA", "token_type": "bearer", "not-before-policy": 0, "session_state": "49a59b7e-6827-499d-91b8-37de1cea59ee", "scope": "" }'; //String paymnetJson = '{ "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIxMDhmNWQ4Yy03ZDU5LTQ3ZWUtYWJjNC03MzVlMjE0NjNhMGIiLCJleHAiOjE1NjEyOTQzNjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IkJlYXJlciIsImF6cCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjQ5YTU5YjdlLTY4MjctNDk5ZC05MWI4LTM3ZGUxY2VhNTllZSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIiwiY2xpZW50SWQiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJjbGllbnRIb3N0IjoiMTAxLjUzLjE2NC44IiwicmVhbG0iOiJuaSIsImdpdmVuX25hbWUiOiJFLUNvbSBBY2NvdW50IiwiY2xpZW50QWRkcmVzcyI6IjEwMS41My4xNjQuOCIsImhpZXJhcmNoeVJlZnMiOlsiMTE0NGRmZDktZjUyYS00NGQxLTkwN2QtY2NkM2Y4M2E2MjIyIl19.qA9epI6Nj4IqLBoWiq58SzE3FFmESTtA5ndsA-PuvvtaNcJPhZgLNKVJNnc2ejXuw8Tjb4t6gqAHfGgGFHjxVzqq1kyizFcj7dCxT2IDK2kHL6ziZ-TtmxuFs50N5qFpVcqgtv05QXzWnNbUf_NgHS_rM5F2nO8v9IeKSpmYhA_IQFOfhy1slraR2WJi7muk5Od3yW1FtLa9ldn3S92FscMWM-nS-MHBdq8y6vpTMz9f2Z4AwHCcAOp4jeydFS4S_PkhJDpEiKEdkKpU8FvYCEIQ9SoZsbG4eoBIYRz6NSSvQHjGkmYBA6wg5irZFVJpqubX1C1PPuHGV3NLJNNRQg", "expires_in": 300, "refresh_expires_in": 1800, "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIwZDRkMWQ5OC0xMjRiLTQ2NDUtODMzYi0wYzA1MjE1NjA5YjkiLCJleHAiOjE1NjEyOTU4NjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IlJlZnJlc2giLCJhenAiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI0OWE1OWI3ZS02ODI3LTQ5OWQtOTFiOC0zN2RlMWNlYTU5ZWUiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIn0.eIf5FjbWEE3OBwTJJA0cO96iI5Q1tflioCVhPMoA-xPPs90HGXQp9-CsBIG6PCXTYS6g3zD5hwP48CZ7kQXbyqHYRUzLfV3z3oJfJ95YhBCdcJh4DWBc11eAj2TmHmJ3Ih6zvHYkY4404rvWRAaiIKHFOtAf5sOt0R94nK_uu8MPSNbJJRqRSOnjgGzVI7AdC_nrn2joO4gN9DKu49eCcHH2lndXAW8e3fOeqxWSuNNlkHv1PXajy0v6veIFjjtlz2wRLdWoMU7VCM_kSZ7Qx-JQraqU0os6lefPgRAQUY225bQsR9ELGf8nTxpwRpkZDeE5wYmFwXPv-sS9xOU5aA", "token_type": "bearer", "not-before-policy": 0, "session_state": "49a59b7e-6827-499d-91b8-37de1cea59ee", "scope": "" }'; */
            Map < String, Object > results = (Map < String, Object > ) JSON.deserializeUntyped(jsonStr);
            if (jsonType == 'AccessToken') res = (String) results.get('access_token');
            else if (jsonType == 'PaymentLink') {
                Map < string, Object > links = (Map < string, Object > ) results.get('_links');
                Map < string, Object > payment = (Map < string, Object > ) links.get('payment');
                res = (string) payment.get('href');
            } else if (jsonType == 'reference') {
                res = (String) results.get('reference');
            }
            system.debug('res::' + res);
        } catch (Exception ex) {
            system.debug('ex::' + ex.getStackTraceString());
        }
        return res;
    }


    public boolean prcssPayRef(String ref) {
        Set < Id > riIds = new Set < Id > ();
        if (ref == null || ref == '') {
            gU.AddErrorMsg(Label.msgNoTns);
            return false;
        }
        List < g_Tran__c > Ts = [Select Id, Name, STA__c, TP__c, A__c, md__c, gwrf__c, gwcd__c, gwdt__c, gwmsg__c, Acc__r.adx__c, Acc__r.bg__c, Acc__r.Name, Acc__r.BillingStreet, Acc__r.BillingPostalCode, Acc__r.lc__c, RQ__r.xaed__c, RQ__r.xanum__c, RQ__r.Full_Name__c, RQ__r.Acc__r.Name, RQ__r.xaloc__c, RQ__r.CreatedBy.Name, RQ__r.Zone__c, RQ__r.rmob__c, RQ__r.xbn__c, RQ__r.xbrnd__c, RQ__r.Id, RQ__c, RQ__r.xfpc__c, RQ__r.AP__c, RQ__r.xtpa__c, RQ__r.Name, RQ__r.STA__c, RQ__r.srvc__c, RQ__r.srvc__r.Name, RQ__r.srvc__r.uid__c, RQ__r.AOP__c, RQ__r.srvc__r.stg__r.apx__c, RQ__r.CreatedDate, RQ__r.xcs__c, RQ__r.xcn__c, (select id, A__c, exp__c, itm__c, itm__r.exp__c, itm__r.xcawb__c, itm__r.itm__r.Name, itm__r.itm__r.lbl__c, itm__r.sta__c, itm__r.sta__r.Courier_Stage__c, itm__r.sta__r.next_status__r.Courier_Stage__c, itm__r.sta__r.Next_Status__c, itm__r.sta__r.staown__c, itm__r.sta__r.cd__c, itm__r.xcasc__c, itm__r.xcub__c, itm__r.xcco__c from Items__r where isDeleted = false order by itm__r.itm__r.ord__c) from g_Tran__c where gwrf__c =: ref and isDeleted = false];
        system.debug('Ts::' + Ts);
        if (Ts.size() != 1) {
            gU.AddErrorMsg(Label.msgNoTns);
            return false;
        }
        T = Ts[0];
        system.debug('T >>>' + T);
        rqid = T.RQ__c; /*//rq=fetchRQ(rqid); //init();*/
        system.debug('T >>>' + T); /*//   if(T.md__c!='Credit / Debit Card'||T.STA__c!='Open'||T.TP__c!='Payment'|| T.gwcd__c!=null||T.gwdt__c!=null||T.gwmsg__c!=null){gU.AddErrorMsg(Label.msgNoTns);return false;} */
        PaymentRes res = getPaymentResponse(ref);
        system.debug('PaymentRes res >>>' + res);
        Boolean updFlag = false;
        if (res.MESSAGECODE == '00') {
            system.debug('pre T.STA__c >>> ' + T.STA__c);
            if (T.STA__c == 'Open') {
                T.STA__c = 'Completed';
                system.debug('T.STA__c >>> ' + T.STA__c);
                try {
                    g_reqitem__c ri;
                    g_reqitem__c riUpdate;
                    for (g_TranItem__c i: T.Items__r) {
                        i.STA__c = T.STA__c;
                        i.Tp__c = T.Tp__c;
                        riIds.add(i.itm__c);
                        if (i.itm__r.sta__r.Courier_Stage__c == 'Collection' || i.itm__r.sta__r.Courier_Stage__c == 'Delivery') {
                            ri = i.itm__r;
                        }
                        if (i.itm__r.sta__r.Next_Status__c != null && i.itm__r.sta__r.staown__c == 'Customer' && T.RQ__r.xcs__c) {
                            riUpdate = i.itm__r;
                        }
                    } /*/Correction Componnet*/
                    g_reqitem__c ricr = null;
                    if (riUpdate != null && riUpdate.sta__r.Next_Status__c != null && riUpdate.sta__r.staown__c == 'Customer' && T.RQ__r.xcs__c) {
                        riUpdate.sta__c = riUpdate.sta__r.next_status__c;
                        riUpdate.xcdocs__c = '';
                        riUpdate.xcnotes__c = '';
                        riUpdate.xr__c = '';
                        if (riUpdate.sta__r.next_status__r.Courier_Stage__c == 'Collection' || riUpdate.sta__r.next_status__r.Courier_Stage__c == 'Delivery') {
                            ricr = riUpdate;
                            ricr.sta__r.Courier_Stage__c = riUpdate.sta__r.next_status__r.Courier_Stage__c;
                            XMLParserforEmpostWebservice cr = new XMLParserforEmpostWebservice();
                            cr.courierBooking(ricr, T.RQ__r, false, Label.msgCourCol);
                        }
                        update riUpdate;
                        List < FeedItem > fdItmLst = new List < FeedItem > ();
                        if (T.RQ__r.xcs__c && T.RQ__r.xcn__c != null && T.RQ__r.xcn__c != '') {
                            FeedItem fd = new FeedItem();
                            fd.body = T.RQ__r.xcn__c;
                            fd.ParentId = T.RQ__r.id;
                            fd.Type = 'TextPost';
                            fd.Visibility = 'AllUsers';
                            fdItmLst.add(fd);
                            fd = new FeedItem();
                            fd.body = Label.msgCRFeed;
                            fd.ParentId = T.RQ__r.id;
                            fd.Type = 'TextPost';
                            fd.Visibility = 'AllUsers';
                            fdItmLst.add(fd);
                            insert fdItmLst;
                            T.RQ__r.xcn__c = '';
                            T.RQ__r.xcs__c = false;
                            update T.RQ__r;
                        }
                    }
                    Boolean isCour = false;
                    XMLParserforEmpostWebservice cour = new XMLParserforEmpostWebservice();
                    if (ri != null && (ri.sta__r.Courier_Stage__c == 'Collection' || ri.sta__r.Courier_Stage__c == 'Delivery') && !isCour) {
                        cour.courierBooking(ri, T.RQ__r, false, '');
                        isCour = false;
                        system.debug('creadit end');
                    }
                } catch (Exception e) {}
                updFlag = true;
            }
        } else {
            T.STA__c = 'Failed';
            gU.AddWarningMsg(Label.msgTrnFail);
            updFlag = true;
        } /*/T.gwrf__c=DEGTRN;*/
        if (updFlag) {
            T.gwcd__c = res.MESSAGECODE;
            T.gwdt__c = Datetime.now(); /*/parseDateDEG(TRANSDATE);*/
            T.gwmsg__c = res.MESSAGE; /*/T.md__c=PYMTMETHOD;*/
            system.debug('T >>> ' + T);
            system.debug('T.STA__c >>> ' + T.STA__c);
            system.debug('T.id >>> ' + T.id);
            update T;
            system.debug('T.STA__c >>> ' + T.STA__c);
            list < g_TranItem__c > itms = [select Id, STA__c, itm__c from g_TranItem__c where T__c =: T.Id and isDeleted = false];
            if (itms.size() > 0) {
                for (g_TranItem__c itm: itms) {
                    itm.STA__c = T.STA__c;
                    riIds.add(itm.itm__c);
                }
                update itms;
            }
            g_req__c rq = T.RQ__r;
            if (rq != null && rq.STA__c == 'Open' && res.MESSAGECODE == '0') {
                rq.STA__c = 'Under Review';
                update rq;
            }
            grqH.rH h = new grqH.rH();
            h.AP(T.RQ__r, T, riIds);
        }
        rq = fetchRQ(rqid);
        system.debug('Balance >>>' + rq.STA__c + ' >>> ' + rq.Acc__r.adb__c);
        return true;
    }

    public PaymentRes getPaymentResponse(String ref) {
        PaymentRes payres = new PaymentRes();
        String resStr = '';
        String niAPIKey = gU.csStr('NI-APIKEY');
        String niEndPoint = gU.csStr('NIENDPOINT');
        String niPayUrl = gU.csStr('NIPAYMENTURL');
        try {
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded'); /*// basic + API key will be chnagedin production*/
            req.setHeader('Authorization', 'Basic:' + niAPIKey);
            req.setMethod('POST');
            req.setBody('grant_type=client_credentials'); /*/ no change in end point move it to custom settings*/
            req.setEndpoint(niEndPoint);
            Http http = New Http();
            system.debug('Grant type header set');
            HTTPResponse res = http.send(req);
            system.debug('Response received, status: ' + res.getStatusCode());
            resStr = res.getBody();
            payres = getJsonResponse2(resStr, 'AccessToken');
        } catch (Exception e) {}
        try {
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'application/vnd.ni-payment.v2+json');
            req.setHeader('Authorization', 'Bearer ' + payres.accessToken);
            req.setMethod('GET'); /*/ b1d087ee-7cf8-40d3-ab56-9d543f139c83  IS order refrence number  to be saved in Transaction   with a  new field  Order ID  xctoid */
            req.setEndpoint(niPayUrl + '/' + ref);
            Http http = New Http();
            HTTPResponse res = http.send(req);
            system.debug('res#################' + res.getBody());
            resStr = res.getBody();
            payres = getJsonResponse2(resStr, 'authResponse');
        } catch (Exception e) {}
        return payres;
    }

    //private PaymentRes getJsonResponse2(String jsonStr, String jsonType) { PaymentRes res = new PaymentRes(); try { /*String accessToken = '{ "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIxMDhmNWQ4Yy03ZDU5LTQ3ZWUtYWJjNC03MzVlMjE0NjNhMGIiLCJleHAiOjE1NjEyOTQzNjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IkJlYXJlciIsImF6cCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjQ5YTU5YjdlLTY4MjctNDk5ZC05MWI4LTM3ZGUxY2VhNTllZSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIiwiY2xpZW50SWQiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJjbGllbnRIb3N0IjoiMTAxLjUzLjE2NC44IiwicmVhbG0iOiJuaSIsImdpdmVuX25hbWUiOiJFLUNvbSBBY2NvdW50IiwiY2xpZW50QWRkcmVzcyI6IjEwMS41My4xNjQuOCIsImhpZXJhcmNoeVJlZnMiOlsiMTE0NGRmZDktZjUyYS00NGQxLTkwN2QtY2NkM2Y4M2E2MjIyIl19.qA9epI6Nj4IqLBoWiq58SzE3FFmESTtA5ndsA-PuvvtaNcJPhZgLNKVJNnc2ejXuw8Tjb4t6gqAHfGgGFHjxVzqq1kyizFcj7dCxT2IDK2kHL6ziZ-TtmxuFs50N5qFpVcqgtv05QXzWnNbUf_NgHS_rM5F2nO8v9IeKSpmYhA_IQFOfhy1slraR2WJi7muk5Od3yW1FtLa9ldn3S92FscMWM-nS-MHBdq8y6vpTMz9f2Z4AwHCcAOp4jeydFS4S_PkhJDpEiKEdkKpU8FvYCEIQ9SoZsbG4eoBIYRz6NSSvQHjGkmYBA6wg5irZFVJpqubX1C1PPuHGV3NLJNNRQg", "expires_in": 300, "refresh_expires_in": 1800, "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIwZDRkMWQ5OC0xMjRiLTQ2NDUtODMzYi0wYzA1MjE1NjA5YjkiLCJleHAiOjE1NjEyOTU4NjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IlJlZnJlc2giLCJhenAiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI0OWE1OWI3ZS02ODI3LTQ5OWQtOTFiOC0zN2RlMWNlYTU5ZWUiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIn0.eIf5FjbWEE3OBwTJJA0cO96iI5Q1tflioCVhPMoA-xPPs90HGXQp9-CsBIG6PCXTYS6g3zD5hwP48CZ7kQXbyqHYRUzLfV3z3oJfJ95YhBCdcJh4DWBc11eAj2TmHmJ3Ih6zvHYkY4404rvWRAaiIKHFOtAf5sOt0R94nK_uu8MPSNbJJRqRSOnjgGzVI7AdC_nrn2joO4gN9DKu49eCcHH2lndXAW8e3fOeqxWSuNNlkHv1PXajy0v6veIFjjtlz2wRLdWoMU7VCM_kSZ7Qx-JQraqU0os6lefPgRAQUY225bQsR9ELGf8nTxpwRpkZDeE5wYmFwXPv-sS9xOU5aA", "token_type": "bearer", "not-before-policy": 0, "session_state": "49a59b7e-6827-499d-91b8-37de1cea59ee", "scope": "" }'; String paymnetJson = '{ "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIxMDhmNWQ4Yy03ZDU5LTQ3ZWUtYWJjNC03MzVlMjE0NjNhMGIiLCJleHAiOjE1NjEyOTQzNjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IkJlYXJlciIsImF6cCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjQ5YTU5YjdlLTY4MjctNDk5ZC05MWI4LTM3ZGUxY2VhNTllZSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIiwiY2xpZW50SWQiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJjbGllbnRIb3N0IjoiMTAxLjUzLjE2NC44IiwicmVhbG0iOiJuaSIsImdpdmVuX25hbWUiOiJFLUNvbSBBY2NvdW50IiwiY2xpZW50QWRkcmVzcyI6IjEwMS41My4xNjQuOCIsImhpZXJhcmNoeVJlZnMiOlsiMTE0NGRmZDktZjUyYS00NGQxLTkwN2QtY2NkM2Y4M2E2MjIyIl19.qA9epI6Nj4IqLBoWiq58SzE3FFmESTtA5ndsA-PuvvtaNcJPhZgLNKVJNnc2ejXuw8Tjb4t6gqAHfGgGFHjxVzqq1kyizFcj7dCxT2IDK2kHL6ziZ-TtmxuFs50N5qFpVcqgtv05QXzWnNbUf_NgHS_rM5F2nO8v9IeKSpmYhA_IQFOfhy1slraR2WJi7muk5Od3yW1FtLa9ldn3S92FscMWM-nS-MHBdq8y6vpTMz9f2Z4AwHCcAOp4jeydFS4S_PkhJDpEiKEdkKpU8FvYCEIQ9SoZsbG4eoBIYRz6NSSvQHjGkmYBA6wg5irZFVJpqubX1C1PPuHGV3NLJNNRQg", "expires_in": 300, "refresh_expires_in": 1800, "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIwZDRkMWQ5OC0xMjRiLTQ2NDUtODMzYi0wYzA1MjE1NjA5YjkiLCJleHAiOjE1NjEyOTU4NjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IlJlZnJlc2giLCJhenAiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI0OWE1OWI3ZS02ODI3LTQ5OWQtOTFiOC0zN2RlMWNlYTU5ZWUiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIn0.eIf5FjbWEE3OBwTJJA0cO96iI5Q1tflioCVhPMoA-xPPs90HGXQp9-CsBIG6PCXTYS6g3zD5hwP48CZ7kQXbyqHYRUzLfV3z3oJfJ95YhBCdcJh4DWBc11eAj2TmHmJ3Ih6zvHYkY4404rvWRAaiIKHFOtAf5sOt0R94nK_uu8MPSNbJJRqRSOnjgGzVI7AdC_nrn2joO4gN9DKu49eCcHH2lndXAW8e3fOeqxWSuNNlkHv1PXajy0v6veIFjjtlz2wRLdWoMU7VCM_kSZ7Qx-JQraqU0os6lefPgRAQUY225bQsR9ELGf8nTxpwRpkZDeE5wYmFwXPv-sS9xOU5aA", "token_type": "bearer", "not-before-policy": 0, "session_state": "49a59b7e-6827-499d-91b8-37de1cea59ee", "scope": "" }'; String jsonStr = '{ "_embedded": { "payment": [ { "_id": "urn:payment:1533d314-d988-4694-9663-63699430f31e", "_links": { "self": { "href": "https://api-gateway-uat.ngenius-payments.com/transactions/outlets/e209b88c-9fb6-4be8-ab4b-e4b977ad0e0d/orders/6c225eca-0843-415a-bb4b-5281e2c8706c/payments/1533d314-d988-4694-9663-63699430f31e" }, "curies": [ { "name": "cnp", "href": "https://api-gateway-uat.ngenius-payments.com/docs/rels/{rel}", "templated": true } ] }, "paymentMethod": { "expiry": "2020-12", "cardholderName": "Test", "name": "MASTERCARD", "pan": "510510******5100" }, "savedCard": { "maskedPan": "510510******5100", "expiry": "2020-12", "cardholderName": "Test", "scheme": "MASTERCARD", "cardToken": "dG9rZW5pemVkUGFuLy92MS8vU0hPV19OT05FLy94ejFlNXRpNWh6YWxwODFo", "recaptureCsc": true }, "state": "CAPTURED", "amount": { "currencyCode": "AED", "value": 100 }, "updateDateTime": "2019-06-24T12:23:07.598Z", "outletId": "e209b88c-9fb6-4be8-ab4b-e4b977ad0e0d", "orderReference": "6c225eca-0843-415a-bb4b-5281e2c8706c", "authResponse": { "authorizationCode": "657400", "success": true, "resultCode": "00", "resultMessage": "Successful approval/completion or that VIP PIN verification is valid" }, "_embedded": { "cnp:capture": [ { "_links": { "self": { "href": "https://api-gateway-uat.ngenius-payments.com/transactions/outlets/e209b88c-9fb6-4be8-ab4b-e4b977ad0e0d/orders/6c225eca-0843-415a-bb4b-5281e2c8706c/payments/1533d314-d988-4694-9663-63699430f31e/captures/c6c45c15-4ecb-4aa8-aced-8afc1ad0dd61" } }, "amount": { "currencyCode": "AED", "value": 100 }, "createdTime": "2019-06-24T12:23:07.598Z", "state": "SUCCESS" } ] } } ] } }*/ Map < String, Object > results = (Map < String, Object > ) JSON.deserializeUntyped(jsonStr); if (jsonType == 'AccessToken') res.accessToken = (String) results.get('access_token'); else if (jsonType == 'authResponse') { Map < string, Object > links = (Map < string, Object > ) results.get('_embedded'); List < Object > paymentLst = (List < Object > ) links.get('payment'); Map < string, Object > payment = (Map < string, Object > ) paymentLst[0]; String dtm = (String) payment.get('updateDateTime'); if (dtm != null) { dtm = dtm.replace('T', ' '); res.updateTime = Datetime.valueOf(dtm); } else { res.updateTime = Datetime.now(); } res.STATE = (String) payment.get('state'); if(String.isNotBlank(res.STATE) && res.STATE == 'CAPTURED'){ Map < string, Object > threeds = (Map < string, Object > ) payment.get('3ds'); res.THREEDS_STATUS = (String) threeds.get('status'); Map < string, Object > authResponse = (Map < string, Object > ) payment.get('authResponse'); res.AUTHCODE = (String) authResponse.get('authorizationCode'); res.MESSAGECODE = (String) authResponse.get('resultCode'); res.messageStatus = string.valueOf(authResponse.get('success')); res.MESSAGE = (String) authResponse.get('resultMessage');  system.debug('Authorization code received'); system.debug((String) authResponse.get('resultCode')); system.debug(string.valueOf(authResponse.get('success'))); system.debug((String) authResponse.get('resultMessage')); system.debug((String) payment.get('state'));  } } } catch (Exception ex) { system.debug('ex::' + ex.getStackTraceString()); } return res; }
    private PaymentRes getJsonResponse2(String jsonStr, String jsonType) {
        PaymentRes res = new PaymentRes();
        try {
            /*String accessToken = '{ "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIxMDhmNWQ4Yy03ZDU5LTQ3ZWUtYWJjNC03MzVlMjE0NjNhMGIiLCJleHAiOjE1NjEyOTQzNjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IkJlYXJlciIsImF6cCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjQ5YTU5YjdlLTY4MjctNDk5ZC05MWI4LTM3ZGUxY2VhNTllZSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIiwiY2xpZW50SWQiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJjbGllbnRIb3N0IjoiMTAxLjUzLjE2NC44IiwicmVhbG0iOiJuaSIsImdpdmVuX25hbWUiOiJFLUNvbSBBY2NvdW50IiwiY2xpZW50QWRkcmVzcyI6IjEwMS41My4xNjQuOCIsImhpZXJhcmNoeVJlZnMiOlsiMTE0NGRmZDktZjUyYS00NGQxLTkwN2QtY2NkM2Y4M2E2MjIyIl19.qA9epI6Nj4IqLBoWiq58SzE3FFmESTtA5ndsA-PuvvtaNcJPhZgLNKVJNnc2ejXuw8Tjb4t6gqAHfGgGFHjxVzqq1kyizFcj7dCxT2IDK2kHL6ziZ-TtmxuFs50N5qFpVcqgtv05QXzWnNbUf_NgHS_rM5F2nO8v9IeKSpmYhA_IQFOfhy1slraR2WJi7muk5Od3yW1FtLa9ldn3S92FscMWM-nS-MHBdq8y6vpTMz9f2Z4AwHCcAOp4jeydFS4S_PkhJDpEiKEdkKpU8FvYCEIQ9SoZsbG4eoBIYRz6NSSvQHjGkmYBA6wg5irZFVJpqubX1C1PPuHGV3NLJNNRQg", "expires_in": 300, "refresh_expires_in": 1800, "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIwZDRkMWQ5OC0xMjRiLTQ2NDUtODMzYi0wYzA1MjE1NjA5YjkiLCJleHAiOjE1NjEyOTU4NjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IlJlZnJlc2giLCJhenAiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI0OWE1OWI3ZS02ODI3LTQ5OWQtOTFiOC0zN2RlMWNlYTU5ZWUiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIn0.eIf5FjbWEE3OBwTJJA0cO96iI5Q1tflioCVhPMoA-xPPs90HGXQp9-CsBIG6PCXTYS6g3zD5hwP48CZ7kQXbyqHYRUzLfV3z3oJfJ95YhBCdcJh4DWBc11eAj2TmHmJ3Ih6zvHYkY4404rvWRAaiIKHFOtAf5sOt0R94nK_uu8MPSNbJJRqRSOnjgGzVI7AdC_nrn2joO4gN9DKu49eCcHH2lndXAW8e3fOeqxWSuNNlkHv1PXajy0v6veIFjjtlz2wRLdWoMU7VCM_kSZ7Qx-JQraqU0os6lefPgRAQUY225bQsR9ELGf8nTxpwRpkZDeE5wYmFwXPv-sS9xOU5aA", "token_type": "bearer", "not-before-policy": 0, "session_state": "49a59b7e-6827-499d-91b8-37de1cea59ee", "scope": "" }'; String paymnetJson = '{ "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIxMDhmNWQ4Yy03ZDU5LTQ3ZWUtYWJjNC03MzVlMjE0NjNhMGIiLCJleHAiOjE1NjEyOTQzNjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IkJlYXJlciIsImF6cCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjQ5YTU5YjdlLTY4MjctNDk5ZC05MWI4LTM3ZGUxY2VhNTllZSIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIiwiY2xpZW50SWQiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJjbGllbnRIb3N0IjoiMTAxLjUzLjE2NC44IiwicmVhbG0iOiJuaSIsImdpdmVuX25hbWUiOiJFLUNvbSBBY2NvdW50IiwiY2xpZW50QWRkcmVzcyI6IjEwMS41My4xNjQuOCIsImhpZXJhcmNoeVJlZnMiOlsiMTE0NGRmZDktZjUyYS00NGQxLTkwN2QtY2NkM2Y4M2E2MjIyIl19.qA9epI6Nj4IqLBoWiq58SzE3FFmESTtA5ndsA-PuvvtaNcJPhZgLNKVJNnc2ejXuw8Tjb4t6gqAHfGgGFHjxVzqq1kyizFcj7dCxT2IDK2kHL6ziZ-TtmxuFs50N5qFpVcqgtv05QXzWnNbUf_NgHS_rM5F2nO8v9IeKSpmYhA_IQFOfhy1slraR2WJi7muk5Od3yW1FtLa9ldn3S92FscMWM-nS-MHBdq8y6vpTMz9f2Z4AwHCcAOp4jeydFS4S_PkhJDpEiKEdkKpU8FvYCEIQ9SoZsbG4eoBIYRz6NSSvQHjGkmYBA6wg5irZFVJpqubX1C1PPuHGV3NLJNNRQg", "expires_in": 300, "refresh_expires_in": 1800, "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzOTVTT3NDdkZUY3NlRmpqNTNiZy1lbFBsUlJZci00OEUzWmN0eDloZnVRIn0.eyJqdGkiOiIwZDRkMWQ5OC0xMjRiLTQ2NDUtODMzYi0wYzA1MjE1NjA5YjkiLCJleHAiOjE1NjEyOTU4NjIsIm5iZiI6MCwiaWF0IjoxNTYxMjk0MDYyLCJpc3MiOiJodHRwczovL2lkZW50aXR5LXVhdC5uZ2VuaXVzLXBheW1lbnRzLmNvbS9hdXRoL3JlYWxtcy9uaSIsImF1ZCI6IjQ1ZTcxYzkwLWI5NWUtNGJhOC1iZWRjLTliNmI5YTEwYWJhNSIsInN1YiI6ImIyNmU1Y2Y2LTQwMGEtNGQyMi1iYTAzLTUzOGQxNjc5ODgzMiIsInR5cCI6IlJlZnJlc2giLCJhenAiOiI0NWU3MWM5MC1iOTVlLTRiYTgtYmVkYy05YjZiOWExMGFiYTUiLCJhdXRoX3RpbWUiOjAsInNlc3Npb25fc3RhdGUiOiI0OWE1OWI3ZS02ODI3LTQ5OWQtOTFiOC0zN2RlMWNlYTU5ZWUiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiQ1JFQVRFX0FVVEhPUklaQVRJT04iLCJWSUVXX01FUkNIQU5UX1JFUE9SVFMiLCJWSUVXX1BBWU1FTlQiLCJSRVZFUlNFX0FVVEhPUklaQVRJT04iLCJWSUVXX0FORF9ET1dOTE9BRF9PVVRMRVRfUkVQT1JUUyIsIk1BTkFHRV9DQVBUVVJFIiwiVklFV19PUkRFUiIsIk1FUkNIQU5UX1NZU1RFTVMiLCJDUkVBVEVfVkVSSUZJQ0FUSU9OIiwiQ1JFQVRFX09ORV9TVEFHRV9TQUxFIiwiVklFV19NRVJDSEFOVF9ISUVSQVJDSFkiLCJNQU5BR0VfTUVSQ0hBTlRfVklSVFVBTF9URVJNSU5BTCIsIkNSRUFURV9PUkRFUiIsIk1BTkFHRV9SRUZVTkQiXX0sInJlc291cmNlX2FjY2VzcyI6e30sInNjb3BlIjoiIn0.eIf5FjbWEE3OBwTJJA0cO96iI5Q1tflioCVhPMoA-xPPs90HGXQp9-CsBIG6PCXTYS6g3zD5hwP48CZ7kQXbyqHYRUzLfV3z3oJfJ95YhBCdcJh4DWBc11eAj2TmHmJ3Ih6zvHYkY4404rvWRAaiIKHFOtAf5sOt0R94nK_uu8MPSNbJJRqRSOnjgGzVI7AdC_nrn2joO4gN9DKu49eCcHH2lndXAW8e3fOeqxWSuNNlkHv1PXajy0v6veIFjjtlz2wRLdWoMU7VCM_kSZ7Qx-JQraqU0os6lefPgRAQUY225bQsR9ELGf8nTxpwRpkZDeE5wYmFwXPv-sS9xOU5aA", "token_type": "bearer", "not-before-policy": 0, "session_state": "49a59b7e-6827-499d-91b8-37de1cea59ee", "scope": "" }'; String jsonStr = '{ "_embedded": { "payment": [ { "_id": "urn:payment:1533d314-d988-4694-9663-63699430f31e", "_links": { "self": { "href": "https://api-gateway-uat.ngenius-payments.com/transactions/outlets/e209b88c-9fb6-4be8-ab4b-e4b977ad0e0d/orders/6c225eca-0843-415a-bb4b-5281e2c8706c/payments/1533d314-d988-4694-9663-63699430f31e" }, "curies": [ { "name": "cnp", "href": "https://api-gateway-uat.ngenius-payments.com/docs/rels/{rel}", "templated": true } ] }, "paymentMethod": { "expiry": "2020-12", "cardholderName": "Test", "name": "MASTERCARD", "pan": "510510******5100" }, "savedCard": { "maskedPan": "510510******5100", "expiry": "2020-12", "cardholderName": "Test", "scheme": "MASTERCARD", "cardToken": "dG9rZW5pemVkUGFuLy92MS8vU0hPV19OT05FLy94ejFlNXRpNWh6YWxwODFo", "recaptureCsc": true }, "state": "CAPTURED", "amount": { "currencyCode": "AED", "value": 100 }, "updateDateTime": "2019-06-24T12:23:07.598Z", "outletId": "e209b88c-9fb6-4be8-ab4b-e4b977ad0e0d", "orderReference": "6c225eca-0843-415a-bb4b-5281e2c8706c", "authResponse": { "authorizationCode": "657400", "success": true, "resultCode": "00", "resultMessage": "Successful approval/completion or that VIP PIN verification is valid" }, "_embedded": { "cnp:capture": [ { "_links": { "self": { "href": "https://api-gateway-uat.ngenius-payments.com/transactions/outlets/e209b88c-9fb6-4be8-ab4b-e4b977ad0e0d/orders/6c225eca-0843-415a-bb4b-5281e2c8706c/payments/1533d314-d988-4694-9663-63699430f31e/captures/c6c45c15-4ecb-4aa8-aced-8afc1ad0dd61" } }, "amount": { "currencyCode": "AED", "value": 100 }, "createdTime": "2019-06-24T12:23:07.598Z", "state": "SUCCESS" } ] } } ] } }*/
            Map < String, Object > results = (Map < String, Object > ) JSON.deserializeUntyped(jsonStr);
            if (jsonType == 'AccessToken') res.accessToken = (String) results.get('access_token');
            else if (jsonType == 'authResponse') {
                Map < string, Object > links = (Map < string, Object > ) results.get('_embedded');
                List < Object > paymentLst = (List < Object > ) links.get('payment');
                Map < string, Object > payment = (Map < string, Object > ) paymentLst[0];
                String dtm = (String) payment.get('updateDateTime');
                if (dtm != null) {
                    dtm = dtm.replace('T', ' ');
                    res.updateTime = Datetime.valueOf(dtm);
                } else {
                    res.updateTime = Datetime.now();
                }
                res.STATE = (String) payment.get('state');
                if (String.isNotBlank(res.STATE) && res.STATE == 'CAPTURED') {
                    /*Map < string, Object > threeds = (Map < string, Object > ) payment.get('3ds'); res.THREEDS_STATUS = (String) threeds.get('status');*/
                    if (payment.containsKey('3ds2')) {
                        Map < string, Object > threeds = (Map < string, Object > ) payment.get('3ds2');
                        String transStatus = (String) threeds.get('transStatus');
                        res.THREEDS_STATUS = (transStatus == 'C' || transStatus == 'Y') ? 'SUCCESS' : '';
                    } else {
                        Map < string, Object > threeds = (Map < string, Object > ) payment.get('3ds');
                        res.THREEDS_STATUS = (String) threeds.get('status');
                    }
                    Map < string, Object > authResponse = (Map < string, Object > ) payment.get('authResponse');
                    res.THREEDS_STATUS = 'SUCCESS';
                    res.AUTHCODE = (String) authResponse.get('authorizationCode');
                    res.MESSAGECODE = (String) authResponse.get('resultCode');
                    res.messageStatus = string.valueOf(authResponse.get('success'));
                    res.MESSAGE = (String) authResponse.get('resultMessage');
                    
                    system.debug('Authorization code received');
                    system.debug((String) authResponse.get('resultCode'));
                    system.debug(string.valueOf(authResponse.get('success')));
                    system.debug((String) authResponse.get('resultMessage'));
                    system.debug((String) payment.get('state'));
                    
                }
            }
        } catch (Exception ex) {
            system.debug('ex::' + ex.getStackTraceString());
        }
        return res;
    }


    public class msg {
        public String title {
            get;
            set;
        }
        public String cssCls {
            get;
            set;
        }
        public String detail {
            get;
            set;
        }
        public msg(String a, String b, String c) {
            this.title = a;
            this.cssCls = b;
            this.detail = c;
        }
    }
    public class PaymentRes {
        public string accessToken {
            set;
            get;
        }
        public string MESSAGECODE {
            set;
            get;
        }
        public string messageStatus {
            set;
            get;
        }
        public string MESSAGE {
            set;
            get;
        }
        public string AUTHCODE {
            set;
            get;
        }
        public Datetime updateTime {
            set;
            get;
        }
        public string STATE {
            set;
            get;
        }
        public string THREEDS_STATUS {
            set;
            get;
        }
    }
}