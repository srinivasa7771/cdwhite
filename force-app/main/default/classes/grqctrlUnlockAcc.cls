public class grqctrlUnlockAcc {

    @InvocableMethod(label='Unlock Account' description='Unlocking the Accont Record after submission' category='Account')
    public static void unLockAccount() {
        for (Account acc :[select id from account where as__c='Submitted' ]) {
            Approval.unlock(acc.id);
        }
    }
}