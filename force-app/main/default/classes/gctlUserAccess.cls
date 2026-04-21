/*
Old Class for User Management, need to be by-passed
*/
public with sharing class gctlUserAccess {
    public Boolean ispu{get;set;}public Boolean pgHide{get;set;} public Boolean isSuperUser{get;set;}{isSuperUser=false;}
    public User cU{get;set;}public Account A{get;set;} public User aU{get;set;}
    public gctlUserAccess() {try{init();}catch (exception ex) {gU.AddErrorMsg(ex);}}
    private void init() {
        pgHide=false;
        ispu=gu.isPortalUser(UserInfo.getProfileId());
        if (!gU.isPortalSuperUser(UserInfo.getProfileId())) {pgHide=true;gU.addWarningMsg(Label.msgNoPrivilege);return;}
        uAccess=new list<GL1>();
        if (getUsers()) {getSrvcs();}
        gU.checkNav();
    }

@TestVisible  private Boolean getUsers() {
        try{
            String suid=String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('uid'));
            if (suid == null) {pgHide=true;gU.addWarningMsg(Label.msgUinactive);return false;}
            if ((suid.length()!=15&&suid.length()!=18)||!Pattern.matches('^[a-zA-Z0-9]*$', suid)) {pgHide=true;gU.addWarningMsg(Label.msgUinactive);return false;}
            list<User> usrs = new list<User>([select Id, ProfileId, FirstName, LastName, accountid,
                contact.account.id, contact.account.Name, contact.account.Type, contact.account.Prk__c from User where IsActive=true and(id=:suid or id=:UserInfo.getUserId())]);
            if (usrs.size()!=2) {pgHide=true;gU.addWarningMsg(Label.msgUinactive);return false;}
            for (User u:usrs) {if (u.Id == UserInfo.getUserId()) {cU=u;}else{aU=u;}}
            A = cU.contact.account;
            if (cU.accountid != aU.accountid) {pgHide=true;gU.addWarningMsg(Label.msgUinactive);return false;}
            isSuperUser = gU.isPortalSuperUser(aU.ProfileId);
            return true;
        }
        catch (exception ex) {gU.AddErrorMsg(ex);return false;}
    }
   @TestVisible  private void getSrvcs() {
        map<String, map<String, list<Wrap>>> mH = new map<String, map<String, list<Wrap>>>();
        for (g_Srvc__c s:[select id, uid__c, Name, lbl__c, Category__c,
            Sub_Category__c, (Select Id, DE__c, AP__c,
                usr__c From g_srvcAL__r where isDeleted = false and usr__c=:aU.Id) from g_Srvc__c where isDeleted=false and actv__c=true and Category__c <> null and Prk__c includes (:a.Prk__c) and AccTp__c includes (:a.Type) order by sord__c]) {
            String c =s.Category__c.split('\\;', 0)[0];
            String sc = s.Sub_Category__c;
            if (mH.get(c)==null) {mH.put(c, new map<String, list<Wrap>>());}
            if (mH.get(c).get(sc)==null) {mH.get(c).put(sc, new list<Wrap>());}
            if (s.g_srvcAL__r.size()>0) {mH.get(c).get(sc).add(new Wrap(s, s.g_srvcAL__r[0]));}
            else {mH.get(c).get(sc).add(new Wrap(s, new g_srvcAL__c(AP__c=false, DE__c=false, srvc__c=s.Id, usr__c=aU.Id)));}
        }
        for (Schema.PicklistEntry c : g_Srvc__c.Category__c.getDescribe().getPicklistValues()) {
            if (mH.get(c.getLabel())!=null) {
                GL1 l1 = new GL1(c.getLabel());
                for (Schema.PicklistEntry sc : g_Srvc__c.Sub_Category__c.getDescribe().getPicklistValues()) {
                    if (mH.get(c.getLabel()).get(sc.getLabel())!=null) {
                         l1.lst.add(new GL2(sc.getLabel(), mH.get(c.getLabel()).get(sc.getLabel())));
                    }
                }
                uAccess.add(l1);
            }
        }
    }
    public list<GL1> uAccess{get;set;}
    public class GL1{public String lbl{get;set;}public list<GL2>lst{get;set;}public GL1(String v) {lbl=v;lst=new list<GL2>();}}
    public class GL2{public String lbl{get;set;}public list<Wrap>lst{get;set;}public GL2(String v, list<Wrap>l) {lbl=v;lst=l;}}
    public class Wrap{
        public g_Srvc__c s{get;set;} public g_srvcAL__c al{get;set;}
        public Wrap(g_Srvc__c oS, g_srvcAL__c oAL) {s=oS;al=oAL;}
        public Boolean CRT{get{return (al.DE__c == true || al.AP__c == true);}}
        public g_srvcAL__c getCopy{get{return new g_srvcAL__c(AP__c=al.AP__c, DE__c=al.DE__c, srvc__c=s.Id, usr__c=al.usr__c);}}
    }
    public void refresh() {init();}
    public void save() {
        Savepoint sp = null;
        try{
            list<g_srvcAL__c> toDEL = new list<g_srvcAL__c>([select Id from g_srvcAL__c where isDeleted=false and usr__c=:aU.Id]);
            list<g_srvcAL__c> toUPD = new list<g_srvcAL__c>();
            for (GL1 c: uAccess) {
                for (GL2 sc: c.lst) {
                    for (Wrap al: sc.lst) {
                        if (al.CRT) {
                            toUPD.add(al.getCopy);
                        }
                    }
                }
            }
            if (Schema.sObjectType.g_srvcAL__c.isDeletable()) {
                delete toDEL;
            }
            if (Schema.sObjectType.g_srvcAL__c.isCreateable()) {
                insert toUPD;
            }
            gU.addSuccessMsg(Label.msgSuccess);
            init();
        }
        catch (exception ex) {if (sp != null) {Database.rollback(sp);} gU.AddErrorMsg(ex);}
    }
}