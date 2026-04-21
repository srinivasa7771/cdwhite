public with sharing class gctlUBO {
    public String sid{get;set;}
    public String pid{get;set;}
    public Boolean ispu{get;set;}
    public List<Attachment> attachdocs {get;set;}
    public g_Req__c rq{get;set;}
    public g_Srvc__c srv{get;set;}
    public Account Acc{get;set;}
    public gu.pgMode md{get;set;}
    public String pg{get;set;}
    public Boolean pgHide{get;set;}
    public transient  blob imageBase64 {get;set;}
    public String docName { get; set; }
    public transient  blob imageBase641 {get;set;}
    public String docName1 { get; set; }
    public String cn{get;set;}

    public gctlUBO(ApexPages.StandardController c) {
        rq=(g_Req__c)c.getRecord();
        attachdocs= new List<Attachment>();
        md = new gu.pgMode();
        ispu=gu.isPortalUser(UserInfo.getProfileId());
        init();
        attachdocs = [Select Id, Name, Body from Attachment where parentId=:rq.id];
    }

    private void init() {
        try {if (rq.id == null) { md.setNew(); loadData(true);}
             else {md.getPgParam();loadData(false); }
            } catch (exception ex) { System.Debug('** Exception:'+ex.getStackTraceString()); pgHide = true; }
    }

    private void loadData(Boolean isnw) {
        try{

            sid=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sid'));
            //pid=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('pid'));
            //s cn = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('cn'));
            if (isnw) {
                if (sid == null) {gu.addWarningMsg(Label.msgInvReqPg);pgHide=true;return;}
                rq.srvc__c = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('sid'));
                srv = [select id, uid__c, name, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c, consta__c,
                    sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c, stg__r.reqq__c from g_Srvc__c where id=: rq.srvc__c limit 1];
            }
            if (!isnw) {
                rq = (g_Req__c)Database.query(rq.srvc__r.stg__r.reqq__c + ' where id=\'' + rq.id + '\' and isDeleted = false');
                Acc = rq.acc__r;srv= rq.srvc__r;
                getAcc();
            }
            else{rq.conrol__c = srv.conrol__c;rq.consta__c = srv.consta__c;rq.sprrole__c = srv.sprrole__c;rq.sprsta__c = srv.sprsta__c;
                 rq.STA__c='Draft';}
            if ((isnw && ispu)) {
                User usr = [select id, contact.account.Name, contact.account.Email__c, contact.account.UBO_Flag__c,
                    contact.account.Is_UBO_required__c, contact.account.Phone, MobilePhone, accountid,
                    contact.account.id, contact.account.adb__c, contact.account.xcuzn__c, contact.account.xcublg__c,
                    contact.account.bgb__c, contact.account.bgnr__c, contact.account.bg__c, contact.account.loc__c,
                    contact.account.Type, contact.account.Prk__c, contact.account.lcsnc__c, contact.account.lcsncnt__c,
                    contact.account.lcedt__c, contact.account.psasnc__c, contact.account.psasncnt__c,
                    contact.account.ecsnc__c, contact.account.ecsncnt__c, contact.account.cosnc__c, contact.account.cosncnt__c,
                    contact.account.bgsnc__c, contact.account.bgsncnt__c, contact.account.snc__c, contact.account.info__c,
                    contact.account.vestd__c, contact.account.vbtemp__c, contact.account.vbvv__c, contact.account.lc__c,
                    contact.account.ORACLE_PARTY_ID__c, contact.account.lcsta__c, contact.account.lctp__c,
                    contact.account.vctemp__c from User where id=:UserInfo.getUserId() limit 1];
                //User usr = [select id, contact.account.Name, contact.account.Email__c, contact.account.Phone, MobilePhone, accountid, contact.account.id, contact.account.adb__c, contact.account.xcuzn__c, contact.account.xcublg__c, contact.account.bgb__c, contact.account.bgnr__c, contact.account.bg__c, contact.account.loc__c, contact.account.Type, contact.account.Prk__c, contact.account.lcsnc__c, contact.account.lcsncnt__c, contact.account.lcedt__c, contact.account.psasnc__c, contact.account.psasncnt__c, contact.account.ecsnc__c, contact.account.ecsncnt__c, contact.account.cosnc__c, contact.account.cosncnt__c, contact.account.bgsnc__c, contact.account.bgsncnt__c, contact.account.snc__c, contact.account.info__c, contact.account.vestd__c, contact.account.vbtemp__c, contact.account.vbvv__c, contact.account.lc__c, contact.account.ORACLE_PARTY_ID__c, contact.account.lcsta__c, contact.account.lctp__c, contact.account.vctemp__c from User where id='00520000003dROY' limit 1];
                Acc = usr.contact.account;rq.acc__c = Acc.Id;rq.xaloc__c = acc.loc__c;rq.rmob__c = usr.MobilePhone;
                rq.xbrnd__c =acc.xcuzn__c;rq.xbn__c =acc.xcublg__c;rq.xceml__c = usr.contact.account.Email__c; rq.xoln__c=usr.contact.account.Phone;
                getAcc();

            }
            pg=srv.stg__r.pg__c;

        } catch (exception ex) {gu.AddErrorMsg(Label.msgException); System.debug( 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString()+' ' + ex.getLineNumber() ); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());}
    }

    private void getAcc() {
        system.debug('rq.Acc__c'+ rq.Acc__c);
        Acc = [select id, UBO_Flag__c, Is_UBO_required__c, dedlic__c, lcsta__c, Name, Legal_Framework__c,
            lrd__c, onar__c, Phone, adb__c, bgb__c, bgnr__c, bg__c, lc__c, ORACLE_PARTY_ID__c,
            loc__c, Type, Prk__c, lcsnc__c, lcsncnt__c, psasnc__c, psasncnt__c, ecsnc__c, ecsncnt__c,
            cosnc__c, cosncnt__c, bgsnc__c, bgsncnt__c, snc__c, info__c, vestd__c, vbtemp__c,
            vbvv__c, lcedt__c, vbtst__c, (Select Id , acct__c, act__c, act_type__c, bus_unit__c,
            dcca_id__c, lic__c, or_prty__c, seg__c, sDate__c from aseg__r), (Select Id, Loc__c,
            agrno__c, acc__c, bu__c, IsMain__c, IsSub__c, ls_end__c, ls_std__c, active__c, rpi__c,
            Is_frzn__c from aloc__r where Is_frzn__c=true  ) from Account where id=: rq.Acc__c limit 1];
        system.debug('Acc' +Acc);
    }

    private void upsertR(String sta) {
        // try{
        rq.STA__c = sta;
        if (Schema.sObjectType.g_req__c.isCreateable()) {
            upsert rq;
        }

    }

    public PageReference uploadDocToRQ() {
        system.debug('acc id'+acc.id);
        upsertR('Under Review');
        List<Attachment> attchlst = new List<Attachment>();
        List<Attachment> attchlstacc = new List<Attachment>();
        List<String> attchids = new List<String>();
        if (imageBase64 != null && String.isNotBlank(docName)) {

            Attachment A = new Attachment(Body = imageBase64, Name = docName, ParentId = rq.id);
            Attachment A1 = new Attachment(Body = imageBase64, Name = docName, ParentId = rq.Acc__c);

            attchlst.add(A);
            attchlstacc.add(A1);
        }
        if (imageBase641 != null && String.isNotBlank(docName1)) {

            Attachment A1 = new Attachment(Body = imageBase641, Name = docName1, ParentId = rq.id);
            Attachment A2 = new Attachment(Body = imageBase641, Name = docName1, ParentId = rq.Acc__c);
            attchlst.add(A1);
            attchlstacc.add(A2);

        }

        system.debug('attchlst size'+attchlst.size());

        if (!attchlst.isEmpty()) {

            if (Schema.sObjectType.Attachment.isCreateable()) {
                insert attchlst;
            }

        }
        if (!attchlstacc.isEmpty()) {

            if (Schema.sObjectType.Attachment.isCreateable()) {
                insert attchlstacc;
            }

        }
        system.debug('attchlst'+attchlst);

        return new pagereference('/'+rq.id);
    }

    public PageReference delDocFromRQ() {
        List <Attachment> attToDel = [select id, name from Attachment where id in: (rq.Attachments)];
        if (Schema.sObjectType.Attachment.isDeletable()) {
            delete attTodel;
        }
        // delete attaccToDel;
        return new pagereference('/'+rq.id);
    }

    public PageReference completeReq() {
        upsertR('Completed');
        return new pagereference('/'+rq.id);
    }

}