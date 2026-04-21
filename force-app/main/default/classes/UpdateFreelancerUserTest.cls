@isTest
global class UpdateFreelancerUserTest {

      @isTest(SeeAllData=true) static void testScheduleIt2() {
        Test.startTest();
         list<user> ulst= [SELECT Id, Name, contact.account.lc__c, isFrl__c, contact.account.Name,
             accname__c, Licvalid__c from user WHERE contact.account.Legal_Framework__c='Freelancer' and isactive=true and profile.name='Z' LIMIT 1];
         update ulst;
        Test.setMock(HttpCalloutMock.class, new GetMngrInc());
          UpdateFreelancerUser obj1 = new UpdateFreelancerUser();
          Database.executeBatch(obj1);

        Test.stopTest();
    }

     global class GetMngrInc implements HTTPCalloutMock{
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HTTPResponse();
            String endPoint = req.getEndpoint();
            res.setHeader('Content-Type', 'application/JSON');
            if (endPoint.contains('RnLIntegrationActLoc'))
               res.setBody('{"MethodName":"getActivities", "locationList":null, "LicnseNo":"19299", "errorCode":"0", "error":"", "act":[{"type":"Office", "titleList":[], "StartDate":"2016-03-31", "segName":"Design", "Name":"Consultancy", "LicenseNo":"19299", "error":"", "chanList":[], "ActivityId":"a2GN0000001LYzOMAW", "accName":null}, {"type":"Office", "titleList":[], "StartDate":"2016-03-31", "segName":"Design", "Name":"Concept Design", "LicenseNo":"19299", "error":"", "chanList":[], "ActivityId":"a2GN0000001LYzPMAW", "accName":null}]}');
            else
               res.setBody('[{"accLicNo":"33333", "salutation":"Mr.", "firstName":"Super33", "lastName":"axs333", "mobile":"050001111", "email":"sacx.h@tecomgroup.ae", "passportNo":"Test123", "nationality":"Tunisia"}]');
            res.setStatusCode(200);
            return res;
        }
    }

}