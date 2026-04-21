global class BatchNonSponAutoUpdate implements Database.Batchable < sObject > , Database.AllowsCallouts {
    private List<Id> rqItmIds;
    private String requestPriority;
    private String methodName;
    String query;
    global BatchNonSponAutoUpdate() {
        query = 'SELECT Id, ismdt__c, rq_itm__r.RQ__r.Name, rq_itm__r.sta__r.slaN__c, rq_itm__r.sta__r.slaXP__c, rq_itm__r.exp__c, rq_itm__r.islax__c, rq_itm__r.RQ__r.e__c, rq_itm__r.islan__c, rq_itm__r.xf__c, rq_itm__c, ws_typ__c, mtd_nm__c, sdt__c, intsts__c, err_msg__c, rq_jsn__c, res_jsn__c From ws_call__c where intsts__c =\'Ready for Integration\' AND ismp__c=false AND ws_typ__c=\'AUTOCLOSE\' AND ( mtd_nm__c=\'NONSPONIDREN\' or mtd_nm__c=\'NONSPONIDCAN\' ) ORDER BY CreatedDate ASC';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('query::' + query);
        return Database.getQueryLocator(query);
    }
      global void execute(Database.BatchableContext BC, List < sObject > scope) {
          List<ws_call__c> wsList=(List<ws_call__c>)scope;
           ws_call__c ws=wsList[0];
          updateNSID(ws.id);
      }
     public static void  updateNSID(id nws) {
        List<ws_call__c> wsList=[SELECT Id, ismdt__c, rq_itm__r.RQ__r.Name, rq_itm__r.sta__r.slaN__c,
            rq_itm__r.sta__r.slaXP__c, rq_itm__r.exp__c, rq_itm__r.islax__c, rq_itm__r.RQ__r.e__c,
            rq_itm__r.islan__c, rq_itm__r.xf__c, rq_itm__c, ws_typ__c, mtd_nm__c, sdt__c, intsts__c,
            err_msg__c, rq_jsn__c, res_jsn__c From ws_call__c where id=:nws];
        ws_call__c ws=wsList[0];
        try{
            g_req__c R=[Select id, Name, Sta__c, srvc__c, Con__c from g_req__c where Name=:ws.rq_itm__r.RQ__r.Name];

            //Non sponsor Renewal
            if (ws.mtd_nm__c=='NONSPONIDREN') {
                if (grqI.uItms(R, 'ok')) {
                    String requestItemCode='';
                    List< g_reqitem__c> riLst= [SELECT itm__r.cd__c, xi__c, xiid__c, xied__c
                                                FROM g_reqitem__c
                                                WHERE RQ__c =: R.Id
                                                AND itm__r.cd__c in('id', 'id2', 'gid') ];

                    g_reqitem__c ri= riLst[0];
                    requestItemCode=ri.itm__r.cd__c;

                    Contact applicant = [SELECT Id, idtxt__c, ididt__c, idedt__c
                                         FROM Contact
                                         WHERE Id =: R.Con__c];

                    Integer currentYear = Date.today().year();

                    // The new id expiry is the current year and the day and month of the previous expiry date
                    Date idExp = applicant.idedt__c != null ? Date.newInstance(currentYear, applicant.idedt__c.month(), applicant.idedt__c.day()):Date.today();

                    //Id card issue is previous year expiry
                    applicant.ididt__c = idExp;

                    ri.xiid__c = idExp;

                    if (requestItemCode == 'gid') {
                        applicant.idedt__c = (idExp).addYears(5).addDays(-1);
                    }
                    else if (requestItemCode == 'id2') {
                        // previous year expiry  + 2
                        applicant.idedt__c = (idExp).addYears(2).addDays(-1);
                    }
                    else {
                        // previous year expiry  + 1
                        applicant.idedt__c = (idExp).addYears(1).addDays(-1);
                    }
                    //Id card expiry is new year expiry
                    ri.xied__c = applicant.idedt__c;
                    ri.xi__c = applicant.idtxt__c;
                    R.ID_Generated__c = true;
                    R.STA__c='Completed';
                    update ri;
                    update applicant;
                    update R;

                    ws.intsts__c='Success';
                    if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                        update ws;
                    }
                }
            } else if (ws.mtd_nm__c=='NONSPONIDCAN') {
                //Non sponsor Cancellation
                if (grqI.uItms(R, 'ac')) {
                    R.ID_Generated__c = true;
                    update R;
                    R.STA__c='Completed';
                    ws.intsts__c = 'Success';
                    if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                        update ws;
                    }
                }
            }
        } catch (Exception e) {
            ws.res_jsn__c=e.getStackTraceString();
            ws.intsts__c='Failed';
            if (Schema.sObjectType.ws_call__c.isUpdateable()) {
                update ws;
            }
            system.debug(e.getStackTraceString());
        }
    }

    global void finish(Database.BatchableContext BC) {}
}