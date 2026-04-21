global class BatchOnboardCancelReq implements Database.Batchable<sObject>, Database.AllowsCallouts {
    String query;
    String orclid;
    global BatchOnboardCancelReq(){
         //query = 'select id,name,Sta__c,srvc__c,acc__c,acc__r.ccrm_sfid__c,acc__r.ORACLE_PARTY_ID__c,(Select Id,upOk__c From rDocs__r where Req__c=true and upOk__c=false and IsDeleted=false) from g_req__c where srvc__r.uid__c in (\'322\') and epexpdt__c!=null and epexpdt__c>TODAY';
        query = label.Onboarding_CloseAccQry;
    }
    global BatchOnboardCancelReq(String orclid){
        this.orclid = orclid;
        // query = 'Select Id,name,sta__c,(SELECT id, name, sta__r.cd__c,sta__r.rqSTA__c from items__r where sta__r.rqSTA__c in (\'Cancelled\',\'Completed\',\'rejected\'))  from g_req__c where sta__c  in (\'Open\',\'In Process\',\'Under Review\') and isp__c=false and id=\''+rqId+'\'';
        query = 'select id,name,Sta__c,srvc__c,acc__c,acc__r.ccrm_sfid__c,acc__r.ORACLE_PARTY_ID__c from g_req__c where acc__r.ORACLE_PARTY_ID__c=:orclid';
    }
      global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator(query);
    }
     global void execute(Database.BatchableContext BC, List<g_req__c> scope) {
         list < g_Req__c > listofReqToUpdate = new list < g_Req__c > ();
         List < g_reqitem__c > toUpdate = new List < g_reqitem__c > ();
         List<ws_call__c> wslst = new List<ws_call__c>();
         //List<id> usridLst = new  List<Id>();
         for (g_req__c ru : scope){
            // if (ru.rDocs__r == null || ru.rDocs__r.size() ==0){
                 ru.sta__c = 'Cancelled';
                 listofReqToUpdate.add(ru);
                  map < String, Id > mapSTA = new map < String, Id > ();
            for (g_srvcitm_Status__c s: [select id, cd__c, itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__c =: ru.srvc__c and cd__c = 'c']) {
                mapSTA.put(s.itm__r.cd__c, s.Id);
            }
            list < g_reqitem__c > items = [select Id, itm__r.cd__c, sta__c, sta__r.Tp__c from g_reqitem__c where RQ__c =: ru.Id and isDeleted = false and sta__r.Tp__c = 'Open'];
            for (g_reqitem__c i: items) {
                if (mapSTA.get(i.itm__r.cd__c) == null) {
                    System.debug(Label.msgNFSTAC);
                }
                i.sta__c = mapSTA.get(i.itm__r.cd__c);
                toUpdate.add(i);
            }
            /*for (User usr: [select id,isactive from User where contact.accountid=:ru.acc__c])
             usridLst.add(usr.id);    */
          // }

         }
         List<Id> accIdLst = new List<id>();
         if (listofReqToUpdate != null && !listofReqToUpdate.isEmpty() && String.isNotBlank(listofReqToUpdate[0].acc__r.ccrm_sfid__c)){

           accIdLst.add(listofReqToUpdate[0].acc__c);
            ws_call__c ws = new ws_call__c();
            ws.intsts__c = 'Ready for Integration';
            ws.ws_typ__c = 'Onboarding';
            ws.mtd_nm__c = 'updateWOStatus';
            ws.rq_jsn__c = '{ "methodName": "canelaccount", "data": [ { "ccrmAccountId": "'+listofReqToUpdate[0].acc__r.ccrm_sfid__c+'", "oraclePartyId": "'+listofReqToUpdate[0].acc__r.ORACLE_PARTY_ID__c+'", "accountStatus": "Cancelled", "reason": "'+Label.Onboarding_DisqualifyReason+'", "category": "Spam" } ] }';
            ws.pmid__c = listofReqToUpdate[0].acc__r.ccrm_sfid__c;
            //wslst.add(ws);

            HttpResponse response   = grqWsOnboard.ccrmStatusUpdate(ws.rq_jsn__c);
            if (response.getStatusCode()==200) {
                String respBody = '';
                if (response.getBody()!=null){respBody =  response.getBody(); }
                System.debug('<response.getBody()> : ' + respBody);
                List<grqWsOnboard.RecInfo> recs = (List<grqWsOnboard.RecInfo>)JSON.deserialize(respBody,List<grqWsOnboard.RecInfo>.class);
                if (recs[0].isSuccess){
                    ws.intsts__c = 'Success';
                }else{ws.intsts__c = 'Failed';}
                ws.res_jsn__c = respBody;

            } else { ws.intsts__c = 'Failed';if (response.getBody()!=null){ws.res_jsn__c =  response.getBody(); }}
            SObjectAccessDecision secDec = Security.stripInaccessible(AccessType.CREATABLE, wslst);
            insert secDec.getRecords();
         }
         /*if (wslst != null && !wslst.isEmpty())
            SObjectAccessDecision secDec2 = Security.stripInaccessible(AccessType.CREATABLE, wslst);
            insert secDec2.getRecords();
         if (toUpdate.size() > 0) {
            update(toUpdate);
         }
        if (listofReqToUpdate.size() > 0) {
            update(listofReqToUpdate);
        }
          System.enqueueJob(new OnboardQueueable('revokeUserAccess', accIdLst));
          /*if (usridLst.size() > 0) {
            System.enqueueJob(new OnboardQueueable('cancelAccount', usridLst[0]));
         }*/

     }


     global void finish(Database.BatchableContext BC){}
}