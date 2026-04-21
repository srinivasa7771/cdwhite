@isTest
public class WS_EdlAxsTest {
    @isTest
    static void teste() {

        WS_EdlAxs.ReqData acc = new WS_EdlAxs.ReqData();
            acc.assistanceSubType = 'testSubType';
            acc.assistanceTime = '102';
            acc.assistanceType = '0';
            acc.CounterNumber = '3';
            acc.entityID = '11';
            acc.entityName = 'Tecom-DCCA';
            acc.mobileNumber = '';
            acc.serviceName = 'Corporate Services';
            acc.subServiceSelection = '14';
            acc.ticketIssueTime = '2020/09/24 11:44:20';
            acc.ticketNumber = '12';
            acc.ticketType = '0';
            acc.user = 'TestUser';
            acc.waitingTime = '339';
         List<WS_EdlAxs.ReqData> listRqData = new List<WS_EdlAxs.ReqData>();
        listRqData.add(acc);
        WS_EdlAxs.TokenDetails tokenDetails = new WS_EdlAxs.TokenDetails();
        tokenDetails.TokenDetails = listRqData;
            String myJSON = JSON.serialize(tokenDetails);
         Test.startTest();
       // RestContext.response.addHeader('Content-Type', 'application/json');
        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        request.requestUri ='/services/apexrest/edlaxsint';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);

        RestContext.request = request;
   RestContext.response= res;

        //RestContext.request = request;
        WS_EdlAxs.postRequest();

    }

}