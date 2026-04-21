public class InsuranceWrapper {
    //Generate policy wrapper
    public class Insurance {
        public QuoteInfo QuoteInfo;
        public SponsorInfo SponsorInfo;
        public List < InsuredInfo > InsuredInfo;
        public PolicyInfo PolicyInfo;
        public PartnerInfo PartnerInfo;
    }
    public class QuoteInfo {
        public String RefNo, QuotationNo, VisaEmirate, SalaryBand, PolicyType, PlanType, NoOfPersonsToInsure, IncludingSponsor, MemberId, disclaimer;
    }
    public class SponsorInfo {
        public String Name, MobileNo, TradeLicenseNo, IsADNICMember, EmailId, DOB, SponsorPFNo, VATRegNo, City, Address, POBoxNo, PhoneNo, SponsorMedPolicyNo;
        public PersonalInfo PersonalInfo;
    }
    public class InsuredInfo {
        public String Name, DOB, Relationship, Gender, PreviouslyCovered, PregnantStatus, MaritalStatus, mobileNo, Nationality, PassportNo, UIDNo, ResidenceLocation,
            SalaryCap, EmiratesId, EmiratesIdApplicationNo, OccupationalIndustry, WorkLocation, MemberCategory, EntryPermitNo, emailId, placeOfBirth,
            currentAddress, placeOfWork, contactDetails, permanentResidency, Commission;

        public PersonalInfo PersonalInfo;
    }
    public class PolicyInfo {
        public String PolicyStartDate, PolicyEndDate, FinalPremiumAmt, PaymentType, PaymentRefNo;
    }
    public class PartnerInfo {
        public String PartnerId;
    }
    public class PersonalInfo {
        public String nationality, placeOfBirth, currentAddress, placeOfWork, passportNumber, eidNumber, contactDetails, birthCertificateNumber, permanentResidency;
    }

    //Upload doc wrapper
    public class uploadDoc{
        public PartnerInfo PartnerInfo;
        public      List<DocumentInfo>  DocumentInfo;
    }
    public class   DocumentInfo  {
        public String MemberId, DocumentCategory, DocumentContent, DocumentName;
    }
}