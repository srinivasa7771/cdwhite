public class gctlConMgmt {
    public String   mgInName        {get;set;}
    public String   mgInPriEmail    {get;set;}
    public String   mgInPriPhn      {get;set;}
    public String   mgInSecEmail    {get;set;}
    public String   mgInSecPhn      {get;set;}
    public String   errMsg          {get;set;}
    public Integer  noOfCons        {get;set;}
    public Integer  exCons          {get;set;}
    public boolean  prolFlg         {get;set;}
    public Boolean  resultrol       {get;set;}
    public Boolean  usem            {get;set;}
    public string   mroles          {get;set;}
    public Boolean  success         {get;set;}
    public Boolean  reld            {get;set;}
    public account  acc             {get;set;}
    public string jsonString        {get;set;}
    public List<coninfo__c> lstCI   {get;set;}
    public set<String> chkrol       {get;set;}
    public coninfo__c mgInConinf    {get;set;}
    public coninfo__c mgInConinfnew {get;set;}
    private set<String> chkrolVal;
    private User u;
    private String van;
    //public coninfo__c managerincharge {get;set;}
    public coninfo__c financialcon {get;set;}
    public coninfo__c admincon {get;set;}
    public coninfo__c legalcon {get;set;}
    public coninfo__c hrcon {get;set;}
    public coninfo__c mkcon {get;set;}
    public coninfo__c fmcon {get;set;}
    private user mgInChg;
    private Id accId;
    private String MANAGER_IN = 'Manager Incharge';
    public gctlConMgmt() {loadData();}

    public gctlConMgmt(ApexPages.StandardController controller) {
        loadData();
        String srvcId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sid'));
        mgInConinfnew = new coninfo__c();

        if (String.isNotBlank(srvcId)) {
            reld = true;}}

    public PageReference saveAccInfo() {

        Savepoint sp = Database.setSavepoint();
        U = [select Id, accountid, ContactId, contact.account.id, contact.account.ORACLE_PARTY_ID__c from User where id=:UserInfo.getUserId() limit 1];

        vldtRoles();//check if contacts with all roles are present
        if (!resultrol) {
            errMsg = '**Please add the mandatory Key-Contacts [Active] : </br> ';
            for (String str : chkrol) {errMsg += ' </br> &bull;&nbsp;&nbsp;' + str; }
            gu.AddErrorMsg(errMsg + '</br>');
            return null;
        }else{

            success = false; String orclId = U.contact.account.ORACLE_PARTY_ID__c;
            List<coninfo__c> lstConToInsrt = new List<coninfo__c>();List<coninfo__c> lstConToUpdt = new List<coninfo__c>();
            System.debug('mgInConinf:: ' + mgInConinf);
            mgInConinf.acc__c = U.accountid;
            if (String.isNotBlank(mgInConinf.id)) { lstConToUpdt.add(mgInConinf);}else{lstConToInsrt.add(mgInConinf);}

            try{
                for (coninfo__c cInfo : lstCI) {
                    if (String.isNotBlank(cInfo.rol__c)) {
                        cInfo.acc__c = U.accountid;
                        if (String.isNotBlank(cInfo.id)) {
                            lstConToUpdt.add(cInfo);
                        }else{
                            lstConToInsrt.add(cInfo);}}}

                if (lstConToInsrt.size() > 0 || lstConToUpdt.size()>0) {
                    if (lstConToInsrt.size()>0) {insert lstConToInsrt;} if (lstConToUpdt.size()>0) {update lstConToUpdt;}update acc;

                    success = true; noOfCons = lstConToInsrt.size();
                    List<Id> lstIds = new List<Id>();
                    for (coninfo__c ci : lstConToInsrt) {
                        lstIds.add(ci.Id);
                    }
                    for (coninfo__c ci : lstConToUpdt) {
                        lstIds.add(ci.Id);
                    }

                    // push data to tecom
                    System.debug('acc.van__c : : ' + acc.van__c);
                    String vanNo = (String.isBlank(acc.van__c) || (String.isNotBlank(acc.van__c) && acc.van__c.equalsIgnoreCase('null'))) ? null : acc.van__c;

                    ParkingM.pushConInfo(lstIds, orclId, vanNo);gu.AddSuccessMsg('['+lstIds.size()  + '] Contact(s) saved successfully.');
                }else{ gu.AddWarningMsg('Nothing to Save, please enter contact details.');}
            }catch (Exception ex) {Database.rollback(sp);gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, '#Exception: ' + ex.getMessage()); return null;}
            return null;
        }
    }

    public void loadData() {

        try{
            reld = false; van=''; lstCI = new List<coninfo__c>();
            acc = new account();
            mgInConinf = new coninfo__c();
            financialcon = new coninfo__c();
            admincon = new coninfo__c();
            legalcon = new coninfo__c();
            hrcon = new coninfo__c();
            mkcon = new coninfo__c();
            fmcon = new coninfo__c();
            Boolean isMgrAvailable = false;
            U = [select Id, accountid, ContactId, contact.account.id, contact.account.ORACLE_PARTY_ID__c, contact.account.Prk__c from User where id=:UserInfo.getUserId() limit 1];

            getContacts();
            if (!lstCI.isEmpty()) {
                system.debug('lstCI'+lstCI);
                for (coninfo__c eCon : lstCI) {
                    system.debug('eCon'+eCon);
                    if (String.isNotBlank(eCon.rol__c) && eCon.rol__c.contains('General Manager')) {

                        mgInConinf = eCon;
                        isMgrAvailable = true;

                    }else if (String.isNotBlank(eCon.rol__c) && eCon.rol__c.contains('Admin Contact')) {
                        admincon = eCon;

                    }else if (String.isNotBlank(eCon.rol__c) && eCon.rol__c.contains('Financial Contact')) {
                        financialcon = eCon;

                    }else if (String.isNotBlank(eCon.rol__c) && eCon.rol__c.contains('Legal Contact')) {

                        legalcon = eCon;

                    }else if (String.isNotBlank(eCon.rol__c) && eCon.rol__c.contains('HR Contact')) {

                        hrcon = eCon;

                    }else if (String.isNotBlank(eCon.rol__c) && eCon.rol__c.contains('Marketing Contact')) {

                        mkcon = eCon;

                    }else if (String.isNotBlank(eCon.rol__c) && eCon.rol__c.contains('Facility Management Contact')) {

                        fmcon = eCon;

                    }
                }
            }

            if (!isMgrAvailable) {
                try{
                    List<Contact> c = [SELECT id, Name, type__c, email, phone, MobilePhone FROM Contact WHERE AccountId=:accId AND type__c=:MANAGER_IN order by lastModifiedDate DESC limit 1];

                    if (c.size()==0) {c = [SELECT Id, Name, type__c, email, phone, MobilePhone, STA__c FROM Contact WHERE id=:U.ContactId limit 1]; }

                    if (!c.isEmpty()) {
                        mgInConinf.con__c = c[0].id;
                        mgInConinf.phone__c = c[0].MobilePhone;
                        mgInConinf.name__c = c[0].Name;
                        mgInConinf.rol__c = MANAGER_IN;
                        mgInConinf.sphn__c = c[0].Phone;
                        mgInConinf.sta__c = 'Active';
                        mgInConinf.email__c = c[0].Email; mgInConinf.acc__c = accId; mgInConinf.extcon__c= true;
                    }

                }catch (Exception e) {system.debug('#Exception: ' + e.getMessage() + e.getStackTraceString());}
            }

            noOfCons = lstCI.size();System.debug('noOfCons : ' + noOfCons);
            if (String.isNotBlank(accId)) {acc = [SELECT Id, name, van__c, ORACLE_PARTY_ID__c, pb__c, ad__c FROM Account WHERE id=:accId]; van = acc.van__c;}
            System.debug('van : ' + van);
        } catch (Exception ex) {system.debug('#Exception: ' + ex.getMessage() + ex.getStackTraceString());}
    }

    public void vldtRoles() {

        string rolchk = '';chkrol = new set<String>();

        for (coninfo__c cl : lstCI ) {
            if (String.isNotBlank(cl.Sta__c) && cl.Sta__c.equalsIgnoreCase('active')) {
                rolchk = rolchk +';'+ cl.rol__c;
            }
        }
        System.debug('mgInConinf.Rol__c : ' + mgInConinf);
        rolchk += ';' + mgInConinf.Rol__c;

        Schema.DescribeFieldResult fieldResult = coninfo__c.rol__c.getDescribe();
        List<Schema.PicklistEntry> pleRoles = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry f : pleRoles) {
            if (!rolchk.contains(f.getLabel())) {
                chkrol.add(f.getLabel());
            }
        }

        if (!rolchk.contains(MANAGER_IN)) {chkrol.add(MANAGER_IN);}
        resultrol = chkrol.isEmpty();
    }

    public void getContacts() {
        try{
            accId = U.accountid; System.debug('U.accountid : ' + U.accountid);
            lstCI = [SELECT Id, Name__c, Rol__c, Con__c, Phone__c, sphn__c, Email__c, seml__c,
                ldno__c, sta__c, extcon__c, conid__c  FROM ConInfo__c WHERE sta__c='Active' AND acc__c=:accId ORDER BY LastModifiedDate];
            System.debug('lstCI : ' + lstCI.size());
            //   if (U.contact.account.Prk__c!='Dubai Design District') {lstCI = new List<coninfo__c>(); //lstCI = new ParkingM().getConInfo(U.contact.account.ORACLE_PARTY_ID__c);
            //  }
            // exCons = lstCI.size();
            vldtRoles();
        }catch (Exception ex) {
            if (ex.getMessage().contains('ENTITY_IS_DELETED')) {gu.AddErrorMsg('Some Contacts have been deleted from AXS, please contact your Administrator.');
                                                             }else{gu.AddErrorMsg('Technical Error, please contact your Administrator.');}
            System.debug('#Exception: ' + ex.getMessage() + ex.getStackTraceString());
        }
    }

    public PageReference addCon() {
        lstCI.add(new coninfo__c(sta__c='Active'));
        noOfCons = lstCI.size();
        return null;
    }
    public PageReference rmvCon() {
        lstCI.remove(lstCI.size()-1);
        noOfCons = lstCI.size();
        return null;
    }
    public void parseJsondata() {
        string croles = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('mroles'));
        string ischeckbox = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('isselected'));
        system.debug('accId inside parse'+accId);
        String ManagerId;
        Boolean adminchecked=false;
        Boolean financechecked=false;
        Boolean legalchecked=false;
        string accVan;
        string accOrc;
        Savepoint sp = Database.setSavepoint();
        system.debug('acc---'+acc);
        system.debug('acc---'+acc.van__c);
        try{
            if (Schema.sObjectType.Account.isUpdateable()) {
                update acc;
            }
        }catch (exception ex) {
            system.debug('ex---'+ex);
            system.debug('ex---msg'+ex.getMessage());
            system.debug('ex----lline'+ex.getLineNumber());
        }

        if (String.isNotBlank(acc.van__c))
            accVan = acc.van__c;
        else accVan ='';
        if (String.isNotBlank(acc.ORACLE_PARTY_ID__c))
            accOrc = acc.ORACLE_PARTY_ID__c;
        else accOrc ='';
        system.debug('admincon.name__c::'+admincon.name__c);
        List<coninfo__c> updateConLst = new List<coninfo__c> ();
        if (String.isNotBlank(admincon.name__c)) {
            admincon.acc__c=acc.Id;
            admincon.rol__c='Admin Contact';
            admincon.CcrmRole__c='Office Admin/Manager';
            admincon.email__c=admincon.email__c;
            admincon.phone__c=admincon.phone__c;
            updateConLst.add(admincon);
        }

        system.debug('ischeckbox-----'+ischeckbox);
        system.debug('croles-----'+croles);
        Set<id> statusLst = new Set<Id>();
        Set<String> namesLst = new Set<String>();
        Set<String> roleSet = new Set<string>();
        List<id> setConinfo = new List<Id>();
        List<coninfo__c> coninfostatusupdate = new List<coninfo__c>();
        List<coninfo__c> coninfoastatusupdate = new List<coninfo__c>();
        List<String> lstString = croles.split(';');
        Map<Id, String> mapRoles = new Map<Id, string>();
        Map<Id, String> managerRoles = new Map<Id, string>();
        Map<Id, coninfo__c> mapinactiveRoles = new Map<Id, coninfo__c>();
        Set<Id> updateroles = new Set<Id>();
        List<coninfo__c> deactconLst = new List<coninfo__c>();
        List<String> roles = new List<String>();
        String ccrmroles;

        system.debug('mgInConinf.seml__c::'+mgInConinf.seml__c);
        system.debug('mgInConinf.sphn__c::'+mgInConinf.sphn__c);
        if (String.isNotBlank(mgInConinf.name__c)) {
            if (String.isBlank(ManagerId)) {
                mgInConinf.acc__c=acc.Id;
                mgInConinf.rol__c='General Manager'+';'+croles;
                mgInConinf.seml__c=mgInConinf.seml__c;
                system.debug('croles---->'+croles);
                if (croles.contains('Admin Contact') || croles.contains('Financial Contact')) {
                    system.debug('inisde Admin---->');
                    ccrmroles = croles.replace('Admin Contact', 'Office Admin/Manager').replace('Financial Contact', 'VAT Contact;Billing Contact');
                    system.debug('outside Admin---->'+ccrmroles);
                }
                if (String.isNotBlank(ccrmroles)) mgInConinf.CcrmRole__c='Manager In-charge'+';'+ccrmroles;
                else mgInConinf.CcrmRole__c='Manager In-charge'+';'+croles;
                mgInConinf.sphn__c=mgInConinf.sphn__c;
                updateConLst.add(mgInConinf);
            }
            else{
                mgInConinf.acc__c=acc.Id;
                mgInConinf.rol__c='General Manager'+';'+croles;
                mgInConinf.Id=ManagerId;
                system.debug('croles---->'+croles);
                if (croles.contains('Admin Contact') || croles.contains('Financial Contact')) {
                    system.debug('inisde Admin---->');
                    ccrmroles = croles.replace('Admin Contact', 'Office Admin/Manager').replace('Financial Contact', 'VAT Contact;Billing Contact');
                    system.debug('outside Admin---->'+ccrmroles);
                }
                system.debug('before check bkank ccrmroles---->'+ccrmroles);
                if (String.isNotBlank(ccrmroles)) mgInConinf.CcrmRole__c='Manager In-charge'+';'+ccrmroles;
                else mgInConinf.CcrmRole__c='Manager In-charge'+';'+croles;
                mgInConinf.seml__c=mgInConinf.seml__c;
                mgInConinf.sphn__c=mgInConinf.sphn__c;
                updateConLst.add(mgInConinf);
            }
        }

        if (String.isNotBlank(financialcon.name__c)) {
            financialcon.acc__c=acc.Id;
            financialcon.rol__c='Financial Contact';
            financialcon.CcrmRole__c ='VAT Contact;Billing Contact';
            financialcon.email__c=financialcon.email__c;
            financialcon.phone__c=financialcon.phone__c;
            financialcon.seml__c=financialcon.seml__c;
            financialcon.sphn__c=financialcon.sphn__c;
            updateConLst.add(financialcon);
        }
         system.debug('legalcon----'+legalcon);
         system.debug('legalcon name----'+legalcon.name__c);
        if (String.isNotBlank(legalcon.name__c)) {
            legalcon.acc__c=acc.Id;
            legalcon.rol__c='Legal Contact';
            legalcon.CcrmRole__c ='Legal Contact';
            legalcon.email__c=legalcon.email__c;
            legalcon.phone__c=legalcon.phone__c;
             legalcon.seml__c=legalcon.seml__c;
            legalcon.sphn__c=legalcon.sphn__c;

            updateConLst.add(legalcon);

        }
          system.debug('hrcon----'+hrcon);
         system.debug('hrcon name----'+hrcon.name__c);
        if (String.isNotBlank(hrcon.name__c)) {
            hrcon.acc__c=acc.Id;
            hrcon.rol__c='HR Contact';
            hrcon.CcrmRole__c='HR Contact';
            hrcon.email__c=hrcon.email__c;
            hrcon.phone__c=hrcon.phone__c;
             hrcon.seml__c=hrcon.seml__c;
            hrcon.sphn__c=hrcon.sphn__c;

            updateConLst.add(hrcon);

        }
           system.debug('mkcon----'+mkcon);
         system.debug('mkcon name----'+mkcon.name__c);
        if (String.isNotBlank(mkcon.name__c)) {
            mkcon.acc__c=acc.Id;
            mkcon.rol__c='Marketing Contact';
            mkcon.CcrmRole__c='Marketing Contact';
            mkcon.email__c=mkcon.email__c;
            mkcon.phone__c=mkcon.phone__c;
             mkcon.seml__c=mkcon.seml__c;
            mkcon.sphn__c=mkcon.sphn__c;

            updateConLst.add(mkcon);

        }
           system.debug('fmcon----'+fmcon);
         system.debug('fmcon name----'+fmcon.name__c);
        if (String.isNotBlank(fmcon.name__c)) {
            fmcon.acc__c=acc.Id;
            fmcon.rol__c='Facility Management Contact';
            fmcon.CcrmRole__c='Facility Management Contact';
            fmcon.email__c=fmcon.email__c;
            fmcon.phone__c=fmcon.phone__c;
             fmcon.seml__c=fmcon.seml__c;
            fmcon.sphn__c=fmcon.sphn__c;

            updateConLst.add(fmcon);

        }
        system.debug('updateConLst-----'+updateConLst);

        if (!updateConLst.isEmpty()) {
            if (Schema.sObjectType.coninfo__c.isCreateable()) {
                upsert updateConLst;
            }
            if (ischeckbox == 'true' && String.isNotBlank(croles)) {
                for (coninfo__c c : [select id, rol__c, seml__c, sphn__c from coninfo__c where acc__c=:accId]) {
                    if (!c.rol__c.contains('General Manager')) {
                        mapRoles.put(c.id, c.rol__c);
                    }
                    if (c.rol__c.contains('General Manager')) {
                        ManagerId = c.Id;
                        managerRoles.put(c.id, c.rol__c);
                    }
                    system.debug('ManagerId'+ManagerId);
                }
                system.debug('managerRoles'+managerRoles);
                     system.debug('mapRoles'+mapRoles);
                 system.debug('lstString'+lstString);
                if (!mapRoles.isEmpty()) {
                    for (String mp:mapRoles.keyset()) {
                        for (string str : lstString) {
                            if (mapRoles.get(mp).contains(str)) {

                                statusLst.add(mp);
                                namesLst.add(mapRoles.get(mp));

                            }

                        }

                    }
                }
                   system.debug('statusLst'+statusLst);
                 system.debug('namesLst'+namesLst);
                if (!statusLst.isEmpty()) {
                    for (coninfo__c coninfo :[select id, rol__c, Sta__c from coninfo__c where Id In:statusLst]) {

                        coninfo__c cin = new coninfo__c(Id=coninfo.Id, Sta__c='Inactive');
                        coninfostatusupdate.add(cin);
                    }
                }
                for (coninfo__c conMI :[select id, rol__c, Sta__c from coninfo__c where rol__c Includes('Manager Incharge') AND Sta__c = 'Active']) {
                    List < String > rolLst = conMI.rol__c.split(';');
                    if (rolLst.size() == 1 && rolLst[0] == 'Manager Incharge')
                        conMI.Sta__c = 'Inactive';
                    if (rolLst.size() > 1) {
                        String newRole = '';
                        for (String str1: rolLst) {
                            if (str1 != 'Manager Incharge') {
                                if (newRole == '') newRole = str1;
                                else newRole = newRole + ';' + str1;
                            }
                        }
                        conMI.rol__c = newRole;
                    }
                    coninfostatusupdate.add(conMI);
                }
                system.debug('coninfostatusupdate========'+coninfostatusupdate);
                if (!coninfostatusupdate.isEmpty()) {
                    if (Schema.sObjectType.coninfo__c.isUpdateable()) {
                        update coninfostatusupdate;
                    }
                }

                for (coninfo__c con : [select Id, sta__c, rol__c from coninfo__c where rol__c Excludes('General Manager', 'Manager Incharge') AND sta__c='Inactive' AND acc__c=:acc.Id]) {
                    mapinactiveRoles.put(con.Id, con);
                }
                 system.debug('mapinactiveRoles'+mapinactiveRoles);
                if (!mapinactiveRoles.isEmpty() && !managerRoles.isEmpty()) {
                    for (String mr : managerRoles.keyset()) {
                        for (String mar : mapinactiveRoles.Keyset()) {

                            if (!managerRoles.get(mr).contains(mapinactiveRoles.get(mar).rol__c)) {

                                updateroles.add(mar);
                                roles.add(mapinactiveRoles.get(mar).rol__c);

                            }

                        }

                    }

                }
                system.debug('updateroles-->'+updateroles);
                 system.debug('roles-->'+roles);
                if (!updateroles.isEmpty()) {
                    for (coninfo__c coninfo :[select id, rol__c, Sta__c from coninfo__c where Id In:updateroles AND rol__c In:roles]) {

                        coninfo__c cin = new coninfo__c(Id=coninfo.Id, Sta__c='Active');
                        coninfoastatusupdate.add(cin);
                    }
                }
                system.debug('coninfoastatusupdate-->'+coninfoastatusupdate);
                if (!coninfoastatusupdate.isEmpty()) {
                    if (Schema.sObjectType.coninfo__c.isCreateable()) {
                        upsert coninfoastatusupdate;
                    }
                }
                Set<Id> updatedIds = new Set<Id>();
                 Set<Id> conLstIds = new Set<Id>();
                 List<coninfo__c> conLstactid = new List<coninfo__c>();
                if (!coninfoastatusupdate.isEmpty()) {
                    for (coninfo__c coninfo :coninfoastatusupdate) {
                       updatedIds.add(coninfo.Id);
                    }
                    system.debug('updatedIds'+updatedIds);
                    if (!updatedIds.isEmpty()) {
                        List<coninfo__c> conLst = [select id, Sta__c from coninfo__c where Id In:updatedIds AND Sta__c='Active'];
                        if (conLst.size()>1) {
                            for (coninfo__c con : conLst) {
                               conLstIds.add(con.id);
                            }
                          system.debug('conLstIds'+conLstIds);
                            if (!conLstIds.isEmpty()) {
                               conLstactid = [select id, Sta__c from coninfo__c where Id In:conLstIds order by createddate DESC LIMIT 1];

                            }
                             system.debug('conLstactid'+conLstactid);
                             List<coninfo__c> conLst1 = [select id, Sta__c from coninfo__c where Id In:updatedIds AND Sta__c='Active' AND ID NOT IN:conLstactid];
                            for (coninfo__c con1:conLst1) {
                                coninfo__c con = new coninfo__c(Id=con1.id, Sta__c='Inactive');
                                deactconLst.add(con);
                            }
                             system.debug('deactconLst'+deactconLst);
                            if (!deactconLst.isEmpty()) {

                               if (Schema.sObjectType.coninfo__c.isUpdateable()) {
                                   update deactconLst;
                               }
                            }

                        }

                    }
                }

            }
            try{
                for (coninfo__c cids :updateConLst) {
                    setConinfo.add(cids.id);

                }
                ParkingM.pushConInfo(setConinfo, accOrc, accVan);
            }catch (Exception ex) {
                Database.rollback(sp);
                gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, '#Exception: ' + ex.getMessage());
            }

        }

    }
}