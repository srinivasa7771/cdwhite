public class cmpAddOnController {

    public g_req__c rq {get; set;}

    public cmpAddOnController() {
        System.debug('::cmpaddOn::');
        String reqId = apexpages.currentpage().getparameters().get('id');
        String rid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        rq = [select id, xcbd__c, xadh__c,
               (select id, Name, RQ__c, itm__r.cd__c, sta__r.cd__c, xpdl__c, xcnotes__c From Items__r where IsDeleted=false order by lastmodifieddate)
               from g_Req__c where id=:rid];

    }

}