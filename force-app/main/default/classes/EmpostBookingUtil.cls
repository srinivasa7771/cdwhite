public with sharing class EmpostBookingUtil {
    public EmpostBookingUtil() {

    }

        public String  createBookingJson(g_Req__c reqObj, String corStg) {
            EmpostcourierWs ews=new EmpostcourierWs();
            EmpostcourierWs.BookingRequest br= new EmpostcourierWs.BookingRequest();

                  if (corStg.toUpperCase()=='DELIVERY') {
                    //br.SenderContactName=reqObj.CreatedBy.Name;
                    br.SenderContactName='AXS';
                    br.SenderCompanyName='AXS Satellite Office at DKP';
                    br.SenderAddress='AXS Satellite Office at DKP';
                    br.ReceiverContactName=reqObj.Full_Name__c != null?reqObj.Full_Name__c:reqObj.CreatedBy.Name;
                      if (reqObj.srvc__r.uid__c=='196') {
                        br.SenderCompanyName='AXS Satellite Office at DSC';
                        br.SenderAddress='AXS Satellite Office at DSC';
                      br.ReceiverContactName='';
                      }

                    br.SenderContactMobile='0525454568';
                    br.SenderContactPhone='0525454568';
                    br.SenderEmail=reqObj.CreatedBy.email;

                    br.ReceiverCompanyName=reqObj.Acc__r.Name;
                  //  br.ReceiverAddress=reqObj.xloc__c +'-'+ reqObj.Zone__c +'-'+ reqObj.Zone__c;
                    br.ReceiverAddress=reqObj.xbrnd__c +'-'+reqObj.xbn__c+'-'+reqObj.xaloc__c;
                    br.ReceiverContactMobile=reqObj.xcmob__c;
                    br.ReceiverContactPhone=reqObj.xcmob__c;
                    br.ReceiverEmail=reqObj.CreatedBy.email;
                  }else if (corStg.toUpperCase()=='COLLECTION') {
                    br.SenderContactName=reqObj.CreatedBy.Name;
                    br.SenderCompanyName=reqObj.Acc__r.Name;
                   // br.SenderAddress=reqObj.xloc__c +'-'+ reqObj.Zone__c +'-'+ reqObj.Zone__c;
                    br.SenderAddress=reqObj.xbrnd__c +'-'+reqObj.xbn__c+'-'+reqObj.xaloc__c;
                    br.SenderContactMobile=reqObj.xcmob__c;
                    br.SenderContactPhone=reqObj.xcmob__c;
                    br.SenderEmail=reqObj.CreatedBy.email;
                    br.ReceiverContactName='Team-'+reqObj.srvc__r.Name;
                    br.ReceiverCompanyName='AXS Satellite Office at DKP';
                    br.ReceiverAddress='AXS Satellite Office at DKP';
                    if (reqObj.srvc__r.uid__c=='197') {
                        br.ReceiverCompanyName='AXS Satellite Office at DSC';
                        br.ReceiverAddress='AXS Satellite Office at DSC';
                      }
                    br.ReceiverContactMobile=reqObj.xcmob__c;
                    br.ReceiverContactPhone=reqObj.xcmob__c;
                    br.ReceiverEmail=reqObj.CreatedBy.email;

                  }

                    br.ReferenceNo=reqObj.Name;
                    br.CommodityDescription=reqObj.srvc__r.Name;
                    br.PreferredPickupDate=(Datetime.now().addDays(1)).format('dd-MMM-yyyy');
                    br.SpecialNotes=reqObj.srvc__r.Name;
                    br.Remarks=reqObj.srvc__r.Name;

                    // standard values
                    br.SenderCity=1;
                    br.SenderZipCode='0';
                    br.SenderState='Dubai';
                    br.SenderCountry=971;
                    br.ReceiverCity=1;
                    br.ReceiverZipCode='0';
                    br.ReceiverState='Dubai';
                    br.ReceiverCountry=971;
                    br.ReferenceNo1=null;
                    br.ReferenceNo2=null;
                    br.ReferenceNo2=null;
                    br.ContentTypeCode='NonDocument';
                    br.NatureType=11;
                    br.Service='Domestic';
                    br.ShipmentType='Express';
                    br.Service='Domestic';
                    br.DeleiveryType='Door to Door';
                    br.Service='Domestic';
                    br.PaymentType='Credit';
                    br.CODCurrency=null;
                    br.CODAmount='0';
                    br.Pieces=3;
                    br.Weight=500;
                    br.WeightUnit='Grams';
                    br.Weight=500;
                    br.Length=12;
                    br.Width=12;
                    br.Height=12;
                    br.DimensionUnit='Centimetre';
                    br.ItemValue='10000';
                    br.ValueCurrency='AED';
                    br.ProductCode='EPG-71';
                    br.SenderRegionId='1615';
                    br.DeliveryInstructionsID=0.0;
                    br.RequestSource='';
                    br.SendMailToSender='Yes';
                    br.SendMailToReceiver='Yes';
                    br.PreferredPickupTimeFrom='09:00';
                    br.PreferredPickupTimeTo='18:00';
                    br.Is_Return_Service='No';
                    br.PrintType='AWBOnly';
                    br.Latitude='0';
                    br.Longitude='0';
                    br.TransactionSource=null;
                    br.AWBType='EAWB';
                    br.RequestType='Booking';
                    br.ReceiverRegionId=null;
                    br.AWBNumber=null;
                    ews.bookingRequest=br;
                   String bookingreq=JSON.serialize(ews);
         return bookingreq;

         }

}