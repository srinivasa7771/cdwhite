public class leCtlReq extends pgBsCtrl{
  public String empid{get;set;}
    public String encid{get;set;}
    public String sid{get;set;}
    public String pid{get;set;} public boolean sancflag{get;set;} public String sanc{get;set;}
    public Boolean ispu{get;set;}
    public Boolean isgu{get;set;} public List<Contact> lc{get;set;}
    public g_Req__c rq{get;set;}
    public g_Srvc__c srv{get;set;}
    public Account Acc{get;set;}
    public gu.pgMode md{get;set;}
    public String pt{get;set;}
    public String pDsc{get;set;}
    public String pg{get;set;}
    public Boolean pgHide{get;set;}
    public String tb {set;get;}
    public String docName { get; set; }
    public String extf { get; set; } /*MS 1.1*/
    public String userName {get;set;}
    public transient  String imageBase64 {get;set;}
    public Contact mngr{get;set;}
    public Case cs {get;set;} public List<Attachment> rqAtt {get;set;}
    public String attCoiId {get; set;}public String attMOAId {get; set;} public String attAOAId {get; set;}
    public String attGCId {get; set;} public String attNmId {get; set;}
    /*MS 1.1 Start*/
    public string trdStDate { get { String startdate = ''; If(rq.xceididt__c != null) { startdate = rq.xceididt__c.format(); } return startdate; } set { if (value != null && value != '') { rq.xceididt__c = date.parse(value); } } }
    public string trdEdDate { get { String enddate = ''; If(rq.xceidedt__c != null) { enddate = rq.xceidedt__c.format(); } return enddate; } set { if (value != null && value != '') { rq.xceidedt__c = date.parse(value); } } }
      public string taxRdNum { get { String taxNum; If(rq.acc__r.van__c != null) { taxNum = rq.acc__r.van__c; } return taxNum; } set { if (value != null) { rq.acc__r.van__c = value; } } }


    public list < Attachment > attMOAAmdId {get;set;}
    public String attBPId {get;set;}
    public String attCPId {get;set;}
    /* MS 1.1 End*/

    Static final string COI='Certificate of Incorporation';
    Static final string AOA='Articles of Association';
    Static final string CCN='Certificate of Company Name Change';
    Static final string FREELANCER='Freelancer Permit';
    Static final string COMM_LIC='Commercial License';
    Static final string CERT_BRANCH='Certificate of Branch Registration';

    public Map<Id,g_reqitem__c> reqItems;  public string lcl{get{return UserInfo.getLocale();}}
    public List<g_reqitemDoc__c> rqItemDocLst; public String commAddress {get;set;}

    public leCtlReq(){

        reqItems = new Map<Id,g_reqitem__c>();
        rqItemDocLst = new List<g_reqitemDoc__c>();
        commAddress=lcl; commAddress ='';
    }

    public leCtlReq(ApexPages.StandardController c){

        tb = '';
        rq=(g_Req__c)c.getRecord();
        system.debug('couct rq>>'+rq);

        mngr = new Contact();
        md = new gu.pgMode();

        ispu=gu.isPortalUser(UserInfo.getProfileId());
        isgu = gu.isGuestUser(userInfo.getProfileId());
        pgHide = false;

        init();
    }

    @TestVisible
    private void init() {
        try {
            if (rq.id == null) {
                md.setNew(); loadData(true);validate(true);
            } else{
                md.getPgParam();loadData(false);validate(true);
            }
        } catch (exception ex) {
            gu.AddErrorMsg('** Exception:'+ex.getStackTraceString());
            System.Debug('** Exception:'+ex.getMessage()+'  :: ' +ex.getStackTraceString());
            pgHide = true;
        }
    }



    public void dsgu(){rq.dsgu__c = true;update rq;}
    public pagereference authenticateUser(){ pagereference pg=null; String rid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id')); /*MS 1.1 Start*/ rq = [select Id, srvc__r.stg__r.reqq__c from g_req__c where  id =: rid];/* MKR - 30/10 */ rq = (g_Req__c)Database.query(rq.srvc__r.stg__r.reqq__c + ' where id=\'' + rq.id + '\' and isDeleted = false'); if (rq.xvtyp__c != 'DED' && rq.Acc__r.clt__c != 'Land'  && (rq.AP__c > 0 || rq.AOP__c > 0) || (rq.STA__c == 'Cancelled' || rq.STA__c == 'Rejected' || rq.STA__c == 'Completed')) { pg = new PageReference('/apex/grqStatus?id=' + rq.Id + '&m=' + md + '&rq.xvtyp__c=' + rq.xvtyp__c + '&rq.Acc__r.clt__c=' + rq.Acc__r.clt__c); } if ( rq.srvc__r.UID__c == '216' &&  rq.AP__c < 3000 && rq.xvtyp__c == 'DED' && rq.Acc__r.clt__c == 'Land' ) { /*pg = new PageReference('/apex/lerqob?id=' + rq.Id);*/ } /*MS 1.1 End*/ encid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('enc')); isgu = gu.isGuestUser(userInfo.getProfileId()) ; if (gu.isGuestUser(userInfo.getProfileId())){ System.debug('** Is Guest User'); if (((empid == '' || empid == null || encid == '' || encid == null   || !DEG_Checksum(empid,encid))) && !Test.isRunningTest()){ pg = new pagereference('/apex/AccesDeniedPage'); } } else{ loadData(false);return pg; } return pg; }
       private void loadData(Boolean isnw) {
               try {
                   sid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sid'));
                   pid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('pid'));
                   attMOAAmdId = new list < Attachment > (); /*MS 1.1*/
                   cs = new Case();
                   String rc = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('rc'));
                   if (rc != null) gu.AddInfoMsg(Label.msgCrcResp);
                   if (!isnw) {
                       System.debug('<loadData>rq.srvc__r.stg__r.reqq__c::' + rq.srvc__r.stg__r.reqq__c);
                       rq = (g_Req__c) Database.query(rq.srvc__r.stg__r.reqq__c + ' where id=\'' + rq.id + '\' and isDeleted = false');
                       Acc = rq.acc__r;
                       srv = rq.srvc__r; /*MS 1.1 starts*/
                       List < g_reqDoc__c > docLst = [select id, name, (select id, name from Attachments) from g_reqDoc__c where RQ__c =: rq.id and(name like '%Company Incorporation Certificate%'
                           or name like 'Franchise agreement%'
                           or name like 'NOC from parent company%'
                           or name like 'Article of association of parent company%'
                           or name like 'MoA or AoA of Parent Company%'
                           or name like 'MoA and AoA of Parent Company%'
                           or name like 'Certificate of Continuity or Existence or Good Standing%'
                           or name like 'Valid copy of trade license%'
                           or name like 'DED Name Reservation Certificate & Initial Approval Letter%'
                           or name like 'DED Commercial License Copy%'
                           or name like 'MoA or AoA Amendment of Company%'
                           or name like 'Business Plan%'
                           or name like 'Company Profile%') and ats__c > 0];
                       if (docLst != null && !docLst.isEmpty()) {
                           for (g_reqDoc__c doc: docLst) {
                               if (doc.attachments != null && !doc.attachments.isEmpty()) {
                                   if (doc.name.contains('MoA or AoA of Parent Company') || doc.name.contains('MoA and AoA of Parent Company')) {
                                       attMOAId = doc.attachments[0].id;
                                   } else if (doc.name == 'Article of association of parent company') {
                                       attAOAId = doc.attachments[0].id;
                                   } else if (doc.name.contains('Certificate of Continuity or Existence or Good Standing')) {
                                       attGCId = doc.attachments[0].id;
                                   } else if (doc.name == 'Franchise agreement' || doc.name == 'NOC from parent company') {
                                       attNmId = doc.attachments[0].id;
                                   } else if (doc.name.contains('MoA or AoA Amendment of Company')) {
                                       for (attachment objAttach: doc.attachments) {
                                           if (attMOAAmdId == null) attMOAAmdId = new list < Attachment > ();
                                           attMOAAmdId.add(objAttach);
                                       }
                                   } else if (doc.name.contains('Business Plan')) {
                                       attBPId = doc.attachments[0].id;
                                   } else if (doc.name.contains('Company Profile')) {
                                       attCPId = doc.attachments[0].id;
                                   } else {
                                       attCoiId = doc.attachments[0].id;
                                   }
                               }
                           }
                       } /*MS 1.1 ends*/
                       if (String.isNotBlank(rq.xadtx3__c)) {
                           grqWsOnboard.Records rec = (grqWsOnboard.Records) json.deserialize(rq.xadtx3__c, grqWsOnboard.Records.class);
                           userName = rec.usrName;
                       }
                       getAcc();
                       system.debug('Acc ::' + Acc.id);
                   }
                   system.debug('rq >>:' + rq);
                   pt = srv.lbl__c;
                   pDsc = srv.dsc__c;
                   pg = srv.stg__r.pg__c;
                   system.debug('os::' + rq.os__c);
                   if (String.isNotBlank(rq.os__c)) {
                       if (rq.xvtyp__c == 'DED' && rq.Acc__r.clt__c == 'Land') {
                           tb = (rq.os__c == 'Lead qualified') ? '' : ((rq.os__c == 'confpage') || (rq.os__c == 'Name Approval Re-Review' || rq.os__c == 'businessName')) ? 'businessName' : (rq.os__c == 'Segments Re-Review' || rq.os__c == 'segments') ? 'segments' : (rq.os__c == 'Submit to PRM' || rq.os__c == 'Provisional Approval Issuance') ? 'Submit to PRM' : (rq.os__c == 'Lease Info') ? 'Lease Info' : 'members';
                       } else {
                           tb = (rq.os__c == 'Lead qualified') ? '' : (rq.os__c == 'confpage') ? 'confpage' : (rq.os__c == 'Name Approval Re-Review' || rq.os__c == 'businessName') ? 'businessName' : (rq.os__c == 'Segments Re-Review' || rq.os__c == 'segments') ? 'segments' : (rq.os__c == 'Submit to PRM' || rq.os__c == 'Provisional Approval Issuance') ? 'Submit to PRM' : 'members';
                       } /*MS 1.1 ends */
                   }
               } catch (exception ex) {
                   System.debug('<loadData> Exception :: ' + ex.getMessage() + ' ex.getStackTraceString():: ' + ex.getStackTraceString());
                   gu.AddErrorMsg(Label.msgException);
                } 
                }       
    public static boolean DEG_Checksum(String msg, String encText) {
        String eCd = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', blob.valueOf('P@ssw0rdAXSHRMS'+msg))).toUpperCase();
        System.debug('** eCd:'+eCd);    System.debug('** encText:'+encText);
        return eCd == encText;
    }

    //private void getAcc(){Acc = [select id,ecedt__c,Name,Legal_Framework__c,Phone,adb__c,bgb__c,bgnr__c,bg__c,lc__c,ORACLE_PARTY_ID__c,loc__c,Type,Prk__c,lcsnc__c,lcsncnt__c,psasnc__c,psasncnt__c,ecsnc__c,ecsncnt__c,cosnc__c,cosncnt__c,bgsnc__c,bgsncnt__c,snc__c,info__c,vestd__c,vbtemp__c,vbvv__c,lcedt__c,vbtst__c,vvsfp__c,(Select Id ,acct__c,act__c,act_type__c,bus_unit__c,dcca_id__c,lic__c,or_prty__c,seg__c,sDate__c from aseg__r),(Select Id,Loc__c,agrno__c,acc__c,bu__c,IsMain__c,IsSub__c,ls_end__c,ls_std__c,active__c,rpi__c,Is_frzn__c from aloc__r where Is_frzn__c=true  ),session__c from Account where id=: rq.Acc__c limit 1];}
    private void getAcc(){
        if (rq.Acc__c != null){Acc = [select id,ad__c,billingAddress,billingStreet,billingCity,billingstate,billingPostalcode,SF_CRM_ID__c,ccrm_sfid__c,licexdt__c,ecedt__c,dedlic__c,lcsta__c,Name,Legal_Framework__c,lrd__c,onar__c,Phone,adb__c,bgb__c,bgnr__c,bg__c,lc__c,ORACLE_PARTY_ID__c,loc__c,Type,Prk__c,lcsnc__c,lcsncnt__c,psasnc__c,psasncnt__c,ecsnc__c,ecsncnt__c,cosnc__c,cosncnt__c,bgsnc__c,bgsncnt__c,snc__c,info__c,vestd__c,vbtemp__c,vbvv__c,lcedt__c,vbtst__c,vvsfp__c,(Select Id ,acct__c,act__c,act_type__c,bus_unit__c,dcca_id__c,lic__c,or_prty__c,seg__c,sDate__c from aseg__r),(Select Id,Loc__c,agrno__c,acc__c,bu__c,IsMain__c,IsSub__c,ls_end__c,ls_std__c,active__c,rpi__c,Is_frzn__c from aloc__r where Is_frzn__c=true  ),session__c from Account where id=: rq.Acc__c limit 1];}
    }



    private void validate(Boolean isNew){
        if (pg!=gu.pageURL){pgHide = true;gu.addWarningMsg(Label.msgInvReqPg);}
        if (isNew&&ispu&&hasSanctions){pgHide=true;}
        if (!accesssOk){pgHide=true;}

        gU.checkNav();
    }


    private Boolean hasSanctions{
        get{
           /* if (rq.Id==null && srv.uid__c!='208' ){
                grqH.rH h = new grqH.rH ();return !h.BC(rq,srv,Acc);
            }
            else if (rq.Id!=null && srv.uid__c!='208' ){
                grqH.rH h = new grqH.rH ();return !h.AC(rq,srv,Acc);
            }*/
            return false;
        }
    }


    private Boolean accesssOk{
        get{
            Boolean acsOk = gu.canReqSrvc(rq.srvc__c,false,null);
            if (!acsOk){if (md.isNew){gu.addWarningMsg(Label.msgNoPrivilege);}else {md.setView();gu.addInfoMsg(Label.msgReadOnly);}}
            return acsOk;
        }
    }

    private void upsertR(String sta) {
        rq.STA__c = sta;
        // system.debug('spouse name::' + rq.xspn__c);
        upsert rq;
        //update rq;

    }

    private Boolean cancelItms(){
        try{
            map<String,Id> mapSTA = new map<String,Id>();
            for (g_srvcitm_Status__c s: [select id,cd__c,itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__c=:rq.srvc__c and cd__c='c']){
                mapSTA.put(s.itm__r.cd__c, s.Id);
            }
            list<g_reqitem__c> items = [select Id, itm__r.cd__c,sta__c from g_reqitem__c where RQ__c=: rq.Id and isDeleted = false and sta__r.Tp__c='Open'];
            list<g_reqitem__c> toUpdate = new list<g_reqitem__c>();
            for (g_reqitem__c i: items){
                if (mapSTA.get(i.itm__r.cd__c)==null){gu.AddErrorMsg(Label.msgNFSTAC);return false;}
                i.sta__c = mapSTA.get(i.itm__r.cd__c);
                toUpdate.add(i);
            }
            if (toUpdate.size()>0){update toUpdate;}
        }catch (Exception e){gu.AddErrorMsg(e.getStackTraceString());return false;}
        return true;
    }

    public PageReference saveDraft(){system.debug('##########saveDraft#########################'); system.debug(rq.STA__c); system.debug(rq.Acc__c);String oldSTA = rq.STA__c;try{upsertR('Draft');if (isgu){ return (new pagereference('/apex/grqich?id=' + rq.Id+'&empid='+empid+'&enc='+encid+'&sid='+sid+'&pid='+pid));}else{return (new ApexPages.StandardController(rq)).edit();}}catch (DMLException exDML){for (Integer i = 0; i < exDML.getNumDml(); i++) {if ( exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION ){System.Debug('** Exception:'+exDML.getDmlMessage(i)); gu.AddErrorMsg(Label.msgException+'3');}}return null;}catch (exception ex){gu.AddErrorMsg(Label.msgException); rq.STA__c = oldSTA;return null;}}


    public PageReference saveOpen(){
        system.debug('##########saveOpen#########################');

        String oldSTA = rq.STA__c;
        try{
            if (md.isNew&&!ispu){getAcc();}
            /*  if (srv.uid__c=='216') upsertR('Under Review'); else upsertR('Open'); */
            upsertR('Open');
            loadData(false);
            String nxtPage = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('nextPage'));

            if (nxtPage!=null){ system.debug('nxtPage1::'+nxtPage);return (new pagereference('/apex/'+nxtPage+'?id=' + rq.Id+'&cn=' + srv.uid__c));}
            if (isgu) return (new pagereference('/apex/grqupmi?empid='+empid+'&enc='+encid+'&pid='+pid+'&sid='+sid+'&id=' + rq.Id));
            //else return(new pagereference('/apex/grqup?id=' + rq.Id));
            else return null;
        }catch (DMLException exDML){
            for (Integer i = 0; i < exDML.getNumDml(); i++) {
                if ( exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION ){
                    System.Debug('**DML Exception:'+exDML.getDmlMessage(i)); if (ispu){gu.AddErrorMsg(Label.msgException);}else{gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'DML Exception: ' + exDML.getStackTraceString());}//gu.AddErrorMsg(Label.msgException+'4');
                }
            }
            return null;
        }catch (exception ex){system.debug('ex::'+ex.getStackTraceString()); gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());rq.STA__c = oldSTA;return null;}
    }


    public PageReference save(){
        try{
            system.debug('##########save#########################');
            upsertR(rq.STA__c);
            return (new ApexPages.StandardController(rq)).view();

        }catch (DMLException exDML){
            for (Integer i = 0; i < exDML.getNumDml(); i++) {if ( exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION ){System.Debug('** Exception:'+exDML.getDmlMessage(i)); gu.AddErrorMsg(Label.msgException);}} return null;
        }catch (exception ex){System.Debug('** Exception:'+ex); gu.AddErrorMsg(Label.msgException); return null;}
    }


    public PageReference CancelR(){ if (ispu){ Savepoint sp = null;String oldSTA = rq.STA__c; try{ If((rq.STA__c!='Draft' && rq.STA__c!='Open') || rq.AP__c>0 || rq.AOP__c>0){gu.AddWarningMsg(Label.msgReqnoCancel);return null;} sp=Database.setSavePoint(); upsertR('Cancelled'); if (!cancelItms()){Database.rollback(sp);rq.STA__c = oldSTA;return null;} return (new ApexPages.StandardController(rq)).view(); } catch (DMLException exDML){if (sp!=null){Database.rollback(sp);}for (Integer i = 0; i < exDML.getNumDml(); i++) {if ( exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION ){System.Debug('** Exception:'+exDML.getDmlMessage(i)); gu.AddErrorMsg(Label.msgException);}}rq.STA__c= oldSTA;return null;}catch (exception ex){if (sp!=null){Database.rollback(sp);}gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());rq.STA__c = oldSTA;return null;} }else if (UserInfo.getProfileId()=='00e20000001Ajl3' || UserInfo.getProfileId()=='00e20000001Ajl3AAC' || UserInfo.getProfileId()=='00e20000001mIim' || UserInfo.getProfileId()=='00e20000001mIimAAE' || UserInfo.getProfileId()=='00e28000001sbAlAAI'){ /*add second id for M*/ if (rq.AOP__c>0){gu.AddErrorMsg('Request has open payments. Please close the payments before proceeding.');return null;} Savepoint sp = null;String oldSTA = rq.STA__c; try{ sp=Database.setSavePoint();upsertR('Cancelled'); if (rq.AP__c>0){if (!cancelItms()){Database.rollback(sp);rq.STA__c = oldSTA; return null;}}else{if (!cancelItms()){Database.rollback(sp);rq.STA__c = oldSTA;return null;}} return (new ApexPages.StandardController(rq)).view(); } catch (DMLException exDML){if (sp!=null){Database.rollback(sp);}for (Integer i = 0; i < exDML.getNumDml(); i++) {if ( exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION ){System.Debug('** Exception:'+exDML.getDmlMessage(i)); gu.AddErrorMsg(Label.msgException);}}rq.STA__c= oldSTA;return null;}catch (exception ex){if (sp!=null){Database.rollback(sp);}gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());rq.STA__c = oldSTA;return null;} }else{gu.AddErrorMsg('Invalid operation.'); return null;} }


    public void conInfo(){Contact con  = [select id,Salutation,ms__c from Contact where id=:rq.Con__c];rq.xcslt__c = con.Salutation;rq.xcms__c = con.ms__c;}


    public PageReference navigatePage(){
        String tbName = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('tbname'));
        system.debug('tb before::'+tbName);
        try{
            system.debug('rq.os__c. '+rq.os__c);

            tb = tbName;
             if (rq.xvtyp__c == 'DED' && rq.Acc__r.clt__c == 'Land' && tbName == 'confpage') { tb = 'businessName';} /*MS 1.1*/


            system.debug('tb after::'+tb+'status:'+rq.STA__c+'os:'+rq.os__c);

            /*MS 1.1 Start*/
            if (String.isBlank(rq.os__c) || rq.os__c == 'Lead qualified' || rq.os__c == 'businessName' || rq.os__c == 'parentCompName' || rq.os__c == 'segments' || rq.os__c == 'members' || rq.os__c == 'Application Payment' || rq.os__c == 'confpage' || rq.os__c == 'Lease Info')
            {
                //if (rq.os__c='Provisional Approval Issuance' &&rq.os__c!='Name Approval Re-Review' && rq.os__c!='Segments Re-Review' && rq.os__c!='Members Re-Review')
                saveTab(tb,rq.STA__c);
            }
            /*MS 1.1 Ends*/

        }catch (Exception e){
            system.debug('exception:'+e.getStackTraceString());
        }

        if (tb=='members' || tb=='segments'){return new PageReference('/lerqOb?id='+rq.id);}

        return null;
    }


    public PageReference updateRequest(){
        tb = 'members';

        system.debug('updateRequest::::');
        String segActJson = apexpages.currentpage().getparameters().get('segmentActivityJson');
        system.debug('segActJson:::'+segActJson);

        if (!String.isBlank(segActJson)){
            rq.xadtx2__c = segActJson;
            List <SegmentsActivitiesController.RequestJsonWrapper> reqSegList = (List<SegmentsActivitiesController.RequestJsonWrapper>)System.JSON.deserialize(segActJson,List<SegmentsActivitiesController.RequestJsonWrapper>.class);
            String docs='';
            rq.xcddocs__c ='';
            for (SegmentsActivitiesController.RequestJsonWrapper seg : reqSegList){
                for (SegmentsActivitiesController.SegActivities act :seg.SegActivities){
                    for (string docname : act.docs){ docs += docname + ';';}
                }
            }
            rq.xcddocs__c = docs.removeEnd(';');
        }
        try{
            rq.os__c = 'members';
            update rq;
            system.debug('xadtx2__c::::'+rq.xadtx2__c);
            system.debug('xcddocs__c::::'+rq.xcddocs__c);
            system.debug('xadh__c::::'+rq.xadh__c);
            system.debug('req::::'+rq);
        }catch (Exception ex){
            system.debug(ex.getMessage());
        }

        return null;
    }


    public PageReference saveCommAdd(){commAddress = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('commAddress'));acc.ad__c = commAddress;update acc;return null;}

    public void saveAttachment() {
        system.debug('save method called: ' +docName);
        try {
            system.debug('docName: ' + docName);
            system.debug('imageBase64: ' + imageBase64);
            Attachment A = new Attachment(Body = EncodingUtil.base64Decode(imageBase64), Name = docName, ParentId = rq.id);
            insert A;
            rq.xepAtt__c= A.Id;

        } catch (Exception e) { system.debug('ex::'+e.getMessage()+'  ex::'+e.getStackTraceString());gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString()); }
    }


    public void saveItemAttachment() {
        system.debug('save method called: ' +docName);
        try {
            system.debug('docName: ' + docName);
            system.debug('imageBase64: ' + imageBase64);
           // List<g_reqitemDoc__c>  docLst =[select id,name,reqDoc__c,Req__c,reqAts__c from g_reqitemDoc__c where name=:docName and reqItm__r.RQ__c=:rq.id];
            List<g_reqitemDoc__c>  docLst =Database.query('select id,name,reqDoc__c,Req__c,reqAts__c,reqItm__c from g_reqitemDoc__c where name like \'%' +docName.trim() +'%\' and reqItm__r.RQ__c=\''+rq.id +'\'');

            if (docLst != null && !docLst.isEmpty()){

                //List<Attachment> aa = [SELECT id, name from attachment where parentId=:rq.id and (name like '%Company Incorporation Certificate%' or name like 'Trade License Copy%' or name like 'DED Name Reservation Certificate & Initial Approval Letter%' or name like 'DED Commercial License Copy%') ];

                List<Attachment> aa = Database.query('SELECT id, name from attachment where parentId= \'' + docLst[0].reqDoc__c +'\' and (name like \'%' +docName.trim() +'%\')');
                system.debug('aa@@@@@@@@@@@@@@: ' + aa);

                if (aa!=null && aa.size()>0  && !aa[0].name.contains('MoA or AoA Amendment')  && (!aa[0].name.contains('MoA or AoA of Parent Company') || !aa[0].name.contains('MoA and AoA of Parent Company')))  /*MS 1.1*/{
                    attCoiId=aa[0].id;
                }else{
                    update rq;


                    if (String.isNotBlank(taxRdNum)){update new Account(Id = rq.acc__c, van__c = rq.acc__r.van__c);} /*MS 1.1*/

                    String extension = String.isNotBlank(extf) ? '.' + extf : '.pdf';
                    docName = grqWsOnboard.updateRqDocs(docLst[0].reqDoc__c);String filename = docName+extension;  Attachment A = new Attachment(Body = EncodingUtil.base64Decode(imageBase64), Name = filename, ParentId = docLst[0].reqDoc__c); insert A;

                    aa = [SELECT id, name from attachment where id=:A.id];
                    if (docName == 'Franchise agreement' || docName == 'NOC from parent company') { attNmId = aa[0].id; } /*MS 1.1 Start*/ else if (docName.contains('MoA or AoA of Parent Company')|| docName.contains('MoA and AoA of Parent Company')) { attMOAId = aa[0].id; } else if (docName.contains('MoA or AoA Amendment of Company')) { if (attMOAAmdId == null) attMOAAmdId = new list < Attachment > (); attMOAAmdId.add(aa[0]); } else if (docName.contains('Business Plan')) { attBPId = aa[0].id; } else if (docName.contains('Company Profile')) { attCPId = aa[0].id; } /*MS 1.1 END*/ else if (docName == 'Article of association of parent company') { attAOAId = aa[0].id; } else if (docName.contains('Certificate of Continuity or Existence or Good Standing')) { attGCId = aa[0].id; } else { attCoiId = aa[0].id; }
                    system.debug('attCoi:----- ' + attCoiId);
                }
            }

            //rq.xepAtt__c= A.Id;
        } catch (Exception e) {
            system.debug('ex::'+e.getStackTraceString());
            system.debug('ex::'+e.getMessage()); gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());
        }
    }


    public PageReference proceedToPay(){
        /*MS 1.1 Starts*/
        try{
            PageReference pg=null;
            update rq;
            system.debug('nD==='+nD);
            if (nD ){gU.AddWarningMsg(Label.msgMoreDocs);return null;  }else{pg= new PageReference('/grqpy?id='+rq.id);}
            system.debug('PageReference==='+pg);
            return pg;
        }
        catch (exception ex)
        {
            system.debug('getStacktraceString=='+ex.getStackTraceString());
            return null;
        }
        /*MS 1.1 Ends*/
    }

    public void saveCase(){
        try {
            cs.Accountid=Acc.id;
            cs.Request__c = rq.id;
            insert cs;
        } catch (Exception e) {
            system.debug('ex::'+e.getStackTraceString());

        }

    }


    public void saveTab(string tbName, String sts) {
        //businessName, segments,members, Submit to PRM

        if (String.isNotBlank(tbName)) {rq.os__c = tbName;}
        system.debug('rq.os__c:'+rq.os__c);
        if (sts  == 'Draft'){rq.STA__c = 'Open';}
        system.debug('rq.STA__c:'+rq.STA__c);

        if (tbName=='draftPage'){rq.os__c =''; rq.STA__c='Draft';}
        update rq;

         /*MS 1.1*/
        Account acc = new Account();
        acc.id = rq.acc__c;
        if (rq.xvtyp__c == 'DED' && rq.Acc__r.clt__c == 'Land' && rq.acc__r.van__c != null && tbName == 'Lease Info') {
            acc.van__c = rq.acc__r.van__c;
        }
        if (rq.xvtyp__c == 'DED' && rq.Acc__r.clt__c == 'Land' && rq.acc__r.van__c != null && tbName == 'Members') {
            acc.Description = rq.acc__r.Description;
        }

        if (acc.id != null) {
            update acc;
        }

    }

    /*
     * Desciption: Update lease info to Land onboarding
     * Created BY : Meenu MS 1.1
     */
    public PageReference updateLeaseInfo() {
        tb = 'segments';
        rq.os__c = 'segments';
        rq.STA__c = 'Open';
        /*list<g_reqDoc__c> lstDoc = [select id,name from g_reqDoc__c where name = 'Attested Power of Attorney' and RQ__c =: rq.Id];
        if (lstDoc != null && lstDoc.isEMpty())
        {
             rq.xcddocs__c = 'Attested Power of Attorney:dr' ;
        }*/
        update rq;
        return null;
    }

    public Address commadd = new Address();
    public class Address {
        public String street{get;set;}
        public String city{get;set;}
        public String emirates{get;set;}
        public String postCode{get;set;}
    }

    public String delDocID {get;set;}

    public void deleteDoc() { String doc_id = delDocID; List < Attachment > delAtt = [select id, name from attachment where id =: doc_id]; if (delAtt != null && delAtt.size() > 0) { delete delAtt[0]; /*if (delAtt[0].name.contains('Franchise agreement')){attNmId = '';}*/ if (delAtt[0].name.contains('Memorandum of association of parent company')) attMOAId = ''; else if (delAtt[0].name.contains('MoA or AoA of Parent Company')|| delAtt[0].name.contains('MoA and AoA of Parent Company')) /*MS 1.1*/ attMOAId = ''; else if (delAtt[0].name.contains('Article of association of parent company')) attAOAId = ''; else if (delAtt[0].name.contains('Good standing certificate')) attGCId = ''; else if (delAtt[0].name.contains('Franchise agreement') || delAtt[0].name.contains('NOC from parent company')) attNmId = ''; /*MS 1.1 Start*/ else if (delAtt[0].name.contains('MoA or AoA Amendment of Company')) { integer attIndex; for (integer i = 0; i < attMOAAmdId.size(); i++) { if (attMOAAmdId[i].Id == doc_id) { attIndex = i; } } if (attIndex != null) attMOAAmdId.remove(attIndex); } else if (delAtt[0].name.contains('Business Plan')) { attBPId = ''; } else if (delAtt[0].name.contains('Company Profile')) { attCPId = ''; } /*MS 1.1 End*/ else attCoiId = ''; } }

   public Boolean nD{ get{ List<g_reqDoc__c> rDoc = [Select Id,Name,mxAts__c,mnAts__c,ats__c,nt__c,or__c,reqAts__c,reqOr__c,tplt__c,upOk__c,mbr__c,mbr__r.Name From g_reqDoc__c where RQ__c =:rq.Id and  Req__c=true and IsDeleted=false]; for (g_reqDoc__c d: rDoc){ if (!d.upOk__c) {return true; } }return false; } }


    // SECURITY: Prevent open redirect (CWE-601)
    private static String sanitizeRedirectUrl(String url) {
        if (String.isBlank(url)) return '/';
        if (url.contains('://') || url.startsWith('//')) return '/';
        if (!url.startsWith('/')) url = '/' + url;
        return url;
    }

}