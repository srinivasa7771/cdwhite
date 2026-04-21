public class gctlPortalAlert {
    public string accid {
        set;
        get;
    }
    public User loggedInUser {
        get;
        set;
    }
    public String aPark {
        get;
        set;
    }
    public gctlPortalAlert(){
        loggedInUser = [SELECT ContactId , Contact.AccountId, Contact.Email, Email, Contact.Type__c, Account.ec__c, Account.vespe__c, Account.PSA_Signed_By__r.flnm__c
                        FROM User
                        WHERE Id = :UserInfo.getUserId()];
        accid = loggedInUser.Contact.AccountId;
        system.debug('loggedInUser -- '+loggedInUser);
    }
    public void updateAlertConfirmation_User() {
        system.debug('U.Policy_Confirmation_Date__c -- ');
        loggedInUser.Policy_Confirmation_Date__c = Date.today();
        // system.debug('U.Policy_Confirmation_Date__c -- '+U.Policy_Confirmation_Date__c);
        update loggedInUser;
    }
    public void AccountDetails() {  
        accid = String.isBlank(accid) ? apexpages.currentpage().getparameters().get('id') : accid;
        if(accid != null && String.isnotBlank(accid)){
            Account acc = [SELECT Id,name,lc__c, PSA_Signed_Date__c, Prk__c
                           FROM Account
                           WHERE Id =: accid];
            aPark = acc.Prk__c;
            
        }
        
    }
}