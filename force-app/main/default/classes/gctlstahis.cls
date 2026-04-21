public class gctlstahis {
public g_Req__c req {get;set;}
     public gctlstahis() {
        String rid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
       req = [select id, xcbd__c, xadh__c, (select id, f__r.Name, CreatedDate, CreatedBy.Name,
           actE__c, itm__r.Name, To__c, t__r.hisl__c, LastModifiedDate, t__r.kstp__c from Status_History__r where isDeleted=false order by CreatedDate desc) from g_Req__c where id=:rid];
    }
}