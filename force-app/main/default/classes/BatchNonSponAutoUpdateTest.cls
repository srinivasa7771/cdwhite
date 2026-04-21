@isTest
public class BatchNonSponAutoUpdateTest {
 @testSetup
    static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        testData.bRulesReqCrt();
        testData.bRulesItemCrt();
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        s.uid__c = '071';
        update s;
        list<g_srvcitm__c> lstsvrItm = new list<g_srvcitm__c>();
        list<g_srvcitm__c> lstsvrItmTOdelete = new list<g_srvcitm__c>();
        for (g_srvcitm__c objsrvItm : [SELECT id, uid__c , cd__c from g_srvcitm__c where srvc__r.uid__c = '071']) {
           if (objsrvItm.cd__c == 'md') {
               objsrvItm.cd__c = 'gid';
               lstsvrItm.add(objsrvItm);
           }
            else if (objsrvItm.cd__c == 'pd') {
                objsrvItm.cd__c = 'id2';
               lstsvrItm.add(objsrvItm);
            }
            else if (objsrvItm.cd__c =='id') {

            }
            else  lstsvrItmTOdelete.add(objsrvItm);
        }

        if (!lstsvrItm.isEmpty()) {
            update lstsvrItm;
        }
        if (!lstsvrItmTOdelete.isEmpty()) {
            delete lstsvrItmTOdelete;
        }
        gStg__c crtstng = testData.createSetting('test', 'testvalue');
        Contact emp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        emp.idedt__c = Date.today();
        update emp;
        g_Req__c req = testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);

        list<g_reqitem__c> lstReqItem = [SELECT id, itm__r.cd__c FROM g_reqitem__c where itm__r.cd__c IN ('gid', 'id2', 'id') ];
        system.debug('lstReqItem===='+lstReqItem);
    }
    @isTest
    static void testRenewal() {
        g_reqitem__c reqItem = [SELECT id, itm__r.cd__c FROM g_reqitem__c where itm__r.cd__c IN ('gid', 'id2', 'id') lIMIT 1];
         ws_call__c wsRenewal = new ws_call__c();
        wsRenewal.intsts__c = 'Ready for Integration';
        wsRenewal.mtd_nm__c = 'NONSPONIDREN';
        wsRenewal.sdt__c = System.today().addDays(3);
        wsRenewal.pmid__c = '';
        wsRenewal.rq_itm__c = reqItem.id;
        wsRenewal.rq_jsn__c = '';
        wsRenewal.ws_typ__c = 'AUTOCLOSE';
        insert wsRenewal;

        Test.startTest();
        Database.executeBatch(new BatchNonSponAutoUpdate(), 1 );
         Test.stopTest();
    }

     @isTest
    static void testRenewal1() {
        delete [SELECT id, itm__r.cd__c FROM g_reqitem__c where itm__r.cd__c IN ( 'gid')];
        g_reqitem__c reqItem = [SELECT id, itm__r.cd__c FROM g_reqitem__c where itm__r.cd__c IN ('id', 'id2' ) lIMIT 1];
         ws_call__c wsRenewal = new ws_call__c();
        wsRenewal.intsts__c = 'Ready for Integration';
        wsRenewal.mtd_nm__c = 'NONSPONIDREN';
        wsRenewal.sdt__c = System.today().addDays(3);
        wsRenewal.pmid__c = '';
        wsRenewal.rq_itm__c = reqItem.id;
        wsRenewal.rq_jsn__c = '';
        wsRenewal.ws_typ__c = 'AUTOCLOSE';
        insert wsRenewal;

        Test.startTest();
        Database.executeBatch(new BatchNonSponAutoUpdate(), 1 );
         Test.stopTest();
    }

    @isTest
    static void testRenewal2() {
         delete [SELECT id, itm__r.cd__c FROM g_reqitem__c where itm__r.cd__c IN ( 'gid', 'id')];
        g_reqitem__c reqItem = [SELECT id, itm__r.cd__c FROM g_reqitem__c where itm__r.cd__c IN ('id2' ) lIMIT 1];
         ws_call__c wsRenewal = new ws_call__c();
        wsRenewal.intsts__c = 'Ready for Integration';
        wsRenewal.mtd_nm__c = 'NONSPONIDREN';
        wsRenewal.sdt__c = System.today().addDays(3);
        wsRenewal.pmid__c = '';
        wsRenewal.rq_itm__c = reqItem.id;
        wsRenewal.rq_jsn__c = '';
        wsRenewal.ws_typ__c = 'AUTOCLOSE';
        insert wsRenewal;

        Test.startTest();
        Database.executeBatch(new BatchNonSponAutoUpdate(), 1 );
         Test.stopTest();
    }
    @isTest
    static void testCancellation() {
        g_reqitem__c reqItem = [SELECT id, itm__r.cd__c FROM g_reqitem__c LIMIT 1];

        ws_call__c wsCancel = new ws_call__c();
        wsCancel.intsts__c = 'Ready for Integration';
        wsCancel.mtd_nm__c = 'NONSPONIDCAN';
        wsCancel.sdt__c = System.today().addDays(3);
        wsCancel.pmid__c = '';
        wsCancel.rq_itm__c = reqItem.id;
        wsCancel.rq_jsn__c = '';
        wsCancel.ws_typ__c = 'AUTOCLOSE';
        insert wsCancel;

        Test.startTest();
        Database.executeBatch(new BatchNonSponAutoUpdate(), 1 );
        Test.stopTest();
    }
}