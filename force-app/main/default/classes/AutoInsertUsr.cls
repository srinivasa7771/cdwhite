public class AutoInsertUsr implements Database.Batchable<sObject>, Database.AllowsCallouts{

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, Name, lc__c, mic__c FROM Account WHERE isDeleted=false AND CreatedDate = LAST_N_DAYS:101 AND Type !=\'Customer-DED\' AND lc__c != null AND lc__c != \'\' AND lctp__c !=\'DED\'  LIMIT 999';
        //'SELECT Id, Name, lc__c FROM Account WHERE lc__c in (\'91134\', \'31359\')';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Account> lstAcc) {fetchMangerIn(lstAcc);}
    public void finish(Database.BatchableContext BC) {}

    public void fetchMangerIn(List<Account> lstAcc) {
        try{
            /*Added To Insert user for general manager Start*/
            map<String, String> mapAccToManager = new map<String, String>();
            for ( acc_sharehd__c objSh : [Select Id, crole__c, fname__c, lname__c, Email__c, accsh__c  from acc_sharehd__c
            where accsh__c IN: lstAcc  and crole__c like '%General Manager%'] ) {
                mapAccToManager.put(objSh.accsh__c, objSh.Email__c);
            }
            system.debug('mapAccToManager===='+ mapAccToManager);
            map<String, String> mapAccUser = new map<String, String>();
            for (User  objUser: [Select Id, isActive,  accountId from User where accountId IN:mapAccToManager.KeySet() and email IN: mapAccToManager.values()] ) {
                mapAccUser.put(objUser.accountId , objUser.id);
            }

            system.debug('mapAccUser===='+ mapAccUser);
            List<Ws_call__c> lstWsCall = new  List<Ws_call__c>();
            for (Account ac: lstAcc) {
                if (mapAccToManager.containsKey(ac.id) && !mapAccUser.containsKey(ac.id)) {
                    system.debug('insert user for Account'+ ac);
                    ws_call__c wsCall = new ws_call__c();
                    wsCall.rq_jsn__c = ac.lc__c;
                    wsCall.pmid__c = ac.Id;
                    wsCall.intsts__c = 'Ready for Integration';
                    wsCall.ws_typ__c = 'UserCreation';
                    lstWsCall.add(wsCall);
                    ac.mic__c = true;
                }
            }
            System.debug('#### lstWsCall : ' + lstWsCall);
            System.debug('#### lstAcc : ' + lstAcc);
            if (Schema.sObjectType.Ws_call__c.isCreateable()) {
                insert lstWsCall;
            }
            if (Schema.sObjectType.Account.isUpdateable()) {
                update lstAcc;
            }

        }catch (exception ex) {
            System.debug('exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    }

}