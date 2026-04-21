@isTest
public class ctrlLAReqWrapperTest {
    @isTest
    static void testWrapper() {
        // Create test data
        String json = '{"serviceRequests":[{"serviceId":"a15F700000OoYx5IAF", "licenseNo":"30006", "activities":[{"name":"Research and Information Services", "ddaId":"a12D0000001YymZIAS", "actionType":"ADD", "channelTitles":[], "noOfTitleAndChannels":null}, {"name":"Dubbing/subtitling", "ddaId":"a12D0000001YyfJIAS", "actionType":"ADD", "channelTitles":[], "noOfTitleAndChannels":null}], "members":[], "locations":null, "companyInfo":null, "isPaid":null, "ddaSegmentId":null}]}';
        ctrlLAReqWrapper.parse(json);
        ctrlLAReqWrapper wrapper = new ctrlLAReqWrapper();

        // Create sample activities
        ctrlLAReqWrapper.Activities activity1 = new ctrlLAReqWrapper.Activities();
        activity1.name = 'Activity 1';
        activity1.ddaId = 'DDA001';
        activity1.actionType = 'Type A';
        activity1.channelTitles = new List<ctrlLAReqWrapper.ChannelTitles>();
        activity1.noOfTitleAndChannels = 5;

        ctrlLAReqWrapper.Activities activity2 = new ctrlLAReqWrapper.Activities();
        activity2.name = 'Activity 2';
        activity2.ddaId = 'DDA002';
        activity2.actionType = 'Type B';
        activity2.channelTitles = new List<ctrlLAReqWrapper.ChannelTitles>();
        activity2.noOfTitleAndChannels = 3;

        // Create sample service requests
        ctrlLAReqWrapper.ServiceRequests request1 = new ctrlLAReqWrapper.ServiceRequests();
        request1.serviceId = 'Service001';
        request1.licenseNo = 123456;
        request1.activities = new List<ctrlLAReqWrapper.Activities>{activity1, activity2};
        request1.members = new List<ctrlLAReqWrapper.ChannelTitles>();
        request1.locations = null;
        request1.companyInfo = null;
        request1.isPaid = false;
        request1.ddaSegmentId = 'Segment001';

        // Add service requests to the wrapper
        wrapper.serviceRequests = new List<ctrlLAReqWrapper.ServiceRequests>{request1};

        // Assert that the wrapper is not null
        System.assertNotEquals(null, wrapper);

        // Assert that the service requests list is not null and contains one item
        System.assertNotEquals(null, wrapper.serviceRequests);
        System.assertEquals(1, wrapper.serviceRequests.size());

        // Assert details of the service request
        ctrlLAReqWrapper.ServiceRequests retrievedRequest = wrapper.serviceRequests[0];
        System.assertEquals('Service001', retrievedRequest.serviceId);
        System.assertEquals(123456, retrievedRequest.licenseNo);
        System.assertEquals(2, retrievedRequest.activities.size());
        // Add more assertions for other fields as needed
    }
}