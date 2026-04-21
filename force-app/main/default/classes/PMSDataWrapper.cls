public class PMSDataWrapper {

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
        public String unitNumberArb {set;get;}
        public String floorEN {set;get;}
        public String floorAR {set;get;}
        public String area {set;get;}
        public String dewa {set;get;}
        public String propertyTypeId {set;get;}
        public String propertyType {set;get;}
        public String propertySubTypeId {set;get;}
        public String propertySubType {set;get;}
        public String propertyUsageId {set;get;}
        public String propertyUsage {set;get;}
        public boolean isMainAddr {set;get;}
    }

    public class ContractInformation {
        public String makaniNumber {set;get;}
        public String uaeNGNumber {set;get;}
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
        public Integer code {set;get;}
        public String name {set;get;}
    }

    public class Response {

        public List<ContractInformation> contractInformation {set;get;}
        public List<LookupItems> lookupItems {set;get;}
        public String additionalData {set;get;}
    }

    public class LandLordInformation {
        public Name name {set;get;}
    }

    public class AreaZone {
        public Integer code {set;get;}
        public Name name {set;get;}
    }

    public class LicenseInformation {
        public String initialApprovalNumber {set;get;}
        public String licenseNumber {set;get;}
        public LicenseAuthorityInformation licenseAuthorityInformation {set;get;}
    }

    public class GeoLocation {
        public String latitude {set;get;}
        public String longitude {set;get;}
    }

    public class AuthorityInformation {
        public String id {set;get;}
        public String name {set;get;}
        public String code {set;get;}
    }
    public class LookupItems {
        public integer identity {set;get;}
        public String value {set;get;}
        public String englishName {set;get;}
        public String arabicName {set;get;}
        public String parentId {set;get;}
        public String otherValue {set;get;}
    }

    /* ccrm data wrapper class */
    public String methodName {set;get;}
    public List<Data> data {set;get;}

    public class LeaseItems {
        public String parentPmsContractNumber {set;get;}
        public String propertyName {set;get;}
        public String propertyNameArabic {set;get;}
        public String approvalReferenceNumber {set;get;}
        public String propertyType {set;get;}
        public String propertyTypeArabic {set;get;}
        public String ejariPropertyType {set;get;}
        public String ejariPropertyTypeArabic {set;get;}
        public String ejariPropertySubtype {set;get;}
        public String ejariPropertySubtypeArabic {set;get;}
        public Integer psf {set;get;}
        public decimal size {set;get;}
        public Boolean isMainAddress {set;get;}
        public String location {set;get;}
        public String usage {set;get;}
        public string floorEN {set;get;}
        public string floorAR {set;get;}
        public decimal floorNumber {set;get;}
    }

    public class Data {
        public String oraclePartyId {set;get;}
        public String contractNumber {set;get;}
        public String landNumber {set;get;}
        public String contractStartDate {set;get;}
        public String contractEndDate {set;get;}
        public String contractStatus {set;get;}
        public String buildingName {set;get;}
        public String buildingNameArabic {set;get;}
        public String dmNumber {set;get;}
        public String dewaAccountNumber {set;get;}
        public String licenseIssuer {set;get;}
        public String makaniNumber {set;get;}
        public Boolean pushToDDA {set;get;}
        public String type {set;get;}
        public String businessPark {set;get;}

        public List<LeaseItems> leaseItems {set;get;}
    }
    public class PMSLeaseResponse{
        public string Id {set;get;}
        public String type {set;get;}
        public boolean isSuccess {set;get;}
        public string errorMessage {set;get;}
    }

}