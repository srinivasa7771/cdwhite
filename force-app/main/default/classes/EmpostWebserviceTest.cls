@isTest
private class EmpostWebserviceTest  {
 private static  void coverTypes() {
        new EmpostWebservice.GetBookingTypes_element();
          new EmpostWebservice.CreateBookingResponse_element();
        new EmpostWebservice.GetStatusBatchResponse_element();
        new EmpostWebservice.GetStatusSummaryResponse_element();
        new EmpostWebservice.GetUpdatedStatusByAWBResult_element();
        EmpostWebservice.GetBookingTypes_element obj = new EmpostWebservice.GetBookingTypes_element();
         obj.apex_schema_type_info = obj.apex_schema_type_info;
        obj.field_order_type_info = obj.field_order_type_info;
        EmpostWebservice.LoginResponse_element ob1= new EmpostWebservice.LoginResponse_element();
          ob1.LoginResult_type_info=ob1.LoginResult_type_info;
        ob1.apex_schema_type_info=ob1.apex_schema_type_info;
       ob1.field_order_type_info=ob1.field_order_type_info;

        new EmpostWebservice.LoginResponse_element();
        EmpostWebservice.LoginResponse_element ob2= new EmpostWebservice.LoginResponse_element();
        ob2.LoginResult=ob2.LoginResult;

        EmpostWebservice.CreateBookingResponse_element ob3=  new EmpostWebservice.CreateBookingResponse_element();
        ob3.CreateBookingResult=ob3.CreateBookingResult;

        EmpostWebservice.GetUpdatedStatusByAWBResult_element ob4=  new EmpostWebservice.GetUpdatedStatusByAWBResult_element();
        ob4.Booking=ob4.Booking;
        ob4.apex_schema_type_info=ob2.apex_schema_type_info;
       ob4.field_order_type_info=ob2.field_order_type_info;
        new EmpostWebservice.GetUpdatedStatusByAWB_element();

         EmpostWebservice.GetUpdatedStatusByAWB_element ob5=  new EmpostWebservice.GetUpdatedStatusByAWB_element();
        ob5.authenticationToken=ob5.authenticationToken;
        ob5.awb=ob5.awb;
      ob5.awb_type_info=ob5.awb_type_info;
        ob5.authenticationToken=ob5.authenticationToken;
      ob5.authenticationToken_type_info=ob5.authenticationToken_type_info;
      ob5.apex_schema_type_info=ob5.apex_schema_type_info;
      ob5.field_order_type_info=ob5.field_order_type_info;

        EmpostWebservice.Booking_element ob6=  new EmpostWebservice.Booking_element();
        ob6.StatusInfo=ob6.StatusInfo;

        EmpostWebservice.TransitConsignment_element ob7=new EmpostWebservice.TransitConsignment_element();
        ob7.apex_schema_type_info=ob7.apex_schema_type_info;
       ob7.field_order_type_info=ob7.field_order_type_info;
          EmpostWebservice.GetDetailByCreatedOnResponse_element ob8=new EmpostWebservice.GetDetailByCreatedOnResponse_element();
        ob8.apex_schema_type_info=ob8.apex_schema_type_info;
       ob8.field_order_type_info=ob8.field_order_type_info;
        ob8.GetDetailByCreatedOnResult=ob8.GetDetailByCreatedOnResult;
        ob8.GetDetailByCreatedOnResult_type_info=ob8.GetDetailByCreatedOnResult_type_info;

          new EmpostWebservice.Booking_element();
          new EmpostWebservice.ArrayOfBOOKINGTYPE();
          new EmpostWebservice.CreateBooking_element();
          new EmpostWebservice.AutoAllocateDeliveryPickups_element();
          new EmpostWebservice.StatusInfo_element();
          new EmpostWebservice.GetContentTypes_element();
          new EmpostWebservice.Login_element();
          new EmpostWebservice.CancelBookingResponse_element();
          new EmpostWebservice.GetCourierInfoResponse_element();
          new EmpostWebservice.CancelBooking_element();
        new EmpostWebservice.AutoAllocateDeliveryPickupsResponse_element();
         new EmpostWebservice.GetCourierInfo_element();
         new EmpostWebservice.UpdateStatusBatch_element();
         new EmpostWebservice.GetBookingTypesResponse_element();
         new EmpostWebservice.UpdateStatusBatchResponse_element();
        new EmpostWebservice.PopulateSoap();
        new EmpostWebservice.PopulateSoap().GetDetailByUpdatedOn('', '');
new EmpostWebservice.PopulateSoap().updateManual() ;

    }
     private class WebServiceMockImpl implements WebServiceMock
    {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType) {   if (request instanceof EmpostWebservice.Login_element)
                response.put('response_x', new EmpostWebservice.Login_element());

               return;
        }

    }

    @IsTest
    private static  void loginTest() {

                new EmpostWebservice.GetBookingTypes_element();
          new EmpostWebservice.CreateBookingResponse_element();
        new EmpostWebservice.GetStatusBatchResponse_element();
        new EmpostWebservice.GetStatusSummaryResponse_element();
        new EmpostWebservice.GetUpdatedStatusByAWBResult_element();
        EmpostWebservice.GetBookingTypes_element obj = new EmpostWebservice.GetBookingTypes_element();
         obj.apex_schema_type_info = obj.apex_schema_type_info;
        obj.field_order_type_info = obj.field_order_type_info;
        EmpostWebservice.LoginResponse_element ob1= new EmpostWebservice.LoginResponse_element();
          ob1.LoginResult_type_info=ob1.LoginResult_type_info;
        ob1.apex_schema_type_info=ob1.apex_schema_type_info;
       ob1.field_order_type_info=ob1.field_order_type_info;

        new EmpostWebservice.LoginResponse_element();
        EmpostWebservice.LoginResponse_element ob2= new EmpostWebservice.LoginResponse_element();
        ob2.LoginResult=ob2.LoginResult;

        EmpostWebservice.CreateBookingResponse_element ob3=  new EmpostWebservice.CreateBookingResponse_element();
        ob3.CreateBookingResult=ob3.CreateBookingResult;

        EmpostWebservice.GetUpdatedStatusByAWBResult_element ob4=  new EmpostWebservice.GetUpdatedStatusByAWBResult_element();
        ob4.Booking=ob4.Booking;
        ob4.apex_schema_type_info=ob2.apex_schema_type_info;
       ob4.field_order_type_info=ob2.field_order_type_info;
        new EmpostWebservice.GetUpdatedStatusByAWB_element();

         EmpostWebservice.GetUpdatedStatusByAWB_element ob5=  new EmpostWebservice.GetUpdatedStatusByAWB_element();
        ob5.authenticationToken=ob5.authenticationToken;
        ob5.awb=ob5.awb;
      ob5.awb_type_info=ob5.awb_type_info;
        ob5.authenticationToken=ob5.authenticationToken;
      ob5.authenticationToken_type_info=ob5.authenticationToken_type_info;
      ob5.apex_schema_type_info=ob5.apex_schema_type_info;
      ob5.field_order_type_info=ob5.field_order_type_info;

        EmpostWebservice.Booking_element ob6=  new EmpostWebservice.Booking_element();
        ob6.StatusInfo=ob6.StatusInfo;

        EmpostWebservice.TransitConsignment_element ob7=new EmpostWebservice.TransitConsignment_element();
        ob7.apex_schema_type_info=ob7.apex_schema_type_info;
       ob7.field_order_type_info=ob7.field_order_type_info;

        EmpostWebservice.GetDetailByCreatedOnResponse_element ob8=new EmpostWebservice.GetDetailByCreatedOnResponse_element();
        ob8.apex_schema_type_info=ob8.apex_schema_type_info;
        ob8.field_order_type_info=ob8.field_order_type_info;

        EmpostWebservice.GetDetailByUpdatedOn_element ob9=new EmpostWebservice.GetDetailByUpdatedOn_element();
        ob9.apex_schema_type_info=ob9.apex_schema_type_info;
        ob9.field_order_type_info=ob9.field_order_type_info;
        ob8.GetDetailByCreatedOnResult=ob8.GetDetailByCreatedOnResult;
        ob8.GetDetailByCreatedOnResult_type_info=ob8.GetDetailByCreatedOnResult_type_info;

        EmpostWebservice.GetUpdatedStatusByAWBResponse_element ob10=new EmpostWebservice.GetUpdatedStatusByAWBResponse_element();
        ob10.apex_schema_type_info=ob10.apex_schema_type_info;
        ob10.field_order_type_info=ob10.field_order_type_info;

        EmpostWebservice.ArrayOfBOOKINGTYPE ob11=new EmpostWebservice.ArrayOfBOOKINGTYPE();
        ob11.apex_schema_type_info=ob11.apex_schema_type_info;
        ob11.field_order_type_info=ob11.field_order_type_info;

         EmpostWebservice.StatusInfo_element ob12=new EmpostWebservice.StatusInfo_element();
        ob12.apex_schema_type_info=ob12.apex_schema_type_info;
        ob12.field_order_type_info=ob12.field_order_type_info;

        EmpostWebservice.TransitConsignmentResponse_element ob13=new EmpostWebservice.TransitConsignmentResponse_element();
        ob13.apex_schema_type_info=ob13.apex_schema_type_info;
        ob13.field_order_type_info=ob13.field_order_type_info;

         EmpostWebservice.GetDetailByUpdatedOnResponse_element ob14=new EmpostWebservice.GetDetailByUpdatedOnResponse_element();
        ob14.apex_schema_type_info=ob14.apex_schema_type_info;
        ob14.field_order_type_info=ob14.field_order_type_info;

         EmpostWebservice.GetContentTypesResponse_element ob15=new EmpostWebservice.GetContentTypesResponse_element();
        ob15.apex_schema_type_info=ob15.apex_schema_type_info;
        ob15.field_order_type_info=ob15.field_order_type_info;

          EmpostWebservice.CancelBookingResponse_element ob16=new EmpostWebservice.CancelBookingResponse_element();
        ob16.apex_schema_type_info=ob16.apex_schema_type_info;
        ob16.field_order_type_info=ob16.field_order_type_info;

        EmpostWebservice.GetCourierInfoResponse_element ob17=new EmpostWebservice.GetCourierInfoResponse_element();
        ob17.apex_schema_type_info=ob17.apex_schema_type_info;
        ob17.field_order_type_info=ob17.field_order_type_info;
            EmpostWebservice.updateManualResponse_element ob18=new EmpostWebservice.updateManualResponse_element();
        ob18.apex_schema_type_info=ob18.apex_schema_type_info;
        ob18.field_order_type_info=ob18.field_order_type_info;

         EmpostWebservice.AutoAllocateDeliveryPickupsResponse_element ob19=new EmpostWebservice.AutoAllocateDeliveryPickupsResponse_element();
        ob19.apex_schema_type_info=ob19.apex_schema_type_info;
        ob19.field_order_type_info=ob19.field_order_type_info;

             EmpostWebservice.updateManualResponse_element ob20=new EmpostWebservice.updateManualResponse_element();
        ob20.apex_schema_type_info=ob20.apex_schema_type_info;
        ob20.field_order_type_info=ob20.field_order_type_info;

          EmpostWebservice.AutoAllocateDeliveryPickupsResponse_element ob21=new EmpostWebservice.AutoAllocateDeliveryPickupsResponse_element();
        ob21.apex_schema_type_info=ob21.apex_schema_type_info;
        ob21.field_order_type_info=ob21.field_order_type_info;

          EmpostWebservice.UpdateStatusBatchResult_element ob22=new EmpostWebservice.UpdateStatusBatchResult_element();
        ob22.apex_schema_type_info=ob22.apex_schema_type_info;
        ob22.field_order_type_info=ob22.field_order_type_info;

           EmpostWebservice.GetBookingTypesResponse_element ob23=new EmpostWebservice.GetBookingTypesResponse_element();
        ob23.apex_schema_type_info=ob23.apex_schema_type_info;
        ob23.field_order_type_info=ob23.field_order_type_info;
              EmpostWebservice.UpdateStatusBatchResponse_element ob24=new EmpostWebservice.UpdateStatusBatchResponse_element();
        ob24.apex_schema_type_info=ob24.apex_schema_type_info;
        ob24.field_order_type_info=ob24.field_order_type_info;

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
            try{
            cls.Login('13291', '123');
        }catch (Exception e) {e.getStackTraceString();}

    }

     @IsTest
    private static  void GetDetailByUpdatedOnTest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
            cls.GetDetailByUpdatedOn('', '');
        }catch (Exception e) {}

    }

    @IsTest
    private static  void updateManualtest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
            cls.updateManual();
        }catch (Exception e) {}

    }
    @IsTest
    private static  void TansitConsignmenttest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
            cls.TransitConsignment();
        }catch (Exception e) {}

    }
    @IsTest
    private static  void UpdateStatusBatchtest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
            cls.UpdateStatusBatch('18-Apr-2015');
        }catch (Exception e) {}

    }
     @IsTest
    private static  void GetBookingTypesTest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
           EmpostWebservice.ArrayOfBOOKINGTYPE vbooking = cls.GetBookingTypes();
            System.debug('--vbooking-- : ' +vbooking);
        }catch (Exception e) {}

    }
     @IsTest
    private static  void GetContentTypesTest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
            String  vbooking = cls.GetContentTypes('bf2975ad4f4e4fc5bd512a697ad09c92');
            System.debug('--vbooking-- : ' +vbooking);
        }catch (Exception e) {}

    }

     @IsTest
    private static  void GetUpdatedStatusByAWBTest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
              String[] AWBs = new List<String>{'7000', '12345678'};
EmpostWebservice.ArrayOfString easObj = new EmpostWebservice.ArrayOfString();
easObj.string_x = AWBs;
cls.GetUpdatedStatusByAWB(easObj, 'bf2975ad4f4e4fc5bd512a697ad09c92');

        }catch (Exception e) {}

    }
     @IsTest
    private static  void CancelBookingTest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
              String[] AWBs  = new List<String>{'7000', '12345678'};
EmpostWebservice.ArrayOfString easObj1 = new EmpostWebservice.ArrayOfString();
easObj1.string_x = AWBs;
  cls.CancelBooking(easObj1, 'bf2975ad4f4e4fc5bd512a697ad09c92');

        }catch (Exception e) {}

    }
     @IsTest
    private static  void GetStatusSummaryTest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
              String[] AWBs  = new List<String>{'7000', '12345678'};
  cls.GetStatusSummary('18-Apr-2015', 'bf2975ad4f4e4fc5bd512a697ad09c92');

        }catch (Exception e) {}

    }
     @IsTest
     private static  void GetStatusBatchTest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
              String[] AWBs  = new List<String>{'7000', '12345678'};
  cls.GetStatusBatch('18-Apr-2015', '18-Apr-2015');

        }catch (Exception e) {}

    }
     @IsTest
    private static  void AutoAllocateDeliveryPickupsTest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
              String[] AWBs  = new List<String>{'7000', '12345678'};
  cls.AutoAllocateDeliveryPickups('bf2975ad4f4e4fc5bd512a697ad09c92', '12345');

        }catch (Exception e) {}

    }
     @IsTest
    private static  void CreateBookingTest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
              String[] AWBs  = new List<String>{'7000', '12345678'};
    String xml='<BookingInfo><BookingType>Delivery</BookingType><EmpID>Srinivasa Varanasi</EmpID><Branch>AXS Office</Branch><EMPPhone>8004297</EMPPhone><CompanyName>IBM Middle East FZ-LLC - Dom1 Tom</CompanyName><Address>AXS - Norman Noronha</Address><Zone>Dubai Internet City</Zone><Phone>0506537429</Phone><Mobile>0506537429</Mobile><RepresentativeName>Srinivasa Varanasi</RepresentativeName><SRNo>23184020160428</SRNo><TeamCode>Abdul Jaleel</TeamCode><Building>Block 17</Building><ZoneID>DKP</ZoneID><ContentTypeId>192</ContentTypeId><TimeStamp>10:10</TimeStamp><HashCode>71498034f26917d3c16b34d7b71626717ae17747</HashCode></BookingInfo>';
  cls.CreateBooking(xml, 'bf2975ad4f4e4fc5bd512a697ad09c92');

        }catch (Exception e) {}

    }

      @IsTest
    private static  void GetCourierInfoTest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
              String[] AWBs  = new List<String>{'7000', '12345678'};
  cls.GetCourierInfo('bf2975ad4f4e4fc5bd512a697ad09c92', '12345', '');

        }catch (Exception e) {}

    }

      @IsTest
    private static  void GetDetailByCreatedOnTest() {

        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        EmpostWebservice metaDataService = new EmpostWebservice();
        EmpostWebservice.PopulateSoap  cls = new EmpostWebservice.PopulateSoap ();
        try{
              String[] AWBs  = new List<String>{'7000', '12345678'};
  cls.GetDetailByCreatedOn('bf2975ad4f4e4fc5bd512a697ad09c92', '12345');

        }catch (Exception e) {}

    }

}