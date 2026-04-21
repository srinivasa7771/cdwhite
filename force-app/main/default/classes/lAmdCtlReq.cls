public with sharing class lAmdCtlReq {
    public String empid {get;set;}
    public String encid {get;set;}
    public String sid {get;set;}
    public String pid {get;set;}
    public boolean sancflag {get;set;}
    public String licpriceMap {get;set;}
    public Boolean ispu {get;set;}
    public Boolean isgu {get;set;}
    public g_Req__c rq {get;set;}
    public g_Req__c req {get;set;}
    public g_Srvc__c srv {get;set;}
    public Account Acc {get;set;}
    public String pt {get;set;}
    public String pDsc {get;set;}
    public String pg {get;set;}
    public Boolean pgHide {get;set;}
    public gu.pgMode md {get;set;}
    public List < PMSAmdDataWrapper.UnitInfo > pmsLeaseLst {get;set;}
    public boolean ejariLeaseFlg {get;set;}
    public Decimal ejariLeaseArea {get;set;}
    public lAmdCtlReq() {
    }
    public lAmdCtlReq(ApexPages.StandardController c) {
        rq = (g_Req__c) c.getRecord();
        system.debug('#####################3');
        system.debug('couct rq>>' + rq);
        system.debug('#####################3');
        system.debug('UserInfo.getProfileId()===='+UserInfo.getProfileId());
        Id strProfileId = UserInfo.getProfileId().substring(0,15);
        ispu = gu.isPortalUser(strProfileId);
        system.debug('ispu===='+ispu);
        isgu = gu.isGuestUser(strProfileId);
        md = new gu.pgMode();
        pmsLeaseLst = new List<PMSAmdDataWrapper.UnitInfo>();
        init();
        if (srv != null) {
        }
    }
    public void init() {
        try {
            if (rq == null || rq.id == null) {
                md.setNew();
                loadData(true);
                validate(true);
            } else {
                md.getPgParam();
                loadData(false);
                validate(true);
            }
        } catch (exception ex) {
            gu.AddErrorMsg('** Exception:' + ex.getStackTraceString());
            System.Debug('** Exception:' + ex.getStackTraceString());
            pgHide = true;
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
        } else {
            return null;
        }
        return pg;
    }
    public void loadData(Boolean isnw) {
        try {
            sid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sid'));
            system.debug('rq=='+rq);
            system.debug('sid=='+sid);
            if (isnw) {
                if (sid == null) {
                    gu.addWarningMsg(Label.msgInvReqPg);
                    pgHide = true;
                    return;
                }
                rq = new g_Req__c();
                rq.srvc__c = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sid'));
                system.debug('rq=1='+rq);
                srv = [select id, xoi__c, uid__c, name, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c, consta__c, sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c, stg__r.reqq__c,sdg__r.slbl__c,sdg__r.docslbl__c,sdg__r.sd__c from g_Srvc__c where id =: rq.srvc__c limit 1];
            }
            if (!isnw) {
                rq = [select Id, srvc__c, srvc__r.stg__c, srvc__r.stg__r.pg__c, srvc__r.stg__r.reqq__c, srvc__r.stg__r.bopg__c from g_Req__c where id =: rq.id]; /*/ Teporarily Added by JP*/
                system.debug('460 rq>>' + rq.srvc__c);
                rq = (g_Req__c) Database.query(rq.srvc__r.stg__r.reqq__c + ' where id=\'' + rq.id + '\' and isDeleted = false'); /* // exstDpd = false; // if (rq != null && rq.id!=null){ string dpdServiceName = Label.dpdSrvcNames;   if (dpdServiceName.contains(',')){   for (string s : dpdServiceName.split(',')){  exstDpd = rq.srvc__r.Name.contains(s.Trim())  ? rq.xard__c : false;  }   }else {exstDpd = rq.srvc__r.Name.contains(dpdServiceName)  ? rq.xard__c : false;} }*/
                Acc = rq.acc__r;
                srv = rq.srvc__r;
                getAcc(); /* for licence renewal requests start*/ /* if ((srv.uid__c=='208') && Acc.lcsta__c=='License Under Renewal'){ if (rq.xcawp__c){LoadAllLocSeg(false);}else{LoadAllLocSeg(true);} setDCCAReqValues(rq); }*/
            } else {
                rq.conrol__c = srv.conrol__c;
                rq.consta__c = srv.consta__c;
                rq.sprrole__c = srv.sprrole__c;
                rq.sprsta__c = srv.sprsta__c;
                rq.STA__c = 'Draft';

            }
            system.debug('rq >>:' + rq);
            system.debug('########isnw#############-' + isnw);
            system.debug('########ispu#############4' + ispu);
            system.debug('########isgu#############4' + isgu);
            if ((isnw && ispu) && !isgu) {
                system.debug('########UserInfo.getUserId()#############--' + UserInfo.getUserId());
                User usr = [select id, contact.account.mtc__c, contact.account.Name, contact.account.Email__c, contact.account.Phone, MobilePhone, accountid, contact.account.id, contact.account.adb__c, contact.account.xcuzn__c, contact.account.xcublg__c, contact.account.bgb__c, contact.account.bgnr__c, contact.account.bg__c, contact.account.loc__c, contact.account.Type, contact.account.Prk__c, contact.account.lcsnc__c, contact.account.lcsncnt__c, contact.account.lcedt__c, contact.account.psasnc__c, contact.account.psasncnt__c, contact.account.ecsnc__c, contact.account.ecsncnt__c, contact.account.cosnc__c, contact.account.cosncnt__c, contact.account.bgsnc__c, contact.account.bgsncnt__c, contact.account.snc__c, contact.account.info__c, contact.account.vestd__c, contact.account.vbtemp__c, contact.account.vbvv__c, contact.account.lc__c, contact.account.ORACLE_PARTY_ID__c, contact.account.lcsta__c, contact.account.lctp__c, contact.account.session__c, contact.account.vctemp__c, contact.account.vvsfp__c from User where id =: UserInfo.getUserId() limit 1];
                Acc = usr.contact.account;
                rq.acc__c = Acc.Id;
                rq.xaloc__c = acc.loc__c;
                rq.rmob__c = usr.MobilePhone;
                system.debug('########rq.acc__c#############4');
                system.debug(rq.acc__c);
                system.debug(Acc.Id);
                system.debug('#####################4');
                rq.xbrnd__c = acc.xcuzn__c;
                rq.xbn__c = acc.xcublg__c;
                rq.xceml__c = usr.contact.account.Email__c;
                rq.xoln__c = usr.contact.account.Phone;
                rq.xpmsle__c = true;
                getAcc(); /*/loadLocations();*/
            }
            ejariLeaseFlg = false;
            loadLeaseInfo();
            pt = srv.lbl__c;
            pDsc = srv.dsc__c;
            pg = srv.stg__r.pg__c;

        } catch (exception ex) {
            gu.AddErrorMsg(ex.getMessage() + ' ex.getMessage() ,' + ex.getLineNumber());
            apexpages.addmessages(ex);
        }
    }
    public void loadLeaseInfo(){
        Map<String,PMSAmdDataWrapper.UnitInfo> tecomLeaseMp = new Map<String,PMSAmdDataWrapper.UnitInfo>();
        Map<String,PMSAmdDataWrapper.UnitInfo> ejariLeaseMp = new Map<String,PMSAmdDataWrapper.UnitInfo>();
        pmsLeaseLst = new List<PMSAmdDataWrapper.UnitInfo>();
        ejariLeaseArea = 0.0;
        Decimal psffeeIcVat = 0.0;
        Boolean isNewLease = false,isTerminate=false;
        //if (String.isNotBlank(Acc.ORACLE_PARTY_ID__c)){
        rq.xcawp__c = false;
        List<grqWsDccaGetService.Records> crmleaseLst = grqWsDccaGetService.loadD3Loc(Acc.ORACLE_PARTY_ID__c);
        if (crmleaseLst!=null && !crmleaseLst.isEmpty()) {
            for (grqWsDccaGetService.Records rc : crmleaseLst){
                Decimal crmLeaseArea=0.0;
                List<String> crmuidLst = new List<String>();
                String status = (String.isNotblank(rc.Status) ? rc.Status : rc.ContractStatusReason);
                boolean stsFlg = false;
                if (status!=null  && (status=='Active' || status=='Lease Signed' ||  status=='Modification Activation' || status=='Contraction Activation'  || status=='Contraction Activation' || status=='LA sent for Signoff' || status=='Expansion Activation' || status=='Original Lease Activation' || status=='Renewal Activation' || status=='Customer sign' || status=='Customer signed'
                                     || status=='Tecom Sign' || status=='Tecom Signed' || status=='Ready for Activation' ||status=='Tecom Sign' || status=='Tecom Signed' || status=='Ready for Activation' || status.contains('Collected by BP') || status.contains('Signed by BP') || status=='LA is signed off' || status=='LA is ready to activated' || status=='LA activated' || status=='Signed LA received' || status.contains('Counter Signed') || status.contains('Ready for Activation') || status.contains('Modification In Progress') || status.contains('Renewal In Progress')|| status.contains('Expansion In Progress') || status.contains('Termination in progress') )){
                                         stsFlg = true;
                                     }
                if (stsFlg && rc.Products != null && !rc.Products.isEmpty()){
                    for (grqWsDccaGetService.Products p: rc.Products){
                        PMSAmdDataWrapper.UnitInfo u = new PMSAmdDataWrapper.UnitInfo();
                        u.unitNoEn =(String.isNotBlank(rc.ContractNumber) ? p.ProductName : p.unitNumber);
                        u.building = (String.isNotBlank(rc.ContractNumber) ? rc.BuildingName : rc.Building);
                        u.contractNo = (String.isNotBlank(rc.ContractNumber) ? rc.ContractNumber : rc.AgNo);
                        u.contractStartDate = (String.isNotBlank(rc.ContractStartDate)) ? grqWsDccaGetService.formatDt(rc.ContractStartDate) : rc.ContractStartDate;
                        u.ContractEndDate = (String.isNotBlank(rc.ContractEndDate)) ? grqWsDccaGetService.formatDt(rc.ContractEndDate) : rc.ContractEndDate;
                        crmLeaseArea = p.UnitArea != null ? p.UnitArea : 0;
                        u.areaSft = crmLeaseArea;
                        if (!crmuidLst.contains(u.contractNo+''+u.unitNoEn)){
                            crmuidLst.add(u.contractNo+''+u.unitNoEn);
                            tecomLeaseMp.put(u.contractNo+''+u.unitNoEn,u);
                        }
                    }
                }
            }
        }
        //}
        system.debug('#####################################');
        system.debug(tecomLeaseMp+'####tecomLeaseMp###');
        system.debug('#####################################');
        List<PMSDataWrapper.ContractInformation> ejariContractList = gwsPMSIntegration.getEjariContractInfoByLicenseNo(Acc.lc__c);
        if (ejariContractList != null && !ejariContractList.isEmpty()){
            for (PMSDataWrapper.ContractInformation c: ejariContractList){ if (String.isNotBlank(c.ContractNumber) && c.propertyInformationList != null && !c.propertyInformationList.isEmpty() ){ for (PMSDataWrapper.PropertyInformationList p : c.propertyInformationList){ PMSAmdDataWrapper.UnitInfo u = new PMSAmdDataWrapper.UnitInfo(); u.unitNoEn = p.unitNumber; u.building = c.buildingName.englishName; u.contractNo = c.contractNumber; u.contractStartDate = (String.isNotBlank(c.startDate))? grqWsDccaGetService.formatEjariDt(c.startDate) : c.startDate; u.ContractEndDate = (String.isNotBlank(c.endDate))? grqWsDccaGetService.formatEjariDt(c.endDate) : c.endDate; u.areaSm =  decimal.valueOf(p.Area); u.areaSft = (u.areaSm *10.7639).setScale(2, RoundingMode.HALF_UP); ejariLeaseMp.put(u.contractNo+''+u.unitNoEn,u); } } }
        }
        system.debug('#####################################');
        system.debug(ejariLeaseMp+'####ejariLeaseMp###');
        system.debug('#####################################');
        system.debug('tecomLeaseMp-'+tecomLeaseMp);
        system.debug('ejariLeaseMp-'+ejariLeaseMp);
        if (ejariLeaseMp != null && !ejariLeaseMp.isEmpty()){
            for (String uid : ejariLeaseMp.keySet()){
                system.debug('tecomLeaseMp.containskey(uid):'+tecomLeaseMp.containskey(uid));
                system.debug('ejari UID--'+uid);
                PMSAmdDataWrapper.UnitInfo u = ejariLeaseMp.get(uid);
                if (tecomLeaseMp != null && tecomLeaseMp.containskey(uid)){
                    u.sts = 'M';
                }
                else{
                    u.sts = 'N'; isNewLease = true;
                }
                pmsLeaseLst.add(u);
            }
        }
        if (tecomLeaseMp != null && !tecomLeaseMp.isEmpty()){
            for (String uid : tecomLeaseMp.keySet()){
                PMSAmdDataWrapper.UnitInfo uin= tecomLeaseMp.get(uid);
                String cntrno=uin.contractNo;
                if (!ejariLeaseMp.containskey(uid) && cntrno!=null && cntrno!='' && !cntrno.contains('CON')){
                    PMSAmdDataWrapper.UnitInfo u = tecomLeaseMp.get(uid);
                    u.sts = 'T'; isTerminate = true;
                    pmsLeaseLst.add(u);
                }
            }
        }
        if (pmsLeaseLst != null && !pmsLeaseLst.isEmpty()){
            pmsLeaseLst.sort();
            for (PMSAmdDataWrapper.UnitInfo u : pmsLeaseLst){
                if (u.sts == 'N' && u.areaSft != null){
                    ejariLeaseArea += u.areaSft;
                }
                if (ejariLeaseArea != null && ejariLeaseArea != 0){ psffeeIcVat = (ejariLeaseArea * decimal.valueOf(Label.PSFFeeSF)); psffeeIcVat = (psffeeIcVat + ((psffeeIcVat * 5) / 100)).setScale(2, RoundingMode.HALF_UP); rq.xsvn__c = String.valueOf(ejariLeaseArea); rq.xadtx2__c = Json.serialize(ejariContractList); ejariLeaseFlg = true; rq.xvnum__c = String.valueOf(psffeeIcVat); }
            }
            rq.xadtx4__c = Json.serialize(pmsLeaseLst);
            if (isTerminate && isNewLease)
                rq.xvtyp__c = 'New and Amendment';
            else if (isNewLease){
                //rq.xcawp__c = true;
                rq.xppsfv__c = true;
                rq.xvtyp__c = 'New';
            }
            else
                rq.xvtyp__c = 'Amendment';
        }
    }
    public static boolean DEG_Checksum(String msg, String encText) {
        String eCd = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', blob.valueOf('P@ssw0rdAXSHRMS' + msg))).toUpperCase();
        System.debug('** eCd:' + eCd);
        System.debug('** encText:' + encText);
        return eCd == encText;
    }
    //private void getAcc(){Acc = [select id,ecedt__c,Name,Legal_Framework__c,Phone,adb__c,bgb__c,bgnr__c,bg__c,lc__c,ORACLE_PARTY_ID__c,loc__c,Type,Prk__c,lcsnc__c,lcsncnt__c,psasnc__c,psasncnt__c,ecsnc__c,ecsncnt__c,cosnc__c,cosncnt__c,bgsnc__c,bgsncnt__c,snc__c,info__c,vestd__c,vbtemp__c,vbvv__c,lcedt__c,vbtst__c,vvsfp__c,(Select Id ,acct__c,act__c,act_type__c,bus_unit__c,dcca_id__c,lic__c,or_prty__c,seg__c,sDate__c from aseg__r),(Select Id,Loc__c,agrno__c,acc__c,bu__c,IsMain__c,IsSub__c,ls_end__c,ls_std__c,active__c,rpi__c,Is_frzn__c from aloc__r where Is_frzn__c=true  ),session__c from Account where id=: rq.Acc__c limit 1];}
    public void getAcc() {
        if (rq.Acc__c != null) {
            Acc = [select id, vespe__c, Freehold__c, SF_CRM_ID__c, dccaexId__c, ccrm_sfid__c, ecedt__c, dedlic__c, lcsta__c, Name, Legal_Framework__c, lrd__c, onar__c, Phone, adb__c, bgb__c, bgnr__c, bg__c, lc__c, ORACLE_PARTY_ID__c, loc__c, Type, Prk__c, lcsnc__c, lcsncnt__c, psasnc__c, psasncnt__c, ecsnc__c, ecsncnt__c, cosnc__c, cosncnt__c, bgsnc__c, bgsncnt__c, snc__c, info__c, vestd__c, vbtemp__c, vbvv__c, lcedt__c, vbtst__c, vvsfp__c, (Select Id, acct__c, act__c, act_type__c, bus_unit__c, dcca_id__c, lic__c, or_prty__c, seg__c, sDate__c from aseg__r), (Select Id, Loc__c, agrno__c, acc__c, bu__c, IsMain__c, IsSub__c, ls_end__c, ls_std__c, active__c, rpi__c, Is_frzn__c from aloc__r where Is_frzn__c = true), session__c from Account where id =: rq.Acc__c limit 1];
        }
    }

    public void validate(Boolean isNew) {
        if (pg != gu.pageURL) {
            pgHide = true;
            gu.addWarningMsg(Label.msgInvReqPg);
        }
        if (isNew && ispu) {
            pgHide = true;
        }
        if (!accesssOk) {
            pgHide = true;
        }


        gU.checkNav();
    }
    private Boolean hasSanctions { get { if (rq.Id == null && srv.uid__c != '208') { grqH.rH h = new grqH.rH(); return !h.BC(rq, srv, Acc); } else if (rq.Id != null && srv.uid__c != '208') { grqH.rH h = new grqH.rH(); return !h.AC(rq, srv, Acc); } return false; } } private Boolean accesssOk { get { Boolean acsOk = gu.canReqSrvc(rq.srvc__c, false, null); if (!acsOk) { if (md.isNew) { gu.addWarningMsg(Label.msgNoPrivilege); } else { md.setView(); gu.addInfoMsg(Label.msgReadOnly); } } return acsOk; } }
    @TestVisible
    private Boolean cancelItms() {
        try {
            map < String, Id > mapSTA = new map < String, Id > ();
            for (g_srvcitm_Status__c s: [select id, cd__c, itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__c =: rq.srvc__c and cd__c = 'c']) {
                mapSTA.put(s.itm__r.cd__c, s.Id);
            }
            list < g_reqitem__c > items = [select Id, itm__r.cd__c, sta__c from g_reqitem__c where RQ__c =: rq.Id and isDeleted = false and sta__r.Tp__c = 'Open'];
            list < g_reqitem__c > toUpdate = new list < g_reqitem__c > ();
            for (g_reqitem__c i: items) { if (mapSTA.get(i.itm__r.cd__c) == null) { gu.AddErrorMsg(Label.msgNFSTAC); return false; } i.sta__c = mapSTA.get(i.itm__r.cd__c); toUpdate.add(i); }
            if (toUpdate.size() > 0) {
                SObjectAccessDecision secDec = Security.stripInaccessible(AccessType.UPDATABLE, toUpdate);
                update secDec.getRecords();
            }
        } catch (Exception e) {
            gu.AddErrorMsg(e.getStackTraceString());
            return false;
        }
        return true;
    }

    public PageReference CancelR() { if (ispu) { Savepoint sp = null; String oldSTA = rq.STA__c; try { If((rq.STA__c != 'Draft' && rq.STA__c != 'Open') || rq.AP__c > 0 || rq.AOP__c > 0) { gu.AddWarningMsg(Label.msgReqnoCancel); return null; } sp = Database.setSavePoint(); upsertR('Cancelled'); if (!cancelItms()) { Database.rollback(sp); rq.STA__c = oldSTA; return null; } return (new ApexPages.StandardController(rq)).view(); } catch (DMLException exDML) { if (sp != null) { Database.rollback(sp); } for (Integer i = 0; i < exDML.getNumDml(); i++) { if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) { System.Debug('** Exception:' + exDML.getDmlMessage(i)); gu.AddErrorMsg(Label.msgException); } } rq.STA__c = oldSTA; return null; } catch (exception ex) { if (sp != null) { Database.rollback(sp); } gu.AddErrorMsg(ex + ' gctlReq9'); rq.STA__c = oldSTA; return null; } } /*add second id for M*/ else if (UserInfo.getProfileId() == '00e20000001Ajl3' || UserInfo.getProfileId() == '00e20000001Ajl3AAC' || UserInfo.getProfileId() == '00e20000001mIim' || UserInfo.getProfileId() == '00e20000001mIimAAE' || UserInfo.getProfileId() == '00e28000001sbAlAAI') { if (rq.AOP__c > 0) { gu.AddErrorMsg('Request has open payments. Please close the payments before proceeding.'); return null; } Savepoint sp = null; String oldSTA = rq.STA__c; try { sp = Database.setSavePoint(); upsertR('Cancelled'); if (rq.AP__c > 0) { if (!cancelItms()) { Database.rollback(sp); rq.STA__c = oldSTA; return null; } } else { if (!cancelItms()) { Database.rollback(sp); rq.STA__c = oldSTA; return null; } } return (new ApexPages.StandardController(rq)).view(); } catch (DMLException exDML) { if (sp != null) { Database.rollback(sp); } for (Integer i = 0; i < exDML.getNumDml(); i++) { if (exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION) { System.Debug('** Exception:' + exDML.getDmlMessage(i)); gu.AddErrorMsg(Label.msgException); } } rq.STA__c = oldSTA; return null; } catch (exception ex) { if (sp != null) { Database.rollback(sp); } gu.AddErrorMsg(ex + ' gctlReq9'); rq.STA__c = oldSTA; return null; } } else { gu.AddErrorMsg('Invalid operation.'); return null; } /* return null;*/ }

    public PageReference saveOpen() {

        String nxtPage = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('nextPage'));
        try{
            rq.STA__c = 'Open';
            upsert rq;
            rq =[select  id,xadtx4__c,xppsfv__c,srvc__c from g_Req__c where id=:rq.id][0];
            rq.xppsfv__c=false;
            gwsPMSIntegration.insertPMSAmndOffLoc(rq);
            if (nxtPage != null) {
                system.debug('nxtPage1::' + nxtPage);
                return (new pagereference('/apex/' + nxtPage + '?id=' + rq.Id + '&cn=' + srv.uid__c));
            }
        }
        catch (exception ex) {
            system.debug('ex::' + ex.getStackTraceString());
            gu.AddErrorMsg(ex + ' gctlReq5 : ' + ex.getStackTraceString());

            return null;
        }
        return null;
    }
    public PageReference paymentPage() {
        return (new pagereference('/apex/grqpymi??empid=TG1647&enc=1245652097735B7F37FE7D402B2C9B3CCC67292A&pid=00328000018PBLv&sid=a0L2000000YQVLDEA5'));
    }
    @testVisible
    private void upsertR(String sta) {
        system.debug('rq=2='+rq);
        rq.STA__c = sta; /*/ system.debug('spouse name::' + rq.xspn__c);*/
        upsert rq; /*/update rq;*/

    }
    @testVisible
    private Boolean nD { get { if (rq.rDocs__r == null) { return false; } for (g_reqDoc__c d: [select id, upOk__c from g_reqDoc__c where RQ__c =: rq.id]) { if (!d.upOk__c) { return true; } } return false; } } public Boolean codeCheck { get; set; } public boolean noSRfg { get; set; }
}