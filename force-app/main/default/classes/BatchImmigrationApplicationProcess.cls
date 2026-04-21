global class BatchImmigrationApplicationProcess implements Database.Batchable < sObject > , Database.AllowsCallouts {

    global String query;
    global Datetime dt;
    global String batchName;
    global String docName;
    global String gApiToken;
    global Map < String, Map < String, String >> getLookupIdByTypeNname = new Map < String, Map < String, String >> ();
    global BatchImmigrationApplicationProcess(String executeBatchName, String rol, integer calYear, integer calMonth) {
        batchName = executeBatchName;
        gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
        query = 'select id,firstname,lastname,mn__c,mon__c,fnar__c,lnar__c,mnar__c,mona__c,e__c,eid__c,eed__c,epui__c,rpui__c from Contact where lnar__c = null and STA__c in (\'Active\',\'Under Activation\') and rol__c = \'' + rol + '\'';
        if (calYear != null)
            query += ' and CALENDAR_YEAR(createddate) = ' + calYear;
        if (calMonth != null)
            query += ' and CALENDAR_MONTH(createddate) = ' + calMonth;

    }
    global BatchImmigrationApplicationProcess(String executeBatchName, boolean flg) {
        batchName = executeBatchName;
        dt = Datetime.now();
        gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
        query = 'SELECT Id,ismdt__c,rq_itm__r.xf__c,rq_itm__r.xat__c,rq_itm__c,ws_typ__c,mtd_nm__c,sdt__c,intsts__c,err_msg__c,rq_jsn__c,res_jsn__c From ws_call__c where intsts__c =\'Ready for Integration\' AND ismp__c=false AND mtd_nm__c=\'submitPayment\' and rq_itm__r.AD__c<=0 and (sdt__c<=:dt or isRI__c=true OR rq_itm__r.RQ__r.expflg__c=true) and (rq_itm__r.RQ__r.xfpdd__c < 2021-07-04 or No_Issue__c=true or rq_itm__r.itm__r.cd__c in (\'la\',\'ins\',\'oua\',\'oup\')) and rq_itm__r.xf__c != NULL and rq_itm__r.sta__r.cd__c in (\'n\',\'rv\',\'v\',\'ics\',\'ppr\',\'dcc\',\'dec\') ORDER BY CreatedDate ASC';
    }
    global BatchImmigrationApplicationProcess(String executeBatchName, String docName) {
        docName = docName;
        batchName = executeBatchName;
        if (batchName == 'uploadAdohDocument') query = 'SELECT Id,ismdt__c,rq_itm__r.RQ__c,rq_itm__r.xf__c,rq_itm__c,ws_typ__c,mtd_nm__c,sdt__c,intsts__c,err_msg__c,rq_jsn__c,res_jsn__c From ws_call__c where intsts__c =\'Ready for Integration\' AND ismp__c=false AND mtd_nm__c=\'uploadSingleDocument\' AND rq_itm__r.xf__c != NULL and Approved__c=true ORDER BY CreatedDate ASC';
    }
    global BatchImmigrationApplicationProcess(String executeBatchName, integer ndays) {
        /* update EP Details */
        batchName = executeBatchName;
        if (executeBatchName == 'updateEP') query = 'SELECT Id,xrp__c,xrpid__c,xrped__c,xe__c,xeid__c,xeed__c,xui__c,xcfn__c,xcfnar__c,xcln__c,xclnar__c,xcmn__c,xcmnar__c,xcmon__c,xcmonar__c,RQ__c,RQ__r.Con__c,xf__c,xi__c,sta__c,sta__r.cd__c,itm__c FROM g_reqitem__c WHERE itm__r.cd__c=\'ep\' AND sta__r.cd__c in (\'ok\',\'ii\',\'dc\') AND xf__c != NULL AND xi__c != NULL and ((NOT xe__c LIKE \'201%\') or xui__c=\'\' or RQ__r.con__r.rpui__c =\'\' or  (NOT RQ__r.con__r.e__c LIKE \'201%\') or RQ__r.con__r.eid__c=null) and  RQ__r.STA__C in (\'In Process\',\'Under Review\',\'Open\') and lastmodifieddate = LAST_N_DAYS:' + ndays;
    }
    global BatchImmigrationApplicationProcess(String executeBatchName) {
        batchName = executeBatchName;
        dt = Datetime.now();
        gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
        if (batchName == 'createApplication') {
            getLookupIdByTypeNname = GDRFAUtil.LookupIdByTypeNname();
            query = 'SELECT Id,ismdt__c,rq_itm__r.sta__r.slaN__c,rq_itm__r.sta__r.slaXP__c,rq_itm__r.exp__c,rq_itm__r.islax__c,rq_itm__r.RQ__r.e__c,rq_itm__r.islan__c,rq_itm__r.xf__c,rq_itm__c,ws_typ__c,mtd_nm__c,sdt__c,intsts__c,err_msg__c,rq_jsn__c,res_jsn__c From ws_call__c where intsts__c =\'Ready for Integration\' AND ismp__c=false AND  ws_typ__c=\'Immigration EVEP\' AND mtd_nm__c=\'createApplication\' and rq_itm__r.RQ__r.Acc__r.lc__c != \'\' and rq_itm__r.sta__r.cd__c in (\'n\',\'aid\',\'rv\',\'v\',\'ics\',\'ppr\',\'dcc\',\'dec\') AND RP_Valid__c=TRUE AND isRI__c=TRUE  ORDER BY CreatedDate ASC';
        } else if (batchName == 'uploadSingleDocument')
            query = 'SELECT Id,ismdt__c,rq_itm__r.RQ__c,rq_itm__r.itm__r.cd__c,rq_itm__r.RQ__r.Srvc__r.uid__c,rq_itm__r.xf__c,rq_itm__c,ws_typ__c,mtd_nm__c,sdt__c,intsts__c,err_msg__c,rq_jsn__c,res_jsn__c From ws_call__c where intsts__c =\'Ready for Integration\'  AND ismp__c=false AND mtd_nm__c=\'uploadSingleDocument\' AND rq_itm__r.xf__c != NULL ORDER BY CreatedDate ASC';
        else if (batchName == 'uploadSingleDocumentAdh')
            query = 'SELECT Id,ismdt__c,rq_itm__r.RQ__c,rq_itm__r.itm__r.cd__c,rq_itm__r.RQ__r.Srvc__r.uid__c,rq_itm__r.xf__c,rq_itm__c,ws_typ__c,mtd_nm__c,sdt__c,intsts__c,err_msg__c,rq_jsn__c,res_jsn__c From ws_call__c where intsts__c =\'Ready for Integration\'  AND ismp__c=false AND mtd_nm__c=\'uploadSingleDocument\' AND rq_itm__r.xf__c != NULL ORDER BY CreatedDate ASC';
        else if (batchName == 'invokePayment') {
            /*String sdt = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');*/
            query = 'SELECT Id,ismdt__c,rq_itm__r.xf__c,rq_itm__r.xat__c,rq_itm__c,ws_typ__c,mtd_nm__c,sdt__c,intsts__c,err_msg__c,rq_jsn__c,res_jsn__c From ws_call__c where intsts__c =\'Ready for Integration\' AND ismp__c=false AND mtd_nm__c=\'submitPayment\' and rq_itm__r.AD__c<=0 and (sdt__c<=:dt or isRI__c=true OR rq_itm__r.RQ__r.expflg__c=true) and rq_itm__r.xf__c != NULL and rq_itm__r.sta__r.cd__c in (\'n\',\'rv\',\'v\',\'ics\',\'aid\',\'ppr\',\'dcc\',\'dec\') ORDER BY CreatedDate ASC';
        } else if (batchName == 'checkFinePayment') {
            /*String sdt = DateTime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');*/
            query = 'SELECT Id,ismdt__c,rq_itm__r.xf__c,rq_itm__r.xat__c,rq_itm__c,ws_typ__c,mtd_nm__c,sdt__c,intsts__c,err_msg__c,rq_jsn__c,res_jsn__c From ws_call__c where intsts__c =\'Ready for Integration\'  AND mtd_nm__c=\'submitPayment\' and rq_itm__r.AD__c<=0 and   rq_itm__r.xf__c != NULL and rq_itm__r.sta__r.cd__c in (\'n\',\'rv\',\'v\',\'ics\',\'ppr\',\'dcc\',\'dec\',\'rc\') ORDER BY CreatedDate ASC';
        } else if (batchName == 'checkApplicationStatus') {
            /*query = 'SELECT Id,First_Payment__c,itm__c,xat__c,xf__c,xi__c,sta__c,sta__r.cd__c,(SELECT Id,reqItm__c,reqItm__r.xf__c,reqDoc__c,reqDoc__r.RQ__c,reqItm__r.xe__c FROM itmsDocs__r WHERE Name=\'Entry Permit Copy\' AND Tp__c=\'Entry permit\') FROM g_reqitem__c WHERE sta__r.cd__c=\'if\'  AND xf__c != NULL AND xi__c != NULL';*/
            /*query = 'SELECT Id,First_Payment__c,itm__c,xat__c,xf__c,xi__c,sta__c,sta__r.cd__c,(SELECT Id,reqItm__c,reqItm__r.xf__c,reqDoc__c,reqDoc__r.RQ__c,reqItm__r.xe__c FROM itmsDocs__r WHERE Name=\'Entry Permit Copy\' AND Tp__c=\'Entry permit\') FROM g_reqitem__c WHERE sta__r.cd__c=\'if\'  AND xf__c != NULL AND xi__c != NULL'; */
            query = 'SELECT Id,xargno__c,xrcd__c,itm__r.cd__c,itm__r.Srvc__r.uid__c,First_Payment__c,itm__c,xat__c,xf__c,xi__c,sta__c,sta__r.cd__c,RQ__c,RQ__r.Acc__c,(SELECT Id,reqItm__c,reqItm__r.xf__c,reqDoc__c,reqDoc__r.RQ__c,reqItm__r.xe__c FROM itmsDocs__r WHERE ((Name=\'Entry Permit Copy\' AND Tp__c=\'Entry permit\') or (Name=\'Establishment card\' AND Tp__c=\'Others\') or (Name=\'Establishment Card\' AND Tp__c=\'Establishment card\') or (Name=\'Residence permit copy\' AND Tp__c=\'Access Permit 1\')  or  (Name=\'Residence Permit\' AND Tp__c=\'Access Permit 1\') or (Name=\'Cancellation paper\' AND Tp__c=\'Cancellation document\') or (Name=\'LA Status Change\' AND Tp__c=\'LADOC\'))) FROM g_reqitem__c WHERE sta__r.cd__c in (\'if\',\'cif\') AND xf__c != NULL AND xi__c != NULL';

        } else if (batchName == 'checkAppEPStatus') {
            query = 'SELECT Id,xargno__c,itm__r.cd__c,First_Payment__c,itm__c,xat__c,xf__c,xi__c,sta__c,sta__r.cd__c,(SELECT Id,reqItm__c,reqItm__r.xf__c,reqDoc__c,reqDoc__r.RQ__c,reqItm__r.xe__c FROM itmsDocs__r WHERE ((Name=\'Entry Permit Copy\' AND Tp__c=\'Entry permit\'))) FROM g_reqitem__c WHERE itm__r.cd__c=\'ep\' and RQ__r.con__r.e__c=null  and  sta__r.cd__c in (\'if\',\'cif\',\'ii\',\'ca\',\'dc\',\'ok\') AND xf__c != NULL AND xi__c != NULL';
        } else if (batchName == 'checkAppRPStatus') {
            query = 'SELECT Id,xargno__c,itm__r.cd__c,First_Payment__c,itm__c,xat__c,xf__c,xi__c,sta__c,sta__r.cd__c,(SELECT Id,reqItm__c,reqItm__r.xf__c,reqDoc__c,reqDoc__r.RQ__c,reqItm__r.xe__c FROM itmsDocs__r WHERE  ((Name=\'Residence permit copy\' AND Tp__c=\'Access Permit 1\')  or  (Name=\'Residence Permit\' AND Tp__c=\'Access Permit 1\') )) FROM g_reqitem__c WHERE RQ__r.con__r.rp__c=null and itm__r.cd__c=\'rp\' and sta__r.cd__c in (\'if\',\'cif\',\'ii\',\'ca\',\'dc\',\'ok\') AND xf__c != NULL AND xi__c != NULL';
        } else if (batchName == 'updateEPStatus') {
            /*query = 'SELECT Id,xe__c,xeid__c,xeed__c,xui__c,xcfn__c,xcfnar__c,xcln__c,xclnar__c,xcmn__c,xcmnar__c,xcmon__c,xcmonar__c,RQ__c,RQ__r.Con__c,xf__c,xi__c,sta__c,sta__r.cd__c,itm__c FROM g_reqitem__c WHERE xf__c in (\'22020100018162\',\'22020100018163\',\'22020100018165\',\'22020100018174\',\'22020100018176\',\'22020100018175\') and itm__r.cd__c=\'ep\' AND sta__r.cd__c=\'ii\' AND xf__c != NULL AND xi__c != NULL';*/
            query = 'SELECT Id,xe__c,xeid__c,xeed__c,xui__c,xcfn__c,xcfnar__c,xcln__c,xclnar__c,xcmn__c,xcmnar__c,xcmon__c,xcmonar__c,RQ__c,RQ__r.Con__c,xf__c,xi__c,sta__c,sta__r.cd__c,itm__c,itm__r.cd__c,RQ__r.Srvc__r.uid__c FROM g_reqitem__c WHERE itm__r.cd__c=\'ep\' AND sta__r.cd__c=\'ii\' AND xf__c != NULL AND xi__c != NULL';
        } else if (batchName == 'updateRPStatus') {
            query = 'SELECT Id,RQ__r.srvc__r.uid__c,xrp__c,xrpid__c,xrped__c,xe__c,xeid__c,xeed__c,xui__c,xcfn__c,xcfnar__c,xcln__c,xclnar__c,xcmn__c,xcmnar__c,xcmon__c,xcmonar__c,RQ__c,RQ__r.Con__c,xf__c,xi__c,sta__c,sta__r.cd__c,itm__c,itm__r.cd__c FROM g_reqitem__c WHERE itm__r.cd__c=\'rp\'  AND sta__r.cd__c in (\'ca\',\'ii\') AND xf__c != NULL AND xi__c != NULL AND xrped__c =NULL';
        } else if (batchName == 'updateRP') {
            query = 'SELECT Id,RQ__r.srvc__r.uid__c,xrp__c,xrpid__c,xrped__c,xe__c,xeid__c,xeed__c,xui__c,xcfn__c,xcfnar__c,xcln__c,xclnar__c,xcmn__c,xcmnar__c,xcmon__c,xcmonar__c,RQ__c,RQ__r.Con__c,xf__c,xi__c,sta__c,sta__r.cd__c,itm__c,itm__r.cd__c FROM g_reqitem__c WHERE itm__r.cd__c=\'rp\'  AND sta__r.cd__c in (\'ca\',\'ii\',\'ok\',\'okk\') AND xf__c != NULL AND xi__c != NULL AND (xrped__c =NULL OR RQ__r.con__r.rped__c=NULL or RQ__r.con__r.rped__c<Today) and First_Payment__c=last_n_days:300 and RQ__r.Srvc__r.uid__c in (\'001\',\'002\',\'020\',\'021\',\'040\',\'078\',\'003\',\'004\',\'016\',\'055\',\'105\',\'106\',\'601\',\'602\',\'620\',\'621\',\'640\',\'678\',\'603\',\'604\',\'616\',\'655\',\'705\',\'706\',\'044\',\'011\')';
        } else if (batchName == 'updateCanStatus') {
            query = 'SELECT Id,xe__c,xeid__c,xeed__c,xui__c,xcfn__c,xcfnar__c,xcln__c,xclnar__c,xcmn__c,xcmnar__c,xcmon__c,xcmonar__c,RQ__c,RQ__r.Con__c,xf__c,xi__c,sta__c,sta__r.cd__c,itm__c FROM g_reqitem__c WHERE (itm__r.cd__c=\'ins\' or itm__r.cd__c=\'oua\' or itm__r.cd__c=\'oup\')  AND sta__r.cd__c=\'ca\' AND xf__c != NULL AND xi__c != NULL';
        } else if (batchName == 'updateEP') {
            query = 'SELECT Id,xrp__c,xrpid__c,xrped__c,xe__c,xeid__c,xeed__c,xui__c,xcfn__c,xcfnar__c,xcln__c,xclnar__c,xcmn__c,xcmnar__c,xcmon__c,xcmonar__c,RQ__c,RQ__r.Con__c,xf__c,xi__c,sta__c,sta__r.cd__c,itm__c,RQ__r.srvc__r.uid__c,itm__r.cd__c FROM g_reqitem__c WHERE itm__r.cd__c=\'ep\' AND sta__r.cd__c=\'ok\' AND xf__c != NULL AND xi__c != NULL and (NOT xe__c LIKE \'201%\')  ORDER BY CreatedDate desc';
        }

    }

    //  global BatchImmigrationApplicationProcess(String executeBatchName, Id wsId) { batchName = executeBatchName; dt = Datetime.now(); gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c; if (batchName == 'createApplication') { getLookupIdByTypeNname = GDRFAUtil.LookupIdByTypeNname(); query = 'SELECT Id,ismdt__c,rq_itm__r.sta__r.slaN__c,rq_itm__r.sta__r.slaXP__c,rq_itm__r.exp__c,rq_itm__r.islax__c,rq_itm__r.islan__c,rq_itm__r.xf__c,rq_itm__c,ws_typ__c,mtd_nm__c,sdt__c,intsts__c,err_msg__c,rq_jsn__c,res_jsn__c From ws_call__c where id=\'' + wsId + '\' AND ws_typ__c=\'Immigration EVEP\' AND mtd_nm__c=\'createApplication\' and rq_itm__r.sta__r.cd__c in (\'n\',\'aid\',\'rv\',\'v\',\'ics\',\'ppr\',\'dcc\',\'dec\') AND RP_Valid__c=TRUE AND isRI__c=TRUE ORDER BY CreatedDate ASC'; } else if (batchName == 'uploadSingleDocument' || batchName == 'uploadSingleDocumentAdh') query = 'SELECT Id,ismdt__c,rq_itm__r.RQ__c,rq_itm__r.RQ__r.Srvc__r.uid__c,rq_itm__r.xf__c,rq_itm__c,ws_typ__c,mtd_nm__c,sdt__c,intsts__c,err_msg__c,rq_jsn__c,res_jsn__c From ws_call__c where id=\'' + wsId + '\' AND mtd_nm__c=\'uploadSingleDocument\' AND rq_itm__r.xf__c != NULL  ORDER BY CreatedDate ASC'; else if (batchName == 'invokePayment') { query = 'SELECT Id,ismdt__c,rq_itm__r.xf__c,rq_itm__r.xat__c,rq_itm__c,ws_typ__c,mtd_nm__c,sdt__c,intsts__c,err_msg__c,rq_jsn__c,res_jsn__c From ws_call__c where id=\'' + wsId + '\' AND mtd_nm__c=\'submitPayment\' AND rq_itm__r.AD__c<=0 and sdt__c<=:dt and rq_itm__r.xf__c != NULL and rq_itm__r.sta__r.cd__c in (\'n\',\'rv\',\'v\',\'ics\',\'aid\',\'ppr\',\'dcc\',\'dec\') ORDER BY CreatedDate ASC'; } }
    global BatchImmigrationApplicationProcess(String executeBatchName, Id wsId) {
        batchName = executeBatchName;
        dt = Datetime.now();
        gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
        if (batchName == 'createApplication') {
            getLookupIdByTypeNname = GDRFAUtil.LookupIdByTypeNname();
            query = 'SELECT Id,ismdt__c,rq_itm__r.sta__r.slaN__c,rq_itm__r.sta__r.slaXP__c,rq_itm__r.exp__c,rq_itm__r.islax__c,rq_itm__r.islan__c,rq_itm__r.xf__c,rq_itm__c,ws_typ__c,mtd_nm__c,sdt__c,intsts__c,err_msg__c,rq_jsn__c,res_jsn__c From ws_call__c where id=\'' + wsId + '\' AND ws_typ__c=\'Immigration EVEP\' AND mtd_nm__c=\'createApplication\' and rq_itm__r.sta__r.cd__c in (\'n\',\'aid\',\'rv\',\'v\',\'ics\',\'ppr\',\'dcc\',\'dec\') AND RP_Valid__c=TRUE AND isRI__c=TRUE ORDER BY CreatedDate ASC';
        } else if (batchName == 'uploadSingleDocument' || batchName == 'uploadSingleDocumentAdh') query = 'SELECT Id,ismdt__c,rq_itm__r.RQ__c,rq_itm__r.RQ__r.Srvc__r.uid__c,rq_itm__r.xf__c,rq_itm__c,ws_typ__c,mtd_nm__c,sdt__c,intsts__c,err_msg__c,rq_jsn__c,res_jsn__c From ws_call__c where id=\'' + wsId + '\' AND mtd_nm__c=\'uploadSingleDocument\' AND rq_itm__r.xf__c != NULL  ORDER BY CreatedDate ASC';
        else if (batchName == 'invokePayment') {
            query = 'SELECT Id,ismdt__c,rq_itm__r.xf__c,rq_itm__r.xat__c,rq_itm__c,ws_typ__c,mtd_nm__c,sdt__c,intsts__c,err_msg__c,rq_jsn__c,res_jsn__c From ws_call__c where id=\'' + wsId + '\' AND mtd_nm__c=\'submitPayment\' AND rq_itm__r.AD__c<=0 and (sdt__c<=:dt  OR isRI__c=true)and rq_itm__r.xf__c != NULL and rq_itm__r.sta__r.cd__c in (\'n\',\'rv\',\'v\',\'ics\',\'aid\',\'ppr\',\'dcc\',\'dec\') ORDER BY CreatedDate ASC';
        }
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('query::' + query);
        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        if (batchName == 'createApplication') invokeCreateApplicationService(scope, gApiToken);
        else if (batchName == 'uploadSingleDocument') uploadSingleDocumentSrvc(scope, gApiToken);
        else if (batchName == 'uploadAdohDocument') uploadAdochDoc(scope, gApiToken, docName);
        else if (batchName == 'uploadSingleDocumentAdh') uploadSingleDocumentAdh(scope, gApiToken);
        else if (batchName == 'invokePayment') invokePayment(scope, gApiToken);
        else if (batchName == 'checkFinePayment') checkFinePayment(scope, gApiToken);
        else if (batchName == 'checkApplicationStatus') getApplicationStatus(scope, gApiToken);
        else if (batchName == 'checkAppEPStatus') getApplicationStatus(scope, gApiToken);
        else if (batchName == 'checkAppRPStatus') getApplicationStatus(scope, gApiToken);
        else if (batchName == 'updateEPStatus') {
            List < g_reqitem__c > riLst = (List < g_reqitem__c > ) scope;
            List < Contact > conLst = [select id, firstname, lastname, mn__c, mon__c, fnar__c, lnar__c, mnar__c, mona__c, e__c, eid__c, eed__c, epui__c, rpui__c from Contact where id =: riLst[0].RQ__r.Con__c];
            if (conLst != null && !conLst.isEmpty()) updateArabicDetails(riLst[0], conLst[0], gApiToken, true);
        } else if (batchName == 'updateArabicDetails') {
            List < Contact > conList = (List < Contact > ) scope;
            updateArabicDetails(null, conList[0], gApiToken, false);
        } else if (batchName == 'updateEP' || batchName == 'updateRPStatus' || batchName == 'updateRP') {
            List < g_reqitem__c > riLst = (List < g_reqitem__c > ) scope;
            List < Contact > conLst = [select id, firstname, lastname, mn__c, mon__c, fnar__c, lnar__c, mnar__c, mona__c, rp__c, rpid__c, rped__c, e__c, eid__c, eed__c, epui__c, rpui__c from Contact where id =: riLst[0].RQ__r.Con__c];
            if (conLst != null && !conLst.isEmpty()) {
                if (batchName == 'updateEP') updatePermit(riLst[0], conLst[0], gApiToken, 'Entry Permit Copy');
                if (batchName == 'updateRPStatus' || batchName == 'updateRP') updatePermit(riLst[0], conLst[0], gApiToken, 'Residence Permit');
            }
        }
    }
    //global void execute(Database.BatchableContext BC, List < sObject > scope) { if (batchName == 'createApplication') invokeCreateApplicationService(scope, gApiToken); else if (batchName == 'uploadSingleDocument') uploadSingleDocumentSrvc(scope, gApiToken); else if (batchName == 'uploadAdohDocument') uploadAdochDoc(scope, gApiToken, docName); else if (batchName == 'uploadSingleDocumentAdh') uploadSingleDocumentAdh(scope, gApiToken, docName); else if (batchName == 'invokePayment') invokePayment(scope, gApiToken); else if (batchName == 'checkApplicationStatus') getApplicationStatus(scope, gApiToken); else if (batchName == 'updateEPStatus') { List < g_reqitem__c > riLst = (List < g_reqitem__c > ) scope; List < Contact > conLst = [select id, firstname, lastname, mn__c, mon__c, fnar__c, lnar__c, mnar__c, mona__c, e__c, eid__c, eed__c, rpui__c from Contact where id =: riLst[0].RQ__r.Con__c]; if (conLst != null && !conLst.isEmpty()) updateArabicDetails(riLst[0], conLst[0], gApiToken, true); } else if (batchName == 'updateArabicDetails') { List < Contact > conList = (List < Contact > ) scope; updateArabicDetails(null, conList[0], gApiToken, false); } else if (batchName == 'updateEP' || batchName == 'updateRPStatus') { List < g_reqitem__c > riLst = (List < g_reqitem__c > ) scope; List < Contact > conLst = [select id, firstname, lastname, mn__c, mon__c, fnar__c, lnar__c, mnar__c, mona__c, rp__c, rpid__c, rped__c, e__c, eid__c, eed__c, rpui__c from Contact where id =: riLst[0].RQ__r.Con__c]; if (conLst != null && !conLst.isEmpty()) { if (batchName == 'updateEP') updatePermit(riLst[0], conLst[0], gApiToken, 'Entry Permit Copy'); if (batchName == 'updateRPStatus') updatePermit(riLst[0], conLst[0], gApiToken, 'Residence Permit'); } } }
    //global void invokeCreateApplicationService(List < sObject > scope, String gApiToken) { List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope; List < ws_call__c > wsToUpdate = new List < ws_call__c > (); try { List < ws_call__c > wsCallsToInsert = new List < ws_call__c > (); List < g_reqitem__c > updateReqItems = new List < g_reqitem__c > (); Set < String > rpNew = new Set < String > (gu.csStr('RP_New').split(';')); Set < String > rpReN = new Set < String > (gu.csStr('RP_Renewal').split(';')); Set < String > rpCan = new Set < String > (gu.csStr('RP_Cancel').split(';')); for (ws_call__c wc: lstwsCall) { String inputJson; g_reqitem__c reqItem = new g_reqitem__c(); reqItem = GDRFAUtil.reqItem(wc.rq_itm__c); inputJson = String.isBlank(wc.rq_jsn__c) ? GDRFAUtil.requestBody(reqItem, gApiToken, getLookupIdByTypeNname) : wc.rq_jsn__c; System.debug('input json:>>>>> ' + inputJson); String appLookupId; if (reqItem.itm__r.cd__c == 'ep') appLookupId = gU.csStr('GDRFAEntryPermitID'); /* RP PROCESSING*/ else if (reqItem.itm__r.cd__c == 'rp' && rpNew.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFAResidenceID'); else if (reqItem.itm__r.cd__c == 'rp' && rpReN.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFARenewResidenceID'); else if ((reqItem.itm__r.cd__c == 'ins' || reqItem.itm__r.cd__c == 'oua' || reqItem.itm__r.cd__c == 'oup' || reqItem.itm__r.cd__c == 'rpc') && rpCan.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFACancelResidenceID'); /* end */ String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/create/' + appLookupId; /*4b63e868-2380-413d-b6ef-701034701789';//qmg:4b63e868-2380-413d-b6ef-701034701789;//stg:0ba4577c-b865-4a22-bc70-3a0bba7c11c3*/ HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken); system.debug('res: ' + res.getBody()); if (res.getStatusCode() == 200) { ImmigrationResponseWrapper irw = ImmigrationResponseWrapper.parse(res.getBody()); System.debug('response:>>>>> ' + irw); List < ImmigrationResponseWrapper.cls_Documents > docsToUpload = irw.Documents; Decimal sla = reqItem.exp__c ? reqItem.islax__c : reqItem.islan__c; for (ImmigrationResponseWrapper.cls_Documents docToUpload: docsToUpload) { String docIdToUpload = ''; if (docToUpload.IsMandatory) { if (docToUpload.documentNameEn.contains('Sponsored Passport page 1')) /* page 2  to last page always*/ docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport First Page'; else if (docToUpload.documentNameEn.contains('Health Insurance card Page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Health Insurance Doc'; } else if (docToUpload.documentNameEn.contains('Medical Test page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Medical Certificate Document'; } else if (docToUpload.documentNameEn.contains('Entry permit visa')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Entry Permit Copy'; } else if (docToUpload.documentNameEn.contains('Proof of Applicant Residency')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Visa Copy'; } else { docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn; } wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (!docToUpload.IsMandatory) { if (docToUpload.documentNameEn.contains('Sponsored Passport page 2')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport Last Page'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 1') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Education Certificate(Attested):0'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 2') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Education Certificate(Attested):1'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 3') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Education Certificate(Attested):2'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 4') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Education Certificate(Attested):3'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 5') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Education Certificate(Attested):4'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 6') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Current Nationality Identity Card (front side)'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 7') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Current Nationality Identity Card (back side)'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 8') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Health Insurance Doc'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else { docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn; } } } if (String.isNotBlank(irw.applicationId)) { wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'submitPayment', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(reqItem.exp__c ? reqItem.sta__r.slaXP__c : reqItem.sta__r.slaN__c), rq_jsn__c = '{"applicationId": "' + irw.applicationId + '"}')); updateReqItems.add(new g_reqitem__c(Id = reqItem.Id, xf__c = irw.applicationId, xfid__c = System.today(), xfed__c = System.today().addMonths(3))); } for (ws_call__c ws: lstwsCall) { if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson; ws.intsts__c = 'Success'; ImmigrationResponseWrapper irw1 = ImmigrationResponseWrapper.parse(res.getBody()); for (ImmigrationResponseWrapper.cls_Documents doc: irw1.Documents) { doc.document = ''; } String resJsonStr = Json.serialize(irw1); ws.res_jsn__c = resJsonStr; wsToUpdate.add(ws); } } else { for (ws_call__c ws: lstwsCall) { if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson; ws.intsts__c = 'Failed'; ws.err_msg__c = res.getBody(); wsToUpdate.add(ws); } } } if (!wsCallsToInsert.isEmpty()) insert wsCallsToInsert; if (!wsToUpdate.isEmpty()) update wsToUpdate; if (!updateReqItems.isEmpty()) update updateReqItems; } catch (Exception e) { System.debug('--line no-- ' + e.getStackTraceString()); wsToUpdate = new List < ws_call__c > (); for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Failed'; ws.err_msg__c = e.getStackTraceString(); wsToUpdate.add(ws); } if (!wsToUpdate.isEmpty()) update wsToUpdate; } }

    // global void invokeCreateApplicationService(List < sObject > scope, String gApiToken) { List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope; List < ws_call__c > wsToUpdate = new List < ws_call__c > (); try { List < ws_call__c > wsCallsToInsert = new List < ws_call__c > (); List < g_reqitem__c > updateReqItems = new List < g_reqitem__c > (); Set < String > rpNew = new Set < String > (gu.csStr('RP_New').split(';')); Set < String > rpReN = new Set < String > (gu.csStr('RP_Renewal').split(';')); Set < String > rpCan = new Set < String > (gu.csStr('RP_Cancel').split(';')); for (ws_call__c wc: lstwsCall) { String inputJson; g_reqitem__c reqItem = new g_reqitem__c(); reqItem = GDRFAUtil.reqItem(wc.rq_itm__c); inputJson = String.isBlank(wc.rq_jsn__c) ? GDRFAUtil.requestBody(reqItem, gApiToken, getLookupIdByTypeNname) : wc.rq_jsn__c; System.debug('input json:>>>>> ' + inputJson); String appLookupId; if (reqItem.itm__r.cd__c == 'ep') appLookupId = gU.csStr('GDRFAEntryPermitID');else if (reqItem.itm__r.cd__c == 'la') appLookupId = gU.csStr('GDRFALAID'); /* RP PROCESSING*/ else if (reqItem.itm__r.cd__c == 'rp' && rpNew.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFAResidenceID'); else if (reqItem.itm__r.cd__c == 'rp' && rpReN.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFARenewResidenceID'); else if ((reqItem.itm__r.cd__c == 'ins' || reqItem.itm__r.cd__c == 'oua' || reqItem.itm__r.cd__c == 'oup' || reqItem.itm__r.cd__c == 'rpc') && rpCan.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFACancelResidenceID'); /* end */ String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/create/' + appLookupId; /*4b63e868-2380-413d-b6ef-701034701789';//qmg:4b63e868-2380-413d-b6ef-701034701789;//stg:0ba4577c-b865-4a22-bc70-3a0bba7c11c3*/ HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken); system.debug('res: ' + res.getBody()); if (res.getStatusCode() == 200) { ImmigrationResponseWrapper irw = ImmigrationResponseWrapper.parse(res.getBody()); System.debug('response:>>>>> ' + irw); List < ImmigrationResponseWrapper.cls_Documents > docsToUpload = irw.Documents; Decimal sla = reqItem.exp__c ? reqItem.islax__c : reqItem.islan__c; for (ImmigrationResponseWrapper.cls_Documents docToUpload: docsToUpload) { String docIdToUpload = ''; if (docToUpload.IsMandatory) { if (docToUpload.documentNameEn.contains('Sponsored Passport page 1')) /* page 2  to last page always*/ docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - first page'; else if (docToUpload.documentNameEn.contains('Health Insurance card Page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Health insurance card or certificate'; } else if (docToUpload.documentNameEn.contains('Medical Test page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Medical Certificate Document'; } else if (docToUpload.documentNameEn.contains('Entry permit visa')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Entry Permit Copy'; } else if (docToUpload.documentNameEn.contains('Proof of Applicant Residency')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Visa Copy'; } else if (docToUpload.documentNameEn.contains('EIDA Card Application Document')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'EIDA application form'; } else { docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn; } wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, ismdt__c = true, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (!docToUpload.IsMandatory) { if (docToUpload.documentNameEn.contains('Sponsored Passport page 2')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - last page'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 1') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:0'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 2') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:1'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 3') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:2'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 4') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:3'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 5') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:4'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 6') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Valid nationality identity card - front'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 7') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Valid nationality identity card - back'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 8') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Health insurance card or certificate'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else { docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn; } } } if (String.isNotBlank(irw.applicationId)) { wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'submitPayment', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(reqItem.RQ__r.expflg__c ? reqItem.sta__r.slaXP__c : reqItem.sta__r.slaN__c), rq_jsn__c = '{"applicationId": "' + irw.applicationId + '"}')); updateReqItems.add(new g_reqitem__c(Id = reqItem.Id, xf__c = irw.applicationId, xfid__c = System.today(), xfed__c = System.today().addMonths(3))); } for (ws_call__c ws: lstwsCall) { if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson; ws.intsts__c = 'Success'; ImmigrationResponseWrapper irw1 = ImmigrationResponseWrapper.parse(res.getBody()); for (ImmigrationResponseWrapper.cls_Documents doc: irw1.Documents) { doc.document = ''; } String resJsonStr = Json.serialize(irw1); ws.res_jsn__c = resJsonStr; wsToUpdate.add(ws); } } else { for (ws_call__c ws: lstwsCall) { if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson; ws.intsts__c = 'Failed'; ws.err_msg__c = res.getBody(); wsToUpdate.add(ws); } } } if (!wsCallsToInsert.isEmpty()) insert wsCallsToInsert; if (!wsToUpdate.isEmpty()) update wsToUpdate; if (!updateReqItems.isEmpty()) update updateReqItems; } catch (Exception e) { System.debug('--line no-- ' + e.getStackTraceString()); wsToUpdate = new List < ws_call__c > (); for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Failed'; ws.err_msg__c = e.getStackTraceString(); wsToUpdate.add(ws); } if (!wsToUpdate.isEmpty()) update wsToUpdate; } }
    //  global void invokeCreateApplicationService(List < sObject > scope, String gApiToken) { List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope; List < ws_call__c > wsToUpdate = new List < ws_call__c > (); String inputJson1; try { List < ws_call__c > wsCallsToInsert = new List < ws_call__c > (); List < g_reqitem__c > updateReqItems = new List < g_reqitem__c > (); Set < String > rpNew = new Set < String > (gu.csStr('RP_New').split(';')); Set < String > rpReN = new Set < String > (gu.csStr('RP_Renewal').split(';')); Set < String > rpCan = new Set < String > (gu.csStr('RP_Cancel').split(';')); for (ws_call__c wc: lstwsCall) { String inputJson; g_reqitem__c reqItem = new g_reqitem__c(); reqItem = GDRFAUtil.reqItem(wc.rq_itm__c); inputJson = String.isBlank(wc.rq_jsn__c) ? GDRFAUtil.requestBody(reqItem, gApiToken, getLookupIdByTypeNname) : wc.rq_jsn__c; System.debug('input json:>>>>> ' + inputJson); inputJson1 = inputJson; String appLookupId; if (reqItem.itm__r.cd__c == 'ep') appLookupId = gU.csStr('GDRFAEntryPermitID'); else if (reqItem.itm__r.cd__c == 'la') appLookupId = gU.csStr('GDRFALAID'); /* RP PROCESSING*/ else if (reqItem.itm__r.cd__c == 'rp' && rpNew.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFAResidenceID'); else if (reqItem.itm__r.cd__c == 'rp' && rpReN.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFARenewResidenceID'); else if ((reqItem.itm__r.cd__c == 'ins' || reqItem.itm__r.cd__c == 'oua' || reqItem.itm__r.cd__c == 'oup') && rpCan.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFACancelResidenceID'); /* end */ String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/create/' + appLookupId; /*4b63e868-2380-413d-b6ef-701034701789';//qmg:4b63e868-2380-413d-b6ef-701034701789;//stg:0ba4577c-b865-4a22-bc70-3a0bba7c11c3*/ HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken); system.debug('res: ' + res.getBody()); if (res.getStatusCode() == 200) { ImmigrationResponseWrapper irw = ImmigrationResponseWrapper.parse(res.getBody()); System.debug('response:>>>>> ' + irw); List < ImmigrationResponseWrapper.cls_Documents > docsToUpload = irw.Documents; Decimal sla = reqItem.exp__c ? reqItem.islax__c : reqItem.islan__c; for (ImmigrationResponseWrapper.cls_Documents docToUpload: docsToUpload) { String docIdToUpload = ''; if (docToUpload.IsMandatory) { if (docToUpload.documentNameEn.contains('Sponsored Passport page 1')) /* page 2  to last page always*/ docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - first page'; else if (docToUpload.documentNameEn.contains('Health Insurance card Page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Health insurance card or certificate'; } else if (docToUpload.documentNameEn.contains('Medical Test page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Medical Certificate Document'; } else if (docToUpload.documentNameEn.contains('Entry permit visa')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Entry Permit Copy'; } else if (docToUpload.documentNameEn.contains('New Entry Permit Visa')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Entry Permit Copy'; } else if (docToUpload.documentNameEn.contains('Old Entry Permit Visa/ Cancelled residency')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Existing residence visa page'; } else if (docToUpload.documentNameEn.contains('Proof of Applicant Residency')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Visa Copy'; } else if (docToUpload.documentNameEn.contains('EIDA Card Application Document')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'EIDA application form'; } else { docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn; } wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, ismdt__c = true, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (!docToUpload.IsMandatory) { if (docToUpload.documentNameEn.contains('Sponsored Passport page 2')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - last page'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 1') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:0'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 2') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:1'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 3') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:2'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 4') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:3'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 5') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:4'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 6') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Valid nationality identity card - front'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 7') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Valid nationality identity card - back'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 8') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Health insurance card or certificate'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else { docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn; } } } if (String.isNotBlank(irw.applicationId)) { wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'submitPayment', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(reqItem.RQ__r.expflg__c ? reqItem.sta__r.slaXP__c : reqItem.sta__r.slaN__c), rq_jsn__c = '{"applicationId": "' + irw.applicationId + '"}')); updateReqItems.add(new g_reqitem__c(Id = reqItem.Id, xf__c = irw.applicationId, xfid__c = System.today(), xfed__c = System.today().addMonths(3))); } for (ws_call__c ws: lstwsCall) { if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson; ws.intsts__c = 'Success'; ImmigrationResponseWrapper irw1 = ImmigrationResponseWrapper.parse(res.getBody()); for (ImmigrationResponseWrapper.cls_Documents doc: irw1.Documents) { doc.document = ''; } String resJsonStr = Json.serialize(irw1); ws.res_jsn__c = resJsonStr; wsToUpdate.add(ws); } } else { for (ws_call__c ws: lstwsCall) { if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson; ws.intsts__c = 'Failed'; ws.err_msg__c = res.getBody(); wsToUpdate.add(ws); } } } if (!wsCallsToInsert.isEmpty()) insert wsCallsToInsert; if (!wsToUpdate.isEmpty()) update wsToUpdate; if (!updateReqItems.isEmpty()) update updateReqItems; } catch (Exception e) { System.debug('--line no-- ' + e.getStackTraceString()); wsToUpdate = new List < ws_call__c > (); for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Failed'; ws.rq_jsn__c = inputJson1; ws.err_msg__c = e.getStackTraceString(); wsToUpdate.add(ws); } if (!wsToUpdate.isEmpty()) update wsToUpdate; } }
    //11-sep21
    // global void invokeCreateApplicationService(List < sObject > scope, String gApiToken) { List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope; List < ws_call__c > wsToUpdate = new List < ws_call__c > (); String inputJson1; try { List < ws_call__c > wsCallsToInsert = new List < ws_call__c > (); List < g_reqitem__c > updateReqItems = new List < g_reqitem__c > (); Set < String > rpNew = new Set < String > (gu.csStr('RP_New').split(';')); Set < String > rpReN = new Set < String > (gu.csStr('RP_Renewal').split(';')); Set < String > rpCan = new Set < String > (gu.csStr('RP_Cancel').split(';')); for (ws_call__c wc: lstwsCall) { Boolean noDup = false; String inputJson; g_reqitem__c reqItem = new g_reqitem__c(); reqItem = GDRFAUtil.reqItem(wc.rq_itm__c); date dt1 = date.newInstance(2021, 7, 4); if(reqItem.RQ__r.xfpdd__c < dt1) inputJson = String.isBlank(wc.rq_jsn__c) ? GDRFAUtil.oldRequestBody(reqItem, gApiToken, getLookupIdByTypeNname) : wc.rq_jsn__c; else inputJson = String.isBlank(wc.rq_jsn__c) ? GDRFAUtil.requestBody(reqItem, gApiToken, getLookupIdByTypeNname) : wc.rq_jsn__c; System.debug('input json:>>>>> ' + inputJson); inputJson1 = inputJson; String appLookupId; if (reqItem.itm__r.cd__c == 'ep') appLookupId = gU.csStr('GDRFAEntryPermitID'); else if (reqItem.itm__r.cd__c == 'la') appLookupId = gU.csStr('GDRFALAID'); /* RP PROCESSING*/ else if (reqItem.itm__r.cd__c == 'rp' && rpNew.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFAResidenceID'); else if (reqItem.itm__r.cd__c == 'rp' && rpReN.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFARenewResidenceID'); else if ((reqItem.itm__r.cd__c == 'ins' || reqItem.itm__r.cd__c == 'oua' || reqItem.itm__r.cd__c == 'oup') && rpCan.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFACancelResidenceID'); /* end */ String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/create/' + appLookupId; /*4b63e868-2380-413d-b6ef-701034701789';//qmg:4b63e868-2380-413d-b6ef-701034701789;//stg:0ba4577c-b865-4a22-bc70-3a0bba7c11c3*/ HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken); system.debug('res: ' + res.getBody()); if (res.getStatusCode() == 200) { ImmigrationResponseWrapper irw = ImmigrationResponseWrapper.parse(res.getBody()); System.debug('response:>>>>> ' + irw); List < ImmigrationResponseWrapper.cls_Documents > docsToUpload = irw.Documents; Decimal sla = reqItem.exp__c ? reqItem.islax__c : reqItem.islan__c; for (ImmigrationResponseWrapper.cls_Documents docToUpload: docsToUpload) { String docIdToUpload = ''; if (docToUpload.IsMandatory) { if (docToUpload.documentNameEn.contains('Sponsored Passport page 1')) /* page 2  to last page always*/ docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - first page'; else if (docToUpload.documentNameEn.contains('Health Insurance card Page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Health insurance card or certificate'; } else if (docToUpload.documentNameEn.contains('Medical Test page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Medical Certificate Document'; } else if (docToUpload.documentNameEn.contains('Entry permit visa')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Entry Permit Copy'; } else if (docToUpload.documentNameEn.contains('New Entry Permit Visa')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Entry Permit Copy'; } else if (docToUpload.documentNameEn.contains('Old Entry Permit Visa/ Cancelled residency')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Existing residence visa page'; } else if (docToUpload.documentNameEn.contains('Proof of Applicant Residency')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Visa Copy'; } else if (docToUpload.documentNameEn.contains('EIDA Card Application Document')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'EIDA application form'; } else { docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn; } wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, ismdt__c = true, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (!docToUpload.IsMandatory) { if (docToUpload.documentNameEn.contains('Sponsored Passport page 2')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - last page'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 1') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:0'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 2') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:1'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 3') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:2'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 4') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:3'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 5') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:4'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 6') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Valid nationality identity card - front'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 7') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Valid nationality identity card - back'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 8') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Health insurance card or certificate'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else { docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } } } if (String.isNotBlank(irw.applicationId) && !noDup) { wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'submitPayment', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(reqItem.RQ__r.expflg__c ? reqItem.sta__r.slaXP__c : reqItem.sta__r.slaN__c), rq_jsn__c = '{"applicationId": "' + irw.applicationId + '"}')); updateReqItems.add(new g_reqitem__c(Id = reqItem.Id, xf__c = irw.applicationId, xfid__c = System.today(), xfed__c = System.today().addMonths(3))); noDup = true; } for (ws_call__c ws: lstwsCall) { if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson; ws.intsts__c = 'Success'; ImmigrationResponseWrapper irw1 = ImmigrationResponseWrapper.parse(res.getBody()); for (ImmigrationResponseWrapper.cls_Documents doc: irw1.Documents) { doc.document = ''; } String resJsonStr = Json.serialize(irw1); ws.res_jsn__c = resJsonStr; wsToUpdate.add(ws); } } else { for (ws_call__c ws: lstwsCall) { if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson; ws.intsts__c = 'Failed'; ws.err_msg__c = res.getBody(); wsToUpdate.add(ws); } } } if (!wsCallsToInsert.isEmpty()) insert wsCallsToInsert; if (!wsToUpdate.isEmpty()) update wsToUpdate; if (!updateReqItems.isEmpty()) update updateReqItems; } catch (Exception e) { System.debug('--line no-- ' + e.getStackTraceString()); wsToUpdate = new List < ws_call__c > (); for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Failed'; ws.rq_jsn__c = inputJson1; ws.err_msg__c = e.getStackTraceString(); wsToUpdate.add(ws); } if (!wsToUpdate.isEmpty()) update wsToUpdate; } }
    //to be
    //global void invokeCreateApplicationService(List < sObject > scope, String gApiToken) { List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope; List < ws_call__c > wsToUpdate = new List < ws_call__c > (); String inputJson1; try { List < ws_call__c > wsCallsToInsert = new List < ws_call__c > (); List < g_reqitem__c > updateReqItems = new List < g_reqitem__c > (); List < g_Req__c > updateReq = new List < g_Req__c > (); Set < String > rpNew = new Set < String > (gu.csStr('RP_New').split(';')); Set < String > rpReN = new Set < String > (gu.csStr('RP_Renewal').split(';')); Set < String > rpCan = new Set < String > (gu.csStr('RP_Cancel').split(';')); Set < String > ecNew = new Set < String > (gu.csStr('EC_New').split(';')); Set < String > ecReN = new Set < String > (gu.csStr('EC_Renewal').split(';')); Set < String > skpDocs = new Set < String > (gu.csStr('GDRFA_SkpDocs').split(';')); Set < String > ppLstNt = new Set < String > (gu.csStr('GDRFA_PPLstNt').split(';')); for (ws_call__c wc: lstwsCall) { Boolean noDup = false; String inputJson; g_reqitem__c reqItem = new g_reqitem__c(); reqItem = GDRFAUtil.reqItem(wc.rq_itm__c); date dt1 = date.newInstance(2021, 7, 4); if (reqItem.RQ__r.xfpdd__c < dt1) inputJson = String.isBlank(wc.rq_jsn__c) ? GDRFAUtil.oldRequestBody(reqItem, gApiToken, getLookupIdByTypeNname) : wc.rq_jsn__c; else inputJson = String.isBlank(wc.rq_jsn__c) ? GDRFAUtil.requestBody(reqItem, gApiToken, getLookupIdByTypeNname) : wc.rq_jsn__c; System.debug('input json:>>>>> ' + inputJson); inputJson1 = inputJson; String appLookupId; if (reqItem.itm__r.cd__c == 'ep') appLookupId = gU.csStr('GDRFAEntryPermitID'); else if (reqItem.itm__r.cd__c == 'la') appLookupId = gU.csStr('GDRFALAID'); /* RP PROCESSING*/ else if (reqItem.itm__r.cd__c == 'rp' && rpNew.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFAResidenceID'); else if (reqItem.itm__r.cd__c == 'rp' && rpReN.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFARenewResidenceID'); else if ((reqItem.itm__r.cd__c == 'ins' || reqItem.itm__r.cd__c == 'oua' || reqItem.itm__r.cd__c == 'oup') && rpCan.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFACancelResidenceID'); /* end */ String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/create/' + appLookupId; /*4b63e868-2380-413d-b6ef-701034701789';//qmg:4b63e868-2380-413d-b6ef-701034701789;//stg:0ba4577c-b865-4a22-bc70-3a0bba7c11c3*/ if (reqItem.itm__r.cd__c == 'ec') endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/establishment/new'; else if (reqItem.itm__r.cd__c == 'er') endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/establishment/renew'; HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken); system.debug('res: ' + res.getBody()); if (res.getStatusCode() == 200) { ImmigrationResponseWrapper irw = ImmigrationResponseWrapper.parse(res.getBody()); System.debug('response:>>>>> ' + irw); List < ImmigrationResponseWrapper.cls_Documents > docsToUpload = irw.Documents; Decimal sla = reqItem.exp__c ? reqItem.islax__c : reqItem.islan__c; if (docsToUpload != null && docsToUpload.size() > 0) { for (ImmigrationResponseWrapper.cls_Documents docToUpload: docsToUpload) { String docIdToUpload = ''; if (docToUpload.IsMandatory) { if (docToUpload.documentNameEn.contains('Sponsored Passport page 1')) /* page 2  to last page always*/ docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - first page'; else if (docToUpload.documentNameEn.contains('Sponsored Passport page 2')) { if (ppLstNt.contains(reqItem.RQ__r.xcnc__c)) docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - last page'; else docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - first page'; } else if (docToUpload.documentNameEn.contains('Health Insurance card Page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Health insurance card or certificate'; } else if (docToUpload.documentNameEn.contains('Medical Test page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Medical Certificate Document'; } else if (docToUpload.documentNameEn.contains('Entry permit visa')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Entry Permit Copy'; } else if (docToUpload.documentNameEn.contains('New Entry Permit Visa')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Entry Permit Copy'; } else if (docToUpload.documentNameEn.contains('Old Entry Permit Visa/ Cancelled residency')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Existing residence visa page'; } else if (docToUpload.documentNameEn.contains('Proof of Applicant Residency')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Visa Copy'; } else if (docToUpload.documentNameEn.contains('EIDA Card Application Document')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'EIDA application form'; } else if (docToUpload.documentNameEn.contains('Study letter Page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Student Undertaking Letter'; } else { docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn; } wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, ismdt__c = true, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (!docToUpload.IsMandatory && !skpDocs.contains(reqItem.RQ__r.Srvc__r.uid__c)) { if (docToUpload.documentNameEn.contains('Sponsored Passport page 2')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - last page'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 1') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:0'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 2') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:1'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 3') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:2'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 4') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:3'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 5') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:4'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 6') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Valid nationality identity card - front'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 7') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Valid nationality identity card - back'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 8') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Health insurance card or certificate'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else { docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } } } } if (String.isNotBlank(irw.applicationId) && !noDup) { wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'submitPayment', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(reqItem.RQ__r.expflg__c ? reqItem.sta__r.slaXP__c : reqItem.sta__r.slaN__c), rq_jsn__c = '{"applicationId": "' + irw.applicationId + '"}')); updateReqItems.add(new g_reqitem__c(Id = reqItem.Id, xf__c = irw.applicationId, xfid__c = System.today(), xfed__c = System.today().addMonths(3))); if (reqItem.itm__r.cd__c == 'rp' && rpReN.contains(reqItem.RQ__r.Srvc__r.uid__c) && String.isBlank(reqItem.RQ__r.xcln__c)) { List < String > fnCnlst = (Label.countriesFirstName).split(';'); if (fnCnlst != null && fnCnlst.contains(reqItem.RQ__r.xcnc__c) && String.isBlank(reqItem.RQ__r.xcln__c) && String.isBlank(reqItem.RQ__r.xcmn__c) && String.isNotBlank(reqItem.RQ__r.xcfn__c)) { updateReq.add(new g_Req__c(id = reqItem.RQ__c, xcfn__c = (reqItem.RQ__r.xcfn__c).substringBefore(' '), xcln__c = (reqItem.RQ__r.xcfn__c).substringAfter(' '))); } } noDup = true; } for (ws_call__c ws: lstwsCall) { if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson; ws.intsts__c = 'Success'; ImmigrationResponseWrapper irw1 = ImmigrationResponseWrapper.parse(res.getBody()); if (irw1.Documents != null && irw1.Documents.size() > 0) { for (ImmigrationResponseWrapper.cls_Documents doc: irw1.Documents) { doc.document = ''; } } String resJsonStr = Json.serialize(irw1); ws.res_jsn__c = resJsonStr; wsToUpdate.add(ws); } } else { for (ws_call__c ws: lstwsCall) { if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson; ws.intsts__c = 'Failed'; ws.err_msg__c = res.getBody(); wsToUpdate.add(ws); } } } if (!wsCallsToInsert.isEmpty()) insert wsCallsToInsert; if (!wsToUpdate.isEmpty()) update wsToUpdate; if (!updateReqItems.isEmpty()) update updateReqItems; if (!updateReq.isEmpty()) update updateReq; } catch (Exception e) { System.debug('--line no-- ' + e.getStackTraceString()); wsToUpdate = new List < ws_call__c > (); for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Failed'; ws.rq_jsn__c = inputJson1; ws.err_msg__c = e.getStackTraceString(); wsToUpdate.add(ws); } if (!wsToUpdate.isEmpty()) update wsToUpdate; } }

    global void invokeCreateApplicationService(List < sObject > scope, String gApiToken) {
        List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope;
        List < ws_call__c > wsToUpdate = new List < ws_call__c > ();
        String inputJson1;
        try {
            List < ws_call__c > wsCallsToInsert = new List < ws_call__c > ();
            List < g_reqitem__c > updateReqItems = new List < g_reqitem__c > ();
            List < g_Req__c > updateReq = new List < g_Req__c > ();
            Set < String > rpNew = new Set < String > (gu.csStr('RP_New').split(';'));
            Set < String > epStu = new Set < String > (gu.csStr('EP_STU').split(';'));
            Set < String > rpReN = new Set < String > (gu.csStr('RP_Renewal').split(';'));
            Set < String > rpCan = new Set < String > (gu.csStr('RP_Cancel').split(';'));
            Set < String > ecNew = new Set < String > (gu.csStr('EC_New').split(';'));
            Set < String > ecReN = new Set < String > (gu.csStr('EC_Renewal').split(';'));
            Set < String > skpDocs = new Set < String > (gu.csStr('GDRFA_SkpDocs').split(';'));
            Set < String > ppLstNt = new Set < String > (gu.csStr('GDRFA_PPLstNt').split(';'));
            for (ws_call__c wc: lstwsCall) {
                Boolean noDup = false;
                String inputJson;
                g_reqitem__c reqItem = new g_reqitem__c();
                reqItem = GDRFAUtil.reqItem(wc.rq_itm__c);
                date dt1 = date.newInstance(2021, 7, 4);
                if (reqItem.RQ__r.xfpdd__c < dt1) inputJson = String.isBlank(wc.rq_jsn__c) ? GDRFAUtil.oldRequestBody(reqItem, gApiToken, getLookupIdByTypeNname) : wc.rq_jsn__c;
                else inputJson = String.isBlank(wc.rq_jsn__c) ? GDRFAUtil.requestBody(reqItem, gApiToken, getLookupIdByTypeNname) : wc.rq_jsn__c;
                System.debug('input json:>>>>> ' + inputJson);
                inputJson1 = inputJson;
                String appLookupId;
                if (reqItem.itm__r.cd__c == 'ep' && epStu.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFASTUEntryPermitID');
                else if (reqItem.itm__r.cd__c == 'ep') appLookupId = gU.csStr('GDRFAEntryPermitID');
                else if (reqItem.itm__r.cd__c == 'la') appLookupId = gU.csStr('GDRFALAID'); /* RP PROCESSING*/
                else if (reqItem.itm__r.cd__c == 'rp' && rpNew.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFAResidenceID');
                else if (reqItem.itm__r.cd__c == 'rp' && rpReN.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFARenewResidenceID');
                else if ((reqItem.itm__r.cd__c == 'ins' || reqItem.itm__r.cd__c == 'oua' || reqItem.itm__r.cd__c == 'oup') && rpCan.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFACancelResidenceID'); /* end */
                String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/create/' + appLookupId; /*4b63e868-2380-413d-b6ef-701034701789';//qmg:4b63e868-2380-413d-b6ef-701034701789;//stg:0ba4577c-b865-4a22-bc70-3a0bba7c11c3*/
                if (reqItem.itm__r.cd__c == 'ec') endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/establishment/new';
                else if (reqItem.itm__r.cd__c == 'er') endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/establishment/renew';
                HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken);
                system.debug('res: ' + res.getBody());
                if (res.getStatusCode() == 200) {
                    ImmigrationResponseWrapper irw = ImmigrationResponseWrapper.parse(res.getBody());
                    System.debug('response:>>>>> ' + irw);
                    List < ImmigrationResponseWrapper.cls_Documents > docsToUpload = irw.Documents;
                    Decimal sla = reqItem.exp__c ? reqItem.islax__c : reqItem.islan__c;
                    if (docsToUpload != null && docsToUpload.size() > 0) {
                        for (ImmigrationResponseWrapper.cls_Documents docToUpload: docsToUpload) {
                            String docIdToUpload = '';
                            if (docToUpload.IsMandatory) {
                                if (docToUpload.documentNameEn.contains('Sponsored Passport page 1')) /* page 2  to last page always*/ docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - first page';
                                else if (docToUpload.documentNameEn.contains('Sponsored Passport page 2')) {
                                    if (ppLstNt.contains(reqItem.RQ__r.xcnc__c)) docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - last page';
                                    else docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - first page';
                                } else if (docToUpload.documentNameEn.contains('Health Insurance card Page 1')) {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Health insurance card or certificate';
                                } else if (docToUpload.documentNameEn.contains('Medical Test page 1')) {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Medical Certificate Document';
                                } else if (docToUpload.documentNameEn.contains('Entry permit visa')) {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Entry Permit Copy';
                                } else if (docToUpload.documentNameEn.contains('New Entry Permit Visa')) {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Entry Permit Copy';
                                } else if (docToUpload.documentNameEn.contains('Old Entry Permit Visa/ Cancelled residency')) {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Existing residence visa page';
                                } else if (docToUpload.documentNameEn.contains('Proof of Applicant Residency')) {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Visa Copy';
                                } else if (docToUpload.documentNameEn.contains('EIDA Card Application Document')) {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'EIDA application form';
                                } else if (docToUpload.documentNameEn.contains('Study letter Page 1')) {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Student Undertaking Letter';
                                } else if (docToUpload.documentNameEn.contains('Degree certificate')) {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:0';
                                } else {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn;
                                }
                                wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, ismdt__c = true, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload));
                            } else if (!docToUpload.IsMandatory && !skpDocs.contains(reqItem.RQ__r.Srvc__r.uid__c)) {
                                if (docToUpload.documentNameEn.contains('Sponsored Passport page 2')) {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - last page';
                                    wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload));
                                } else if (docToUpload.documentNameEn == 'Others Page 1') {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:0';
                                    wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload));
                                } else if (docToUpload.documentNameEn == 'Others Page 2') {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:1';
                                    wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload));
                                } else if (docToUpload.documentNameEn == 'Others Page 3') {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:2';
                                    wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload));
                                } else if (docToUpload.documentNameEn == 'Others Page 4') {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:3';
                                    wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload));
                                } else if (docToUpload.documentNameEn == 'Others Page 5') {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:4';
                                    wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload));
                                } else if (docToUpload.documentNameEn == 'Others Page 6') {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Valid nationality identity card - front';
                                    wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload));
                                } else if (docToUpload.documentNameEn == 'Others Page 7') {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Valid nationality identity card - back';
                                    wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload));
                                } else if (docToUpload.documentNameEn == 'Others Page 8') {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + 'Health insurance card or certificate';
                                    wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload));
                                } else {
                                    docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn;
                                    wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload));
                                }
                            }
                        }
                    }
                    if (String.isNotBlank(irw.applicationId) && !noDup) {
                        wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'submitPayment', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(reqItem.RQ__r.expflg__c ? reqItem.sta__r.slaXP__c : reqItem.sta__r.slaN__c), rq_jsn__c = '{"applicationId": "' + irw.applicationId + '"}'));
                        updateReqItems.add(new g_reqitem__c(Id = reqItem.Id, xf__c = irw.applicationId, xfid__c = System.today(), xfed__c = System.today().addMonths(3)));
                        if (reqItem.itm__r.cd__c == 'rp' && rpReN.contains(reqItem.RQ__r.Srvc__r.uid__c) && String.isBlank(reqItem.RQ__r.xcln__c)) {
                            List < String > fnCnlst = (Label.countriesFirstName).split(';');
                            if (fnCnlst != null && fnCnlst.contains(reqItem.RQ__r.xcnc__c) && String.isBlank(reqItem.RQ__r.xcln__c) && String.isBlank(reqItem.RQ__r.xcmn__c) && String.isNotBlank(reqItem.RQ__r.xcfn__c)) {
                                updateReq.add(new g_Req__c(id = reqItem.RQ__c, xcfn__c = (reqItem.RQ__r.xcfn__c).substringBefore(' '), xcln__c = (reqItem.RQ__r.xcfn__c).substringAfter(' ')));
                            }
                        }
                        noDup = true;
                    }
                    for (ws_call__c ws: lstwsCall) {
                        if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson;
                        ws.intsts__c = 'Success';
                        ImmigrationResponseWrapper irw1 = ImmigrationResponseWrapper.parse(res.getBody());
                        if (irw1.Documents != null && irw1.Documents.size() > 0) {
                            for (ImmigrationResponseWrapper.cls_Documents doc: irw1.Documents) {
                                doc.document = '';
                            }
                        }
                        String resJsonStr = Json.serialize(irw1);
                        ws.res_jsn__c = resJsonStr;
                        wsToUpdate.add(ws);
                    }
                } else {
                    for (ws_call__c ws: lstwsCall) {
                        if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson;
                        ws.intsts__c = 'Failed';
                        ws.err_msg__c = res.getBody();
                        wsToUpdate.add(ws);
                    }
                }
            }
            if (!wsCallsToInsert.isEmpty()) insert wsCallsToInsert;
            if (!wsToUpdate.isEmpty()) update wsToUpdate;
            if (!updateReqItems.isEmpty()) update updateReqItems;
            if (!updateReq.isEmpty()) update updateReq;
        } catch (Exception e) {
            System.debug('--line no-- ' + e.getStackTraceString());
            wsToUpdate = new List < ws_call__c > ();
            for (ws_call__c ws: lstwsCall) {
                ws.intsts__c = 'Failed';
                ws.rq_jsn__c = inputJson1;
                ws.err_msg__c = e.getStackTraceString();
                wsToUpdate.add(ws);
            }
            if (!wsToUpdate.isEmpty()) update wsToUpdate;
        }
    } //global void invokeCreateApplicationService(List < sObject > scope, String gApiToken) { List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope; List < ws_call__c > wsToUpdate = new List < ws_call__c > (); String inputJson1; try { List < ws_call__c > wsCallsToInsert = new List < ws_call__c > (); List < g_reqitem__c > updateReqItems = new List < g_reqitem__c > (); List < g_Req__c > updateReq = new List < g_Req__c > (); Set < String > rpNew = new Set < String > (gu.csStr('RP_New').split(';')); Set < String > rpReN = new Set < String > (gu.csStr('RP_Renewal').split(';')); Set < String > rpCan = new Set < String > (gu.csStr('RP_Cancel').split(';')); Set < String > ecNew = new Set < String > (gu.csStr('EC_New').split(';')); Set < String > ecReN = new Set < String > (gu.csStr('EC_Renewal').split(';')); Set < String > skpDocs = new Set < String > (gu.csStr('GDRFA_SkpDocs').split(';')); Set < String > ppLstNt = new Set < String > (gu.csStr('GDRFA_PPLstNt').split(';')); for (ws_call__c wc: lstwsCall) { Boolean noDup = false; String inputJson; g_reqitem__c reqItem = new g_reqitem__c(); reqItem = GDRFAUtil.reqItem(wc.rq_itm__c); date dt1 = date.newInstance(2021, 7, 4); if (reqItem.RQ__r.xfpdd__c < dt1) inputJson = String.isBlank(wc.rq_jsn__c) ? GDRFAUtil.oldRequestBody(reqItem, gApiToken, getLookupIdByTypeNname) : wc.rq_jsn__c; else inputJson = String.isBlank(wc.rq_jsn__c) ? GDRFAUtil.requestBody(reqItem, gApiToken, getLookupIdByTypeNname) : wc.rq_jsn__c; System.debug('input json:>>>>> ' + inputJson); inputJson1 = inputJson; String appLookupId; if (reqItem.itm__r.cd__c == 'ep') appLookupId = gU.csStr('GDRFAEntryPermitID'); else if (reqItem.itm__r.cd__c == 'la') appLookupId = gU.csStr('GDRFALAID'); /* RP PROCESSING*/ else if (reqItem.itm__r.cd__c == 'rp' && rpNew.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFAResidenceID'); else if (reqItem.itm__r.cd__c == 'rp' && rpReN.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFARenewResidenceID'); else if ((reqItem.itm__r.cd__c == 'ins' || reqItem.itm__r.cd__c == 'oua' || reqItem.itm__r.cd__c == 'oup') && rpCan.contains(reqItem.RQ__r.Srvc__r.uid__c)) appLookupId = gU.csStr('GDRFACancelResidenceID'); /* end */ String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/create/' + appLookupId; /*4b63e868-2380-413d-b6ef-701034701789';//qmg:4b63e868-2380-413d-b6ef-701034701789;//stg:0ba4577c-b865-4a22-bc70-3a0bba7c11c3*/ if (reqItem.itm__r.cd__c == 'ec') endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/establishment/new'; else if (reqItem.itm__r.cd__c == 'er') endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/establishment/renew'; HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken); system.debug('res: ' + res.getBody()); if (res.getStatusCode() == 200) { ImmigrationResponseWrapper irw = ImmigrationResponseWrapper.parse(res.getBody()); System.debug('response:>>>>> ' + irw); List < ImmigrationResponseWrapper.cls_Documents > docsToUpload = irw.Documents; Decimal sla = reqItem.exp__c ? reqItem.islax__c : reqItem.islan__c; if (docsToUpload != null && docsToUpload.size() > 0) { for (ImmigrationResponseWrapper.cls_Documents docToUpload: docsToUpload) { String docIdToUpload = ''; if (docToUpload.IsMandatory) { if (docToUpload.documentNameEn.contains('Sponsored Passport page 1')) /* page 2  to last page always*/ docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - first page'; else if (docToUpload.documentNameEn.contains('Sponsored Passport page 2')) { if (ppLstNt.contains(reqItem.RQ__r.xcnc__c)) docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - last page'; else docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - first page'; } else if (docToUpload.documentNameEn.contains('Health Insurance card Page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Health insurance card or certificate'; } else if (docToUpload.documentNameEn.contains('Medical Test page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Medical Certificate Document'; } else if (docToUpload.documentNameEn.contains('Entry permit visa')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Entry Permit Copy'; } else if (docToUpload.documentNameEn.contains('New Entry Permit Visa')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Entry Permit Copy'; } else if (docToUpload.documentNameEn.contains('Old Entry Permit Visa/ Cancelled residency')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Existing residence visa page'; } else if (docToUpload.documentNameEn.contains('Proof of Applicant Residency')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Visa Copy'; } else if (docToUpload.documentNameEn.contains('EIDA Card Application Document')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'EIDA application form'; } else if (docToUpload.documentNameEn.contains('Study letter Page 1')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Student Undertaking Letter'; } else { docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn; } wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, ismdt__c = true, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (!docToUpload.IsMandatory && !skpDocs.contains(reqItem.RQ__r.Srvc__r.uid__c)) { if (docToUpload.documentNameEn.contains('Sponsored Passport page 2')) { docIdToUpload = docToUpload.documentTypeId + '__' + 'Passport - last page'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 1') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:0'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 2') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:1'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 3') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:2'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 4') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:3'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 5') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Attested Degree Certificate:4'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 6') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Valid nationality identity card - front'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 7') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Valid nationality identity card - back'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else if (docToUpload.documentNameEn == 'Others Page 8') { docIdToUpload = docToUpload.documentTypeId + '__' + 'Health insurance card or certificate'; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } else { docIdToUpload = docToUpload.documentTypeId + '__' + docToUpload.documentNameEn; wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'uploadSingleDocument', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(sla), rq_jsn__c = docIdToUpload)); } } } } if (String.isNotBlank(irw.applicationId) && !noDup) { wsCallsToInsert.add(new ws_call__c(rq_itm__c = reqItem.Id, mtd_nm__c = 'submitPayment', ws_typ__c = 'Immigration EVEP', intsts__c = 'Ready for Integration', sdt__c = GDRFAUtil.noOfWorkingDays(reqItem.RQ__r.expflg__c ? reqItem.sta__r.slaXP__c : reqItem.sta__r.slaN__c), rq_jsn__c = '{"applicationId": "' + irw.applicationId + '"}')); updateReqItems.add(new g_reqitem__c(Id = reqItem.Id, xf__c = irw.applicationId, xfid__c = System.today(), xfed__c = System.today().addMonths(3))); if (reqItem.itm__r.cd__c == 'rp' && rpReN.contains(reqItem.RQ__r.Srvc__r.uid__c) && String.isBlank(reqItem.RQ__r.xcln__c)) { List < String > fnCnlst = (Label.countriesFirstName).split(';'); if (fnCnlst != null && fnCnlst.contains(reqItem.RQ__r.xcnc__c) && String.isBlank(reqItem.RQ__r.xcln__c) && String.isBlank(reqItem.RQ__r.xcmn__c) && String.isNotBlank(reqItem.RQ__r.xcfn__c)) { updateReq.add(new g_Req__c(id = reqItem.RQ__c, xcfn__c = (reqItem.RQ__r.xcfn__c).substringBefore(' '), xcln__c = (reqItem.RQ__r.xcfn__c).substringAfter(' '))); } } noDup = true; } for (ws_call__c ws: lstwsCall) { if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson; ws.intsts__c = 'Success'; ImmigrationResponseWrapper irw1 = ImmigrationResponseWrapper.parse(res.getBody()); if (irw1.Documents != null && irw1.Documents.size() > 0) { for (ImmigrationResponseWrapper.cls_Documents doc: irw1.Documents) { doc.document = ''; } } String resJsonStr = Json.serialize(irw1); ws.res_jsn__c = resJsonStr; wsToUpdate.add(ws); } } else { for (ws_call__c ws: lstwsCall) { if (String.isBlank(ws.rq_jsn__c)) ws.rq_jsn__c = inputJson; ws.intsts__c = 'Failed'; ws.err_msg__c = res.getBody(); wsToUpdate.add(ws); } } } if (!wsCallsToInsert.isEmpty()) insert wsCallsToInsert; if (!wsToUpdate.isEmpty()) update wsToUpdate; if (!updateReqItems.isEmpty()) update updateReqItems; if (!updateReq.isEmpty()) update updateReq; } catch (Exception e) { System.debug('--line no-- ' + e.getStackTraceString()); wsToUpdate = new List < ws_call__c > (); for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Failed'; ws.rq_jsn__c = inputJson1; ws.err_msg__c = e.getStackTraceString(); wsToUpdate.add(ws); } if (!wsToUpdate.isEmpty()) update wsToUpdate; } }
    global static List < Attachment > reqItemDocToUpload(String reqId, String docName, String srvCd) {
        system.debug('reqItemId-' + reqId);
        system.debug('docName-' + docName);
        String reqDocId;
        Set < id > riDocLst = new Set < Id > ();
        List < Attachment > attachments;
        Set < String > rpCan = new Set < String > (gu.csStr('RP_Cancel').split(';'));
        Set < String > ecNew = new Set < String > (gu.csStr('EC_New').split(';'));
        Set < String > ecReN = new Set < String > (gu.csStr('EC_Renewal').split(';'));
        Set < String > ecdocs = new Set < String > (gu.csStr('GDRFA_EstDocs').split(';'));
        try {
            if ((ecNew.contains(srvCd) || ecReN.contains(srvCd)) && ecdocs.contains(docName)) {
                List < g_req__c > rqLst = [select id, Acc__r.lc__c from g_req__c where id =: reqId];
                if (rqLst != null && !rqLst.isEmpty()) {
                    /* String jsonResp = grqWsDccaGetService.getLicenseCopy(rqLst[0].Acc__r.lc__c); Map < String, Object > metadata_Map = (Map < String, Object > ) JSON.deserializeUntyped(jsonResp); String licCopyBase64 = (String) metadata_Map.get('body'); */
                    String licCopyBase64 = grqWsDccaGetService.generateDDADoc(rqLst[0].Acc__r.lc__c, 'Commercial License');
                    if (String.isNotBlank(licCopyBase64)) {
                        HttpRequest req = New HttpRequest();
                        req.setHeader('Content-Type', 'application/json');
                        req.setHeader('Content-Disposition', 'Content-Disposition: form-data; name="DocumentTitle"');
                        req.setHeader('Apikey', Label.GDRFAConvertAPIKey);
                        String endpointUrl = 'https://v2.convertapi.com/convert/pdf/to/jpg?Secret=' + Label.GDRFAConvertAPISecret;
                        req.setTimeout(90000);
                        req.setMethod('POST');
                        req.setEndpoint(endpointUrl);
                        req.setBody('{"Parameters":[{"Name":"File","FileValue":{"Name":"licencecopy.pdf","Data":"' + licCopyBase64 + '"}},{"Name":"StoreFile","Value":false}]}');
                        Http http = new Http();
                        HTTPResponse res = http.send(req);
                        if (res.getStatusCode() == 200) {
                            Map < String, Object > jmetadata_Map = (Map < String, Object > ) JSON.deserializeUntyped(res.getBody());
                            List < Object > recordList = (List < Object > ) jmetadata_Map.get('Files');
                            Map < String, Object > licobj = (Map < String, Object > ) recordList[0];
                            system.debug(licObj.get('FileName'));
                            licCopyBase64 = (String) licObj.get('FileData');
                        }
                    }
                    attachments = new List < Attachment > ();
                    if (String.isNotBlank(licCopyBase64)) attachments.add(new Attachment(name = docName + '.jpg', Body = EncodingUtil.base64Decode(licCopyBase64), ContentType = ''));
                }
            } else if (docName.contains('Health Insurance Doc') || docName.contains('Health insurance card or certificate')) {
                List < g_reqitem__c > rilst = [select id, RQ__r.Con__r.xpdl__c from g_reqitem__c where RQ__c =: reqId and itm__r.cd__c = 'inr'
                    and sta__r.cd__c = 'ok'
                ];
                if (rilst != null && !rilst.isEmpty()) {
                    Blob doc = GDRFAUtil.policyDoc(rilst[0].RQ__r.Con__r.xpdl__c);
                    if (doc != null) {
                        attachments = new List < Attachment > ();
                        attachments.add(new Attachment(name = 'Health insurance card or certificate.pdf', Body = doc, ContentType = ''));
                    }
                } else {
                    for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Health Insurance Doc'
                            or Name = 'Health insurance card or certificate')]) {
                        riDocLst.add(ridoc.reqDoc__c);
                    }
                    attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst AND(Name = 'Health Insurance Doc.jpg'
                        OR Name = 'Health insurance card or certificate.jpg') ORDER BY CreatedDate DESC LIMIT 1];
                }
            } else if (docName.contains('Education Certificate(Attested)') || docName.contains('Attested Degree Certificate')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Education Certificate(Attested)'
                    or Name = 'Attested Degree Certificate'
                    or Name = 'Attested Degree Certificate:0') ORDER BY CreatedDate DESC LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 5];
            } else if (docName.contains('Passport First Page') || docName.contains('Passport - first page')) {
                for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Passport - first page'
                        or Name = 'Passport First Page'
                        or Name = 'Clear Passport Copy.'
                        or Name = 'Passport Copy - First Page')]) {
                    riDocLst.add(ridoc.reqDoc__c);
                }
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Passport Last Page') || docName.contains('Passport - last page')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Passport - last page'
                    or Name = 'Passport Last Page'
                    or Name = 'Passport Copy - Last/Second Page') LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Personal Photo') || docName.contains('Recent passport size photo')) {
                if (rpCan.contains(srvCd)) {
                    List < g_Req__c > rqLst = [select id, Con__r.Photo_ID__c from g_Req__c where id =: reqId];
                    if (rqLst != null && !rqLst.isEmpty() && String.isNotBlank(rqLst[0].Con__r.Photo_ID__c)) {
                        attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE Id =: rqLst[0].Con__r.Photo_ID__c];
                    }
                    if ((rqLst != null && !rqLst.isEmpty() && String.isBlank(rqLst[0].Con__r.Photo_ID__c)) || (attachments == null || attachments.isEmpty())) {
                        reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Passport Copy - Visa Page'
                            LIMIT 1
                        ].reqDoc__c;
                        attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
                    }
                } else {
                    for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Recent passport size photo'
                            or Name = 'Personal Photo'
                            or Name = 'Clear Passport size Color Photo.')]) {
                        riDocLst.add(ridoc.reqDoc__c);
                    }
                    attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst ORDER BY CreatedDate DESC LIMIT 1];
                }
            } else if (docName.contains('Visa Copy') && rpCan.contains(srvCd)) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Passport Copy - Visa Page'
                    LIMIT 1
                ].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Sponsored Passport page 3') && rpCan.contains(srvCd)) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Company undertaking letter'
                    LIMIT 1
                ].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Valid driving license Page 1') || docName.contains('Driving License Copy - Front Side')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid driving license Page 1'
                    or Name = 'Driving License Copy - Front Side') LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Car registration - Page 1') || docName.contains('Driving License Copy - Back Side')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Car registration - Page 1'
                    or Name = 'Driving License Copy - Back Side') LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('ID Card from nationality country') || docName.contains('Valid nationality identity card - front') || docName.contains('Current Nationality Identity Card (front side)')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid nationality identity card - front'
                    or Name = 'Current Nationality Identity Card (front side)'
                    or Name = 'ID Card from nationality country') LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Current Nationality Identity Card (back side)') || docName.contains('Valid nationality identity card - back')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid nationality identity card - back'
                    or Name = 'Current Nationality Identity Card (back side)') LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Salary Payment Completion letter') || docName.contains('Company undertaking letter')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Company undertaking letter'
                    or Name = 'Salary Payment Completion letter') LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('EIDA application form')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId and Name = 'EIDA application form.jpg'
                    ORDER BY CreatedDate DESC LIMIT 1
                ];
            } else {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            }
            if (attachments.size() > 0) return attachments;
            else return new List < Attachment > ();
        } catch (Exception e) {
            System.debug('--line no-- ' + e.getStackTraceString());
            return new List < Attachment > ();
        }
    }

    //  global static List < Attachment > reqItemDocToUpload(String reqId, String docName, String srvCd) { system.debug('reqItemId-' + reqId); system.debug('docName-' + docName); String reqDocId; Set < id > riDocLst = new Set < Id > (); List < Attachment > attachments; Set < String > rpCan = new Set < String > (gu.csStr('RP_Cancel').split(';')); Set < String > ecNew = new Set < String > (gu.csStr('EC_New').split(';')); Set < String > ecReN = new Set < String > (gu.csStr('EC_Renewal').split(';')); Set < String > ecdocs = new Set < String > (gu.csStr('GDRFA_EstDocs').split(';')); try { if ((ecNew.contains(srvCd) || ecReN.contains(srvCd)) && ecdocs.contains(docName)) { List < g_req__c > rqLst = [select id, Acc__r.lc__c from g_req__c where id =: reqId]; if (rqLst != null && !rqLst.isEmpty()) { /* String jsonResp = grqWsDccaGetService.getLicenseCopy(rqLst[0].Acc__r.lc__c); Map < String, Object > metadata_Map = (Map < String, Object > ) JSON.deserializeUntyped(jsonResp); String licCopyBase64 = (String) metadata_Map.get('body'); */ String licCopyBase64 = grqWsDccaGetService.generateDDADoc(rqLst[0].Acc__r.lc__c, 'Commercial License'); if (String.isNotBlank(licCopyBase64)) { HttpRequest req = New HttpRequest(); req.setHeader('Content-Type', 'application/json'); req.setHeader('Content-Disposition', 'Content-Disposition: form-data; name="DocumentTitle"'); req.setHeader('Apikey', Label.GDRFAConvertAPIKey); String endpointUrl = 'https://v2.convertapi.com/convert/pdf/to/jpg?Secret=' + Label.GDRFAConvertAPISecret; req.setTimeout(90000); req.setMethod('POST'); req.setEndpoint(endpointUrl); req.setBody('{"Parameters":[{"Name":"File","FileValue":{"Name":"licencecopy.pdf","Data":"' + licCopyBase64 + '"}},{"Name":"StoreFile","Value":false}]}'); Http http = new Http(); HTTPResponse res = http.send(req); if (res.getStatusCode() == 200) { Map < String, Object > jmetadata_Map = (Map < String, Object > ) JSON.deserializeUntyped(res.getBody()); List < Object > recordList = (List < Object > ) jmetadata_Map.get('Files'); Map < String, Object > licobj = (Map < String, Object > ) recordList[0]; system.debug(licObj.get('FileName')); licCopyBase64 = (String) licObj.get('FileData'); } } attachments = new List < Attachment > (); if (String.isNotBlank(licCopyBase64)) attachments.add(new Attachment(name = docName + '.jpg', Body = EncodingUtil.base64Decode(licCopyBase64), ContentType = '')); } } else if (docName.contains('Health Insurance Doc') || docName.contains('Health insurance card or certificate')) { List < g_reqitem__c > rilst = [select id, RQ__r.Con__r.xpdl__c from g_reqitem__c where RQ__c =: reqId and itm__r.cd__c = 'inr' and sta__r.cd__c = 'ok' ]; if (rilst != null && !rilst.isEmpty()) { Blob doc = GDRFAUtil.policyDoc(rilst[0].RQ__r.Con__r.xpdl__c); if (doc != null) { attachments = new List < Attachment > (); attachments.add(new Attachment(name = 'Health insurance card or certificate.pdf', Body = doc, ContentType = '')); } } else { for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Health Insurance Doc' or Name = 'Health insurance card or certificate')]) { riDocLst.add(ridoc.reqDoc__c); } attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst AND(Name = 'Health Insurance Doc.jpg' OR Name = 'Health insurance card or certificate.jpg') ORDER BY CreatedDate DESC LIMIT 1]; } } else if (docName.contains('Education Certificate(Attested)') || docName.contains('Attested Degree Certificate')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Education Certificate(Attested)' or Name = 'Attested Degree Certificate') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 5]; } else if (docName.contains('Passport First Page') || docName.contains('Passport - first page')) { for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Passport - first page' or Name = 'Passport First Page' or Name = 'Clear Passport Copy.' or Name = 'Passport Copy - First Page')]) { riDocLst.add(ridoc.reqDoc__c); } attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Passport Last Page') || docName.contains('Passport - last page')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Passport - last page' or Name = 'Passport Last Page' or Name = 'Passport Copy - Last/Second Page') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Personal Photo') || docName.contains('Recent passport size photo')) { if (rpCan.contains(srvCd)) { List < g_Req__c > rqLst = [select id, Con__r.Photo_ID__c from g_Req__c where id =: reqId]; if (rqLst != null && !rqLst.isEmpty() && String.isNotBlank(rqLst[0].Con__r.Photo_ID__c)) { attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE Id =: rqLst[0].Con__r.Photo_ID__c]; } if ((rqLst != null && !rqLst.isEmpty() && String.isBlank(rqLst[0].Con__r.Photo_ID__c)) || (attachments == null || attachments.isEmpty())) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Passport Copy - Visa Page' LIMIT 1 ].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } } else { for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Recent passport size photo' or Name = 'Personal Photo' or Name = 'Clear Passport size Color Photo.')]) { riDocLst.add(ridoc.reqDoc__c); } attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst ORDER BY CreatedDate DESC LIMIT 1]; } } else if (docName.contains('Visa Copy') && rpCan.contains(srvCd)) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Passport Copy - Visa Page' LIMIT 1 ].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Sponsored Passport page 3') && rpCan.contains(srvCd)) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Company undertaking letter' LIMIT 1 ].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Valid driving license Page 1') || docName.contains('Driving License Copy - Front Side')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid driving license Page 1' or Name = 'Driving License Copy - Front Side') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Car registration - Page 1') || docName.contains('Driving License Copy - Back Side')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Car registration - Page 1' or Name = 'Driving License Copy - Back Side') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('ID Card from nationality country') || docName.contains('Valid nationality identity card - front') || docName.contains('Current Nationality Identity Card (front side)')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid nationality identity card - front' or Name = 'Current Nationality Identity Card (front side)' or Name = 'ID Card from nationality country') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Current Nationality Identity Card (back side)') || docName.contains('Valid nationality identity card - back')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid nationality identity card - back' or Name = 'Current Nationality Identity Card (back side)') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('EIDA application form')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId and Name = 'EIDA application form.jpg' ORDER BY CreatedDate DESC LIMIT 1 ]; } else { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } if (attachments.size() > 0) return attachments; else return new List < Attachment > (); } catch (Exception e) { System.debug('--line no-- ' + e.getStackTraceString()); return new List < Attachment > (); } }

    //global static List < Attachment > reqItemDocToUpload(String reqId, String docName, String srvCd) { system.debug('reqItemId-' + reqId); system.debug('docName-' + docName); String reqDocId; Set < id > riDocLst = new Set < Id > (); List < Attachment > attachments; Set < String > rpCan = new Set < String > (gu.csStr('RP_Cancel').split(';')); Set < String > ecNew = new Set < String > (gu.csStr('EC_New').split(';')); Set < String > ecReN = new Set < String > (gu.csStr('EC_Renewal').split(';')); Set < String > ecdocs = new Set < String > (gu.csStr('GDRFA_EstDocs').split(';')); try { if ((ecNew.contains(srvCd) || ecReN.contains(srvCd)) && ecdocs.contains(docName)) { List<g_req__c> rqLst = [select id,Acc__r.lc__c from g_req__c where id=:reqId]; if(rqLst != null && !rqLst.isEmpty()){ String jsonResp = grqWsDccaGetService.getLicenseCopy(rqLst[0].Acc__r.lc__c); Map < String, Object > metadata_Map = (Map < String, Object > ) JSON.deserializeUntyped(jsonResp); String licCopyBase64 = (String) metadata_Map.get('body'); attachments = new List < Attachment > (); if(String.isNotBlank(licCopyBase64)) attachments.add(new Attachment(name = docName+'.pdf', Body = blob.valueOf(licCopyBase64), ContentType = '')); }  } else if (docName.contains('Health Insurance Doc') || docName.contains('Health insurance card or certificate')) { List < g_reqitem__c > rilst = [select id, RQ__r.Con__r.xpdl__c from g_reqitem__c where RQ__c =: reqId and itm__r.cd__c = 'inr' and sta__r.cd__c = 'ok' ]; if (rilst != null && !rilst.isEmpty()) { Blob doc = GDRFAUtil.policyDoc(rilst[0].RQ__r.Con__r.xpdl__c); if (doc != null) { attachments = new List < Attachment > (); attachments.add(new Attachment(name = 'Health insurance card or certificate.pdf', Body = doc, ContentType = '')); } } else { for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Health Insurance Doc' or Name = 'Health insurance card or certificate')]) { riDocLst.add(ridoc.reqDoc__c); } attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst AND(Name = 'Health Insurance Doc.jpg' OR Name = 'Health insurance card or certificate.jpg') ORDER BY CreatedDate DESC LIMIT 1]; } } else if (docName.contains('Education Certificate(Attested)') || docName.contains('Attested Degree Certificate')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Education Certificate(Attested)' or Name = 'Attested Degree Certificate') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 5]; } else if (docName.contains('Passport First Page') || docName.contains('Passport - first page')) { for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Passport - first page' or Name = 'Passport First Page' or Name = 'Clear Passport Copy.' or Name = 'Passport Copy - First Page')]) { riDocLst.add(ridoc.reqDoc__c); } attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Passport Last Page') || docName.contains('Passport - last page')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Passport - last page' or Name = 'Passport Last Page' or Name = 'Passport Copy - Last/Second Page') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Personal Photo') || docName.contains('Recent passport size photo')) { if (rpCan.contains(srvCd)) { List < g_Req__c > rqLst = [select id, Con__r.Photo_ID__c from g_Req__c where id =: reqId]; if (rqLst != null && !rqLst.isEmpty() && String.isNotBlank(rqLst[0].Con__r.Photo_ID__c)) { attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE Id =: rqLst[0].Con__r.Photo_ID__c]; } if ((rqLst != null && !rqLst.isEmpty() && String.isBlank(rqLst[0].Con__r.Photo_ID__c)) || (attachments == null || attachments.isEmpty())) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Passport Copy - Visa Page' LIMIT 1 ].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } } else { for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Recent passport size photo' or Name = 'Personal Photo' or Name = 'Clear Passport size Color Photo.')]) { riDocLst.add(ridoc.reqDoc__c); } attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst ORDER BY CreatedDate DESC LIMIT 1]; } } else if (docName.contains('Visa Copy') && rpCan.contains(srvCd)) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Passport Copy - Visa Page' LIMIT 1 ].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Sponsored Passport page 3') && rpCan.contains(srvCd)) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Company undertaking letter' LIMIT 1 ].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Valid driving license Page 1') || docName.contains('Driving License Copy - Front Side')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid driving license Page 1' or Name = 'Driving License Copy - Front Side') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Car registration - Page 1') || docName.contains('Driving License Copy - Back Side')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Car registration - Page 1' or Name = 'Driving License Copy - Back Side') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('ID Card from nationality country') || docName.contains('Valid nationality identity card - front') || docName.contains('Current Nationality Identity Card (front side)')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid nationality identity card - front' or Name = 'Current Nationality Identity Card (front side)' or Name = 'ID Card from nationality country') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Current Nationality Identity Card (back side)') || docName.contains('Valid nationality identity card - back')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid nationality identity card - back' or Name = 'Current Nationality Identity Card (back side)') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('EIDA application form')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId and Name = 'EIDA application form.jpg' ORDER BY CreatedDate DESC LIMIT 1 ]; } else { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } if (attachments.size() > 0) return attachments; else return new List < Attachment > (); } catch (Exception e) { System.debug('--line no-- ' + e.getStackTraceString()); return new List < Attachment > (); } }
    global static List < Attachment > reqItemDocToUploadAdh(String reqId, String docName, String srvCd) {
        system.debug('reqItemId-' + reqId);
        system.debug('docName-' + docName);
        String reqDocId;
        Set < id > riDocLst = new Set < Id > ();
        List < Attachment > attachments;
        Set < String > rpCan = new Set < String > (gu.csStr('RP_Cancel').split(';'));
        Set < String > ecNew = new Set < String > (gu.csStr('EC_New').split(';'));
        Set < String > ecReN = new Set < String > (gu.csStr('EC_Renewal').split(';'));
        Set < String > ecdocs = new Set < String > (gu.csStr('GDRFA_EstDocs').split(';'));
        try {
            if ((ecNew.contains(srvCd) || ecReN.contains(srvCd)) && ecdocs.contains(docName)) {
                List < g_req__c > rqLst = [select id, Acc__r.lc__c from g_req__c where id =: reqId];
                if (rqLst != null && !rqLst.isEmpty()) {
                    /* String jsonResp = grqWsDccaGetService.getLicenseCopy(rqLst[0].Acc__r.lc__c); Map < String, Object > metadata_Map = (Map < String, Object > ) JSON.deserializeUntyped(jsonResp); String licCopyBase64 = (String) metadata_Map.get('body'); */
                    String licCopyBase64 = grqWsDccaGetService.generateDDADoc(rqLst[0].Acc__r.lc__c, 'Commercial License');
                    if (String.isNotBlank(licCopyBase64)) {
                        HttpRequest req = New HttpRequest();
                        req.setHeader('Content-Type', 'application/json');
                        req.setHeader('Content-Disposition', 'Content-Disposition: form-data; name="DocumentTitle"');
                        req.setHeader('Apikey', Label.GDRFAConvertAPIKey);
                        String endpointUrl = 'https://v2.convertapi.com/convert/pdf/to/jpg?Secret=' + Label.GDRFAConvertAPISecret;
                        req.setTimeout(90000);
                        req.setMethod('POST');
                        req.setEndpoint(endpointUrl);
                        req.setBody('{"Parameters":[{"Name":"File","FileValue":{"Name":"licencecopy.pdf","Data":"' + licCopyBase64 + '"}},{"Name":"StoreFile","Value":false}]}');
                        Http http = new Http();
                        HTTPResponse res = http.send(req);
                        if (res.getStatusCode() == 200) {
                            Map < String, Object > jmetadata_Map = (Map < String, Object > ) JSON.deserializeUntyped(res.getBody());
                            List < Object > recordList = (List < Object > ) jmetadata_Map.get('Files');
                            Map < String, Object > licobj = (Map < String, Object > ) recordList[0];
                            system.debug(licObj.get('FileName'));
                            licCopyBase64 = (String) licObj.get('FileData');
                        }
                    }
                    attachments = new List < Attachment > ();
                    if (String.isNotBlank(licCopyBase64)) attachments.add(new Attachment(name = docName + '.jpg', Body = blob.valueOf(licCopyBase64), ContentType = ''));
                }
            } else if (docName.contains('Health Insurance Doc') || docName.contains('Health insurance card or certificate')) {
                List < g_reqitem__c > rilst = [select id, RQ__r.Con__r.xpdl__c from g_reqitem__c where RQ__c =: reqId and itm__r.cd__c = 'inr'
                    and sta__r.cd__c = 'ok'
                ];
                if (rilst != null && !rilst.isEmpty()) {
                    Blob doc = GDRFAUtil.policyDoc(rilst[0].RQ__r.Con__r.xpdl__c);
                    if (doc != null) {
                        attachments = new List < Attachment > ();
                        attachments.add(new Attachment(name = 'Health insurance card or certificate.pdf', Body = doc, ContentType = ''));
                    }
                } else {
                    for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Health Insurance Doc'
                            or Name = 'Health insurance card or certificate')]) {
                        riDocLst.add(ridoc.reqDoc__c);
                    }
                    attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst AND(Name = 'Health Insurance Doc.jpg'
                        OR Name = 'Health insurance card or certificate.jpg') ORDER BY CreatedDate DESC LIMIT 1];
                }
            } else if (docName.contains('Medical Certificate Document')) {
                try {
                    reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c;
                    attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId and LastModifiedBy.Profile.Name != 'x'
                        and LastModifiedBy.Profile.Name != 'z'
                        ORDER BY CreatedDate DESC LIMIT 1
                    ];
                } catch (System.QueryException e) {
                    attachments = null;
                }
                if (attachments == null || (attachments != null && (attachments.size() == 0 || attachments.isEmpty()))) {
                    reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Health Insurance Doc'
                        OR Name = 'Health insurance card or certificate') LIMIT 1].reqDoc__c;
                    attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId AND(Name = 'Health Insurance Doc.jpg'
                        OR Name = 'Health insurance card or certificate.jpg') ORDER BY CreatedDate DESC LIMIT 1];
                }
            } else if (docName.contains('Education Certificate(Attested)') || docName.contains('Attested Degree Certificate')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Education Certificate(Attested)'
                    or Name = 'Attested Degree Certificate') LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 5];
            } else if (docName.contains('Passport First Page') || docName.contains('Passport - first page')) {
                for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Passport - first page'
                        or Name = 'Passport First Page'
                        or Name = 'Clear Passport Copy.'
                        or Name = 'Passport Copy - First Page')]) {
                    riDocLst.add(ridoc.reqDoc__c);
                }
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Passport Last Page') || docName.contains('Passport - last page')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Passport - last page'
                    or Name = 'Passport Last Page'
                    or Name = 'Passport Copy - Last/Second Page') LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Personal Photo') || docName.contains('Recent passport size photo')) {
                if (rpCan.contains(srvCd)) {
                    List < g_Req__c > rqLst = [select id, Con__r.Photo_ID__c from g_Req__c where id =: reqId];
                    if (rqLst != null && !rqLst.isEmpty() && String.isNotBlank(rqLst[0].Con__r.Photo_ID__c)) {
                        attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE Id =: rqLst[0].Con__r.Photo_ID__c];
                    }
                    if ((rqLst != null && !rqLst.isEmpty() && String.isBlank(rqLst[0].Con__r.Photo_ID__c)) || (attachments == null || attachments.isEmpty())) {
                        reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Passport Copy - Visa Page'
                            LIMIT 1
                        ].reqDoc__c;
                        attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
                    }
                } else {
                    for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Recent passport size photo'
                            or Name = 'Personal Photo'
                            or Name = 'Clear Passport size Color Photo.')]) {
                        riDocLst.add(ridoc.reqDoc__c);
                    }
                    attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst ORDER BY CreatedDate DESC LIMIT 1];
                }
            } else if (docName.contains('Visa Copy') && rpCan.contains(srvCd)) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Passport Copy - Visa Page'
                    LIMIT 1
                ].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Sponsored Passport page 3') && rpCan.contains(srvCd)) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Company undertaking letter'
                    LIMIT 1
                ].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Valid driving license Page 1') || docName.contains('Driving License Copy - Front Side')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid driving license Page 1'
                    or Name = 'Driving License Copy - Front Side') LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Car registration - Page 1') || docName.contains('Driving License Copy - Back Side')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Car registration - Page 1'
                    or Name = 'Driving License Copy - Back Side') LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('ID Card from nationality country') || docName.contains('Valid nationality identity card - front') || docName.contains('Current Nationality Identity Card (front side)')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid nationality identity card - front'
                    or Name = 'Current Nationality Identity Card (front side)'
                    or Name = 'ID Card from nationality country') LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Current Nationality Identity Card (back side)') || docName.contains('Valid nationality identity card - back')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid nationality identity card - back'
                    or Name = 'Current Nationality Identity Card (back side)') LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('Salary Payment Completion letter') || docName.contains('Company undertaking letter')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Company undertaking letter'
                    or Name = 'Salary Payment Completion letter') LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            } else if (docName.contains('EIDA application form')) {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId and name = 'EIDA application form.jpg'
                    ORDER BY CreatedDate DESC LIMIT 1
                ];
            } else {
                reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c;
                attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1];
            }
            if (attachments.size() > 0) return attachments;
            else return new List < Attachment > ();
        } catch (Exception e) {
            System.debug('--line no-- ' + e.getStackTraceString());
            return new List < Attachment > ();
        }
    }
    //global static List < Attachment > reqItemDocToUpload(String reqId, String docName,String srvCd) { system.debug('reqItemId-' + reqId); system.debug('docName-' + docName); String reqDocId; Set < id > riDocLst = new Set < Id > (); List < Attachment > attachments; Set < String > rpCan = new Set < String > (gu.csStr('RP_Cancel').split(';')); try { if (docName.contains('Health Insurance Doc') || docName.contains('Health insurance card or certificate')) { List < g_reqitem__c > rilst = [select id, RQ__r.Con__r.xpdl__c from g_reqitem__c where RQ__c =: reqId and itm__r.cd__c = 'inr' and sta__r.cd__c = 'ok' ]; if (rilst != null && !rilst.isEmpty()) { Blob doc = GDRFAUtil.policyDoc(rilst[0].RQ__r.Con__r.xpdl__c); if (doc != null) { attachments = new List < Attachment > (); attachments.add(new Attachment(name = 'Health insurance card or certificate.pdf', Body = doc, ContentType = '')); } } else { for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Health Insurance Doc' or Name = 'Health insurance card or certificate')]) { riDocLst.add(ridoc.reqDoc__c); } attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst AND(Name = 'Health Insurance Doc.jpg' OR Name = 'Health insurance card or certificate.jpg') ORDER BY CreatedDate DESC LIMIT 1]; } } else if (docName.contains('Education Certificate(Attested)') || docName.contains('Attested Degree Certificate')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Education Certificate(Attested)' or Name = 'Attested Degree Certificate') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 5]; } else if (docName.contains('Passport First Page') || docName.contains('Passport - first page')) { for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Passport - first page' or Name = 'Passport First Page' or Name = 'Clear Passport Copy.')]) { riDocLst.add(ridoc.reqDoc__c); } attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Passport Last Page') || docName.contains('Passport - last page')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Passport - last page' or Name = 'Passport Last Page') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Personal Photo') || docName.contains('Recent passport size photo')) { if(rpCan.contains(srvCd)){ List<g_Req__c> rqLst =  [select id,Con__r.Photo_ID__c from g_Req__c where id=:reqId]; if(rqLst != null && !rqLst.isEmpty() && String.isNotBlank(rqLst[0].Con__r.Photo_ID__c)){ attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE Id =: rqLst[0].Con__r.Photo_ID__c];  } if((rqLst != null && !rqLst.isEmpty() && String.isBlank(rqLst[0].Con__r.Photo_ID__c)) || (attachments == null || attachments.isEmpty()) ){ reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Passport Copy - Visa Page' LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } } else{ for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Passport - first page' or Name = 'Personal Photo' or Name = 'Clear Passport size Color Photo.')]) { riDocLst.add(ridoc.reqDoc__c); } attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst ORDER BY CreatedDate DESC LIMIT 1];  } }else if (docName.contains('Employment Contract Page 1') ) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Passport Copy - Visa Page' LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Valid driving license Page 1') || docName.contains('Driving License Copy - Front Side')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid driving license Page 1' or Name = 'Driving License Copy - Front Side') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Car registration - Page 1') || docName.contains('Driving License Copy - Back Side')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Car registration - Page 1' or Name = 'Driving License Copy - Back Side') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('ID Card from nationality country') || docName.contains('Valid nationality identity card - front') || docName.contains('Current Nationality Identity Card (front side)')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid nationality identity card - front' or Name = 'Current Nationality Identity Card (front side)' or Name = 'ID Card from nationality country') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Current Nationality Identity Card (back side)') || docName.contains('Valid nationality identity card - back')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid nationality identity card - back' or Name = 'Current Nationality Identity Card (back side)') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('EIDA application form')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId and Name = 'EIDA application form.jpg' ORDER BY CreatedDate DESC LIMIT 1 ]; } else { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } if (attachments.size() > 0) return attachments; else return new List < Attachment > (); } catch (Exception e) { System.debug('--line no-- ' + e.getStackTraceString()); return new List < Attachment > (); } }
    //global static List < Attachment > reqItemDocToUploadAdh(String reqId, String docName, String srvCd) { system.debug('reqItemId-' + reqId); system.debug('docName-' + docName); String reqDocId; Set < id > riDocLst = new Set < Id > (); List < Attachment > attachments; Set < String > rpCan = new Set < String > (gu.csStr('RP_Cancel').split(';')); try { if (docName.contains('Health Insurance Doc') || docName.contains('Health insurance card or certificate')) { List < g_reqitem__c > rilst = [select id, RQ__r.Con__r.xpdl__c from g_reqitem__c where RQ__c =: reqId and itm__r.cd__c = 'inr' and sta__r.cd__c = 'ok' ]; if (rilst != null && !rilst.isEmpty()) { Blob doc = GDRFAUtil.policyDoc(rilst[0].RQ__r.Con__r.xpdl__c); if (doc != null) { attachments = new List < Attachment > (); attachments.add(new Attachment(name = 'Health insurance card or certificate.pdf', Body = doc, ContentType = '')); } } else { for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Health Insurance Doc' or Name = 'Health insurance card or certificate')]) { riDocLst.add(ridoc.reqDoc__c); } attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst AND(Name = 'Health Insurance Doc.jpg' OR Name = 'Health insurance card or certificate.jpg') ORDER BY CreatedDate DESC LIMIT 1]; } } else if (docName.contains('Medical Certificate Document')) { try { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId and LastModifiedBy.Profile.Name != 'x' and LastModifiedBy.Profile.Name != 'z' ORDER BY CreatedDate DESC LIMIT 1 ]; } catch (System.QueryException e) { attachments = null; } if (attachments == null || (attachments != null && (attachments.size() == 0 || attachments.isEmpty()))) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Health Insurance Doc' OR Name = 'Health insurance card or certificate') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId AND(Name = 'Health Insurance Doc.jpg' OR Name = 'Health insurance card or certificate.jpg') ORDER BY CreatedDate DESC LIMIT 1]; } } else if (docName.contains('Education Certificate(Attested)') || docName.contains('Attested Degree Certificate')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Education Certificate(Attested)' or Name = 'Attested Degree Certificate') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 5]; } else if (docName.contains('Passport First Page') || docName.contains('Passport - first page')) { for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Passport - first page' or Name = 'Passport First Page' or Name = 'Clear Passport Copy.')]) { riDocLst.add(ridoc.reqDoc__c); } attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Passport Last Page') || docName.contains('Passport - last page')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Passport - last page' or Name = 'Passport Last Page') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Personal Photo') || docName.contains('Recent passport size photo')) { if (rpCan.contains(srvCd)) { List < g_Req__c > rqLst = [select id, Con__r.Photo_ID__c from g_Req__c where id =: reqId]; if (rqLst != null && !rqLst.isEmpty() && String.isNotBlank(rqLst[0].Con__r.Photo_ID__c)) { attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE Id =: rqLst[0].Con__r.Photo_ID__c]; } if ((rqLst != null && !rqLst.isEmpty() && String.isBlank(rqLst[0].Con__r.Photo_ID__c)) || (attachments == null || attachments.isEmpty())) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Passport Copy - Visa Page' LIMIT 1 ].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } } else { for (g_reqitemDoc__c ridoc: [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Req__c = true and reqAts__c = true and upOk__c = true AND(Name = 'Passport - first page' or Name = 'Personal Photo' or Name = 'Clear Passport size Color Photo.')]) { riDocLst.add(ridoc.reqDoc__c); } attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: riDocLst ORDER BY CreatedDate DESC LIMIT 1]; } } else if (docName.contains('Employment Contract Page 1')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name = 'Passport Copy - Visa Page' LIMIT 1 ].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Valid driving license Page 1') || docName.contains('Driving License Copy - Front Side')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid driving license Page 1' or Name = 'Driving License Copy - Front Side') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Car registration - Page 1') || docName.contains('Driving License Copy - Back Side')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Car registration - Page 1' or Name = 'Driving License Copy - Back Side') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('ID Card from nationality country') || docName.contains('Valid nationality identity card - front') || docName.contains('Current Nationality Identity Card (front side)')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid nationality identity card - front' or Name = 'Current Nationality Identity Card (front side)' or Name = 'ID Card from nationality country') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('Current Nationality Identity Card (back side)') || docName.contains('Valid nationality identity card - back')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND(Name = 'Valid nationality identity card - back' or Name = 'Current Nationality Identity Card (back side)') LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } else if (docName.contains('EIDA application form')) { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId and name = 'EIDA application form.jpg' ORDER BY CreatedDate DESC LIMIT 1 ]; } else { reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c; attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 1]; } if (attachments.size() > 0) return attachments; else return new List < Attachment > (); } catch (Exception e) { System.debug('--line no-- ' + e.getStackTraceString()); return new List < Attachment > (); } }
    global static List < Attachment > reqItemDocToAdochUpload(String reqId, String docName) {
        system.debug('reqItemId-' + reqId);
        system.debug('docName-' + docName);
        docName = (docName != null && docName.length() > 0) ? (docName.split(':'))[0] : docName;
        String reqDocId;
        List < Attachment > attachments;
        try {
            reqDocId = [SELECT reqDoc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c =: reqId AND Name =: docName LIMIT 1].reqDoc__c;
            attachments = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentId =: reqDocId ORDER BY CreatedDate DESC LIMIT 5];
            if (attachments.size() > 0) return attachments;
            else return new List < Attachment > ();
        } catch (Exception e) {
            System.debug('--line no-- ' + e.getStackTraceString());
            return new List < Attachment > ();
        }
    }
    global void uploadAdochDoc(List < sObject > scope, String gApiToken, String docName) {
        try {
            List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope;
            List < ws_call__c > wsToUpdate = new List < ws_call__c > ();
            List < ws_call__c > wsBlnkUpdate = new List < ws_call__c > ();
            String fname = '';
            for (ws_call__c wc: lstwsCall) {
                List < String > reqJson = wc.rq_jsn__c.split('__');
                if (reqItemDocToAdochUpload(wc.rq_itm__r.RQ__c, reqJson[1]).size() > 0) {
                    List < Attachment > att = reqItemDocToAdochUpload(wc.rq_itm__r.RQ__c, reqJson[1]); /*Attachment att = reqItemDocToUpload(wc.rq_itm__c,reqJson[1])[0];*/
                    if (att.size() > 0) {
                        SingleDocUploadJSONWrapper sdu = new SingleDocUploadJSONWrapper();
                        SingleDocUploadJSONWrapper.cls_Documents Documents = new SingleDocUploadJSONWrapper.cls_Documents();
                        Documents.documentTypeId = reqJson[0];
                        List < String > attJson = reqJson[1].split(':');
                        if (attJson.size() > 1) {
                            Integer ct = attJson[1] != null && attJson[1] != '' ? Integer.valueOf(attJson[1]) : 0;
                            if (ct < att.size() && ct == 0) {
                                Documents.document = EncodingUtil.base64Encode(att[0].Body);
                                Documents.FileName = att[0].Name;
                                Documents.MimeType = att[0].ContentType;
                                fname = att[0].Name;
                                if (fname != null && fname.containsIgnoreCase('.pdf')) {
                                    Documents.MimeType = 'application/pdf';
                                } else {
                                    Documents.MimeType = 'image/jpeg';
                                }
                            } else if (ct < att.size()) {
                                Documents.document = EncodingUtil.base64Encode(att[ct].Body);
                                Documents.FileName = att[ct].Name;
                                Documents.MimeType = att[ct].ContentType;
                                fname = att[ct].Name;
                                if (fname != null && fname.containsIgnoreCase('.pdf')) {
                                    Documents.MimeType = 'application/pdf';
                                } else {
                                    Documents.MimeType = 'image/jpeg';
                                }
                            } else {
                                wc.intsts__c = '';
                                wc.err_msg__c = 'Documents were not uploaded by customer!';
                                wsBlnkUpdate.add(wc);
                            }
                        } else {
                            Documents.document = EncodingUtil.base64Encode(att[0].Body);
                            Documents.FileName = att[0].Name;
                            Documents.MimeType = att[0].ContentType;
                            fname = att[0].Name;
                            if (fname != null && fname.containsIgnoreCase('.pdf')) {
                                Documents.MimeType = 'application/pdf';
                            } else {
                                Documents.MimeType = 'image/jpeg';
                            }
                        }
                        if (wc.intsts__c != '') {
                            Documents.IsMandatory = true;
                            Documents.documentNameEn = docName;
                            Documents.documentNameAr = GDRFAUtil.engToArabicStr(docName, gApiToken);
                            sdu.applicationId = wc.rq_itm__r.xf__c;
                            sdu.Documents = Documents;
                            String inputJson = JSON.serialize(sdu);
                            String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/documents/upload';
                            HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken);
                            system.debug('single doc res:>>>>> ' + res.getBody());
                            if (res.getStatusCode() == 200) {
                                for (ws_call__c ws: lstwsCall) {
                                    ws.intsts__c = 'Success';
                                    ws.res_jsn__c = res.getBody();
                                    wsToUpdate.add(ws);
                                }
                            } else {
                                for (ws_call__c ws: lstwsCall) {
                                    ws.intsts__c = 'Failed';
                                    ws.err_msg__c = res.getBody();
                                    wsToUpdate.add(ws);
                                }
                            }
                        }
                    }
                } else if (reqItemDocToAdochUpload(wc.rq_itm__r.RQ__c, reqJson[1]).isEmpty()) {
                    for (ws_call__c ws: lstwsCall) {
                        if (!ws.ismdt__c) ws.intsts__c = '';
                        ws.err_msg__c = 'Documents were not uploaded by customer!';
                        wsToUpdate.add(ws);
                    }
                }
            }
            if (!wsToUpdate.isEmpty()) update wsToUpdate;
            if (!wsBlnkUpdate.isEmpty()) update wsBlnkUpdate;
        } catch (Exception e) {
            System.debug('error in uploading doc:>>>>> ' + e.getStackTraceString());
        }
    }
    global void uploadSingleDocumentSrvc(List < sObject > scope, String gApiToken) {
        List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope;
        try {
            List < ws_call__c > wsToUpdate = new List < ws_call__c > ();
            List < ws_call__c > wsBlnkUpdate = new List < ws_call__c > ();
            String fname = '';
            for (ws_call__c wc: lstwsCall) {
                List < String > reqJson = wc.rq_jsn__c.split('__');
                if (reqItemDocToUpload(wc.rq_itm__r.RQ__c, reqJson[1], wc.rq_itm__r.RQ__r.Srvc__r.uid__c).size() > 0) {
                    List < Attachment > att = reqItemDocToUpload(wc.rq_itm__r.RQ__c, reqJson[1], wc.rq_itm__r.RQ__r.Srvc__r.uid__c); /*Attachment att = reqItemDocToUpload(wc.rq_itm__c,reqJson[1])[0];*/
                    if (att.size() > 0) {
                        SingleDocUploadJSONWrapper sdu = new SingleDocUploadJSONWrapper();
                        SingleDocUploadJSONWrapper.cls_Documents Documents = new SingleDocUploadJSONWrapper.cls_Documents();
                        Documents.documentTypeId = reqJson[0];
                        List < String > attJson = reqJson[1].split(':');
                        if (attJson.size() > 1) {
                            Integer ct = attJson[1] != null && attJson[1] != '' ? Integer.valueOf(attJson[1]) : 0;
                            if (ct < att.size() && ct == 0) {
                                Documents.document = EncodingUtil.base64Encode(att[0].Body);
                                Documents.FileName = att[0].Name;
                                Documents.MimeType = att[0].ContentType;
                                fname = att[0].Name;
                                if (fname != null && fname.containsIgnoreCase('.pdf')) {
                                    Documents.MimeType = 'application/pdf';
                                } else {
                                    Documents.MimeType = 'image/jpeg';
                                }
                            } else if (ct < att.size()) {
                                Documents.document = EncodingUtil.base64Encode(att[ct].Body);
                                Documents.FileName = att[ct].Name;
                                Documents.MimeType = att[ct].ContentType;
                                fname = att[ct].Name;
                                if (fname != null && fname.containsIgnoreCase('.pdf')) {
                                    Documents.MimeType = 'application/pdf';
                                } else {
                                    Documents.MimeType = 'image/jpeg';
                                }
                            } else {
                                wc.intsts__c = '';
                                wc.err_msg__c = 'Documents were not uploaded by customer!';
                                wsBlnkUpdate.add(wc);
                            }
                        } else {
                            if (wc.rq_itm__r.itm__r.cd__c == 'ec' || wc.rq_itm__r.itm__r.cd__c == 'er') Documents.document = (att[0].Body != null) ? EncodingUtil.base64Encode(att[0].Body) : '';
                            else Documents.document = EncodingUtil.base64Encode(att[0].Body);
                            Documents.FileName = att[0].Name;
                            Documents.MimeType = att[0].ContentType;
                            fname = att[0].Name;
                            if (fname != null && fname.containsIgnoreCase('.pdf')) {
                                Documents.MimeType = 'application/pdf';
                            } else {
                                Documents.MimeType = 'image/jpeg';
                            }
                        }
                        if (wc.intsts__c != '') {
                            Documents.IsMandatory = true;
                            Documents.documentNameEn = reqJson[1];
                            Documents.documentNameAr = GDRFAUtil.engToArabicStr(reqJson[1], gApiToken);
                            sdu.applicationId = wc.rq_itm__r.xf__c;
                            sdu.Documents = Documents;
                            String inputJson = JSON.serialize(sdu);
                            String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/documents/upload';
                            HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken);
                            system.debug('single doc res:>>>>> ' + res.getBody());
                            if (res.getStatusCode() == 200) {
                                for (ws_call__c ws: lstwsCall) {
                                    ws.intsts__c = 'Success';
                                    ws.res_jsn__c = res.getBody();
                                    wsToUpdate.add(ws);
                                }
                            } else {
                                /*to handle 150 kb*/
                                String msg = res.getBody();
                                if (msg != null && (msg.containsIgnoreCase('Maximum size of the file') || msg.containsIgnoreCase('The file type is not allowed') || msg.containsIgnoreCase('We encountered unexpected behavior'))) {
                                    HttpRequest req = New HttpRequest();
                                    req.setHeader('Content-Type', 'application/json');
                                    req.setHeader('Content-Disposition', 'Content-Disposition: form-data; name="DocumentTitle"');
                                    req.setHeader('Apikey', Label.GDRFAConvertAPIKey);
                                    endpointUrl = 'https://v2.convertapi.com/convert/jpeg/to/jpg?Secret=' + Label.GDRFAConvertAPISecret;
                                    req.setTimeout(90000);
                                    req.setMethod('POST');
                                    req.setEndpoint(endpointUrl);
                                    String docname = reqJson[1] + '.jpeg';
                                    String width = Label.GDRFAdocWidth;
                                    String height = Label.GDRFAdocHeight;
                                    if (reqJson[1].containsIgnoreCase('Photo')) {
                                        req.setBody('{"Parameters":[{"Name":"File","FileValue":{"Name":"' + docname + '","Data":"' + EncodingUtil.base64Encode(att[0].Body) + '"}},{ "Name": "ImageResolution", "Value": "300" }, { "Name": "ScaleImage", "Value": true }, { "Name": "ScaleIfLarger", "Value": true }, { "Name": "ImageHeight", "Value": "300" }, { "Name": "ImageWidth", "Value": "300" }, { "Name": "ImageQuality", "Value": "40" },{"Name":"StoreFile","Value":false}]}');
                                    } else {
                                        req.setBody('{"Parameters":[{"Name":"File","FileValue":{"Name":"' + docname + '","Data":"' + EncodingUtil.base64Encode(att[0].Body) + '"}},{ "Name": "ImageResolution", "Value": "300" }, { "Name": "ScaleImage", "Value": true }, { "Name": "ScaleIfLarger", "Value": true }, { "Name": "ImageHeight", "Value": "' + height + '" }, { "Name": "ImageWidth", "Value": "' + width + '" }, { "Name": "ImageQuality", "Value": "45" },{"Name":"StoreFile","Value":false}]}');
                                    }
                                    Http http = new Http();
                                    res = http.send(req);
                                    system.debug('res : ' + res.getBody());
                                    if (res.getStatusCode() == 200) {
                                        DocumentConversionWrapper dcw = DocumentConversionWrapper.parse(res.getBody());
                                        if (dcw.Files != null && !dcw.Files.isEmpty()) {
                                            Documents.document = dcw.Files[0].FileData;
                                            sdu.Documents = Documents; /*Documents.document {"ConversionCost":1,"Files":[{"FileName":"my_file.jpg","FileExt":"jpg","FileSize":68073,"FileData":"/FAEGCgCYGCgCYMdJmANbg2ZrgoAAAD//Z"}]} */
                                            inputJson = JSON.serialize(sdu);
                                            endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/documents/upload';
                                            res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken);
                                            system.debug('single doc res:>>>>> ' + res.getBody());
                                            if (res.getStatusCode() == 200) {
                                                for (ws_call__c ws: lstwsCall) {
                                                    ws.intsts__c = 'Success';
                                                    ws.res_jsn__c = res.getBody();
                                                    wsToUpdate.add(ws);
                                                }
                                            } else {
                                                for (ws_call__c ws: lstwsCall) {
                                                    ws.intsts__c = 'Failed';
                                                    ws.err_msg__c = res.getBody();
                                                    ws.ismp__c = true;
                                                    wsToUpdate.add(ws);
                                                }
                                            }
                                        }
                                    } else {
                                        for (ws_call__c ws: lstwsCall) {
                                            ws.intsts__c = 'Failed';
                                            ws.err_msg__c = res.getBody();
                                            ws.ismp__c = true;
                                            wsToUpdate.add(ws);
                                        }
                                    }
                                } else {
                                    for (ws_call__c ws: lstwsCall) {
                                        ws.intsts__c = 'Failed';
                                        ws.err_msg__c = res.getBody();
                                        wsToUpdate.add(ws);
                                    }
                                }
                            }
                        }
                    }
                } else if (reqItemDocToUpload(wc.rq_itm__r.RQ__c, reqJson[1], wc.rq_itm__r.RQ__r.Srvc__r.uid__c).isEmpty()) {
                    for (ws_call__c ws: lstwsCall) {
                        if (!ws.ismdt__c) ws.intsts__c = '';
                        ws.err_msg__c = 'Documents were not uploaded by customer!';
                        wsToUpdate.add(ws);
                    }
                }
            }
            if (!wsToUpdate.isEmpty()) update wsToUpdate;
            if (!wsBlnkUpdate.isEmpty()) update wsBlnkUpdate;
        } catch (Exception e) {
            lstwsCall[0].intsts__c = 'Failed';
            lstwsCall[0].err_msg__c = e.getStackTraceString();
            update lstwsCall;
            System.debug('error in uploading doc:>>>>> ' + e.getStackTraceString());
        }
    }
    global void uploadSingleDocumentAdh(List < sObject > scope, String gApiToken) {
        List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope;
        try {
            List < ws_call__c > wsToUpdate = new List < ws_call__c > ();
            List < ws_call__c > wsBlnkUpdate = new List < ws_call__c > ();
            String fname = '';
            for (ws_call__c wc: lstwsCall) {
                List < String > reqJson = wc.rq_jsn__c.split('__');
                if (reqItemDocToUpload(wc.rq_itm__r.RQ__c, reqJson[1], wc.rq_itm__r.RQ__r.Srvc__r.uid__c).size() > 0) {
                    List < Attachment > att = reqItemDocToUpload(wc.rq_itm__r.RQ__c, reqJson[1], wc.rq_itm__r.RQ__r.Srvc__r.uid__c); /*Attachment att = reqItemDocToUpload(wc.rq_itm__c,reqJson[1])[0];*/
                    if (att.size() > 0) {
                        SingleDocUploadJSONWrapper sdu = new SingleDocUploadJSONWrapper();
                        SingleDocUploadJSONWrapper.cls_Documents Documents = new SingleDocUploadJSONWrapper.cls_Documents();
                        Documents.documentTypeId = reqJson[0];
                        List < String > attJson = reqJson[1].split(':');
                        if (attJson.size() > 1) {
                            Integer ct = attJson[1] != null && attJson[1] != '' ? Integer.valueOf(attJson[1]) : 0;
                            if (ct < att.size() && ct == 0) {
                                Documents.document = EncodingUtil.base64Encode(att[0].Body);
                                Documents.FileName = att[0].Name;
                                Documents.MimeType = att[0].ContentType;
                                fname = att[0].Name;
                                if (fname != null && fname.containsIgnoreCase('.pdf')) {
                                    Documents.MimeType = 'application/pdf';
                                } else {
                                    Documents.MimeType = 'image/jpeg';
                                }
                            } else if (ct < att.size()) {
                                Documents.document = EncodingUtil.base64Encode(att[ct].Body);
                                Documents.FileName = att[ct].Name;
                                Documents.MimeType = att[ct].ContentType;
                                fname = att[ct].Name;
                                if (fname != null && fname.containsIgnoreCase('.pdf')) {
                                    Documents.MimeType = 'application/pdf';
                                } else {
                                    Documents.MimeType = 'image/jpeg';
                                }
                            } else {
                                wc.intsts__c = '';
                                wc.err_msg__c = 'Documents were not uploaded by customer!';
                                wsBlnkUpdate.add(wc);
                            }
                        } else {
                            if (wc.rq_itm__r.itm__r.cd__c == 'ec' || wc.rq_itm__r.itm__r.cd__c == 'er') Documents.document = (att[0].Body != null) ? EncodingUtil.base64Encode(att[0].Body) : '';
                            else Documents.document = EncodingUtil.base64Encode(att[0].Body);
                            Documents.FileName = att[0].Name;
                            Documents.MimeType = att[0].ContentType;
                            fname = att[0].Name;
                            if (fname != null && fname.containsIgnoreCase('.pdf')) {
                                Documents.MimeType = 'application/pdf';
                            } else {
                                Documents.MimeType = 'image/jpeg';
                            }
                        }
                        if (wc.intsts__c != '') {
                            Documents.IsMandatory = true;
                            Documents.documentNameEn = reqJson[1];
                            Documents.documentNameAr = GDRFAUtil.engToArabicStr(reqJson[1], gApiToken);
                            sdu.applicationId = wc.rq_itm__r.xf__c;
                            sdu.Documents = Documents;
                            String inputJson = JSON.serialize(sdu);
                            String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/documents/upload';
                            HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken);
                            system.debug('single doc res:>>>>> ' + res.getBody());
                            if (res.getStatusCode() == 200) {
                                for (ws_call__c ws: lstwsCall) {
                                    ws.intsts__c = 'Success';
                                    ws.res_jsn__c = res.getBody();
                                    wsToUpdate.add(ws);
                                }
                            } else {
                                /*to handle 150 kb*/
                                String msg = res.getBody();
                                if (msg != null && (msg.containsIgnoreCase('Maximum size of the file') || msg.containsIgnoreCase('The file type is not allowed') || msg.containsIgnoreCase('We encountered unexpected behavior'))) {
                                    HttpRequest req = New HttpRequest();
                                    req.setHeader('Content-Type', 'application/json');
                                    req.setHeader('Content-Disposition', 'Content-Disposition: form-data; name="DocumentTitle"');
                                    req.setHeader('Apikey', Label.GDRFAConvertAPIKey);
                                    endpointUrl = 'https://v2.convertapi.com/convert/jpeg/to/jpg?Secret=' + Label.GDRFAConvertAPISecret;
                                    req.setTimeout(90000);
                                    req.setMethod('POST');
                                    req.setEndpoint(endpointUrl);
                                    String docname = reqJson[1] + '.jpeg';
                                    String width = Label.GDRFAdocWidth;
                                    String height = Label.GDRFAdocHeight;
                                    if (reqJson[1].containsIgnoreCase('Photo')) {
                                        req.setBody('{"Parameters":[{"Name":"File","FileValue":{"Name":"' + docname + '","Data":"' + EncodingUtil.base64Encode(att[0].Body) + '"}},{ "Name": "ImageResolution", "Value": "300" }, { "Name": "ScaleImage", "Value": true }, { "Name": "ScaleIfLarger", "Value": true }, { "Name": "ImageHeight", "Value": "300" }, { "Name": "ImageWidth", "Value": "300" }, { "Name": "ImageQuality", "Value": "40" },{"Name":"StoreFile","Value":false}]}');
                                    } else {
                                        req.setBody('{"Parameters":[{"Name":"File","FileValue":{"Name":"' + docname + '","Data":"' + EncodingUtil.base64Encode(att[0].Body) + '"}},{ "Name": "ImageResolution", "Value": "300" }, { "Name": "ScaleImage", "Value": true }, { "Name": "ScaleIfLarger", "Value": true }, { "Name": "ImageHeight", "Value": "' + height + '" }, { "Name": "ImageWidth", "Value": "' + width + '" }, { "Name": "ImageQuality", "Value": "45" },{"Name":"StoreFile","Value":false}]}');
                                    }
                                    Http http = new Http();
                                    res = http.send(req);
                                    system.debug('res : ' + res.getBody());
                                    if (res.getStatusCode() == 200) {
                                        DocumentConversionWrapper dcw = DocumentConversionWrapper.parse(res.getBody());
                                        if (dcw.Files != null && !dcw.Files.isEmpty()) {
                                            Documents.document = dcw.Files[0].FileData;
                                            sdu.Documents = Documents; /*Documents.document {"ConversionCost":1,"Files":[{"FileName":"my_file.jpg","FileExt":"jpg","FileSize":68073,"FileData":"/FAEGCgCYGCgCYMdJmANbg2ZrgoAAAD//Z"}]} */
                                            inputJson = JSON.serialize(sdu);
                                            endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/documents/upload';
                                            res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken);
                                            system.debug('single doc res:>>>>> ' + res.getBody());
                                            if (res.getStatusCode() == 200) {
                                                for (ws_call__c ws: lstwsCall) {
                                                    ws.intsts__c = 'Success';
                                                    ws.res_jsn__c = res.getBody();
                                                    wsToUpdate.add(ws);
                                                }
                                            } else {
                                                for (ws_call__c ws: lstwsCall) {
                                                    ws.intsts__c = 'Failed';
                                                    ws.err_msg__c = res.getBody();
                                                    ws.ismp__c = true;
                                                    wsToUpdate.add(ws);
                                                }
                                            }
                                        }
                                    } else {
                                        for (ws_call__c ws: lstwsCall) {
                                            ws.intsts__c = 'Failed';
                                            ws.err_msg__c = res.getBody();
                                            ws.ismp__c = true;
                                            wsToUpdate.add(ws);
                                        }
                                    }
                                } else {
                                    for (ws_call__c ws: lstwsCall) {
                                        ws.intsts__c = 'Failed';
                                        ws.err_msg__c = res.getBody();
                                        wsToUpdate.add(ws);
                                    }
                                }
                            }
                        }
                    }
                } else if (reqItemDocToUpload(wc.rq_itm__r.RQ__c, reqJson[1], wc.rq_itm__r.RQ__r.Srvc__r.uid__c).isEmpty()) {
                    for (ws_call__c ws: lstwsCall) {
                        if (!ws.ismdt__c) ws.intsts__c = '';
                        ws.err_msg__c = 'Documents were not uploaded by customer!';
                        wsToUpdate.add(ws);
                    }
                }
            }
            if (!wsToUpdate.isEmpty()) update wsToUpdate;
            if (!wsBlnkUpdate.isEmpty()) update wsBlnkUpdate;
        } catch (Exception e) {
            lstwsCall[0].intsts__c = 'Failed';
            lstwsCall[0].err_msg__c = e.getStackTraceString();
            update lstwsCall;
            System.debug('error in uploading doc:>>>>> ' + e.getStackTraceString());
        }
    }
    //global void uploadSingleDocumentSrvc(List < sObject > scope, String gApiToken) { List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope; try { List < ws_call__c > wsToUpdate = new List < ws_call__c > (); List < ws_call__c > wsBlnkUpdate = new List < ws_call__c > (); for (ws_call__c wc: lstwsCall) { List < String > reqJson = wc.rq_jsn__c.split('__'); if (reqItemDocToUpload(wc.rq_itm__r.RQ__c, reqJson[1], wc.rq_itm__r.RQ__r.Srvc__r.uid__c).size() > 0) { List < Attachment > att = reqItemDocToUpload(wc.rq_itm__r.RQ__c, reqJson[1], wc.rq_itm__r.RQ__r.Srvc__r.uid__c); /*Attachment att = reqItemDocToUpload(wc.rq_itm__c,reqJson[1])[0];*/ if (att.size() > 0) { SingleDocUploadJSONWrapper sdu = new SingleDocUploadJSONWrapper(); SingleDocUploadJSONWrapper.cls_Documents Documents = new SingleDocUploadJSONWrapper.cls_Documents(); Documents.documentTypeId = reqJson[0]; List < String > attJson = reqJson[1].split(':'); if (attJson.size() > 1) { Integer ct = attJson[1] != null && attJson[1] != '' ? Integer.valueOf(attJson[1]) : 0; if (ct < att.size() && ct == 0) { Documents.document = EncodingUtil.base64Encode(att[0].Body); Documents.FileName = att[0].Name; Documents.MimeType = att[0].ContentType; } else if (ct < att.size()) { Documents.document = EncodingUtil.base64Encode(att[ct].Body); Documents.FileName = att[ct].Name; Documents.MimeType = att[ct].ContentType; } else { wc.intsts__c = ''; wc.err_msg__c = 'Documents were not uploaded by customer!'; wsBlnkUpdate.add(wc); } } else { if (wc.rq_itm__r.itm__r.cd__c == 'ec' || wc.rq_itm__r.itm__r.cd__c == 'er') Documents.document = (att[0].Body != null) ? EncodingUtil.base64Encode(att[0].Body) : ''; else Documents.document = EncodingUtil.base64Encode(att[0].Body); Documents.FileName = att[0].Name; Documents.MimeType = att[0].ContentType; } if (wc.intsts__c != '') { Documents.IsMandatory = true; Documents.documentNameEn = reqJson[1]; Documents.documentNameAr = GDRFAUtil.engToArabicStr(reqJson[1], gApiToken); sdu.applicationId = wc.rq_itm__r.xf__c; sdu.Documents = Documents; String inputJson = JSON.serialize(sdu); String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/documents/upload'; HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken); system.debug('single doc res:>>>>> ' + res.getBody()); if (res.getStatusCode() == 200) { for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Success'; ws.res_jsn__c = res.getBody(); wsToUpdate.add(ws); } } else { /*to handle 150 kb*/ String msg = res.getBody(); if (msg != null && (msg.containsIgnoreCase('Maximum size of the file') || msg.containsIgnoreCase('We encountered unexpected behavior'))) { HttpRequest req = New HttpRequest(); req.setHeader('Content-Type', 'application/json'); req.setHeader('Content-Disposition', 'Content-Disposition: form-data; name="DocumentTitle"'); req.setHeader('Apikey', Label.GDRFAConvertAPIKey); endpointUrl = 'https://v2.convertapi.com/convert/jpeg/to/jpg?Secret=' + Label.GDRFAConvertAPISecret; req.setTimeout(90000); req.setMethod('POST'); req.setEndpoint(endpointUrl); String docname = reqJson[1] + '.jpeg'; if (reqJson[1].containsIgnoreCase('Photo')) { req.setBody('{"Parameters":[{"Name":"File","FileValue":{"Name":"' + docname + '","Data":"' + EncodingUtil.base64Encode(att[0].Body) + '"}},{ "Name": "ImageResolution", "Value": "300" }, { "Name": "ScaleImage", "Value": true }, { "Name": "ScaleIfLarger", "Value": true }, { "Name": "ImageHeight", "Value": "300" }, { "Name": "ImageWidth", "Value": "300" }, { "Name": "ImageQuality", "Value": "40" },{"Name":"StoreFile","Value":false}]}'); } else { req.setBody('{"Parameters":[{"Name":"File","FileValue":{"Name":"'+docname+'","Data":"' + EncodingUtil.base64Encode(att[0].Body) + '"}},{ "Name": "ImageResolution", "Value": "300" }, { "Name": "ScaleImage", "Value": true }, { "Name": "ScaleIfLarger", "Value": true }, { "Name": "ImageHeight", "Value": "1017" }, { "Name": "ImageWidth", "Value": "872" }, { "Name": "ImageQuality", "Value": "45" },{"Name":"StoreFile","Value":false}]}'); } Http http = new Http(); res = http.send(req); system.debug('res : ' + res.getBody()); if (res.getStatusCode() == 200) { DocumentConversionWrapper dcw = DocumentConversionWrapper.parse(res.getBody()); if (dcw.Files != null && !dcw.Files.isEmpty()) { Documents.document = dcw.Files[0].FileData; sdu.Documents = Documents; /*Documents.document {"ConversionCost":1,"Files":[{"FileName":"my_file.jpg","FileExt":"jpg","FileSize":68073,"FileData":"/FAEGCgCYGCgCYMdJmANbg2ZrgoAAAD//Z"}]} */ inputJson = JSON.serialize(sdu); endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/documents/upload'; res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken); system.debug('single doc res:>>>>> ' + res.getBody()); if (res.getStatusCode() == 200) { for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Success'; ws.res_jsn__c = res.getBody(); wsToUpdate.add(ws); } } else { for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Failed'; ws.err_msg__c = res.getBody(); ws.ismp__c = true; wsToUpdate.add(ws); } } } } else { for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Failed'; ws.err_msg__c = res.getBody(); ws.ismp__c = true; wsToUpdate.add(ws); } } } else { for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Failed'; ws.err_msg__c = res.getBody(); wsToUpdate.add(ws); } } } } } } else if (reqItemDocToUpload(wc.rq_itm__r.RQ__c, reqJson[1], wc.rq_itm__r.RQ__r.Srvc__r.uid__c).isEmpty()) { for (ws_call__c ws: lstwsCall) { if (!ws.ismdt__c) ws.intsts__c = ''; ws.err_msg__c = 'Documents were not uploaded by customer!'; wsToUpdate.add(ws); } } } if (!wsToUpdate.isEmpty()) update wsToUpdate; if (!wsBlnkUpdate.isEmpty()) update wsBlnkUpdate; } catch (Exception e) { lstwsCall[0].intsts__c = 'Failed'; lstwsCall[0].err_msg__c = e.getStackTraceString(); update lstwsCall; System.debug('error in uploading doc:>>>>> ' + e.getStackTraceString()); } }
    //global void uploadSingleDocumentAdh(List < sObject > scope, String gApiToken) { try { List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope; List < ws_call__c > wsToUpdate = new List < ws_call__c > (); List < ws_call__c > wsBlnkUpdate = new List < ws_call__c > (); for (ws_call__c wc: lstwsCall) { List < String > reqJson = wc.rq_jsn__c.split('__'); if (reqItemDocToUploadAdh(wc.rq_itm__r.RQ__c, reqJson[1], wc.rq_itm__r.RQ__r.Srvc__r.uid__c).size() > 0) { List < Attachment > att = reqItemDocToUploadAdh(wc.rq_itm__r.RQ__c, reqJson[1], wc.rq_itm__r.RQ__r.Srvc__r.uid__c); /*Attachment att = reqItemDocToUpload(wc.rq_itm__c,reqJson[1])[0];*/ if (att.size() > 0) { SingleDocUploadJSONWrapper sdu = new SingleDocUploadJSONWrapper(); SingleDocUploadJSONWrapper.cls_Documents Documents = new SingleDocUploadJSONWrapper.cls_Documents(); Documents.documentTypeId = reqJson[0]; List < String > attJson = reqJson[1].split(':'); if (attJson.size() > 1) { Integer ct = attJson[1] != null && attJson[1] != '' ? Integer.valueOf(attJson[1]) : 0; if (ct < att.size() && ct == 0) { Documents.document = EncodingUtil.base64Encode(att[0].Body); Documents.FileName = att[0].Name; Documents.MimeType = att[0].ContentType; } else if (ct < att.size()) { Documents.document = EncodingUtil.base64Encode(att[ct].Body); Documents.FileName = att[ct].Name; Documents.MimeType = att[ct].ContentType; } else { wc.intsts__c = ''; wc.err_msg__c = 'Documents were not uploaded by customer!'; wsBlnkUpdate.add(wc); } } else { Documents.document = EncodingUtil.base64Encode(att[0].Body); Documents.FileName = att[0].Name; Documents.MimeType = att[0].ContentType; } if (wc.intsts__c != '') { Documents.IsMandatory = true; Documents.documentNameEn = reqJson[1]; Documents.documentNameAr = GDRFAUtil.engToArabicStr(reqJson[1], gApiToken); sdu.applicationId = wc.rq_itm__r.xf__c; sdu.Documents = Documents; String inputJson = JSON.serialize(sdu); String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/documents/upload'; HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken); system.debug('single doc res:>>>>> ' + res.getBody()); if (res.getStatusCode() == 200) { for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Success'; ws.res_jsn__c = res.getBody(); wsToUpdate.add(ws); } } else { /*to handle 150 kb*/ String msg = res.getBody(); if (msg != null && msg.containsIgnoreCase('Maximum size of the file is 150 KB')) {  HttpRequest req = New HttpRequest(); req.setHeader('Content-Type', 'application/json'); req.setHeader('Content-Disposition', 'Content-Disposition: form-data; name="DocumentTitle"'); req.setHeader('Apikey', Label.GDRFAConvertAPIKey); endpointUrl = 'https://v2.convertapi.com/convert/jpeg/to/jpg?Secret=' + Label.GDRFAConvertAPISecret; req.setTimeout(90000); req.setMethod('POST'); req.setEndpoint(endpointUrl);  req.setBody('{"Parameters":[{"Name":"File","FileValue":{"Name":"my_file.jpeg","Data":"' + EncodingUtil.base64Encode(att[0].Body) + '"}},{ "Name": "ImageResolution", "Value": "300" }, { "Name": "ScaleImage", "Value": true }, { "Name": "ScaleIfLarger", "Value": true }, { "Name": "ImageHeight", "Value": "1232" }, { "Name": "ImageWidth", "Value": "872" }, { "Name": "ImageQuality", "Value": "50" },{"Name":"StoreFile","Value":false}]}'); Http http = new Http(); res = http.send(req); system.debug('res : ' + res.getBody()); if (res.getStatusCode() == 200) { DocumentConversionWrapper dcw = DocumentConversionWrapper.parse(res.getBody()); if (dcw.Files != null && !dcw.Files.isEmpty()) { Documents.document = dcw.Files[0].FileData; sdu.Documents = Documents; /*Documents.document {"ConversionCost":1,"Files":[{"FileName":"my_file.jpg","FileExt":"jpg","FileSize":68073,"FileData":"/FAEGCgCYGCgCYMdJmANbg2ZrgoAAAD//Z"}]} */ inputJson = JSON.serialize(sdu); endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/documents/upload'; res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken); system.debug('single doc res:>>>>> ' + res.getBody()); if (res.getStatusCode() == 200) { for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Success'; ws.res_jsn__c = res.getBody(); wsToUpdate.add(ws); }  } else {  for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Failed'; ws.err_msg__c = res.getBody(); ws.ismp__c = true; wsToUpdate.add(ws); } } } } else{ for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Failed'; ws.err_msg__c = res.getBody(); wsToUpdate.add(ws); } } } else {   for (ws_call__c ws: lstwsCall) { ws.intsts__c = 'Failed'; ws.err_msg__c = res.getBody(); wsToUpdate.add(ws); } } } } } } else if (reqItemDocToUpload(wc.rq_itm__r.RQ__c, reqJson[1], wc.rq_itm__r.RQ__r.Srvc__r.uid__c).isEmpty()) { for (ws_call__c ws: lstwsCall) { if (!ws.ismdt__c) ws.intsts__c = ''; ws.err_msg__c = 'Documents were not uploaded by customer!'; wsToUpdate.add(ws); } } } if (!wsToUpdate.isEmpty()) update wsToUpdate; if (!wsBlnkUpdate.isEmpty()) update wsBlnkUpdate; } catch (Exception e) { System.debug('error in uploading doc:>>>>> ' + e.getStackTraceString()); } }
    //global void invokePayment(List < sObject > scope, String gApiToken) { try { List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope; List < ws_call__c > wsToUpdate = new List < ws_call__c > (); List < ws_call__c > getFeelst = new List < ws_call__c > (); List < g_reqitem__c > updateReqItems = new List < g_reqitem__c > (); List<g_reqitem__c> riLst = new List<g_reqitem__c>(); for (ws_call__c wc: lstwsCall) { String processPayment = 'Yes'; g_reqitem__c reqItem = GDRFAUtil.reqItem(wc.rq_itm__c); if (String.isNotBlank(reqItem.RQ__r.xadh__c) && (reqItem.RQ__r.xadh__c).contains('ofl;')) { List < g_reqitem__c > oflLst = [select id, RQ__c from g_reqitem__c where RQ__c =: reqItem.RQ__c and itm__r.cd__c = 'ofl' and Sta__r.cd__c = 'ok' ]; if (oflLst == null || oflLst.isEmpty()) processPayment = 'No'; } for (ws_call__c wsc: reqItem.WS_Calls__r) { if (wsc.mtd_nm__c == 'uploadSingleDocument' && (wsc.intsts__c == 'Failed' || wsc.intsts__c == 'Ready for Integration')) processPayment = 'No'; } if (wc.rq_itm__r.xf__c != null && processPayment == 'Yes') { String finputJson = '{"applicationId": "' + wc.rq_itm__r.xf__c + '","validate":"true"}'; String fendpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/fees'; HTTPResponse fres = GDRFAUtil.httpResponse(finputJson, fendpointUrl, 'POST', gApiToken); system.debug(fres.getBody()); ws_call__c fwc = new ws_call__c(); fwc.rq_itm__c = wc.rq_itm__r.id; fwc.ws_typ__c = 'Immigration EVEP'; fwc.mtd_nm__c = 'GetFee'; system.debug('fres.getStatusCode()'); system.debug(fres.getStatusCode()); if (fres.getStatusCode() == 200) { fwc.intsts__c = 'Success'; if (reqItem.itm__r.cd__c == 'la' || reqItem.itm__r.cd__c == 'rp' || reqItem.itm__r.cd__c == 'oua' || reqItem.itm__r.cd__c == 'oup' || reqItem.itm__r.cd__c == 'ins') { ImmigrationResponseWrapper.FeeResponse frec = (ImmigrationResponseWrapper.FeeResponse) System.JSON.deserialize(fres.getBody(), ImmigrationResponseWrapper.FeeResponse.class); List < ImmigrationResponseWrapper.Fees > feeLst = frec.fees; if (feeLst != null && !feeLst.isEmpty()) { for (ImmigrationResponseWrapper.Fees f: feeLst) { if (f.nameEn == 'Violation Fee' && f.isMandatory == true) { processPayment = 'No';  /* in case of fines  retuned for correction */ reqItem.sta__c =GDRFAUtil.statusId('rc',reqItem.Itm__c); reqItem.xr__c='Others'; decimal fineAmount = f.amount; String oldpermitNo = reqItem.RQ__r.e__c; String fileType = ''; if (String.isNotBlank(oldpermitNo)) { List < String > permitLst = oldpermitNo.split('/'); if ((integer.valueOf(permitLst[1]) < system.now().Year()) || permitLst[0] == '201') fileType = '2'; else fileType = '1'; } if(fileType == '1' && reqItem.itm__r.cd__c == 'la') /* inncas  of visit visa*/ fineAmount = fineAmount + Decimal.valueOf(Label.GDRFAFineVisitVisa); else fineAmount = fineAmount + Decimal.valueOf(Label.GDRFAFineResidenceVisa);  String fnnotes='A fine for overstaying has been levied against applicant, Please pay the fine at the earliest to avoid the daily fine increments.'+'Fine amount to be paid AED: ' + fineAmount +' as of: '+ system.now(); reqItem.xcnotes__c=fnnotes; /*wc.intsts__c = 'Failed';*/ wc.err_msg__c = 'Fine Amount  to be paid AED: ' + fineAmount +' as of: '+ system.now();  reqItem.nt__c = 'Fine Amount : ' + fineAmount +' as of: '+ system.now(); List<g_reqitem__c> fnItmLst =new  List<g_reqitem__c> (); fnItmLst = [select id,cN__c,AD__c from g_reqitem__c where RQ__c=:reqItem.RQ__c and itm__r.cd__c='fn' ]; if(fnItmLst != null && !fnItmLst.isEmpty() && fnItmLst[0].cN__c < f.amount  ){ processPayment = 'No'; wc.err_msg__c = 'Fine Amount mismatch: ' + f.amount; reqItem.sta__c =GDRFAUtil.statusId('rc',reqItem.Itm__c); reqItem.xr__c='Others'; if(fnItmLst[0].AD__c<=0){ fnnotes='An additional fine for overstaying has been levied against applicant, Please pay the fine at the earliest to avoid the daily fine increments.'+'Fine amount to be paid AED: ' + (f.amount - fnItmLst[0].cN__c)+' as of: '+ system.now(); } reqItem.xcnotes__c=fnnotes; fnItmLst[0].cN__c = f.amount; /*updateReqItems.add(reqItem);*/ updateReqItems.add(fnItmLst[0]); reqItem.IsFines__c=true; } else if(fnItmLst != null && !fnItmLst.isEmpty()  && fnItmLst[0].AD__c>0){ reqItem.IsFines__c=true; processPayment = 'No'; }  else if ((fnItmLst!=null && fnItmLst.size()==0) &&  !reqItem.IsFinePaid__c && !reqItem.IsFines__c){ for(g_srvcitm__c i :[select id, Srv_Code__c, Req__c, dSTA__c, EXP__c, Name, vspexc__c, vst__c, vec__c, su__c, vsu__c, vesch__c, ngs__c, ngsXP__c, vsc__c, cd__c, srvc__c, Tp__c, rv__c, prcEdt__c, dcr__c, DscApp__c, KF__c, scN__c, vscp__c, cN__c, smN__c, slaN__c, vspc__c, spChN__c, spChXP__c, scXP__c, cXP__c, smXP__c, slaXP__c, dc__c, TAX_CODE__c, TAX_TYPE__c, extc__c, TAXCODE_SC__c, extcsc__c, (Select Id, cd__c, uid__c From Statuses__r where isDeleted = false and actv__c = true AND(cd__c = 'n')) From g_srvcitm__c where isDeleted = false and actv__c = true and srvc__c =:reqItem.RQ__r.Srvc__c AND cd__c = 'fn']){ riLst.add(new g_reqitem__c(Name = i.Name, itm__c = i.id, RQ__c = reqItem.RQ__c, m__c = null, rv__c = i.rv__c, vSTA__c = 'Verified', slaN__c = i.slaN__c, slaXP__c = i.slaXP__c, ngs__c = i.ngs__c, ngsXP__c = i.ngsXP__c, TAX_CODE__c = i.TAX_CODE__c, TAX_TYPE__c = i.TAX_TYPE__c, extc__c = i.extc__c, TAXCODE_SC__c = i.TAXCODE_SC__c, extcsc__c = i.extcsc__c, DscApp__c = i.DscApp__c, KF__c = i.KF__c, cN__c = fineAmount, cXP__c = i.cXP__c, smN__c = i.smN__c, smXP__c = i.smXP__c, scN__c =i.scN__c, scXP__c = i.scXP__c, vsc__c = i.vsc__c, vesch__c = i.vesch__c, vst__c = i.vst__c, vec__c = i.vec__c, su__c = i.su__c, vsu__c = i.vsu__c, sta__c = i.Statuses__r[0].Id, itmtp__c = i.Tp__c, xdcr__c = i.dcr__c, dc__c = i.dc__c)); } reqItem.IsFines__c=true; }   wsToUpdate.add(wc); updateReqItems.add(reqItem);  } } } } } else { fwc.intsts__c = 'Failed'; processPayment = 'No'; } fwc.rq_jsn__c = finputJson; fwc.res_jsn__c = fres.getBody(); getFeelst.add(fwc); } system.debug('processPayment:' + processPayment); if (wc.rq_itm__r.xf__c != null && processPayment == 'Yes') {  String inputJson = '{"applicationId": "' + wc.rq_itm__r.xf__c + '"}'; String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/pay'; HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken); System.debug('payment res:>>>>> ' + res.getBody()); if (res.getStatusCode() == 200) { ImmigrationResponseWrapper.ApplicationResponse irw = (ImmigrationResponseWrapper.ApplicationResponse) System.JSON.deserialize(res.getBody(), ImmigrationResponseWrapper.ApplicationResponse.class); if (String.isNotBlank(wc.rq_jsn__c)) wc.rq_jsn__c = inputJson; wc.intsts__c = 'Success'; wc.res_jsn__c = res.getBody(); wsToUpdate.add(wc); reqItem.sta__c = GDRFAUtil.statusId('if', reqItem.itm__c); reqItem.xi__c = irw.batchId; reqItem.xat__c = system.now(); updateReqItems.add(reqItem); } else { if (String.isNotBlank(wc.rq_jsn__c)) wc.rq_jsn__c = inputJson; wc.intsts__c = 'Failed'; wc.err_msg__c = res.getBody(); wsToUpdate.add(wc); } } } if (!getFeelst.isEmpty()) insert getFeelst; if (!wsToUpdate.isEmpty()) update wsToUpdate; if(!riLst.isEmpty()) insert riLst; if (!updateReqItems.isEmpty()) update updateReqItems; } catch (Exception e) { System.debug('Error in payment:>>>>> ' + e.getStackTraceString()); } }
    global void invokePayment(List < sObject > scope, String gApiToken) {
        try {
            List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope;
            List < ws_call__c > wsToUpdate = new List < ws_call__c > ();
            List < ws_call__c > getFeelst = new List < ws_call__c > ();
            List < g_reqitem__c > updateReqItems = new List < g_reqitem__c > ();
            List < g_reqitem__c > riLst = new List < g_reqitem__c > ();
            datetime dt = system.now();
            String tdy = dt.format('dd MMM,yyyy');
            for (ws_call__c wc: lstwsCall) {
                String processPayment = 'Yes';
                g_reqitem__c reqItem = GDRFAUtil.reqItem(wc.rq_itm__c);
                if (String.isNotBlank(reqItem.RQ__r.xadh__c) && (reqItem.RQ__r.xadh__c).contains('ofl;')) {
                    List < g_reqitem__c > oflLst = [select id, RQ__c from g_reqitem__c where RQ__c =: reqItem.RQ__c and itm__r.cd__c = 'ofl'
                        and Sta__r.cd__c = 'ok'
                    ];
                    if (oflLst == null || oflLst.isEmpty()) processPayment = 'No';
                }
                if (reqItem.itm__r.cd__c == 'rp') {
                    List < g_reqitem__c > eidalLst = [select id, RQ__c from g_reqitem__c where RQ__c =: reqItem.RQ__c and itm__r.cd__c = 'ia'
                        and Sta__r.cd__c in ('ok', 'ebn', 'okk', 'ebr')
                    ];
                    if (eidalLst == null || eidalLst.isEmpty()) processPayment = 'No';
                }
                for (ws_call__c wsc: reqItem.WS_Calls__r) {
                    if (wsc.mtd_nm__c == 'uploadSingleDocument' && (wsc.intsts__c == 'Failed' || wsc.intsts__c == 'Ready for Integration')) processPayment = 'No';
                }
                if (wc.rq_itm__r.xf__c != null && processPayment == 'Yes') {
                    String finputJson = '{"applicationId": "' + wc.rq_itm__r.xf__c + '","validate":"true"}';
                    String fendpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/fees';
                    HTTPResponse fres = GDRFAUtil.httpResponse(finputJson, fendpointUrl, 'POST', gApiToken);
                    system.debug(fres.getBody());
                    ws_call__c fwc = new ws_call__c();
                    fwc.rq_itm__c = wc.rq_itm__r.id;
                    fwc.ws_typ__c = 'Immigration EVEP';
                    fwc.mtd_nm__c = 'GetFee';
                    system.debug('fres.getStatusCode()');
                    system.debug(fres.getStatusCode());
                    if (fres.getStatusCode() == 200) {
                        fwc.intsts__c = 'Success';
                        if (reqItem.itm__r.cd__c == 'la' || reqItem.itm__r.cd__c == 'rp' || reqItem.itm__r.cd__c == 'oua' || reqItem.itm__r.cd__c == 'oup' || reqItem.itm__r.cd__c == 'ins' || reqItem.itm__r.cd__c == 'er') {
                            ImmigrationResponseWrapper.FeeResponse frec = (ImmigrationResponseWrapper.FeeResponse) System.JSON.deserialize(fres.getBody(), ImmigrationResponseWrapper.FeeResponse.class);
                            List < ImmigrationResponseWrapper.Fees > feeLst = frec.fees;
                            if (feeLst != null && !feeLst.isEmpty()) {
                                for (ImmigrationResponseWrapper.Fees f: feeLst) {
                                    if ((f.nameEn == 'Violation Fee' || f.nameEn == 'Violation Fee - Establishment') && f.isMandatory == true) {
                                        processPayment = 'No'; /* in case of fines  retuned for correction */
                                        reqItem.sta__c = GDRFAUtil.statusId('rc', reqItem.Itm__c);
                                        reqItem.xr__c = 'Others';
                                        decimal fineAmount = f.amount;
                                        decimal fineAmountSC = f.amount;
                                        String oldpermitNo = reqItem.RQ__r.e__c;
                                        String fileType = '';
                                        if (String.isNotBlank(oldpermitNo)) {
                                            List < String > permitLst = oldpermitNo.split('/');
                                            if ((integer.valueOf(permitLst[1]) < system.now().Year()) || permitLst[0] == '201') fileType = '2';
                                            else fileType = '1';
                                        }
                                        if (fileType == '1' && reqItem.itm__r.cd__c == 'la') {
                                            /* inncas  of visit visa*/
                                            fineAmount = fineAmount + Decimal.valueOf(Label.GDRFAFineVisitVisa) + 280;
                                            fineAmountSC = fineAmountSC + Decimal.valueOf(Label.GDRFAFineVisitVisa);
                                        } else if (reqItem.itm__r.cd__c != 'er') {
                                            fineAmount = fineAmount + Decimal.valueOf(Label.GDRFAFineResidenceVisa) + 280;
                                            fineAmountSC = fineAmountSC + Decimal.valueOf(Label.GDRFAFineVisitVisa);
                                        }
                                        String fnnotes = 'A fine for overstaying has been levied against applicant, Please pay the fine at the earliest to avoid the daily fine increments.' + 'Fine amount to be paid AED: ' + fineAmount + ' as of: ' + tdy;
                                        if (reqItem.itm__r.cd__c == 'er') fnnotes = 'Non renewal fine has been levied against application, Please pay the fine at the earliest.' + 'Fine amount to be paid AED: ' + (fineAmount + 280) + ' as of: ' + tdy;
                                        reqItem.xcnotes__c = fnnotes; /*wc.intsts__c = 'Failed';*/
                                        wc.err_msg__c = 'Fine Amount  to be paid AED: ' + fineAmount + ' as of: ' + tdy;
                                        wc.sdt__c = system.now();
                                        reqItem.nt__c = 'Fine Amount : ' + fineAmount + ' as of: ' + tdy;
                                        List < g_reqitem__c > fnItmLst = new List < g_reqitem__c > ();
                                        fnItmLst = [select id, cN__c, AD__c, AOP__c from g_reqitem__c where RQ__c =: reqItem.RQ__c and itm__r.cd__c = 'fn'];
                                        if (fnItmLst != null && !fnItmLst.isEmpty() && fnItmLst[0].cN__c <= f.amount) {
                                            processPayment = 'No';
                                            wc.err_msg__c = 'Fine Amount mismatch: ' + f.amount;
                                            reqItem.sta__c = GDRFAUtil.statusId('rc', reqItem.Itm__c);
                                            reqItem.xr__c = 'Others';
                                            if (fnItmLst[0].AD__c <= 0) {
                                                fnnotes = 'An additional fine for overstaying has been levied against applicant, Please pay the fine at the earliest to avoid the daily fine increments.' + 'Fine amount to be paid AED: ' + (f.amount - fnItmLst[0].cN__c) + ' as of: ' + tdy;
                                                if (reqItem.itm__r.cd__c == 'er') fnnotes = 'Non renewal fine has been levied against application, Please pay the fine at the earliest.' + 'Fine amount to be paid AED: ' + (f.amount - fnItmLst[0].cN__c) + ' as of: ' + tdy;
                                            }
                                            if (fnItmLst[0].AD__c <= 0 && fnItmLst[0].cN__c == f.amount) {
                                                processPayment = 'Yes';
                                            }
                                            reqItem.xcnotes__c = fnnotes;
                                            fnItmLst[0].cN__c = f.amount; /*updateReqItems.add(reqItem);*/
                                            updateReqItems.add(fnItmLst[0]);
                                            reqItem.IsFines__c = true;
                                        } else if (fnItmLst != null && !fnItmLst.isEmpty() && fnItmLst[0].AD__c > 0) {
                                            reqItem.IsFines__c = true;
                                            processPayment = 'No';
                                        } else if (fnItmLst != null && !fnItmLst.isEmpty() && fnItmLst[0].AD__c <= 0 && fnItmLst[0].AOP__c <= 0) {
                                            processPayment = 'Yes';
                                        } else if ((fnItmLst != null && fnItmLst.size() == 0) && !reqItem.IsFinePaid__c && !reqItem.IsFines__c) {
                                            for (g_srvcitm__c i: [select id, Srv_Code__c, Req__c, dSTA__c, EXP__c, Name, vspexc__c, vst__c, vec__c, su__c, vsu__c, vesch__c, ngs__c, ngsXP__c, vsc__c, cd__c, srvc__c, Tp__c, rv__c, prcEdt__c, dcr__c, DscApp__c, KF__c, scN__c, vscp__c, cN__c, smN__c, slaN__c, vspc__c, spChN__c, spChXP__c, scXP__c, cXP__c, smXP__c, slaXP__c, dc__c, TAX_CODE__c, TAX_TYPE__c, extc__c, TAXCODE_SC__c, extcsc__c, (Select Id, cd__c, uid__c From Statuses__r where isDeleted = false and actv__c = true AND(cd__c = 'n')) From g_srvcitm__c where isDeleted = false and actv__c = true and srvc__c =: reqItem.RQ__r.Srvc__c AND cd__c = 'fn']) {
                                                riLst.add(new g_reqitem__c(Name = i.Name, itm__c = i.id, RQ__c = reqItem.RQ__c, m__c = null, rv__c = i.rv__c, vSTA__c = 'Verified', slaN__c = i.slaN__c, slaXP__c = i.slaXP__c, ngs__c = i.ngs__c, ngsXP__c = i.ngsXP__c, TAX_CODE__c = i.TAX_CODE__c, TAX_TYPE__c = i.TAX_TYPE__c, extc__c = i.extc__c, TAXCODE_SC__c = i.TAXCODE_SC__c, extcsc__c = i.extcsc__c, DscApp__c = i.DscApp__c, KF__c = i.KF__c, cN__c = fineAmountSC, cXP__c = i.cXP__c, smN__c = i.smN__c, smXP__c = i.smXP__c, scN__c = i.scN__c, scXP__c = i.scXP__c, vsc__c = i.vsc__c, vesch__c = i.vesch__c, vst__c = i.vst__c, vec__c = i.vec__c, su__c = i.su__c, vsu__c = i.vsu__c, sta__c = i.Statuses__r[0].Id, itmtp__c = i.Tp__c, xdcr__c = i.dcr__c, dc__c = i.dc__c));
                                            }
                                            reqItem.IsFines__c = true;
                                        }
                                        if (processPayment == 'No') {
                                            wsToUpdate.add(wc);
                                            updateReqItems.add(reqItem);
                                        }
                                    }
                                    if ((f.nameEn == 'Dubai Police Traffic Fines' || f.nameEn.toLowerCase().contains('traffic') || f.nameEn.toLowerCase().contains('traffic fines')) && f.isMandatory == true) {
                                        reqItem.sta__c = GDRFAUtil.statusId('rc', reqItem.Itm__c);
                                        reqItem.xr__c = 'Others';
                                        decimal fineAmount = f.amount;
                                        reqItem.xr__c = 'Others';
                                        Decimal famt = fineAmount;
                                        String fnnotes = 'Traffic fines of AED ' + famt + ' have been levied against the applicant by Dubai Police. Please ensure all outstanding fines are cleared to proceed and avoid delays in processing the visa application.';
                                        reqItem.xcnotes__c = fnnotes;
                                        wc.err_msg__c = fnnotes;
                                        if (processPayment == 'Yes') {
                                            /* to avoid duplicate updates*/
                                            wsToUpdate.add(wc);
                                            updateReqItems.add(reqItem);
                                        }
                                        processPayment = 'No'; /* in case of fines  retuned for correction */
                                        g_req__c rq = new g_req__c(id = reqItem.RQ__c, xrtaf__c = fnnotes);
                                        update rq;
                                    }
                                }
                            }
                        }
                    } else {
                        fwc.intsts__c = 'Failed';
                        processPayment = 'No';
                    }
                    fwc.rq_jsn__c = finputJson;
                    fwc.res_jsn__c = fres.getBody();
                    getFeelst.add(fwc);
                }
                system.debug('processPayment:' + processPayment);
                if (wc.rq_itm__r.xf__c != null && processPayment == 'Yes') {
                    
                    String inputJson = '{"applicationId": "' + wc.rq_itm__r.xf__c + '"}';
                    String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/pay';
                    HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken);
                    System.debug('payment res:>>>>> ' + res.getBody());
                    if (res.getStatusCode() == 200) {
                        ImmigrationResponseWrapper.ApplicationResponse irw = (ImmigrationResponseWrapper.ApplicationResponse) System.JSON.deserialize(res.getBody(), ImmigrationResponseWrapper.ApplicationResponse.class);
                        if (String.isNotBlank(wc.rq_jsn__c)) wc.rq_jsn__c = inputJson;
                        wc.intsts__c = 'Success';
                        wc.res_jsn__c = res.getBody();
                        wsToUpdate.add(wc);
                        reqItem.sta__c = GDRFAUtil.statusId('if', reqItem.itm__c);
                        reqItem.xi__c = irw.batchId;
                        reqItem.xat__c = system.now();
                        updateReqItems.add(reqItem);
                    } else {
                        if (String.isNotBlank(wc.rq_jsn__c)) wc.rq_jsn__c = inputJson;
                        wc.intsts__c = 'Failed';
                        wc.err_msg__c = res.getBody();
                        wsToUpdate.add(wc);
                    }
                }
            }
            if (!getFeelst.isEmpty()) insert getFeelst;
            if (!wsToUpdate.isEmpty()) update wsToUpdate;
            if (!riLst.isEmpty()) insert riLst;
            if (!updateReqItems.isEmpty()) update updateReqItems;
        } catch (Exception e) {
            System.debug('Error in payment:>>>>> ' + e.getStackTraceString());
        }
    }
    //global void checkFinePayment(List < sObject > scope, String gApiToken) { try { List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope; List < ws_call__c > wsToUpdate = new List < ws_call__c > (); List < ws_call__c > getFeelst = new List < ws_call__c > (); List < g_reqitem__c > updateReqItems = new List < g_reqitem__c > (); List < g_reqitem__c > riLst = new List < g_reqitem__c > (); datetime dt = system.now(); String tdy = dt.format('dd MMM,yyyy'); for (ws_call__c wc: lstwsCall) { String processPayment = 'Yes'; g_reqitem__c reqItem = GDRFAUtil.reqItem(wc.rq_itm__c); for (ws_call__c wsc: reqItem.WS_Calls__r) { if (wsc.mtd_nm__c == 'uploadSingleDocument' && (wsc.intsts__c == 'Failed' || wsc.intsts__c == 'Ready for Integration')) processPayment = 'No'; } if(reqItem.itm__r.cd__c == 'rp'){ List < g_reqitem__c > eidalLst = [select id, RQ__c from g_reqitem__c where RQ__c =: reqItem.RQ__c and itm__r.cd__c = 'ia' and Sta__r.cd__c in ('ok', 'ebn', 'okk', 'ebr') ]; if (eidalLst == null || eidalLst.isEmpty()) processPayment = 'No'; } if (wc.rq_itm__r.xf__c != null && processPayment == 'Yes') { String finputJson = '{"applicationId": "' + wc.rq_itm__r.xf__c + '","validate":"true"}'; String fendpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/fees'; HTTPResponse fres = GDRFAUtil.httpResponse(finputJson, fendpointUrl, 'POST', gApiToken); system.debug(fres.getBody()); ws_call__c fwc = new ws_call__c(); fwc.rq_itm__c = wc.rq_itm__r.id; fwc.ws_typ__c = 'Immigration EVEP'; fwc.mtd_nm__c = 'GetFee'; system.debug('fres.getStatusCode()'); system.debug(fres.getStatusCode()); if (fres.getStatusCode() == 200) { fwc.intsts__c = 'Success'; if (reqItem.itm__r.cd__c == 'la' || reqItem.itm__r.cd__c == 'rp' || reqItem.itm__r.cd__c == 'oua' || reqItem.itm__r.cd__c == 'oup' || reqItem.itm__r.cd__c == 'ins') { ImmigrationResponseWrapper.FeeResponse frec = (ImmigrationResponseWrapper.FeeResponse) System.JSON.deserialize(fres.getBody(), ImmigrationResponseWrapper.FeeResponse.class); List < ImmigrationResponseWrapper.Fees > feeLst = frec.fees; if (feeLst != null && !feeLst.isEmpty()) { for (ImmigrationResponseWrapper.Fees f: feeLst) { if (f.nameEn == 'Violation Fee' && f.isMandatory == true) { processPayment = 'No'; /* in case of fines  retuned for correction */ reqItem.sta__c = GDRFAUtil.statusId('rc', reqItem.Itm__c); reqItem.xr__c = 'Others'; decimal fineAmount = f.amount; decimal fineAmountSC = f.amount; String oldpermitNo = reqItem.RQ__r.e__c; String fileType = ''; if (String.isNotBlank(oldpermitNo)) { List < String > permitLst = oldpermitNo.split('/'); if ((integer.valueOf(permitLst[1]) < system.now().Year()) || permitLst[0] == '201') fileType = '2'; else fileType = '1'; } if (fileType == '1' && reqItem.itm__r.cd__c == 'la') { /* inncas  of visit visa*/ fineAmount = fineAmount + Decimal.valueOf(Label.GDRFAFineVisitVisa) + 280; fineAmountSC = fineAmountSC + Decimal.valueOf(Label.GDRFAFineVisitVisa); } else { fineAmount = fineAmount + Decimal.valueOf(Label.GDRFAFineResidenceVisa) + 280; fineAmountSC = fineAmountSC + Decimal.valueOf(Label.GDRFAFineResidenceVisa); } String fnnotes = 'A fine for overstaying has been levied against applicant, Please pay the fine at the earliest to avoid the daily fine increments.' + 'Fine amount to be paid AED: ' + fineAmount + ' as of: ' + tdy; reqItem.xcnotes__c = fnnotes; /*wc.intsts__c = 'Failed';*/ wc.err_msg__c = 'Fine Amount  to be paid AED: ' + fineAmount + ' as of: ' + tdy; reqItem.nt__c = 'Fine Amount : ' + fineAmount + ' as of: ' + tdy; List < g_reqitem__c > fnItmLst = new List < g_reqitem__c > (); fnItmLst = [select id, cN__c, AD__c from g_reqitem__c where RQ__c =: reqItem.RQ__c and itm__r.cd__c = 'fn']; if (fnItmLst != null && !fnItmLst.isEmpty() && fnItmLst[0].cN__c <= f.amount) { processPayment = 'No'; wc.err_msg__c = 'Fine Amount mismatch: ' + f.amount; reqItem.sta__c = GDRFAUtil.statusId('rc', reqItem.Itm__c); reqItem.xr__c = 'Others'; Decimal famt = f.amount + 280; fnnotes = 'An additional fine for overstaying has been levied against applicant, Please pay the fine at the earliest to avoid the daily fine increments.' + 'Fine amount to be paid AED: ' + famt + ' as of: ' + tdy; if (fnItmLst[0].AD__c <= 0) { fnnotes = 'An additional fine for overstaying has been levied against applicant, Please pay the fine at the earliest to avoid the daily fine increments.' + 'Fine amount to be paid AED: ' + (f.amount - fnItmLst[0].cN__c) + ' as of: ' + tdy; } reqItem.xcnotes__c = fnnotes; fnItmLst[0].cN__c = f.amount; /*updateReqItems.add(reqItem);*/ updateReqItems.add(fnItmLst[0]); reqItem.IsFines__c = true; } else if (fnItmLst != null && !fnItmLst.isEmpty() && fnItmLst[0].AD__c > 0) { fnnotes = 'A fine for overstaying has been levied against applicant, Please pay the fine at the earliest to avoid the daily fine increments.' + 'Fine amount to be paid AED: ' + fnItmLst[0].AD__c + ' as of: ' + tdy; reqItem.xcnotes__c = fnnotes; reqItem.IsFines__c = true; processPayment = 'No'; } else if ((fnItmLst != null && fnItmLst.size() == 0) && !reqItem.IsFinePaid__c && !reqItem.IsFines__c) { for (g_srvcitm__c i: [select id, Srv_Code__c, Req__c, dSTA__c, EXP__c, Name, vspexc__c, vst__c, vec__c, su__c, vsu__c, vesch__c, ngs__c, ngsXP__c, vsc__c, cd__c, srvc__c, Tp__c, rv__c, prcEdt__c, dcr__c, DscApp__c, KF__c, scN__c, vscp__c, cN__c, smN__c, slaN__c, vspc__c, spChN__c, spChXP__c, scXP__c, cXP__c, smXP__c, slaXP__c, dc__c, TAX_CODE__c, TAX_TYPE__c, extc__c, TAXCODE_SC__c, extcsc__c, (Select Id, cd__c, uid__c From Statuses__r where isDeleted = false and actv__c = true AND(cd__c = 'n')) From g_srvcitm__c where isDeleted = false and actv__c = true and srvc__c =: reqItem.RQ__r.Srvc__c AND cd__c = 'fn']) { riLst.add(new g_reqitem__c(Name = i.Name, itm__c = i.id, RQ__c = reqItem.RQ__c, m__c = null, rv__c = i.rv__c, vSTA__c = 'Verified', slaN__c = i.slaN__c, slaXP__c = i.slaXP__c, ngs__c = i.ngs__c, ngsXP__c = i.ngsXP__c, TAX_CODE__c = i.TAX_CODE__c, TAX_TYPE__c = i.TAX_TYPE__c, extc__c = i.extc__c, TAXCODE_SC__c = i.TAXCODE_SC__c, extcsc__c = i.extcsc__c, DscApp__c = i.DscApp__c, KF__c = i.KF__c, cN__c = fineAmountSC, cXP__c = i.cXP__c, smN__c = i.smN__c, smXP__c = i.smXP__c, scN__c = i.scN__c, scXP__c = i.scXP__c, vsc__c = i.vsc__c, vesch__c = i.vesch__c, vst__c = i.vst__c, vec__c = i.vec__c, su__c = i.su__c, vsu__c = i.vsu__c, sta__c = i.Statuses__r[0].Id, itmtp__c = i.Tp__c, xdcr__c = i.dcr__c, dc__c = i.dc__c)); } reqItem.IsFines__c = true; wc.sdt__c = system.now(); } wsToUpdate.add(wc); updateReqItems.add(reqItem); } } } } } else { fwc.intsts__c = 'Failed'; processPayment = 'No'; } fwc.rq_jsn__c = finputJson; fwc.res_jsn__c = fres.getBody(); getFeelst.add(fwc); } system.debug('processPayment:' + processPayment); } if (!getFeelst.isEmpty()) insert getFeelst; if (!wsToUpdate.isEmpty()) update wsToUpdate; if (!riLst.isEmpty()) insert riLst; if (!updateReqItems.isEmpty()) update updateReqItems; } catch (Exception e) { System.debug('Error in payment:>>>>> ' + e.getStackTraceString()); } }
    global void checkFinePayment(List < sObject > scope, String gApiToken) {
        try {
            List < ws_call__c > lstwsCall = (List < ws_call__c > ) scope;
            List < ws_call__c > wsToUpdate = new List < ws_call__c > ();
            List < ws_call__c > getFeelst = new List < ws_call__c > ();
            List < g_reqitem__c > updateReqItems = new List < g_reqitem__c > ();
            List < g_reqitem__c > riLst = new List < g_reqitem__c > ();
            datetime dt = system.now();
            String tdy = dt.format('dd MMM,yyyy');
            for (ws_call__c wc: lstwsCall) {
                String processPayment = 'Yes';
                g_reqitem__c reqItem = GDRFAUtil.reqItem(wc.rq_itm__c);
                for (ws_call__c wsc: reqItem.WS_Calls__r) {
                    if (wsc.mtd_nm__c == 'uploadSingleDocument' && (wsc.intsts__c == 'Failed' || wsc.intsts__c == 'Ready for Integration')) processPayment = 'No';
                }
                if (reqItem.itm__r.cd__c == 'rp') {
                    List < g_reqitem__c > eidalLst = [select id, RQ__c from g_reqitem__c where RQ__c =: reqItem.RQ__c and itm__r.cd__c = 'ia'
                        and Sta__r.cd__c in ('ok', 'ebn', 'okk', 'ebr')
                    ];
                    if (eidalLst == null || eidalLst.isEmpty()) processPayment = 'No';
                }
                if (wc.rq_itm__r.xf__c != null && processPayment == 'Yes') {
                    String finputJson = '{"applicationId": "' + wc.rq_itm__r.xf__c + '","validate":"true"}';
                    String fendpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/fees';
                    HTTPResponse fres = GDRFAUtil.httpResponse(finputJson, fendpointUrl, 'POST', gApiToken);
                    system.debug(fres.getBody());
                    ws_call__c fwc = new ws_call__c();
                    fwc.rq_itm__c = wc.rq_itm__r.id;
                    fwc.ws_typ__c = 'Immigration EVEP';
                    fwc.mtd_nm__c = 'GetFee';
                    system.debug('fres.getStatusCode()');
                    system.debug(fres.getStatusCode());
                    if (fres.getStatusCode() == 200) {
                        fwc.intsts__c = 'Success';
                        if (reqItem.itm__r.cd__c == 'la' || reqItem.itm__r.cd__c == 'rp' || reqItem.itm__r.cd__c == 'oua' || reqItem.itm__r.cd__c == 'oup' || reqItem.itm__r.cd__c == 'ins') {
                            ImmigrationResponseWrapper.FeeResponse frec = (ImmigrationResponseWrapper.FeeResponse) System.JSON.deserialize(fres.getBody(), ImmigrationResponseWrapper.FeeResponse.class);
                            List < ImmigrationResponseWrapper.Fees > feeLst = frec.fees;
                            if (feeLst != null && !feeLst.isEmpty()) {
                                for (ImmigrationResponseWrapper.Fees f: feeLst) {
                                    if (f.nameEn == 'Violation Fee' && f.isMandatory == true) {
                                        processPayment = 'No'; /* in case of fines  retuned for correction */
                                        reqItem.sta__c = GDRFAUtil.statusId('rc', reqItem.Itm__c);
                                        reqItem.xr__c = 'Others';
                                        decimal fineAmount = f.amount;
                                        decimal fineAmountSC = f.amount;
                                        String oldpermitNo = reqItem.RQ__r.e__c;
                                        String fileType = '';
                                        if (String.isNotBlank(oldpermitNo)) {
                                            List < String > permitLst = oldpermitNo.split('/');
                                            if ((integer.valueOf(permitLst[1]) < system.now().Year()) || permitLst[0] == '201') fileType = '2';
                                            else fileType = '1';
                                        }
                                        if (fileType == '1' && reqItem.itm__r.cd__c == 'la') {
                                            /* inncas  of visit visa*/
                                            fineAmount = fineAmount + Decimal.valueOf(Label.GDRFAFineVisitVisa) + 280;
                                            fineAmountSC = fineAmountSC + Decimal.valueOf(Label.GDRFAFineVisitVisa);
                                        } else {
                                            fineAmount = fineAmount + Decimal.valueOf(Label.GDRFAFineResidenceVisa) + 280;
                                            fineAmountSC = fineAmountSC + Decimal.valueOf(Label.GDRFAFineResidenceVisa);
                                        }
                                        String fnnotes = 'A fine for overstaying has been levied against applicant, Please pay the fine at the earliest to avoid the daily fine increments.' + 'Fine amount to be paid AED: ' + fineAmount + ' as of: ' + tdy;
                                        reqItem.xcnotes__c = fnnotes; /*wc.intsts__c = 'Failed';*/
                                        wc.err_msg__c = 'Fine Amount  to be paid AED: ' + fineAmount + ' as of: ' + tdy;
                                        reqItem.nt__c = 'Fine Amount : ' + fineAmount + ' as of: ' + tdy;
                                        List < g_reqitem__c > fnItmLst = new List < g_reqitem__c > ();
                                        fnItmLst = [select id, cN__c, AD__c from g_reqitem__c where RQ__c =: reqItem.RQ__c and itm__r.cd__c = 'fn'];
                                        if (fnItmLst != null && !fnItmLst.isEmpty() && fnItmLst[0].cN__c <= f.amount) {
                                            processPayment = 'No';
                                            wc.err_msg__c = 'Fine Amount mismatch: ' + f.amount;
                                            reqItem.sta__c = GDRFAUtil.statusId('rc', reqItem.Itm__c);
                                            reqItem.xr__c = 'Others';
                                            Decimal famt = f.amount + 280;
                                            fnnotes = 'An additional fine for overstaying has been levied against applicant, Please pay the fine at the earliest to avoid the daily fine increments.' + 'Fine amount to be paid AED: ' + famt + ' as of: ' + tdy;
                                            if (fnItmLst[0].AD__c <= 0) {
                                                fnnotes = 'An additional fine for overstaying has been levied against applicant, Please pay the fine at the earliest to avoid the daily fine increments.' + 'Fine amount to be paid AED: ' + (f.amount - fnItmLst[0].cN__c) + ' as of: ' + tdy;
                                            }
                                            reqItem.xcnotes__c = fnnotes;
                                            fnItmLst[0].cN__c = f.amount; /*updateReqItems.add(reqItem);*/
                                            updateReqItems.add(fnItmLst[0]);
                                            reqItem.IsFines__c = true;
                                        } else if (fnItmLst != null && !fnItmLst.isEmpty() && fnItmLst[0].AD__c > 0) {
                                            fnnotes = 'A fine for overstaying has been levied against applicant, Please pay the fine at the earliest to avoid the daily fine increments.' + 'Fine amount to be paid AED: ' + fnItmLst[0].AD__c + ' as of: ' + tdy;
                                            reqItem.xcnotes__c = fnnotes;
                                            reqItem.IsFines__c = true;
                                            processPayment = 'No';
                                        } else if ((fnItmLst != null && fnItmLst.size() == 0) && !reqItem.IsFinePaid__c && !reqItem.IsFines__c) {
                                            for (g_srvcitm__c i: [select id, Srv_Code__c, Req__c, dSTA__c, EXP__c, Name, vspexc__c, vst__c, vec__c, su__c, vsu__c, vesch__c, ngs__c, ngsXP__c, vsc__c, cd__c, srvc__c, Tp__c, rv__c, prcEdt__c, dcr__c, DscApp__c, KF__c, scN__c, vscp__c, cN__c, smN__c, slaN__c, vspc__c, spChN__c, spChXP__c, scXP__c, cXP__c, smXP__c, slaXP__c, dc__c, TAX_CODE__c, TAX_TYPE__c, extc__c, TAXCODE_SC__c, extcsc__c, (Select Id, cd__c, uid__c From Statuses__r where isDeleted = false and actv__c = true AND(cd__c = 'n')) From g_srvcitm__c where isDeleted = false and actv__c = true and srvc__c =: reqItem.RQ__r.Srvc__c AND cd__c = 'fn']) {
                                                riLst.add(new g_reqitem__c(Name = i.Name, itm__c = i.id, RQ__c = reqItem.RQ__c, m__c = null, rv__c = i.rv__c, vSTA__c = 'Verified', slaN__c = i.slaN__c, slaXP__c = i.slaXP__c, ngs__c = i.ngs__c, ngsXP__c = i.ngsXP__c, TAX_CODE__c = i.TAX_CODE__c, TAX_TYPE__c = i.TAX_TYPE__c, extc__c = i.extc__c, TAXCODE_SC__c = i.TAXCODE_SC__c, extcsc__c = i.extcsc__c, DscApp__c = i.DscApp__c, KF__c = i.KF__c, cN__c = fineAmountSC, cXP__c = i.cXP__c, smN__c = i.smN__c, smXP__c = i.smXP__c, scN__c = i.scN__c, scXP__c = i.scXP__c, vsc__c = i.vsc__c, vesch__c = i.vesch__c, vst__c = i.vst__c, vec__c = i.vec__c, su__c = i.su__c, vsu__c = i.vsu__c, sta__c = i.Statuses__r[0].Id, itmtp__c = i.Tp__c, xdcr__c = i.dcr__c, dc__c = i.dc__c));
                                            }
                                            reqItem.IsFines__c = true;
                                            wc.sdt__c = system.now();
                                        }
                                        wsToUpdate.add(wc);
                                        updateReqItems.add(reqItem);
                                    }
                                    if ((f.nameEn == 'Dubai Police Traffic Fines' || f.nameEn.toLowerCase().contains('traffic') || f.nameEn.toLowerCase().contains('traffic fines')) && f.isMandatory == true) {
                                        reqItem.sta__c = GDRFAUtil.statusId('rc', reqItem.Itm__c);
                                        reqItem.xr__c = 'Others';
                                        decimal fineAmount = f.amount;
                                        reqItem.xr__c = 'Others';
                                        Decimal famt = fineAmount;
                                        String fnnotes = 'Traffic fines of AED ' + famt + ' have been levied against the applicant by Dubai Police. Please ensure all outstanding fines are cleared to proceed and avoid delays in processing the visa application.';
                                        reqItem.xcnotes__c = fnnotes;
                                        wc.err_msg__c = fnnotes;
                                        if (processPayment == 'Yes') {
                                            /* to avoid duplicate updates*/
                                            wsToUpdate.add(wc);
                                            updateReqItems.add(reqItem);
                                        }
                                        processPayment = 'No'; /* in case of fines  retuned for correction */
                                        g_req__c rq = new g_req__c(id = reqItem.RQ__c, xrtaf__c = fnnotes);
                                        update rq;
                                    }
                                }
                            }
                        }
                    } else {
                        fwc.intsts__c = 'Failed';
                        processPayment = 'No';
                    }
                    fwc.rq_jsn__c = finputJson;
                    fwc.res_jsn__c = fres.getBody();
                    getFeelst.add(fwc);
                }
                system.debug('processPayment:' + processPayment);
            }
            if (!getFeelst.isEmpty()) insert getFeelst;
            if (!wsToUpdate.isEmpty()) update wsToUpdate;
            if (!riLst.isEmpty()) insert riLst;
            if (!updateReqItems.isEmpty()) update updateReqItems;
        } catch (Exception e) {
            System.debug('Error in payment:>>>>> ' + e.getStackTraceString());
        }
    }
    global String invokePrintVisa(g_reqitem__c reqItm, String gApiToken, String permitNo) {
        String processUpdate = '';
        try {
            if (String.isNotBlank(reqItm.xf__c)) {
                String inputJson = '{"applicationNumber": "' + reqItm.xf__c + '"}';
                String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/visa/generate';
                HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken);
                system.debug('inputJson:>>>>> ' + inputJson);
                system.debug('res:' + res.getBody());
                if (res.getStatusCode() == 200) {
                    processUpdate = 'Yes';
                    ApplicationDetailsWrapper.AttachmentJSON attJson = (ApplicationDetailsWrapper.AttachmentJSON) System.JSON.deserialize(res.getBody(), ApplicationDetailsWrapper.AttachmentJSON.class);
                    System.debug('attJson:>>>>> ' + attJson);
                    if (reqItm.itm__r.cd__c == 'ec' || reqItm.itm__r.cd__c == 'er') {
                        processUpdate = '';
                        HTTPResponse res1 = GDRFAUtil.ocrResponse(attJson.reportContentAsBase64String);
                        if (res1.getStatusCode() == 200) {
                            processUpdate = 'Yes';
                            system.debug('res11:' + res1.getBody());
                            Map < String, Object > results = (Map < String, Object > ) JSON.deserializeUntyped(res1.getBody());
                            Map < string, Object > prDtls = (Map < string, Object > ) results.get('data');
                            if (prDtls != null && (prDtls.containsKey('ID') || prDtls.containsKey('Date'))) {
                                List < Account > accLst = [select id, ec__c, ecidt__c, ecedt__c from Account where id =: reqItm.RQ__r.Acc__c];
                                if (accLst != null && !accLst.isEmpty()) {
                                    if (prDtls.containsKey('ID')) {
                                        String ec = (String) prDtls.get('ID');
                                        accLst[0].ec__c = ec;
                                    }
                                    if (prDtls.containsKey('Date')) {
                                        String ecExpDt = (String) prDtls.get('Date');
                                        if (String.isNotBlank(ecExpDt)) {
                                            accLst[0].ecedt__c = date.valueOf(ecExpDt);
                                            accLst[0].ecidt__c = (accLst[0].ecedt__c).addYears(-1).addDays(1);
                                        }
                                    }
                                    update accLst;
                                }
                            }
                        }
                    }
                    g_reqitemDoc__c ridoc = new g_reqitemDoc__c(id = reqItm.itmsDocs__r[0].id, Req__c = true, reqAts__c = true, mnAts__c = 1, mxAts__c = 1);
                    update ridoc;
                    if (attJson.reportContentAsBase64String != null) {
                        Attachment at = new Attachment(ParentId = reqItm.itmsDocs__r[0].reqDoc__c, Name = attJson.fileName, Body = EncodingUtil.base64Decode(attJson.reportContentAsBase64String), ContentType = 'application/pdf');
                        insert at;
                        System.debug('att:>>>>> ' + at.Id);
                        reqItm.xe__c = permitNo; /*map file no*/
                        update reqItm;
                    }
                }
            }
        } catch (Exception e) {
            processUpdate = 'No';
            System.debug('--line no-- ' + e.getStackTraceString());
            System.debug('--error msg-- ' + e.getMessage());
        }
        return processUpdate;
    }
    //global void getApplicationStatus(List < sObject > scope, String gApiToken) { try { List < g_reqitem__c > reqItems = (List < g_reqitem__c > ) scope; String processUpdate = ''; for (g_reqitem__c ri: reqItems) { if (String.isNotBlank(ri.xf__c)) { DateTime dT = ri.xat__c; String paymentDt = dT.format('yyyy-MM-dd'); String inputJson = '{"applicationNo":"' + ri.xf__c + '","transactionNo":"' + ri.xi__c + '","paymentDate":"' + paymentDt + '"}'; /*{"applicationNumber": "'+riDoc.reqItm__r.xf__c+'"}';*/ String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/statusInquiry'; HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken); system.debug('inputJson:>>>>> ' + inputJson); system.debug('res:' + res.getBody()); if (res.getStatusCode() == 200) { ImmigrationResponseWrapper.ApplicationStatus appStatus = (ImmigrationResponseWrapper.ApplicationStatus) System.JSON.deserialize(res.getBody(), ImmigrationResponseWrapper.ApplicationStatus.class); System.debug('applicationStatus:>>>>> ' + appStatus); if ((appStatus.StatesCode == 'APPROVED' || appStatus.StatesCode == 'COMPLETE' || appStatus.StatesCode == 'TOBEDELIVEREDPRINTED' || appStatus.StatesCode == 'SUCCESSFULLYDELIVERED')  && (ri.sta__r.cd__c == 'ii' || ri.sta__r.cd__c == 'dc' || ri.sta__r.cd__c == 'ok')) { ri.xargno__c = appStatus.FileNo; invokePrintVisa(ri, gApiToken, ''); processUpdate = 'Yes'; } else if (appStatus.StatesCode == 'APPROVED' && ri.sta__r.cd__c != 'ii') { ri.sta__c = GDRFAUtil.statusId('ii', ri.itm__c); /* for RP NEW and Renewal status to be marked as immigration approved*/ if (ri.itm__r.cd__c == 'rp') { ri.sta__c = GDRFAUtil.statusId('ca', ri.itm__c); } ri.xargno__c = appStatus.FileNo; /*if (ri.itm__r.cd__c == 'ep')*/ invokePrintVisa(ri, gApiToken, ''); processUpdate = 'Yes'; } else if (appStatus.StatesCode == 'REJECTED' && ri.sta__r.cd__c != 'ic') { /*if rejected invoke application details*/ ri.sta__c = GDRFAUtil.statusId('ic', ri.itm__c); HTTPResponse res1 = GDRFAUtil.httpResponse('{"applicationId" : "' + ri.xf__c + '"}', gU.csStr('GDRFAAPI') + '/scintegration/application/details', 'POST', gApiToken); System.debug('app details res:>>>>> ' + res1.getBody()); String respo = res1.getBody(); if (res1.getStatusCode() == 200) { String correctionNotes = 'REJECTED: '; Integer docNo = 1; ApplicationDetailsWrapper adw = (ApplicationDetailsWrapper) System.JSON.deserialize(respo, ApplicationDetailsWrapper.class); if (String.isNotBlank(adw.applicationStateComment)) correctionNotes += adw.applicationStateComment; ri.xcnotes__c = correctionNotes; } processUpdate = 'Yes'; } else if (appStatus.StatesCode == 'ADDITIONALDOCREQUIRED' && ri.sta__r.cd__c != 'ic') { ri.sta__c = GDRFAUtil.statusId('ic', ri.itm__c); String endpoint = gU.csStr('GDRFAAPI') + '/scintegration/application/' + ri.xf__c + '/documents'; HTTPResponse res2 = GDRFAUtil.httpResponse(null, endpoint, 'GET', gApiToken); System.debug('response:>>>>> ' + res2.getBody()); if (res.getStatusCode() == 200) { ImmigrationResponseWrapper documentsList = (ImmigrationResponseWrapper) System.JSON.deserialize(res2.getBody(), ImmigrationResponseWrapper.class); System.debug('docs wrapper: ' + documentsList); String correctionNotes = ''; String statusId; Integer docNo = 1; for (ImmigrationResponseWrapper.cls_DocumentsList reqDoc: documentsList.DocumentsList) { if (reqDoc.IsMandatory && String.isNotBlank(reqDoc.Reason)) { String docName = reqDoc.documentNameEn == 'Others Page 1' ? 'Education Certificate(Attested)' : reqDoc.documentNameEn.contains('Passport page 2') ? 'Passport Last Page' : reqDoc.documentNameEn.contains('Passport page 1') ? 'Passport Last Page' : reqDoc.documentNameEn; correctionNotes += String.valueOf(docNo) + '. ' + docName + ': ' + reqDoc.Reason + ';'; docNo++; } } correctionNotes = correctionNotes.removeEnd(';'); if (String.isNotBlank(correctionNotes)) ri.xcnotes__c = correctionNotes; } processUpdate = 'Yes'; } else if ((appStatus.StatesCode == 'INPROCESS' || appStatus.StatesCode == 'PAID') && ri.sta__r.cd__c != 'if') { ri.sta__c = GDRFAUtil.statusId('if', ri.itm__c); processUpdate = 'Yes'; } else if ((appStatus.StatesCode == 'INPROCESSATMOFA' || appStatus.StatesCode == 'DENIED' || appStatus.StatesCode == 'BLACKLISTPENDING' || appStatus.StatesCode == 'VISITREQUIRED') && ri.sta__r.cd__c != 'ic') { ri.sta__c = GDRFAUtil.statusId('ic', ri.itm__c); ri.xcnotes__c = appStatus.StatesCode; processUpdate = 'Yes'; } } } } if (processUpdate == 'Yes') update reqItems; } catch (Exception e) { System.debug('--line no-- ' + e.getStackTraceString()); System.debug('--error-- ' + e.getLineNumber()); } }
    global void getApplicationStatus(List < sObject > scope, String gApiToken) {
        try {
            List < g_reqitem__c > reqItems = (List < g_reqitem__c > ) scope;
            List < g_reqitem__c > newItms = new List < g_reqitem__c > ();
            List < g_reqitem__c > uItms = new List < g_reqitem__c > ();
            List < g_req__c > reqLst = new List < g_req__c > ();
            String processUpdate = '';
            for (g_reqitem__c ri: reqItems) {
                if (String.isNotBlank(ri.xf__c)) {
                    DateTime dT = ri.xat__c;
                    String paymentDt = dT.format('yyyy-MM-dd');
                    String inputJson = '{"applicationNo":"' + ri.xf__c + '","transactionNo":"' + ri.xi__c + '","paymentDate":"' + paymentDt + '"}'; /*{"applicationNumber": "'+riDoc.reqItm__r.xf__c+'"}';*/
                    String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/statusInquiry';
                    HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken);
                    system.debug('inputJson:>>>>> ' + inputJson);
                    system.debug('res:' + res.getBody());
                    if (res.getStatusCode() == 200) {
                        ImmigrationResponseWrapper.ApplicationStatus appStatus = (ImmigrationResponseWrapper.ApplicationStatus) System.JSON.deserialize(res.getBody(), ImmigrationResponseWrapper.ApplicationStatus.class);
                        System.debug('applicationStatus:>>>>> ' + appStatus);
                        if ((appStatus.StatesCode == 'APPROVED' || appStatus.StatesCode == 'COMPLETE' || appStatus.StatesCode == 'TOBEDELIVEREDPRINTED' || appStatus.StatesCode == 'SUCCESSFULLYDELIVERED') && (ri.sta__r.cd__c == 'ii' || ri.sta__r.cd__c == 'dc' || ri.sta__r.cd__c == 'ok' || ri.sta__r.cd__c == 'okk')) {
                            ri.xargno__c = appStatus.FileNo;
                            processUpdate = invokePrintVisa(ri, gApiToken, ''); /*processUpdate = 'Yes';*/
                        } else if (appStatus.StatesCode == 'APPROVED' && ri.sta__r.cd__c != 'ii') {
                            ri.sta__c = GDRFAUtil.statusId('ii', ri.itm__c); /* for RP NEW and Renewal status to be marked as immigration approved*/
                            if (ri.itm__r.cd__c == 'la') {
                                ri.xlid__c = Date.today();
                                uItms = [select id, itm__c, sta__c, xiid__c, xied__c, xjd__c from g_reqitem__c where RQ__c =: ri.RQ__c and itm__r.cd__c = 'id'];
                                if (uItms != null && !uItms.isEmpty()) {
                                    uItms[0].sta__c = GDRFAUtil.statusId('g', uItms[0].itm__c);
                                    uItms[0].xiid__c = Date.today();
                                    uItms[0].xjd__c = Date.today();
                                    if (gu.csStr('RP_3YRS').contains(ri.itm__r.Srvc__r.uid__c)) {
                                        uItms[0].xied__c = Date.today().addYears(2).addDays(-1);
                                    }
                                    if (gu.csStr('RP_1YRS').contains(ri.itm__r.Srvc__r.uid__c)) {
                                        uItms[0].xied__c = Date.today().addYears(1).addDays(-1);
                                    }
                                }
                            }
                            if (ri.itm__r.cd__c == 'ep') {
                                ri.sta__c = GDRFAUtil.statusId('ok', ri.itm__c);
                            }
                            if (ri.itm__r.cd__c == 'rp') {
                                reqLst.add(new g_Req__c(id = ri.RQ__c, STA__c = 'Completed'));
                                ri.sta__c = GDRFAUtil.statusId('okk', ri.itm__c);
                                uItms = [select id, itm__c, sta__c, xiid__c, xied__c, xjd__c from g_reqitem__c where RQ__c =: ri.RQ__c and itm__r.cd__c = 'id'
                                    and sta__r.cd__c = 'n'
                                ];
                                if (uItms != null && !uItms.isEmpty()) {
                                    uItms[0].sta__c = GDRFAUtil.statusId('g', uItms[0].itm__c);
                                    uItms[0].xjd__c = Date.today();
                                    if (gu.csStr('RP_3YRS').contains(ri.itm__r.Srvc__r.uid__c)) {
                                        uItms[0].xied__c = Date.today().addYears(2).addDays(-1);
                                    }
                                    if (gu.csStr('RP_1YRS').contains(ri.itm__r.Srvc__r.uid__c)) {
                                        uItms[0].xied__c = Date.today().addYears(1).addDays(-1);
                                    }
                                }
                            }
                            if (ri.itm__r.cd__c == 'ins' || ri.itm__r.cd__c == 'oua' || ri.itm__r.cd__c == 'oup') {
                                ri.sta__c = GDRFAUtil.statusId('ok', ri.itm__c);
                                ri.xrcd__c = Date.today();
                            }
                            if (ri.itm__r.cd__c == 'ec' || ri.itm__r.cd__c == 'er') {
                                reqLst.add(new g_Req__c(id = ri.RQ__c, STA__c = 'Completed'));
                                ri.sta__c = GDRFAUtil.statusId('ok', ri.itm__c);
                            }
                            if (ri.itm__r.cd__c == 'ins') {
                                reqLst.add(new g_Req__c(id = ri.RQ__c, STA__c = 'Open'));
                            }
                            if (ri.itm__r.cd__c == 'oua' || ri.itm__r.cd__c == 'oup') {
                                reqLst.add(new g_Req__c(id = ri.RQ__c, STA__c = 'Completed'));
                            }
                            ri.xargno__c = appStatus.FileNo; /*if (ri.itm__r.cd__c == 'ep')*/
                            processUpdate = invokePrintVisa(ri, gApiToken, '');
                            if (ri.itm__r.cd__c == 'ins') {
                                for (g_srvcitm__c i: [select id, Name, vspexc__c, vst__c, vec__c, su__c, vsu__c, vesch__c, ngs__c, ngsXP__c, vsc__c, cd__c, srvc__c, Tp__c, rv__c, prcEdt__c, dcr__c, DscApp__c, KF__c, scN__c, vscp__c, cN__c, smN__c, slaN__c, spChN__c, spChXP__c, scXP__c, cXP__c, smXP__c, slaXP__c, dc__c, TAX_CODE__c, TAX_TYPE__c, extc__c, TAXCODE_SC__c, extcsc__c, (Select Id From Statuses__r where isDeleted = false and cd__c = 'pp'
                                        limit 1) From g_srvcitm__c where isDeleted = false and actv__c = true and Srvc__r.uid__c =: ri.itm__r.Srvc__r.uid__c AND cd__c = 'cx']) {
                                    newItms.add(new g_reqitem__c(Name = i.Name, RQ__c = ri.RQ__c, itm__c = i.Id, sta__c = i.Statuses__r[0].Id, itmtp__c = i.Tp__c, DscApp__c = i.DscApp__c, exp__c = false, KF__c = i.KF__c, scN__c = 0, xdcr__c = i.dcr__c, cN__c = i.cN__c, smN__c = i.smN__c, slaN__c = i.slaN__c, scXP__c = i.scXP__c, cXP__c = i.cXP__c, smXP__c = i.smXP__c, slaXP__c = i.slaXP__c, dc__c = i.dc__c, vsc__c = 0, TAX_CODE__c = i.TAX_CODE__c, TAX_TYPE__c = i.TAX_TYPE__c, extc__c = i.extc__c, TAXCODE_SC__c = i.TAXCODE_SC__c, extcsc__c = i.extcsc__c));
                                }
                            } /*processUpdate = 'Yes';*/
                        } else if (appStatus.StatesCode == 'REJECTED' && ri.sta__r.cd__c != 'ic') {
                            /*if rejected invoke application details*/
                            ri.sta__c = GDRFAUtil.statusId('ic', ri.itm__c);
                            HTTPResponse res1 = GDRFAUtil.httpResponse('{"applicationId" : "' + ri.xf__c + '"}', gU.csStr('GDRFAAPI') + '/scintegration/application/details', 'POST', gApiToken);
                            System.debug('app details res:>>>>> ' + res1.getBody());
                            String respo = res1.getBody();
                            if (res1.getStatusCode() == 200) {
                                String correctionNotes = 'REJECTED: ';
                                Integer docNo = 1;
                                ApplicationDetailsWrapper adw = (ApplicationDetailsWrapper) System.JSON.deserialize(respo, ApplicationDetailsWrapper.class);
                                if (String.isNotBlank(adw.applicationStateComment)) correctionNotes += adw.applicationStateComment;
                                ri.xcnotes__c = correctionNotes;
                            }
                            processUpdate = 'Yes';
                        } else if (appStatus.StatesCode == 'ADDITIONALDOCREQUIRED' && ri.sta__r.cd__c != 'ic') {
                            ri.sta__c = GDRFAUtil.statusId('ic', ri.itm__c);
                            String endpoint = gU.csStr('GDRFAAPI') + '/scintegration/application/' + ri.xf__c + '/documents';
                            HTTPResponse res2 = GDRFAUtil.httpResponse(null, endpoint, 'GET', gApiToken);
                            System.debug('response:>>>>> ' + res2.getBody());
                            if (res.getStatusCode() == 200) {
                                ImmigrationResponseWrapper documentsList = (ImmigrationResponseWrapper) System.JSON.deserialize(res2.getBody(), ImmigrationResponseWrapper.class);
                                System.debug('docs wrapper: ' + documentsList);
                                String correctionNotes = '';
                                String statusId;
                                Integer docNo = 1;
                                for (ImmigrationResponseWrapper.cls_DocumentsList reqDoc: documentsList.DocumentsList) {
                                    if (reqDoc.IsMandatory && String.isNotBlank(reqDoc.Reason)) {
                                        String docName = reqDoc.documentNameEn == 'Others Page 1' ? 'Education Certificate(Attested)' : reqDoc.documentNameEn.contains('Passport page 2') ? 'Passport Last Page' : reqDoc.documentNameEn.contains('Passport page 1') ? 'Passport Last Page' : reqDoc.documentNameEn;
                                        correctionNotes += String.valueOf(docNo) + '. ' + docName + ': ' + reqDoc.Reason + ';';
                                        docNo++;
                                    }
                                }
                                correctionNotes = correctionNotes.removeEnd(';');
                                if (String.isNotBlank(correctionNotes)) ri.xcnotes__c = correctionNotes;
                            }
                            processUpdate = 'Yes';
                        } else if ((appStatus.StatesCode == 'INPROCESS' || appStatus.StatesCode == 'PAID') && ri.sta__r.cd__c != 'if') {
                            ri.sta__c = GDRFAUtil.statusId('if', ri.itm__c);
                            processUpdate = 'Yes';
                        } else if ((appStatus.StatesCode == 'INPROCESSATMOFA' || appStatus.StatesCode == 'DENIED' || appStatus.StatesCode == 'VISITREQUIRED') && ri.sta__r.cd__c != 'ic') {
                            ri.sta__c = GDRFAUtil.statusId('ic', ri.itm__c);
                            ri.xcnotes__c = appStatus.StatesCode;
                            processUpdate = 'Yes';
                        }
                    }
                }
            }
            if (processUpdate == 'Yes') {
                if (uItms != null && !uItms.isEmpty()) {
                    reqItems.addAll(uItms);
                }
                update reqItems;
            }
            if (processUpdate == 'Yes' && newItms != null && !newItms.isEmpty()) {
                insert newItms;
            }
            if (processUpdate == 'Yes' && reqLst != null && !reqLst.isEmpty()) {
                update reqLst;
            }
        } catch (Exception e) {
            System.debug('--line no-- ' + e.getStackTraceString());
            System.debug('--error-- ' + e.getLineNumber());
        }
    }
    public void updateArabicDetails(g_reqitem__c ri, Contact con, String gApiToken, boolean stsUpdateFlg) {
        try {
            String firstNameAr = '', middleNameAr = '', lastNameAr = '', motherNameAr = '';
            if (con != null && String.isNotBlank(con.lastname)) {
                if (String.isNotBlank(con.firstname) && con.firstname != con.fnar__c && (String.isBlank(con.fnar__c) || (con.fnar__c).length() == 1)) {
                    firstNameAr = GDRFAUtil.engToArabicStr(con.firstname, gApiToken);
                }
                if (String.isNotBlank(con.lastname) && con.lastname != con.lnar__c && (String.isBlank(con.lnar__c) || (con.lnar__c).length() == 1)) {
                    lastNameAr = GDRFAUtil.engToArabicStr(con.lastname, gApiToken);
                }
                if (String.isNotBlank(con.mn__c) && con.mn__c != con.mnar__c && (String.isBlank(con.mnar__c) || (con.mnar__c).length() == 1)) {
                    middleNameAr = GDRFAUtil.engToArabicStr(con.mn__c, gApiToken);
                }
                if (String.isNotBlank(con.mon__c) && con.mon__c != con.mona__c && (String.isBlank(con.mona__c) || (con.mona__c).length() == 1)) {
                    motherNameAr = GDRFAUtil.engToArabicStr(con.mon__c, gApiToken);
                }
                if (String.isNotBlank(firstNameAr)) con.fnar__c = firstNameAr;
                if (String.isNotBlank(lastNameAr)) con.lnar__c = lastNameAr;
                if (String.isNotBlank(middleNameAr)) con.mnar__c = middleNameAr;
                if (String.isNotBlank(motherNameAr)) con.mona__c = motherNameAr;
                if (stsUpdateFlg) {
                    if (String.isNotBlank(firstNameAr)) ri.xcfnar__c = firstNameAr;
                    if (String.isNotBlank(lastNameAr)) ri.xclnar__c = lastNameAr;
                    if (String.isNotBlank(middleNameAr)) ri.xcmnar__c = middleNameAr;
                    ri.sta__c = GDRFAUtil.statusId('ok', ri.itm__c);
                    updateEntryPermitDetails(ri, gApiToken);
                    update ri;
                    g_Req__c r = [select id, STA__c, xcfnar__c, xclnar__c, xcmnar__c from g_Req__c where id =: ri.RQ__c];
                    r.STA__c = 'In Process';
                    if (String.isNotBlank(firstNameAr)) r.xcfnar__c = firstNameAr;
                    if (String.isNotBlank(lastNameAr)) r.xclnar__c = lastNameAr;
                    if (String.isNotBlank(middleNameAr)) r.xcmnar__c = middleNameAr;
                    update r;
                    if (String.isNotBlank(ri.xe__c)) {
                        con.e__c = ri.xe__c;
                        con.eid__c = ri.xeid__c;
                        con.eed__c = ri.xeed__c;
                        con.epui__c = ri.xui__c;
                        con.rpui__c = ri.xui__c;
                    }
                }
                update con;
            }
        } catch (Exception e) {
            System.debug('--line no-- ' + e.getStackTraceString());
            System.debug('--error msg-- ' + e.getMessage());
        }
    }
    public void updateEntryPermitDetails(g_reqitem__c reqItm, String gApiToken) {
        try {
            if (String.isNotBlank(reqItm.xf__c)) {
                String inputJson = '{"applicationNumber": "' + reqItm.xf__c + '"}';
                String endpointUrl = gU.csStr('GDRFAAPI') + '/scintegration/application/visa/generate';
                HTTPResponse res = GDRFAUtil.httpResponse(inputJson, endpointUrl, 'POST', gApiToken);
                system.debug('inputJson:>>>>> ' + inputJson);
                system.debug('res:' + res.getBody());
                ApplicationDetailsWrapper.AttachmentJSON attJson = null;
                if (res.getStatusCode() == 200) {
                    attJson = (ApplicationDetailsWrapper.AttachmentJSON) System.JSON.deserialize(res.getBody(), ApplicationDetailsWrapper.AttachmentJSON.class);
                    System.debug('attJson:>>>>> ' + attJson);
                }
                if (attJson != null && attJson.reportContentAsBase64String != null) {
                    HttpRequest req = New HttpRequest();
                    req.setHeader('Content-Type', 'application/json');
                    req.setHeader('Cache-Control', 'no-cache');
                    req.setHeader('x-api-key', gU.csStr('OCR_APIKEY'));
                    req.setTimeout(90000);
                    req.setMethod('POST');
                    req.setBody('{"image":"' + attJson.reportContentAsBase64String + '"}');
                    req.setEndpoint(gU.csStr('OCR_ENDPOINT'));
                    Http http = new Http();
                    system.debug('Grant type header set');
                    HTTPResponse res1 = http.send(req);
                    if (res1.getStatusCode() == 200) {
                        system.debug('res11:' + res1.getBody()); /*String str = '{"data":{"ENTRY PERMIT NO":"201/2019/7419758 ","Nationality":"AUSTRALIA ","Date of Birth":"20/12/1982 ","Place of Birth":"FITZROY ","Allowed to Enter":"U.AE to : ","Full Name":"SARA MILIONICO ","Valid Until":"15/02/2020 ","Profession":"DIRECTOR OF SALES AND MARKETING ","Passport No":". Normal / PA7952728 "},"type":"Not a valid file rescan it again","type_id":"LOW_CONFIDENCE_SCAN","confidence_level":0.3835193624233828,"ocr_engine":"aws"}';*/
                        Map < String, Object > results = (Map < String, Object > ) JSON.deserializeUntyped(res1.getBody());
                        Map < string, Object > epDtls = (Map < string, Object > ) results.get('data');
                        if (epDtls != null && epDtls.containsKey('ENTRY PERMIT NO')) {
                            String epNo = (String) epDtls.get('ENTRY PERMIT NO');
                            reqItm.xe__c = epNo.trim();
                            String uid = (String) epDtls.get('UID');
                            reqItm.xui__c = uid.trim();
                            String validfrom = (String) epDtls.get('DOI');
                            if (String.isBlank(validfrom)) validfrom = (String) epDtls.get('Date & Place Of Issue');
                            if (String.isNotBlank(validfrom)) {
                                validfrom = validfrom.split(' ')[0];
                                reqItm.xeid__c = GDRFAUtil.strtoDate(validfrom.replace('-', '/'));
                            } else reqItm.xeid__c = Date.today();
                            String validUntil = (String) epDtls.get('Valid Until');
                            if (String.isNotBlank(validUntil)) reqItm.xeed__c = GDRFAUtil.strtoDate(validUntil.replace('-', '/'));
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.debug('--line no-- ' + e.getStackTraceString());
            System.debug('--error msg-- ' + e.getMessage());
        }
    }
    public void updatePermit(g_reqitem__c ri, Contact con, String gApiToken, String parseDoc) {
        try {
            List < attachment > attList = new List < attachment > ();
            if (con != null) {
                if (parseDoc.contains('Residence')) {
                    attList = [select id, body from attachment where parentid in (select id from g_reqDoc__c where RQ__c =: ri.RQ__c and(Name = 'Residence permit copy'
                        or Name = 'Residence Permit')) order by createddate desc limit 1];
                } else {
                    attList = [select id, body from attachment where parentid in (select id from g_reqDoc__c where RQ__c =: ri.RQ__c and name =: parseDoc) order by createddate desc limit 1];
                }
                if (attList != null && !attList.isEmpty()) {
                    ApplicationDetailsWrapper.AttachmentJSON attJson = new ApplicationDetailsWrapper.AttachmentJSON();
                    attJson.reportContentAsBase64String = EncodingUtil.base64Encode(attList[0].body);
                    if (attJson != null && attJson.reportContentAsBase64String != null) {
                        HttpRequest req = New HttpRequest();
                        req.setHeader('Content-Type', 'application/json');
                        req.setHeader('Cache-Control', 'no-cache');
                        req.setHeader('x-api-key', gU.csStr('OCR_APIKEY'));
                        req.setTimeout(90000);
                        req.setMethod('POST');
                        req.setBody('{"image":"' + attJson.reportContentAsBase64String + '"}');
                        req.setEndpoint(gU.csStr('OCR_ENDPOINT'));
                        Http http = new Http();
                        system.debug('Grant type header set');
                        HTTPResponse res1 = http.send(req);
                        if (res1.getStatusCode() == 200) {
                            system.debug('res11:' + res1.getBody()); /*String str = '{"data":{"ENTRY PERMIT NO":"201/2019/7419758 ","Nationality":"AUSTRALIA ","Date of Birth":"20/12/1982 ","Place of Birth":"FITZROY ","Allowed to Enter":"U.AE to : ","Full Name":"SARA MILIONICO ","Valid Until":"15/02/2020 ","Profession":"DIRECTOR OF SALES AND MARKETING ","Passport No":". Normal / PA7952728 "},"type":"Not a valid file rescan it again","type_id":"LOW_CONFIDENCE_SCAN","confidence_level":0.3835193624233828,"ocr_engine":"aws"}';*/
                            Map < String, Object > results = (Map < String, Object > ) JSON.deserializeUntyped(res1.getBody());
                            Map < string, Object > prDtls = (Map < string, Object > ) results.get('data');
                            if (prDtls != null && prDtls.containsKey('ENTRY PERMIT NO')) {
                                String epNo = (String) prDtls.get('ENTRY PERMIT NO');
                                ri.xe__c = epNo.trim();
                                String uid = (String) prDtls.get('UID');
                                ri.xui__c = uid.trim();
                                String validfrom = (String) prDtls.get('DOI');
                                if (String.isBlank(validfrom)) validfrom = (String) prDtls.get('Date & Place Of Issue');
                                if (String.isNotBlank(validfrom)) {
                                    validfrom = validfrom.split(' ')[0];
                                    ri.xeid__c = GDRFAUtil.strtoDate(validfrom.replace('-', '/'));
                                } else ri.xeid__c = Date.today();
                                String validUntil = (String) prDtls.get('Valid Until');
                                if (String.isNotBlank(validUntil)) ri.xeed__c = GDRFAUtil.strtoDate(validUntil.replace('-', '/'));
                            }
                            if (prDtls != null && prDtls.containsKey('File #')) {
                                String rpNo = (String) prDtls.get('File #');
                                if (rpNo != null) {
                                    ri.xrp__c = rpNo.trim();
                                }
                                String uid = (String) prDtls.get('UID');
                                if (uid != null) {
                                    ri.xui__c = uid.trim();
                                }
                                String validfrom = (String) prDtls.get('Date of Issue');
                                if (validfrom != null) {
                                    ri.xrpid__c = Date.valueOf(validfrom.replace('/', '-'));
                                } else {
                                    ri.xrpid__c = Date.today();
                                }
                                String validUntil = (String) prDtls.get('Date of Expiry');
                                if (String.isNotBlank(validUntil)) {
                                    Date dt1 = Date.today();
                                    Date expDt = Date.valueOf(validUntil.replace('/', '-'));
                                    if (expDt.year() <= dt1.year()) {
                                        ri.xrpid__c = expDt;
                                        if (gu.csStr('RP_3YRS').contains(ri.RQ__r.Srvc__r.uid__c)) {
                                            ri.xrped__c = expDt.addYears(2).addDays(-1);
                                        }
                                        if (gu.csStr('RP_1YRS').contains(ri.RQ__r.Srvc__r.uid__c)) {
                                            ri.xrped__c = expDt.addYears(1).addDays(-1);
                                        }
                                    } else if (expDt.year() > dt1.year()) {
                                        ri.xrped__c = expDt;
                                    }
                                } else {
                                    if (gu.csStr('RP_3YRS').contains(ri.RQ__r.Srvc__r.uid__c)) {
                                        ri.xrped__c = date.today().addYears(2).addDays(-1);
                                    }
                                    if (gu.csStr('RP_1YRS').contains(ri.RQ__r.Srvc__r.uid__c)) {
                                        ri.xrped__c = date.today().addYears(1).addDays(-1);
                                    }
                                }
                            }
                        }
                    }
                    update ri;
                    if (String.isNotBlank(ri.xe__c) && ri.itm__r.cd__c == 'ep') {
                        con.e__c = ri.xe__c;
                        con.eid__c = ri.xeid__c;
                        con.eed__c = ri.xeed__c;
                        con.epui__c = ri.xui__c;
                        con.rpui__c = ri.xui__c;
                    }
                    if (String.isNotBlank(ri.xrp__c) && ri.itm__r.cd__c == 'rp') {
                        con.rp__c = ri.xrp__c;
                        con.rpid__c = ri.xrpid__c;
                        con.rped__c = ri.xrped__c;
                        con.rpui__c = ri.xui__c;
                    }
                    update con;
                }
            }
        } catch (Exception e) {
            System.debug('--line no11-- ' + e.getStackTraceString());
            System.debug('--error msg11-- ' + e.getMessage());
        }
    }
    /* public string  getUID(g_reqitem__c ri,String gApiToken,Map<String,Map<String,String>> getLookupIdByTypeNname) { string resStr = ''; try{ HttpRequest req = New HttpRequest(); req.setHeader('Content-Type', 'application/json'); /* move API to SETTIN req.setHeader('Apikey',gU.csStr('GDRFAAPIKey')); req.setHeader('Cache-Control', 'no-cache'); req.setHeader('Authorization', 'Bearer '+gApiToken); req.setHeader('AcceptLanguage', 'en-US'); req.setTimeout(90000); req.setMethod('POST'); string passportNo = ri.RQ__r.xcp__c.replaceAll('[^a-zA-Z0-9\\s]', '').replaceAll( '\\s+', '').toUpperCase(); integer birthYear = ri.RQ__r.xcbd__c.year(); integer nationalityId = ri.RQ__r.xcnc__c != null ? integer.valueOf(getLookupIdByTypeNname.get('Country').get(ri.RQ__r.xcnc__c.toUpperCase())) : 1; String inputJson = '{"passportNo":"'+passportNo+'","nationalityId": '+nationalityId+',"YearOfBirth":'+birthYear+'}';  req.setBody('{"passportNo":"N9761156","nationalityId":701,"YearOfBirth":1988}'); req.setEndpoint(gU.csStr('GDRFAAPI')+'/scintegration/inquiry/individual/details'); Http http = new Http(); system.debug('Grant type header set'); HTTPResponse res = http.send(req); system.debug('res:'+res.getBody()); if(res.getStatusCode()==200) { ImmigrationResponseWrapper irw = (ImmigrationResponseWrapper) System.JSON.deserialize(res.getBody(), ImmigrationResponseWrapper.class); if(irw != null && irw.IndividualProfile != null) resStr =  irw.IndividualProfile.UDBNo; } }catch(Exception e) { System.debug('--line no-- '+e.getStackTraceString());System.debug('--error-- '+e.getLineNumber()); } return resStr; }*/
    global void finish(Database.BatchableContext BC) {}
}