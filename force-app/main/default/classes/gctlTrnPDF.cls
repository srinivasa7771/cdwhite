public with sharing class gctlTrnPDF {
    public g_Tran__c T{get;set;}public Boolean ispu{get;set;} public Boolean isgu{get;set;}
    public string tid {set;get;}
    public gctlTrnPDF(ApexPages.StandardController c) {
        isgu = gu.isGuestUser(userInfo.getProfileId());
        if (isgu) {tid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));}
        else
        {T=(g_Tran__c)c.getRecord();tid = T.id;}
        ispu=gU.isPortalUser(UserInfo.getProfileId());init();
    }
    private void init() {try{laodData();}catch (exception ex) {gU.AddErrorMsg(ex);}}
    private void laodData() {

        T = [   Select Id, Name, A__c, Bnk__c, cq__c, ci__c, cdt__c, dt__c, nt__c, md__c, STA__c, TP__c, RQ__r.xss__c, RQ__r.xfpc__c,
             CreatedBy.ProfileId, CreatedBy.Name, RQ__r.xcfn__c, RQ__r.tsrv__c, RQ__r.xppsfv__c, RQ__r.QR_Code__c,
             RQ__c, RQ__r.Name, RQ__r.nt__c, RQ__r.dsc__c, RQ__r.Con__c, RQ__r.Con__r.Name, RQ__r.Con__r.xsgv__c,
             RQ__r.srvc__c, RQ__r.srvc__r.lbl__c, RQ__r.srvc__r.payNt__c, RQ__r.srvc__r.uid__c, RQ__r.xltr__c, RQ__r.xanum__c, RQ__r.xaed__c,
             Acc__c, Acc__r.Name, Acc__r.lctp__c, Acc__r.lc__c, Acc__r.BillingPostalCode, Acc__r.BillingStreet, Acc__r.Prk__c, Acc__r.van__c,
             RQ__r.Acc__r.BillingPostalCode, RQ__r.Acc__r.BillingStreet, RQ__r.Acc__r.Prk__c, RQ__r.Acc__r.van__c,
             (
                 Select Id, Name, A__c, exp__c, STA__c, Tp__c, vat__c, ngs__c, TAX_TYPE__c, TAX_CODE__c,
                 itm__c, itm__r.Name, itm__r.DscApp__c, itm__r.Dsc__c, itm__r.KF__c, itm__r.AV__c, itm__r.su__c, itm__r.vsu__c,
                 itm__r.itm__r.Name, itm__r.itm__r.lbl__c, itm__r.itm__r.Req__c, itm__r.itm__r.payNt__c, itm__r.itm__r.cd__c,
                 itm__r.cXP__c, itm__r.cN__c, itm__r.scN__c, itm__r.scXP__c, itm__r.ngs__c, itm__r.ngsXP__c
                 From Items__r order by itm__r.itm__r.ord__c
             )
             from g_Tran__c where Id=:tid];
    }
}