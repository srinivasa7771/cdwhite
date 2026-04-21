public class ParkingDetails implements Comparable {
    public String  sector       {get;set;}
    public String  cardNum      {get;set;}    public Boolean    sel              {get;set;}
    public String  cardId       {get;set;}    public String    sPlaceOfReg      {get;set;}
    public String  BusinessPark {get;set;}  public String    vType            {get;set;}
    public String  actStat      {get;set;}    public String    vehicleNumber    {get;set;}
    public String  vDetails     {get;set;}    public String    secVclNum        {get;set;}
    public String  cHolderNm    {get;set;}    public String    status            {get;set;}
    public String  cardType     {get;set;}     public String     pPlaceOfReg      {get;set;}
    public String  refMobile     {get;set;}  public String   email     {get;set;}
    public String  expDate      {get;set;}

    public ParkingDetails() {}
    public ParkingDetails(String sector, String cardNum, Boolean sel, String cardId, String sPlaceOfReg,
        String BusinessPark, String vType, String actStat, String vehicleNumber, String vDetails,
        String secVclNum,
                          String cHolderNm, String status, String cardType, String pPlaceOfReg, String refMobile, String email, String expDate) {
        this.sector=sector;
        this.cardNum=cardNum;
        this.sel=sel;
        this.cardId=cardId;
        this.sPlaceOfReg=sPlaceOfReg;
        this.BusinessPark=BusinessPark;
        this.vType=vType;
        this.actStat=actStat;
        this.vehicleNumber=vehicleNumber;
        this.vDetails=vDetails;
        this.secVclNum=secVclNum;
        this.cHolderNm=cHolderNm;
        this.status=status;
        this.cardType=cardType;
        this.pPlaceOfReg=pPlaceOfReg;
        this.refMobile=refMobile;
        this.email=email;
        this.expDate=expDate;
    }

    public Integer compareTo(Object compareTo) {
        ParkingDetails ParkingDetails = (ParkingDetails) compareTo;
        if (cardNum == ParkingDetails.cardNum) return 0;
        if (cardNum > ParkingDetails.cardNum) return 1;
        return -1;
    }
}