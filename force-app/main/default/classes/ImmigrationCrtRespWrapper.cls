public class ImmigrationCrtRespWrapper {
    public String applicationId {
        set;
        get;
    }
    /*21920100010393 */ public cls_Documents[] Documents;
    public class cls_Documents {
        public String documentTypeId;
        /*9cb0b7bb-b35a-4205-9ec0-984a6fc419b3*/ public boolean IsMandatory;
        public String MineType;
        /*image/jpeg */ public String documentNameEn;
        /*Employment Contract  Page 1*/ public String documentNameAr;
        public String FileName;
    /*11.jpg*/ }
    public static ImmigrationCrtRespWrapper parse(String json) {
        return (ImmigrationCrtRespWrapper) System.JSON.deserialize(json, ImmigrationCrtRespWrapper.class);
    }
    public cls_DocumentsList[] DocumentsList;
    public class cls_DocumentsList {
        public String documentTypeId;
        /*831835d8-a613-4bd3-a9d8-c4c111aa5550*/ public boolean IsMandatory;
        public String MimeType;
        /*2*/ public String documentNameEn;
        /*Others Page 1*/ public String documentNameAr;
        /* 1*/ public String Reason;
        /*Document name Recent  document required*/ public String FileName;
        public boolean IsNew;
    }
    public ApplicationResponse appResponse;
    public class ApplicationResponse {
        public String applicationId;
        /*21920100013457*/ public String batchId;
    /*201006830*/ }
    public ApplicationStatus ApplicationStatus;
    public class ApplicationStatus {
        public String ApplicationNumber;
        /*21920100013226*/ public String StatesCode;
        /*ADDITIONALDOCREQUIRED */ public String PaidOn;
        /*2019-10-24T05:59:53Z*/ public String RefernceNumber;
        /*S2PMS1571896793480*/ public String TransactionId;
        /*201006742*/ public String ApplicantName;
        /*SRAVAN KUMAR GAVVA*/ public String CurrentStatus;
        /*Additional Documents Required*/ public String ServiceName;
        /*New Work Entry Permit*/ public String FileNo;
        /*0*/ public Integer FileType;
    /*0*/ }
    public class Fees {
        public String nameEn;
        public Decimal amount;
        public boolean isMandatory;
    }
    public class FeeResponse {
        public String applicationId;
        public List < Fees > fees;
    }
}