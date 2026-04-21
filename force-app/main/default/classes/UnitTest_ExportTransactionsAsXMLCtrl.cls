@isTest
private class UnitTest_ExportTransactionsAsXMLCtrl {
    @TestSetup
    static void initializeData() {
        List<Account> accounts = new List<Account>();
        List<g_Tran__c> tansactions = new List<g_Tran__c>();
        for (Integer i=0;i<100;i++) {
            accounts.add(new Account(Name='Test account'+i));
        }
        insert accounts;
        for (Account ac: accounts) {
            tansactions.add(new g_Tran__c(Acc__c=ac.Id, Tp__C='Payment', md__c='Credit / Debit Card'));
        }
        insert tansactions;
    }
    static testMethod void exportTransactionXMLNegative() {
        Test.startTest();
        ExportTransactionsAsXMLCtrl ctrl = new ExportTransactionsAsXMLCtrl();
        Test.stopTest();
    }
    static testMethod void exportTransactionXMLPositive() {
        Test.startTest();
        System.assertEquals(100, [Select count() from Account]);
        System.assertEquals(100, [Select count() from g_Tran__c]);
        PageReference pr = Page.ExportTransactionsAsXML;
        Date todayDate = Date.today();
        pr.getParameters().put('selectedMonth', String.valueOf(todayDate.month()));
        pr.getParameters().put('selectedYear', String.valueOf(todayDate.year()));
        Test.setCurrentPage(pr);
        ExportTransactionsAsXMLCtrl ctrl = new ExportTransactionsAsXMLCtrl();
        Test.stopTest();
    }
}