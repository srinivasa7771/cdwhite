public class ApplicationDetailsWrapper {
    public String applicationId {set;get;}    //21920100621456
    public String applicationStateComment {set;get;}    //

    public String sponsorEstCode {set;get;}    //26158125
    public String applicantEstCode {set;get;}    //26158125
    public String paymentDate {set;get;}    //2019-11-03T10:10:38Z
    public String contactMobilePhone {set;get;}    //0501599747
    public String createdOn {set;get;}    //2019-11-03T10:08:21Z
    public String expiryDate {set;get;} //2025-08-10
    public String IssueDate {set;get;} //2025-08-10
    public cls_fees[] fees;
    public cls_documents[] documents;
    public boolean IsSuccess;
    public String errorCode;
    public ErrorMsg[] errorMsg;
    public ApplicantProfile IndividualProfile;
    public class cls_fees {
        public String feeTypeId;    //7757f3d3-9fae-4cb9-a85b-70ded1d91a38
        public Decimal amount;    //50
        public String nameEn;    //Service Fee
        public String nameAr;    //رسم الخدمة
    }
    public class cls_documents {
        public String content;    //
        public String filename;    //Personal Photo.jpg
        public String nameEn;    //Personal Photo
        public String nameAr;    //صورة شخصية
        public boolean isMandatory;
        public String documentTypeId;    //50f41f94-b59b-4482-871e-2eff765aa5ba
    }

    public class AttachmentJSON {
        public String fileName;
        public String fileType;
        public String reportContentAsBase64String;
    }

    public class ApplicantProfile{
        public string IndividualNameEN;
        public string IndividualNameAR;
        public string FIRST_NAME_EN;
        public string SECOND_NAME_EN;
        public string LAST_NAME_EN;
        public string FIRST_NAME_AR;
        public string SECOND_NAME_AR;
        public string LAST_NAME_AR;
        public string PassportNo;
    }

    public class ErrorMsg {
        public string messageEn;
    }
}