@IsTest
public class AXS_Call_Center_WSTest {

static testMethod void testdoPost() {

        Task t = new Task(Subject='test', Status='New', Priority='Normal', CallType='Outbound', CallObject='xxxxxxx');

        String restURL = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/AXSCSWS/';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = restURL;
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        Map<String, String> params = new Map<String, String>();
        params.put('CallObjectId', 'xxxxxxx');
        params.put('Rating', '4');

        test.startTest();
        insert t;
        AXS_Call_Center_WS.AXSJsonResponse jResponse = AXS_Call_Center_WS.doPost('UpdateRating', params);
        AXS_Call_Center_WS.AXSJsonResponse jResponse2 = AXS_Call_Center_WS.doPost('Status', params);
        AXS_Call_Center_WS.AXSJsonResponse jResponse3 = AXS_Call_Center_WS.doPost('test', params);
        test.stopTest();

}

}