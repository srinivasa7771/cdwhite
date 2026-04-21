public class UserInfoCtl {

    public string userInfoJson { get; private set; }

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
}

public UserInfoCtl() {
    UserWrp hu = getUserInfo();
    userInfoJson = JSON.serialize(hu);
}

private UserWrp getUserInfo() {
    User runningUser = [
        SELECT      Name, Id, SmallPhotoUrl, Email, Profile.UserType, account.name, accountid, account.Prk__c, account.lcsta__c,
        account.park__c, account.licexdt__c

        FROM        User
        WHERE       Id = : UserInfo.getUserId()
    ];

    UserWrp usr = new UserWrp();
    if (runningUser.Profile.UserType == 'Guest') {
        usr.isLoggedIn = false;
    } else {
        usr.fullName = runningUser.Name;
        usr.email = runningUser.Email;
        usr.userId = runningUser.Id;
        usr.isLoggedIn = true;
        usr.accName = runningUser.account.name;
        usr.accId = runningUser.accountid;
        usr.park=runningUser.account.Prk__c;

        usr.sta=runningUser.account.lcsta__c;
        usr.prk=runningUser.account.park__c;
        usr.expDt=runningUser.account.licexdt__c;

    }

    return usr;
}

}