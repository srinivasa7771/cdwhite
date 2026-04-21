@isTest
public class gctlAccHistTest {

    static testMethod void doTest() {
         Test.startTest();
         Account a=testData.accCrt(false);
        gctlAccHist obj=new gctlAccHist(new ApexPages.StandardController(a));
        obj.getAccHistLst();
        Test.stopTest();
    }
}