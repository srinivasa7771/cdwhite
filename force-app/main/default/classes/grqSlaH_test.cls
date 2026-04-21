@isTest (SeeAllData = true)
public class grqSlaH_test
{
    static testMethod void grqSlaH_Method() {
        List<g_Req__c> lstRq = [SELECT Id, mstStg__c, srvc__c FROM g_Req__c where mstStg__c != null AND sta__c = 'Completed' limit 3];
        list<g_reqitem__c> news = [SELECT Id, dtieclsx__c, islax__c, islan__c, sta__c, RQ__c,
            dtic__c, itmCd__c, dtiacls__c, dtiecl__c, vSTA__c, dtsc__c, exp__c FROM g_reqitem__c Where sta__c != null AND dtsc__c != null limit 3];
        Set<Id> setIds = new Set<Id>();

        map<Id, g_Srvc__c> mSrvc = new map<Id, g_Srvc__c>();
        map<Id, g_reqitem__c> olds = new map<Id, g_reqitem__c>();
        map<Id, g_srvcitm_Status__c> mSTA = new map<Id, g_srvcitm_Status__c>();

        for (g_Req__c loopvar : lstRq) {   setIds.add(loopvar.srvc__c);    }

        List<g_Srvc__c> lstSrvc = [SELECT Id, Milestone_Stage__c, Milestone_SLA__c from g_Srvc__c WHERE Id IN :setIds limit 100];

        for (g_Srvc__c loopvar : lstSrvc) {   mSrvc.put(loopvar.Id, loopvar); }

        setIds = new Set<Id>();
        List<SObject> bulkList_loopvar_update = new List<SObject>();
        for (g_reqitem__c loopvar : News) {
            if (loopvar.vSTA__c == 'Requires Verification') loopvar.vSTA__c = 'Verified';
            else if (loopvar.vSTA__c == 'Verified') loopvar.vSTA__c = 'Requires Verification';
            bulkList_loopvar_update.add(loopvar);
            olds.put(loopvar.Id, loopvar);
            setIds.add(loopvar.sta__c);
        }
        if (!bulkList_loopvar_update.isEmpty()) { update bulkList_loopvar_update; }

        List<g_srvcitm_Status__c> LstSTA = [SELECT Id, Shift_At__c, Shift_Items__c, slaa__c,
            Tp__c, slaN__c, slaXP__c, itm__r.rv__c, rc__c, nm__c FROM g_srvcitm_Status__c WHERE Id IN :SetIds limit 100];

        for (g_srvcitm_Status__c loopvar : LstSTA) {   mSTA.put(loopvar.Id, loopvar);  }

        Test.startTest();
        grqSlaH cls = new grqSlaH();
        grqSlaH.prepItms(news, olds, mSTA);
        grqSlaH.crtMlstn(lstRq, mSrvc);
        Test.stopTest();
    }
}