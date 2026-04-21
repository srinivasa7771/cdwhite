@isTest
private class grNshTest {
    static testMethod void doTest() {
        Test.startTest();
        testData.init();
        Account a=testData.accCrt(false);
        grNsh obj = new grNsh();
        obj.gNSpD();
        obj.getTBx();
        obj.init();

        //PageReference scPage = Page.grdprn;
        PageReference scPage = new PageReference('/apex/grdprn');
        scPage.getParameters().put('a', a.Id);
        scPage.getParameters().put('c', a.Id);
        scPage.getParameters().put('p', a.Id);
        scPage.getParameters().put('n', a.Id);
        Test.setCurrentPage(scPage);
        obj.gNSpD();
        obj.getTBx();
        String str = obj.getSId();
        String str1 = obj.getN();
        String str2 = obj.getP();

        Test.stopTest();
    }
}