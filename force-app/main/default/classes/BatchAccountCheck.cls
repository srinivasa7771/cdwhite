global class BatchAccountCheck implements Database.Batchable < sObject > , Database.AllowsCallouts, Schedulable {

    global String type;
    global String partyId;

    global BatchAccountCheck() {}

    global BatchAccountCheck(String type, string partyId) {
        this.type = type;
        this.partyId = partyId;
    }

     global BatchAccountCheck(String type) {
        this.type = type;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {

        String query = 'Select id, ORACLE_PARTY_ID__c, orafu_bg__c, ora_fu_dep__c from Account where ORACLE_PARTY_ID__c != null ';
        if (String.isNotBlank(partyId)) {
            query +=  ' and ORACLE_PARTY_ID__c =\''+partyId+'\'';
        }
        system.debug('query==='+query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <Account > scope) {

        system.debug('scope==='+scope);
        List<Account> lstAcountToUpdate = new List<Account>();
        if (scope != null && scope.size() > 0) {

            for (Account objAccount: scope) {
                decimal balance = 0.0;
                String resp = gtFussionWs.checkBalance(objAccount.ORACLE_PARTY_ID__c, type);
                system.debug('resp==='+resp);
                BalanceChkResp bresp = (BalanceChkResp) JSON.deserialize(resp, BalanceChkResp.class);
                if (bresp.STATUS == 'Error') {
                    balance = 0.0;
                } else {
                    balance = bresp.CUST_BAL_UNAPP;
                }
                system.debug('balance==='+balance);
                Account obj = new Account();
                obj.Id= objAccount.Id;
                if (type == 'DEP') obj.ora_fu_dep__c = balance;
                else obj.orafu_bg__c =balance ;
                lstAcountToUpdate.add(obj);
            }
            system.debug('lstAcountToUpdate==='+lstAcountToUpdate);
            if (!lstAcountToUpdate.isEmpty()) {
                system.debug('lstAcountToUpdate===='+lstAcountToUpdate);
                if (Schema.sObjectType.Account.isUpdateable()) {
                    update lstAcountToUpdate;
                }
            }

        }

    }

    global void finish(Database.BatchableContext BC) {}

    global void execute(SchedulableContext sc) {
        database.executebatch(new BatchAccountCheck(type, partyId));
    }

}