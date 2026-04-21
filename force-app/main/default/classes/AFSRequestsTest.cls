@IsTest
public class AFSRequestsTest {
    @IsTest
    static void testAFSRequests() {
        AFSRequests afsRequests = new AFSRequests();
        afsRequests.openAFSRequests = new List<openAFSRequests>();
        afsRequests.license = 102889;

        System.assertEquals(afsRequests.openAFSRequests, new List<openAFSRequests>());
        System.assertEquals(afsRequests.license, 102889);
    }
}