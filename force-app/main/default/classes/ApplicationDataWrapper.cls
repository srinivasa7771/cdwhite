public class ApplicationDataWrapper {
    public String ApplicationNumber;
    public String residenceNo;
    public cls_applicationData applicationData;

    public class cls_applicationData {
        public cls_Application Application;
    }
    public class cls_Application {
        public cls_ApplicantDetails ApplicantDetails;
        public cls_SponsorDetails SponsorDetails;
        public cls_ApplicationDetails ApplicationDetails;
    }
    public class cls_ApplicantDetails {
        public String FirstNameE;    //RAHIL
        public String FirstNameA;    // رحيل
        public String MiddleNameE;    // ALI MOHAMMED HUSAIN
        public String MiddleNameA;    //
        public String LastNameE;    // SAYED
        public String LastNameA;    // سي
        public String MotherNameE;    // TALAT
        public String MotherNameA;    //
        public String CurrentNationalityId;    //237
        public String PreviousNationality;    //237
        public String BirthDate;    //1990-11-17
        public String BirthCountryId;    //237
        public String BirthPlaceE;    // Mumbai
        public String BirthPlaceA;    // مومباي
        public String SexId;    //1
        public String MaritalStatusId;    //1
        public String ReligionId;    //1
        public String Faith;    //1
        public String EducationId;    //545
        public String ProfessionId;    //1
        public String Language1;    //1
        public String PassportNo;    //X2492497
        public String PassportTypeId;    //1
        public String PassportIssueDate;    //2013-05-29
        public String PassportExpiryDate;    //2023-05-28
        public String PassportPlaceE;    // Mumbai
        public String PassportPlaceA;    // مومباي
        public String PassportIssueCountryId;    //237
        public String PassportIssueGovId;    //237
        public String IsInsideUAE;    //2499BF925BF346E3A88681B1B1DD4B8B
        public Boolean IsOriginalPassportAvailable;
        public String AddressOutsideCountryId;    //237
        public String AddressOutsideCity;    // Mumbai
        public String AddressOutside1;    //Mumbai
        public String AddressOutside2;    //Mumbai
        public String AddressOutsideTelNo;    //00919890071677
        public String EmirateId;    //1
        public String CityId;    //1
        public String AreaId;    //1
        public String Street;    //81 A
        public String Building;    //
        public String Landmark;    //
        public String MakaniNo;    //1111111111
        public String MobileNo;    // 0504993350
        public String ResidenceRequestYear;

    }
    public class cls_SponsorDetails {
        public String SponsorEmail;    //srinivasa.varanasi@tecom.ae
        public String MobileNumber;    //0554480164
        public String EstCode;    //26157223
    }
    public class cls_ApplicationDetails {
        public boolean IsDraft;
         public String ResidencyPickup;
        public String CancellationReason;
    }
    public class EntrypermitDetails{
        public string entrypermitNo {set;get;}
        public string uidNo {set;get;}

    }
}