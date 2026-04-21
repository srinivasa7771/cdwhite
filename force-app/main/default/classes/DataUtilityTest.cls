@isTest
public class DataUtilityTest{
    /****************************Insert Account Data **************************************************************************/
    public static List<Account> createAccountRecord(Integer recnum) {
        List<Account> listAccount = new List<Account>();
            for (Integer i=0;i <= recnum;i++) {
            Account acntRecord = new Account();
            acntrecord.name = 'Tecome New Account'+i;
            listAccount.add(acntrecord);
        }
        return listAccount;
     }
    /****************************Insert Contact Data **************************************************************************/
    public static List<Contact> createContactRecord(Integer recnum) {
        List<Contact> listContact = new List<Contact>();
            for (Integer i=0;i <= recnum;i++) {
            Contact contactRecord = new Contact();
            contactrecord.Firstname = 'Tecome First Name Contact'+i;
            contactrecord.Lastname = 'Tecome Last Name Contact'+i;
            contactrecord.rol__c='Employee';
            listContact.add(contactrecord);
        }
        return listContact;
     }
    /****************************Insert User Data **************************************************************************/
    public static List<User> createUserRecord(Integer recnum) {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        List<User> listUser = new List<User>();
            for (Integer i=0;i <= recnum;i++) {
            User userRecord = new User();
            userRecord.Alias = 'standt';
            userRecord.Email='standarduser@testorg.com';
            userRecord.EmailEncodingKey='UTF-8';
            userRecord.LastName='Testing';
            userRecord.LanguageLocaleKey='en_US';
            userRecord.LocaleSidKey='en_US';
            userRecord.ProfileId = p.Id;
            userRecord.TimeZoneSidKey='America/Los_Angeles';
            userRecord.UserName='Tecom_SUS50545@testorg.com'+i;
            listUser.add(userRecord);
        }
        return listUser;
     }
}