public with sharing class gctlUsers {
    public Boolean ispu{get;set;}
    public Boolean ReadOnly{get{return !gU.isPortalSuperUser(UserInfo.getProfileId());}}
    public Boolean CanView{get{return gU.isPortalUser(UserInfo.getProfileId());}}
    public Integer maxAllow{get;set;}{maxAllow=0;} public Boolean canCrtUsr{get;set;}
    public list<usr> usrs{get;set;}{usrs = new list<usr>();}
    public gctlUsers () {try{init();} catch (exception ex) {gU.AddErrorMsg(ex);}}
    private void init() {
        canCrtUsr=true;
        ispu=gu.isPortalUser(UserInfo.getProfileId());
        usrs.clear();
        User usr = [select Id, AccountId, Contact.Account.mxPortalUsers__c from User where id=: UserInfo.getUserId() limit 1];
        this.maxAllow=usr.Contact.Account.mxPortalUsers__c == null?0:integer.valueOf(usr.Contact.Account.mxPortalUsers__c);
        Integer actvUsrs = 1;
        /*including current user*/ if (usr.AccountId != null) {
            for (User u:[Select u.ProfileId, u.Name, u.Id, u.AccountId, u.isActive,
                (Select Id, srvc__c, srvc__r.Name, DE__c, AP__c From Access_Levels__r where isDeleted=false) From User u where u.AccountId=:usr.AccountId and id !=: usr.Id order by u.isActive desc,
                u.Name asc ]) {
                usrs.add(new usr(u));
                if (u.isActive) {
                    actvUsrs ++;
                }
            }
        }
        if (actvUsrs >= maxAllow) {
            canCrtUsr=false;
        }
        gU.checkNav();
    }
    public void save() {
        try{
            list<User> upL = new list<User>();
            for (usr u: usrs) {
                upL.add(u.u);
            }
            if (upL.size()>0) {
                if (Schema.sObjectType.User.isUpdateable()) {
                    update upL;
                }
                init();
                gU.AddSuccessMsg(Label.msgSuccess);
                return;
            }
            gU.AddWarningMsg(Label.msgNoChange);
        }
        catch (exception ex) {
            gU.AddErrorMsg(ex);
        }
    }
    private void enUser(Id uid, Boolean actv) {
        if (uid == null) {
            gU.AddWarningMsg(Label.msgNoChange);
            return;
        }
        if (actv) {
            Integer actvUsrs = 1;
            /*including current user*/ for (usr u: usrs) {
                if (u.u.isActive) {
                    actvUsrs ++;
                }
            }
            if (actvUsrs >= maxAllow) {
                String pgmsg = Label.msgPortalQuota;
                pgmsg = pgmsg.replace('#p1', maxAllow.format());
                pgmsg = pgmsg.replace('#p2', actvUsrs.format());
                gU.AddWarningMsg(pgmsg);
                return;
            }
        }
        User u = new User(Id = uid);
        u.IsActive = actv;
        if (Schema.sObjectType.User.isUpdateable()) {
            update u;
        }
        init();
        gU.AddSuccessMsg(Label.msgSuccess);
    }
    public void enUser() {try{enUser(String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('uid')), true);} catch (exception ex) {gU.AddErrorMsg(ex);}}
    public void dsbUser() {try{enUser(String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('uid')), false);} catch (exception ex) {gU.AddErrorMsg(ex);}}
    public class usr{
        public User u{
            get;
            set;
        }
        public Integer srvcAP{
            get;
            set;
        }
        public Integer srvcDE{
            get;
            set;
        }
        public usr(User varU) {
            u = varU;
            srvcAP=0;
            srvcDE=0;
            for (g_srvcAL__c al : u.Access_Levels__r) {
                srvcAP=al.AP__c == true?srvcAP+1:srvcAP;
                srvcDE=al.DE__c == true?srvcDE+1:srvcDE;
            }
        }
        public Boolean IsSuperUser{
            get{
                return gU.isPortalSuperUser(u.ProfileId);
            }
            set{
                u.ProfileId=(value == true)?gU.csStr('gpSU'):gU.csStr('gpST');
            }
        }
    }
}