public class WsParking {

    public static String callParkingWs(String parkingReqBody) {

        //'{"ActionName" : "getaccounteligibility", "OracleID" : "1720810"}'
        String respBody = '';
        Http h = new Http();
        HttpRequest request     = new HttpRequest();
        HttpResponse response   = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:D3_NC/apexrest/CCRM/');
        request.setTimeout(90000);
        request.setMethod('POST');
        system.debug('parkingReqBody -- '+parkingReqBody);
        String reqJson = parkingReqBody;
        request.setBody(reqJson);
        response = h.send(request);
        respBody = response.getBody();
        System.debug('respBody1:: ' + respBody);
        return respBody;

    }

    public static String getRqBody(String methodNm, String orcleId, g_req__c rq) {
        ParkReq parkReq = new ParkReq();
        parkReq.ActionName = methodNm.toLowerCase();
        parkReq.oracleID = orcleId;
        if (rq != null) {
            parkReq.AXSId = rq.name;
        }
        switch on methodNm.toLowerCase() {
            when 'insertparkingrequest'{
                /*String rqCardDet  = '[{"CardNo":"3456", "cardHolderName":"Test Holder", "Email":"test@test.com", "Mobile":"123456", "Phone":"456789", "Vehicles":[{"VehiclePlaceofReg":"Ajman", "VehicleOwner":"Test Owner", "VehicleNumber":"V456", "VehicleModel":"2020", "VehicleEmirate":"Ajman", "VehicleBrand":"Suzuki"}, {"VehiclePlaceofReg":"Dubai", "VehicleOwner":"Test Owner", "VehicleNumber":"V123", "VehicleModel":"2019", "VehicleEmirate":"Dubai", "VehicleBrand":"Honda"}]}]';
                */ String rqCardDet = '';
                if (String.isNotBlank(rqCardDet)) {
                    List<Card> cards = (List<Card>)JSON.deserialize(rqCardDet, List<Card>.class);
                    parkReq.CardsDetail = cards;
                }
            }
            when 'getaccounteligibility'{
                parkReq.ActionName = methodNm.toLowerCase();
            }
            when 'cancelvehicle'{
                parkReq.ActionName = methodNm.toLowerCase();
            }
            when 'getavailablecards' {
                parkReq.CardStatus = 'BOTH';
            /* Active, Inactive, Both depending on type of service*/ }
            when 'updaterequestdetails' {
                parkReq.chName = rq.xchn__c;
                parkReq.chEmail = rq.xceml__c;
                parkReq.chMobile = rq.xcmob__c;
                parkReq.chPhone = rq.rmob__c;
            }
            when 'checkvehiclevalidity' {
                /* parkReq.VehicleNumber = rq.xchn__c;
                parkReq.CardNumber = rq.xchn__c;
                parkReq.SectorName = rq.xchn__c;
            */  }
            when 'perslotpricecalculation' {
            }
            when 'createpaidcards' {
                parkReq.AgNo = rq.xanum__c;
                parkReq.expiryDate = rq.xaed__c.day()+'-'+ rq.xaed__c.month() +'-'+rq.xaed__c.year();
            }
            when else {
            }
        }
        return JSON.serialize(parkReq);
    }

    //#############################################################################################
    // Wrapper Classes
    //#############################################################################################

    public class parkReq{ // dont copy from CRM
        Public String ActionName;
        Public String OracleID;
        Public String CardStatus;
        Public String AXSId;
        Public String chName;
        Public String chEmail;
        Public String chMobile;
        Public String chPhone;
        Public String VehicleNumber;
        Public String CardNumber;
        Public String SectorName;
        Public String BusinessPark;
        Public String AgNo;
        Public String contentType;
        Public String attachmentName;
        Public String body;
        Public String ExpiryDate;
        Public String EligibilitySubType;
        Public String ReqSlots;
        Public String ParkingType;
        Public String CardRequestType;
        Public String Amount;
        Public String EligibilityName;
        Public String Sector;
        Public String Enddate;
        Public String Eligibility;
        Public String RequestType;

        public list<Card> CardsDetail;
    }

    public class ed{
        Public String Status;
        Public String Message;
        public List<EligibilityDetails> AccountEligibility;
    }

    public class EligibilityDetails{
        public string oracleId;
        public list<EligibilityDetail> EligibilityDetail;
    }

    public class EligibilityDetail{
        public string EligibilityName;
        public string EligibilityType;
        public string EligibilitySubType;
        public string LeaseEndDate;
        public string Sector;
        public string AgNo;
        public string TCode;
        public string PaidStandardEligibility;
        public string FreeEligibility;
        public string PaidEligibility;
        public string EnrolledCard;
        public string ReservedCard;
        public string ActiveCard;
        public Boolean defaultPaidparking {get;set;}
        public list<parking> ParkingDetail {get; set;}
        public list<SectorLocation> SectorLocations {get;set;}
        public string SectorID;
        public string EligibilityID;
        public string newCardsPaidEligible;
        public string RemainingPaidEligible;
    }

    public class SectorLocation{
        public string Sequence;
        public string LocationName;
        public string LocaionId;
        public String PaidStandardPrice;
        public string isDefault;

    }

    public class parking{
        public string ParkingType;
        public string ParkingSubType;
        public string FreeEligibility;
        public string FreeActive;
        public string FreeInactive;
        public string FreeUsed;
        public string PaidEligibility;
        public string PaidActive;
        public string PaidInactive;
        public string PaidUsed;
    }

    public class Card{

        public String CardNumber;
        public String CardStatus;
        public String CardType;
        public String CardSubType;
        public String CardIsExpired;
        public String CardHolderName;
        public String CardHolderEmail;
        public String CardHolderPhone;
        public String CardExpDate;
        public String BusinessPark;
        public String Sector;
        public String SectorLocationId;
        public String SectorLocationName;   //PJ
        public String EligibilityName;
        public String Tcode;
        public String IsReserved;
        public String OraclePrtyId;
        public List<Vehicle> Vehicles;
    }

    public class Vehicle{
        public String VehicleType;
        public String VehicleNumber;
        public String PlateNumberCode;
        public String PlaceOfReg;
        public String VehicleBrand;
        public String VehicleModel;
        public String VehiclePlateColor;
        public String VehicleColor;
        public String VehiclePlaceofReg;
        public String VehicleOwner;
        public String VehicleEmirate;
    }

    public class Vehicles{
        public string VehiclName;
    }
    public class Response{
        public String Status;
        public String Message;
        public Decimal PerSlotPrice;
        public String ParkingRequest;
        public String AXSId;
        public list<EligibilityDetail> AccountEligibility;
        public list<Vehicles> Vehicles;
        public list<Card> CardsDetail;
    }

}