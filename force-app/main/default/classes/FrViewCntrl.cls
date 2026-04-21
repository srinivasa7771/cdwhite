public class FrViewCntrl {
    public transient String selStat { get; set; }
    public List<g_Req__c> reqList {get;set;}

    public PageReference queryReq() {
        system.debug('queryReq::::');
        system.debug('selStat::::'+selStat);
        String srvCode='322';
        if (selStat != null && selStat != '-None-') {
            if (selStat == 'l90') {
                reqList= [SELECT name, Full_Name__c, xcp__c, xcnc__c, sta__c, Account_Name__c, srvc__r.name,
                    xceml__c, AP__c, AUP__c, os__c, ldmob__c, onhold__c, CreatedDate, bprk__c, PRM_Name__c,
                    PRM_Email__c, cldt__c, clcnt__c     FROM g_Req__c WHERE acc__r.lc__c !=:Label.Onboarding_Account_LC and  sta__c IN ('Open',
                    'Draft') AND CreatedDate <LAST_90_DAYS  AND Service_Code__c =: srvCode and xcebr__c=false and (onhold__c=true or clcnt__c=null or clcnt__c<2) order by  CreatedDate desc  limit 1500];
            }else if (selStat == 'g90') {
                reqList= [SELECT name, Full_Name__c, xcp__c, xcnc__c, sta__c, Account_Name__c, srvc__r.name,
                    xceml__c, AP__c, AUP__c, os__c, ldmob__c, onhold__c, CreatedDate, bprk__c, PRM_Name__c,
                    PRM_Email__c, cldt__c, clcnt__c     FROM g_Req__c WHERE acc__r.lc__c !=:Label.Onboarding_Account_LC and sta__c IN ('Open',
                    'Draft') AND CreatedDate=LAST_90_DAYS  AND Service_Code__c =: srvCode  and xcebr__c=false and (onhold__c=true or  clcnt__c=null or clcnt__c<2) order by CreatedDate desc limit 1500 ];
            }else if (selStat == 'rCall') {
                reqList= [SELECT name, Full_Name__c, xcp__c, xcnc__c, sta__c, Account_Name__c, srvc__r.name,
                    xceml__c, AP__c, AUP__c, os__c, ldmob__c, onhold__c, CreatedDate, bprk__c, PRM_Name__c,
                    PRM_Email__c, cldt__c, clcnt__c     FROM g_Req__c WHERE acc__r.lc__c !=:Label.Onboarding_Account_LC and onhold__c =true AND sta__c IN ('Open',
                    'Draft') AND Service_Code__c =: srvCode and xcebr__c=false];
            }
            else if (selStat == 'prmCall') {
                reqList= [SELECT name, Full_Name__c, xcp__c, xcnc__c, sta__c, Account_Name__c, srvc__r.name,
                    xceml__c, AP__c, AUP__c, os__c, ldmob__c, onhold__c, CreatedDate, bprk__c, PRM_Name__c,
                    PRM_Email__c, cldt__c, clcnt__c     FROM g_Req__c WHERE acc__r.lc__c !=:Label.Onboarding_Account_LC and sta__c IN ('Open',
                    'Draft') AND Service_Code__c =: srvCode and (xcebr__c=true or (onhold__c=false and clcnt__c >= 2))];
            }
        }else{
              String sql = Label.Onboarding_FLAccClQry;
              reqList = Database.query(String.escapeSingleQuotes(sql));
              //reqList= [SELECT name, Full_Name__c, xcp__c, xcnc__c, sta__c, Account_Name__c, srvc__r.name, xceml__c, AP__c, AUP__c, os__c, ldmob__c, onhold__c, CreatedDate, bprk__c, PRM_Name__c, PRM_Email__c, cldt__c, clcnt__c     FROM g_Req__c WHERE acc__r.lc__c !=:Label.Onboarding_Account_LC and sta__c IN ('Open', 'Draft') AND Service_Code__c =: srvCode AND CreatedDate=LAST_90_DAYS];
            }
        return null;
    }

}