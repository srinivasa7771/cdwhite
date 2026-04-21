public class appdfCntr {
    public g_Req__c rq{get;set;}
    public List<String> lstPrmtReq {get;set;}

    public appdfCntr(ApexPages.StandardController c) {
        string rqid = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('id'));

        rq = [Select xnaf__c, xoca__c, Account_Name__c, xet__c, xst__c, xrsv__c, xuvdet__c, hpr__c, Reason__c, Con__c,
              xchn__c, xrap__c, prf__c, csp__c, i_STA__c, Id, xdcmt__c, xanum__c, Name, STA__c, AT__c, AP__c, AOP__c, rmob__c, xawb__c, xaloc__c, xbrnd__c, xbn__c, nt__c, xadh__c,
              xceml__c, xcemrt__c, xcfn__c, xcln__c, xcmob__c, xcof__c, xcot__c, xcp__c, xcped__c, xcpid__c, xcpic__c,
              xcpip__c, xcbp__c, xcnp__c, xcrlg__c, xcslt__c, xclng__c, xcstrt__c, xcmta__c, xdedc__c, xdedln__c, xosa__c, xphid__c,
              xcs__c, xcn__c, Zone__c, xrp__c,
              (select id, Name, xped__c, xst__c, xet__c, sta__c, sta__r.name, sta__r.cd__c  From Items__r  where IsDeleted=false order by itm__r.ord__c)
              From g_Req__c where id=:rqid];
    }

    public void getPrmtReqs() {lstPrmtReq = new List<String>();if (String.isNotBlank(rq.hpr__c)) {lstPrmtReq = rq.hpr__c.split(';');}}

}