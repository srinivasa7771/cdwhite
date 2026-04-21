public with sharing class gctlDv {
    public String empid{get;set;}
    public String encid{get;set;}
    public String pid{get;set;}
    public String sid{get;set;}
    public String err{get;set;}
    public List<Contact> lc{get;set;}
    public Contact emp{get;set;}
    public List<g_Req__c> rq{get;set;}
    public Map<Id, Contact> conMap;

    public gctlDv(ApexPages.StandardController c) {
        rq = new List<g_Req__c>();
    }

    public PageReference ckPrfl() {

        Boolean isgu = gU.isGuestUser(UserInfo.getProfileId());
        PageReference loginRes = null;

        empid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        encid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('enc'));

        if ((empid=='' || empid == null ||  !DEG_Checksum(empid, encid)) && !Test.isRunningTest()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Access Denied.11')); return null;
        }else{
            //auto login if guest user and not tecom internal user
            if (isgu && UserInfo.getUserName()!=System.Label.tecomIntUser) {
                loginRes =  Site.login(System.Label.tecomIntUser, 'password#1234', Apexpages.currentPage().getUrl());
            }
            return loginRes;
        }
    }

    public gctlDv() {
        try{
            System.debug('**pid:'+pid);
            empid= String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
            system.debug('**********'+empid);
            encid=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('enc'));
            conMap = new Map<Id, Contact> ();
            if ((empid=='' || empid == null ||  !DEG_Checksum(empid, encid)) && !Test.isRunningTest()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Access Denied.11'));
            }else{
                lc=[select id, name, Photo_ID__c, rol__c, rp__c, STA__c, rped__c,
                    xur__c, Gender__c from Contact where Spon__r.idtxt__c=:empid  or (idtxt__c=:empid and rol__c='Employee') order by rped__c];
                //
                emp = [select id, name, rped__c, RP_Expiry_Status__c, sta__C from Contact where idtxt__c=:empid limit 1];
                for (Contact con : lc) {
                    conMap.put(con.Id, con);
                }
                List<String> conIds = new List<String>();
                for (contact con : [select id, idtxt__c from contact where Spon__r.idtxt__c =: empid or (idtxt__c=:empid and rol__c='Employee')]) {
                    conIds.add(con.id);
                }
                if (conIds != null && conIds.size()>0)
                    //rq=[Select Name, ConRol__c, STA__c, Con__r.Name, Con__r.xur__c, Con__c, Con__r.rol__c, i_STA__c from g_Req__c where Con__r.id IN : conIds AND STA__c != 'Completed' AND Con__r.Account.Id='0012000001DbKS9'];
                    //rq=[Select Name, ConRol__c, STA__c, Con__r.Name, Con__r.xur__c, Con__c, Con__r.rol__c, i_STA__c from g_Req__c where Con__r.id IN : conIds AND Con__r.Account.Id='0012000001DbKS9'];
                    rq=[Select Name, ap__c, ConRol__c, STA__c, Con__r.Name, Con__r.xur__c, Con__c, Con__r.rol__c, i_STA__c from g_Req__c where Con__r.id IN : conIds];
            }
        }
        catch (Exception e) {
            System.debug('**Exception happened:'+e);
        }
    }
    public static boolean DEG_Checksum(String msg, String encText) {
        String eCd = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', blob.valueOf('P@ssw0rdAXSHRMS'+msg))).toUpperCase();
        System.debug('** eCd:'+eCd);    System.debug('** encText:'+encText);
        return eCd == encText;
    }
    public PageReference Renew() {
        System.debug('**pid:' + pid);
        PageReference redirect;
        g_Req__c rq = null;
        if (pid != null) {
            if (conMap.get(pid) != null) {
                Contact con = conMap.get(pid);
                system.debug('*****con.rol__c***' + con.rol__c);
                if (con.rol__c == 'Spouse') {
                    redirect = new PageReference('/apex/grdpri');
                    redirect.getParameters().put('sid', Label.SpouseSid);
                    /*rq = saveApplicantInfo(Label.SpouseSid, con.id);
                    */ if (rq != null) redirect.getParameters().put('id', rq.id);
                }
                else if (con.rol__c == 'Child') {
                    redirect = new PageReference('/apex/grqcdri');
                    redirect.getParameters().put('sid', Label.ChildSid);
                    /*rq = saveApplicantInfo(Label.ChildSid, con.id);
                    */ if (rq != null) redirect.getParameters().put('id', rq.id);
                }
                else if (con.rol__c == 'Employee') {
                    redirect = new PageReference('/apex/grqeri');
                    redirect.getParameters().put('sid', Label.EmpSid);
                    /*rq = saveApplicantInfo('a0L2000000YQVKZEA5', con.id);
                    */ if (rq != null) redirect.getParameters().put('id', rq.id);
                }
                else {
                    redirect = new PageReference('/apex/dv2');
                }
            }
        }
        /*if (rq == null) {
            redirect = new PageReference('/apex/dv');
            redirect.getParameters().put('id', empid);
            //ApexPages.currentPage().Message(new ApexPages.addMessage(ApexPages.Severity.Info, Label.msgException));
        }
        */ redirect.getParameters().put('empid', empid);
        redirect.getParameters().put('pid', pid);
        redirect.getParameters().put('enc', encid);
        redirect.setRedirect(true);
        if (rq != null) system.debug('rq id::' + rq.id);
        return redirect;
    }

     public g_Req__c saveApplicantInfo(String sid, String conId) {
         system.debug('invoke save applicant');
         Pagereference ref = null;
         g_Req__c rq = new g_Req__c();
         try {
             system.debug('applicant:'+conId);
             system.debug('srvc::'+sid);
             rq.srvc__c = sid;
             /*List<g_Req__c> reqList = [select id, Con__c, Con__r.nc__c, Con__r.p__c, Con__r.firstname, Con__r.middlename, Con__r.lastname, Con__r.mon__c, Con__r.fan__c, Con__r.Gender__c, Con__r.Birthdate, Con__r.bc__c, Con__r.Email, Con__r.fnar__c, Con__r.mnar__c, Con__r.lnar__c, Con__r.lng__c, Con__r.mona__c, Con__r.jb__c, Con__r.eidid__c, Con__r.eidedt__c, Con__r.ql__c, Con__r.ot__c, Con__r.fs__c, Con__r.of__c, Con__r.emrt__c, Con__r.cty__c, Con__r.strt__c, Con__r.area__c, Con__r.pobx__c, Con__r.pobxarea__c, Con__r.pic__c, Con__r.pip__c, Con__r.pid__c, Con__r.ped__c, Con__r.rlg__c, Con__r.ms__c, Con__r.bp__c, Con__r.bpa__c, Con__r.np__c, Con__r.Salutation from g_Req__c where srvc__r.uid__c='001' and Con__c=:rq.Con__c order by createddate desc limit 1];
             */ List<Contact> conLst = [select id, Accountid, id__c, nc__c,
                 p__c, Proc__c, RP_Expiry_Due__c, mn__c, Spon__c, snc__c, sp__c,
                 rp__c, rpid__c, rped__c, mbs__c, ma__c, mta__c, moa__c, ha__c,
                 rpui__c, HomePhone, firstname, middlename, lastname, MobilePhone,
                 mon__c, fan__c, Gender__c, Birthdate, bc__c, Email, fnar__c,
                 mnar__c, lnar__c, lng__c, mona__c, jb__c, eidid__c, eidedt__c,
                 ql__c, ot__c, fs__c, of__c, emrt__c, cty__c, strt__c, area__c,
                 pobx__c, pobxarea__c, pic__c, pip__c, pid__c, ped__c, rlg__c,
                 ms__c, bp__c, bpa__c, np__c, Salutation from Contact where id=:conId ];
             system.debug('contact mona__c::::::'+conLst[0].mona__c);
             if (conLst != null && !conLst.isEmpty()) {
                 rq.Con__c = conLst[0].id;
                 rq.Acc__c =  conLst[0].Accountid;
                 rq.xcnc__c = conLst[0].nc__c;
                 rq.xcp__c = conLst[0].p__c;
                 rq.xcfn__c =  conLst[0].firstname;
                 rq.xcln__c = conLst[0].lastname;
                 rq.xcmn__c = conLst[0].middlename;
                 rq.xcmn__c = conLst[0].mn__c;
                 rq.xcmon__c = conLst[0].mon__c;
                 rq.xcfan__c = conLst[0].fan__c;
                 rq.Gender__c = conLst[0].Gender__c;
                 rq.xcbd__c = conLst[0].Birthdate;
                 rq.xcbc__c =  conLst[0].bc__c;
                 rq.xceml__c =  conLst[0].Email;
                 rq.xcfnar__c = conLst[0].fnar__c;
                 rq.xcmnar__c =  conLst[0].mnar__c;
                 rq.xclnar__c =  conLst[0].lnar__c;
                 rq.xclng__c =  conLst[0].lng__c;
                 rq.xcmonar__c = conLst[0].mona__c;
                 rq.xcjb__c = conLst[0].jb__c;
                 rq.xceidid__c = conLst[0].eidid__c;
                 rq.xceidedt__c = conLst[0].eidedt__c;
                 rq.xcql__c = conLst[0].ql__c;
                 rq.xcfs__c = conLst[0].fs__c;
                 rq.xcot__c = conLst[0].ot__c;
                 rq.xcof__c  = conLst[0].of__c;
                 rq.xcemrt__c = conLst[0].emrt__c;
                 rq.xccty__c = conLst[0].cty__c;
                 rq.xcstrt__c = conLst[0].strt__c;
                 rq.xcarea__c = conLst[0].area__c;
                 rq.xcpobx__c =  conLst[0].pobx__c;
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
                 rq.xcmbs__c = conLst[0].mbs__c;
                 rq.xcma__c = conLst[0].ma__c;
                 rq.xcmta__c = conLst[0].mta__c;
                 rq.xcmoa__c = conLst[0].moa__c;
                 rq.xcha__c = conLst[0].ha__c;
                 rq.xchph__c = conLst[0].HomePhone;
                 rq.xcmob__c = conLst[0].MobilePhone;
                 rq.xrp__c = conLst[0].rp__c;
                 rq.xui__c=conLst[0].rpui__c;
                 rq.xrpid__c = conLst[0].rpid__c;
                 rq.xrped__c = conLst[0].rped__c;
                 rq.Spr__c = conLst[0].Spon__c;
                 rq.xcsnc__c = conLst[0].snc__c;
                 rq.xcsp__c = conLst[0].sp__c;
                 rq.xcid__c=conLst[0].id__c;
                 rq.STA__c='Draft';
                 if (Schema.sObjectType.g_Req__c.isCreateable()) {
                     upsert rq;
                 }
             }
             system.debug('req inserted...');
             return rq;
         }
         catch (DMLException exDML) {
             system.debug('DMLExceptionEEEEEE: ' + exDML);
             for (Integer i = 0;
             i < exDML.getNumDml();
             i++) {
                 if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) {
                     System.Debug('** Exception:' + exDML.getDmlMessage(i));
                     gu.AddErrorMsg(Label.msgException );
                 }
             }
             return null;
         }
         catch (exception ex) {
             gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
             return null;
         }
     }

}