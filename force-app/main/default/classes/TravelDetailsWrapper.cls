public class TravelDetailsWrapper {
    public String residenceNo {set;get;} /*/Residence number of the dependent*/
    public String permitNo {set;get;} /*/Permit Number of the dependent*/
    public Boolean insideTheCountry{set;get;}
    public String lastEntryDate {set;get;} /*/Format(YYYY-MM-DD HH:MM:SS)*/
    public Integer remainingStayDays {set;get;}
    public String lastExitDate {set;get;} /*/Format(YYYY-MM-DD HH:MM:SS)*/
    public Integer nextVisitStayDays {set;get;}
    public String stayUntilDate {set;get;} //Format(YYYY-MM-DD HH:MM:SS)
    public String firstUsageDate {set;get;} //Format(YYYY-MM-DD HH:MM:SS)
    public PermitResidenceStatus permitStatus;
    public PermitResidenceStatus residenceStatus;
    public boolean IsSuccess;
    public String errorCode;
    public ErrorMsg[] errorMsg;
    public class PermitResidenceStatus {
        public String Id; /*/7757f3d3-9fae-4cb9-a85b-70ded1d91a38*/
        public String nameEN;    /*50*/
        public String nameAR;    /*50*/
    }
    public class ErrorMsg {
        public string messageEn;
    }
}