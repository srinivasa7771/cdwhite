@istest
private class emailMessageHandlerTest {
    static TestMethod void doTest() {

        Case cs = new Case();
        cs.Subject = 'test';
        cs.Status = 'Open';
        cs.Type = 'Request';
        cs.Description = 'test';
        cs.Origin='Email';
        cs.Category__c='Events';
        cs.Sub_Category__c='Marketing';
        cs.ms__c='Booking Venues';
        cs.Comment__c='Test';
        cs.brand__c='DIND';
        insert cs;
        cs.ownerid=casehandler.getQueueDevName('AXS_Events');
        update  cs;

        EmailMessage em = new EmailMessage();
        em.parentid= cs.id;
        em.Incoming=true;
        em.ToAddress = 'support@axs.ae';
        em.ccAddress = 'support@axs.ae';
        em.FromAddress = 'test@test.com';
        em.Subject = 'Test Subject';
        insert em;

        Test.startTest();
        emailMessageHandler.updateCase(new list<emailMessage>{em});
        emailMessageHandler.appendCaseNumber(new list<emailMessage>{em});
        Test.stopTest();
    }
}