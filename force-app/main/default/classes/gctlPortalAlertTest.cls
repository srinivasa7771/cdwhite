@isTest
public class gctlPortalAlertTest {
    @testSetup
    static void setupData() {
        // Create Account
        Account acc = new Account(
            Name = 'Test Account',
            lc__c = 'Test LC',
            Prk__c = 'Test Park'
        );
        insert acc;

        // Create Contact
        Contact con = new Contact(
            LastName = 'Test Contact',
            Email = 'testcontact@example.com',
            AccountId = acc.Id
        );
        insert con;

        // Create User (must set required fields)
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Z' LIMIT 1];
        User u = new User(
            Alias = 'tuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'TestUser',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York',
            UserName = 'testuser' + System.currentTimeMillis() + '@example.com',
            ProfileId = p.Id,
            ContactId = con.Id
        );
        insert u;
    }

    @isTest
    static void testControllerMethods() {
        // Run as our test user
        User u = [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];
        
        System.runAs(u) {
            // Instantiate controller
            gctlPortalAlert ctrl = new gctlPortalAlert();
            System.assertNotEquals(null, ctrl.loggedInUser, 'User should be populated');
            System.assertNotEquals(null, ctrl.accid, 'AccountId should be populated');

            // Test AccountDetails
            ctrl.AccountDetails();
            System.assertNotEquals(null, ctrl.aPark, 'aPark should be set from Account');

            // Test updateAlertConfirmation_User
            ctrl.updateAlertConfirmation_User();
            User updatedUser = [SELECT Id, Policy_Confirmation_Date__c FROM User WHERE Id = :u.Id];
            System.assertEquals(Date.today(), updatedUser.Policy_Confirmation_Date__c, 'Policy Confirmation Date should be updated');
        }
    }
}