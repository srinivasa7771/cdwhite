public class DDAMembersWrapper {
    public List<Members> drWrp{get; set;}
    public List<Members> nonDrWrp{get; set;}
    public String srList {get; set;}
    public String message {get; set;}
    public List<LicenseInfos> licenseInfos {get; set;}
    public Boolean isSuccess {get; set;}

    public class LicenseInfos {
        public Decimal totalShareCapital {get; set;}
        public Decimal totalNumberOfShares {get; set;}
        public List<Members> members {get; set;}
        public String parentCompanyName {get; set;}
        public String parentCompanyPermanentAddress {get; set;}
        public String parentCompanyNationality {get; set;}
        public String parentCompanyRegistrationNo {get; set;}
        public String ManagerInChargerPerMobile {get; set;}
        public String ManagerInChargerPerEmail {get; set;}
        public String ManagerInChargerNationalityArabicCountry {get; set;}
        public String ManagerInChargerNationality {get; set;}
        public String ManagerInChargerName {get; set;}
        public String ManagerInChargerFullNameArabic {get; set;}
        public String licenseNo {get; set;}
        public String LicenseIssueDate {get; set;}
        public String LicenseFirstIssueDate {get; set;}
        public String LicenseExpiryDate {get; set;}
        public String LicenseeNameArabic {get; set;}
        public String LicenseeName {get; set;}
        public List<LicensedActivities> licensedActivities{get; set;}
        public String LegalNameArabic {get; set;}
        public String LegalName {get; set;}
        public String LegalFrameworkName {get; set;}
        public String LegalFrameworkLegalFrameworkArabic {get; set;}
        public String CountryofIncorporationName {get; set;}
        public String CountryofIncorporationArabicCountryName {get; set;}
        public String companyDdaId {get; set;}
        public String ActivityAmendmentRequestDdaId {get; set;}
        public String ActivityAmendmentRequestAXSRefNo {get; set;}
    }
   public class LicensedActivities {
       public String segmentName{
           get;
           set;
       }
       public String segmentArabicName{
           get;
           set;
       }
       public Boolean isRelatedtoTitles{
           get;
           set;
       }
       public Boolean isRelatedtoChannel{
           get;
           set;
       }
       public List<ChannelTitles> channelTitles{
           get;
           set;
       }
       public String activityName{
           get;
           set;
       }
       public String activityDdaId{
           get;
           set;
       }
       public String activityArabicName{
           get;
           set;
       }
   }

    public class EmiratesId {
        public String placeOfIssuance {
            get;
            set;
        }
        public Date issueDate {
            get;
            set;
        }
        public Date expiryDate {
            get;
            set;
        }
        public String docNo {
            get;
            set;
        }
        public String countryOfIssuance {
            get;
            set;
        }
    }

    public class EmiratesId_Z {
        public String placeOfIssuance {get; set;}
        public Date issueDate {get; set;}
        public Date expiryDate {get; set;}
        public String docNo {get; set;}
        public String countryOfIssuance {get; set;}
    }

   public class Passports_Y {
       public String placeOfIssuance {
           get;
           set;
       }
       public String issueDate {
           get;
           set;
       }
       public String expiryDate {
           get;
           set;
       }
       public String docNo {
           get;
           set;
       }
       public String countryOfIssuance {
           get;
           set;
       }
   }

    public class Passports_X {
    }

    public class Passports {
        public String placeOfIssuance {
            get;
            set;
        }
        public String issueDate {
            get;
            set;
        }
        public String expiryDate {
            get;
            set;
        }
        public String docNo {
            get;
            set;
        }
        public String countryOfIssuance {
            get;
            set;
        }
    }
    public class Passports_Z {
        public String placeOfIssuance {
            get;
            set;
        }
        public String issueDate {
            get;
            set;
        }
        public String expiryDate {
            get;
            set;
        }
        public String docNo {
            get;
            set;
        }
        public String countryOfIssuance {
            get;
            set;
        }
    }

    public class Members {
        public String type {get; set;}
        public String salutation {get; set;}
        public String registrationNo {get; set;}
        public Date registrationDate {get; set;}
        public Decimal proposedNumberOfShares {get; set;}
        public String positions {get; set;}
        public String placeborn {get; set;}
        public String perMobile {get; set;}
        public Boolean isMobilePhoneVerified{get; set;}
        public DateTime mobilePhoneVerificationDatetime{get; set;}
        public String perEmail {get; set;}
        public Boolean isEmailVerified{get; set;}
        public DateTime emailVerificationDatetime{get; set;}
        public Boolean VisitedUAE{get; set;}
        public String birthCountry{get; set;}
        public String passportShareType {get; set;}
        public String passportShare {get; set;}
        public List<Passports> passports  {get; set;}
        public String operatingNameArabic {get; set;}
        public String operatingName {get; set;}
        public String nationality {get; set;}
        public String middleNameArabic {get; set;}
        public String middleName {get; set;}
        public String lastNameArabic {get; set;}
        public String lastName {get; set;}
        public String gender {get; set;}
        public String firstNameArabic {get; set;}
        public String firstName {get; set;}
        public String externalId {get; set;}
        public EmiratesId emiratesId {get; set;}
        public String ddaId {get; set;}
        public Date dateOfIncorporation {get; set;}
        public Decimal currentNumberOfShares {get; set;}
        public String countryOfIncorporation {get; set;}
        public Date cessationDate {get; set;}
        public Date birthDate {get; set;}
        public List<Addresses> addresses {get; set;}
        public String actionType {get; set;}
    }
    public class ChannelTitles {
        public String targetedAudience{
            get;
            set;
        }
        public String requestType{
            get;
            set;
        }
        public String printingCompany{
            get;
            set;
        }
        public String name{
            get;
            set;
        }
        public String licensedTitleChannelDdaId{
            get;
            set;
        }
        public String languages{
            get;
            set;
        }
        public String isOnAir{
            get;
            set;
        }
        public String isNameConfirmed{
            get;
            set;
        }
        public String isApprovedByNMC{
            get;
            set;
        }
        public Boolean isActive{
            get;
            set;
        }
        public String genre{
            get;
            set;
        }
        public String frequency{
            get;
            set;
        }
        public String distributionType{
            get;
            set;
        }
        public String distributionCompany{
            get;
            set;
        }
        public String background{
            get;
            set;
        }
        public String areaOfDistribution{
            get;
            set;
        }
        public String arabicName{
            get;
            set;
        }
        public String approvalStatus{
            get;
            set;
        }
    }
    public class Addresses {
        public String type{
            get;
            set;
        }
        public String street{
            get;
            set;
        }
        public String postalCode{
            get;
            set;
        }
        public String phone{
            get;
            set;
        }
        public String mobile{
            get;
            set;
        }
        public String homePhone{
            get;
            set;
        }
        public String email{
            get;
            set;
        }
        public String country{
            get;
            set;
        }
        public String city{
            get;
            set;
        }
        public String buildingNo{
            get;
            set;
        }
        public String area{
            get;
            set;
        }
    }

}