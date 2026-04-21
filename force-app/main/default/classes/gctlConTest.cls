@IsTest
private class gctlConTest {
    @testSetup static void setup() {
        testData.init();

       // User usr = testData.createUser('test');
    }

    static testmethod void testConNotBlank() {
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt1');
        Contact con=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        Test.startTest();
        //PageReference vfpage = Page.grqstatus;
        PageReference vfpage = new PageReference('/apex/grqstatus');
        vfpage.getParameters().put('id', conLst[0].Id);
        Test.setCurrentPage(vfpage);
        gctlCon obj = new gctlCon();

        Test.stopTest();
    }
    static testmethod void testConNotBlankSponBlank() {
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt1');
        Contact con=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        Test.startTest();
        //PageReference vfpage = Page.grqstatus;
        PageReference vfpage = new PageReference('/apex/grqstatus');
        vfpage.getParameters().put('id', con.Id);
        Test.setCurrentPage(vfpage);
        gctlCon obj = new gctlCon();
        Test.stopTest();
    }
    static testmethod void testConBlank() {

            Test.startTest();
            //User usr = testData.createportalUser('test');
            //insert usr;
            //Account acc =[SELECT id FROM Account LIMIT 1];
            //Contact con =[SELECT id FROM Contact WHERE p__c='Pass2' LIMIT 1];
            User user = testData.createportalUser('test');
            //user.contactId =con.id;
            insert user;
            system.debug('user:::'+user.id);

            //PageReference vfpage = Page.grqstatus;
            PageReference vfpage = new PageReference('/apex/grqstatus');
            vfpage.getParameters().put('id', '');
            Test.setCurrentPage(vfpage);
          system.runAs(user) {
            gctlCon obj = new gctlCon();
              Apexpages.currentPage().getParameters().put('role', 'Employee');
          obj.roleFilter();
          }
            Test.stopTest();
    }
}