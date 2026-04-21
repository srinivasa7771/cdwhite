@isTest
private class UnitTest_SelectTransactionsMonthCtrl {
    static testMethod void selectMonthTest() {
        Test.startTest();
        SelectTransactionsMonthCtrl ctrl = new SelectTransactionsMonthCtrl();
        Date todayDate = Date.today();
        ctrl.DownloadXML();
        ctrl.selectedMonth = todayDate.month() +'-'+todayDate.year();
        ctrl.DownloadXML();
        Test.stopTest();
    }

}