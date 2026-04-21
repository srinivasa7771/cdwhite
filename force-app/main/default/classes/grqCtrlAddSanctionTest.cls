@isTest
public class grqCtrlAddSanctionTest {
    @testSetup static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
    }
    static testmethod void test1() {
        List<Account> accLst = [select id, as__c , GSO__c, FIN__c, snc__c, lcsta__c, sn__c, snadrmd__c, VIP__c, CA_San__c, Lease__c, srb__c, snc_txt__c from Account where Name='Acc' LIMIT 1];
        accLst[0].gso__c='GSO- Employee head count';
        accLst[0].snadrmd__c='Add Requested Sanction';
        accLst[0].snc__c='GSO- Employee head count';
        accLst[0].as__c='Approved';
        update accLst[0];
        PageReference pageRef = Page.addSanction;
        Test.setCurrentPage(pageRef);
       // ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(accLst[0]);
        ApexPages.currentPage().getParameters().put('Id', accLst[0].id);
        test.startTest();
        grqCtrlAddSanction ctrl = new grqCtrlAddSanction();
        ctrl.saveSanction();
        ctrl.cancel();
        grqCtrlAddSanction.appendSanctions();
        ctrl.submitForApproval(accLst[0]);
        test.stopTest();
    }
    static testmethod void test2() {
        List<Account> accLst = [select id, as__c , GSO__c, FIN__c, snc__c, lcsta__c, sn__c, snadrmd__c, VIP__c, CA_San__c, Lease__c, srb__c, snc_txt__c from Account where Name='Acc' LIMIT 1];
        accLst[0].FIN__c='FIN- Bounced Cheques    ';
        accLst[0].snadrmd__c='Add Requested Sanction';
        accLst[0].snc__c='FIN- Bounced Cheques    ';
        accLst[0].as__c='Approved';
        update accLst[0];
        PageReference pageRef = Page.addSanction;
        Test.setCurrentPage(pageRef);
       // ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(accLst[0]);
        ApexPages.currentPage().getParameters().put('Id', accLst[0].id);
        test.startTest();
        grqCtrlAddSanction ctrl = new grqCtrlAddSanction();
        ctrl.saveSanction();
        ctrl.cancel();
        grqCtrlAddSanction.appendSanctions();
        ctrl.submitForApproval(accLst[0]);
        test.stopTest();
    }
    static testmethod void test3() {
        List<Account> accLst = [select id, as__c , GSO__c, FIN__c, snc__c, lcsta__c, sn__c, snadrmd__c, VIP__c, CA_San__c, Lease__c, srb__c, snc_txt__c from Account where Name='Acc' LIMIT 1];
        accLst[0].CA_San__c='CA- Violation (Activity)';
        accLst[0].snadrmd__c='Add Requested Sanction';
        accLst[0].snc__c='CA- Violation (Activity)';
        accLst[0].as__c='Approved';
        update accLst[0];
        PageReference pageRef = Page.addSanction;
        Test.setCurrentPage(pageRef);
       // ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(accLst[0]);
        ApexPages.currentPage().getParameters().put('Id', accLst[0].id);
        test.startTest();
        grqCtrlAddSanction ctrl = new grqCtrlAddSanction();
        ctrl.saveSanction();
        ctrl.cancel();
        grqCtrlAddSanction.appendSanctions();
        ctrl.submitForApproval(accLst[0]);
        test.stopTest();
    }
    static testmethod void test4() {
        List<Account> accLst = [select id, as__c , GSO__c, FIN__c, snc__c, lcsta__c, sn__c, snadrmd__c, VIP__c, CA_San__c, Lease__c, srb__c, snc_txt__c from Account where Name='Acc' LIMIT 1];
        accLst[0].Lease__c='Non-Renewal of Lease';
        accLst[0].snadrmd__c='Add Requested Sanction';
        accLst[0].snc__c='Non-Renewal of Lease';
        accLst[0].as__c='Approved';
        update accLst[0];
        PageReference pageRef = Page.addSanction;
        Test.setCurrentPage(pageRef);
       // ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(accLst[0]);
        ApexPages.currentPage().getParameters().put('Id', accLst[0].id);
        test.startTest();
        grqCtrlAddSanction ctrl = new grqCtrlAddSanction();
        ctrl.saveSanction();
        ctrl.cancel();
        grqCtrlAddSanction.appendSanctions();
        ctrl.submitForApproval(accLst[0]);
        test.stopTest();
    }
   static testmethod void test5() {
       List<Account> accLst = [select id, as__c , GSO__c, FIN__c, snc__c, lcsta__c, sn__c, snadrmd__c, VIP__c, CA_San__c, Lease__c, srb__c, snc_txt__c from Account where Name='Acc' LIMIT 1];
       accLst[0].Lease__c='Non-Renewal of Lease';
       accLst[0].snc__c='Non-Renewal of Lease';

       accLst[0].as__c='Rejected';
       update accLst[0];
        accLst[0].Lease__c='Non-Renewal of Lease';
        update accLst[0];
       PageReference pageRef = Page.addSanction;
        Test.setCurrentPage(pageRef);
       // ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(accLst[0]);
        ApexPages.currentPage().getParameters().put('Id', accLst[0].id);
        test.startTest();
        grqCtrlAddSanction ctrl = new grqCtrlAddSanction();
        ctrl.submitForApproval(accLst[0]);
        ctrl.saveSanction();
        ctrl.cancel();
        grqCtrlAddSanction.appendSanctions();
        test.stopTest();
    }
    static testmethod void test6() {
       List<Account> accLst = [select id, as__c , GSO__c, FIN__c, snc__c, lcsta__c, sn__c, snadrmd__c, VIP__c, CA_San__c, Lease__c, srb__c, snc_txt__c from Account where Name='Acc' LIMIT 1];
       accLst[0].Lease__c='Non-Renewal of Lease';
       //accLst[0].sn__c=accLst[0].snadrmd__c='';
       accLst[0].lcsta__c='License Cancelled';
       accLst[0].as__c='Submitted';
       update accLst[0];
       PageReference pageRef = Page.addSanction;
        Test.setCurrentPage(pageRef);
       // ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(accLst[0]);
        ApexPages.currentPage().getParameters().put('Id', accLst[0].id);
        test.startTest();
        grqCtrlAddSanction ctrl = new grqCtrlAddSanction();
        ctrl.submitForApproval(accLst[0]);
        ctrl.saveSanction();
        ctrl.cancel();
        grqCtrlAddSanction.appendSanctions();
        test.stopTest();
    }
    static testmethod void test7() {
        List<Account> accLst = [select id, as__c , GSO__c, FIN__c, snc__c, lcsta__c, sn__c, snadrmd__c, VIP__c, CA_San__c, Lease__c, srb__c, snc_txt__c from Account where Name='Acc' LIMIT 1];
        accLst[0].Lease__c='Non-Renewal of Lease';
        accLst[0].lcsta__c='License Cancelled';
        update accLst[0];
        PageReference pageRef = Page.addSanction;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', accLst[0].id);
        test.startTest();
        grqAddSanctionHelper.SubmitApproval(accLst);
        test.stopTest();
    }

}