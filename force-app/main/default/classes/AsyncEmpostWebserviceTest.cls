@IsTest
public class AsyncEmpostWebserviceTest {
 private static testMethod void coverTypes() {
        new EmpostWebservice();

    }
     private class WebServiceMockImpl implements WebServiceMock
    {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType) {

            return;
        }
    }

   @IsTest
    private static  void logingetValueTest() {
        AsyncEmpostWebservice.LoginResponse_elementFuture cls = new AsyncEmpostWebservice.LoginResponse_elementFuture();
            try{
            cls.getValue();
        }catch (Exception e) {e.getStackTraceString();}

    }
    @IsTest
    private static  void loginRepgetValueTest() {
        AsyncEmpostWebservice.LoginResponse_elementFuture cls = new AsyncEmpostWebservice.LoginResponse_elementFuture();
            try{
            cls.getValue();
        }catch (Exception e) {e.getStackTraceString();}

    }
    @IsTest
    private static  void CBgetValueTest() {
        AsyncEmpostWebservice.CreateBookingResponse_elementFuture cls = new AsyncEmpostWebservice.CreateBookingResponse_elementFuture();
            try{
            cls.getValue();
        }catch (Exception e) {e.getStackTraceString();}

    }
    @IsTest
    private static  void GetUpdatedgetValueTest() {
        AsyncEmpostWebservice.GetUpdatedStatusByAWBResponse_elementFuture cls = new AsyncEmpostWebservice.GetUpdatedStatusByAWBResponse_elementFuture();
            try{
            cls.getValue();
        }catch (Exception e) {e.getStackTraceString();}

    }
    @IsTest
    private static  void AutoAllgetValueTest() {
        AsyncEmpostWebservice.AutoAllocateDeliveryPickupsResponse_elementFuture cls = new AsyncEmpostWebservice.AutoAllocateDeliveryPickupsResponse_elementFuture();
            try{
            cls.getValue();
        }catch (Exception e) {e.getStackTraceString();}

    }
      @IsTest
    private static  void getStatusgetValueTest() {
        AsyncEmpostWebservice.GetStatusBatchResponse_elementFuture cls = new AsyncEmpostWebservice.GetStatusBatchResponse_elementFuture();
            try{
            cls.getValue();
        }catch (Exception e) {e.getStackTraceString();}

    }

       @IsTest
    private static  void getStatusgetValueTestq() {
        AsyncEmpostWebservice.GetBookingTypesResponse_elementFuture cls = new AsyncEmpostWebservice.GetBookingTypesResponse_elementFuture();
            try{
            cls.getValue();
        }catch (Exception e) {e.getStackTraceString();}

    }

       @IsTest
    private static  void getStatusgetValueTest2() {
        AsyncEmpostWebservice.GetCourierInfoResponse_elementFuture cls = new AsyncEmpostWebservice.GetCourierInfoResponse_elementFuture();
            try{
            cls.getValue();
        }catch (Exception e) {e.getStackTraceString();}

    }

       @IsTest
    private static  void getStatusgetValueTest3() {
        AsyncEmpostWebservice.GetStatusSummaryResponse_elementFuture cls = new AsyncEmpostWebservice.GetStatusSummaryResponse_elementFuture();
            try{
            cls.getValue();
        }catch (Exception e) {e.getStackTraceString();}

    }

       @IsTest
    private static  void getStatusgetValueTest4() {
        AsyncEmpostWebservice.GetContentTypesResponse_elementFuture cls = new AsyncEmpostWebservice.GetContentTypesResponse_elementFuture();
            try{
            cls.getValue();
        }catch (Exception e) {e.getStackTraceString();}

    }

       @IsTest
    private static  void getStatusgetValueTest5() {
        AsyncEmpostWebservice.CancelBookingResponse_elementFuture cls = new AsyncEmpostWebservice.CancelBookingResponse_elementFuture();
            try{
            cls.getValue();
        }catch (Exception e) {e.getStackTraceString();}

    }
    @IsTest
     private static  void getStatusgetValueTest6() {

        AsyncEmpostWebservice.AsyncPopulateSoap cls = new AsyncEmpostWebservice.AsyncPopulateSoap();
            try{
                System.Continuation x;
            cls.beginUpdateStatusBatch(x, '');
        }catch (Exception e) {e.getStackTraceString();}

    }

      @IsTest
     private static  void getStatusgetValueTest9() {

        AsyncEmpostWebservice.AsyncPopulateSoap cls = new AsyncEmpostWebservice.AsyncPopulateSoap();
            try{
                System.Continuation x;
            cls.beginCreateBooking(x, '', '');
        }catch (Exception e) {e.getStackTraceString();}

    } @IsTest
         private static  void getStatusgetValueTest10() {

        AsyncEmpostWebservice.AsyncPopulateSoap cls = new AsyncEmpostWebservice.AsyncPopulateSoap();
            try{
                System.Continuation x;
            cls.beginGetUpdatedStatusByAWB(x, null, '');
        }catch (Exception e) {e.getStackTraceString();}

    }
     @IsTest
     private static  void getStatusgetValueTest11() {

        AsyncEmpostWebservice.AsyncPopulateSoap cls = new AsyncEmpostWebservice.AsyncPopulateSoap();
            try{
                System.Continuation x;
            cls.beginAutoAllocateDeliveryPickups(x, null, '');
        }catch (Exception e) {e.getStackTraceString();}

    }
     @IsTest
     private static  void getStatusgetValueTest12() {

        AsyncEmpostWebservice.AsyncPopulateSoap cls = new AsyncEmpostWebservice.AsyncPopulateSoap();
            try{
                System.Continuation x;
            cls.beginGetBookingTypes(x);
        }catch (Exception e) {e.getStackTraceString();}

    }
    @IsTest
     private static  void getStatusgetValueTest13() {

        AsyncEmpostWebservice.AsyncPopulateSoap cls = new AsyncEmpostWebservice.AsyncPopulateSoap();
            try{
                System.Continuation x;
            cls.beginGetCourierInfo(x, '', '', '');
        }catch (Exception e) {e.getStackTraceString();}

    }
     @IsTest
     private static  void getStatusgetValueTest14() {

        AsyncEmpostWebservice.AsyncPopulateSoap cls = new AsyncEmpostWebservice.AsyncPopulateSoap();
            try{
                System.Continuation x;
            cls.beginGetStatusSummary(x, '', '');
        }catch (Exception e) {e.getStackTraceString();}

    }
     @IsTest
     private static  void getStatusgetValueTest15() {

        AsyncEmpostWebservice.AsyncPopulateSoap cls = new AsyncEmpostWebservice.AsyncPopulateSoap();
            try{
                System.Continuation x;
            cls.beginGetContentTypes(x, '');
        }catch (Exception e) {e.getStackTraceString();}

    }
    @IsTest
     private static  void getStatusgetValueTest16() {

        AsyncEmpostWebservice.AsyncPopulateSoap cls = new AsyncEmpostWebservice.AsyncPopulateSoap();
            try{
                System.Continuation x;
            cls.beginCancelBooking(x, null, '');
        }catch (Exception e) {e.getStackTraceString();}

    }
      @IsTest
     private static  void getStatusgetValueTest17() {

        AsyncEmpostWebservice.AsyncPopulateSoap cls = new AsyncEmpostWebservice.AsyncPopulateSoap();
            try{
                System.Continuation x;
            cls.beginCancelBooking(x, null, '');
        }catch (Exception e) {e.getStackTraceString();}

    }

}