@isTest
public class grwsFetchAccTest {

    static TestMethod void doTest() {
        Test.startTest();
           Account acc = new Account();
           acc.name = 'Test Acc';
           acc.lc__c = '234324535';
           acc.lcsta__c = 'License Issued';
          acc.Legal_Framework__c = 'Freelancer';
          acc.lcidt__c = date.today();
          acc.lcedt__c = date.today().addDays(10);
         insert acc;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.params.put('accid', acc.id);
        RestContext.request = req;
        RestContext.response = res;
        grwsFetchAcc.getAccInfo();

        Test.stopTest();

    }

     static TestMethod void doTest1() {
          Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.params.put('accid', '435346436');
        RestContext.request = req;
        RestContext.response = res;
        grwsFetchAcc.getAccInfo();

        Test.stopTest();
     }

}