@isTest
public class MilestnH_Test
{
    @testSetup static void setup() {

        List < gStg__c > lstGStg = new List < gStg__c > ();

        gStg__c bh = new gStg__c(name = 'BH', Text_Value__c = '01m20000000BKEa');
        lstGStg.add(bh);
        gStg__c sla = new gStg__c(name = 'slaExpiry', Number_Value__c = 50);
        lstGStg.add(sla);
        gStg__c cour = new gStg__c(name = 'Courier_login', Text_Value__c = '61812, 61812, AXSEMPOST');
        lstGStg.add(cour);
        insert lstGStg;

    }
    static testMethod void MilestnH_Method() {
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        Account a = testData.accCrt(false);
        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp = testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r = testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_Milestone__c objMilestone = new g_Milestone__c();
        objMilestone.Request__c = r.id;
        insert objMilestone;
        g_Milestone__c mileStone = [Select Id, Request__c, Status__c, Start_Date__c, End_Date__c, Additional_End_Date__c from g_Milestone__c WHERE Request__c != null limit 1];
        List<g_Req__c> lstRq = [SELECT Id, mstStg__c, srvc__c, (Select id,
            name from Milestones__r limit 1) FROM g_Req__c where Id IN (Select Request__c from g_Milestone__c where Request__c != null) ];
        Set<Id> setIds = new Set<Id>();

        for (g_Req__c loopvar : lstRq) {    setIds.add(loopvar.Id);    }

        list<g_reqitem__c> news = [SELECT Id, dtieclsx__c, islax__c, islan__c, sta__c, RQ__c,
            dtic__c, itmCd__c, dtiacls__c, dtiecl__c, vSTA__c, dtsc__c, exp__c FROM g_reqitem__c Where sta__c != null AND  RQ__c IN :setIds];
        System.debug('--News-- : ' +news);
        map<Id, g_Srvc__c> mSrvc = new map<Id, g_Srvc__c>();

        map<Id, g_srvcitm_Status__c> mSTA = new map<Id, g_srvcitm_Status__c>();

        Test.startTest();
        g_itmHistorySTA__c hist = new g_itmHistorySTA__c(itm__c=News[0].id,    Milestone__c=mileStone.id, SLA_Action__c='Standard');
        insert hist;
        hist = [select id, itm__c, Milestone__c, SLA_Action__c from g_itmHistorySTA__c where id=:hist.id];
        BusinessHours BH=[select id from BusinessHours where isDefault = true limit 1];

        grqSlaH cls = new grqSlaH();

        MilestnH m = new MilestnH();

        MilestnH.calculateDuration(DateTime.now(), datetime.now().addDays(2), gU.csStr('BH'));
        MilestnH.reCalculateHistoryAndMilestone(hist, mileStone, BH, 'Verified');
        set<id> rqidLst = new Set<id>();
        rqidLst.add(r.id);
        MilestnH.getMilestoneMap(rqidLst);
        Test.stopTest();
    }
    static testMethod void MilestnH_Method1() {
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        Account a = testData.accCrt(false);
        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp = testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r = testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_Milestone__c objMilestone = new g_Milestone__c();
        objMilestone.Request__c = r.id;
        insert objMilestone;
        g_Milestone__c mileStone = [Select Id, Request__c, Status__c, Start_Date__c, End_Date__c, Additional_End_Date__c from g_Milestone__c WHERE Request__c != null limit 1];
        mileStone.Status__c = 'Completed';
        mileStone.End_Date__c = date.today();
        update mileStone;
        List<g_Req__c> lstRq = [SELECT Id, mstStg__c, srvc__c, (Select id,
            name from Milestones__r limit 1) FROM g_Req__c where Id IN (Select Request__c from g_Milestone__c where Request__c != null) ];
        Set<Id> setIds = new Set<Id>();

        for (g_Req__c loopvar : lstRq) {    setIds.add(loopvar.Id);    }

        list<g_reqitem__c> news = [SELECT Id, dtieclsx__c, islax__c, islan__c, sta__c, RQ__c,
            dtic__c, itmCd__c, dtiacls__c, dtiecl__c, vSTA__c, dtsc__c, exp__c FROM g_reqitem__c Where sta__c != null AND  RQ__c IN :setIds];
        System.debug('--News-- : ' +news);
        map<Id, g_Srvc__c> mSrvc = new map<Id, g_Srvc__c>();

        map<Id, g_srvcitm_Status__c> mSTA = new map<Id, g_srvcitm_Status__c>();

        Test.startTest();
        g_itmHistorySTA__c hist = new g_itmHistorySTA__c(itm__c=News[0].id,    Milestone__c=mileStone.id, SLA_Action__c='Standard');
        insert hist;
        hist = [select id, itm__c, Milestone__c, SLA_Action__c from g_itmHistorySTA__c where id=:hist.id];
        BusinessHours BH=[select id from BusinessHours where isDefault = true limit 1];

        grqSlaH cls = new grqSlaH();

        MilestnH m = new MilestnH();

        MilestnH.calculateDuration(DateTime.now(), datetime.now().addDays(2), gU.csStr('BH'));
        MilestnH.reCalculateHistoryAndMilestone(hist, mileStone, BH, 'Verified');
        Test.stopTest();
    }
}