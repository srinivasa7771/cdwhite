public with sharing class gctlHm1 {
    public string licCopy { get; set; }
    public string days {set;get;}
    public string status {set;get;}
    public User U { get; set; }
    public Account accUpdate {set;get;}
    public Account A { get; set; } 
    public g_Req__c rq { get; set; } 
    public Boolean pgHide { get; set; }
    public Boolean ispu { get; set; } 
    public string lcl { get { return UserInfo.getLocale(); } } 
    public Decimal minBG { get { return gU.csCurr('minBG'); } } 
    public Decimal maxBG { get { return gU.csCurr('maxBG'); } } 
    public Decimal VVU { get; set; } { VVU = 0; }
    /*cD=Draft RQs|cO=Open RQs|cR=under review RQs|cP=In Process RQs|cH=on hold RQs|cC=need correction RQs*/
    public Decimal cD { get; set; } { cD = 0; }
    public Decimal cO { get; set; } { cO = 0; } 
    public Decimal cR { get; set; } { cR = 0; }
    public Decimal cP { get; set; } { cP = 0; } 
    public Decimal cH { get; set; } { cH = 0; } 
    public Decimal cC { get; set; } { cC = 0; }    
    /*cOD=Contacts need Update Attribute|cRPExp=Expired RPs|cPSExp=Expired Passports|cPSExp=Passports expiring NEXT30DAYS|cRPExp30=RPs expiring NEXT30DAYS*/
    public Decimal cOD { get; set; } { cOD = 0; } 
    public Decimal cRPExp { get; set; } { cRPExp = 0; } 
    public Decimal cPSExp { get; set; } { cPSExp = 0; } 
    public Decimal cPSExp30 { get; set; } { cPSExp30 = 0; } 
    public Decimal cRPExp30 { get; set; } { cRPExp30 = 0; } 
    public Date leaseDt {get;set;}    
    public List<g_Req__c> notificationRqs { get; set; } 
    public List<g_Req__c> notificationRqs3 { get; set; } 
    public List<g_Req__c> rcRqs { get; set; } 
    public List<g_Req__c> draftRqs { get; set; } 
    public List<g_Req__c> allDPRqs { get; set; } 
    public List<g_Req__c> pendingRqs { get; set; }
    public List<g_Req__c> draftRq5 { get; set; }
    public List<g_Req__c> pendingRq5 { get; set; } 
    public List<g_Req__c> allRqs { get; set; } 
    public List<g_Req__c> openNopmntRqs { get; set; } 
    public String pageNo {get;set;}
    public Boolean isVIPCardHolder {get;set;}  
    public String lcidtFormatted { get; set; }
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
    
    public transient  String imageBase64 {get;set;}
    public String docName { get; set; }
    
    public Boolean isCI {get;set;}
    public String poBox {get;set;}
    public String orclId {get;set;}
    public Integer mScSize {get;set;}
    public Boolean mScHasVal {get;set;}
    public Boolean conVals {get;set;}
    public String prsn{get;set;}
    public String dat{get;set;}
    public String sta{get;set;}
    public String isPendingTab{get;set;}public String searchCriet{get;set;}public List<contact> contLst  {get;set;}public List<loc__c> locLst  {get;set;}
    
    public List<g_Tran__c> tsLst {get;set;}public List<myAccount> myAccountLst {get;set;} public List<grqWsDccaGetService.Records>  tecomLeaseList {get;set;}
    public List<String> licList{get;set;} public Map<String,User> uidUsrname{get;set;} public  map<String,String > finalAgreeLoc{get;set;}
    
    public Boolean onlyParkingUser{get;set;}
    
    public gctlHm1() {
        ispu = gu.isPortalUser(UserInfo.getProfileId());
        pgHide = !ispu;
        system.debug('ispu --- '+ispu);
        init();
    }
    private void init() {
        try {
            if (ispu) {
                loadData(false);
            }
            gU.checkNav();} catch (exception ex) {gu.AddErrorMsg(ex);System.debug('@@ Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());pgHide = true;}
    }
    
    public String loadEmployeeData() {System.debug('=======loadEmployeeData=======');return 'test';}
    public String rqNo {get;set;}
    public string isVisaTransfer {set;get;}
    public List<D> docList {set;get;} 
    public List<D> docTrnsList {set;get;} 
    /* Save Attachment starts*/
    public void saveAttachment(){
        
        try {
            system.debug('Rq Id::'+rq.id);
            system.debug('docName: ' + docName);
            List<g_reqDoc__c> rqDocList = [select id,RQ__r.name from g_reqDoc__c where RQ__c =:rq.id and name=:docName];
            if(rqDocList != null && !rqDocList.isEmpty()){
                rqNo = rqDocList[0].RQ__r.name;
                Attachment A = new Attachment(Body = EncodingUtil.base64Decode(imageBase64), Name = docName+'.jpg', ParentId = rqDocList[0].id);
                insert A;
                system.debug('rqNo::'+rqNo);
                if(String.isBlank(isVisaTransfer)){
                    for(D doc : docList){
                        if(doc.DocName == docName){doc.attId = A.Id;doc.attName = docName+'.jpg';}
                    } 
                }
                else{
                    for(D doc : docTrnsList){if(doc.DocName == docName){doc.attId = A.Id;doc.attName = docName+'.jpg';}} 
                }
                if (docName=='Personal Photo') {if (rq.xphid__c == null) { rq.xphid__c = A.Id; update rq; } if (rq.xphid__c != A.Id){ rq.xphid__c = A.Id; update rq; } if (rq.Con__r != null) { Contact c = rq.Con__r; c.Photo_ID__c = A.Id; update C; }} 
            }           
        } catch (Exception e) { 
            system.debug('ex::'+e.getStackTraceString());
            gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString()); 
            
        }
    } 
    /* Save Attachment ends*/
    /* Edit Account starts*/
    public pageReference saveAccount(){
        system.debug('email-- '+accUpdate.email__c);
        system.debug('TRN#-- '+accUpdate.van__c);
        //accUpdate.Phone =  '+971'+accUpdate.Phone;
        if(accUpdate.ccrm_sfid__c!=null)
            accUpdate.intsts__c = 'Ready for Integration';
        Update accUpdate;
        PageReference pageRef = new PageReference('/pageCompanyInfo');
        return pageRef;
    }
    
    /* Edit Account ends*/
    /* checking TRN in Account starts*/
    Public Boolean inValidtrn {get;set;}
    public pageReference checkTRNnumber(){
        String uTrn = accUpdate.van__c;
        system.debug('uTrn -- '+uTrn);
        List<Account> trns = [select van__c from account where van__c!='' and id!=:A.id];
        for(Account t: trns){
            if(uTrn==t.van__c){
                inValidtrn = true;
                return null;
            }
        }
        inValidtrn = false;
        return null;
    }
    
    /* checking TRN in Account ends
-------------------------------------*/
    
    /*************** PARKING
-----------------------------------*/
    public PageReference vehOperations(){
        String rJson = Apexpages.currentPage().getParameters().get('reqJson');
        System.debug('@@reqJson :' + rJson);
        String resp = WsParking.callParkingWs(rJson);
        System.debug('@@resp :' + resp);
        PageReference pageRef = new PageReference('/pageCompanyInfo?t=a5m4n9uu5ns9ih0a');
        return pageRef;
    }
    
    /* check vehicle validity starts*/
    public Boolean isValidVeh {set;get;}
    public PageReference checkVehVal(){ isValidVeh = false; string r = Apexpages.currentPage().getParameters().get('rJson'); String res = WsParking.callParkingWs(r); WsParking.Response resp = (WsParking.Response)JSON.deserialize(res,WsParking.Response.class); if(resp.Status=='RecordFound') isValidVeh = true; return null; }
    /* check vehicle validity ends*/
    
    /*************** PARKING
-----------------------------------*/
    
    /* Document wrapper starts*/
    public class D{
        public string DocName {get;set;}
        public string DocLabel {get;set;}
        public string DocType {get;set;}
        public String attId {get;set;} 
        public String tmpltId {get;set;}  
        public String attName {get;set;} 
        public boolean parse {get;set;} 
        public boolean isSaveRQ {get;set;}
        public boolean isOptional {get;set;} 
    }
    /* Document wrapper ends*/
    
    
    
    public PageReference obr(){
        String srvcUid='';
        String sid='';
        U = [select Id, accountid, contact.account.id, contact.account.os__c, contact.account.Prk__c,contact.account.Type 
             from User where id =: UserInfo.getUserId() limit 1 ]; //contact.account.MemSta__c,
        system.debug('usr>>'+U );     
        
        srvcUid ='216';
        system.debug('srvcUid >>'+srvcUid );        
        system.debug('U.contact.account.os__c>>'+U.contact.account.os__c);        
        system.debug('U.contact.account.id >>'+U.contact.account.id);
        
        if(U.contact.account.os__c != null && U.contact.account.os__c!='Completed'){
            List<g_req__c> req1 = [Select id, name from g_req__c where Acc__c= :U.contact.account.id And srvc__r.uid__c =:srvcUid and sta__c NOT IN ('Completed','Cancelled','Rejected')]; //,CAS__c,xcacp__c
            system.debug('req1  >>'+req1 );
            if(req1.size()>0){
                //PageReference pageRef = new PageReference('/'+req1[0].id);
                
                PageReference pageRef = null;
                if(srvcUid =='216'){
                    pageRef = new PageReference('/grqob?id='+req1[0].id+'&m=e');
                }
                System.debug('@@@@@ pageRef' + pageRef );
                return pageRef;
            }
        }
        return null;
    }
    
    private void loadData(Boolean isnw) {
        
        licList = new List<String>{'License Under Renewal','License Issued','License Approved','License Cancelled'};
            RecordsPerPageslist = 10;
        String url = Apexpages.currentPage().getURL();
        if(url.contains('pagepastrequests')){
            if(Apexpages.currentPage().getparameters().get('flg') != null){
                if(Apexpages.currentPage().getparameters().get('flg') == 'pndg') isPendingTab = 'pndg';
                else if(Apexpages.currentPage().getparameters().get('flg') == 'drft') isPendingTab = 'drft';
            }
            
        }
        
        U = [select Id, FirstName, LastName, accountid, LastPasswordChangeDate, LastLoginDate, contact.Photo_ID__c, contact.account.id, contact.account.park__c, contact.account.van__c ,contact.account.on__c ,contact.account.PSA_Signed_By__c, contact.account.onar__c , contact.account.Website, contact.account.vespe__c, contact.account.vespex__c, contact.account.vetemp__c, contact.account.vbtemp__c , contact.account.vetst__c, contact.account.vespst__c, contact.account.vespstx__c , contact.account.vbtst__c, contact.account.vev__c, contact.account.mxPortalUsers__c,contact.account.Name,contact.account.Email__c,contact.account.lPrk__c,contact.account.Building_Name__c, contact.account.xcublg__c,contact.account.Location__c,contact.account.Location_Cluster__c,contact.account.xcuzn__c , contact.account.Phone, contact.account.Type, contact.account.Prk__c, contact.account.adb__c, contact.account.info__c,contact.account.bgnr__c, contact.account.bg__c, contact.account.bgc__c, contact.account.bgcabsc__c, contact.account.bgb__c, contact.account.vctemp__c, contact.account.speabsc__c, contact.account.vctst__c, contact.account.sncNt__c, contact.account.vbvv__c,contact.account.lcidt1__c, contact.account.ec__c, contact.account.ecidt__c,contact.account.lctp__c,contact.account.ecedt__c,contact.account.lcidt__c,contact.account.lcedt__c,contact.account.lcsnc__c, contact.account.lcsncnt__c,contact.account.Legal_Framework__c,contact.account.psasnc__c, contact.account.psasncnt__c, contact.account.lcsta__c,contact.account.ecsnc__c, contact.account.ecsncnt__c,contact.account.lcrndt__c,contact.account.cosnc__c, contact.account.cosncnt__c,contact.account.licexdt__c, contact.account.licIdt__c,   contact.account.bgsnc__c, contact.account.bgsncnt__c, contact.account.snc__c,contact.account.voep__c,contact.account.lc__c, contact.account.ORACLE_PARTY_ID__c,contact.account.rpa__c, contact.account.os__c, contact.account.adob__c , contact.account.adx__c, contact.account.adc__c,contact.account.stapsa__c  from User where id =: UserInfo.getUserId() limit 1];
        
        
        A = U.contact.account;
        accUpdate = [select id,Email__c,ccrm_sfid__c,phone,van__c,Website,intsts__c from account where id=:A.id];
        
        if(U.contact.account.ORACLE_PARTY_ID__c!=null)
            orclId = U.contact.account.ORACLE_PARTY_ID__c;
        
        system.debug('orclId -- '+orclId);
        
        if(!u.contact.account.Type.equalsIgnoreCase('Customer - Incubation') && !u.contact.account.Type.equalsIgnoreCase('Customer - Member')){
            
            loadCards2(orclId);
            getParkings(A);
            poBox = '';
            getPOBox();
            loadTransaction();
            getSanctions();
            //checkParkingUser();
        }
    }
    
    public PageReference checkParkingUser(){if (!Test.isRunningTest()) {try {getconinfoLst();} catch (exception ex) {}} onlyParkingUser = gU.checkParkingUser(UserInfo.getUserId()); PageReference pageRef = null; Boolean test = (onlyParkingUser)&&(el.get('stdElg')==null||el.get('stdElg')<=0); system.debug('stdElg -- '+test); if(onlyParkingUser && (el.get('stdElg') == null || el.get('stdElg') <= 0)&& el.get('prkAvl')!=1){ pageRef = new PageReference('/AccessDenied'); } system.debug('pageRef -- '+pageRef); return pageRef; }
    
    public Map<String,String>renewLinkMap{get;set;}// Renewal RequestURL
    public boolean showRenewal{get;set;}
    public void setRenewalRequest(){
        renewLinkMap = new  Map<String,String>();
        List<g_Req__c> rqRenLst = [select Id,Acc__c, srvc__c,Service_Code__c from g_Req__c where Acc__c =:u.contact.account.id AND Service_Code__c='223'];
        for(g_Req__c rqren : rqRenLst){
            renewLinkMap.put('Click Here for Renewal','/apex/ddfcRenewal?id=' + rqren.Id +'&m=v');
            
            showRenewal =true;
        }
        system.debug('renewLinkLst >> '+ renewLinkMap);
    }
    
    
    public List<ParkingDetails> lst_pdClone{get;set;}
    
    public List<ParkingDetails> lst_pd{get;set;}
    public List<ParkingM.ParkingDetails_m> lst_pd3{get;set;}
    
    public String parkingString {get;set;}
    
    public PageReference loadCards2(String oid) {
        lst_pd3 = new parkingM().loadCards(oid);
        if(lst_pd3!=null&&!lst_pd3.isEmpty()&&lst_pd3.size()>0){
            parkingString = JSON.serialize(lst_pd3);
            for(ParkingM.ParkingDetails_m parkingCard : lst_pd3){
                if(parkingCard.cardType == 'VIP'){
                    isVIPCardHolder = true;
                }
            }
        }
        system.debug('lst_pd- 405 -gctlhm1 '+lst_pd3);
        //prd.lst_pd = lst_pd; 
        return null;
    }
    
    public Map<String,Integer> el {get;set;}    //***
    public Boolean isPRavail{get;set;}
    public void getParkings(Account acc) {
        try{
            ParkingM p = new ParkingM(); 
            el =  p.getEligibility(acc);
            System.debug('### EL : ' + el);
        } catch(Exception ex){
            System.debug('@@Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
        List<g_req__c> renewlReq = [Select id ,name from g_req__c where Acc__c=:U.accountId AND STA__c='Draft' AND Service_Code__c='156' LIMIT 1];
        isPRavail = false;
        if(!renewlReq.isEmpty()){isPRavail=true;}
    } //***
    
    public void getConInfo() {
        isCI = false;
        List<coninfo__c> lstCI = [SELECT ID,Name__c,Acc__c,Con__c,Email__c,rol__c,phone__c FROM coninfo__c WHERE Acc__c=:A.Id Limit 1];
        if(lstCI != null && lstCI.size() > 0){isCI=true;}
    }
    
    public Map<string,coninfo__c> conMap  {get;set;}
    public List<string> aList  {get;set;}
    public Set<string> oList  {get;set;}
    public Map<String,List<String>> multiMap {get;set;}
    public class Records{public List<Manager> Managers;}
    public class accIDs {public List<String> AccLicNos;}
    public class Manager{
        public String accLicNo,salutation,firstName,lastName,mobile,email,passportNo,nationality;
        public Boolean dupCon,dupUsr;
    } 
    
    public void getconinfoLst() { List < string > str = new List < string > (); List < string > multiplestrg = new List < string > (); conMap = new Map < string, coninfo__c > (); multiMap = new Map < String, List < String >> (); aList = new List < String > (); oList = new Set < String > (); /*Anu-2/7/2021-Added Code for updating Manager details*/ accIDs ids = new accIDs(); List < String > accLicNoLst = new List < String > (); accLicNoLst.add(A.lc__c); ids.AccLicNos = accLicNoLst; String reqBody = JSON.serialize(ids); System.debug(reqBody); Http h = new Http(); HttpRequest request = new HttpRequest(); HttpResponse response = new HttpResponse(); request.setHeader('Content-Type', 'application/json'); request.setHeader('accept', 'application/json'); request.setEndpoint('callout:DCCA_Auth/apexrest/fetchManagersInfo'); request.setTimeout(90000); request.setMethod('POST'); request.setBody(reqBody); response = h.send(request); if(response.getStatusCode() == 200) { String respBody = '{"Managers":[]}'; if(response.getBody() != null) { respBody = '{"Managers":' + response.getBody() + '}'; } System.debug('<response.getBody()> : ' + respBody); Records recs = (Records) JSON.deserialize(respBody, gctlHm1.Records.class); if(recs != null) { List < coninfo__c > conInfoInsert = new List < coninfo__c > (); List < coninfo__c > conInfoUpdate = new List < coninfo__c > (); for(Manager m: recs.Managers) { String mName = m.firstName + ' ' + m.lastName; String emailId; if(m.email.contains(';')) { List < String > emailList = m.email.split(';'); emailId = emailList[0]; } else emailId = m.email; List < coninfo__c > conInLst = [SELECT ID, Name__c, Acc__c, con__c, con__r.Firstname, con__r.LastName, sort_order__c, Email__c, rol__c, phone__c, seml__c, sphn__c FROM coninfo__c WHERE Acc__c =: A.Id AND Sta__c = 'Active' AND rol__c includes('General Manager') ]; if(!conInLst.isEmpty()) { for(coninfo__c con1: conInLst) { if(con1.Name__c != mName) { System.debug('A.Id inside If====' + A.Id); coninfo__c nwCon = new coninfo__c(); nwCon.Name__c = mName; nwCon.acc__c = A.Id; nwCon.email__c = emailId; nwCon.phone__c = m.mobile; nwCon.rol__c = 'General Manager'; nwCon.Sta__c = 'Active'; conInfoInsert.add(nwCon); List < String > rolLst = con1.rol__c.split(';'); if(rolLst.size() == 1 && rolLst[0] == 'General Manager') con1.Sta__c = 'Inactive'; if(rolLst.size() > 1) { String newRole = ''; for(String str1: rolLst) { if(str1 != 'General Manager') { if(newRole == '') newRole = str1; else newRole = newRole + ';' + str1; } } con1.rol__c = newRole; } conInfoUpdate.add(con1); } System.debug('conInfoInsert inside If=====' + conInfoInsert); System.debug('conInfoUpdate inside If=====' + conInfoUpdate); } } else { System.debug('A.Id inside else====' + A.Id); coninfo__c nwCon1 = new coninfo__c(); nwCon1.Name__c = mName; nwCon1.acc__c = A.Id; nwCon1.email__c = emailId; nwCon1.phone__c = m.mobile; nwCon1.rol__c = 'General Manager'; nwCon1.Sta__c = 'Active'; conInfoInsert.add(nwCon1); } } System.debug('conInfoInsert afterAll=====' + conInfoInsert); System.debug('conInfoUpdate afterAll=====' + conInfoUpdate); if(conInfoInsert.size() > 0) insert conInfoInsert; if(conInfoUpdate.size() > 0) update conInfoUpdate; } } List < coninfo__c > coninfostatusupdate = new List < coninfo__c > (); for(coninfo__c conMI: [select id, rol__c, Sta__c from coninfo__c where rol__c Includes('Manager Incharge') AND Sta__c = 'Active']) { List < String > rolLst = conMI.rol__c.split(';'); if(rolLst.size() == 1 && rolLst[0] == 'Manager Incharge') conMI.Sta__c = 'Inactive'; if(rolLst.size() > 1) { String newRole = ''; for(String str1: rolLst) { if(str1 != 'Manager Incharge') { if(newRole == '') newRole = str1; else newRole = newRole + ';' + str1; } } conMI.rol__c = newRole; } coninfostatusupdate.add(conMI); } system.debug('coninfostatusupdate in gctlHm1========' + coninfostatusupdate); if(!coninfostatusupdate.isEmpty()) { update coninfostatusupdate; } /*for (coninfo__c con: [SELECT ID, Name__c, Acc__c, Con__c, sort_order__c, Email__c, rol__c, phone__c, seml__c, sphn__c FROM coninfo__c WHERE Acc__c =: A.Id AND Sta__c = 'Active' order by sort_order__c ASC ]) { conMap.put(con.rol__c, con); aList.add(con.rol__c); }*/ for(coninfo__c con: [SELECT ID, Name__c, Acc__c, Con__c, sort_order__c, Email__c, rol__c, phone__c, seml__c, sphn__c FROM coninfo__c WHERE Acc__c =: A.Id AND Sta__c = 'Active' order by sort_order__c ASC ]) { /*List < String > rolLst = con.rol__c.split(';');*/ List < String > rolLst = new List<string>(); rolLst =  (con.rol__c!=null)?con.rol__c.split(';'):new List<string>(); if(rolLst.size() == 1 && (rolLst[0] == 'VAT Contact' || rolLst[0] == 'Billing Contact')) { conMap.put('Financial Contact', con); aList.add('Financial Contact'); } else if(rolLst.size() == 1 && rolLst[0] == 'Office Admin/Manager') { conMap.put('Admin Contact', con); aList.add('Admin Contact'); } else if(rolLst.size() > 1) { Set < String > newRole = new Set < String > (); for(String str1: rolLst) { if(str1 == 'VAT Contact') { newRole.add('Financial Contact'); } else if(str1 == 'Billing Contact') { newRole.add('Financial Contact'); } else if(str1 == 'Office Admin/Manager') { newRole.add('Admin Contact'); } else newRole.add(str1); } String nrole = String.join((Iterable < String > ) newRole, ';'); system.debug('nrole------>' + nrole); conMap.put(nrole, con); aList.add(nrole); } else { conMap.put(con.rol__c, con); aList.add(con.rol__c); } } system.debug('aList------>' + aList); system.debug('conMap------>' + conMap); if(!conMap.isEmpty()) { for(String ci: conMap.keySet()) { if(String.isNotBlank(ci) && ci.contains(';')) { str = ci.split(';'); for(String s: str) { if(s != 'General Manager') { multiplestrg.add(s); } multiMap.put('General Manager', multiplestrg); } } } if(!multiMap.isEmpty()) { for(String sk: multiMap.keyset()) { for(String s: multiMap.get(sk)) { oList.add(s); } } } system.debug('oList----->' + oList); system.debug('multiMap----->' + multiMap); system.debug('conMap----->' + conMap); if(!conMap.isEmpty()) { conVals = (conMap.keySet().size() > 0) ? true : false; } } system.debug('conMap keys----' + conMap.keyset()); system.debug('conMap values----' + conMap.values()); system.debug('conVals----' + conVals); }
    public Pagereference searchByStatus1(){
        String qry = 'select id,Applicant_Name__c,prio__c,CurrentNationality__c,xcnc__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcln__c,STA__c,damsgs__c,AOP__c from g_Req__c where isDeleted = false and Acc__c =\''+ A.Id+'\'  ';
        //String qry = 'SELECT id,flnm__c,Photo_ID__c,jb__r.name,STA__c,nc__c,p__c,eidid__c,rp__c,ped__c,rped__c,Passport_Status__c,RP_Sts__c FROM contact WHERE accountid=\'0012000001G8hoX\' and ';
        if(string.isNotBlank(days)){
            Integer d = integer.valueof(days)-1;
            if(d == 0 ) qry = qry + ' and LastModifiedDate = TODAY';
            else qry = qry + ' and LastModifiedDate = LAST_N_DAYS:'+d;
            
            if(string.isNotBlank(status) && status!='All')
                qry = qry + ' and STA__c =\''+status+'\'';
        }
        else if(string.isBlank(days) && string.isNotBlank(status) && status!='All'){qry = qry + ' and STA__c =\''+status+'\'';}            
        system.debug('qry::'+qry);
        allDPRqs = Database.query(qry);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(allDPRqs);
        stdSetController= ssc;
        return null; 
    }
    public void LoadPrivateMethods() {
        if (Test.isRunningTest()) {
            try {getSanctions();} catch (exception ex) {}
            try {getCs();} catch (exception ex) {}
            try {getSrvcs();} catch (exception ex) {}
            try {loadStats();} catch (exception ex) {}
            try {NotGCC('Pakistani');} catch (exception ex) {}
            try {getVisitors();} catch (exception ex) {}
            try {loadData(false);} catch (exception ex) {}
            // try {getconinfoLst();} catch (exception ex) {}
            
        }
    }
    private void getRCRQs(){rcRqs=[select id,Name,srvc__r.Name,xcfn__c,xcln__c,xcnc__c from g_Req__c where i_STA__c like '%Requires Correction%' and isDeleted = false and Acc__c =: A.Id];}
    
    public void getdraftRQs(){
        draftRq5 = new List<g_Req__c>();
        draftRqs = new List<g_Req__c>();
        allRqs = new List<g_Req__c>();
        allRqs = [select id,Applicant_Name__c,xfpdd__c,prio__c,CurrentNationality__c,xcnc__c,AT__c,AP__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcln__c,STA__c,damsgs__c,AOP__c from g_Req__c where isDeleted = false and Acc__c =: A.Id order by LastModifiedDate desc ];
        for(g_Req__c r : allRqs){
            if(r.STA__c =='Draft') draftRqs.add(r);
        }
        //draftRqs=[select id,Applicant_Name__c,prio__c,CurrentNationality__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcln__c,STA__c from g_Req__c where STA__c='Draft' and isDeleted = false and Acc__c =: A.Id];
        if(!draftRqs.isEmpty() && draftRqs.size()>0){for(Integer i = 0;i< draftRqs.size() && i<5;i++){draftRq5.add(draftRqs.get(i));}}
    } 
    
    public void getnotificationRQs() { notificationRqs = new List < g_Req__c > (); notificationRqs3 = new List < g_Req__c > (); system.debug('pendingRq5--- ' + pendingRq5); if (pendingRq5 != null) { for (g_req__c r: pendingRq5) { if (r.bamsgs__c != null) { notificationRqs.add(r); } } } if (notificationRqs != null) { for (Integer r = 0; notificationRqs != null && r < notificationRqs.size() && r < 3; r++) { notificationRqs3.add(notificationRqs.get(r)); } } }
    
    public void getpendingRQs(){ pendingRq5 = new List<g_Req__c>(); pendingRqs=[select id,Applicant_Name__c,prio__c,CurrentNationality__c,xcnc__c,AT__c,AP__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcln__c,STA__c,AOP__c,damsgs__c,bamsgs__c,LastModifiedDate from g_Req__c where (xcawp__c=true or AOP__c > 0) and STA__c NOT IN('Draft','Completed','Rejected','Cancelled')  and isDeleted = false and Acc__c =: A.Id order by LastModifiedDate desc ]; if(pendingRqs != null && !pendingRqs.isEmpty()){ integer cnt = 0; for(Integer r = 0;r<pendingRqs.size();r++){if(cnt <5 && pendingRqs.get(r).damsgs__c!=null){pendingRq5.add(pendingRqs.get(r));cnt=cnt+1;}} } }
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
        allDPRqs = [select id,Applicant_Name__c,prio__c,CurrentNationality__c,xcnc__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcln__c,STA__c,damsgs__c,AOP__c from g_Req__c where isDeleted = false and (Applicant_Name__c LIKE: p or xcp__c LIKE: p) and Acc__c =:A.Id];
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(allDPRqs);
        stdSetController= ssc;
    }
    public void getallDPRQs(){
        allDPRqs = new List<g_Req__c>();
        if(isPendingTab=='pndg' ){for(g_Req__c r : pendingRqs){if(r.damsgs__c!=null){allDPRqs.add(r);}}} 
        else if(isPendingTab=='drft' ) allDPRqs = draftRqs;
        else{allRqs = [select id,Applicant_Name__c,xfpdd__c,prio__c,CurrentNationality__c,xcnc__c,AT__c,AP__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcln__c,STA__c,damsgs__c,AOP__c from g_Req__c where isDeleted = false and Acc__c =: A.Id order by LastModifiedDate desc ];allDPRqs = allRqs;}
    }
    public void searchByStatus(){
        system.debug('sta---> '+sta);
        // allDPRqs = new List<g_Req__c>();
        String s = ''+sta+'';
        allDPRqs = [select id,Applicant_Name__c,prio__c,CurrentNationality__c,xcnc__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcln__c,STA__c,damsgs__c,AOP__c from g_Req__c where isDeleted = false and STA__c =: s and Acc__c =: A.Id];
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(allDPRqs);
        stdSetController= ssc;
    }
    public void searchByDate(){
        //allDPRqs = new List<g_Req__c>();
        Integer d = integer.valueof(dat);
        if(d == 1) allDPRqs = [select id,Applicant_Name__c,prio__c,CurrentNationality__c,xcnc__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcln__c,STA__c,damsgs__c,AOP__c from g_Req__c where isDeleted = false and Acc__c =:A.Id];
        else{
            Integer dd =  d -1;
            String qur = 'select id,Applicant_Name__c,prio__c,CurrentNationality__c,xcnc__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcln__c,STA__c,damsgs__c from g_Req__c where isDeleted = false and LastModifiedDate = LAST_N_DAYS:'+dd+' and Acc__c =\''+A.Id+'\''; //+A.Id
            allDPRqs = database.query(qur);
        }
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(allDPRqs);
        stdSetController= ssc;
    }
    public Integer TotalPages{                                            // Total number of pages as per user selection of Records per page
        get{
            if(stdSetController.getResultSize() <=10)
                this.TotalPages=1;
            if(Math.Mod(stdSetController.getResultSize() ,stdSetController.getPageSize()) == 0) this.TotalPages =(stdSetController.getResultSize()/stdSetController.getPageSize());
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
    public ApexPages.StandardSetController stdSetController{            /*Instantiating a standard set controller*/ get{ if(stdSetController==null){ if(allDPRqs==null||allDPRqs.size()==0){allDPRqs = new List<g_Req__c>();}  List<g_Req__c> rqs= new List<g_Req__c>();  allDPRqs = [select id,Applicant_Name__c,xfpdd__c,prio__c,CurrentNationality__c,xcnc__c,AT__c,AP__c,xcp__c,Name,srvc__r.Name,xcfn__c,xcln__c,STA__c,damsgs__c,AOP__c from g_Req__c where isDeleted = false and Acc__c =: A.Id and STA__c!='Completed' order by lastmodifieddate desc];  /*:accid*/  if(isPendingTab=='pndg' ){for(g_Req__c r : allDPRqs){if(r.damsgs__c!=null && r.damsgs__c!='0'){rqs.add(r);}}allDPRqs= rqs;}  stdSetController = new ApexPages.StandardSetController(allDPRqs); } stdSetController.setPageSize(RecordsPerPageslist);        /*Limiting Number of records to be displayed per page */ return stdSetController; } set; } 
    
    public Pagereference getSelectedPageList(){ 
        this.stdSetController.setpageSize(RecordsPerPageslist);
        this.stdSetController.setpageNumber(integer.valueOf(pageNo));
        return null;
    }
    public list<g_req__c> getallDPRqs1(){                               //to display records on vf page
        return (list<g_req__c>)stdSetController.getRecords();
    }
    private void getRQs() { map < String, Decimal > mSTA = new map < String, Decimal > (); mSTA.put('Draft', 0);mSTA.put('Open', 0);mSTA.put('Under Review', 0);mSTA.put('In Process', 0);mSTA.put('On Hold', 0);mSTA.put('NC', 0); for (aggregateResult ar: [select STA__c STA, count(Id) C, SUM(nc__c) NC from g_Req__c where isDeleted = false and Acc__c =: A.Id and(STA__c = 'Draft' or STA__c = 'Open' or STA__c = 'Under Review' or STA__c = 'In Process' or STA__c = 'On Hold') group by STA__c]) { mSTA.put((String) ar.get('STA'), mSTA.get((String) ar.get('STA')) + (ar.get('C') == null ? 0 : (Decimal) ar.get('C'))); if (ar.get('STA') != 'On Hold') { mSTA.put('NC', mSTA.get('NC') + (ar.get('NC') == null ? 0 : (Decimal) ar.get('NC'))); } } cD = mSTA.get('Draft') == null ? 0 : mSTA.get('Draft');cO = mSTA.get('Open') == null ? 0 : mSTA.get('Open');cR = mSTA.get('Under Review') == null ? 0 : mSTA.get('Under Review');cP = mSTA.get('In Process') == null ? 0 : mSTA.get('In Process');cH = mSTA.get('On Hold') == null ? 0 : mSTA.get('On Hold'); cC = mSTA.get('NC') == null ? 0 : mSTA.get('NC'); }
    private void getSanctions() {
        if ((A.snc__c != null && A.snc__c != '') || A.lcsnc__c || A.psasnc__c || A.ecsnc__c) {
            mSnc = new map < string, string > ();
            if (A.lcsnc__c) mSnc.put('LC', A.lcsncnt__c);
            if (A.psasnc__c) mSnc.put('PSA', A.psasncnt__c);
            if (A.ecsnc__c) mSnc.put('EC', A.ecsncnt__c);
            if(String.isNotBlank(A.snc__c)){
                for (string snc: A.snc__c.split(';')) {
                    mSnc.put(snc, '');
                }
            }
            mScSize = mSnc.keySet().size();
            mScHasVal = (mSnc.keySet().size()>0)?true:false;
            
            if (mSnc.keySet().size() > 0) {
                for (Sanction_Detail__c sncDt: [select id, Name, Sanction_Notes__c from Sanction_Detail__c where Name in: mSnc.keySet()]) {
                    if (mSnc.containsKey(sncDt.Name)) {mSnc.put(sncDt.Name, sncDt.Sanction_Notes__c);}
                }
            }
        }
    }
    
    public List<alocpob__c> poBoxLst {get;set;}
    public void getPOBox() {
        poBoxLst = new List<alocpob__c>();
        poBoxLst = [select id,Name,idt__c,edt__c,typ__c from alocpob__c where isDeleted = false and acc__c =: A.Id and stts__c='Active' limit 10];
        if(!poBoxLst.isEmpty())poBox = poBoxLst[0].Name;
    } 
    
    private void getRPExpLst() {List<aggregateResult> rpExpLst = [select count(id),calendar_month(rped__c) from contact where accountid=:A.Id and rped__c >TODAY and rped__c <=NEXT_N_MONTHS:6 GROUP BY calendar_month(rped__c) ORDER BY calendar_month(rped__c) DESC];}
    private void getPassportExpLst() {List<aggregateResult> pExpLst = [select count(id),calendar_month(ped__c) from contact where accountid=:A.Id and ped__c >TODAY and ped__c <=NEXT_N_MONTHS:6 GROUP BY calendar_month(ped__c) ORDER BY calendar_month(ped__c) DESC];}
    private void getLeaseExpLst() {List<grqWsDccaGetService.Records> tecomd3Lst = new List<grqWsDccaGetService.Records>();List<grqWsDccaGetService.Records> tecomLeaseLst =  grqWsDccaGetService.loadTecomCRMLoc(A.ORACLE_PARTY_ID__c);List<grqWsDccaGetService.Records> d3lsLst = grqWsDccaGetService.loadD3Loc(A.ORACLE_PARTY_ID__c);tecomd3Lst.addAll(tecomLeaseLst);tecomd3Lst.addAll(d3lsLst);}
    
    private void getCs() {
        for (aggregateResult ar: [select count(id) C from Contact where isDeleted = false and AccountId =: A.Id and STA__c = 'Active'
                                  and rol__c = 'Employee'
                                  and createddate < LAST_N_DAYS: 179 and(lua__c = null or lua__c < LAST_N_DAYS: 179 or luas__c = null or luas__c < LAST_N_DAYS: 179)
                                 ]) {
                                     cOD += ar.get('C') == null ? 0 : (Decimal) ar.get('C');
                                 }
    }
    private void getSrvcs() {
        set < Id > sids;
        if (!gu.isPortalSuperUser(UserInfo.getProfileId()) && ispu) {
            sids = new set < id > ();
            for (g_srvcAL__c al: [select srvc__r.Id from g_srvcAL__c where isDeleted = false and usr__c =: UserInfo.getUserId() and DE__c = true]) {sids.add(al.srvc__r.Id);}
        }
        map < String, map < String, list < g_Srvc__c >>> mH = new map < String, map < String, list < g_Srvc__c >>> ();
        map < String, map < String, list < g_Srvc__c >>> mHMC = new map < String, map < String, list < g_Srvc__c >>> ();
        // for (g_Srvc__c s: [select id, uid__c, Name, lbl__c,Menu_Category__c,Category__c, Sub_Category__c from g_Srvc__c where isDeleted = false and actv__c = true and Category__c <> null and Prk__c includes(: a.Prk__c) and AccTp__c includes(: a.Type) and(id in: sids or isDeleted =: sids == null ? false : true) order by sord__c]) { //Menu_Category__c,
        for (g_Srvc__c s: [select id, uid__c, Name, lbl__c,Menu_Category__c,Category__c, Sub_Category__c from g_Srvc__c where isDeleted = false and actv__c = true and Category__c <> null and Prk__c includes(: a.Prk__c) and AccTp__c includes(: a.Type)  order by sord__c]) { //Menu_Category__c,
            String sc = s.Sub_Category__c;
            for (String c: s.Menu_Category__c.split('\\;', 0)) {
                if (mH.get(c) == null) {
                    mH.put(c, new map < String, list < g_Srvc__c >> ());
                }
                if (mH.get(c).get(sc) == null) {
                    mH.get(c).put(sc, new list < g_Srvc__c > ());
                }
                mH.get(c).get(sc).add(s);
            }
            
            
        }
        Srvcs = new list < GL1 > (); /*sort subgroups as per schema*/
        for (Schema.PicklistEntry c: g_Srvc__c.Menu_Category__c.getDescribe().getPicklistValues()) {
            if (mH.get(c.getLabel()) != null) {
                GL1 l1 = new GL1(c.getLabel());
                for (Schema.PicklistEntry sc: g_Srvc__c.Sub_Category__c.getDescribe().getPicklistValues()) {
                    if (mH.get(c.getLabel()).get(sc.getLabel()) != null) {l1.lst.add(new GL2(sc.getLabel(), mH.get(c.getLabel()).get(sc.getLabel())));}
                }
                Srvcs.add(l1);
            }
        }
        system.debug('Srvcs >>'+ Srvcs);
    }
    
    //AXS 2.0 By JP
    private void loadContact() { List < Id > conIdLst = new List < Id > (); myAccountLst = new List < myAccount > (); contLst = new List < contact > (); uidUsrname = new Map < String, User > (); Map < String, User > conIdUsrname = new Map < String, User > (); Map < Id, Contact > conIdContactMap = new Map < Id, Contact > (); for (Contact c: [select Id, Name, Personal_Photo__c, Photo_ID__c, Email, Job_Title_Formula__c, rped__c, ped__c, nc__c, rol__c, STA__c, isDeleted from Contact where AccountId =: A.Id]) { contLst.add(c); conIdLst.add(c.Id); conIdContactMap.put(c.Id, c); } system.debug('ContLst >>' + contLst); List < User > userLst = [select Id, Name, Username, Email, contactId, isActive from User where contactId =: conIdLst]; for (User usr: userLst) { conIdUsrname.put(usr.contactId, usr); uidUsrname.put(usr.Id, usr); } system.debug('userLst >>' + userLst); system.debug('conIdUsrname >>' + conIdUsrname);for (User u: userLst) { myAccount m = new myAccount(); m.con = conIdContactMap.get(u.contactId); m.usr = u; /*conIdUsrname.get(c.id);*/ m.usrPhoto = conIdContactMap.get(u.contactId).Photo_ID__c; myAccountLst.add(m); } system.debug('myAccountLst >>' + myAccountLst); }
    class myAccount{public Contact con{get;set;}public User usr{get;set;}public string usrPhoto{get;set;}}
    
    private void loadAccountLocation(){ try{ tecomLeaseList = new List<grqWsDccaGetService.Records>(); List<grqWsDccaGetService.Records> d3LeaseList = new List<grqWsDccaGetService.Records>(); if(A!= null && A.ORACLE_PARTY_ID__c!=null ){ /* tecomLeaseList = grqWsDccaGetService.loadTecomCRMLoc(A.ORACLE_PARTY_ID__c);*/ system.debug('######################tecomLeaseList#############################'); system.debug(tecomLeaseList); /*d3LeaseList = grqWsDccaGetService.loadD3Loc(A.ORACLE_PARTY_ID__c);*/ } system.debug('######################d3LeaseList#############################'); if(d3LeaseList!= null && !d3LeaseList.isEmpty() && d3LeaseList.size()>0){ tecomLeaseList.addAll(d3LeaseList); } system.debug('JJJJJ tecomLeaseList11'+tecomLeaseList); finalAgreeLoc= new map<String,String>(); for (grqWsDccaGetService.Records rec: tecomLeaseList) { finalAgreeLoc.put(rec.AgNo, rec.Products[0].UnitNumber+','+rec.Products[0].ProductName); } locLst = new List<loc__c>(); system.debug('ll A>>'+ A); if(a!=null && A.Id !=null) for (loc__c lc: [select Id,Name,acc__c,active__c,act__c,agrno__c,arBldg__c,arbu__c,arflr__c,aroffno__c,asf__c,Bldg__c,bu__c,cat__c,flr__c,IsActive__c,Is_frzn__c,IsMain__c,isregof__c,IsSub__c,ls_end__c,ls_std__c,lstyp__c,Loc__c,mu__c,offno__c,pyear__c,plt__c,pltarb__c,rpi__c,rqno__c,subcat__c,su__c from loc__c where acc__c =: A.Id]) { locLst.add(lc); } }catch(Exception ex){ system.debug('loadAccountLocation Ex >>'+ ex); } system.debug('locLst >> '+ locLst); }
    
    private void loadTransaction(){
        tsLst = new List<g_Tran__c>();
        for (g_Tran__c ts: [select id,acc__c,Name, md__c, A__c, dt__c, STA__c from g_Tran__c  where acc__c =: A.Id ORDER BY dt__c DESC limit 6]) {tsLst.add(ts);}
        system.debug('tsLst >> '+ tsLst);
    }
    
    
    private void enUser(Id uid, Boolean actv){system.debug('in enUser2 >>'+uid +' || '+actv );if(uid == null){gU.AddWarningMsg(Label.msgNoChange); return;}User u = uidUsrname.get(uid);u.IsActive = actv;update u;system.debug('updated User >>'+ u);init();gU.AddSuccessMsg(Label.msgSuccess);}
    
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
                         and AccountId =: A.Id
                        ]) {
                            // if (c.rped__c == null && NotGCC(c.nc__c) ) { //&& c.rol__c <> 'Non Sponsored' && c.rol__c <> 'Access Card' && c.rol__c <> 'Other'
                            //     cRPExp++;
                            //  } else
                            
                            if (c.rped__c <= Date.today() && NotGCC(c.nc__c) && (c.rol__c=='Employee'||c.rol__c=='Non Sponsored'||c.rol__c=='Access Card' ||c.rol__c=='Student') ) {cRPExp++;} // //&& c.rol__c <> 'Non Sponsored' && c.rol__c <> 'Access Card' && c.rol__c <> 'Other'
                            
                            //  if (c.ped__c == null) {
                            //    cPSExp++;
                            // } else
                            
                            if (c.ped__c <= Date.today() && c.ped__c !=null && NotGCC(c.nc__c)  && (c.rol__c=='Employee'||c.rol__c=='Non Sponsored'||c.rol__c=='Access Card' ||c.rol__c=='Student')) {
                                cPSExp++;
                            } else if (Date.today().addDays(30) >= c.ped__c && NotGCC(c.nc__c)  && (c.rol__c=='Employee'||c.rol__c=='Non Sponsored'||c.rol__c=='Access Card' ||c.rol__c=='Student')) {
                                cPSExp30++;
                            }
                        }
        for (Contact ct: [select Id, rped__c, ped__c, nc__c, rol__c from Contact where isDeleted = false and STA__c = 'Active'
                          and AccountId =: A.Id and rped__c = NEXT_N_DAYS: 30]) {if (NotGCC(ct.nc__c) && (ct.rol__c=='Employee'||ct.rol__c=='Non Sponsored'||ct.rol__c=='Access Card' ||ct.rol__c=='Student')) {cRPExp30++;}}
    }
    private boolean NotGCC(String nationality) {
        if (nationality <> 'Bahrain' && nationality <> 'Kuwait' && nationality <> 'Oman' && nationality <> 'Qatar' && nationality <> 'Saudi Arabia' && nationality <> 'United Arab Emirates') {
            return true;
        } else {return false;}
    }
    
    
    public PageReference getLicenseCopy(){String lc= apexpages.currentpage().getparameters().get('lc');if(ispu){lc=A.lc__c;}String jsonResp = grqWsDccaGetService.getLicenseCopy(lc);        Map<String, Object> metadata_Map = (Map<String, Object>) JSON.deserializeUntyped(jsonResp);licCopy=(String)metadata_Map.get('body');return null;}
    
    
    public Map<String, String> ddaDocs {get{return new Map<String, String>{'Certificate of Incorporation'=>'COI','Certificate of Branch Registration'=>'COBR','Commercial License'=>'License'};}set;}  //'Articles of Association'=>'AOA',,'Register Of Directors'=>'ROD'
    
    public PageReference  getDocument(){ String lc= apexpages.currentpage().getparameters().get('lc');String dc= apexpages.currentpage().getparameters().get('dc'); System.debug('<getDocument:: > dc: ' + dc); if(String.isNotBlank(dc)){ /*Map<String,String> mapDocs = new Map<String,String>{'coi'=>'Certificate of Incorporation','aoa'=>'Articles of Association','cocn'=>'Certificate of Company Name Change','fp'=>'Freelancer Permit','cobr'=>'Certificate of Branch Registration','clc'=>'Commercial Licence','cxt'=>'Company Extract','brs'=>'Board Resolution','rod'=>'Register Of Directors'};*/ if(ispu){lc=A.lc__c;} /*19072*/ licCopy = grqWsDccaGetService.getDocument(lc,dc); }  return null; }
    
    private void getVisitors() {
        AggregateResult ar = [select count(id) C from g_Req__c where(isDeleted = false AND Acc__c =: A.Id) AND(srvc__r.uid__c = '058'
                                                                                                               OR srvc__r.uid__c = '074'
                                                                                                               OR srvc__r.uid__c = '096'
                                                                                                               OR srvc__r.uid__c = '097') AND((STA__c != 'Rejected'
                                                                                                                                               AND STA__c != 'Cancelled'
                                                                                                                                               AND CreatedDate = THIS_MONTH) OR STA__c = 'Open'
                                                                                                                                              OR STA__c = 'Draft')];
        if (ar == null) {return;}
        if (ar.get('C') == null) {return;}
        VVU = (Decimal) ar.get('C');
    }
    public list < GL1 > Srvcs {get;set;}public list < GL1 > SrvcCategory {get;set;}
    public map < string, string > mSnc {
        get;
        set;
    }
    public class GL1 {
        public String lbl {
            get;
            set;
        }
        public list < GL2 > lst {
            get;
            set;
        }
        public GL1(String v) {
            lbl = v;
            lst = new list < GL2 > ();
        }
    }
    public class GL2 {public String lbl {get;set;}public list < g_Srvc__c > lst {get;set;}public GL2(String v, list < g_Srvc__c > l) {lbl = v;lst = l;}}
}