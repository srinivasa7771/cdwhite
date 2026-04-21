public class LARequestWrapper{
    public class Addresses {
        public String type{get; set;}
        public String street{get; set;}
        public String postalCode{get; set;}
        public String phone{get; set;}
        public String mobile{get; set;}
        public String homePhone{get; set;}
        public String email{get; set;}
        public String country{get; set;}
        public String city{get; set;}
        public String buildingNo{get; set;}
        public String area{get; set;}
    }

    public class Activities {
        public Decimal noOfTitleAndChannels{get; set;}
        public String name{get; set;}
        public String ddaId{get; set;}
        public List<ChannelTitles> channelTitles{get; set;}
        public String actionType{get; set;}
    }

    public List<ServiceRequests> serviceRequests{get; set;}

    public class EmiratesId {
        public Date issueDate{get; set;}
        public Date expiryDate{get; set;}
        public String docNo{get; set;}
    }

    public class ServiceRequests{
        public String serviceId{
            get;
            set;
        }
        public String axsRefNo{
            get;
            set;
        }
        public String licenseNo{
            get;
            set;
        }
        public Boolean isPaid{
            get;
            set;
        }
        public List<Members> members{
            get;
            set;
        }
        public List<Locations> locations{
            get;
            set;
        }
        public CompanyInfo companyInfo{
            get;
            set;
        }
        public List<Activities> activities{
            get;
            set;
        }
        public String proposedName1{
            get;
            set;
        }
        public String proposedName2{
            get;
            set;
        }
        public String proposedName3{
            get;
            set;
        }
        public String proposedParentName{
            get;
            set;
        }
    }

    public class Locations {
        public String name{get; set;}
        public String leaseItemDdaId{get; set;}
        public String actionType{get; set;}
    }

    public class Passports {
        public String countryOfIssuance{get; set;}
        public String placeOfIssuance{get; set;}
        public Date issueDate{get; set;}
        public Date expiryDate{get; set;}
        public String docNo{get; set;}
        public String uploadedExDoc{get; set;}
    }

    public class CompanyInfo {
        public String proposedNewName3{get; set;}
        public String proposedNewName2{get; set;}
        public String proposedNewName1{get; set;}
        public String operatingName{get; set;}
    }

    public class Members {
        public String positions{get; set;}
        public String attachmentId   {get; set;}
        public String EIDfId{get; set;}
        public String EIDbId{get; set;}
        public String visaId{get; set;}
        public String phoneNo{get; set;}
        public Boolean isPhoneVerified{get; set;}
        public DateTime phoneVerificationDateTime{get; set;}
        public String perMobile{get; set;}
        public Boolean isMobilePhoneVerified{get; set;}
        public DateTime mobilePhoneVerificationDatetime{get; set;}
        public String perEmail{get; set;}
        public Boolean isEmailVerified{get; set;}
        public DateTime emailVerificationDatetime{get; set;}
        public Boolean visitedUAE{get; set;}
        public String birthCountry{get; set;}
        public String nationality{get; set;}
        public String lastName{get; set;}
        public String gender{get; set;}
        public String firstName{get; set;}
        public String ddaId{get; set;}
        public Date birthDate{get; set;}
        public String placeborn{get; set;}
        public Date dateOfIncorporation{get; set;}
        public String countryOfIncorporation{get; set;}
        public String operatingName{get; set;}
        public String registrationNo{get; set;}
        public Decimal proposedNumberOfShares{get; set;}
        public Decimal currentNumberOfShares{get; set;}
        public Date registrationDate{get; set;}
        public Date cessationDate{get; set;}
        public List<Passports> passports{get; set;}
        public EmiratesId emiratesId{get; set;}
        public List<Addresses> addresses{get; set;}
        public String actionType{get; set;}
        public String UID{get; set;}
        public String salutation{get; set;}
        public String middleName{get; set;}
        public String operatingNameArabic{get; set;}
        public String firstNameArabic{get; set;}
        public String lastNameArabic{get; set;}
        public String middleNameArabic{get; set;}
    }

    public class ChannelTitles {
        public String targetedAudience{get; set;}
        public String requestType{get; set;}
        public String printingCompany{get; set;}
        public String name{get; set;}
        public String languages{get; set;}
        public Boolean isOnAir{get; set;}
        public Boolean isNameConfirmed{get; set;}
        public Boolean isApprovedByNMC{get; set;}
        public String genre{get; set;}
        public String frequency{get; set;}
        public String distributionType{get; set;}
        public String distributionCompany{get; set;}
        public String background{get; set;}
        public String areaOfDistribution{get; set;}
        public String arabicName{get; set;}
        public String approvalStatus{get; set;}
        public String actionType{get; set;}
        public String licensedTitleChannelDdaId{get; set;}
    }

    public static LARequestWrapper parse(String json) {
        return (LARequestWrapper ) System.JSON.deserialize(json, LARequestWrapper.class);
    }
}