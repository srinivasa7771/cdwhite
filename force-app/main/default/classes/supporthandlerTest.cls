@isTest
private class supporthandlerTest {
    static testMethod void doTest_ins() {
        try {
            List<Account> listAccount = DataUtilityTest.createAccountRecord(1);
            Insert listAccount;
            Issue_Tracker__c caserec = new Issue_Tracker__c();
            caserec.Summary__c = 'Test Summary';
            caserec.More_Details__c = 'Test more details';
            caserec.Type__c = 'Enquiry';
            insert caserec;
            List<Issue_Tracker__c> listcaserecs = new List<Issue_Tracker__c>();
            listcaserecs.add(caserec);
            Test.startTest();
            try {
                supporthandler.IB(listcaserecs);
            }catch (Exception e) {}
            List<Issue_Tracker__c> listcaserecsopen = new List<Issue_Tracker__c>();
            for (Issue_Tracker__c cases: listcaserecs) {
                cases.Status__c = 'In Process';
                listcaserecsopen.add(cases);
            }
            update listcaserecsopen;
            List<Issue_Tracker__c> listcaserecsclosed = new List<Issue_Tracker__c>();
            for (Issue_Tracker__c cases: listcaserecs) {
                cases.Status__c = 'Closed';cases.Root_Cause__c = 'Customer Delay'; listcaserecsclosed.add(cases);
            }
            try {
                update listcaserecsclosed;
            }catch (Exception e) {}

            Test.StopTest();

        }catch (Exception e) {}
    }
}