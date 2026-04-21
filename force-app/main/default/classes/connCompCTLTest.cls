@isTest
private class connCompCTLTest {

     static testMethod void doTest() {
      Issue_Tracker__c it = new Issue_Tracker__c(Status__c='In Process');
      it.CreatedDate = date.today();  
      Test.startTest();
        connCompCTL ctrl = new connCompCTL(new ApexPages.StandardController(it));
         
      Test.stopTest(); 
     }
     static testMethod void doTest1() {
      Issue_Tracker__c it = new Issue_Tracker__c(Status__c='Closed');
      it.Assignment_Date__c = date.today();  
      it.CreatedDate = date.today();
      it.Closure_Date__c = date.today();   
      Test.startTest();
        connCompCTL ctrl = new connCompCTL(new ApexPages.StandardController(it));
         
      Test.stopTest(); 
     }
    
}