@isTest
private class ExportDataToExcelTest {
     @testSetup static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
    }
    static testmethod void testfieldValAge() {

        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        conLst[0].AccountId = accLst[0].id;
        update conLst;
        system.debug('accLst:::'+accLst.size());

        Test.startTest();
        //PageReference exportPage = Page.ExportDataToExcel;
        PageReference exportPage = new PageReference('/apex/ExportDataToExcel');
        exportPage.getParameters().put('AccountId', accLst[0].Id);
        exportPage.getParameters().put('filter', 'Employee-PRO');
        exportPage.getParameters().put('fieldVal', 'Age__c');
        Test.setCurrentPage(exportPage);
        ExportDataToExcel obj = new ExportDataToExcel();

        System.assertEquals( accLst[0].Id, String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('AccountId')));
        System.assertEquals( 'Employee-PRO', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('filter')));
        System.assertEquals( 'Age__c', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('fieldVal')));

        Test.stopTest();
    }
    static testmethod void testfieldValGender() {
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        conLst[0].AccountId = accLst[0].id;
        update conLst;
        system.debug('accLst:::'+accLst.size());

        Test.startTest();
        //PageReference exportPage = Page.ExportDataToExcel;
        PageReference exportPage = new PageReference('/apex/ExportDataToExcel');
        exportPage.getParameters().put('AccountId', accLst[0].Id);
        exportPage.getParameters().put('filter', 'Employee-PRO');
        exportPage.getParameters().put('fieldVal', 'Gender__c');
        Test.setCurrentPage(exportPage);
        ExportDataToExcel obj = new ExportDataToExcel();

        System.assertEquals( accLst[0].Id, String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('AccountId')));
        System.assertEquals( 'Employee-PRO', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('filter')));
        System.assertEquals( 'Gender__c', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('fieldVal')));

        Test.stopTest();
    }
    static testmethod void testfieldValRol() {
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        conLst[0].AccountId = accLst[0].id;
        update conLst;
        system.debug('accLst:::'+accLst.size());

        Test.startTest();
        //PageReference exportPage = Page.ExportDataToExcel;
        PageReference exportPage = new PageReference('/apex/ExportDataToExcel');
        exportPage.getParameters().put('AccountId', accLst[0].Id);
        exportPage.getParameters().put('filter', 'Employee-PRO');
        exportPage.getParameters().put('fieldVal', 'rol__c');
        Test.setCurrentPage(exportPage);
        ExportDataToExcel obj = new ExportDataToExcel();

        System.assertEquals( accLst[0].Id, String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('AccountId')));
        System.assertEquals( 'Employee-PRO', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('filter')));
        System.assertEquals( 'rol__c', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('fieldVal')));

        Test.stopTest();
    }
    static testmethod void testfieldValmgs() {
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        conLst[0].AccountId = accLst[0].id;
        update conLst;
        system.debug('accLst:::'+accLst.size());

        Test.startTest();
        //PageReference exportPage = Page.ExportDataToExcel;
        PageReference exportPage = new PageReference('/apex/ExportDataToExcel');
        exportPage.getParameters().put('AccountId', accLst[0].Id);
        exportPage.getParameters().put('filter', 'Employee-PRO');
        exportPage.getParameters().put('fieldVal', 'mgs__c');
        Test.setCurrentPage(exportPage);
        ExportDataToExcel obj = new ExportDataToExcel();

        System.assertEquals( accLst[0].Id, String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('AccountId')));
        System.assertEquals( 'Employee-PRO', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('filter')));
        System.assertEquals( 'mgs__c', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('fieldVal')));

        Test.stopTest();
    }
    static testmethod void testfieldValnc() {
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        conLst[0].AccountId = accLst[0].id;
        update conLst;
        system.debug('accLst:::'+accLst.size());

        Test.startTest();
        //PageReference exportPage = Page.ExportDataToExcel;
        PageReference exportPage = new PageReference('/apex/ExportDataToExcel');
        exportPage.getParameters().put('AccountId', accLst[0].Id);
        exportPage.getParameters().put('filter', 'Employee-PRO');
        exportPage.getParameters().put('fieldVal', 'nc__c');
        Test.setCurrentPage(exportPage);
        ExportDataToExcel obj = new ExportDataToExcel();

        System.assertEquals( accLst[0].Id, String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('AccountId')));
        System.assertEquals( 'Employee-PRO', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('filter')));
        System.assertEquals( 'nc__c', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('fieldVal')));

        Test.stopTest();
    }
    static testmethod void testfieldValp() {
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        conLst[0].AccountId = accLst[0].id;
        update conLst;
        system.debug('accLst:::'+accLst.size());

        Test.startTest();
        //PageReference exportPage = Page.ExportDataToExcel;
        PageReference exportPage = new PageReference('/apex/ExportDataToExcel');
        exportPage.getParameters().put('AccountId', accLst[0].Id);
        exportPage.getParameters().put('filter', 'Employee-PRO');
        exportPage.getParameters().put('fieldVal', 'p__c');
        Test.setCurrentPage(exportPage);
        ExportDataToExcel obj = new ExportDataToExcel();

        System.assertEquals( accLst[0].Id, String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('AccountId')));
        System.assertEquals( 'Employee-PRO', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('filter')));
        System.assertEquals( 'p__c', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('fieldVal')));

        Test.stopTest();
    }
    static testmethod void testfieldValrp() {
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        conLst[0].AccountId = accLst[0].id;
        update conLst;
        system.debug('accLst:::'+accLst.size());

        Test.startTest();
        //PageReference exportPage = Page.ExportDataToExcel;
        PageReference exportPage = new PageReference('/apex/ExportDataToExcel');
        exportPage.getParameters().put('AccountId', accLst[0].Id);
        exportPage.getParameters().put('filter', 'Employee-PRO');
        exportPage.getParameters().put('fieldVal', 'rp__c');
        Test.setCurrentPage(exportPage);
        ExportDataToExcel obj = new ExportDataToExcel();

        System.assertEquals( accLst[0].Id, String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('AccountId')));
        System.assertEquals( 'Employee-PRO', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('filter')));
        System.assertEquals( 'rp__c', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('fieldVal')));

        Test.stopTest();
    }
    static testmethod void testfieldValAllData() {
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        conLst[0].AccountId = accLst[0].id;
        update conLst;
        system.debug('accLst:::'+accLst.size());

        Test.startTest();
        //PageReference exportPage = Page.ExportDataToExcel;
        PageReference exportPage = new PageReference('/apex/ExportDataToExcel');
        exportPage.getParameters().put('AccountId', accLst[0].Id);
        exportPage.getParameters().put('filter', 'Employee-PRO');
        exportPage.getParameters().put('fieldVal', 'AllData');
        Test.setCurrentPage(exportPage);
        ExportDataToExcel obj = new ExportDataToExcel();

        System.assertEquals( accLst[0].Id, String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('AccountId')));
        System.assertEquals( 'Employee-PRO', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('filter')));
        System.assertEquals( 'AllData', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('fieldVal')));

        Test.stopTest();
    }
    static testmethod void testfieldValNoValue() {
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        conLst[0].AccountId = accLst[0].id;
        update conLst;
        system.debug('accLst:::'+accLst.size());

        Test.startTest();
        //PageReference exportPage = Page.ExportDataToExcel;
        PageReference exportPage = new PageReference('/apex/ExportDataToExcel');
        exportPage.getParameters().put('AccountId', accLst[0].Id);
        exportPage.getParameters().put('filter', 'Employee-PRO');
        exportPage.getParameters().put('fieldVal', 'novalue');
        Test.setCurrentPage(exportPage);
        ExportDataToExcel obj = new ExportDataToExcel();

        System.assertEquals( accLst[0].Id, String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('AccountId')));
        System.assertEquals( 'Employee-PRO', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('filter')));
        System.assertEquals( 'novalue', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('fieldVal')));

        Test.stopTest();
    }
    static testmethod void testfieldValtransactions2() {
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        conLst[0].AccountId = accLst[0].id;
        update conLst;

        /*g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        g_Req__c r=testData.reqCrt(a.Id, s.Id, conLst[0].Id, 'Open', stg.reqq__c);
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment');
        insert T;*/

        system.debug('accLst:::'+accLst.size());

        Test.startTest();
        //PageReference exportPage = Page.ExportDataToExcel;
        PageReference exportPage = new PageReference('/apex/ExportDataToExcel');
        exportPage.getParameters().put('AccountId', accLst[0].Id);
        exportPage.getParameters().put('filter', 'Employee-PRO');
        exportPage.getParameters().put('fieldVal', 'transactions2');
        exportPage.getParameters().put('fieldVal', 'transactions2');

        exportPage.getParameters().put('startDate', '25/12/2020');
        exportPage.getParameters().put('endDate', '25/12/2022');
        exportPage.getParameters().put('addFilter', 'saasd');
        Test.setCurrentPage(exportPage);
        ExportDataToExcel obj = new ExportDataToExcel();

        System.assertEquals( accLst[0].Id, String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('AccountId')));
        System.assertEquals( 'Employee-PRO', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('filter')));
        System.assertEquals( 'transactions2', String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('fieldVal')));

        Test.stopTest();
    }

}