@isTest
public class UserOutOfOfficeTest{
    private static testMethod void UserOutOfOfficeTest1() {
        User usrTest = [select id, Out_Of_Office__c, From_Date__c, To_Date__c from User where Id=: UserInfo.getUserID()];
        userOutOfOfficeExt test1 = new userOutOfOfficeExt(new ApexPages.StandardController(usrTest));
        test1.usr.From_Date__c = Date.today().addDays(-1);
        test1.usr.From_Date__c = Date.today().addDays(5);
        test1.Save();

    }
}