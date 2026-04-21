public class grbrCtl {
   public g_Req__c rq{get;set;}
   public g_cmb__c cb{get;set;}
   public String id{get;set;}
   public String loc{get;set;}
   public grbrCtl(ApexPages.StandardController c) {
       rq=(g_Req__c)c.getRecord();
       try{
           cb=[SELECT Id, Name, xccpd__c from g_cmb__c  where xawb__c=:rq.xawb__c];
           rq.xaloc__c=loc.replace('\n', ', ');
           rq.xaloc__c=loc.replace('\r', ', ');
           rq.xaloc__c=rq.xaloc__c.trim();
       }
       catch (Exception e) {
       }
   }
}