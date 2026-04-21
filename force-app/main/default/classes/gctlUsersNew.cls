public with sharing class gctlUsersNew {
    public Boolean pgHide{get;set;} public Boolean ispu{get;set;}
    public g_reqitem__c wrp{get;set;} /*This object has all the fields we need. so its used as the portal user has no access to create contact*/
    public User U{get;set;}
    public String AccID{get;set;}
    public Account A {get;set;}
    public Contact C {get;set;}
    public gctlUsersNew(){init();}
    public gctlUsersNew(gctlHm controller){init();}
    public void init(){
        try{
            U = [select Id, FirstName, LastName,Name, AccountId, LastPasswordChangeDate, LastLoginDate, contact.MobilePhone, contact.Email, contact.Photo_ID__c,contact.Gender__c, contact.account.id, contact.account.on__c,
                 contact.account.onar__c , contact.account.Website, contact.account.vespe__c, contact.account.vespex__c, contact.account.vetemp__c, contact.account.vbtemp__c ,
                 contact.account.vetst__c, contact.account.vespstx__c , contact.account.vbtst__c, contact.account.vev__c, contact.account.mxPortalUsers__c,contact.account.Name,
                 contact.account.Email__c,contact.account.lPrk__c,contact.account.Building_Name__c,contact.account.vespst__c, contact.account.Park__c, contact.account.xcublg__c,contact.account.Location__c,contact.account.Location_Cluster__c,
                 contact.account.xcuzn__c , contact.account.Phone, contact.account.Type, contact.account.Prk__c, contact.account.adb__c, contact.account.info__c,contact.account.bgnr__c,
                 contact.account.bg__c, contact.account.bgc__c, contact.account.bgcabsc__c, contact.account.bgb__c, contact.account.vctemp__c, contact.account.speabsc__c, contact.account.vctst__c,
                 contact.account.sncNt__c, contact.account.vbvv__c,contact.account.lcidt1__c, contact.account.ec__c, contact.account.ecidt__c,contact.account.lctp__c,
                 contact.account.ecedt__c,contact.account.lcedt__c,contact.account.lcsnc__c, contact.account.lcsncnt__c,contact.account.Legal_Framework__c,contact.account.psasnc__c,
                 contact.account.psasncnt__c, contact.account.lcsta__c,contact.account.ecsnc__c, contact.account.ecsncnt__c,contact.account.lcrndt__c,contact.account.cosnc__c, contact.account.cosncnt__c,
                 contact.account.licexdt__c, contact.account.licIdt__c,   contact.account.bgsnc__c, contact.account.bgsncnt__c, contact.account.snc__c,contact.account.voep__c,contact.account.lc__c,
                 contact.account.ORACLE_PARTY_ID__c,contact.account.rpa__c, contact.account.os__c, contact.account.adob__c , contact.account.adx__c, contact.account.adc__c  from User where id =: UserInfo.getUserId() limit 1];
            A = U.contact.account;
            C = U.contact;
            ispu=gu.isPortalUser(UserInfo.getProfileId());
            if (!gU.isPortalSuperUser(UserInfo.getProfileId())){pgHide=true;gu.addWarningMsg(Label.msgNoPrivilege);return;}
            //U = [select Id,AccountId, Contact.Account.mxPortalUsers__c from User where id=: UserInfo.getUserId() limit 1];
            integer maxAllow = U.Contact.Account.mxPortalUsers__c==null?0:integer.valueOf(U.Contact.Account.mxPortalUsers__c);
            List<User> users=[select Id from User where AccountId =: U.AccountId and IsActive=true];
            if (maxAllow==1 || users.size()>= maxAllow ){
                pgHide=true;
                String pgmsg = Label.msgPortalQuota;
                pgmsg = pgmsg.replace('#p1',maxAllow.format());
                pgmsg = pgmsg.replace('#p2',users.size().format());
                showAddButton = false;
                //gU.AddWarningMsg(pgmsg);
                //return;
            }
            else
                showAddButton = true;
            wrp = new g_reqitem__c();
            loadContact();
            loadEmployeeData();

        } catch (exception ex){pgHide=true;gU.AddErrorMsg(ex);}
    }
    public PageReference createUser(){ try{ /*AggregateResult[] muids= [select MAX(uid__c) from User];*/ Contact c; System.debug('wrp====='+wrp); list<Contact> cs = [select id,AccountId,Salutation,firstname,lastName,email,mobilephone,nc__c,p__c,rol__c,STA__c from Contact where isDeleted=false AND (p__c=:wrp.xcp__c AND nc__c=:wrp.xcnc__c) limit 1 ]; System.debug('cs====='+cs); System.debug('cs====='+cs.size()); if (cs.size()<=0){cs = [select id,AccountId,Salutation,firstname,lastName,email,mobilephone,nc__c,p__c,rol__c,STA__c from Contact where isDeleted=false AND Email=:wrp.xceml__c limit 1 ];} if (cs.size()<=0){c = new Contact(AccountId=U.AccountId,Salutation=wrp.xcslt__c,FirstName=wrp.xcfn__c,lastName=wrp.xcln__c,Email=wrp.xceml__c,mobilephone=wrp.xcmob__c,nc__c=wrp.xcnc__c,p__c=wrp.xcp__c,rol__c='Other',STA__c='Inactive'); if (U!=null && U.AccountId!=null) c.AccountId=U.AccountId; /* Added by JP for in5*/ else c.AccountId = AccID; } else{ c = cs[0]; List<User> exus=[select Id from User where ContactId =: c.Id and IsActive=true limit 1]; if (exus.size()>0){gU.AddWarningMsg(Label.msgUsrError);return null;} if (c.rol__c==null){c.rol__c='Other';} if (c.STA__c==null){c.rol__c='Inactive';} if (c.AccountId!=U.AccountId){if (c.STA__c=='Inactive'||c.rol__c=='Other'){c.AccountId=U.AccountId;}else{gU.AddWarningMsg(Label.msgUsrError);return null;}} if (c.Salutation==null||c.rol__c=='Other'){c.Salutation=wrp.xcslt__c;} if (c.firstname==null||c.rol__c=='Other'){c.firstname=wrp.xcfn__c;} if (c.lastName==null||c.rol__c=='Other'){c.lastName=wrp.xcln__c;} if (c.email==null||c.rol__c=='Other'){c.email=wrp.xceml__c;} if (c.mobilephone==null||c.rol__c=='Other'){c.mobilephone=wrp.xcmob__c;} if (c.nc__c==null||c.rol__c=='Other'){c.nc__c=wrp.xcnc__c;} if (c.p__c==null||c.rol__c=='Other'){c.p__c=wrp.xcp__c;} } upsert c; User nwU = new User(); nwU.ContactId=c.Id; String uniqueTime = String.valueof(system.now()).replace(' ','').replace('-','').replace(':',''); nwU.FirstName = wrp.xcfn__c;nwU.LastName = wrp.xcln__c;nwU.Alias=wrp.xcln__c.substring(0,3)+'.'+wrp.xcfn__c.substring(0,3);nwU.Email = wrp.xceml__c;nwU.Username = wrp.xceml__c; nwU.ProfileId=gU.csStr('gpST');nwU.CommunityNickname = nwU.Alias+uniqueTime;nwU.IsActive=true;nwU.TimeZoneSidKey = 'Asia/Dubai'; nwU.LocaleSidKey = 'en_GB';nwU.LanguageLocaleKey = 'en_US';nwU.EmailEncodingKey = 'ISO-8859-1'; Database.DMLOptions dmo = new Database.DMLOptions(); dmo.EmailHeader.triggerUserEmail = true; nwU.setOptions(dmo); insert nwU; PageReference p = Page.gu; p.setRedirect(true); return p; }catch (exception ex){gU.AddErrorMsg(ex);return null;} }
    /***************User Management Code Starts*******************/
    public List<mySerivceGroupRequest> servOptions {get;set;}//added for User Management
    public List<Contact> myAccountEmployeeLst{get;set;}//added for User Management
    public String myAccEmpStr {get;set;}//added for User Management
    Public List<mySerivceGroupRequest> orgSrvOpt;
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
    public Id deProfile = [Select Id From Profile Where Name='X' LIMIT 1].Id;
    public Id defaultProfile = [Select Id From Profile Where Name='Z' LIMIT 1].Id;
    public List<SelectOption> regions { get { List<SelectOption> options = new List<SelectOption>(); Schema.DescribeFieldResult fieldResult = contact.nc__c.getDescribe(); List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();  for ( Schema.PicklistEntry f : ple) options.add(new SelectOption(f.getLabel(), f.getValue())); return options; } }

    public void loadEmployeeData() {
        CounCode='+971';
        WrkCounCode='+971';
        firstTimeLoad = true;
        servOptions = new List<mySerivceGroupRequest>();
        orgSrvOpt = new List<mySerivceGroupRequest>();
        System.debug('=======loadEmployeeData1======='+String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('selInd')));
        System.debug('=======loadEmployeeData2======='+String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('acsType')));
        accessFrom = String.valueOf(String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('acsType')));
        System.debug('=======loadEmployeeData3======='+String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('acsType')));
        if ((String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('selInd'))) != null){
            firstTimeLoad = false;
            System.debug('#900=======x======='+String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('selInd')));
            String val = String.valueOf(String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('selInd')));
            String prcType = String.valueOf(String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('acsType')));
            accessFrom = prcType;
            System.debug('#944=======val.length'+val.length());
            if (val.length()<15){
                Integer ind = Integer.valueOf(String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('selInd')));
                selectedEmp = myAccountEmployeeLst.get(ind-1);
            }else{
                selectedEmp = [select Id,FirstName,LastName,Name,Personal_Photo__c,Photo_ID__c,Email,Job_Title_Formula__c, rped__c, ped__c, nc__c,
                               rol__c,STA__c,isDeleted,p__c,MobilePhone,MailingAddress,ha__c,OtherPhone from Contact where Id=: val];
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
            List<User> usLst = [select Id,ProfileId,FirstName,LastName,Username,Email,accountid,contact.account.id,contact.account.Name,contact.account.Type,contact.account.Prk__c
                                from User where IsActive=true and ContactId=:selectedEmp.Id];
            System.debug('#989=====loadEmployeeData'+usLst);
            if (usLst.size()>0){
                UsrExist = true;
                UsrExistWithAnotherAcc = false;
                selectedUs = usLst[0];
                username = selectedUs.Username;
                System.debug('#211=====selectedUs.ProfileId'+selectedUs.ProfileId);
                System.debug('#212=====defaultProfile'+defaultProfile);
                defaultGroupsAccess = (selectedUs.ProfileId == defaultProfile) ? true : false;
            }
            else{
                UsrExist = false;
                UsrExistWithAnotherAcc = false;
            }

            if (UsrExist){
                mH = new map<String,list<Wrap>>();
                for (g_Srvc__c s:[select id,uid__c,Name,lbl__c,Category__c,Sub_Category__c,Service_Group__c,
                                 (Select Id,DE__c,AP__c,usr__c From g_srvcAL__r where isDeleted = false and usr__c=:selectedUs.Id)
                                 from g_Srvc__c where isDeleted=false and actv__c=true and Service_Group__c <> null and Prk__c includes (:A.Prk__c) and AccTp__c includes (:A.Type)]){
                                     String c =s.Service_Group__c.split('\\;',0)[0];
                                     if (mH.get(c)==null)
                                     {
                                         mH.put(c,new list<Wrap>());
                                     }
                                     if (s.g_srvcAL__r.size()>0)
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
                List<mySerivceGroupRequest> servOpt2 = new List<mySerivceGroupRequest>();
                for (String grpName : mH.keyset()) { mySerivceGroupRequest sr = new mySerivceGroupRequest(); mySerivceGroupRequest sr1 = new mySerivceGroupRequest(); sr.grpName = grpName; sr1.grpName = grpName; for (Wrap wrp : mH.get(grpName)) { if (wrp.al.DE__c){ sr.grpDE = true; sr1.grpDE = true; } else{ sr.grpDE = false; sr1.grpDE = false; break; } } for (Wrap wrp : mH.get(grpName)) { if (wrp.al.AP__c){ sr.grpAE = true; sr1.grpAE = true; } else{ sr.grpAE = false; sr1.grpAE = false; break; } } List<String> servNm = new List<String>(); List<String> servNm1 = new List<String>(); for (Wrap wrp : mH.get(grpName)) { servNm.add(wrp.s.lbl__c); servNm1.add(wrp.s.lbl__c); } sr.groupedSerName = servNm; sr1.groupedSerName = servNm1; servOpt.add(sr); orgSrvOpt.add(sr1); }
                System.debug('======servOpt=====946'+servOpt);
                servOptions = servOpt;
                System.debug('======servOptions=====946'+servOptions);
                // orgSrvOpt = servOpt;
                System.debug('======orgSrvOpt=====946'+orgSrvOpt);
            }

            else{
                loadSerivceList();
            }
        }
        if (firstTimeLoad)
        {
            System.debug('=======inside firstTimeLoad=======');
            /*firstName= 'Please enter you First name';
            lastName= 'Please enter you Last name';
            passNumber= 'Please enter you Passport Number';
            emailId= 'Please enter you email address';

            phNo='Please enter your mobile number';
            addVal='';

            wrkphNo='Please enter your work number';
            username='Please enter your prefered username';
            CounCode='+971';
            WrkCounCode='+971';*/
            conExist = false;
            UsrExist = false;
            loadSerivceList();
        }

    }

    public void loadSerivceList() {
        servOptions = new List<mySerivceGroupRequest>();
        Schema.DescribeFieldResult fieldResult = g_Srvc__c.Service_Group__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        System.debug('=======inside loadSerivceList=======');
        for ( Schema.PicklistEntry f : ple){
            System.debug('=======service group picklist values=======');
            mySerivceGroupRequest sr = new mySerivceGroupRequest();
            sr.grpName = f.getLabel();
            sr.grpDE = false;
            sr.grpAE = false;
            List<g_Srvc__c> serNameList = [Select lbl__c from g_Srvc__c where Service_Group__c includes (:f.getLabel()) and isDeleted=false and actv__c=true and Prk__c includes (:A.Prk__c) and AccTp__c includes (:A.Type)];
            List<String> serName = new List<String>();
            for (g_Srvc__c sr1: serNameList)
                serName.add(sr1.lbl__c);
            sr.groupedSerName =  serName;
            servOptions.add(sr);
        }
        orgSrvOpt = servOptions;
        System.debug('=======outside service group picklist values======='+orgSrvOpt);
        System.debug('=======outside service group picklist values======='+servOptions);
    }

    public PageReference addUser(){ system.debug('#1073=====Inside AddUser===='); list<g_srvcAL__c> toInsertAL = new list<g_srvcAL__c>(); list<g_srvcAL__c> toDeleteAL = new list<g_srvcAL__c>(); /*AggregateResult[] muids= [select MAX(uid__c) from User];*/ String unqVal = nationality+passNumber; Savepoint sp = null; system.debug('#332=====conExist===='+conExist); system.debug('#333=====UsrExist===='+UsrExist); try{ if (conExist && UsrExist) { system.debug('#1077=====servOptions===='+servOptions); system.debug('#1077=====orgSrvOpt===='+orgSrvOpt); updateContact(); if (defaultGroupsAccess && (selectedUs.ProfileId != defaultProfile) ){ updateUser('toApprover',selectedUs.Id); } if (!defaultGroupsAccess && (selectedUs.ProfileId == defaultProfile) ){ updateUser('toDataEntry',selectedUs.Id); } for (mySerivceGroupRequest serReq : servOptions){ for (mySerivceGroupRequest serReq1 : orgSrvOpt){ system.debug('#1083=====serReq===='+serReq); system.debug('#1083=====serReq1===='+serReq1); if (serReq.grpName == serReq1.grpName){ if ((serReq.grpDE != serReq1.grpDE)||(serReq.grpAE != serReq1.grpAE)){ if (serReq.grpDE == true && serReq.grpAE == true){ for (Wrap wrp : mH.get(serReq.grpName)) {  g_srvcAL__c tempal = wrp.al; system.debug('#1092=====before tempal===='+tempal); tempal.DE__c = true;tempal.AP__c = true; system.debug('#1095=====after tempal===='+tempal); toInsertAL.add(tempal); } } if (serReq.grpDE == false && serReq.grpAE == false){ for (Wrap wrp : mH.get(serReq.grpName)) { g_srvcAL__c tempal = wrp.al; toDeleteAL.add(tempal); } } if (serReq.grpDE == true && serReq.grpAE == false){ for (Wrap wrp : mH.get(serReq.grpName)) { g_srvcAL__c tempal = wrp.al; tempal.DE__c = true;tempal.AP__c = false; toInsertAL.add(tempal); } } if (serReq.grpDE == false && serReq.grpAE == true){ for (Wrap wrp : mH.get(serReq.grpName)) { g_srvcAL__c tempal = wrp.al; tempal.DE__c = false;tempal.AP__c = true; toInsertAL.add(tempal); } } } } } } } else if (conExist && (UsrExist!=true) && (UsrExistWithAnotherAcc!=true)){ System.debug('=========inside else if======='+conExist); System.debug('=========inside else if======='+selectedEmp); User us = createUser(selectedEmp); updateContact(); if (defaultGroupsAccess){  for (g_Srvc__c ser: [select id,uid__c,Name,lbl__c,Category__c,Sub_Category__c,Service_Group__c from g_Srvc__c where isDeleted=false and actv__c=true and Service_Group__c <> null and Prk__c includes (:A.Prk__c) and AccTp__c includes (:A.Type)]){ toInsertAL.add(new g_srvcAL__c(AP__c=true,DE__c=true,srvc__c=ser.Id,usr__c=us.Id)); } System.debug('=========toInsertAL======='+toInsertAL);  } else{ System.debug('=======ServicesList======'+servOptions); for (mySerivceGroupRequest serReq : servOptions){ if (serReq.grpDE || serReq.grpAE){ for (g_Srvc__c ser : [select id,uid__c,Name,lbl__c,Category__c,Sub_Category__c,Service_Group__c from g_Srvc__c where isDeleted=false and actv__c=true and Service_Group__c includes (:serReq.grpName) and Prk__c includes (:A.Prk__c) and AccTp__c includes (:A.Type)]){ toInsertAL.add(new g_srvcAL__c(AP__c=serReq.grpAE,DE__c=serReq.grpDE,srvc__c=ser.Id,usr__c=us.Id)); } }  } } } else { System.debug('=========inside else======='+contactExistWithDiffAcc); System.debug('=========inside else======='+UsrExistWithAnotherAcc); Contact newCon = createContact(); User newUser1 = createUser(newCon);  System.debug('=========defaultGroupsAccess======='+defaultGroupsAccess); if (defaultGroupsAccess){  for (g_Srvc__c ser: [select id,uid__c,Name,lbl__c,Category__c,Sub_Category__c,Service_Group__c from g_Srvc__c where isDeleted=false and actv__c=true and Service_Group__c <> null and Prk__c includes (:A.Prk__c) and AccTp__c includes (:A.Type)]){ toInsertAL.add(new g_srvcAL__c(AP__c=true,DE__c=true,srvc__c=ser.Id,usr__c=newUser1.Id)); } System.debug('=========toInsertAL======='+toInsertAL);  } else{ System.debug('=======ServicesList======'+servOptions); for (mySerivceGroupRequest serReq : servOptions){ if (serReq.grpDE || serReq.grpAE){ for (g_Srvc__c ser : [select id,uid__c,Name,lbl__c,Category__c,Sub_Category__c,Service_Group__c from g_Srvc__c where isDeleted=false and actv__c=true and Service_Group__c includes (:serReq.grpName) and Prk__c includes (:A.Prk__c) and AccTp__c includes (:A.Type)]){ toInsertAL.add(new g_srvcAL__c(AP__c=serReq.grpAE,DE__c=serReq.grpDE,srvc__c=ser.Id,usr__c=newUser1.Id)); } }  } } } System.debug('#1176=======toInsertAL======'+toInsertAL); System.debug('#1176=======toDeleteAL======'+toDeleteAL); if (toInsertAL.size()>0) Upsert toInsertAL; if (toDeleteAL.size()>0) Delete toDeleteAL;  PageReference pageWhereWeEndUp = new PageReference('/myaccount'); /*create a PageReference object for the Home tab */ return pageWhereWeEndUp.setRedirect(true);  }catch (exception ex) { throw new DMLException(ex); /*return null;*/ }  }

    public void accessDefaultCntrl(){
        List<mySerivceGroupRequest> servOptions1 = new List<mySerivceGroupRequest>();
        system.debug('#1180======defaultGroupsAccess'+defaultGroupsAccess);
        if (defaultGroupsAccess){
            for ( mySerivceGroupRequest f : servOptions){
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
                            from User where ContactId=:Con.Id and contact.account.id=:A.Id ];
        System.debug('#1203=====checkUserExist'+usLst);
        if (usLst.size()>0){
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
        if (usLst.size()>0){
            UsrExistWithAnotherAcc = true;
            pgMsg ='There is an existing User with same Email for another Account : '+usLst[0].contact.account.Name+'Do you still want to add to this Account.';
            String usnm = A.Name.replaceAll('[^a-zA-Z0-9\\s+]', '');
            username = emailId+usnm.deleteWhitespace();
            System.debug('#495=====username'+username);
        }
        else{
            UsrExistWithAnotherAcc = false;
            username = emailId;
            pgMsg='';
        }
        System.debug('#502=====username'+username);
    }

    public void chkUserName(){
        System.debug('#504=====username'+username);
        username = username+'@'+A.park__c+'.axs';
        System.debug('username --  '+username);
        List<User> usLst = [select Id,ProfileId,FirstName,LastName,Email,Username,accountid,contact.account.id,contact.account.Name,contact.account.Type,contact.account.Prk__c
                            from User where IsActive=true and Username=:username];
        System.debug('#1203=====checkUserExistWithAnotherAcc'+usLst);
        if (usLst.size()>0){
            UsrExistWithAnotherAcc = true;
            pgMsg ='There is an existing User with same username for Account : '+usLst[0].contact.account.Name+'.If you still want to add to this Account, Please enter a unique username.';
            String usnm = A.Name.replaceAll('[^a-zA-Z0-9\\s+]', '');
            /*username = emailId+usnm.deleteWhitespace();*/
            System.debug('#495=====username'+username);
        }
        else{
            UsrExistWithAnotherAcc = false;
            /*username = emailId;*/
            pgMsg='';
        }
        System.debug('#502=====username'+username);
    }

    public User createUser(Contact newCon) { User nwU; System.debug('Line#504====emailId===' + emailId); try { /*AggregateResult[] muids = [select MAX(uid__c) from User];*/ String orgId = userInfo.getOrganizationId(); String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', ''); Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000)); String uniqueName = orgId + dateString + randomInt; string nick = newCon.email != null ? newCon.email.substring(0, newCon.email.indexOf('@')) : ''; nick += Datetime.now().getTime(); /*String ala = firstName.substring(0, 3)+lastname.substring(0, 2);*/ Id prfId; if (defaultGroupsAccess) prfId = defaultProfile; else prfId = deProfile; String usNm; if (UsrExistWithAnotherAcc) usNm = username; else { String msg = (newCon.email != null) ? newCon.email : emailId; /*usNm = msg+'.axsqa';*/ usNm = username + '@' + A.park__c + '.axs'; } System.debug('profileid===' + prfId); System.debug('username===' + usNm); System.debug('newCon===' + newCon.id); System.debug('newCon===' + newCon.FirstName); /*newUser1 = new User(alias=ala, email = newCon.email, emailencodingkey = 'ISO-8859-1', firstname = newCon.firstName, lastname = newCon.lastname, languagelocalekey = 'en_US', localesidkey = 'en_US', contactId = newCon.Id, timezonesidkey = 'Asia/Dubai', username = usNm, CommunityNickname = nick, ProfileId = prfId, IsActive = true);*/ nwU = new User(); nwU.ContactId = newCon.Id; nwU.FirstName = newCon.firstName; nwU.LastName = newCon.lastname; String nicknm = newCon.lastname.substring(0, 1) + String.valueof(Math.random()).substring(2, 8); nwU.Alias = nicknm; nwU.Email = (newCon.email != null) ? newCon.email : emailId; nwU.Username = username + '@' + A.park__c + '.axs'; nwU.ProfileId = prfId; String cnm = newCon.firstName + nicknm; nwU.CommunityNickname = (cnm.length() > 40) ? cnm.substring(0,39) : cnm; nwU.IsActive = true; nwU.TimeZoneSidKey = 'Asia/Dubai'; nwU.LocaleSidKey = 'en_GB'; nwU.LanguageLocaleKey = 'en_US'; nwU.EmailEncodingKey = 'ISO-8859-1'; Database.DMLOptions dmo = new Database.DMLOptions(); dmo.EmailHeader.triggerUserEmail = true; nwU.setOptions(dmo); insert nwU; } catch (Exception e) { system.debug(e.getStackTraceString()); throw e; } return nwU; }

    public Contact createContact(){ String psNum; if (contactExistWithDiffAcc) psNum = passNumber+'\\c'; else psNum = passNumber; Contact newCon = New Contact(FirstName = firstName,LastName =lastName,p__c = psNum,nc__c = nationality, Email= emailId, ha__c = addVal,STA__c = 'Active',HomePhone=WrkCounCode+wrkphNo,MobilePhone=CounCode+phNo, AccountId=A.Id); Insert newCon; return newCon; }

    public void updateContact(){ String unqiVal = nationality+passNumber; System.debug('unqiVal===='+unqiVal); Integer int1 = 0; List<Contact> con = [select Id,FirstName,LastName,Name,Personal_Photo__c,Photo_ID__c,Email,Job_Title_Formula__c, rped__c, ped__c, nc__c, rol__c,STA__c,isDeleted,p__c,Account.Name,Account.Id,MobilePhone,OtherPhone,ha__c from Contact where id=: selectedEmp.Id LIMIT 1]; if (con.size()>0){ if (con[0].Email != emailId){ con[0].Email = emailId; int1++; } if (con[0].MobilePhone != phNo){ con[0].MobilePhone = phNo; int1++; } if (con[0].OtherPhone != wrkphNo){ con[0].OtherPhone = wrkphNo; int1++; } if (con[0].ha__c != addVal){ con[0].ha__c = addVal; int1++; } } if (int1 > 0) Update con[0]; }

    @Future
    public static void updateUser(String str, Id usrId){ List<User> usr = [select Id,FirstName,LastName,profileId from User where id=: usrId LIMIT 1]; if (str == 'toApprover'){ usr[0].profileId = [Select Id From Profile Where Name='Z' LIMIT 1].Id; update usr[0]; } if (str=='toDataEntry'){ usr[0].profileId = [Select Id From Profile Where Name='X' LIMIT 1].Id; update usr[0]; } }

    public void validateUnique(){ System.debug('passport number===='+passNumber); System.debug('Nationality===='+nationality); String unqiVal = nationality+passNumber; System.debug('unqiVal===='+unqiVal); List<Contact> conLst = [select Id,FirstName,LastName,Name,Personal_Photo__c,Photo_ID__c,Email,Job_Title_Formula__c, rped__c, ped__c, nc__c, rol__c,STA__c,isDeleted,p__c,Account.Name,Account.Id from Contact where uid__c=: unqiVal]; if (conLst.size()>0) { if (conLst[0].Account.Id == A.Id){ pgMsg ='The contact already exists in your Account.'; contactExistWithSameAcc = true; contactExistWithDiffAcc = false; contactAlreadyExisits = true; foundContact = conLst[0]; }else{ pgMsg ='The contact already exists in system under Account:'+conLst[0].Account.Name+'.Do you still want to add to this Account?'; contactAlreadyExisits = true; contactExistWithDiffAcc = true; contactExistWithSameAcc = false; foundContact = conLst[0]; }  }else{ pgMsg =''; contactExistWithSameAcc = false; contactExistWithDiffAcc = false; contactAlreadyExisits = false; }  }

    public void clearDataCntrl(){ selectedEmp = new Contact();  firstName= ''; lastName= ''; passNumber= ''; emailId= ''; CounCode='+971'; phNo=''; addVal=''; WrkCounCode='+971'; wrkphNo=''; username=''; conExist = false; UsrExist = false; loadSerivceList();  }

    public class mySerivceGroupRequest{
        public String grpName{get;set;}
        public Boolean grpDE{get;set;}
        public Boolean grpAE{get;set;}
        public List<String> groupedSerName{get;set;}
    }

    class myEmployees{ public String IdVal{get;set;} public String conName{get;set;} public string conJobTitle{get;set;} public string conPassNo{get;set;} public string conImg{get;set;} }

    public class Wrap{ public g_Srvc__c s{get;set;} public g_srvcAL__c al{get;set;} public Wrap(g_Srvc__c oS,g_srvcAL__c oAL) { s=oS; al=oAL; } }

    /***************User Management Code Ends*******************/
    /****Code from gctlHm starts*****/

    public List<contact> contLst  {get;set;}
    public List<myAccount> myAccountLst {get;set;}
    public Map<String,User> uidUsrname{get;set;}

    public void loadContact() { myAccountLst = new List<myAccount>(); contLst = new List<contact>(); uidUsrname = new Map<String,User>(); system.debug('inisde loadContact >>'+A.Id); List<User> userLst = [Select id, Name, ContactId,isActive,Username, AccountID,ProfileId, Contact.Name,Contact.Personal_Photo__c,Contact.Photo_ID__c,Contact.Email, Contact.Job_Title_Formula__c, Contact.rped__c, Contact.ped__c, Contact.nc__c, Contact.rol__c,Contact.STA__c,Contact.isDeleted from User where AccountId =: A.Id]; for (User usr : userLst){ uidUsrname.put(usr.Id,usr); } system.debug('userLst >>'+userLst);  for (User u : userLst){ myAccount m = new myAccount(); m.con = u.contact; m.usr = u; m.usrPhoto = u.Contact.Photo_ID__c; if (u.isActive) { if (u.ProfileId == deProfile) m.usrtype = 'DataEntryUser'; if (u.ProfileId == defaultProfile) m.usrtype = 'SuperUser'; } else m.usrtype = 'InActive'; myAccountLst.add(m); } system.debug('myAccountLst >>'+myAccountLst); }
    class myAccount{
        public Contact con{get;set;}
        public User usr{get;set;}
        public string usrPhoto{get;set;}
        public string usrtype{get;set;}
    }
    public void enUser(Id uid, Boolean actv){ system.debug('in enUser2 >>'+uid +' || '+actv ); if (uid == null){gU.AddWarningMsg(Label.msgNoChange); return;} User u = uidUsrname.get(uid); u.IsActive = actv; update u; system.debug('updated User >>'+ u); init(); gU.AddSuccessMsg(Label.msgSuccess); }

    public void enUser(){system.debug('in enUser');try{enUser(String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('uid')),true);} catch (exception ex){gU.AddErrorMsg(ex);}}
    public void dsbUser(){system.debug('in dsbUser'); try{enUser(String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('uid')),false);} catch (exception ex){gU.AddErrorMsg(ex);}}


}