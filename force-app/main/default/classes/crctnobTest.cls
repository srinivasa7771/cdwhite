@isTest(SeeAllData=false)
public class crctnobTest {

    @testSetup
    static void setup() {
        testData.init();

        Account acc = testData.accCrt(false);
        Contact con = testData.conCrt(null, acc.Id, 'Active', 'Employee', 'Pass1', 'Egypt');

        testData.bRulesReqCrt();
        testData.bRulesItemCrt();

        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c srvc = testData.srvcCrt(stg.Id);

        g_Req__c req = testData.reqCrt(acc.Id, srvc.Id, con.Id, 'Open', stg.reqq__c);

        g_srvcitm__c srvItm = [SELECT Id FROM g_srvcitm__c LIMIT 1];
        g_srvcitm_Status__c stat = [SELECT Id, Next_Status__c FROM g_srvcitm_Status__c LIMIT 1];

        g_reqitem__c rqItem = new g_reqitem__c(
            Name = 'Test Item',
            RQ__c = req.Id,
            itm__c = srvItm.Id,
            sta__c = stat.Id,
            rc__c = true
        );
        insert rqItem;

        g_reqDoc__c rdoc = new g_reqDoc__c(
            Name = 'Passport Copy',
            RQ__c = req.Id,

            ats__c = 0
        );
        insert rdoc;

        g_reqitemDoc__c rdocItem = new g_reqitemDoc__c(
            lbl__c='test',
            reqDoc__c = rdoc.Id,
            reqItm__c = rqItem.Id,
            Req__c = true,
            reqAts__c = true,
            mnAts__c = 1
        );
        insert rdocItem;

        Attachment att = new Attachment(
            ParentId = rdoc.Id,
            Name = 'Passport',
            Body = Blob.valueOf('TEST')
        );
        insert att;
    }

    @isTest
    static void testControllerCoverage() {

        g_Req__c rq = [SELECT Id FROM g_Req__c LIMIT 1];
        Attachment att = [SELECT Id FROM Attachment LIMIT 1];

        Test.startTest();

        ApexPages.currentPage().getParameters().put('id', rq.Id);

        crctnob ctrl = new crctnob();

        // 🔹 Force execution paths
        Boolean hasMissingDocs = ctrl.nD;
        ctrl.loadData();
        ctrl.reArrangeDocs();

        ctrl.usrComments = 'Test correction comments';
        ctrl.saveReq();

        ctrl.reqDocId2 = att.Id;
        ctrl.deleteAttachment2();

        Test.stopTest();

       // System.assertNotEquals(null, ctrl.Docs);
        //System.assertNotEquals(null, ctrl.dasLst);
    }
}