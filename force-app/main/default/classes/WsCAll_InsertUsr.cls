global class WsCAll_InsertUsr implements Database.Batchable <sObject>, Database.AllowsCallouts {

    List<Contact> lstConToUpsert;List<NewUser> lstUsrToUpsrt;Map<String, Set<String>>dupContacts;
    Map<String, User> mapUsrConsByUID = new Map<String, User>();
    Map<String, String> mapAccByLic  = new Map<String, String>();
    Map<String, Contact> mapConsByUID = new Map<String, Contact>();

    global Database.QueryLocator start(Database.BatchableContext BC) {
        string type = 'UserCreation';
        String query = 'Select Id, err_cd__c, pmid__c, rq_jsn__c, res_jsn__c, xwsc__c, intsts__c, err_msg__c  from ws_call__c where ws_typ__c = :type AND intsts__c =\'Ready for Integration\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<ws_call__c> scope) {
        fetchMangerIn(scope);
    }

    public void fetchMangerIn(List<ws_call__c> lstwsCall) {
        List<ws_call__c> wsToUpdate = new List<ws_call__c>();

        try{

            for (ws_call__c ws : lstwsCall) {mapAccByLic.put(ws.rq_jsn__c, ws.pmid__c);}
            System.debug('<mapAccByLic> : ' + mapAccByLic);
            //String respBody = '{"Managers":[{"accLicNo":"33333", "salutation":"Mr.", "firstName":"Super33", "lastName":"axs333", "mobile":"050001111", "email":"sacx.h@tecomgroup.ae", "passportNo":"Test123", "nationality":"Tunisia"}]}';
            accIDs ids = new accIDs();
            ids.AccLicNos = new List<String>(mapAccByLic.keySet());
            String reqBody = JSON.serialize(ids);
            System.debug(reqBody);

            Http h = new Http();
            HttpRequest request     = new HttpRequest();
            HttpResponse response   = new HttpResponse();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept', 'application/json');
            request.setEndpoint('callout:DCCA_Auth/apexrest/fetchManagersInfo');
            request.setTimeout(90000);request.setMethod('POST');
            request.setBody(reqBody);
            response = h.send(request);

            if (response.getStatusCode()==200) {
                String respBody = '{"Managers":[]}';
                if (response.getBody()!=null) {respBody = '{"Managers":' + response.getBody() + '}';}
                System.debug('<response.getBody()> : ' + respBody);

                Records recs = (Records)JSON.deserialize(respBody, WsCAll_InsertUsr.Records.class);
                if (recs != null) {autoCreate(recs.Managers);}
                for (ws_call__c ws : lstwsCall) {
                    ws.intsts__c = 'Success';
                    wsToUpdate.add(ws);
                }
                if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                    update wsToUpdate;
                }
            }else{ }
        }catch (exception ex) {

            for (ws_call__c ws : lstwsCall) {
                    ws.res_jsn__c = ex.getMessage() + ' -- ' + ex.getStackTraceString();
                    ws.intsts__c = 'Failed';
                    wsToUpdate.add(ws);
            }
            if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                update wsToUpdate;
            }
        }
    }

    public void autoCreate(List<Manager> lstMngr) {
        List<String> lstUIDs = new List<String>();
        List<String> lstEmail = new List<String>();
        Map<String, User> mapUsrByConID = new Map<String, User>();
        dupContacts = new Map<String, Set<String>>();

        List<User> lstUsers = new List<User>();
        lstConToUpsert = new List<Contact>();lstUsrToUpsrt = new List<NewUser>();

        for (Manager m : lstMngr) {lstUIDs.add(m.nationality+ m.passportNo);  lstEmail.add(m.email); }
        List<User> lstExistingUsrs = [Select id, name, userName, Email, AccountId, contact.Account.lc__c,
            contactId, contact.name, contact.Email, contact.nc__c, contact.p__c, contact.rol__c,
            contact.UID__c from User where contact.uidf__c=:lstUIDs OR userName=:lstEmail] ;

        for (User usr : lstExistingUsrs) {mapUsrConsByUID.put(usr.Contact.UID__c, usr);  mapUsrByConID.put(usr.ContactId, usr);}

        List<Contact> consWithoutUser = [Select Id, Name, Email, AccountId, Account.lc__c, UID__c, nc__c, p__c, Type__c, rol__c From Contact where UIDF__c=:lstUIDs OR Id=:mapUsrByConID.keySet()];

        Set<String> t;

        for (Contact c : consWithoutUser) {
            mapConsByUID.put(c.UID__c, c);String x=(c.UID__c).replaceAll('/c', '');
            if (!dupContacts.containsKey(x)) {dupContacts.put(x, new Set<String>());}
            t = dupContacts.get(x); t.add(c.Account.lc__c); dupContacts.put(x, t);
        }

        for (Manager m : lstMngr) {
            m.dupCon = false; m.dupUsr=false;
            String uid = m.nationality+''+m.passportNo.toUpperCase();
            System.debug('*** uid : ' + uid);

            if (mapUsrConsByUID.containsKey(uid)) {
                User u = mapUsrConsByUID.get(uid); Set<String> extAccs = dupContacts.get(uid);
                if (extAccs != null && extAccs.contains(m.accLicNo)) {
                    m.dupCon=null; m.dupUsr=null; /**SKIP THE USER/CONTACT CREATION**/
                }else{
                    m.dupCon = true; m.dupUsr=true;
                    if (dupContacts.containsKey(uid)) {m.passportNo+='/c'.repeat(dupContacts.get(uid).size());   }
                }
            }else{
                if (mapConsByUID.containsKey(uid)) {
                    Contact c = mapConsByUID.get(uid);
                    Set<String> extAccs = dupContacts.get(uid);
                    if (extAccs != null && !extAccs.contains(m.accLicNo)) {
                        m.dupCon=true;
                        m.dupUsr=true;
                        if (dupContacts.containsKey(uid)) {
                            m.passportNo+='/c'.repeat(dupContacts.get(uid).size());
                        }
                    }
                    else{
                        m.dupCon=true;
                        m.dupUsr=false;
                    }
                                                 }

            }
        }
        System.debug('*** lstMngr : ' + lstMngr);
        createConUsr(lstMngr);

        if (Schema.sObjectType.Contact.isCreateable()) {
            upsert lstConToUpsert;
        }

        Map<string, string> mapUpsertedCons = new Map<string, string>();

        for (Contact c : lstConToUpsert) {
            mapUpsertedCons.put(c.nc__c+c.p__c, c.Id);
        }
        System.debug('*** mapUpsertedCons : ' + mapUpsertedCons);

        for (NewUser u : lstUsrToUpsrt) {
            if (String.isBlank(u.usr.ContactId)) {
                u.usr.ContactId = mapUpsertedCons.get(u.conUID);
                lstUsers.add(u.usr);
            }
        }

        System.debug('*** lstUsers : ' + lstUsers);
        if (Schema.sObjectType.User.isCreateable()) {
            insert lstUsers;
        }
    }

    void createConUsr(List<Manager> lstMngr) {

        for (Manager m : lstMngr) {
            if (m.dupCon == null) {continue;}
            Contact c;
            if (m.dupCon  && !m.dupUsr) {
                //update the existing contact
                c = mapConsByUID.get(m.nationality+m.passportNo);
                if (c != null) {c.AccountId = mapAccByLic.get(m.accLicNo); c.email=m.email; c.mobilephone=m.mobile; c.Type__c='Manager Incharge';}
            }else if (m.dupCon && m.dupUsr) {
                    String cfirstname ='';
                    String cmiddlename='';
                if (m.firstname.length()>40) {
                    List<String> strlst = m.firstname.split(' ');
                    Integer len = strlst.size();
                    system.debug(len);
                    if (strlst.size() >0) {
                    integer i = 0;
                    while ((i<len) && ((cfirstname + strlst[i]+' ').length() < 40)) {
                        cfirstname = cfirstname + strlst[i]+' ';
                        i++;
                        System.debug(i);
                        System.debug(cfirstname);
                    }
                    while ((i<len) && ((cmiddlename + strlst[i]+' ').length() < 40)) {
                        cmiddlename = cmiddlename + strlst[i]+' ';
                        i++;
                        System.debug(i);
                        System.debug(cmiddlename);
                    }

                    System.debug('firstname===='+cfirstname);
                        System.debug('middlename===='+cmiddlename);
                    }
                }
                if (m.firstName.length()<40)
                    c = new Contact(Salutation=m.salutation, firstname=m.firstName, lastName=m.lastName,
                        mobilephone=m.mobile, email=m.email, nc__c=m.nationality, p__c=m.passportNo, STA__c='Inactive',
                        rol__c='Employee', Type__c='Manager Incharge', AccountId=mapAccByLic.get(m.accLicNo));
                else
                    c = new Contact(Salutation=m.salutation, firstname=cfirstname, middlename=cmiddlename,
                        lastName=m.lastName, mobilephone=m.mobile, email=m.email, nc__c=m.nationality, p__c=m.passportNo,
                        STA__c='Inactive', rol__c='Employee', Type__c='Manager Incharge', AccountId=mapAccByLic.get(m.accLicNo));
            }else if (!m.dupCon) {
                String cfirstname ='';
                    String cmiddlename='';
                if (m.firstname.length()>40) {
                    List<String> strlst = m.firstname.split(' ');
                    Integer len = strlst.size();
                    system.debug(len);
                    if (strlst.size() >0) {
                    integer i = 0;
                    while ((i<len) && ((cfirstname + strlst[i]+' ').length() < 40)) {
                        cfirstname = cfirstname + strlst[i]+' ';
                        i++;
                        System.debug(i);
                        System.debug(cfirstname);
                    }
                    while ((i<len) && ((cmiddlename + strlst[i]+' ').length() < 40)) {
                        cmiddlename = cmiddlename + strlst[i]+' ';
                        i++;
                        System.debug(i);
                        System.debug(cmiddlename);
                    }

                    System.debug('firstname===='+cfirstname);
                        System.debug('middlename===='+cmiddlename);
                    }
                }
                if (m.firstName.length()<40)
                    c = new Contact(Salutation=m.salutation, firstname=m.firstName, lastName=m.lastName,
                        mobilephone=m.mobile, email=m.email, nc__c=m.nationality, p__c=m.passportNo, STA__c='Inactive',
                        rol__c='Employee', Type__c='Manager Incharge', AccountId=mapAccByLic.get(m.accLicNo));
                else
                    c = new Contact(Salutation=m.salutation, firstname=cfirstname, middlename=cmiddlename,
                        lastName=m.lastName, mobilephone=m.mobile, email=m.email, nc__c=m.nationality, p__c=m.passportNo,
                        STA__c='Inactive', rol__c='Employee', Type__c='Manager Incharge', AccountId=mapAccByLic.get(m.accLicNo));
            }

            if (c != null) {lstConToUpsert.add(c);}

            User nwU        = new User();
            nwU.FirstName   = c.FirstName;
            nwU.LastName    = c.LastName;
            nwU.Email       = m.Email;

            System.debug('--- c: '+ c);
            String uid = (m.nationality+m.passportNo).replaceAll('/c', '');

            Integer z = dupContacts.containsKey(uid) ? dupContacts.get(uid).size() : 0;

            Integer len = 5;
            String str = string.valueof(Math.abs(Crypto.getRandomLong()));
            String randomNumber = str.substring(0, len);
            system.debug('Random Number----' + randomNumber);

            System.debug('@@@@ z: ' + z +'   UID>> ' + uid);
            /*if (m.dupUsr) {
                nwU.Username =  c.LastName+'_'+m.accLicNo+z+ '@'+c.Email.split('@')[1];
                nwU.Alias = m.firstname.substring(0, 1)+m.lastname.substring(0, 2)+Date.Today().day();
            }else{
                nwU.Username = c.Email.split('@')[0]+'_'+m.accLicNo+z+'@'+c.Email.split('@')[1];
                nwU.Alias=m.firstname.substring(0, 1)+m.lastname.substring(0, 2)+z;
            }*/

            if (m.dupUsr) {
                nwU.Username =  c.LastName+'_'+m.accLicNo+randomNumber+ '@'+c.Email.split('@')[1];
                nwU.Alias = m.firstname.substring(0, 1)+m.lastname.substring(0, 2)+randomNumber;
            }else{
                nwU.Username = c.Email.split('@')[0]+'_'+m.accLicNo+randomNumber+'@'+c.Email.split('@')[1];
                nwU.Alias=m.firstname.substring(0, 1)+m.lastname.substring(0, 2)+randomNumber;
            }

            nwU.ProfileId = gU.csStr('gpSU');
            //nwU.CommunityNickname = m.firstName.substring(0, 1)+m.lastname+z;
            nwU.CommunityNickname = m.firstName.substring(0, 1)+m.lastname+randomNumber;
            nwU.IsActive = true;  nwU.TimeZoneSidKey = 'Asia/Dubai';
            nwU.LocaleSidKey = 'en_GB';
            nwU.LanguageLocaleKey = 'en_US';
            nwU.EmailEncodingKey = 'ISO-8859-1';
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.EmailHeader.triggerUserEmail = true; nwU.setOptions(dmo);

            NewUser usr = new NewUser(); usr.usr = nwU; usr.conUID = m.nationality+m.passportNo;
            System.debug('*** lstUsrToUpsrt : ' + lstUsrToUpsrt);
            lstUsrToUpsrt.add(usr);
        }
    }

    public class NewUser{User usr;String conUID;}
    public class Records{public List<Manager> Managers;}
    public class accIDs {public List<String> AccLicNos;}
    public class Manager{
        public String accLicNo, salutation, firstName, lastName, mobile, email, passportNo, nationality;
        public Boolean dupCon, dupUsr;
    }

    global void finish(Database.BatchableContext BC) {}
}