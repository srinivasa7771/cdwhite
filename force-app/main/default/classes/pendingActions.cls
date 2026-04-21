public class pendingActions {

    public Boolean parkingUser {get;set;}
    List <String> parkingSerCodes {get;set;}

    public list<g_req__c> allDPRqs{get;set;}
    public list<g_req__c> allDPRqs1{get;set;}
    public transient list<g_req__c> allRqs{get;set;}
    public String strAllDPRqs1{get;set;}
    public transient String RequestString{get;set;}
    public transient String RequestString1{get;set;}
    public Boolean pgHide {get;set;}
    public Boolean ispu {get;set;}
    public List<String> licList{get;set;}
    public User U {get;set;}
    public Account A {get;set;}
    public g_Req__c rq {get;set;}
    public String orclId {get;set;}
    public Set<String> status = new Set<String>{'Draft', 'Completed', 'Rejected', 'Cancelled'};
    public pendingActions() {
        try {
            system.debug('UserInfo.getProfileId()===='+UserInfo.getProfileId());
            ispu = gu.isPortalUser(UserInfo.getProfileId());
            system.debug('ispu===='+ispu);
            pgHide = !ispu;
            parkingUser = gu.checkParkingUser(UserInfo.getUserId());
            init();
        } catch (exception ex) {
            gu.AddErrorMsg(ex);
            pgHide = true;
        }

    }
    public void init() {
        system.debug('In >> init()');
        try {
            if (ispu) {
                loadData(false);
            }
            gU.checkNav();
        } catch (exception ex) {
            gu.AddErrorMsg(ex);
            pgHide = true;
        }
    }
    private void loadData(Boolean isnw) {

        system.debug('In >> loadData() 1');
        String url = Apexpages.currentPage().getURL();
        U = [select Id, FirstName, LastName, accountid, LastLoginDate, contact.Photo_ID__c, contact.account.id, contact.account.on__c ,
             contact.account.onar__c , contact.account.Website, contact.account.vespe__c, contact.account.vespex__c, contact.account.vetemp__c, contact.account.vbtemp__c ,
             contact.account.vetst__c, contact.account.vespst__c, contact.account.vespstx__c , contact.account.vbtst__c, contact.account.vev__c, contact.account.mxPortalUsers__c,
             contact.account.Name, contact.account.Email__c, contact.account.lPrk__c, contact.account.Building_Name__c, contact.account.xcublg__c,
             contact.account.Location__c, contact.account.Location_Cluster__c, contact.account.xcuzn__c , contact.account.Phone, contact.account.Type, contact.account.Prk__c, contact.account.adb__c,
             contact.account.info__c, contact.account.bgnr__c, contact.account.bg__c, contact.account.bgc__c, contact.account.bgcabsc__c, contact.account.bgb__c, contact.account.vctemp__c,
             contact.account.speabsc__c, contact.account.vctst__c, contact.account.sncNt__c, contact.account.vbvv__c, contact.account.lcidt1__c, contact.account.ec__c, contact.account.ecidt__c,
             contact.account.lctp__c,    contact.account.ecedt__c, contact.account.lcedt__c, contact.account.lcsnc__c,
                 contact.account.lcsncnt__c, contact.account.Legal_Framework__c, contact.account.psasnc__c,
             contact.account.psasncnt__c, contact.account.lcsta__c, contact.account.ecsnc__c, contact.account.ecsncnt__c,
                 contact.account.lcrndt__c, contact.account.cosnc__c, contact.account.cosncnt__c,
             contact.account.licexdt__c, contact.account.licIdt__c,   contact.account.bgsnc__c, contact.account.bgsncnt__c, contact.account.snc__c, contact.account.voep__c, contact.account.lc__c,
             contact.account.ORACLE_PARTY_ID__c, contact.account.rpa__c, contact.account.os__c,
                 contact.account.adob__c , contact.account.adx__c, contact.account.adc__c  from User where id =: UserInfo.getUserId() limit 1];

        system.debug('In >> loadData() 2'+u);

        parkingSerCodes = System.Label.parkingSerCodes.split(', ');
        A = U.contact.account;
        if (U.contact.account.ORACLE_PARTY_ID__c != null)
            orclId = U.contact.account.ORACLE_PARTY_ID__c;
        List<g_Req__c> rqLst = [select id, name, STA__c, AP__c, xtpa__c, AOP__c, xadh__C,
            AUP__c, xcamdt__c, (select id from Attachments order by lastmodifieddate desc limit 1) from g_Req__c where Acc__c=:A.Id and STA__c in('Draft',
            'Open', 'Under Review', 'In Process', 'Completed') and srvc__r.uid__c = '208' order by lastmodifieddate desc limit 1];
        if (rqLst != null && !rqLst.isEmpty())
           rq = rqLst[0];
        if (!u.contact.account.Type.equalsIgnoreCase('Customer - Incubation') && !u.contact.account.Type.equalsIgnoreCase('Customer - Member')) {
            list<g_req__c> allRqs1 = new List<g_req__c>();
            if (parkingUser) {
                allRqs = [select id, Last_MDays__c, Applicant_Name__c, prio__c, CurrentNationality__c,
                    xcnc__c, tmpp__c, xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c, STA__c,
                    damsgs__c, AOP__c from g_Req__c where LastModifiedDate = LAST_N_DAYS:30 and isDeleted = false and Acc__c =: A.Id and Service_Code__c in:parkingSerCodes and createddate=LAST_N_DAYS:730 order by LastModifiedDate desc];
            }
            else{
                allRqs = [select id, Last_MDays__c, Applicant_Name__c, prio__c, CurrentNationality__c,
                    xcnc__c, tmpp__c, xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c, STA__c,
                    damsgs__c, AOP__c from g_Req__c where LastModifiedDate = LAST_N_DAYS:30 and isDeleted = false and Acc__c =: A.Id and createddate=LAST_N_DAYS:730 order by LastModifiedDate desc];
            }
            allRqs1 = [select id, Last_MDays__c, Applicant_Name__c, prio__c, CurrentNationality__c,
                xcnc__c, tmpp__c, xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c, STA__c,
                damsgs__c, AOP__c from g_Req__c where isDeleted = false and Acc__c =: A.Id and createddate=LAST_N_DAYS:730 order by LastModifiedDate desc];
            //allDPRqs = [select id, Last_MDays__c, Applicant_Name__c, prio__c, lastmodifieddate, CurrentNationality__c, xcnc__c, xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c, STA__c, damsgs__c, AOP__c, xadh__C, AUP__c, xcamdt__c from g_Req__c where STA__c NOT IN('Draft', 'Completed', 'Rejected', 'Cancelled') and isDeleted = false and  Acc__c =:A.Id];
            allDPRqs1 = new list<g_req__c>();
            for (g_req__c r:allRqs1) {
                if (r.damsgs__c != null && !(status.contains(r.STA__c)))
                    allDPRqs1.add(r);
            }
            RequestString = JSON.serialize(allRqs);
            RequestString1 = JSON.serialize(allDPRqs1);
        }
    }
    public void dateFilter() {
        String parkingSerCodesSer ='';
        for (Integer i=0;i<parkingSerCodes.size();i++) {
            if (i == parkingSerCodes.size()-1)
                parkingSerCodesSer += '\''+parkingSerCodes[i]+'\'';
            else
                parkingSerCodesSer += '\''+parkingSerCodes[i]+'\', ';
        }

        string qur = '';
        string qur1 = '';
        string day1 = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('days'));
        string day = (day1==''?'':((day1=='all')?'':'LastModifiedDate = LAST_N_DAYS:' + String.escapeSingleQuotes(day1) + ' and'));
        if (parkingUser) {
            qur = 'select id, Last_MDays__c, Applicant_Name__c, prio__c, CurrentNationality__c, xcnc__c, tmpp__c, xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c, STA__c, damsgs__c, AOP__c from g_Req__c where ' +
                String.escapeSingleQuotes(day) + ' isDeleted = false and Acc__c =\''+ A.Id+'\' and createddate=LAST_N_DAYS:730 AND Service_Code__c in (' +
                String.escapeSingleQuotes(parkingSerCodesSer) + ') order by LastModifiedDate desc';
        }
        else{
            qur = 'select id, Last_MDays__c, Applicant_Name__c, prio__c, CurrentNationality__c, xcnc__c, tmpp__c, xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c, STA__c, damsgs__c, AOP__c from g_Req__c where ' +
                String.escapeSingleQuotes(day) + ' isDeleted = false and Acc__c =\''+ A.Id+'\' and createddate=LAST_N_DAYS:730 order by LastModifiedDate desc';
        }
        allRqs = Database.query(qur);
        allDPRqs1 = new list<g_req__c>();
        for (g_req__c r:allRqs) {
            if (r.damsgs__c != null && !(status.contains(r.STA__c)))
                allDPRqs1.add(r);
        }
        RequestString = JSON.serialize(allRqs);
        RequestString1 = JSON.serialize(allDPRqs1);
    }

}