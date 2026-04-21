public class gctlCon {
    public Contact con {set;get;}
    public Contact spon {set;get;}
    public List<Contact> depLst {set;get;}
    public id accid {set;get;}
    public integer depCnt {set;get;}
    Public  User  U{set;get;}
    public list<contact> ContactList{ get;set;}
    public transient String ContactString{ get;set;}
    Public string  selectedCon{set;get;}
    list<contact> conLst = new List<contact>();
    public gctlCon() {
        String conId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        if (String.isNotBlank(conId)) {
            depLst = new List<Contact>();depCnt=0;
            con =  [select id, flnm__c, Account.Prk__c, Account.name, Account.lcsta__c, Account.lcrndt__c,
                Account.licexdt__c, Account.lcedt__c, firstname, lastname, mn__c, salutation, fan__c,
                mon__c, fnar__c, mnar__c, lnar__c, mona__c, nc__c, bp__c, Birthdate, bc__c, Gender__c,
                ms__c, rlg__c, ql__c, Department, jb__r.name, p__c, pid__c, ped__c, pip__c, pipa__c,
                pic__c, HomePhone, MobilePhone, strt__c, Photo_ID__c, STA__c, vip__c, Proc__c, RP_Expiry_Status__c,
                RP_Sts__c, xpno__c,    xpsd__c, xpmi__c, xped__c, xpdl__c, ha__c, jd__c, rol__c,
                eidid__c, eididt__c, eidedt__c, xean__c, rp__c, rped__c, rpui__c, rpid__c,
                    mbs__c, ma__c, mta__c, moa__c, Spon__c, email, Course_Name__c, Program__c, ptsta__c, CVDocID__c, Current_Course_Year__c, GPA__c, pte__c, pte__r.name, ptid__c, pted__c,
                    (select id, flnm__c, firstname, lastname, mn__c, p__c, pid__c, ped__c, STA__c, rol__c, eidid__c, eididt__c, eidedt__c, xean__c, rp__c, rped__c, rpui__c, rpid__c from Spon__r)
                    from Contact where id=:conId];
            if (con != null && con.Spon__r != null && !con.Spon__r.isEmpty()) {
                depCnt = con.Spon__r.size();
                depLst = con.Spon__r;
            }
            if (String.isNotBlank(con.Spon__c)) {
                List<Contact> sponList = [select id, flnm__c, firstname, lastname, mn__c, p__c, pid__c,
                    ped__c, rol__c, eidid__c, eididt__c, eidedt__c, xean__c, rp__c, rped__c, rpui__c,
                    rpid__c from Contact where id=:con.Spon__c];
                if (sponList != null && !sponList.isEmpty())
                    spon = sponList[0];
            }
        }else{

            U = [select Id, contactid, firstName, LastName, account.name, accountid, account.Prk__c, account.lcsta__c, account.lcedt__c,
                 account.park__c, account.licexdt__c, account.lcrndt__c, account.vespst__c, account.vcspst__c from User where id =:Userinfo.getUserId() limit 1];
            accid = U.accountid;
            con =  [select id, flnm__c, Account.Prk__c, Account.name, Account.lcsta__c, Account.lcrndt__c, Account.licexdt__c, Account.lcedt__c,
                    firstname, lastname, mn__c, salutation, fan__c, mon__c, fnar__c, mnar__c, lnar__c, mona__c, nc__c, bp__c, Birthdate, bc__c, Gender__c, ms__c,
                    rlg__c, ql__c, jb__r.name, p__c, pid__c, ped__c, pip__c, pipa__c, pic__c, HomePhone, MobilePhone, strt__c, Photo_ID__c, STA__c, vip__c, RP_Expiry_Status__c, RP_Sts__c,
                    xpno__c,    xpsd__c, xpmi__c, xped__c, xpdl__c, ha__c, jd__c, eidid__c, eididt__c, eidedt__c, xean__c, rp__c, rped__c, rpui__c, rpid__c,
                    mbs__c, ma__c, mta__c, moa__c, Spon__c,
                    (select id, flnm__c, firstname, lastname, mn__c, p__c, pid__c, ped__c, rol__c, eidid__c, eididt__c, eidedt__c, xean__c, rp__c, rped__c, rpui__c, rpid__c from Spon__r)
                    from Contact where id=:U.contactid];
            ContactList = [SELECT id, firstname, Photo_ID__c, rol__c, Gender__c, Age__c, ptsta__c,
                pte__r.name, Job_Title_Formula__c, STA__c, nc__c, p__c, eidid__c, rp__c, ped__c,
                rped__c, Passport_Status__c, RP_Sts__c FROM contact where rol__c='Employee' and AccountId=:accid order by lastmodifieddate desc limit 999 ];
            ContactString = JSON.serialize(ContactList);
            system.debug('ContactList -- '+ContactList);

        }

    }
    public void roleFilter() {
        string rol = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('role'));
        String rolFilter = (rol=='')?'':'rol__c=\'' + String.escapeSingleQuotes(rol) + '\' and';
        String qur = 'SELECT id, firstname, Photo_ID__c, rol__c, Gender__c, Age__c, ptsta__c, pte__r.name, Job_Title_Formula__c, STA__c, nc__c, p__c, eidid__c, rp__c, ped__c, rped__c, Passport_Status__c, RP_Sts__c FROM contact where ' +
            String.escapeSingleQuotes(rolFilter) + ' AccountId =\'' + String.escapeSingleQuotes(accid) + '\' order by lastmodifieddate desc limit 2500';
        system.debug('Query -- '+qur);
        ContactList = Database.query(qur);
        ContactString = JSON.serialize(ContactList);
    }
    public PageReference createPartTimeReq() {
        con = [select id, Firstname, lastname, nc__c from contact where id=:selectedCon];
        g_Req__c req = new g_Req__c(xcfn__c=con.FirstName, xcln__c=con.LastName, xcnc__c=con.nc__c, Con__c=selectedCon, Acc__c=accid, srvc__c='a0L280000048ZNYEA2');
        if (Schema.sObjectType.g_Req__c.isCreateable()) {
            insert req;
        }
        PageReference pg = new PageReference('/'+req.id);
        pg.setRedirect(true);
        return pg;
    }
}