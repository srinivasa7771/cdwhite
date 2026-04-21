public with sharing class gctlstult {
 public g_Req__c rq {get;set;}
     public Boolean ispu {get;set;}
     public gctlstult(ApexPages.StandardController c) {
          ispu=gu.isPortalUser(UserInfo.getProfileId());
        String rid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
       rq = [select id, Applicant_Name__c, con__r.account.name, con__r.Personal_Photo__c,
           con__r.Gender__c, stuperQR__c, xphid__c, xrpid__c, xrped__c, xcp__c, action__c, Acc__r.Name,
           con__r.p__c, con__r.License_Number__c, xcnc__c, e__c, xceidedt__c, name, xdtcls__c from g_Req__c where id=:rid];
    }

}