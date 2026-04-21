global class BatchSTAHIS implements Database.Batchable < sObject > {
    public String queryString;
    public static Boolean isBatchUpdate = false;
    private static BusinessHours bsHour;
    public BatchSTAHIS() {
    }
    public BatchSTAHIS(String mm) {
        this();
        queryString ='select itm__r.itm__r.srvc__r.uid__c, itm__c, RQ__c, statype__c, SLA_Action__c, Milestone__c, staowner__c, acts__c' +
            ', actE__c, estE__c, sla__c, Duration__c, cd__c, f__c, t__c from g_itmHistorySTA__c' +
                ' where t__r.Name=\'Medically Fit\'  and itm__r.itm__r.srvc__r.uid__c in (\'192\', \'055\', \'040\', \'002\', \'010\', \'189\', \'015\', \'191\', \'193\', \'004\', \'027\', \'028\', \'026\', \'106\', \'078\', \'080\', \'105\', \'081\', \'021\', \'020\', \'003\', \'025\', \'190\', \'016\', \'001\', \'188\')' +
            ' and CALENDAR_YEAR(createddate)=2019 and CALENDAR_MONTH(createddate)='+mm;
        system.debug(queryString);
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(queryString);
    }
    public void execute(Database.BatchableContext bc, List < g_itmHistorySTA__c > mdLst) {
        try {
            system.debug('getQueryLocator1');
            if (bsHour == null) {
                bsHour = [SELECT Id FROM BusinessHours WHERE id =: gU.csStr('BH')];
            }
            Map<String, String> sMap=new Map<String, String>();
            List<g_srvcitm_Status__c> stLst=[SELECT Id, itm__c FROM g_srvcitm_Status__c WHERE cd__c='mf'];
            for (g_srvcitm_Status__c s :stLst) {
                sMap.put(s.itm__c, s.id);
            }
            Map<String, g_itmHistorySTA__c > mapMD=new Map<String, g_itmHistorySTA__c >();
            for (g_itmHistorySTA__c s :mdLst) {
                mapMD.put(s.RQ__c, s);
            }
            List<g_itmHistorySTA__c> rpLst=[select itm__r.itm__r.srvc__r.uid__c, itm__c, RQ__c,
                statype__c, SLA_Action__c, Milestone__c, staowner__c, acts__c , actE__c, estE__c,
                sla__c, Duration__c, cd__c, f__c, t__c from g_itmHistorySTA__c where t__r.cd__c='if'  and itm__r.itm__r.srvc__r.uid__c in ('192',
                '055', '040', '002', '010', '189', '015', '191', '193', '004', '027', '028', '026',
                '106', '078', '080', '105', '081', '021', '020', '003', '025', '190', '016', '001',
                '188') and itm__r.itm__r.cd__c in ('rp', 'rt', 'trp') and RQ__c in :mapMD.keySet()];
            List<g_itmHistorySTA__c> newRPLST= new List<g_itmHistorySTA__c>();
            for (g_itmHistorySTA__c rp :rpLst) {
                String sid=sMap.get(rp.itm__r.itm__c);
                g_itmHistorySTA__c nRp=rp.clone(false, false, false, false);
                g_itmHistorySTA__c md=mapMD.get(rp.RQ__c);
                nRp.f__c=sid;
                nRp.acts__c=md.actE__c;
                Double cd= MilestnH.calculateDuration(md.actE__c, nRp.actE__c, bsHour.id);
                nRp.cd__c=cd;
                nRp.Duration__c=cd;
                newRPLST.add(nRp);
            }
            if (Schema.sObjectType.g_itmHistorySTA__c.isCreateable()) {
                insert newRPLST;
            }
        }
        catch (Exception e) {
            system.debug('getQueryLocator2');
            system.debug(e.getStackTraceString());
        }
    }
    public void finish(Database.BatchableContext bc) {
    }
}