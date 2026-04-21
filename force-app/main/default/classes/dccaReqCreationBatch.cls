global class dccaReqCreationBatch implements Database.Batchable < sObject > , Database.AllowsCallouts {
    public String queryString;
    public dccaReqCreationBatch() {
        queryString = 'Select id, lc__c, lcedt__c, ORACLE_PARTY_ID__c, lcsta__c, Legal_Framework__c, dccaexId__c, Prk__c  from Account where lcsta__c = \'License Issued\' AND lcedt__c <= NEXT_N_DAYS:45 and isDeleted=false and Prk__c!=\'Dubai Healthcare City\' and Type !=\'Customer-DED\' and Type !=\'Customer - Internal\' and Type !=\'Customer-LASInternal\' and Type !=\'Customer-Decree\' and lc__c != \' \' and ORACLE_PARTY_ID__c != \' \' and CALENDAR_Year(lcedt__c) >= 2018 ';
    }
    public dccaReqCreationBatch(string licNo) {
        this();
        queryString +=' '+'AND lc__c=\''+licNo+'\'';
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // String query = 'Select id, lcedt__c, ORACLE_PARTY_ID__c, lcsta__c from Account where lcsta__c = \'License Issued\' AND lcedt__c= LAST_N_DAYS:45 Limit 10';
        system.debug(queryString);
        queryString+=' limit 999';
        return Database.getQueryLocator(queryString);  //where xdrv__c=true
    }
    global void execute(Database.BatchableContext BC, List <Account> scope) {
        List<g_Req__c> rqList = new List<g_Req__c>();
        List<Account> accList = new List<Account>();
        Map<Id, string> mapUserContact = new Map<Id, string>();
        List<Id> actIdList = new List<Id>();
        map<Id, List<String>> accEmailMap = new  map<Id, List<String>>();
        List<Id> reqAccList = new  List<Id>();
        Map<Id, String> reqAccMap = new  Map<Id, String>();
        List<Id> accWOReqList = new  List<Id>();
        List<Account> scopeNew = new List<Account>();
        List<ws_call__c> wsList = new List<ws_call__c>();

        try{
            for (Account ac: scope) {actIdList.add(ac.id);}
            List<User> userList = [select Id, Email, ContactId, AccountId  from user where Profile.Name ='z' and IsActive=true and AccountId in :actIdList];
            for (User u : userList) {
                // mapUserContact.put(u.ContactId, u.Email);
                if (accEmailMap.containsKey(u.AccountID)) {
                    List<string> emailList =accEmailMap.get(u.AccountID);
                    emailList.add(u.Email);
                    accEmailMap.put(u.AccountID, emailList );
                }else{
                    List<string> emailList  = new List<string> ();
                    emailList.add(u.Email);
                    accEmailMap.put(u.AccountID, emailList );
                }
            }

            //FM Manager Email -xfme__c// HSE-Email- xhsee__c//   SEC Email - xsece__c//AV Email - xave__c

            /*check Draft requests*/
            List<g_req__c> reqList = [select id, name, acc__c from g_req__c where acc__c in:actIdList and srvc__r.uid__c='208' and sta__c in ('Draft', 'Open')];
            for (g_req__c r : reqList) {
                reqAccMap.put(r.acc__c, r.name);
            }
            for (Account ac : scope) {
                if (!reqAccMap.containsKey(ac.id))
                    scopeNew.add(ac);
            }
            system.debug('reqList --'+reqList);
            system.debug('scopeNew --'+scopeNew);
            grqWsDccaGetService.ActivityLocations  alldccaLoc = new grqWsDccaGetService.ActivityLocations();
            g_Srvc__c srv = [Select id from g_Srvc__c where uid__c ='208'];
            for (Account ac : scopeNew) {
                ws_call__c ws = new ws_call__c();
                ws.ws_typ__c = 'DDA Lic Renewal';
                ws.intsts__c = 'Success';
                ws.mtd_nm__c = 'Lic Renewal';
                ws.pmid__c = ac.lc__c;

                g_Req__c rq = new g_Req__c();
                String dccaReq = dccaReqCreationBatchHelper.loaction(ac);
                dccaReq = dccaReq.replaceAll('\r\n', ' ').replaceAll('\n', ' ').replaceAll('\r', ' ');
                rq.srvc__c =srv.id;
                rq.xdccaRq__c = dccaReq;
                //Assign email address
                if (accEmailMap.containsKey(ac.id)) {
                    List<String> email = accEmailMap.get(ac.id);
                    if (String.isNotBlank(ac.Legal_Framework__c) && ac.Legal_Framework__c == 'Freelancer') {
                        List<string> emailLst = new List<String>();
                        if (String.isNotBlank(ac.Prk__c) && ac.Prk__c == 'Dubai Internet City') {
                            emailLst = Label.FreelancerDICPRM.split(';');
                        }
                        if (String.isNotBlank(ac.Prk__c) && ac.Prk__c == 'Dubai Media City') {
                            emailLst = Label.FreelancerDMCPRM.split(';');
                        }
                        if (String.isNotBlank(ac.Prk__c) && ac.Prk__c == 'Dubai Knowledge Park') {
                            emailLst = Label.FreelancerDKPPRM.split(';');
                        }
                        if (String.isNotBlank(ac.Prk__c) && ac.Prk__c == 'Dubai Design District') {
                            emailLst = Label.FreelancerD3PRM.split(';');
                        }
                        rq.xfme__c = email.get(0);
                        if (emailLst != null && !emailLst.isEmpty()) {
                            for ( integer j = 1;
                            j <= emailLst.size();
                            j++) {
                                if (j == 1) rq.xhsee__c = emailLst.get(0);
                                if (j == 2) rq.xsece__c = emailLst.get(1);
                                if (j == 3) rq.xave__c = emailLst.get(2);
                            }
                        }
                    }
                    else{
                        integer i ;
                        for ( i = 0;
                        i <= email.size();
                        i++) {
                            if (i == 1) rq.xfme__c = email.get(0);
                            if (i == 2) rq.xhsee__c = email.get(1);
                            if (i == 3) rq.xsece__c = email.get(2);
                            if (i == 4) rq.xave__c = email.get(3);
                        }
                    }
                    system.debug(rq);
                }

                rq.Acc__c = ac.id;
                rq.STA__c = 'Draft';
                rqList.add(rq);
                ac.lcsta__c = 'License Under Renewal';
                grqWsDccaGetService jj= (grqWsDccaGetService) System.JSON.deserialize(dccaReq, grqWsDccaGetService.class);
                ws.rq_jsn__c = dccaReq;
                // Account Name , Legal framework, License Name
                if (jj != null) {
                    if (jj.Data.get(0).legaleng != null) rq.xcne__c =jj.Data.get(0).legaleng;
                    if (jj.Data.get(0).legalarabic != null) rq.xcna__c =jj.Data.get(0).legalarabic;
                    if (jj.Data.get(0).lincenseeeng != null) rq.xlne__c =jj.Data.get(0).lincenseeeng;
                    if (jj.Data.get(0).lincenseearabic != null) rq.xlna__c =jj.Data.get(0).lincenseearabic;
                    if (jj.Data.get(0).frameworkeng != null) rq.xalfe__c =jj.Data.get(0).frameworkeng;
                    if (jj.Data.get(0).businessPArk != null) rq.xaccbrand__c =jj.Data.get(0).businessPArk;
                }
                //Account Name , Legal framework, License Name

                String Docs='';
                String Docs2='';
                for (Integer i=0;jj.Data.get(0).docs != null && i<jj.Data.get(0).docs.size();i++) {
                    //Docs=Docs+(i+1)+') '+jj.Data.get(0).docs.get(i).name+'\n';
                    if (!Docs.contains(jj.Data.get(0).docs.get(i).name)) {
                        Docs=Docs+jj.Data.get(0).docs.get(i).name+';';
                    }

                    if (jj != null && !Docs2.contains(jj.Data.get(0).docs.get(i).name)) {
                        if (string.isBlank(Docs2)) {
                            Docs2 = (i+1)+'. '+jj.Data.get(0).docs.get(i).name+'</br>';
                        }else{
                            Docs2 =Docs2+(i+1)+'. '+jj.Data.get(0).docs.get(i).name+'</br>';
                        }
                    }
                }if (Docs==';') {Docs='';}
                Set<String> newSetDoc = new Set<String>();
                String newDocs;
                if (Docs != null) {
                    String[] docString = Docs.split(';');
                    for (string str : docString) {
                        if (!newSetDoc.contains(str))
                            newSetDoc.add(str);
                    }
                    for (string setStr : newSetDoc) {
                        if (newDocs != null) {
                            newDocs = newDocs+setStr+';';
                        }else{
                            newDocs = setStr+';';
                        }
                    }
                }
                if (String.isBlank(newDocs)) {
                    rq.xcddocs__c=Docs;  }
                else{
                    rq.xcddocs__c=newDocs;
                }
                if (rq.xcddocs__c==';') {rq.xcddocs__c='';}

                accList.add(ac);
                wsList.add(ws);
            }

            if (wsList != null && wsList.size()>0)Insert wsList;
            if (rqList != null && rqList.size()>0)Insert rqList;
            if (Schema.sObjectType.Account.isUpdateable()) { if (accList != null && accList.size()>0)update accList; }
        }catch (System.Exception e) {
            System.debug('ERROR: ' + e.getStackTraceString());
            ws_call__c ws = new ws_call__c();
            ws.ws_typ__c = 'DDA Lic Renewal';
            ws.mtd_nm__c = 'Lic Renewal';
            ws.pmid__c = scope[0].lc__c;
            String err = 'Exception type caught: ' + e.getTypeName() + ' &&& ';
            err+= 'Message: ' + e.getMessage()+' &&& ';
            ws.res_jsn__c=err+e.getStackTraceString();
            ws.intsts__c = 'Failed';
            Insert ws;
        }
    }

    global void finish(Database.BatchableContext BC) {}

}