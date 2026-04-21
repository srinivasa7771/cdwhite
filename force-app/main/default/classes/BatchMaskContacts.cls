global class BatchMaskContacts implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
     String query = 'Select id, AccountId, Email, HomePhone, MobilePhone from contact';
        return Database.getQueryLocator(query);
            }
    global void execute(Database.BatchableContext bc, List<Contact> conLst) {
        Set<Id> accIds = new Set<Id>();
        List<Contact> updateconLst = new List<Contact>();
        List<Account> updateaccLst = new List<Account>();
        system.debug('conAccLst'+conLst);
        for (Contact con : conLst) {
            accIds.add(con.AccountId);
            contact c = new Contact(Id=con.id, Email='', HomePhone='', MobilePhone='');
            updateconLst.add(c);
        }
        system.debug('accIds ---->'+accIds);
          system.debug('accIds size---->'+accIds.size());
        system.debug('updateconLst ---->'+updateconLst);
         system.debug('updateconLst size ---->'+updateconLst.size());
        if (!updateconLst.isEmpty()) {
            if (Schema.sObjectType.Contact.isUpdateable()) {
                update updateconLst;
            }
        }
        for (Account acc : [Select Id, Phone, Email__c from Account Where Id IN:accIds]) {

             Account a = new Account(Id=acc.id, Phone='', Email__c='');
            updateaccLst.add(a);

        }
        system.debug('updateaccLst ---->'+updateaccLst);
         system.debug('updateaccLst size---->'+updateaccLst.size());
        if (!updateaccLst.isEmpty()) {
            if (Schema.sObjectType.Account.isUpdateable()) {
                update updateaccLst;
            }
        }
    }
    global void finish(Database.BatchableContext bc) {
        // execute any post-processing operations
    }
}