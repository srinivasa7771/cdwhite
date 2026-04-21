public class grqWsDccaGetServiceBatch {

public static Map<String, String> actMap {get;set;}
public static Map<String, String> priceMap {get;set;}

public class argLocation {
public Boolean isRegoff {get;set;}
public string agreeNo {get;set;}
public string floor ;
public string arbfloor ;
public string OffNo ;
public string buildN ;
public string arbBuildN ;
public string bus ;
public string arbBus ;
public string status {get;set;}
public string reason {get;set;}
public string stDt {get;set;}
public string edDt {get;set;}
public string fullLoc {get;set;}
}

public class argLoc {
public List<argLocation> argLocation;
}

    public class Attachments {
        public String parentId;
        public String attachmentBody;
        public String Name;
        public String messagecode;
        public String message;

    }

public class  Titles{
public String name{set;get;}
public String lang{set;get;}
public String genere{set;get;}
public String freq{set;get;}
}

public class  Channels{
public String name{set;get;}
public String lang{set;get;}
public String genere{set;get;}
public String freq{set;get;}
}

    public class AttachList {
        public list<Attachments> AttachmentList {get;set;}
    }

    public class  Locations{
        public Boolean isRegoff {get;set;}
        public string AgreementNo {get;set;}
        public string ArabicBuildingName {get;set;}
        public string ArabicBusinessUnit {get;set;}
        public string ArabicFloor {get;set;}
        public string ArabicOfficeNo {get;set;}
        public string totalArea {get;set;}
        public string Category {get;set;}
        public string SubCategory {get;set;}
        public boolean regOff{get;set;}
        public string OfficeNo{get;set;}
        public string LicenseNo {get;set;}
        public string LocationId {get;set;}
        public string BusinessPark {get;set;}
        public string BuildingName {get;set;}
        public string Floor {get;set;}
        public String Status {get;set;}
        Public String ContractStatusReason {get;set;}
        Public date ContractStartDate {get;set;}
        Public date ContractEnddate {get;set;}
        Public boolean IsMainAdd {get;set;}
        Public String subleaseCompany {get;set;}
        Public boolean showOnLicen {get;set;}
        public string licenseType {get;set;}
        Public string IsSubLease {get;set;}
        public string error {get;set;}

        Public String IsDownsize {get;set;}
        Public String RenewalOpp {get;set;}

        public string Recordtype{get;set;}
        public string masterLocationLicense{get;set;}
        public List<products> prodList;

    }
    /**  public class products{
public string LineItemName {get;set;}
public string ProductName {get;set;}
public string UnitNumber {get;set;}
}**/
    public class Products {
        public String LineItemName;
        public String ProductName;
        public String UnitNumber;
        public String buildingName;
         public String floor;
         public boolean regOff;
    }

    public class Activities{
        public string LicenseNo {get;set;}
        public string ActivityId {get;set;}
        public string Name {get;set;}
        Public string type {get;set;}
        public string segName {get;set;}
        public string accName {get;set;}
        public List<Titles> titleList {get;set;}
        public List<Channels> chanList {get;set;}
        public date StartDate {get;set;}
        public string error {get;set;}

    }
    public class  ActivityLocations{

        public List<Locations> locationList;
        public string LicnseNo {get;set;}
        public string MethodName {get;set;}
        public List<Activities> act;
        public string error {get;set;}
        public string errorCode {get;set;}
    }

    //Request creation
    public class DocumentD
    {
        public String name {get;set;}
        public String shareHolderName {get;set;}
        public boolean isRequired {get;set;}
    }
    public class LineItems
    {
        public string segment {get;set;}
        public string activity {get;set;}
        public string isActive {get;set;}
        public string lineName {get;set;}
        public Integer amount {get;set;}
    }
    public List<Data> Data;
    public class Data
    {
        public List<DocumentD> docs {get;set;}
        public List<LineItems> lines {get;set;}
        public Integer amount {get;set;}
        public string idRec {get;set;}
        public string licNo {get;set;}
        public string expDate {get;set;}
        public string name {get;set;}
        public string mangerName{get;set;}
        public string mangerNameA {get;set;}
        public string leaseType {get;set;}
        public string managerNation {get;set;}
        public string managerNationA {get;set;}
        public string errorCode {get;set;}
        public string errorMessage{get;set;}
        public string licType{get;set;}
        public string sme{get;set;}
        public boolean buRecomendation{get;set;}
        public string shareHldType{get;set;}
           public List<sanctions> sancs;
        public string actspeNotes;
        public boolean isRenewalAllowed;
        public string status;
        public string legaleng;
        public string legalarabic;
        public string lincenseeeng ;
        public string lincenseearabic;
        public string frameworkeng;
        public string frameworkarabic;
        public string businessPArk;
    }

    public Class sanctions
    {
    public string sanctionDept{get;set;}
    public string sancdescriprtion{get;set;}
    }

    public ResponseData ResponseData{get;set;}

    public class ResponseData {
        public String PartyId {get;set;}
        public Boolean Success{get;set;}
        public String Source {get;set;}
        public String Error {get;set;}
        public String ResponseCode{get;set;}
        public List<Records> Records{get;set;}
    }

    public class Records {
        public String StageName{get;set;}
        public String AgNo{get;set;}
        public String LeaseType{get;set;}
         public String Type{get;set;}
        public Boolean regOff{get;set;}
        public String BusinessPark{get;set;}
        public String ContractStartDate{get;set;}
        public String ContractEndDate{get;set;}
        public String Category{get;set;}
        public String SubCategory{get;set;}
        public String ContractStatus{get;set;}
        public String ContractStatusReason{get;set;}
        public List<Products> Products{get;set;}
        public List<Units> Units{get;set;}
        public String fullUnitAdd{get;set;}

         Public String IsDownsize {get;set;}
        Public String RenewalOpp {get;set;}
    }

    public class Units{
        //
         public string UnitNameArabic {get;set;}
         public string UnitNoArabic {get;set;}
         public string UnitNoEnglish {get;set;}
         public string FloorArabic {get;set;}
         public string FloorEnglish {get;set;}
         public string BuildingNameArabic {get;set;}
         public string Category {get;set;}
         public string SubCategory {get;set;}
         public string SendToDCCA {get;set;}
        //
        public string UnitName {get;set;}
        public string UnitNumber {get;set;}
        public string FloorName {get;set;}
        public string BuildingName {get;set;}
      //  public string BuildingNameArabic {get;set;}
        public string CommercialName {get;set;}
        public string BusinessPark {get;set;}
        public string UniqueKey {get;set;}
         public string AgNo {get;set;}
        public string ContractStartDate {get;set;}
        public string ContractEnddate {get;set;}
    }

}