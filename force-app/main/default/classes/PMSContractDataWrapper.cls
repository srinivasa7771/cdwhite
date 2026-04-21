public class PMSContractDataWrapper {
   public String dedLicenseNumber {set;get;}
    public String contractNumber {set;get;}
    public String timeStamp {set;get;}
    public String responseCode {set;get;}
    public List<ValidationErrorsList> validationErrorsList {set;get;}
    public Response response {set;get;}

    public class TenantInformation {
        public String tenantType {set;get;}
        public Name name {set;get;}
        public String emiratesID {set;get;}
        public String passportNo {set;get;}
        public String visaNo {set;get;}
        public String visaStartDt {set;get;}
        public String visaEndDt {set;get;}
        public String mobileNo {set;get;}
        public String email {set;get;}
        public String poBox {set;get;}
        public LicenseInformation licenseInformation {set;get;}
    }

    public class LicenseAuthorityInformation {
        public String id {set;get;}
        public Name name {set;get;}
        public Integer code {set;get;}
    }

    public class ValidationErrorsList {
        public Integer errorNumber {set;get;}
        public String validationType {set;get;}
        public String errorMessage {set;get;}

    }

    public class PropertyInformationList {
        public String ejariBusPropertyTypeId {set;get;}
        public String approvalRefNumber {set;get;}
        public String unitNumber {set;get;}
        public String area {set;get;}
        public String dewa {set;get;}
        public String propertyTypeId {set;get;}
        public String propertyType {set;get;}
        public String propertySubTypeId {set;get;}
        public String propertySubType {set;get;}
        public String propertyUsageId {set;get;}
        public String propertyUsage {set;get;}
    }

    public class ContractInformation {
        public String makaniNumber {set;get;}
        public Object uaeNGNumber {set;get;}
        public List<PropertyInformationList> propertyInformationList {set;get;}
        public String contractNumber {set;get;}
        public String startDate {set;get;}
        public String endDate {set;get;}
        public Double contractAnnualAmount {set;get;}
        public Double contractAmount {set;get;}
        public Integer versionNumber {set;get;}
        public AreaZone areaZone {set;get;}
        public AreaZone location {set;get;}
        public AuthorityInformation authorityInformation {set;get;}
        public LicenseInformation licenseInformation {set;get;}
        public GeoLocation geoLocation {set;get;}
        public CommunityInformation communityInformation {set;get;}
        public LandLordInformation landLordInformation {set;get;}
        public TenantInformation tenantInformation {set;get;}
        public String parcelID {set;get;}
        public String landNumber {set;get;}
        public Name buildingName {set;get;}
    }

    public class Name {
        public String englishName {set;get;}
        public String arabicName {set;get;}
    }

    public class CommunityInformation {
        public Integer Code {set;get;}
        public String Name {set;get;}
    }

    public class Response {

        public ContractInformation contractInformation {set;get;}
        public String additionalData {set;get;}
    }

    public class LandLordInformation {
        public Name name {set;get;}
    }

    public class AreaZone {
        public Integer Code {set;get;}
        public Name name {set;get;}
    }

    public class LicenseInformation {
        public String InitialApprovalNumber {set;get;}
        public String LicenseNumber {set;get;}
        public LicenseAuthorityInformation LicenseAuthorityInformation {set;get;}
    }

    public class GeoLocation {
        public String Latitude {set;get;}
        public String Longitude {set;get;}
    }

    public class AuthorityInformation {
        public String Id {set;get;}
        public String Name {set;get;}
        public String Code {set;get;}
    }
}