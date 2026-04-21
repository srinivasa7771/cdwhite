@isTest
public class grecccTest {

    @IsTest
    private static void checkTrnTest() {
        list < gStg__c > stgs = new list < gStg__c > ();
        stgs.add(new gStg__c(Name = 'NI-APIKEY', Checkbox_Value__c = true, Text_Value__c = 'test', Number_Value__c = 0, Currency_Value__c = 0));
        stgs.add(new gStg__c(Name = 'NIENDPOINT', Checkbox_Value__c = true, Text_Value__c = 'test', Number_Value__c = 0, Currency_Value__c = 0));
        stgs.add(new gStg__c(Name = 'NIPAYMENTURL', Checkbox_Value__c = true, Text_Value__c = 'test', Number_Value__c = 0, Currency_Value__c = 0));
        insert stgs;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockApplicationProcess());
        greccc cls = new greccc();
        List < greccc.PaymentRes > stas = new List < greccc.PaymentRes > ();
        Set < String > tids = new Set < String > ();
        Map < String, greccc.PaymentRes > repMap = new Map < String, greccc.PaymentRes > ();
        list < g_Tran__c > trans;
        greccc.PaymentRes tt = cls.getPaymentResponse('a0F28000000UcZWEA0');
        Test.stopTest();



    }


    @IsTest
    private static void parseDateDEGTest() {

        greccc cls = new greccc();
        cls.parseDateDEG('10/05/2016 03:47:23');

    }

    public class MockApplicationProcess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"tst","_id":"urn:order:28c58a82-1828-44e4-bb9f-48d6812cd27b","_links":{"self":{"href":"https://api-gateway.ngenius-payments.com/transactions/outlets/0313c75d-e644-4114-a067-026a6976dd99/orders/28c58a82-1828-44e4-bb9f-48d6812cd27b"},"tenant-brand":{"href":"http://config-service/config/outlets/0313c75d-e644-4114-a067-026a6976dd99/configs/tenant-brand"},"merchant-brand":{"href":"http://config-service/config/outlets/0313c75d-e644-4114-a067-026a6976dd99/configs/merchant-brand"}},"type":"SINGLE","merchantDefinedData":{},"action":"SALE","amount":{"currencyCode":"AED","value":45000},"language":"en","merchantAttributes":{"skipConfirmationPage":"true","redirectUrl":"https://axs.force.com/grqpyc"},"emailAddress":"zeeshan.aftab@10pearls.com","reference":"28c58a82-1828-44e4-bb9f-48d6812cd27b","outletId":"0313c75d-e644-4114-a067-026a6976dd99","createDateTime":"2019-12-12T12:16:13.404Z","paymentMethods":{"card":["VISA","MASTERCARD","DINERS_CLUB_INTERNATIONAL"]},"referrer":"urn:Ecom:28c58a82-1828-44e4-bb9f-48d6812cd27b","formattedAmount":"د.إ.‏ 450","formattedOrderSummary":{},"_embedded":{"payment":[{"_id":"urn:payment:d49e95b2-6e3a-42cc-bfcc-e0d2d2d04d1e","_links":{"self":{"href":"https://api-gateway.ngenius-payments.com/transactions/outlets/0313c75d-e644-4114-a067-026a6976dd99/orders/28c58a82-1828-44e4-bb9f-48d6812cd27b/payments/d49e95b2-6e3a-42cc-bfcc-e0d2d2d04d1e"},"curies":[{"name":"cnp","href":"https://api-gateway.ngenius-payments.com/docs/rels/{rel}","templated":true}]},"paymentMethod":{"expiry":"2022-04","cardholderName":"Zeeshan Aftab","name":"MASTERCARD","pan":"552778******4018"},"state":"POST_AUTH_REVIEW","amount":{"currencyCode":"AED","value":45000},"updateDateTime":"2019-12-12T12:19:20.309Z","outletId":"0313c75d-e644-4114-a067-026a6976dd99","orderReference":"28c58a82-1828-44e4-bb9f-48d6812cd27b","authResponse":{"authorizationCode":"093412","success":true,"resultCode":"00","resultMessage":"Successful approval/completion or that VIP PIN verification is valid"},"3ds":{"status":"SUCCESS"}}]}}');
            res.setStatusCode(200);
            return res;
        }
    }

}