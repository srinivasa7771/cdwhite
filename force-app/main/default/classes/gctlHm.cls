public with sharing class gctlHm {
    public boolean noOpi {get;set;}
    public string licCopy {get;set;} 
    public String parkingString {get;set;}public string days {set;get;}public string status {set;get;}
    public string dc {get;set;}
    public boolean profileAlerts{get;set;}
    public string alertDescription{get;set;}
    //Added By CB
    public Boolean displayPSAPopup {get;set;}
    public String managerInCharge  {get;set;}
    public Date agreementDate  {get;set;}
    //END CB 
    public User U {
        get;
        set;
    }
    public Account A {
        get;
        set;
    }
    public Contact C {
        get;
        set;
    }
    public g_Req__c rq {
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
    }@TestVisible 
    public string lcl {
        get {
            return UserInfo.getLocale();
        }
    }@TestVisible 
    public Decimal minBG {
        get {
            return gU.csCurr('minBG');
        }
    }@TestVisible 
    public Decimal maxBG {
        get {
            return gU.csCurr('maxBG');
        }
    }@TestVisible 
    public Decimal VVU {
        get;
        set;
    } {
        VVU = 0;
    }
    /*cD=Draft RQs|cO=Open RQs|cR=under review RQs|cP=In Process RQs|cH=on hold RQs|cC=need correction RQs*/
    public Decimal cD {
        get;
        set;
    } {
        cD = 0;
    }
    public Decimal cO {
        get;
        set;
    } {
        cO = 0;
    }
    public Decimal cR {
        get;
        set;
    } {
        cR = 0;
    }
    public Decimal cP {
        get;
        set;
    } {
        cP = 0;
    }
    public Decimal cH {
        get;
        set;
    } {
        cH = 0;
    }
    public Decimal cC {
        get;
        set;
    } {
        cC = 0;
    }
    /*cOD=Contacts need Update Attribute|cRPExp=Expired RPs|cPSExp=Expired Passports|cPSExp=Passports expiring NEXT30DAYS|cRPExp30=RPs expiring NEXT30DAYS*/
    public Decimal cOD {
        get;
        set;
    } {
        cOD = 0;
    }
    public Decimal cRPExp {
        get;
        set;
    } {
        cRPExp = 0;
    }
    public Decimal cPSExp {
        get;
        set;
    } {
        cPSExp = 0;
    }
    public Decimal cPSExp30 {
        get;
        set;
    } {
        cPSExp30 = 0;
    }
    public Decimal cRPExp30 {
        get;
        set;
    } {
        cRPExp30 = 0;
    }
    public Date leaseDt {get;set;}
    
    
    
    public List<g_Req__c> notificationRqs {
        get;
        set;
    }
    public List<g_Req__c> notificationRqs3 {
        get;
        set;
    }
    public List<g_Req__c> rcRqs {
        get;
        set;
    }
    public List<g_Req__c> draftRqs {
        get;
        set;
    }
    public List<g_Req__c> allDPRqs {
        get;
        set;
    }
    public transient List<g_Req__c> pendingRqs {
        get;
        set;
    }
    public List<g_Req__c> draftRq5 {
        get;
        set;
    }
    public List<g_Req__c> pendingRq5 {
        get;
        set;
    }
    public transient List<g_Req__c> allRqs {
        get;
        set;
    }
    public List<g_Req__c> openNopmntRqs {
        get;
        set;
    }
    public String pageNo {get;set;}  
    public Integer RecordsPerPageslist{ 
        get;set{
            if(value!=null){
                this.RecordsPerPagesList=value;
            }
        }       
    }
    public Integer PageNumber{
        get{                                                            //To get current page number
            this.PageNumber=stdSetController.getPageNumber();
            return this.PageNumber;
        }
        set{                                                              // To navigate to the page number entered by the user
            stdSetController.setPageNumber(value);
        }
    }
    
    
    public Boolean isCI {get;set;}
    //public Boolean isGv {get;set;}
    public String poBox {get;set;}
    public String orclId {get;set;}
    public Integer mScSize {get;set;}
    public Boolean mScHasVal {get;set;}
    public String prsn{get;set;}
    public String dat{get;set;}
    public String sta{get;set;}
    public String isPendingTab{get;set;}
    public String searchCriet{get;set;}
    public String accidonload{get;set;}
    public List<contact> contLst  {get;set;}
    public List<loc__c> locLst  {get;set;}
    
    public List<grqWsDccaGetService.Records>  tecomLeaseList {get;set;}
    public  map<String,String > finalAgreeLoc{get;set;}
    public List<g_Tran__c> tsLst {get;set;}
    public List<myAccount> myAccountLst {get;set;}
    public List<String> licList{get;set;} 
    public Map<String,User> uidUsrname{get;set;}
    public String redirectUrl {get;set;}
    public Id approverProfile = [Select Id From Profile Where Name='X' LIMIT 1].Id;
    public Id defaultProfile = [Select Id From Profile Where Name='Z' LIMIT 1].Id;
    /* public Decimal osE {
get;
set;
} {
osE = 0;
}*/
    public gctlHm() {
        profileAlerts=false;
        try {
            system.debug('In >> gctlHm()');
            ispu = gu.isPortalUser(UserInfo.getProfileId());
            pgHide = !ispu;
            system.debug('In >> Calling Init');
            displayPSAPopup = checkDisplayPSAPopup();
            init();
        } catch (exception ex) {
            gu.AddErrorMsg(ex);
            System.debug('gctlHm >> @@ Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            pgHide = true;
        }
        system.debug('Out >> gctlHm()');
    }
    private void init() { system.debug('In >> init()'); try { if (ispu) { system.debug('In >> init()>>ispu'); loadData(false); } gU.checkNav(); } catch (exception ex) { gu.AddErrorMsg(ex); System.debug('@@ Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString()); pgHide = true; } system.debug('Out >> init()'); }
    public PageReference obr1() { noOpi = false; system.debug('noOpi -- ' + noOpi); PageReference pageRef = null; String srvcUid = ''; U = [select Id,Policy_Confirmation_Date__c, Name, seg__c, FirstName, LastName, accountid, LastPasswordChangeDate, LastLoginDate, contact.Type__c, contact.Photo_ID__c, contact.MobilePhone, contact.Email, contact.account.id,contact.account.show_alert__c, contact.account.PRM_Name__c, contact.account.PRM_MobileNo__c, contact.account.PRM_Email__c, contact.account.on__c, contact.account.onar__c, contact.account.Website, contact.account.vespe__c, contact.account.vespex__c, contact.account.vetemp__c, contact.account.vbtemp__c, contact.account.vetst__c, contact.account.vespst__c, contact.account.vespstx__c, contact.account.vbtst__c, contact.account.vev__c, contact.account.mxPortalUsers__c, contact.account.Name, contact.account.Email__c, contact.account.lPrk__c, contact.account.Building_Name__c, contact.account.xcublg__c, contact.account.Location__c, contact.account.Location_Cluster__c, contact.account.xcuzn__c, contact.account.Phone, contact.account.Type, contact.account.Park__c, contact.account.Prk__c, contact.account.adb__c, contact.account.info__c, contact.account.bgnr__c, contact.account.bg__c, contact.account.bgc__c, contact.account.bgcabsc__c, contact.account.bgb__c, contact.account.vctemp__c, contact.account.speabsc__c, contact.account.vctst__c, contact.account.sncNt__c, contact.account.vbvv__c, contact.account.lcidt1__c, contact.account.ec__c, contact.account.ecidt__c, contact.account.lctp__c, contact.account.ecedt__c, contact.account.lcedt__c, contact.account.lcsnc__c, contact.account.lcsncnt__c, contact.account.Legal_Framework__c, contact.account.psasnc__c, contact.account.psasncnt__c, contact.account.lcsta__c, contact.account.ecsnc__c, contact.account.ecsncnt__c, contact.account.lcrndt__c, contact.account.cosnc__c, contact.account.cosncnt__c, contact.account.licexdt__c, contact.account.licIdt__c, contact.account.bgsnc__c, contact.account.bgsncnt__c, contact.account.snc__c, contact.account.voep__c, contact.account.lc__c, contact.account.ORACLE_PARTY_ID__c, contact.account.rpa__c, contact.account.os__c, contact.account.adob__c, contact.account.adx__c, contact.account.adc__c from User where id =: UserInfo.getUserId() limit 1]; Boolean onlyParkingUser = gU.checkParkingUser(U.Id); if (onlyParkingUser == true) { pageRef = new PageReference('/AccessDenied'); if ((el.get('stdElg') != null && el.get('stdElg') > 0) || el.get('prkAvl') == 1) { pageRef = new PageReference('/pageCompanyInfo'); } return pageRef; } if (String.isNotBlank(U.contact.account.lcsta__c) && (U.contact.account.lcsta__c.equalsIgnoreCase('license issued') || U.contact.account.lcsta__c.equalsIgnoreCase('license under renewal'))) { return null; } if (U.contact.account.Legal_Framework__c == 'Freelancer' && String.isBlank(U.contact.account.lc__c)) { if (U.contact.account.os__c != 'Completed' && U.contact.account.lcsta__c != 'License Issued') { List < g_req__c > req1 = [Select id, name, xdei__c, STA__c from g_req__c where Acc__c =: U.contact.account.id And srvc__r.uid__c = '322' and sta__c != 'Cancelled' order by createddate desc ]; /*,CAS__c,xcacp__c*/ if (req1 != null && !req1.isEmpty()) { if (String.isBlank(A.ORACLE_PARTY_ID__c)) { noOpi = true; } else if (String.isBlank(U.contact.account.os__c) && String.isNotBlank(req1[0].xdei__c)) { pageRef = new PageReference('/grqpy?id=' + req1[0].id); } else if (String.isNotBlank(req1[0].sta__c) && req1[0].sta__c.equalsIgnoreCase('draft')) { pageRef = new PageReference('/obrqfl?sid=' + Label.Onboarding_Fl_SD + '&id=' + req1[0].id + '&vt=n#'); /* new PageReference('/'+req1[0].id);*/ } else { pageRef = new PageReference('/' + req1[0].id); } } /*else { pageRef = new PageReference('/obrqfl?sid=' + Label.Onboarding_Fl_SD + '&vt=n#'); }*/ } } else { /*if(U.contact.account.os__c != null && U.contact.account.os__c!='Completed') */ srvcUid = '216'; List < g_req__c > req1 = [Select id, name, xvtyp__c, parcat__c, AP__c, AOP__c from g_req__c where Acc__c =: U.contact.account.id And srvc__r.uid__c =: srvcUid and sta__c NOT IN('Completed', 'Cancelled', 'Rejected') order by createddate desc]; /*,CAS__c,xcacp__c*/ system.debug('req1  >>' + req1); if (req1.size() > 0) { /* PageReference pageRef = new PageReference('/'+req1[0].id); */ if (srvcUid == '216') { if (String.isBlank(A.ORACLE_PARTY_ID__c)) { noOpi = true; } else { if (req1[0].AP__c <= 5250 && ((req1[0].xvtyp__c == 'DED' && req1[0].parCat__c == 'Land') || (req1[0].xvtyp__c == 'DDA' || req1[0].xvtyp__c == 'DED'))) { pageRef = new PageReference('/lerqOb?id=' + req1[0].id + '&m=e'); } else if (req1[0].AP__c > 0 || req1[0].AOP__c > 0) pageRef = new PageReference('/grqStatus?id=' + req1[0].id); else pageRef = new PageReference('/lerqOb?id=' + req1[0].id + '&m=e'); } } /*else if(srvcUid =='221' ){&& !req1[0].xcacp__c if(U.contact.account.MemSta__c=='Issued' || U.contact.account.MemSta__c=='Under Renewal')pageRef = new PageReference('/gpmIn5');else if(req1[0].CAS__c=='Approved')pageRef = new PageReference('/ddfcregister?id='+req1[0].id+'&sid='+sid+'&m=v');elsepageRef = new PageReference('/ddfcregister?id='+req1[0].id+'&sid='+sid+'&m=e');pageRef.setRedirect(true);}*/ System.debug('@@@@@ pageRef' + pageRef); return pageRef; } } return pageRef; }
    public PageReference obr(){ String srvcUid=''; String sid=''; U = [select Id, accountid, contact.account.id, contact.account.os__c, contact.account.Park__c, contact.account.Prk__c,contact.account.Type from User where id =: UserInfo.getUserId() limit 1 ]; system.debug('usr>>'+U ); srvcUid ='320'; system.debug('srvcUid >>'+srvcUid );  system.debug('U.contact.account.os__c>>'+U.contact.account.os__c);  system.debug('U.contact.account.id >>'+U.contact.account.id);  if(U.contact.account.os__c != null && U.contact.account.os__c!='Completed'){ List<g_req__c> req1 = [Select id, name from g_req__c where Acc__c= :U.contact.account.id And srvc__r.uid__c =:srvcUid and sta__c NOT IN ('Completed','Cancelled','Rejected')]; system.debug('req1  >>'+req1 ); if(req1.size()>0){ PageReference pageRef = null; if(srvcUid =='216'){ pageRef = new PageReference('/grqob?id='+req1[0].id+'&m=e'); } System.debug('@@@@@ pageRef' + pageRef ); return pageRef; } } return null; }
    public PageReference checkOraclePartyID(){ Account Acc = [select id, ORACLE_PARTY_ID__c from account where id=:u.contact.account.id]; if(String.isNotBlank(Acc.ORACLE_PARTY_ID__c)){ noOpi =  false; return new PageReference('/gpm'); } noOpi =  true; return null; }
    private void loadData(Boolean isnw) { system.debug('In >> loadData() 1'); licList = new List<String>{'License Under Renewal','License Issued','License Approved','License Cancelled'}; RecordsPerPageslist = 10; String url = Apexpages.currentPage().getURL(); if(url.contains('pagepastrequests') ||  url.contains('pendingactions')){ if(Apexpages.currentPage().getparameters().get('flg') != null){ if(Apexpages.currentPage().getparameters().get('flg') == 'pndg') isPendingTab = 'pndg'; else if(Apexpages.currentPage().getparameters().get('flg') == 'drft') isPendingTab = 'drft'; } }  U = [select Id, Name,seg__c, FirstName, LastName, accountid, LastPasswordChangeDate, LastLoginDate, contact.Photo_ID__c,contact.MobilePhone,contact.Email, contact.account.id, contact.account.on__c , contact.account.PRM_Name__c,contact.account.PRM_MobileNo__c, contact.account.PRM_Email__c, contact.account.onar__c , contact.account.Website, contact.account.vespe__c, contact.account.vespex__c, contact.account.vetemp__c, contact.account.vbtemp__c , contact.account.vetst__c, contact.account.vespst__c, contact.account.vespstx__c , contact.account.vbtst__c, contact.account.vev__c, contact.account.mxPortalUsers__c, contact.account.Name,contact.account.Email__c,contact.account.lPrk__c,contact.account.Building_Name__c, contact.account.xcublg__c,contact.account.Location__c, contact.account.Location_Cluster__c,contact.account.xcuzn__c , contact.account.Phone, contact.account.Type, contact.account.Park__c, contact.account.Prk__c, contact.account.adb__c, contact.account.info__c,contact.account.bgnr__c, contact.account.bg__c, contact.account.bgc__c, contact.account.bgcabsc__c, contact.account.bgb__c, contact.account.vctemp__c, contact.account.speabsc__c, contact.account.vctst__c, contact.account.sncNt__c, contact.account.vbvv__c,contact.account.lcidt1__c, contact.account.ec__c, contact.account.ecidt__c, contact.account.lctp__c,    contact.account.ecedt__c,contact.account.lcedt__c,contact.account.lcsnc__c, contact.account.lcsncnt__c,contact.account.Legal_Framework__c, contact.account.psasnc__c, contact.account.psasncnt__c, contact.account.lcsta__c,contact.account.ecsnc__c, contact.account.ecsncnt__c,contact.account.lcrndt__c,contact.account.cosnc__c, contact.account.cosncnt__c,contact.account.licexdt__c, contact.account.licIdt__c,   contact.account.bgsnc__c, contact.account.bgsncnt__c, contact.account.snc__c,contact.account.voep__c, contact.account.lc__c, contact.account.ORACLE_PARTY_ID__c,contact.account.rpa__c, contact.account.os__c, contact.account.adob__c , contact.account.adx__c, contact.account.adc__c,contact.account.lcflg__c,contact.account.RelocationFlag__c from User where id =: UserInfo.getUserId() limit 1];  system.debug('In >> loadData() 2'); string jsonStr = '{"methodname":"getcompanyalerts", "data":{"licenseNum":"'+u.contact.account.lc__c+'"}}'; String responseBody = DDAServices.getDDAServices('DCCA_Auth','onbordingapi','POST',jsonStr);  String link = '<a href="/custProfileUpdate?sid=' +Label.CPU+' " target="_blank"><b><i><u>click here to update</u></i></b></a>'; Map<String, Object> alertMap =  (Map<String, Object>)JSON.deserializeUntyped(responseBody); List<Object> alerList =  (List<Object>)alertMap.get('ListAlerts'); if (alerList!=null && !alerList.isEmpty()) { profileAlerts=true; }  A = U.contact.account; C = U.contact; if(U.contact.account.ORACLE_PARTY_ID__c!=null) orclId = U.contact.account.ORACLE_PARTY_ID__c; List<g_Req__c> rqLst = [select id,name,STA__c,AP__c,xtpa__c,AOP__c,xadh__C,AUP__c,xcamdt__c,(select id from Attachments order by lastmodifieddate desc limit 1) from g_Req__c where Acc__c=:A.Id and STA__c in('Draft','Open','Under Review','In Process','Completed') and srvc__r.uid__c = '208' order by lastmodifieddate desc limit 1]; if(rqLst != null && !rqLst.isEmpty()) rq = rqLst[0];  /*List<AggregateResult> arLst = [select count(Id) cnt from contact where id in (select contactId from AccountcontactRelation where accountId =:U.accountid  and isDirect = false and sts__c = 'Active')]; if(arLst != null && !arLst.isEmpty()) osE = (Decimal)arLst.get(0).get('cnt');   */ if(!u.contact.account.Type.equalsIgnoreCase('Customer - Incubation') && !u.contact.account.Type.equalsIgnoreCase('Customer - Member')){ system.debug('In >> loadData() 3'); getRQs(); getVisitors(); getCs(); getSrvcs(); loadStats(); getSanctions(); getParkings(A); /* loadCards2(orclId);*/ getConInfo(); getRCRQs(); getdraftRQs(); getpendingRQs(); getnotificationRQs(); getallDPRQs(); poBox = ''; getPOBox();  system.debug('In >> loadData() 4'); } }
    
    public Map<String,String>renewLinkMap{get;set;}// Renewal RequestURL
    public boolean showRenewal{get;set;}
    public void setRenewalRequest(){
        renewLinkMap = new  Map<String,String>();
        List<g_Req__c> rqRenLst = [select Id,Acc__c, srvc__c,Service_Code__c,xadh__C,AUP__c,xcamdt__c from g_Req__c where Acc__c =:u.contact.account.id AND Service_Code__c='223' limit 499];
        for(g_Req__c rqren : rqRenLst){
            renewLinkMap.put('Click Here for Renewal','/apex/ddfcRenewal?id=' + rqren.Id +'&m=v');
            //apex/ddfcRenewal?id=a0Ep0000005d1kpEAA&m=v
            showRenewal =true;
        }
        system.debug('renewLinkLst >> '+ renewLinkMap);
    }
    public List<ParkingDetails> lst_pdClone{get;set;}
    
    public List<ParkingDetails> lst_pd{get;set;}
    public List<ParkingM.ParkingDetails_m> lst_pd3{get;set;}
    
    
    public PageReference loadCards2(String oid) {
        lst_pd3 = new parkingM().loadCards(oid);
        parkingString = JSON.serialize(lst_pd3);
        system.debug('parkingString- 405 -gctlhm '+parkingString);
        //prd.lst_pd = lst_pd; 
        return null;
    }
    
    private static Map<String,Integer> pel;
    public  Map<String,Integer> el {get;set;}
    
    public void getParkings(Account acc) {
        try{
            if(pel==null){
                ParkingM p = new ParkingM(); 
                pel =  p.getEligibility(acc);
                el=pel;
                
            }else{
                el=pel;
            }
            
            System.debug('### EL : ' + el);
        } catch(Exception ex){ 
            System.debug('@@Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
        /*List<g_req__c> renewlReq = [Select id ,name from g_req__c where Acc__c=:U.accountId AND STA__c='Draft' AND Service_Code__c='156' LIMIT 1];
isPRavail = false;
if(renewlReq.size()>0){isPRavail=true;}*/
    } //***
    
    public void getConInfo() { isCI = false; system.debug('Acount:::'+A.Name); List<coninfo__c> lstCI = [SELECT ID,Name__c,Acc__c,Con__c,Email__c,rol__c,phone__c FROM coninfo__c WHERE Acc__c=:A.Id Limit 1]; if(lstCI != null && lstCI.size() > 0){isCI=true;}  }
    
    public Map<string,coninfo__c> conMap  {get;set;}
    public void getconinfoLst() {
        Map<String,coninfo__c> coninfoMap = new Map<String,coninfo__c>();
        List<string> str = new List<string>();
        conMap= new Map<string,coninfo__c>();
        for(coninfo__c con : [SELECT ID,Name__c,Acc__c,Con__c,Email__c,rol__c,phone__c,seml__c,sphn__c FROM coninfo__c WHERE Acc__c=:A.Id AND Sta__c='Active']){
            coninfoMap.put(con.rol__c,con);
        }
        system.debug('coninfoMap size::::::::::'+coninfoMap.size());
        if(!coninfoMap.isEmpty()){
            for(String ci : coninfoMap.keySet()){
                if(ci.contains(';')){
                    str= ci.split(';');   
                    for(String s :str){
                        conMap.put(s,coninfoMap.get(ci)); 
                        
                    }
                }else{
                    conMap.put(ci,coninfoMap.get(ci)); 
                }
                
                
            }
            system.debug('conMap----->'+conMap);
        }
        
    }
    
    public Pagereference searchByStatus1(){
        String qry = 'select id,Applicant_Name__c,prio__c,CurrentNationality__c,xcnc__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcmn__c,xcln__c,STA__c,damsgs__c,AOP__c from g_Req__c where isDeleted = false and Acc__c =\''+ A.Id+'\' ';
        //String qry = 'SELECT id,flnm__c,Photo_ID__c,jb__r.name,STA__c,nc__c,p__c,eidid__c,rp__c,ped__c,rped__c,Passport_Status__c,RP_Sts__c FROM contact WHERE accountid=\'0012000001G8hoX\' and ';
        
        if(Apexpages.currentPage().getparameters().get('flg') != null){
            isPendingTab = Apexpages.currentPage().getparameters().get('flg');
        }
        System.debug('<searchByStatus1>  isPendingTab:  ' + isPendingTab);
        if(isPendingTab=='pndg'){
            qry +=' and STA__c NOT IN(\'Completed\',\'Rejected\',\'Cancelled\') AND ((AT__c=0) OR (AT__c>0 AND AOP__c>0)) '; 
        }
        
        if(string.isNotBlank(days)){
            Integer d = integer.valueof(days)-1;
            if(d == 0 ){
                qry = qry + ' and LastModifiedDate = TODAY';
            }else{
                qry = qry + ' and LastModifiedDate = LAST_N_DAYS:'+d;
                
            }
            
            if(string.isNotBlank(status) && status!='All'){
                qry = qry + ' and STA__c =\''+status+'\'';
            }
            
            
        }else if(string.isBlank(days) && string.isNotBlank(status) && status!='All'){
            qry = qry + ' and STA__c =\''+status+'\'';
        }            
        
        qry= qry+' limit 499 ';
        system.debug('qry::'+qry);
        
        allDPRqs = Database.query(qry);
        
        
        if(isPendingTab=='pndg' ){
            List<g_Req__c> rqs= new List<g_Req__c>();
            for(g_Req__c r : allDPRqs){
                if(r.damsgs__c!=null && r.damsgs__c!='0'){rqs.add(r);}
            }
            allDPRqs= rqs;
            
        } 
        
        strAllDPRqs1 = JSON.serialize(allDPRqs);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(allDPRqs);
        stdSetController= ssc;
        return null; 
    }
    
    public void LoadPrivateMethods() {
        if (Test.isRunningTest()) {
            try {
                getSanctions();
            } catch (exception ex) {}
            try {
                getCs();
            } catch (exception ex) {}
            try {
                getSrvcs();
            } catch (exception ex) {}
            try {
                loadStats();
            } catch (exception ex) {}
            try {
                NotGCC('Pakistani');
            } catch (exception ex) {}
            try {
                getVisitors();
            } catch (exception ex) {}
            try {
                loadData(false);
            } catch (exception ex) {}
        }
    }
    private void getRCRQs(){
        rcRqs=[select id,Name,srvc__r.Name,xcfn__c,xcmn__c,xcln__c,xcnc__c,xadh__C,AUP__c,xcamdt__c from g_Req__c where i_STA__c like '%Requires Correction%' and isDeleted = false and Acc__c =: A.Id limit 499];
    }
    public void getdraftRQs(){
        draftRq5 = new List<g_Req__c>();
        draftRqs = new List<g_Req__c>();
        allRqs = new List<g_Req__c>();
        allRqs = [select id,Applicant_Name__c,xfpdd__c,prio__c,CurrentNationality__c,xcnc__c,AT__c,AP__c,xcp__c,tmpp__c,Name,srvc__r.Name,xcfn__c,xcmn__c,xcln__c,STA__c,bamsgs__c,damsgs__c,AOP__c,xadh__C,AUP__c,xcamdt__c  from g_Req__c where isDeleted = false and Acc__c =: A.Id order by LastModifiedDate desc ];
        for(g_Req__c r : allRqs){
            if(r.STA__c =='Draft')
                draftRqs.add(r);
        }
        //draftRqs=[select id,Applicant_Name__c,prio__c,CurrentNationality__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcln__c,STA__c from g_Req__c where STA__c='Draft' and isDeleted = false and Acc__c =: A.Id];
        if(!draftRqs.isEmpty() && draftRqs.size()>0){
            for(Integer i = 0;i< draftRqs.size() && i<5;i++){
                draftRq5.add(draftRqs.get(i));
            }
        }
    } 
    public void getnotificationRQs(){ notificationRqs = new List<g_Req__c>(); notificationRqs3 = new List<g_Req__c>(); system.debug('pendingRq5--- '+pendingRq5);   notificationRqs3=[select id,Name,LastModifiedDate,bamsgs__c,damsgs__c,AUP__c,xcamdt__c,xadh__c from g_Req__c where STA__c NOT IN('Draft','Completed','Rejected','Cancelled') and bamsgs__c!=null and isDeleted = false and Acc__c =: A.Id order by LastModifiedDate desc limit 15];  for(g_req__c r : pendingRq5){ if(r.bamsgs__c!=null ){ notificationRqs.add(r); } if(r.AP__c==0){ r.bamsgs__c=',has been saved as a draft. Click here to resume the application.'; notificationRqs.add(r); } }  /*for(Integer r = 0;notificationRqs!=null && r<notificationRqs.size() && r<3;r++){ notificationRqs3.add(notificationRqs.get(r)); }*/ for(Integer r = 0;draftRq5!=null && r<draftRq5.size() && r<3;r++){ g_req__c dr=draftRq5.get(r); dr.bamsgs__c=',has been saved as a draft. Click here to resume the application.';  }  }
    
    public void getpendingRQs() { Integer leaseRenewalCount = 0; Id leaseRenewalReqId; pendingRq5 = new List < g_Req__c > (); pendingRqs = new List < g_Req__c > (); List < g_req__c > pendingRqs1 = [select id, Applicant_Name__c, prio__c, srvc__r.uid__c,CurrentNationality__c, xcnc__c, AT__c, AP__c, xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c, STA__c, AOP__c, damsgs__c, bamsgs__c, LastModifiedDate, xadh__C, AUP__c, xcamdt__c from g_Req__c where STA__c NOT IN('Draft', 'Completed', 'Rejected', 'Cancelled') and isDeleted = false and Acc__c =: A.Id order by LastModifiedDate desc]; if (pendingRqs1 != null && !pendingRqs1.isEmpty()) { integer cnt = 0; for (Integer r = 0; r < pendingRqs1.size(); r++) { if (cnt < 5 && pendingRqs1.get(r).damsgs__c != null) { pendingRq5.add(pendingRqs1.get(r)); cnt = cnt + 1; } } for (g_req__c r: pendingRqs1) { if (r.damsgs__c != null) pendingRqs.add(r); if(r.srvc__r.uid__c == '196'){ leaseRenewalCount++; leaseRenewalReqId = r.id; } } if (leaseRenewalCount == 1) { redirectUrl = '/grqLeaseRenewalDetails?id=' + leaseRenewalReqId; } else if (leaseRenewalCount > 1) { redirectUrl = '/grqShowMutipleReqSelection'; } } }
    
    public void getNopmntRQs(){
        openNopmntRqs = new List<g_Req__c>();
        for(g_Req__c r : allRqs){
            if(r.AT__c != r.AP__c){
                if(r.STA__c =='Open'){
                    openNopmntRqs.add(r);
                    //system.debug(r.name+'----> '+r.STA__c);
                }       
            }
        }
    }
    public void searchPersons(){
        // allDPRqs = new List<g_Req__c>();
        String p = '%'+prsn+'%';
        allDPRqs = [select id,Applicant_Name__c,prio__c,CurrentNationality__c,xcnc__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcmn__c,xcln__c,STA__c,damsgs__c,AOP__c,xadh__C,AUP__c,xcamdt__c from g_Req__c where isDeleted = false and (Applicant_Name__c LIKE: p or xcp__c LIKE: p) and Acc__c =:A.Id];
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(allDPRqs);
        stdSetController= ssc;
    }
    
    public void getallDPRQs(){ allDPRqs = new List<g_Req__c>(); if(isPendingTab=='pndg' ){  allDPRqs = pendingRqs;  } else if(isPendingTab=='drft' ){ allDPRqs = draftRqs; }else{ allRqs = [select id,Applicant_Name__c,xfpdd__c,prio__c,CurrentNationality__c,xcnc__c,AT__c,AP__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcmn__c,xcln__c,STA__c,damsgs__c,AOP__c,xadh__C,AUP__c,xcamdt__c from g_Req__c where isDeleted = false and Acc__c =: A.Id order by LastModifiedDate desc limit 499]; allDPRqs = allRqs; } system.debug('allDPRqs size--- '+allDPRqs.size()); }     
    public void searchByStatus(){
        system.debug('sta---> '+sta);
        // allDPRqs = new List<g_Req__c>();
        String s = ''+sta+'';
        allDPRqs = [select id,Applicant_Name__c,prio__c,CurrentNationality__c,xcnc__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcmn__c,xcln__c,STA__c,damsgs__c,AOP__c,xadh__C,AUP__c,xcamdt__c from g_Req__c where isDeleted = false and STA__c =: s and Acc__c =: A.Id order by LastModifiedDate limit 499];
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(allDPRqs);
        stdSetController= ssc;
    }
    public void searchByDate(){
        //allDPRqs = new List<g_Req__c>();
        Integer d = integer.valueof(dat);
        if(d == 1)
            allDPRqs = [select id,Applicant_Name__c,prio__c,CurrentNationality__c,xcnc__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcmn__c,xcln__c,STA__c,damsgs__c,AOP__c,xadh__C,AUP__c,xcamdt__c from g_Req__c where isDeleted = false and Acc__c =:A.Id order by LastModifiedDate limit 499];
        else{
            Integer dd =  d -1;
            String qur = 'select id,Applicant_Name__c,prio__c,CurrentNationality__c,xcnc__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcmn__c,xcln__c,STA__c,damsgs__c from g_Req__c where isDeleted = false and LastModifiedDate = LAST_N_DAYS:'+dd+' and Acc__c =\''+A.Id+'\''; //+A.Id
            allDPRqs = database.query(qur);
        }
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(allDPRqs);
        stdSetController= ssc;
    }
    public Integer TotalPages{                                            // Total number of pages as per user selection of Records per page
        get{
            if(stdSetController.getResultSize() <=10)
                this.TotalPages=1;
            if(Math.Mod(stdSetController.getResultSize() ,stdSetController.getPageSize()) == 0)
                this.TotalPages =(stdSetController.getResultSize()/stdSetController.getPageSize());
            else
                this.TotalPages = (stdSetController.getResultSize()/stdSetController.getPageSize())+1;
            System.Debug(this.TotalPages);
            return totalpages;
        }
        set;
    }
    public Integer MaxNumberOfRecords{                                    //Maximum number of records in a query list
        get{
            return stdSetController.getRecords().size();
        }
        set;
    }
    public void next(){
        this.stdSetController.next();
    }
    public ApexPages.StandardSetController stdSetController{ get{ if(stdSetController==null){ if(allDPRqs==null||allDPRqs.size()==0) allDPRqs = new List<g_Req__c>(); List<g_Req__c> rqs= new List<g_Req__c>();  allDPRqs = [select id,Applicant_Name__c,xfpdd__c,prio__c,CurrentNationality__c,xcnc__c,AT__c,AP__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcmn__c,xcln__c,STA__c,damsgs__c,AOP__c,xadh__C,AUP__c,xcamdt__c from g_Req__c where isDeleted = false and Acc__c =: A.Id and STA__c!='Completed' order by lastmodifieddate desc limit 99];  if(isPendingTab=='pndg' ){ for(g_Req__c r : allDPRqs){ if(r.damsgs__c!=null && r.damsgs__c!='0'){ rqs.add(r);  if(rqs.size()>2){break;} } } allDPRqs= rqs;  }else{ for(g_Req__c r : allDPRqs){ rqs.add(r); if(rqs.size()>2){break;} } allDPRqs= rqs; }  stdSetController = new ApexPages.StandardSetController(allDPRqs); } stdSetController.setPageSize(RecordsPerPageslist); return stdSetController; } set; }
    
    public Pagereference getSelectedPageList(){ 
        this.stdSetController.setpageSize(RecordsPerPageslist);
        this.stdSetController.setpageNumber(integer.valueOf(pageNo));
        return null;
    }
    
    public String strAllDPRqs1{get;set;}
    public list<g_req__c> getallDPRqs1(){                               //to display records on vf page
        
        List<g_req__c> temp = (list<g_req__c>)stdSetController.getRecords();
        strAllDPRqs1 = JSON.serialize(temp); 
        System.debug('temp :  ' + temp.size() + ' ** : strAllDPRqs1 ::: ' + strAllDPRqs1 );
        return temp;
    }
    
    private void getRQs() { map < String, Decimal > mSTA = new map < String, Decimal > (); mSTA.put('Draft', 0); mSTA.put('Open', 0); mSTA.put('Under Review', 0); mSTA.put('In Process', 0); mSTA.put('On Hold', 0); mSTA.put('NC', 0); for (aggregateResult ar: [select STA__c STA, count(Id) C, SUM(nc__c) NC from g_Req__c where isDeleted = false and Acc__c =: A.Id and(STA__c = 'Draft' or STA__c = 'Open' or STA__c = 'Under Review' or STA__c = 'In Process' or STA__c = 'On Hold')  group by STA__c  ]) { mSTA.put((String) ar.get('STA'), mSTA.get((String) ar.get('STA')) + (ar.get('C') == null ? 0 : (Decimal) ar.get('C'))); if (ar.get('STA') != 'On Hold') { mSTA.put('NC', mSTA.get('NC') + (ar.get('NC') == null ? 0 : (Decimal) ar.get('NC'))); } } cD = mSTA.get('Draft') == null ? 0 : mSTA.get('Draft'); cO = mSTA.get('Open') == null ? 0 : mSTA.get('Open'); cR = mSTA.get('Under Review') == null ? 0 : mSTA.get('Under Review'); cP = mSTA.get('In Process') == null ? 0 : mSTA.get('In Process'); cH = mSTA.get('On Hold') == null ? 0 : mSTA.get('On Hold'); cC = mSTA.get('NC') == null ? 0 : mSTA.get('NC'); }  
    private void getSanctions() { if ((A.snc__c != null && A.snc__c != '') || A.lcsnc__c || A.psasnc__c || A.ecsnc__c) { mSnc = new map < string, string > (); if (A.lcsnc__c) mSnc.put('LC', A.lcsncnt__c); if (A.psasnc__c) mSnc.put('PSA', A.psasncnt__c); if (A.ecsnc__c) mSnc.put('EC', A.ecsncnt__c); if(String.isNotBlank(A.snc__c)){ for (string snc: A.snc__c.split(';')) { mSnc.put(snc, ''); } } mScSize = mSnc.keySet().size(); mScHasVal = (mSnc.keySet().size()>0)?true:false;  if (mSnc.keySet().size() > 0) { for (Sanction_Detail__c sncDt: [select id, Name, Sanction_Notes__c from Sanction_Detail__c where Name in: mSnc.keySet()]) { if (mSnc.containsKey(sncDt.Name)) { mSnc.put(sncDt.Name, sncDt.Sanction_Notes__c); } } } } }
    public List<alocpob__c> poBoxLst {get;set;}
    public void getPOBox() { poBoxLst = new List<alocpob__c>(); poBoxLst = [select id,Name,idt__c,edt__c,typ__c from alocpob__c where isDeleted = false and acc__c =: A.Id and stts__c='Active' limit 10]; if(poBoxLst != null && !poBoxLst.isEmpty()) poBox = poBoxLst[0].Name; }
    @TestVisible 
    private void getRPExpLst() {
        List<aggregateResult> rpExpLst = [select count(id),calendar_month(rped__c) from contact where accountid=:A.Id and rped__c >TODAY and rped__c <=NEXT_N_MONTHS:6 GROUP BY calendar_month(rped__c) ORDER BY calendar_month(rped__c) DESC];
    }
    @TestVisible 
    private void getPassportExpLst() {
        List<aggregateResult> pExpLst = [select count(id),calendar_month(ped__c) from contact where accountid=:A.Id and ped__c >TODAY and ped__c <=NEXT_N_MONTHS:6 GROUP BY calendar_month(ped__c) ORDER BY calendar_month(ped__c) DESC];
    }
    @TestVisible 
    private void getLeaseExpLst() { List<grqWsDccaGetService.Records> tecomd3Lst = new List<grqWsDccaGetService.Records>(); List<grqWsDccaGetService.Records> tecomLeaseLst =  grqWsDccaGetService.loadTecomCRMLoc(A.ORACLE_PARTY_ID__c); List<grqWsDccaGetService.Records> d3lsLst = grqWsDccaGetService.loadD3Loc(A.ORACLE_PARTY_ID__c); tecomd3Lst.addAll(tecomLeaseLst); tecomd3Lst.addAll(d3lsLst);   }
    private void getCs() { for (aggregateResult ar: [select count(id) C from Contact where isDeleted = false and AccountId =: A.Id and STA__c = 'Active' and rol__c = 'Employee' and createddate < LAST_N_DAYS: 179 and(lua__c = null or lua__c < LAST_N_DAYS: 179 or luas__c = null or luas__c < LAST_N_DAYS: 179) ]) { cOD += ar.get('C') == null ? 0 : (Decimal) ar.get('C'); } } 
    private void getSrvcs() { set < Id > sids; if (!gu.isPortalSuperUser(UserInfo.getProfileId()) && ispu) { sids = new set < id > (); for (g_srvcAL__c al: [select srvc__r.Id from g_srvcAL__c where isDeleted = false and usr__c =: UserInfo.getUserId() and DE__c = true]) { sids.add(al.srvc__r.Id); } } map < String, map < String, list < g_Srvc__c >>> mH = new map < String, map < String, list < g_Srvc__c >>> (); map < String, map < String, list < g_Srvc__c >>> mHMC = new map < String, map < String, list < g_Srvc__c >>> ();  for (g_Srvc__c s: [select id, uid__c, Name, lbl__c,Menu_Category__c,Category__c, Sub_Category__c from g_Srvc__c where isDeleted = false and actv__c = true and Category__c <> null and Prk__c includes(: a.Prk__c) and AccTp__c includes(: a.Type)  order by sord__c]) {  String sc = s.Sub_Category__c; if(String.isNotBlank(s.Menu_Category__c)){ for (String c: s.Menu_Category__c.split('\\;', 0)) { if (mH.get(c) == null) { mH.put(c, new map < String, list < g_Srvc__c >> ()); } if (mH.get(c).get(sc) == null) { mH.get(c).put(sc, new list < g_Srvc__c > ()); } mH.get(c).get(sc).add(s); } }  } Srvcs = new list < GL1 > (); /*sort subgroups as per schema*/ for (Schema.PicklistEntry c: g_Srvc__c.Menu_Category__c.getDescribe().getPicklistValues()) { if (mH.get(c.getLabel()) != null) { GL1 l1 = new GL1(c.getLabel()); for (Schema.PicklistEntry sc: g_Srvc__c.Sub_Category__c.getDescribe().getPicklistValues()) { if (mH.get(c.getLabel()).get(sc.getLabel()) != null) { l1.lst.add(new GL2(sc.getLabel(), mH.get(c.getLabel()).get(sc.getLabel()))); } } Srvcs.add(l1); } } system.debug('Srvcs >>'+ Srvcs); }
    
    //AXS 2.0 By JP
    private void loadContact() { myAccountLst = new List<myAccount>(); contLst = new List<contact>(); uidUsrname = new Map<String,User>(); system.debug('inisde loadContact >>'+A.Id); contLst = [select Id,Name,Personal_Photo__c,Photo_ID__c,Email,Job_Title_Formula__c, rped__c, ped__c, nc__c, rol__c,STA__c,isDeleted from Contact where AccountId =: A.Id]; system.debug('ContLst >>'+contLst); List<User> userLst = [Select id, Name, ContactId,isActive,Username, AccountID,ProfileId, Contact.Name,Contact.Personal_Photo__c,Contact.Photo_ID__c,Contact.Email, Contact.Job_Title_Formula__c, Contact.rped__c, Contact.ped__c, Contact.nc__c, Contact.rol__c,Contact.STA__c,Contact.isDeleted from User where AccountId =: A.Id]; for(User usr : userLst){ uidUsrname.put(usr.Id,usr); } system.debug('userLst >>'+userLst);  for(User u : userLst){ myAccount m = new myAccount(); m.con = u.contact; m.usr = u; m.usrPhoto = u.Contact.Photo_ID__c; if(u.isActive) { if(u.ProfileId == approverProfile) m.usrtype = 'DataEntryUser'; if(u.ProfileId == defaultProfile) m.usrtype = 'SuperUser'; } else m.usrtype = 'InActive'; myAccountLst.add(m); } system.debug('myAccountLst >>'+myAccountLst); }
    class myAccount{ public Contact con{get;set;} public User usr{get;set;} public string usrPhoto{get;set;} public string usrtype{get;set;} }
    @testVisible
    private void loadAccountLocation(){ try{  tecomLeaseList = new  List<grqWsDccaGetService.Records>(); List<grqWsDccaGetService.Records>  d3LeaseList = new  List<grqWsDccaGetService.Records>();  if(A!= null && A.ORACLE_PARTY_ID__c!=null ){ /* tecomLeaseList = grqWsDccaGetService.loadTecomCRMLoc(A.ORACLE_PARTY_ID__c);*/ system.debug('######################tecomLeaseList#############################'); system.debug(tecomLeaseList); /*d3LeaseList = grqWsDccaGetService.loadD3Loc(A.ORACLE_PARTY_ID__c);*/ } system.debug('######################d3LeaseList#############################');  if(d3LeaseList!= null && !d3LeaseList.isEmpty() && d3LeaseList.size()>0){ tecomLeaseList.addAll(d3LeaseList); } system.debug('JJJJJ tecomLeaseList11'+tecomLeaseList); finalAgreeLoc= new   map<String,String>(); for (grqWsDccaGetService.Records rec: tecomLeaseList) { finalAgreeLoc.put(rec.AgNo, rec.Products[0].UnitNumber+','+rec.Products[0].ProductName);  }   locLst = new List<loc__c>(); system.debug('ll A>>'+ A); if(a!=null && A.Id !=null) for (loc__c lc: [select Id,Name,acc__c,active__c,act__c,agrno__c,arBldg__c,arbu__c,arflr__c,aroffno__c,asf__c,Bldg__c,bu__c,cat__c,flr__c,IsActive__c,Is_frzn__c,IsMain__c,isregof__c,IsSub__c,ls_end__c,ls_std__c,lstyp__c,Loc__c,mu__c,offno__c,pyear__c,plt__c,pltarb__c,rpi__c,rqno__c,subcat__c,su__c from loc__c where acc__c =: A.Id]) { locLst.add(lc); } }catch(Exception ex){ system.debug('loadAccountLocation Ex >>'+ ex); } system.debug('locLst >> '+ locLst); }
    @testVisible
    private void loadTransaction(){ tsLst = new List<g_Tran__c>(); for (g_Tran__c ts: [select id,acc__c,Name, md__c, A__c, dt__c, STA__c from g_Tran__c  where acc__c =: A.Id ORDER BY dt__c DESC limit 6]) { tsLst.add(ts); } system.debug('tsLst >> '+ tsLst); }
    
    @testVisible
    private void enUser(Id uid, Boolean actv){ system.debug('in enUser2 >>'+uid +' || '+actv ); if(uid == null){gU.AddWarningMsg(Label.msgNoChange); return;} User u = uidUsrname.get(uid); u.IsActive = actv; update u; system.debug('updated User >>'+ u); init(); gU.AddSuccessMsg(Label.msgSuccess); }
    @testVisible
    public void enUser(){
        system.debug('in enUser');
        try{enUser(ApexPages.currentPage().getParameters().get('uid'),true);} catch(exception ex){gU.AddErrorMsg(ex);}
    }
    public void dsbUser(){
        system.debug('in dsbUser');
        try{enUser(ApexPages.currentPage().getParameters().get('uid'),false);} catch(exception ex){gU.AddErrorMsg(ex);}
    }
    
    //End : JP Changes 
    
    private void loadStats() {
        for (Contact c: [select Id, rped__c, ped__c, nc__c, rol__c from Contact where isDeleted = false and STA__c = 'Active'
                         and AccountId =: A.Id limit 499
                        ]) {
                            
                            if (c.rped__c <= Date.today() && NotGCC(c.nc__c) && (c.rol__c=='Employee'||c.rol__c=='Non Sponsored'||c.rol__c=='Access Card' ||c.rol__c=='Student') ) { //&& c.rol__c <> 'Non Sponsored' && c.rol__c <> 'Access Card' && c.rol__c <> 'Other'
                                cRPExp++;
                            }
                            
                            
                            
                            if (c.ped__c <= Date.today() && c.ped__c !=null && NotGCC(c.nc__c)  && (c.rol__c=='Employee'||c.rol__c=='Non Sponsored'||c.rol__c=='Access Card' ||c.rol__c=='Student')) {
                                cPSExp++;
                            } else if (Date.today().addDays(30) >= c.ped__c && NotGCC(c.nc__c)  && (c.rol__c=='Employee'||c.rol__c=='Non Sponsored'||c.rol__c=='Access Card' ||c.rol__c=='Student')) {
                                cPSExp30++;
                            }
                        }
        for (Contact ct: [select Id, rped__c, ped__c, nc__c, rol__c from Contact where isDeleted = false and STA__c = 'Active'
                          and AccountId =: A.Id and rped__c = NEXT_N_DAYS: 30
                         ]) {
                             if (NotGCC(ct.nc__c) && (ct.rol__c=='Employee'||ct.rol__c=='Non Sponsored'||ct.rol__c=='Access Card' ||ct.rol__c=='Student')) {
                                 cRPExp30++;
                             }
                         }
    }
    private boolean NotGCC(String nationality) {
        if (nationality <> 'Bahrain' && nationality <> 'Kuwait' && nationality <> 'Oman' && nationality <> 'Qatar' && nationality <> 'Saudi Arabia' && nationality <> 'United Arab Emirates') {
            return true;
        } else {
            return false;
        }
    }
    
    
    public PageReference getLicenseCopy(){ String lc= apexpages.currentpage().getparameters().get('lc'); if(ispu){lc=A.lc__c;} String jsonResp = grqWsDccaGetService.getLicenseCopy(lc); Map<String, Object> metadata_Map = (Map<String, Object>) JSON.deserializeUntyped(jsonResp); licCopy=(String)metadata_Map.get('body'); return null; }
    
    public PageReference  getDocument(){ String lc= apexpages.currentpage().getparameters().get('lc'); dc= apexpages.currentpage().getparameters().get('dc'); System.debug('<getDocument:: > dc: ' + dc); if(String.isNotBlank(dc)){ if(ispu && String.isBlank(lc)){lc=A.lc__c;} /*19072*/licCopy = grqWsDccaGetService.getDocument(lc,dc); } return null; }
    
    private void getVisitors() { AggregateResult ar = [select count(id) C from g_Req__c where(isDeleted = false AND Acc__c =: A.Id) AND(srvc__r.uid__c = '058' OR srvc__r.uid__c = '074' OR srvc__r.uid__c = '096' OR srvc__r.uid__c = '097') AND((STA__c != 'Rejected' AND STA__c != 'Cancelled' AND CreatedDate = THIS_MONTH) OR STA__c = 'Open' OR STA__c = 'Draft')]; if (ar == null) { return; } if (ar.get('C') == null) { return; } VVU = (Decimal) ar.get('C'); }
    
     //Start CB 5 Feb 2025
    public boolean checkDisplayPSAPopup(){
        User currentUser = [SELECT Contact.Type__c, Contact.Name,Contact.Account.lc__c,Contact.Account.stapsa__c,Contact.Account.lcsta__c,Contact.Account.Legal_Framework__c, Contact.Account.Id 
                            FROM User
                            WHERE Id =: UserInfo.getUserId()];
        Account currentAccount = currentUser.Contact.Account;
        agreementDate = Date.today();
        System.debug('currentUser' + currentUser);
        if(String.isNotEmpty(currentAccount.lc__c) && currentAccount.lcsta__c == 'License Issued' && currentAccount.stapsa__c != 'Signed' && currentAccount.Legal_Framework__c != 'Freelancer'){
            managerInCharge = currentUser.Contact.Name;
            return true;
        }
        return false;
    }
    
    // End CB
    public list < GL1 > Srvcs { get; set; } public list < GL1 > SrvcCategory { get; set; } public map < string, string > mSnc { get; set; } public class GL1 { public String lbl { get; set; } public list < GL2 > lst { get; set; } public GL1(String v) { lbl = v; lst = new list < GL2 > (); } } public class GL2 { public String lbl { get; set; } public list < g_Srvc__c > lst { get; set; } public GL2(String v, list < g_Srvc__c > l) { lbl = v; lst = l; }
                                                                                                                                                                                                                                                                                                                     }
    /***************User Management Code Starts*******************/ 
    /*public List<mySerivceGroupRequest> servOptions {get;set;}//added for User Management
public List<Contact> myAccountEmployeeLst{get;set;}//added for User Management
public String myAccEmpStr {get;set;}//added for User Management
Public List<mySerivceGroupRequest> orgSrvOpt{get;set;}
public List<myEmployees> myEmpLst {set;get;}
public List<myEmployees> myEmpLst2 {set;get;}
public string firstName {set;get;}
public string lastName {set;get;}
public Boolean firstTimeLoad {set;get;}
public string passNumber {set;get;}
public string nationality {set;get;}
public string emailId {set;get;}
public string CounCode {set;get;}
public string phNo {set;get;}
public string addVal {set;get;}
public string WrkCounCode {set;get;}
public string wrkphNo {set;get;}
public string username {set;get;}
public Boolean defaultGroupsAccess {get;set;}
public String searchWord {get;set;}
public Integer selectedIndex {get;set;}
public Contact selectedEmp {get;set;}
public User selectedUs {get;set;}
public Boolean conExist {get;set;}
public Boolean UsrExist {get;set;}
public Boolean UsrExistWithAnotherAcc{get;set;}
public String pgMsg{get;set;}
public String finalResult{get;set;}
public String accessFrom{get;set;}
public String finalResultMsg{get;set;}
public String conId{get;set;}
public String UsrId{get;set;}
public g_Req__c DummpyReq{get;set;}
public Boolean contactExistWithSameAcc{get;set;}
public Boolean contactExistWithDiffAcc{get;set;}
public Boolean contactAlreadyExisits{get;set;}
public Contact foundContact{get;set;}
public Boolean showAddButton{get;set;}
public Map<String,list<Wrap>> mH {get;set;}
public List<SelectOption> regions
{
get
{
List<SelectOption> options = new List<SelectOption>();
Schema.DescribeFieldResult fieldResult = contact.nc__c.getDescribe();
List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

for( Schema.PicklistEntry f : ple)
options.add(new SelectOption(f.getLabel(), f.getValue()));
return options;
}
}

public void loadEmployeeContact() {
integer i=1;
firstTimeLoad = true;
accessFrom = null;
DummpyReq = new g_Req__c();
List<myEmployees> empLst = new List<myEmployees>();
Map<Integer,Contact> mContact = new Map<Integer,Contact>();
myAccountEmployeeLst = [select Id,FirstName,LastName,Name,Personal_Photo__c,Photo_ID__c,Email,Job_Title_Formula__c, rped__c, ped__c, nc__c, 
rol__c,STA__c,isDeleted,p__c from Contact where AccountId =: A.Id AND rol__c='Employee' limit 499];

selectedEmp = new Contact();
loadEmployeeData();
system.debug('myAccountLst >>'+myAccountEmployeeLst); 
for(Contact con: myAccountEmployeeLst){
myEmployees emp = new myEmployees();
emp.IdVal = con.Id;
emp.conName = con.Name;
emp.conJobTitle = con.Job_Title_Formula__c;
emp.conPassNo = con.p__c;
emp.conImg = '/servlet/servlet.FileDownload?file='+con.Photo_ID__c;
empLst.add(emp);
}
myEmpLst = empLst;
myEmpLst2 = empLst;
myAccEmpStr = JSON.serialize(empLst);
System.debug('=======myAccEmpStr======='+myAccEmpStr);
Integer noofUserallowed = Integer.valueof([Select mxPortalUsers__c from Account where Id=: A.Id].mxPortalUsers__c);
User U = [select Id,AccountId, Contact.Account.mxPortalUsers__c from User where id=: UserInfo.getUserId() limit 1];
integer maxAllow = U.Contact.Account.mxPortalUsers__c==null?0:integer.valueOf(U.Contact.Account.mxPortalUsers__c);
List<User> users=[select Id from User where AccountId =: U.AccountId and IsActive=true];
if(maxAllow==1 || users.size()>= maxAllow ){
showAddButton = false;
}
else{
showAddButton = true;
}

}

public void loadEmployeeData() {
System.debug('=======loadEmployeeData======='+Apexpages.currentPage().getParameters().get('selInd'));
System.debug('=======loadEmployeeData======='+Apexpages.currentPage().getParameters().get('acsType'));
accessFrom = String.valueOf(Apexpages.currentPage().getParameters().get('acsType'));
if((Apexpages.currentPage().getParameters().get('selInd')) != null){
firstTimeLoad = false;
System.debug('#900=======x======='+Apexpages.currentPage().getParameters().get('selInd'));
String val = String.valueOf(Apexpages.currentPage().getParameters().get('selInd'));
String prcType = String.valueOf(Apexpages.currentPage().getParameters().get('acsType'));
accessFrom = prcType;
System.debug('#944=======val.length'+val.length());
if(val.length()<15){
Integer ind = Integer.valueOf(Apexpages.currentPage().getParameters().get('selInd'));
selectedEmp = myAccountEmployeeLst.get(ind-1);
}else{
selectedEmp = [select Id,FirstName,LastName,Name,Personal_Photo__c,Photo_ID__c,Email,Job_Title_Formula__c, rped__c, ped__c, nc__c, 
rol__c,STA__c,isDeleted,p__c,MobilePhone,MailingAddress,ha__c,OtherPhone from Contact where Id=: val LIMIT 1];
}
System.debug('#952=======selectedEmp'+selectedEmp);
conExist = true;
firstName= selectedEmp.FirstName;
lastName= selectedEmp.LastName;
passNumber= selectedEmp.p__c;
nationality= selectedEmp.nc__c;
emailId= selectedEmp.Email;
phNo = selectedEmp.MobilePhone;
wrkphNo = selectedEmp.OtherPhone;
addVal = selectedEmp.ha__c;
checkUserExist(selectedEmp);
checkUserExistWithAnotherAcc();
if(UsrExistWithAnotherAcc){
pgMsg ='There is an existing User with same Email for another account do you still want to add to this Account.';
String usnm = A.Name;
username = emailId+'.'+usnm.deleteWhitespace();
}
if(UsrExist){
mH = new map<String,list<Wrap>>();
for(g_Srvc__c s:[select id,uid__c,Name,lbl__c,Category__c,Sub_Category__c,Service_Group__c,
(Select Id,DE__c,AP__c,usr__c From g_srvcAL__r where isDeleted = false and usr__c=:selectedUs.Id) 
from g_Srvc__c where isDeleted=false and actv__c=true and Service_Group__c <> null and Prk__c includes (:A.Prk__c) and AccTp__c includes (:A.Type)]){
String c =s.Service_Group__c.split('\\;',0)[0];
if(mH.get(c)==null)
{
mH.put(c,new list<Wrap>());
}
if(s.g_srvcAL__r.size()>0)
{
mH.get(c).add(new Wrap(s,s.g_srvcAL__r[0]));
} 
else 
{
mH.get(c).add(new Wrap(s,new g_srvcAL__c(AP__c=false, DE__c=false, srvc__c=s.Id, usr__c=selectedUs.Id)));
}
}
System.debug('======mH=====922'+mH);
List<mySerivceGroupRequest> servOpt = new List<mySerivceGroupRequest>();
for(String grpName : mH.keyset())
{
mySerivceGroupRequest sr = new mySerivceGroupRequest();
sr.grpName = grpName;
for(Wrap wrp : mH.get(grpName))
{
if(wrp.al.DE__c)
sr.grpDE = true;
else{
sr.grpDE = false;
break;
}    
}
for(Wrap wrp : mH.get(grpName))
{
if(wrp.al.AP__c)
sr.grpAE = true;
else{
sr.grpAE = false;
break;
}    
}
servOpt.add(sr);
}
System.debug('======servOptions=====946'+servOpt);
servOptions = servOpt;
orgSrvOpt = servOpt;
}

else{
loadSerivceList();
}
}
if(firstTimeLoad)
{
firstName= 'Please enter you First name';
lastName= 'Please enter you Last name';
passNumber= 'Please enter you Passport Number';
emailId= 'Please enter you email address';
CounCode='+971';
phNo='Please enter your mobile number';
addVal='';
WrkCounCode='+971';
wrkphNo='Please enter your work number';
username='Please enter your prefered username';
conExist = false;
UsrExist = false;
loadSerivceList(); 
}

}

public void loadSerivceList() {
servOptions = new List<mySerivceGroupRequest>();
Schema.DescribeFieldResult fieldResult = g_Srvc__c.Service_Group__c.getDescribe();
List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

for( Schema.PicklistEntry f : ple){
mySerivceGroupRequest sr = new mySerivceGroupRequest();
sr.grpName = f.getLabel();
sr.grpDE = false;
sr.grpAE = false;
servOptions.add(sr);
}
orgSrvOpt = servOptions;
}



public PageReference addUser(){
system.debug('#1073=====Inside AddUser====');
list<g_srvcAL__c> toInsertAL = new list<g_srvcAL__c>();
list<g_srvcAL__c> toDeleteAL = new list<g_srvcAL__c>();
AggregateResult[] muids= [select MAX(uid__c) from User]; 
String unqVal = nationality+passNumber;
Savepoint sp = null;
try{
if(conExist && UsrExist)
{
system.debug('#1077=====servOptions===='+servOptions);
system.debug('#1077=====servOptions===='+orgSrvOpt);
for(mySerivceGroupRequest serReq : servOptions){
for (mySerivceGroupRequest serReq1 : orgSrvOpt){
system.debug('#1083=====serReq===='+serReq);
system.debug('#1083=====serReq1===='+serReq1);
if(serReq.grpName == serReq1.grpName){
if((serReq.grpDE != serReq1.grpDE)||(serReq.grpAE != serReq1.grpAE)){
if(serReq.grpDE == true && serReq.grpAE == true){
for(Wrap wrp : mH.get(serReq.grpName))
{

g_srvcAL__c tempal = wrp.al;
system.debug('#1092=====before tempal===='+tempal);
tempal.DE__c = true;
tempal.AP__c = true;
system.debug('#1095=====after tempal===='+tempal);
toInsertAL.add(tempal);
}
}
if(serReq.grpDE == false && serReq.grpAE == false){
for(Wrap wrp : mH.get(serReq.grpName))
{
g_srvcAL__c tempal = wrp.al;
toDeleteAL.add(tempal);
}
}
if(serReq.grpDE == true && serReq.grpAE == false){
for(Wrap wrp : mH.get(serReq.grpName))
{
g_srvcAL__c tempal = wrp.al;
tempal.DE__c = true;
tempal.AP__c = false;
toInsertAL.add(tempal);
}
}
if(serReq.grpDE == false && serReq.grpAE == true){
for(Wrap wrp : mH.get(serReq.grpName))
{
g_srvcAL__c tempal = wrp.al;
tempal.DE__c = false;
tempal.AP__c = true;
toInsertAL.add(tempal);
}
}
}    
}
}
}
}
else if(conExist && (UsrExist!=true) && (UsrExistWithAnotherAcc!=true)){
System.debug('=========inside else if======='+conExist);
System.debug('=========inside else if======='+selectedEmp);
User us = createUser(selectedEmp);
if(defaultGroupsAccess){

for(g_Srvc__c ser: [select id,uid__c,Name,lbl__c,Category__c,Sub_Category__c,Service_Group__c 
from g_Srvc__c where isDeleted=false and actv__c=true and Service_Group__c <> null and Prk__c includes (:A.Prk__c) and AccTp__c includes (:A.Type)]){
toInsertAL.add(new g_srvcAL__c(AP__c=true,DE__c=true,srvc__c=ser.Id,usr__c=us.Id));
}
System.debug('=========toInsertAL======='+toInsertAL);

}
else{
System.debug('=======ServicesList======'+servOptions);
for(mySerivceGroupRequest serReq : servOptions){
if(serReq.grpDE || serReq.grpAE){
for(g_Srvc__c ser : [select id,uid__c,Name,lbl__c,Category__c,Sub_Category__c,Service_Group__c 
from g_Srvc__c where isDeleted=false and actv__c=true and Service_Group__c includes (:serReq.grpName)
and Prk__c includes (:A.Prk__c) and AccTp__c includes (:A.Type)]){
toInsertAL.add(new g_srvcAL__c(AP__c=serReq.grpAE,DE__c=serReq.grpDE,srvc__c=ser.Id,usr__c=us.Id)); 
} 
}

}
}
}
else
{
System.debug('=========inside else======='+contactExistWithDiffAcc);
System.debug('=========inside else======='+UsrExistWithAnotherAcc);
Contact newCon = createContact();
User newUser1 = createUser(newCon);

System.debug('=========defaultGroupsAccess======='+defaultGroupsAccess);
if(defaultGroupsAccess){

for(g_Srvc__c ser: [select id,uid__c,Name,lbl__c,Category__c,Sub_Category__c,Service_Group__c 
from g_Srvc__c where isDeleted=false and actv__c=true and Service_Group__c <> null and Prk__c includes (:A.Prk__c) and AccTp__c includes (:A.Type)]){
toInsertAL.add(new g_srvcAL__c(AP__c=true,DE__c=true,srvc__c=ser.Id,usr__c=newUser1.Id));
}
System.debug('=========toInsertAL======='+toInsertAL);

}
else{
System.debug('=======ServicesList======'+servOptions);
for(mySerivceGroupRequest serReq : servOptions){
if(serReq.grpDE || serReq.grpAE){
for(g_Srvc__c ser : [select id,uid__c,Name,lbl__c,Category__c,Sub_Category__c,Service_Group__c 
from g_Srvc__c where isDeleted=false and actv__c=true and Service_Group__c includes (:serReq.grpName)
and Prk__c includes (:A.Prk__c) and AccTp__c includes (:A.Type)]){
toInsertAL.add(new g_srvcAL__c(AP__c=serReq.grpAE,DE__c=serReq.grpDE,srvc__c=ser.Id,usr__c=newUser1.Id)); 
} 
}

}
}
}
System.debug('#1176=======toInsertAL======'+toInsertAL);
System.debug('#1176=======toDeleteAL======'+toDeleteAL);
if(toInsertAL.size()>0)
Upsert toInsertAL;
if(toDeleteAL.size()>0)
Delete toDeleteAL;

PageReference pageWhereWeEndUp = new PageReference('/myaccount'); //create a PageReference object for the Home tab
return pageWhereWeEndUp.setRedirect(true);

}catch(exception ex)
{
throw new DMLException(ex);
//return null;
} 

}
public void accessDefaultCntrl(){
List<mySerivceGroupRequest> servOptions1 = new List<mySerivceGroupRequest>();
system.debug('#1180======defaultGroupsAccess'+defaultGroupsAccess);
if(defaultGroupsAccess){
for( mySerivceGroupRequest f : servOptions){
mySerivceGroupRequest sr = new mySerivceGroupRequest();
sr.grpName = f.grpName;
sr.grpDE = true;
sr.grpAE = true;
servOptions1.add(sr);
}
servOptions = servOptions1; 
}
else{
servOptions = orgSrvOpt;
}

}

public void checkUserExist(Contact Con){
List<User> usLst = [select Id,ProfileId,FirstName,LastName,accountid,contact.account.id,contact.account.Name,contact.account.Type,contact.account.Prk__c 
from User where IsActive=true and ContactId=:Con.Id and contact.account.id=:A.Id ];
System.debug('#1203=====checkUserExist'+usLst);
if(usLst.size()>0){
UsrExist = true;
selectedUs = usLst[0];
}
else{
UsrExist = false;
}
}
public void checkUserExistWithAnotherAcc(){
List<User> usLst = [select Id,ProfileId,FirstName,LastName,Email,accountid,contact.account.id,contact.account.Name,contact.account.Type,contact.account.Prk__c 
from User where IsActive=true and Email=:emailId and contact.account.id!=:A.Id];
System.debug('#1203=====checkUserExistWithAnotherAcc'+usLst);
if(usLst.size()>0){
UsrExistWithAnotherAcc = true;
pgMsg ='There is an existing User with same Email for another Account : '+usLst[0].contact.account.Name+'Do you still want to add to this Account.';
String usnm = A.Name;
username = emailId+usnm.deleteWhitespace();
}
else{
UsrExistWithAnotherAcc = false;
pgMsg='';
}
}
public Id approverProfile = [Select Id From Profile Where Name='X' LIMIT 1].Id;
public Id defaultProfile = [Select Id From Profile Where Name='Z' LIMIT 1].Id;

public User createUser(Contact newCon){
User nwU;
try{
AggregateResult[] muids= [select MAX(uid__c) from User];  

string nick = newCon.email!=null?newCon.email.substring(0, newCon.email.indexOf('@')):'';
nick += Datetime.now().getTime();
String ala = firstName.substring(0, 3)+lastname.substring(0, 2);
Id prfId;
if(defaultGroupsAccess)
prfId = defaultProfile;
else
prfId = approverProfile;
String usNm;
if(UsrExistWithAnotherAcc)
usNm = username;
else
usNm = newCon.email+'.axsqa';
System.debug('profileid==='+prfId);
System.debug('username==='+usNm);
System.debug('newCon==='+newCon.id);
System.debug('newCon==='+newCon.FirstName);
/*newUser1 = new User(alias=ala, 
email = newCon.email, 
emailencodingkey = 'ISO-8859-1', 
firstname = newCon.firstName, 
lastname = newCon.lastname, 
languagelocalekey = 'en_US',
localesidkey = 'en_US',
contactId = newCon.Id,
timezonesidkey = 'Asia/Dubai',
username = usNm,
CommunityNickname = nick,
ProfileId = prfId, 
IsActive = true);*/
    /* nwU = new User();
nwU.ContactId=newCon.Id;
nwU.FirstName = newCon.firstName;nwU.LastName = newCon.lastname;nwU.Alias=newCon.lastname.substring(0,1)+String.ValueOf(Integer.ValueOf(muids[0].get('expr0'))+1);
nwU.Email = newCon.email;nwU.Username = usNm;
nwU.ProfileId=prfId;nwU.CommunityNickname = newCon.firstName+String.ValueOf(Integer.ValueOf(muids[0].get('expr0'))+1);nwU.IsActive=true;nwU.TimeZoneSidKey = 'Asia/Dubai';
nwU.LocaleSidKey = 'en_GB';nwU.LanguageLocaleKey = 'en_US';nwU.EmailEncodingKey = 'ISO-8859-1';
Database.DMLOptions dmo = new Database.DMLOptions();
dmo.EmailHeader.triggerUserEmail = true;
nwU.setOptions(dmo);
//insert nwU; 

insert nwU;
}catch(Exception e){system.debug(e.getStackTraceString());}
return nwU;

}

public Contact createContact(){
String psNum;
if(contactExistWithDiffAcc)
psNum = passNumber+'\\c';
else
psNum = passNumber;
Contact newCon = New Contact(FirstName = firstName,
LastName =lastName,
p__c = psNum, 
nc__c = nationality, 
Email= emailId, 
ha__c = addVal,
STA__c = 'Active',
HomePhone=WrkCounCode+wrkphNo,
MobilePhone=CounCode+phNo,
AccountId=A.Id);
Insert newCon;
return newCon;
}
public Contact updateContact(){
String unqiVal = nationality+passNumber;
System.debug('unqiVal===='+unqiVal);
Contact con = [select Id,FirstName,LastName,Name,Personal_Photo__c,Photo_ID__c,Email,Job_Title_Formula__c, rped__c, ped__c, nc__c, 
rol__c,STA__c,isDeleted,p__c,Account.Name,Account.Id,MobilePhone from Contact where uid__c=: unqiVal LIMIT 1];
con.Email = emailId;
con.MobilePhone = phNo;
con.OtherPhone = wrkphNo;
con.ha__c = addVal;

Update con;
return con;
}
public void validateUnique(){
System.debug('passport number===='+passNumber);
System.debug('Nationality===='+nationality);
String unqiVal = nationality+passNumber;
System.debug('unqiVal===='+unqiVal);
List<Contact> conLst = [select Id,FirstName,LastName,Name,Personal_Photo__c,Photo_ID__c,Email,Job_Title_Formula__c, rped__c, ped__c, nc__c, 
rol__c,STA__c,isDeleted,p__c,Account.Name,Account.Id from Contact where uid__c=: unqiVal];
if(conLst.size()>0)
{
if(conLst[0].Account.Id == A.Id){
pgMsg ='The contact already exists in your Account.';
contactExistWithSameAcc = true;
contactExistWithDiffAcc = false;
contactAlreadyExisits = true;
foundContact = conLst[0];
}else{
pgMsg ='The contact already exists in system under Account:'+conLst[0].Account.Name+'.Do you still want to add to this Account?';
contactAlreadyExisits = true;
contactExistWithDiffAcc = true;
contactExistWithSameAcc = false;
foundContact = conLst[0];
}

}else{
pgMsg ='';
contactExistWithSameAcc = false;
contactExistWithDiffAcc = false;
contactAlreadyExisits = false;
}

}
public void clearDataCntrl(){
selectedEmp = new Contact();

firstName= '';
lastName= '';
passNumber= '';
emailId= '';
CounCode='+971';
phNo='';
addVal='';
WrkCounCode='+971';
wrkphNo='';
username='';
conExist = false;
UsrExist = false;
loadSerivceList();

}

public class mySerivceGroupRequest{
public String grpName{get;set;}
public Boolean grpDE{get;set;}
public Boolean grpAE{get;set;}
}

class myEmployees{
public String IdVal{get;set;}
public String conName{get;set;}
public string conJobTitle{get;set;}
public string conPassNo{get;set;}
public string conImg{get;set;}
}

public class Wrap{
public g_Srvc__c s{get;set;} 
public g_srvcAL__c al{get;set;}
public Wrap(g_Srvc__c oS,g_srvcAL__c oAL)
{
s=oS;
al=oAL;
} 
}

/***************User Management Code Ends*******************/
}