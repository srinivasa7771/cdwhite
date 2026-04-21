public class Contact_Details_CTL
{
    public Contact cont{get;set;}
    public List<Case> lstCases {get;set;}
    public List<g_Req__c> lstRequests {get;set;}

    public Contact_Details_CTL(ApexPages.StandardController stdController) {
        this.cont = (Contact)stdController.getRecord();
        loadData();
    }

    public void loadData() {
        this.cont = [Select Id, Name, AccountId from Contact Where Id=:cont.Id];
        Account ac = [Select Id, Name,
            (Select Id, CaseNumber, Subject, Status, CreatedDate, Category__c, Origin, Sub_Category__c, OwnerId, Owner.Name, ContactId From Cases where IsClosed=false),
            (Select Id, srvc__r.lbl__c , Name, Acc__c, Acc__r.Name, STA__c, CreatedDate, Con__c,
                Spr__c, Service__c, xfpc__c From Requests__r where STA__c != 'Completed' AND STA__c !=: 'Rejected' and STA__c != 'Cancelled' Order By xfpc__c desc)
            from Account Where Id =: cont.AccountId];
       lstCases = ac.Cases;
       lstRequests = ac.Requests__r;
    }
}