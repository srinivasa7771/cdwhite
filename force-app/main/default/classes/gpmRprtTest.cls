@isTest
private class gpmRprtTest {
  static testMethod void doTest() {
     Test.startTest();
      testData.init();
       Account a=testData.accCrt(false);
      List<Contact> conlst = new List<Contact>();
      conlst.add(new Contact(Salutation='Mr.', firstName='fName1', lastName='lName1',
          STA__c='Active', rol__c='Employee', p__c='Pass1', pid__c=date.today(),
          ped__c=date.today().addYears(1), bc__c='Egypt', pic__c='Egypt',
          Accountid=a.id, os__c = true));
      conlst.add(new Contact(Salutation='Mr.', firstName='fName2', lastName='lName2',
          STA__c='Active', rol__c='Non Sponsored', p__c='Pass2', pid__c=date.today(),
          ped__c=date.today().addYears(1), bc__c='Egypt', pic__c='Egypt',
          Accountid=a.id, os__c = true));
      insert conlst;
      ApexPages.currentPage().getParameters().put('accid', a.id);
      gpmRprt cntrl = new gpmRprt();
     Test.stopTest();
  }

}