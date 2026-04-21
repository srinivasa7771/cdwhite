public class grqwsGDRFA {

    public string access_token {set;get;}
    public string IsSuccess {set;get;}

    //Visa search
    public string TargetFileNo {set;get;}
    public string applicationNumber {set;get;}
    public string statusId {set;get;}

    //Status enquiry
    public string StatesCode {set;get;}
    public string CurrentStatus {set;get;}

    //documents
    public String applicationId {set;get;}
    public List<Documents> Documents {set;get;}
    Public class Documents{
        public string documentTypeId {set;get;}
        public boolean IsMandatory {set;get;}
        public string documentNameEn {set;get;}
        public string documentNameAr {set;get;}
    }

    //Payment
    public string batchId {set;get;}
    public List<Fees> fees {set;get;}
    public class Fees {
        public string feeTypeId {set;get;}
        public decimal amount {set;get;}
        public string nameEn {set;get;}
        public string nameAr {set;get;}
    }

}