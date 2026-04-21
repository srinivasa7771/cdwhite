@isTest
private class gctlPplTest {

    @testSetup static void setup() {
        
        List<gStg__c> lstGStg = new List<gStg__c>();
        gStg__c outsource = new gStg__c(name='All_Outsourced',Text_Value__c = 'STA__c != \'InActive\' and os__c = true');
        lstGStg.add(outsource);
        gStg__c empl = new gStg__c(name='All_Employees',Text_Value__c = 'STA__c != \'InActive\' and (rol__c = \'Employee\' or rol__c = \'Non Sponsored\' or rol__c = \'Access Card\' )');
        lstGStg.add(empl);
        insert lstGStg;
    }
    static testMethod void doTest() {
     Test.startTest(); 
      testData.init();
       Account a=testData.accCrt(false);
      List<Contact> conlst = new List<Contact>();
      conlst.add(new Contact(Salutation='Mr.',firstName='fName1',lastName='lName1',STA__c='Active',rol__c='Employee',p__c='Pass1',pid__c=date.today(),ped__c=date.today().addYears(1),bc__c='Egypt',pic__c='Egypt',Accountid=a.id,os__c = true));
      conlst.add(new Contact(Salutation='Mr.',firstName='fName2',lastName='lName2',STA__c='Active',rol__c='Non Sponsored',p__c='Pass2',pid__c=date.today(),ped__c=date.today().addYears(1),bc__c='Egypt',pic__c='Egypt',Accountid=a.id,os__c = true));
      insert conlst;
      ApexPages.currentPage().getParameters().put('id',a.id);
      ApexPages.currentPage().getParameters().put('p','All_Outsourced');
      ApexPages.currentPage().getParameters().put('d','0');
      gctlPpl cntrl = new gctlPpl(new ApexPages.StandardController(a));
      cntrl.gCon();  
     Test.stopTest(); 
  }
   static testMethod void doTest1() {
     Test.startTest(); 
      testData.init();
       Account a=testData.accCrt(false);
      List<Contact> conlst = new List<Contact>();
      conlst.add(new Contact(Salutation='Mr.',firstName='fName1',lastName='lName1',STA__c='Active',rol__c='Employee',p__c='Pass1',pid__c=date.today(),ped__c=date.today().addYears(1),bc__c='Egypt',pic__c='Egypt',Accountid=a.id,os__c = true));
      conlst.add(new Contact(Salutation='Mr.',firstName='fName2',lastName='lName2',STA__c='Active',rol__c='Non Sponsored',p__c='Pass2',pid__c=date.today(),ped__c=date.today().addYears(1),bc__c='Egypt',pic__c='Egypt',Accountid=a.id,os__c = true));
      insert conlst;
      ApexPages.currentPage().getParameters().put('id',a.id);
      ApexPages.currentPage().getParameters().put('p','All_Employees');
      ApexPages.currentPage().getParameters().put('d','0');
      gctlPpl cntrl = new gctlPpl(new ApexPages.StandardController(a));
      cntrl.gCon();  
      ApexPages.currentPage().getParameters().put('p','All_Employe');
      cntrl.gCon();  
     Test.stopTest(); 
  }  
  static testMethod void doTest2() {
     Test.startTest(); 
      testData.init();
       Account a=testData.accCrt(false);
      List<Contact> conlst = new List<Contact>();
      conlst.add(new Contact(Salutation='Mr.',firstName='fName1',lastName='lName1',STA__c='Active',rol__c='Employee',p__c='Pass1',pid__c=date.today(),ped__c=date.today().addYears(1),bc__c='Egypt',pic__c='Egypt',Accountid=a.id,os__c = true));
      conlst.add(new Contact(Salutation='Mr.',firstName='fName2',lastName='lName2',STA__c='Active',rol__c='Non Sponsored',p__c='Pass2',pid__c=date.today(),ped__c=date.today().addYears(1),bc__c='Egypt',pic__c='Egypt',Accountid=a.id,os__c = true));
      insert conlst;
      ApexPages.currentPage().getParameters().put('id',a.id);
      ApexPages.currentPage().getParameters().put('d','0');
      gctlPpl cntrl = new gctlPpl(new ApexPages.StandardController(a));
      cntrl.gCon();  
     
     Test.stopTest(); 
  }    
}