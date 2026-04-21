global class gctlMst {

    global  List<g_Milestone__c> mst{

     get{
            return mst = [SELECT Name__c, agm__c, Request__c , desc__c, SLA_Duration__c, eDesc__c ,
                Status__c, Request__r.Ap__c, Request__r.Aop__c, Request__r.srvc__r.uid__c, Request__r.srvc__r.Group__c FROM g_Milestone__c where Request__r.Name=:srName];
        }
        set;
   }
    global String srName{set;get;}

}