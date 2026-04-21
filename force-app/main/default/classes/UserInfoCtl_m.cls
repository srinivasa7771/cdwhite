public class UserInfoCtl_m {
    public Integer parkingEl1 {
        get;
        set;
    }
    public string userInfoJson {
        get;
        private set;
    }
    public List < g_Req__c > pendingRq5 {
        get;
        set;
    }
    public User runningUser {
        get;
        set;
    }
    public Boolean parkingUser {get;set;}
    public class UserWrp {
        public string fullName;
        public string email;
        public string userId;
        public boolean isLoggedIn;
        public string accName;
        public string accId;
        public string park;
        public string prk;
        public string expDt;
        public string sta;
        public string lic;
        public string lFrm;
        public string aType;
        public List < g_Req__c > rq5;
        public Integer parkingEl;
        public Decimal stuEl;
        public Boolean bnkGrnt;
        public String seg;
        public Boolean isparkingUser;
    }
    public UserInfoCtl_m() {
        runningUser = [SELECT Name, seg__c, Id, SmallPhotoUrl, Email, Profile.UserType, account.name,
            accountid, account.Prk__c, account.lcsta__c, account.park__c, account.Type, account.lc__c,
            account.licexdt__c, account.Legal_Framework__c, account.vetst__c, account.ORACLE_PARTY_ID__c,
            account.bgnr__c, account.bgb__c, account.bg__c FROM User WHERE Id =: UserInfo.getUserId()];
        parkingUser = gu.checkParkingUser(runningUser.id);
        UserWrp hu = getUserInfo();
        userInfoJson = JSON.serialize(hu);
    }
    public void getnotificationRQs() {
        List < g_Req__c > notificationRqs3 = new List < g_Req__c > ();
        pendingRq5 = new List < g_Req__c > ();
        system.debug('runningUser --> ' + runningUser);
        system.debug('parkingUser --> ' + parkingUser);
        List <String> parkingSerCodes = System.Label.parkingSerCodes.split(', ');
        if (parkingUser)
            notificationRqs3 = [select id, Name, LastModifiedDate, bamsgs__c,
                damsgs__c from g_Req__c where bamsgs__c != null and isDeleted = false and Acc__c =: runningUser.accountid and Service_Code__c in:parkingSerCodes order by LastModifiedDate desc limit 15];
        else
            notificationRqs3 = [select id, Name, LastModifiedDate, bamsgs__c,
                damsgs__c from g_Req__c where bamsgs__c != null and isDeleted = false and Acc__c =: runningUser.accountid order by LastModifiedDate desc limit 15];
        for (g_req__c r: notificationRqs3) {
            if (r.bamsgs__c != null) {
                pendingRq5.add(r);
            }
        }
    }
    public UserWrp getUserInfo() {
        UserWrp usr = new UserWrp();
        if (runningUser.Profile.UserType == 'Guest') {
            usr.isLoggedIn = false;
        } else {
            getnotificationRQs();
            usr.fullName = runningUser.Name;
            usr.email = runningUser.Email;
            usr.userId = runningUser.Id;
            usr.isLoggedIn = true;
            usr.accName = runningUser.account.name;
            usr.accId = runningUser.accountid;
            usr.park = runningUser.account.Prk__c;
            usr.lFrm = runningUser.account.Legal_Framework__c;
            usr.sta = runningUser.account.lcsta__c;
            usr.prk = runningUser.account.park__c;
            usr.expDt = runningUser.account.licexdt__c;
            usr.lic = runningUser.account.lc__c;
            usr.rq5 = pendingRq5;
            usr.aType = runningUser.account.Type;
            usr.parkingEl = parkingEl1;
            usr.stuEl = runningUser.account.vetst__c;
            usr.bnkGrnt = !(runningUser.account.bgnr__c || runningUser.account.bg__c > 125000);
            usr.seg = runningUser.seg__c;
            usr.isParkingUser = parkingUser;
        }
        return usr;
    }
}