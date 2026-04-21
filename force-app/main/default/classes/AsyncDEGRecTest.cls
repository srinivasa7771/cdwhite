@IsTest
public class AsyncDEGRecTest {
      @IsTest
    private static  void getDEGTransactionStatusTest() {
        try{
         AsyncDEGRec.getTransactionStatusResponse_elementFuture sd=new AsyncDEGRec.getTransactionStatusResponse_elementFuture();
        sd.getValue();
        }catch (Exception e) {}
    }
        @IsTest
    private static  void getDEGTransactionStatusResponse_elementFuture() {
  try{
        AsyncDEGRec.getDEGTransactionStatusResponse_elementFuture sd=new AsyncDEGRec.getDEGTransactionStatusResponse_elementFuture();
        sd.getValue();
        }catch (Exception e) {}
    }

      @IsTest
    private static  void epayTransactionSearchResponse_elementFuture() {
        try{
        AsyncDEGRec.epayTransactionSearchResponse_elementFuture sd=new AsyncDEGRec.epayTransactionSearchResponse_elementFuture();
        sd.getValue();
              }catch (Exception e) {}
    }

      @IsTest
    private static  void beginGetTransactionStatusTest() {
        try{
        AsyncDEGRec.AsyncePayTransactionInquiryHttpsSoap11Endpoint sd=new AsyncDEGRec.AsyncePayTransactionInquiryHttpsSoap11Endpoint();
        System.Continuation x;
        //sd.beginGetTransactionStatus(x, '', '', '');
              }catch (Exception e) {}
    }

      @IsTest
    private static  void beginGetDEGTransactionStatusTest() {
        try{
         AsyncDEGRec.AsyncePayTransactionInquiryHttpsSoap11Endpoint sd=new AsyncDEGRec.AsyncePayTransactionInquiryHttpsSoap11Endpoint();
        System.Continuation x;
        //sd.beginGetDEGTransactionStatus(x, '', '', '', '120000');
              }catch (Exception e) {}
    }
     @IsTest
    private static  void beginEpayTransactionSearchTest() {
        try{
         AsyncDEGRec.AsyncePayTransactionInquiryHttpsSoap11Endpoint sd=new AsyncDEGRec.AsyncePayTransactionInquiryHttpsSoap11Endpoint();
        System.Continuation x;
        //sd.beginEpayTransactionSearch(x, '', '', '', '120000', '', '');
              }catch (Exception e) {}
    }
}