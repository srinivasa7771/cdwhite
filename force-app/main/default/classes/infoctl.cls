public class infoctl {

    public String empid{get;set;}
    public String encid{get;set;}
    public String sid{get;set;}
    public String pid{get;set;}
    public Contact emp{get;set;}
    public Boolean isgu{get;set;}
    public List<Contact> lc{get;set;}
    public g_Req__c rq{get;set;}
    public g_Srvc__c srv{get;set;}
    public Account Acc{get;set;}
    public gu.pgMode md{get;set;}

    public String pg{get;set;}
    public Boolean pgHide{get;set;}

    private String m_SOQL; public Set<Id> riIds;
    public String pt{get;set;}public String pDsc{get;set;}public Boolean ispu{get;set;} /*public string lcl{get{return UserInfo.getLocale();}} */
    public g_Tran__c T{get;set;}public list<itm> Is{get;set;}private transient decimal AOP=0;
    public List<Selectoption> pyMthds {get;set;}    public String pyMthd{get;set;}public Boolean payDone{get;set;} public String pdfConfirm{get;set;} public Decimal vat{get;set;}

    public infoctl() {}
    public infoctl(ApexPages.StandardController c) {
        //rq=(g_Req__c)c.getRecord();
        if (String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'))!=null) {
                rq=[select id, srvc__r.stg__r.reqq__c, xdedln__c, srvc__c, Con__c, Acc__c from g_Req__c where id=:String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'))];
         }
        md = new gu.pgMode();
        ispu=gu.isPortalUser(UserInfo.getProfileId());
        isgu = gu.isGuestUser(userInfo.getProfileId());
       // mbrs=new list<mbr>();mbrCnt=0;pgHide = false;
        init();
    }

   private void init() {
       try {
           if (rq.id == null) {
               md.setNew();
               loadData(true);
           }
           else {
               md.getPgParam();
               loadData(false);
           }
       }
       catch (exception ex) {
           System.Debug('** Exception:'+ex);
           pgHide = true;
       }
   }
   public pagereference authenticate() {
       try{
           authenticateUser();
           dsgu();
           System.debug('**No Issue in authenticate..');
       }
       catch (Exception e) {
           System.debug('**Issue in authenticate..');
       }
       return null;
   }
   public void dsgu() {rq.dsgu__c = true; }
   public pagereference authenticateUser() {
       empid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('empid'));
       encid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('enc'));
       isgu = gu.isGuestUser(userInfo.getProfileId()) ;
       pagereference pg=null;
       if (gu.isGuestUser(userInfo.getProfileId())) {
           System.debug('** Is Guest User');
           if (String.isNotBlank(rq.xdedln__c)) {
               pg = null;
           }
           else if (((empid == '' || empid == null || encid == '' || encid == null   || !DEG_Checksum(empid, encid))) && !Test.isRunningTest()) {
               pg = new pagereference('/apex/AccesDeniedPage');
           }
           else {
               /*if (rq.AP__c == 0 && DEG_Checksum(empid, encid)) {
                   */ emp = [select id, name, rped__c, RP_Expiry_Status__c, sta__c from Contact where idtxt__c=:empid limit 1];
                   crtPay('Completed', 'Debit Memo');
               }
           }
           else{
               return null;
           }
           return pg;
       }
   @testvisible private void loadData(Boolean isnw) {
       sid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sid'));
       pid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('pid'));
       if (isnw) {
           gu.AddInfoMsg('Inside isnw');
           if (sid == null) {
               gu.addWarningMsg(Label.msgInvReqPg);
               pgHide = true;
               return;
           }
           rq.srvc__c = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('sid'));
           srv = [select id, uid__c, name, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c, consta__c,
               sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c, stg__r.reqq__c,
               stg__r.payq__c from g_Srvc__c where id =: rq.srvc__c limit 1];
           List < Account > accs = [select id, adb__c, bgb__c, bgnr__c, bg__c, lc__c, loc__c,
               Type, Prk__c, sncNt__c, lcsnc__c, lcsncnt__c, psasnc__c, psasncnt__c, ecsnc__c, ecsncnt__c,
               cosnc__c, cosncnt__c, bgsnc__c, bgsncnt__c, snc__c, info__c, vestd__c, vbtemp__c,
               vbvv__c, lcedt__c from Account where id =: System.Label.TecomAccnt];
           if (accs != null && accs.size() > 0) {
               rq.Acc__c = accs[0].id;
               acc = accs[0];
           }
           gu.AddInfoMsg('Inside 1');
           empid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('empid'));
           pid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('pid'));
           encid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('enc'));
           sid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sid'));
           gu.AddInfoMsg('Inside 2');
           if ((isgu && empid == null) || !isgu) {
           } else if (pid != null && pid != '') {
               lc = [select id, name, Photo_ID__c, rol__c, rp__c, rped__c from Contact where Id =: pid order by rped__c];
               rq.Con__c = lc[0].id;
           } else if ((empid == '' || empid == null || !DEG_Checksum(empid, encid)) && isgu) {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Access Denied.'));
           } else {
               lc = [select id, name, Photo_ID__c, rol__c, rp__c, rped__c from Contact where Spon__r.idtxt__c =: empId order by rped__c];
               rq.Con__c = lc[0].id;
           }
           gu.AddInfoMsg('Inside 3');
       }
       if (!isnw) {
           rq = (g_Req__c) Database.query('Select xcnc__c, Id, Name, xdedln__c, STA__c, AT__c, AP__c, AOP__c, dsc__c, dsc__r.prct__c, spCh__c, rmob__c, xaloc__c, xbrnd__c, xbn__c, nt__c, xfpc__c, srvc__c, srvc__r.name, srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.Prk__c, srvc__r.AccTp__c, srvc__r.ckgsnc__c, srvc__r.snc__c, srvc__r.stg__r.pg__c, srvc__r.stg__r.apx__c, srvc__r.stg__r.reqq__c, srvc__r.payMd__c, Acc__r.Name, Acc__r.lc__c, Acc__c, Acc__r.Type, Acc__r.bgrfi__c, Acc__r.adrfi__c, Acc__r.Prk__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c, Acc__r.psasncnt__c, Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c, Acc__r.bgsnc__c, Acc__r.bg__c, Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c, Acc__r.vestd__c, Acc__r.vbtemp__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, Acc__r.adb__c, Acc__r.bgb__c, Acc__r.bgnr__c, xtpa__c, srvc__r.uid__c, xltr__c, (Select Id, Name From reqMbrs__r where isDeleted=false), (Select Id, Name, mxAts__c, mnAts__c, ats__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, upOk__c, mbr__c, mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false), (Select Id, Name, STA__c, dt__c, A__c, md__c, TP__c From Transactions__r where isDeleted=false), (select id, Name, RQ__c, nc__c, rv__c, m__c, m__r.Name, vSTA__c, AP__c, AD__c, AOP__c, nt__c, xprnt__c, xr__c, Dsc__c, DscApp__c, KF__c, cN__c, scN__c, smN__c, exp__c, cXP__c, scXP__c, smXP__c, itm__c, itm__r.xf__c, itm__r.cd__c, itm__r.Name, itm__r.lbl__c, itm__r.Tp__c, itm__r.Req__c, itm__r.exp__c, itm__r.prcEdt__c, itm__r.dSTA__c, sta__c, sta__r.cd__c, sta__r.Name, sta__r.lbl__c, sta__r.Tp__c, sta__r.rc__c, sta__r.noEXP__c, sta__r.Courier_Stage__c, xcawb__c, xcnopro__c , xcub__c , xcco__c, xcasc__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, AV__c, su__c, vsu__c, TAX_CODE__c, extc__c, TAXCODE_SC__c, extcsc__c, vsc__c, vesch__c, vst__c, vec__c, ngs__c, ngsXP__c, tvatp__c, tgop__c, tngop__c, tgovp__c, tvngp__c From Items__r where IsDeleted=false order by itm__r.ord__c), Zone__c, Full_Name__c, CreatedBy.Name , xdrv__c, x30gr__c From g_Req__c where id=\'' +
               rq.id + '\' and isDeleted = false');
           Acc = rq.acc__r;
           srv = rq.srvc__r;
       } else {
           rq.conrol__c = srv.conrol__c;
           rq.consta__c = srv.consta__c;
           rq.sprrole__c = srv.sprrole__c;
           rq.sprsta__c = srv.sprsta__c;
           rq.STA__c = 'Draft';
       }
       if ((isnw && ispu) && !isgu) {
           User usr = [select id, MobilePhone, accountid, contact.account.id, contact.account.adb__c,
               contact.account.bgb__c, contact.account.bgnr__c, contact.account.bg__c, contact.account.loc__c,
               contact.account.Type, contact.account.Prk__c, contact.account.lcsnc__c, contact.account.lcsncnt__c,
               contact.account.lcedt__c, contact.account.psasnc__c, contact.account.psasncnt__c,
               contact.account.ecsnc__c, contact.account.ecsncnt__c, contact.account.cosnc__c, contact.account.cosncnt__c,
               contact.account.bgsnc__c, contact.account.bgsncnt__c, contact.account.snc__c, contact.account.info__c,
               contact.account.vestd__c, contact.account.vbtemp__c, contact.account.vbvv__c, contact.account.lc__c from User where id =: UserInfo.getUserId() limit 1];
           Acc = usr.contact.account;
           rq.acc__c = Acc.Id;
           rq.xaloc__c = acc.loc__c;
           rq.rmob__c = usr.MobilePhone;
       }
       gu.AddInfoMsg('Inside 4');
   }
   public static boolean DEG_Checksum(String msg, String encText) {
       String eCd = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', blob.valueOf('P@ssw0rdAXSHRMS'+msg))).toUpperCase();
       System.debug('** eCd:'+eCd);
       System.debug('** encText:'+encText);
       return eCd == encText;
   }
   @testvisible private void getAcc() {
       Acc = [select id, adb__c, bgb__c, bgnr__c, bg__c, lc__c, loc__c, Type, Prk__c, lcsnc__c,
           lcsncnt__c, psasnc__c, psasncnt__c, ecsnc__c, ecsncnt__c, cosnc__c, cosncnt__c, bgsnc__c,
           bgsncnt__c, snc__c, info__c, vestd__c, vbtemp__c, vbvv__c, lcedt__c from Account where id=: rq.Acc__c limit 1];
   }
   public class mbr{
       public g_reqMbr__c m{
           get;
           set;
       }
       public Boolean isnw{
           get{
               return m.Id == null;
           }
       }
       public mbr(g_reqMbr__c mvar) {
           m = mvar;
       }
       public void adjust(g_Req__c r) {
           m.RQ__c = r.Id;
           m.Name = (m.fnm__c == null?'':m.fnm__c) + (m.lnm__c == null?'':m.lnm__c);
       }
   }
   @testvisible private Boolean crtPay(String STA, String mthd) {
       Savepoint sp = null;
       try {
           Is = new list < itm > ();
           pyMthds = new List < Selectoption > ();
           AOP = 0;
           if (m_SOQL == null) {
               m_SOQL = 'Select  xltr__c, Id, Name, STA__c, AT__c, AP__c, AOP__c, dsc__c, dsc__r.prct__c, spCh__c, rmob__c, xcnc__c, xaloc__c, xbrnd__c, xbn__c, nt__c, xfpc__c, srvc__r.dis_req__c , srvc__c, srvc__r.name, srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.Prk__c, srvc__r.AccTp__c, srvc__r.ckgsnc__c, srvc__r.Category__c, srvc__r.snc__c, srvc__r.stg__r.pg__c, srvc__r.stg__r.apx__c, srvc__r.stg__r.reqq__c, srvc__r.payMd__c, Acc__r.Name, Acc__r.lc__c, Acc__c, Acc__r.Type, Acc__r.Prk__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c, Acc__r.psasncnt__c, Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c, Acc__r.bgsnc__c, Acc__r.bg__c, Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c, Acc__r.vestd__c, Acc__r.vbtemp__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, Acc__r.adb__c, Acc__r.bgb__c, Acc__r.bgnr__c, xtpa__c, srvc__r.uid__c, (Select Id, Name From reqMbrs__r where isDeleted=false), (Select Id, Name, mxAts__c, mnAts__c, ats__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, upOk__c, mbr__c, mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false), (Select Id, Name, STA__c, dt__c, A__c, md__c, TP__c From Transactions__r where isDeleted=false), (select id, Name, RQ__c, nc__c, rv__c, m__c, m__r.Name, vSTA__c, AP__c, AD__c, AOP__c, nt__c, xprnt__c, xr__c, Dsc__c, DscApp__c, KF__c, cN__c, scN__c, smN__c, exp__c, cXP__c, scXP__c, smXP__c, itm__c, itm__r.xf__c, itm__r.cd__c, itm__r.Name, itm__r.lbl__c, itm__r.Tp__c, itm__r.Req__c, itm__r.exp__c, itm__r.prcEdt__c, itm__r.dSTA__c, sta__c, sta__r.cd__c, sta__r.Name, sta__r.lbl__c, sta__r.Tp__c, sta__r.rc__c, sta__r.noEXP__c, sta__r.Courier_Stage__c, xcawb__c, xcnopro__c , xcub__c , xcco__c, xcasc__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, AV__c, su__c, vsu__c, TAX_CODE__c, extc__c, TAXCODE_SC__c, extcsc__c, vsc__c, vesch__c, vst__c, vec__c, ngs__c, ngsXP__c, tvatp__c, tgop__c, tngop__c, tgovp__c, tvngp__c From Items__r where IsDeleted=false order by itm__r.ord__c), Zone__c, Full_Name__c, CreatedBy.Name From g_Req__c';
           }
           rq = (g_Req__c) Database.query(m_SOQL + ' where id=\'' + rq.Id + '\' and isDeleted = false');
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
           T.md__c = mthd;
           T.dt__c = Date.today();
           sp = Database.setSavepoint();
           system.debug('rq.AP__c::' + rq.AP__c);
           list < g_TranItem__c > TIs = new list < g_TranItem__c > ();
           riIds = new Set < Id > ();
           if (rq.AP__c == 0) {
               upsert T;
           }
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
                           TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = govtFee,
                               VAT__c = 0, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c,
                               TAX_CODE__c = gu.csStr('TAXCodeEXEMPTED')));
                       }
                       if (govtVATFee > 0) {
                           TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = govtVATFee +
                               vatAmtGvt, VAT__c = vatAmtGvt, exp__c = i.I.exp__c, STA__c = T.STA__c,
                               Tp__c = T.Tp__c, TAX_CODE__c = ((taxCodeGov != null && taxCodeGov == 'EXEMPTED') ? gu.csStr('TAXCodeEXEMPTED') : taxCodeGov)));
                       }
                       if (nonGovtFee > 0) {
                           TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = nonGovtFee +
                               vatAmt, VAT__c = vatAmt, ngs__c = true, exp__c = i.I.exp__c,
                               STA__c = T.STA__c, Tp__c = T.Tp__c, TAX_CODE__c = ((taxCode != null && taxCode == 'EXEMPTED') ? gu.csStr('TAXCodeEXEMPTED') : taxCode)));
                       }
                   } else {
                       TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = i.I.AD__c,
                           VAT__c = 0, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c,
                           TAX_CODE__c = gu.csStr('TAXCodeEXEMPTED')));
                       if (mthd == 'Cash' && i.I.su__c != null && i.I.su__c > 0) TIs.add(new g_TranItem__c(itm__c = i.I.Id, T__c = T.Id, A__c = (i.I.su__c != null ? i.I.su__c : 0) +
                           (i.I.vsu__c != null ? i.I.vsu__c : 0), VAT__c = (i.I.vsu__c != null ? i.I.vsu__c : 0),
                               ngs__c = true, exp__c = i.I.exp__c, STA__c = T.STA__c, Tp__c = T.Tp__c,
                               TAX_CODE__c = i.I.TAX_CODE__c));
                   }
                   riIds.add(i.I.Id);
               }
           }
           if (TIs.size() > 0 && rq.AP__c == 0) {
               if (Schema.sObjectType.g_TranItem__c.isCreateable()) {
                   insert TIs;
               }
           }
           system.debug('rq.STA__c::' + rq.STA__c);
           if ((rq.STA__c == 'Open' || rq.STA__c == 'Draft' || rq.STA__c == 'In Process') && STA == 'Completed') {
               rq.STA__c = 'Under Review';
               if (Schema.sObjectType.g_req__c.isUpdateable()) {
                   update rq;
               }
               grqH.rH h = new grqH.rH();
               h.AP(T.RQ__r, T, riIds);
           }
           return true;
       } catch (exception ex) {
           if (sp != null) {
               Database.rollback(sp);
           }
           system.debug('crtPay Exception::' + ex.getStackTraceString());
           gU.AddErrorMsg(ex);
           return false;
       }
   }
   public class itm{public g_reqitem__c I{get;set;}public Boolean s{get;set;}public Boolean r{get;set;}public itm(g_reqitem__c itm) {I=itm;s=true;r = I.itm__r.Req__c;}}
}