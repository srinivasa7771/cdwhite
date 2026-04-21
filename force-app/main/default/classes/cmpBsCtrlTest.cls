@istest
private class cmpBsCtrlTest {
    static testmethod void test() {
        Test.startTest();
            cmpBsCtrl obj = new cmpBsCtrl();
            obj.key='test';
            pgBsCtrl obj1 = new pgBsCtrl();
            obj.pageController =obj1;
        Test.stopTest();
    }
}