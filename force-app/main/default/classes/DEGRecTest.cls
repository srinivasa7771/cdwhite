@isTest
public class DEGRecTest {
    @IsTest
    private static  void coverTypesDEG() {
        DEGRec.UsernameToken a=new DEGRec.UsernameToken();
        a.username=a.username;
        a.password=a.password;
        a.Nonce=a.Nonce;
        a.Created=a.Created;
        a.username_type_info=a.username_type_info;
        a.password_type_info=a.password_type_info;
        a.Nonce_type_info=a.Nonce_type_info;
        a.apex_schema_type_info=a.apex_schema_type_info;
        a.field_order_type_info=a.field_order_type_info;

        DEGRec.Security b=new DEGRec.Security();
        b.usernameToken_type_info=b.usernameToken_type_info;
        b.Timestamp_type_info=b.Timestamp_type_info;
        b.apex_schema_type_info=b.apex_schema_type_info;
        b.field_order_type_info=b.field_order_type_info;

        DEGRec.Timestamp t=new DEGRec.Timestamp();
        t.Created=t.Created;
        t.Expires=t.Expires;
        t.Created_type_info=t.Created_type_info;
        t.Expires_type_info=t.Expires_type_info;
        t.apex_schema_type_info=t.apex_schema_type_info;
        t.field_order_type_info=t.field_order_type_info;

        DEGRec.epayTransactionSearchResponse_element x=new DEGRec.epayTransactionSearchResponse_element();
        x.result_type_info=x.result_type_info;
        x.apex_schema_type_info=x.apex_schema_type_info;
        x.field_order_type_info=x.field_order_type_info;

        DEGRec.epayTransactionSearch_element r=new DEGRec.epayTransactionSearch_element();
        r.spCode=r.spCode;
        r.servCode=r.servCode;
        r.spTrn=r.spTrn;
        r.degTrn=r.degTrn;
        r.pgCode=r.pgCode;
        r.pgTrn=r.pgTrn;
        r.spCode_type_info=r.spCode_type_info;
        r.servCode_type_info=r.servCode_type_info;
        r.spTrn_type_info=r.spTrn_type_info;
        r.degTrn_type_info=r.degTrn_type_info;
        r.pgCode_type_info=r.pgCode_type_info;
        r.pgTrn_type_info=r.pgTrn_type_info;
        r.apex_schema_type_info=r.apex_schema_type_info;
        r.field_order_type_info=r.field_order_type_info;

        DEGRec.getTransactionStatus_element ri=new DEGRec.getTransactionStatus_element();
        ri.spCode_type_info=ri.spCode_type_info;
        ri.servCode_type_info=ri.servCode_type_info;
        ri.spTrn_type_info=ri.spTrn_type_info;
        ri.apex_schema_type_info=ri.apex_schema_type_info;
        ri.field_order_type_info=ri.field_order_type_info;

        DEGRec.getTransactionStatusResponse_element ii=new DEGRec.getTransactionStatusResponse_element();
        ii.result_type_info=ii.result_type_info;
        ii.apex_schema_type_info=ii.apex_schema_type_info;
        ii.field_order_type_info=ii.field_order_type_info;

             DEGRec.getDEGTransactionStatusResponse_element iii=new DEGRec.getDEGTransactionStatusResponse_element();
        iii.result_type_info=iii.result_type_info;
        iii.apex_schema_type_info=iii.apex_schema_type_info;
        iii.field_order_type_info=iii.field_order_type_info;

        DEGRec.getDEGTransactionStatus_element rri=new DEGRec.getDEGTransactionStatus_element();
        rri.spCode_type_info=rri.spCode_type_info;
        rri.servCode_type_info=rri.servCode_type_info;
        rri.spTrn_type_info=rri.spTrn_type_info;
        rri.timeout_type_info=rri.timeout_type_info;
        rri.apex_schema_type_info=rri.apex_schema_type_info;
        rri.field_order_type_info=rri.field_order_type_info;

    }

      @IsTest
    private static  void getDEGTransactionStatusTest() {
         DEGRec.ePayTransactionInquiryHttpsSoap11Endpoint sd=new DEGRec.ePayTransactionInquiryHttpsSoap11Endpoint();
        //sd.getDEGTransactionStatus('', '', '', '120000000');
    }
        @IsTest
    private static  void getTransactionStatusTest() {
         DEGRec.ePayTransactionInquiryHttpsSoap11Endpoint sd=new DEGRec.ePayTransactionInquiryHttpsSoap11Endpoint();
      // sd.getTransactionStatus('', '', '');
    }
        @IsTest
    private static  void epayTransactionSearchTest() {
         DEGRec.ePayTransactionInquiryHttpsSoap11Endpoint sd=new DEGRec.ePayTransactionInquiryHttpsSoap11Endpoint();
        //sd.epayTransactionSearch('', '', '', '', '', '');

    }

}