@isTest(SeeAllData=false)
private class grwsUpdateAccTest {

      static testMethod void unitTest01() {
          Test.startTest();
             Account a=testData.accCrt(false);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/updateaccinfo/';

        String postData = '{"partyId":"32023", "AddOnVisa":3}';

        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;

        grwsUpdateAcc.updateAccInfo();

          Test.stopTest();
      }
    static testMethod void unitTest02() {
          Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/updateaccinfo/';

        String postData = '{"partyId":"32024", "AddOnVisa":3}';

        req.requestBody = Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;

        grwsUpdateAcc.updateAccInfo();

          Test.stopTest();
      }
}