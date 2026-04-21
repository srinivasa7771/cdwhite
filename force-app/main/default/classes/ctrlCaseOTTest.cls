@istest
private class ctrlCaseOTTest {
    static TestMethod void doTest() {
        Id objQId = [select id, name from group where Developername='AXS_Support' and type='Queue'].id;
        Test.startTest();
        Case cs = new Case();
        cs.Subject = 'test';
        cs.Status = 'Open';
        cs.Type = 'Enquiry';
        cs.Description = 'test';
        cs.origin='Email';
        cs.OwnerId = objQId;
        insert cs;
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='CC2'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName=uniqueUserName);
        //System.runAs(u) {
        PageReference pageRef = Page.caseOTPage;
        Test.setCurrentPage(pageRef);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(cs);
        ApexPages.currentPage().getParameters().put('Id', cs.id);
        ctrlCaseOT ctrl = new ctrlCaseOT(sc);
        ctrl.updateCase();
       // }
        Test.stopTest();
    }
}