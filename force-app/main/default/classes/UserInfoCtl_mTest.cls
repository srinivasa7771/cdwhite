@isTest
private class UserInfoCtl_mTest {
    static testmethod void test1() {
        Test.startTest();
        UserInfoCtl_m obj = new UserInfoCtl_m();
        obj.getnotificationRQs();
        obj.getUserInfo();
        Test.stopTest();
    }
}