@istest
private class caseTriggerTest {

    @TestSetup
    static void makeData() {
        User newUser = testData.createportalUser('test');
    }
    static TestMethod void doTest() {
        Test.startTest();
        List<User> usrLst =  [select id, contactId, name from User where profile.name = 'Z' and isactive=true and contactId != null limit 1];
        if (usrLst != null && !usrLst.isEmpty()) {
            Case cs = new Case();
            cs.Subject = 'test';
            cs.Status = 'Open';
            cs.Type = 'Enquiry';
            cs.ContactId = usrLst[0].contactId;
            cs.Description = 'test';
            cs.Category__c='Account Support';
            cs.Sub_Category__c='Inquiry';
            cs.Resolution_Notes__c='test';
            insert cs;

            cs.Status = 'Closed';
            cs.Reason = 'New problem';
            cs.Category__c = 'Courier';
            cs.Sub_Category__c = 'Courier delivery';
            update cs;

        }
        Test.stopTest();
    }

    static TestMethod void doTest2() {
        Test.startTest();
        List<User> usrLst =  [select id, contactId, name from User where profile.name = 'Z' and isactive=true and contactId != null limit 1];
        if (usrLst != null && !usrLst.isEmpty()) {
            Case cs = new Case();
            cs.Subject = 'test';
            cs.Status = 'Open';
            cs.Type = 'Enquiry';
            cs.Origin='Email';
            cs.ContactId = usrLst[0].contactId;
            cs.Description = 'test';
            cs.To_Email__c='updatecontacts@dham.ae';
            cs.category__c='Events';
            cs.Sub_Category__c='Marketing';
            cs.ms__c='Booking Venues';
            cs.comment__c='Test';
            cs.brand__c='DSC';
            insert cs;
        }
        casehandler.getQueueDevName('AXS_Events');
        Test.stopTest();
    }

}