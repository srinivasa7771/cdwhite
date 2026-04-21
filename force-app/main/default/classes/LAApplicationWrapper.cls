public class LAApplicationWrapper {
    public String permitNo {set;get;}
    public String applicationNumber;
    public String oldFileNo;
    public String oldFileType; /*  visit or cancelled residence */
    public cls_applicationData applicationData;
    public class cls_applicationData {
        public cls_Application Application;
    }
    public class cls_Application {
        public cls_ApplicantDetails ApplicantDetails;
        public cls_SponsorDetails SponsorDetails;
        public cls_ApplicationDetails ApplicationDetails;
    }
    public class cls_ApplicantDetails {}
    public class cls_SponsorDetails {
        public String SponsorEmail; /*srinivasa.varanasi@tecom.ae */
        public String MobileNumber; /*0554480164 */
        public String EstCode; /*26157223*/
    }
    public class cls_ApplicationDetails {
        public boolean IsDraft;
    }
}