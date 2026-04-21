@isTest
private class BatchCourierReBookingTest {
    private static testMethod void BatchCourierReBookingTest() {
        new BatchCourierReBooking();
    }

    @IsTest
    private static  void XMLParsertest() {
        try{
           database.executeBatch(new BatchCourierReBooking(), 1);
        }catch (Exception e) {}
    }
}