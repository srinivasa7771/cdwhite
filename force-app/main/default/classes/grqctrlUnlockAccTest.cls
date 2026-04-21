@isTest
public class grqctrlUnlockAccTest {
@testSetup static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
    }
    static testmethod void test1() {
        List<Account> accLst = [select id, lc__c, as__c, snc_txt__c from Account where Name='Acc' LIMIT 1];
        accLst[0].as__c='Submitted';
        update accLst[0];
        grqctrlUnlockAcc.unLockAccount();
    }
}