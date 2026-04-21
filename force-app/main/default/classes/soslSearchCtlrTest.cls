@isTest
private class soslSearchCtlrTest {
    static testmethod void test1() {
        soslSearchCtlr sch = new soslSearchCtlr();
        sch.searchDemo();
        sch.getSearchOption();
        contact con = new contact(lastname='testcontact', ped__c=system.today().addyears(4), rped__c=system.today().addyears(4));
        insert con;
     soslSearchCtlr.People ctrl = new soslSearchCtlr.People(con);
        string searchStr =sch.searchStr;
    }
     static testmethod void test2() {
        contact con1 = new contact(lastname='testcontact');
        insert con1;
          //PageReference myVfPage = Page.soslSearch;
         PageReference myVfPage = new PageReference('/apex/soslSearch');
        myVfPage.getParameters().put('sos', con1.lastname);
        Test.setCurrentPage(myVfPage);
        String searchStr = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('sos'));
         system.debug('searchStr'+searchStr);
        soslSearchCtlr sch = new soslSearchCtlr();
        sch.searchDemo();
     soslSearchCtlr.People ctrl = new soslSearchCtlr.People(con1);
     }
        static testmethod void test3() {
        soslSearchCtlr sch = new soslSearchCtlr();
        sch.searchDemo();
        sch.getSearchOption();
        contact con = new contact(lastname='testcontact', ped__c=system.today(), rped__c=system.today());
        insert con;
     soslSearchCtlr.People ctrl = new soslSearchCtlr.People(con);
        string searchStr =sch.searchStr;
    }
}