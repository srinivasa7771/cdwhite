global class BatchOnboardCrtUsr implements Database.Batchable<sObject>, Database.AllowsCallouts {
     global String query;
    global BatchOnboardCrtUsr() {
        query = 'select id, ccrm_sfid__c, mic__c, park__c, Prk__c from Account where bkflg__c=true and mic__c=false';
    }
    global BatchOnboardCrtUsr(string accid) {
        query = 'select id, ccrm_sfid__c, mic__c, park__c, Prk__c from Account where bkflg__c=true and id=\''+accid+'\'';
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }
     global void execute(Database.BatchableContext BC, List<Account> scope) {

         Account acc = scope[0];
         try{
        List<g_req__c>  rqLst = [select id from g_req__c where Acc__c=:acc.id];
         if (rqLst == null || rqLst.isEmpty()) {
             String accinfo = BatchOnboardFetchAccInfo.getCCRMAccountInfo(acc.ccrm_sfid__c);

          if (String.isNotBlank(accinfo)) {
              grqWsOnboard.Records rec = (grqWsOnboard.Records)JSON.deserialize(accinfo, grqWsOnboard.Records.class);
             if (rec.members != null) {
                 grqWsOnboard.Member mb = rec.members[0];
                 contact con = new Contact(lastname = rec.crmAccName, email = mb.email, p__c = acc.ccrm_sfid__c, accountid = acc.id);
                 if (Schema.sObjectType.Contact.isCreateable()) {
                     insert con;
                 }
                 String nicknm = rec.crmAccName.substring(0, 2) + String.valueof(Math.random()).substring(2, 7);
                User nwU = new User(); /*nwU.FirstName   = m.FirstName;*/
                nwU.LastName = rec.crmAccName;
                nwU.Email = mb.email;
                nwU.Username = nicknm + '@' + (acc.park__c).toLowerCase() + '.axs';
                nwU.Alias = nicknm;
                nwU.ProfileId = gU.csStr('gpSU');
                nwU.ContactId = con.id;
                nwU.CommunityNickname = rec.crmAccName.substring(0, 1) + acc.park__c + nicknm;
                nwU.IsActive = true;
                nwU.TimeZoneSidKey = 'Asia/Dubai';
                nwU.LocaleSidKey = 'en_GB';
                nwU.LanguageLocaleKey = 'en_US';
                nwU.EmailEncodingKey = 'ISO-8859-1';
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.EmailHeader.triggerUserEmail = true;
                nwU.setOptions(dmo);
                if (Schema.sObjectType.User.isCreateable()) {
                    insert nwU;
                }
                g_Req__c r = new g_Req__c( srvc__c = Label.New_Freelancer_SID, xceml__c = mb.email, xbrnd__c = acc.Prk__c, xcfn__c = rec.crmAccName, Acc__c = acc.id, STA__c='Open', xdei__c='DDAID');
                if (Schema.sObjectType.g_Req__c.isCreateable()) {
                    insert r;
                }
                acc.mic__c = true;
                if (Schema.sObjectType.Account.isUpdateable()) {
                    update acc;
                }
             }

          }
         }
         }catch (Exception ex) {
             system.debug('ex::'+ex.getStackTraceString());
         }

     }
    global void finish(Database.BatchableContext BC) {}

}