public class mdWrapper {
    public List<IdentityInfo> IdentityInfo{get; set;}
    public List<IdentityInfo> DirectersIdentityInfo{get; set;}
    public List<IdentityInfo> MembersIdentityInfo{get; set;}

    public class ContactDetail {
        public String Nationality{get;set;}
        public String mobileNumber{
            public get{
                if (mobileNumber=='util_reset@test.com') {
                    return null;
                }
                if (mobileNumber != null && mobileNumber!='util_reset@test.com') {
                    if (mobileNumber.startswith('00971')) {
                        return mobileNumber.replace('00971', '');
                    }
                    else if (mobileNumber.startswith('0')) {
                        return mobileNumber.replace('0', '');
                    }
                }
                return mobileNumber;
                }
            public set;}
        public String middleName{get;set;}
        public Boolean isMobilePhoneVerified{get;set;}
        public DateTime mobilePhoneVerificationDatetime{get;set;}
        public Boolean isEmailVerified{get;set;}
        public DateTime emailVerificationDatetime{get;set;}
        public String lastName{get;set;}
        public String gender{get;set;}
        public String firstName{get;set;}
        public String firstNameArabic{get;set;}
        public String lastNameArabic{get;set;}
        public String emailAddress{get;set;}
        public String dateOfBirth{get;set;}
        public boolean visitedUAE{get;set;}
        public string birthCountry{get;set;}
        public string placeOfBirth{get;set;}
    }

    public class ResponseCode {
        public Integer responseCode{get;set;}
        public String errorMessage{get;set;}
    }

    public ResponseCode responseCode{get;set;}

    public class AddressDetailsInUAE {
        public String residencePhone{get;set;}
        public String POBoxNo{get;set;}
        public String officePhoneNo{get;set;}
        public String mobileNo{get;set;}
        public String emailAddress{get;set;}
        public String city{get;set;}
        public String address{get;set;}
    }

    public class IdentityInfo {
        public String reqNum{get;set;}
        public String reqId{get;set;}
        public String role{get;set;}
        public PassportInfo passportInfo{get;set;}
        public String nationalIdNo{get;set;}
        public String identityName{get;set;}
        public String identityId{get;set;}
        public EmiratesIdInfo emiratesIdInfo{get;set;}
        public ContactDetail contactDetail{get;set;}
        public AddressDetailsInUAE addressDetailsInUAE{get;set;}
        public AddressDetailsInHomeCountryPermanent addressDetailsInHomeCountryPermanent{get;set;}
    }

    public class PassportInfo {
        public String passportNumber{get;set;}
        public String passportIssueDate{get;set;}
        public String passportExpiryDate{get;set;}
        public String passportIssuePlace{get;set;}

        public Boolean isExpired{
            public get{
                Boolean check = false;
                if (String.isBlank(passportNumber)||String.isBlank(passportIssueDate)||String.isBlank(passportExpiryDate)) {
                    check = true;
                }
                else if (Date.valueOf(passportExpiryDate)<Date.today()) {
                    check = true;
                }
                return check;
            }
            public set;
        }
    }

    public class AddressDetailsInHomeCountryPermanent {
        public String residencePhone{get;set;}
        public String POBoxNo{get;set;}
        public String officePhoneNo{get;set;}
        public String mobileNo{get;set;}
        public String emailAddress{get;set;}
        public String country{get;set;}
        public String city{get;set;}
        public String address{get;set;}
    }

    public class EmiratesIdInfo {
        public String emiratesIdNumber{get;set;}
        public String emiratesIdIssueDate{get;set;}
        public String emiratesIdExpiryDate{get;set;}
        public Boolean isExpired{
            //public get{ Boolean check = false;if (String.isBlank(emiratesIdNumber)||String.isBlank(emiratesIdIssueDate)||String.isBlank(emiratesIdExpiryDate)) {check = true;}else if (Date.valueOf(emiratesIdExpiryDate)<Date.today()) {check = true;}return check;}
            public get {
                Boolean check = false;
                if (String.isNOTBlank(emiratesIdNumber) && String.isBlank(emiratesIdExpiryDate)) {
                    check = true;
                    return check;
                }
                else if (String.isNOTBlank(emiratesIdNumber) &&  Date.valueOf(emiratesIdExpiryDate) < Date.today()) {
                    check = true;
                }
                return check;
            }
            public set;
        }
    }
}