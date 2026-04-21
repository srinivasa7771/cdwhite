public class ResidentApplicationNewWrapper {
    public String permitNo;
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
    }
}