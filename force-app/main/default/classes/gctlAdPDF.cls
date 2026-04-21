public with sharing class gctlAdPDF {
    public Account A{get;set;} public Boolean ispu{get;set;}
    public string newLN {get;set;}
    public Decimal maxBG{get{return gU.csCurr('maxBG');}} public Decimal minBG{get{return gU.csCurr('minBG');}}
    public String p{get;set;}{p='THIS_YEAR';} public Integer n{get;set;}{n=1;}
    public Date dF{get;set;} public Date dT{get;set;}
    public Decimal cd{get;set;}{cd=0;}  public String cdT{get{return cd.format();}}
    public Decimal db{get;set;}{db=0;}  public String dbT{get{return db.format();}}
    public list<Trn> Ts{get;set;}{Ts=new list<Trn>();}
    public gctlAdPDF(ApexPages.StandardController c) {try{newLN = '\r\n'; A=(Account)c.getRecord();ispu=gU.isPortalUser(UserInfo.getProfileId());}catch (exception ex) {gU.AddErrorMsg(ex);}}
    public void gAD() {
        try{
            Ts=new list<Trn>();calcPeriod();
            A = [select Id, Name, lc__c, adb__c, adob__c, adx__c, adc__c, (select Id, Name, RQ__c,
                RQ__r.Name, RQ__r.CreatedBy.Name, RQ__r.Applicant_Name__c, RQ__r.srvc__r.lbl__c,
                dt__c, TpAD__c, A__c from Transactions__r where isDeleted=false and STA__c='Completed' and TpAD__c<>null and RQ__c<>null and dt__c>=:dF and dt__c<=:dT order by dt__c,
                RQ__r.Name)from Account where isDeleted=false and Id=:A.Id limit 1000];
            AggregateResult[] ARs = [select COUNT(Id) nOfTrans from g_Tran__c where isDeleted=false and STA__c='Completed' and TpAD__c<>null and RQ__c<>null and dt__c>=:dF and dt__c<=:dT and Acc__r.Id=:A.Id];
            if (Integer.ValueOf(ARS[0].get('nOfTrans'))>1000) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,
                    'The number of transactions in the report exceed the maximum limit 1000. Please provide a shorter period. Thanks.'));
            }
            initTrans();
        }
        catch (exception ex) {gU.AddErrorMsg(ex);}}
    public void gBG() {
        try{
            Ts=new list<Trn>();
            calcPeriod();
            A = [select Id, Name, adb__c, lc__c, bg__c, bgc__c, bgcabsc__c, bgb__c, (select Id,
                Name, RQ__c, RQ__r.Name, RQ__r.Applicant_Name__c, RQ__r.srvc__r.lbl__c, dt__c, TpAD__c,
                A__c from Transactions__r where isDeleted=false and STA__c='Completed' and TP__c='Payment' and RQ__r.srvc__r.uid__c='tbg' and dt__c>=:dF and dt__c<=:dT order by dt__c)from Account where isDeleted=false and Id=:A.Id];
            initTrans();
        }
        catch (exception ex) {
            gU.AddErrorMsg(ex);
        }
    }
    public void gCC() {
        try{
            Ts=new list<Trn>();
            calcPeriod();
            A = [select Id, Name, lc__c, bg__c, bgc__c, bgcabsc__c, bgb__c, (select Id, Name,
                RQ__c, RQ__r.Name, RQ__r.Applicant_Name__c, RQ__r.srvc__r.lbl__c, dt__c, TpAD__c,
                A__c, STA__c from Transactions__r where isDeleted=false and (md__c='Credit / Debit Card' or md__c='Credit Card') and TP__c='Payment' and dt__c>=:dF and dt__c<=:dT order by dt__c,
                RQ__r.Name)from Account where isDeleted=false and Id=:A.Id];
            initTrans();
        }
        catch (exception ex) {
            gU.AddErrorMsg(ex);
        }
    }
    private void initTrans() {for (g_Tran__c t: A.Transactions__r) {Trn nT=new Trn(t);cd+=nT.cd;db+=nT.db;Ts.add(nT);}A.Transactions__r.clear();}
    private void calcPeriod() {
        if (dF != null&&dT != null) {if (dT>date.today()) {dT=date.today();}return;}
        String pv=String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('p'));
        if (pv=='CUSTOM') {
            if (String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('fd'))<>'' && String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('td'))<>'') {
                String[] dFs=String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('fd')).split('/', -2);
                String[] dTs=String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('td')).split('/', -2);
                dF=Date.newinstance(Integer.ValueOf(dFs[2]), Integer.ValueOf(dFs[1]), Integer.ValueOf(dFs[0]));
                dT=Date.newinstance(Integer.ValueOf(dTs[2]), Integer.ValueOf(dTs[1]), Integer.ValueOf(dTs[0]));
            }
        }
        else{
            if (pv=='THIS_MONTH'||pv=='LAST_MONTH'||pv=='THIS_QUARTER'||pv=='THIS_YEAR') {p=pv;}
            if (pv=='LAST_N_QUARTERS'||pv=='LAST_N_YEARS') {
                String nv=String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('n'));
                if (nv != null) {
                    try{
                        n=Integer.valueOf(nv);
                    }
                    catch (exception ex) {
                        n=1;
                    }
                    p=pv;
                }
            }
            if (p=='THIS_MONTH') {dT=date.today();dF=dT.toStartOfMonth();}
            else if (p=='LAST_MONTH') {dT=date.today().toStartOfMonth().addDays(-1);dF=dT.toStartOfMonth();}
            else if (p=='THIS_QUARTER'||p=='LAST_N_QUARTERS') {
                dT=date.today();
                if (dT.month()<4) {
                    dF=date.newInstance(dT.Year(), 1, 1);
                }
                else if (dT.month()<7) {
                    dF=date.newInstance(dT.Year(), 4, 1);
                }
                else if (dT.month()<10) {
                    dF=date.newInstance(dT.Year(), 7, 1);
                }
                else {
                    dF=date.newInstance(dT.Year(), 10, 1);
                }
                if (p=='LAST_N_QUARTERS') {
                    dT=dF.addDays(-1);
                    dF=dF.addMonths(-3*n);
                }
            }
            else if (p=='THIS_YEAR') {dT=date.today();dF=date.newInstance(dT.Year(), 1, 1);}
            else if (p=='LAST_N_YEARS') {dT=date.newInstance(date.today().Year()-1, 12, 31);dF=date.newInstance(dT.Year()-n+1, 1, 1);}
        }
    }
    public class Trn{
        public g_Tran__c T{
            get;
            set;
        }
        public Boolean isCrdt{
            get;
            set;
        }
        public decimal cd{
            get{
                return isCrdt?T.A__c:0;
            }
        }
        public decimal db{
            get{
                return isCrdt?0:T.A__c;
            }
        }
        public Trn(g_Tran__c o) {
            T=o;
            isCrdt=T.TpAD__c=='Refund'||T.TpAD__c=='Top-up';
        }
    }
}