public with sharing class userOutOfOfficeExt{
    public User usr {get; set;}
    public userOutOfOfficeExt(ApexPages.StandardController std) {
        usr = [select id, Out_Of_Office__c, From_Date__c, To_Date__c from User where Id=: std.getId()];
    }
    public void Save() {
        if (Schema.sObjectType.User.isUpdateable()) {
            update usr;
        }
        usr = [select id, Out_Of_Office__c, From_Date__c, To_Date__c from User where Id=: usr.Id];
        system.debug('usr: '+usr.Out_Of_Office__c);
    }
}