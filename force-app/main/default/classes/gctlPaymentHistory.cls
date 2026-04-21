public class gctlPaymentHistory {

    public g_req__c rq {get; set;}
    
    public gctlPaymentHistory(){
        System.debug('::gctlPaymentHistory::');
        String reqId = apexpages.currentpage().getparameters().get('id');
        rq = [ SELECT id, name,srvc__r.uid__c,
              (SELECT Id,Name,STA__c,dt__c,A__c,md__c,TP__c ,fwf__c FROM Transactions__r WHERE isDeleted=false), 
              (SELECT Id,CaseNumber,Origin,Type,Subject,Status,Category__c,Sub_Category__c,CreatedDate,ClosedDate FROM Cases__r ORDER BY IsClosed,CreatedDate DESC) 
              FROM g_req__c WHERE id=:reqId];
        
    }
}