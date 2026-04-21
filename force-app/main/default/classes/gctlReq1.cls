public with sharing class gctlReq1 {
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
    public Boolean ispu {
        get;
        set;
    }
    public Boolean isgu {
        get;
        set;
    }
    public List < Contact > lc {
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
    public gu.pgMode md {
        get;
        set;
    }
    public String pt {
        get;
        set;
    }
    public String pDsc {
        get;
        set;
    }
    public String pg {
        get;
        set;
    }
    public Boolean pgHide {
        get;
        set;
    }
    public Boolean exstDpd {
        get;
        set;
    }
    public Boolean isSpActive {
        get;
        set;
    }
    public String spInsTp {
        get;
        set;
    }
    public Contact mngr {
        get;
        set;
    }
    public List < seg__c > allSeg {
        get;
        set;
    }
    public String pyMthd {
        get;
        set;
    }
    public gctlInsComp gctlInsComp {
        get;
        set;
    }
    /*//Insurance*/ public string grsPrem {
        get;
        set;
    }
    public string vatAmt {
        get;
        set;
    }
    public string fnlPrem {
        get;
        set;
    }
    public String insRqTp {
        get;
        set;
    }
    /*// addedBy SH */ public string lcl {
        get {
            return UserInfo.getLocale();
        }
    }
    public List < ParkingM.ParkingDetail > lst_pd {
        get;
        set;
    }
    public String cn {
        get;
        set;
    }
    public static String searchNum {
        get;
        set;
    }
    public Boolean st {
        get;
        set;
    }
    public Boolean isCon {
        get;
        set;
    }
    public List < SelectOption > locList {
        get;
        set;
    }
    public String selectedLoc {
        get;
        set;
    }
    public List < SelectOption > locList2 {
        get;
        set;
    }
    public String selectedLoc2 {
        get;
        set;
    }
    public List < seg__c > seg {
        get;
        set;
    }
    public Boolean segflag {
        get;
        set;
    }
    public Boolean locflag {
        get;
        set;
    }
    public Boolean incubflag {
        get;
        set;
    }
    public Boolean brnchincubflag {
        get;
        set;
    }
    public Boolean fzllcflag {
        get;
        set;
    }
    public transient String imageBase64 {
        get;
        set;
    }
    public String reqDocId {
        get;
        set;
    }
    public String docName {
        get;
        set;
    }
    public class lostDocWrap {
        public boolean selected {
            get;
            set;
        }
        public String nameOfDoc {
            get;
            set;
        }
        public Integer noOfDoc {
            get;
            set;
        }
        public lostDocWrap(String nameOfDoc, Integer noOfDoc, boolean selected) {
            this.nameOfDoc = nameOfDoc;
            this.noOfDoc = noOfDoc;
            if (selected == null) {
                this.selected = false;
            }
            else this.selected = selected;
        }
    }
    public list < lostDocWrap > tcopylist {
        get;
        set;
    }
    public gctlReq1() {
    }
    public gctlReq1(ApexPages.StandardController c) {
        rq = (g_Req__c) c.getRecord();
        system.debug('#####################3');
        /*system.debug(rq.Acc__c);
        */ system.debug('#####################3');
        st = true;
        mngr = new Contact();
        md = new gu.pgMode();
        segflag = false;
        locflag = false;
        incubflag = false;
        brnchincubflag = false;
        fzllcflag = false;
        tcopylist = new list < lostDocWrap > ();
        ispu = gu.isPortalUser(UserInfo.getProfileId());
        isgu = gu.isGuestUser(userInfo.getProfileId());
        pgHide = false;
        init();
        system.debug('Calling Adnic mail');
        /* if (rq.xcbd__c != null) {
            system.debug('Inside Adnic mail');
            if (Integer.valueOf(system.TODAY().YEAR()) - Integer.valueOf(rq.xcbd__c.YEAR()) >= 64) {
                system.debug('Called Adnic mail');
                sendAdnicEmail();
            }
        }
    */ }
    /** public void sendAdnicEmail() {
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        String [] sendto = new String[] {
        'jewindsilva@gmail.com'}
        ;
        mail.setToAddresses(sendto);
        mail.setReplyTo('jewindsilva@gmail.com');
        mail.setSubject('AXS');
        String body = 'Dear  ADNIC support, ';
        body += 'The requested user age is greater than 64 years';
        mail.setHtmlBody(body);
        // Messaging.sendEmail(mail);
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {
        mail}
        ;
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        }
        else {
            System.debug('The email failed to send: '+ results[0].errors[0].message);
        }
    }
    **/ /* //private void init() {
        try {
            if (rq.id == null) {
                md.setNew();
                loadData(true);
                validate(true);
            }
            else if (rq.id != null && rq.STA__c=='Open' && rq.AP__c == 0) {
                md.getPgParam();
                loadData(false);
                validate(true);
            }
            else {
                md.getPgParam();
                loadData(false);
                validate(false);
            }
        }
        catch (exception ex) {
            System.Debug('** Exception:'+ex);
            gu.AddErrorMsg(Label.msgException+'1');
            pgHide = true;
        }
    }
    */ private void init() {
        try {
            if (rq.id == null) {
                md.setNew();
                loadData(true);
                validate(true);
            }
            else {
                md.getPgParam();
                loadData(false);
                validate(true);
            }
        }
        catch (exception ex) {
            System.Debug('** Exception:' + ex.getStackTraceString());
            pgHide = true;
        }
    }
    public void dsgu() {
        rq.dsgu__c = true;
        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update rq;
        }
    }
    public pagereference authenticateUser() {
        empid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('empid'));
        encid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('enc'));
        isgu = gu.isGuestUser(userInfo.getProfileId());
        pagereference pg = null;
        if (gu.isGuestUser(userInfo.getProfileId())) {
            System.debug('** Is Guest User');
            if (((empid == '' || empid == null || encid == '' || encid == null || !DEG_Checksum(empid, encid))) && !Test.isRunningTest()) {
                pg = new pagereference('/apex/AccesDeniedPage');
            }
        }
        else {
            return null;
        }
        return pg;
    }
    public void loadDpdtSec() {
    }
    private void loadData(Boolean isnw) {
        system.debug('loadData:::::');
        try {
            sid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sid'));
            pid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('pid'));
            String rc = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('rc'));
            cn = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('cn'));
            if (rc != null) gu.AddInfoMsg(Label.msgCrcResp);
            if (isnw) {
                system.debug('sid:::' + sid);
                if (sid == null) {
                    gu.addWarningMsg(Label.msgInvReqPg);
                    pgHide = true;
                    return;
                }
                rq.srvc__c = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('sid'));
                system.debug('sid####' + sid);
                srv = [select id, xoi__c, uid__c, name, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c,
                    consta__c, sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c,
                    stg__r.reqq__c from g_Srvc__c where id =: rq.srvc__c limit 1];
                if (isgu) {
                    /* only if guest users */ List < Account > accs = [select id, Name, Phone, adb__c, bgb__c, bgnr__c, bg__c, lc__c, ORACLE_PARTY_ID__c, loc__c, Type, Prk__c, lcsnc__c, sncNt__c, lcsncnt__c, psasnc__c, psasncnt__c, ecsnc__c, ecsncnt__c, cosnc__c, cosncnt__c, bgsnc__c, bgsncnt__c, snc__c, info__c, vestd__c, vbtemp__c, vbvv__c, lcedt__c, vbtst__c, vvsfp__c from Account where id =: System.Label.TecomAccnt];
                    /* 0012000001DbKS9 */ if (accs != null && accs.size() > 0) {
                        rq.Acc__c = accs[0].id;
                        acc = accs[0];
                    }
                    empid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('empid'));
                    pid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('pid'));
                    encid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('enc'));
                    sid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sid'));
                    /*s isgu = gu.isGuestUser(userInfo.getProfileId()) ;
                    */ if ((isgu && empid == null) || !isgu) {
                    }
                    else if (pid != null && pid != '') {
                        lc = [select id, name, Photo_ID__c, rol__c, rp__c, rped__c from Contact where Id =: pid order by rped__c];
                        rq.Con__c = lc[0].id;
                    }
                    else if ((empid == '' || empid == null || !DEG_Checksum(empid, encid)) && isgu) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Access Denied.'));
                    }
                    else {
                        lc = [select id, name, Photo_ID__c, rol__c, rp__c, rped__c from Contact where Spon__r.idtxt__c =: empId order by rped__c];
                        rq.Con__c = lc[0].id;
                    }
                }
            }
            if (!isnw) {
                rq = (g_Req__c) Database.query(rq.srvc__r.stg__r.reqq__c + ' where id=\'' + rq.id + '\' and isDeleted = false');
                Acc = rq.acc__r;
                srv = rq.srvc__r;
                getAcc();
            }
            else {
                rq.conrol__c = srv.conrol__c;
                rq.consta__c = srv.consta__c;
                rq.sprrole__c = srv.sprrole__c;
                rq.sprsta__c = srv.sprsta__c;
                rq.STA__c = 'Draft';
            }
            system.debug('########isnw#############-' + isnw);
            system.debug('########ispu#############4' + ispu);
            system.debug('########isgu#############4' + isgu);
            if ((isnw && ispu) && !isgu) {
                system.debug('########UserInfo.getUserId()#############--' + UserInfo.getUserId());
                User usr = [select id, contact.account.mtc__c, contact.account.Name, contact.account.Email__c,
                    contact.account.Phone, MobilePhone, accountid, contact.account.id, contact.account.adb__c,
                    contact.account.xcuzn__c, contact.account.xcublg__c, contact.account.bgb__c, contact.account.bgnr__c,
                    contact.account.bg__c, contact.account.loc__c, contact.account.Type, contact.account.Prk__c,
                    contact.account.lcsnc__c, contact.account.lcsncnt__c, contact.account.lcedt__c, contact.account.psasnc__c,
                    contact.account.psasncnt__c, contact.account.ecsnc__c, contact.account.ecsncnt__c,
                    contact.account.cosnc__c, contact.account.cosncnt__c, contact.account.bgsnc__c, contact.account.bgsncnt__c,
                    contact.account.snc__c, contact.account.info__c, contact.account.vestd__c, contact.account.vbtemp__c,
                    contact.account.vbvv__c, contact.account.lc__c, contact.account.ORACLE_PARTY_ID__c,
                    contact.account.lcsta__c, contact.account.lctp__c, contact.account.vctemp__c, contact.account.vvsfp__c from User where id =: UserInfo.getUserId() limit 1];
                Acc = usr.contact.account;
                rq.acc__c = Acc.Id;
                rq.xaloc__c = acc.loc__c;
                if (String.isNotBlank(usr.MobilePhone)) {
                    String mph = usr.MobilePhone;
                    rq.rmob__c = mph.replaceAll('\\D', '').replaceFirst('971', '').replaceFirst('0', '');
                }
                system.debug('########rq.acc__c#############4');
                system.debug(rq.acc__c);
                system.debug(Acc.Id);
                system.debug('#####################4');
                rq.xbrnd__c = acc.xcuzn__c;
                rq.xbn__c = acc.xcublg__c;
                rq.xceml__c = usr.contact.account.Email__c;
                rq.xoln__c = usr.contact.account.Phone;
                getAcc();
                /*loadLocations();
            */ }
            pt = srv.lbl__c;
            pDsc = srv.dsc__c;
            pg = srv.stg__r.pg__c;
        }
        catch (exception ex) {
            gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString()+' ' + ex.getLineNumber());
            System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    }
    public static boolean DEG_Checksum(String msg, String encText) {
        String eCd = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', blob.valueOf('P@ssw0rdAXSHRMS' + msg))).toUpperCase();
        System.debug('** eCd:' + eCd);
        System.debug('** encText:' + encText);
        return eCd == encText;
    }
    private void getAcc() {
        Acc = [select id, Name, Legal_Framework__c, Phone, adb__c, bgb__c, bgnr__c, bg__c,
            lc__c, ORACLE_PARTY_ID__c, loc__c, Type, Prk__c, lcsnc__c, lcsncnt__c, psasnc__c,
            psasncnt__c, ecsnc__c, ecsncnt__c, cosnc__c, cosncnt__c, bgsnc__c, bgsncnt__c, snc__c,
            info__c, vestd__c, vbtemp__c, vbvv__c, lcedt__c, vbtst__c, vvsfp__c, (Select Id,
            acct__c, act__c, act_type__c, bus_unit__c, dcca_id__c, lic__c, or_prty__c, seg__c,
            sDate__c from aseg__r), (Select Id, Loc__c, agrno__c, acc__c, bu__c, IsMain__c, IsSub__c,
            ls_end__c, ls_std__c, active__c, rpi__c, Is_frzn__c from aloc__r where Is_frzn__c = true) from Account where id =: rq.Acc__c limit 1];
    }
    private void validate(Boolean isNew) {
        /* if (pg != gu.pageURL) {
            pgHide = true;
            gu.addWarningMsg(Label.msgInvReqPg);
        }
        */ /* if (isNew&&ispu&&hasSanctions) {
            pgHide=true;
        }
        if (!accesssOk) {
            pgHide=true;
        }
        gU.checkNav();
    }
    */ /*if (isNew&&ispu && hasSanctions) {
        pgHide=true;
    }
    if (!accesssOk) {
        pgHide=true;
    }
    gU.checkNav();
*/ }
/*Account Act and Seg  */ private Boolean hasSanctions {
    get {
        if (rq.Id == null) {
            grqH.rH h = new grqH.rH();
            return !h.BC(rq, srv, Acc);
        }
        else if (rq.Id != null) {
            grqH.rH h = new grqH.rH();
            return !h.AC(rq, srv, Acc);
        }
        return false;
    }
}
private Boolean accesssOk {
    get {
        Boolean acsOk = gu.canReqSrvc(rq.srvc__c, false, null);
        if (!acsOk) {
            if (md.isNew) {
                gu.addWarningMsg(Label.msgNoPrivilege);
            }
            else {
                md.setView();
                gu.addInfoMsg(Label.msgReadOnly);
            }
        }
        return acsOk;
    }
}
private void upsertR(String sta) {
    rq.STA__c = sta;
    if (Schema.sObjectType.g_req__c.isCreateable()) {
        upsert rq;
    }
}
public PageReference saveDraft() {
    system.debug('##########saveDraft#########################');
    system.debug(rq.STA__c);
    system.debug(rq.Acc__c);
    system.debug('#############saveDraft######################');
    String oldSTA = rq.STA__c;
    try {
        upsertR('Draft');
        return (new ApexPages.StandardController(rq)).edit();
        /* // String nxtPage = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('nextPage'));
        //if (nxtPage != null && nxtPage == 'grqins') {
            rq = (g_Req__c)Database.query(rq.srvc__r.stg__r.reqq__c + ' where id=\'' + rq.id + '\' and isDeleted = false');
            return null;
        }
        else return (new ApexPages.StandardController(rq)).edit();
    */ }
    catch (DMLException exDML) {
        for (Integer i = 0;
        i < exDML.getNumDml();
        i++) {
            if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                System.Debug('** Exception:' + exDML.getDmlMessage(i));
                gu.AddErrorMsg(Label.msgException + '3');
            }
        }
        return null;
    }
    catch (exception ex) {
        gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        rq.STA__c = oldSTA;
        return null;
    }
}
public PageReference saveOpen() {
    system.debug('test : saveOpen');
    system.debug('rq.id>>>' + rq.id);
    String oldSTA = rq.STA__c;
    /*fetchPreTransaction();
    */ try {
        if (md.isNew && !ispu) {
            getAcc();
        }
        /*if (hasSanctions) {
            return null;
        }
        */ system.debug('rq.id>>>' + rq.id);
        upsertR('Open');
        system.debug('rq.id>>>' + rq.id);
        if (fetchPreTransaction() == null) {
            system.debug('Inside::::');
            pagereference ref = new pagereference('');
            /*//pagereference ref = new pagereference('/apex/grqpy1?id=' + rq.Id+'&cn=' + srv.uid__c);
            //pagereference ref = new pagereference('/apex/grqpyNIC?id=' + rq.Id+'&cn=' + srv.uid__c);
            */ system.debug('srv.uid__c::::' + srv.uid__c);
            if (srv.uid__c == 'tad') ref = new pagereference('/apex/grqtop?id=' + rq.Id + '&cn=' + srv.uid__c);
            else ref = new pagereference('/apex/grqbgt?id=' + rq.Id + '&cn=' + srv.uid__c);
            ref.setRedirect(true);
            return ref;
        }
        return null;
    }
    catch (DMLException exDML) {
        for (Integer i = 0;
        i < exDML.getNumDml();
        i++) {
            if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                System.Debug('**DML Exception:' + exDML.getDmlMessage(i));
                if (ispu) {
                    gu.AddErrorMsg(Label.msgException);
                }
                else {
                    gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'DML Exception: ' + exDML.getStackTraceString());
                }
                /*gu.AddErrorMsg(Label.msgException+'4');
            */ }
        }
        return null;
    }
    catch (exception ex) {
        gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        rq.STA__c = oldSTA;
        return null;
    }
}
public List < g_Tran__c > fetchPreTransaction() {
    system.debug('rq.id>>>' + rq.id);
    list < g_Tran__c > rqtrans = database.query(Label.qryTrn + ' where RQ__c=\'' + rq.id + '\' and isDeleted=false LIMIT 999');
    system.debug('Query -- ' + Label.qryTrn + ' where RQ__c=\'' + rq.id + '\' and isDeleted=false LIMIT 999');
    system.debug('rqtrans>>>' + rqtrans);
    if (rqtrans != null && rqtrans.size() > 0) {
        return rqtrans;
    }
    else {
        return null;
    }
}
public PageReference save() {
    try {
        upsertR(rq.STA__c);
        return (new ApexPages.StandardController(rq)).view();
    }
    catch (DMLException exDML) {
        for (Integer i = 0;
        i < exDML.getNumDml();
        i++) {
            if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                System.Debug('** Exception:' + exDML.getDmlMessage(i));
                gu.AddErrorMsg(Label.msgException);
            }
        }
        return null;
    }
    catch (exception ex) {
        System.Debug('** Exception:' + ex);
        gu.AddErrorMsg(Label.msgException);
        return null;
    }
}
}