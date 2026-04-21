@isTest
private class ExportTransactionsAsXMLCtrlTest {
    static testMethod void ExportTest() {
    ExportTransactionsAsXMLCtrl exp = new ExportTransactionsAsXMLCtrl();
    Test.setCurrentPageReference(new PageReference('Page.myPage'));
    System.currentPageReference().getParameters().put('selectedMonth', '11');
    System.currentPageReference().getParameters().put('selectedYear', '2016');
    System.currentPageReference().getParameters().put('fileName', 'Nov');
          Account a=testData.accCrt(false);
        g_Tran__C gt = new g_Tran__C(TP__c='Payment', sta__c='Completed', md__c='Credit / Debit Card', Acc__c=a.id);
        insert gt;
          ExportTransactionsAsXMLCtrl.trans et = new ExportTransactionsAsXMLCtrl.trans();
      string tid = et.tid;
         Decimal amt =et.amt;
         Datetime gwdt =et.gwdt;
         string gwmsg =et.gwmsg;
         string gwrf =et.gwrf;
         string gwcd= et.gwcd;
         string md =et.md;
         string sta= et.sta;
         Datetime createdDate= et.createdDate;
    }
}