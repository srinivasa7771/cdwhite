public class openAFSRequests {
    public String totalAmountToPay {get;set;}
    public  List<invoiceItems> invoiceItems {get;set;}
    public String financialYearStart{get;set;}
    public String financialYearEnd{get;set;}
    public Date finYearStartDt{get;set;}
    public Date finYearEndDt{get;set;}
    public Integer financialYear{get;set;}
    public String ddaId{get;set;}
    public String  axsRefNo{get;set;}
    public String  Status{get;set;}
    public List<attachments> attachments{get;set;}
    public List<subRequests> subRequests{get;set;}

    public class invoiceItems {
        public String name{get;set;}
        public String fineOrFee{get;set;}
        public Integer amount{get;set;}
    }

    public class subRequests{
        public String type{get;set;}
        public String status{get;set;}
        public String requestSubmissionDate{get;set;}
        public boolean isRejected{get;set;}
        public boolean isApproved{get;set;}
        public boolean inProgress{get;set;}

    }
    public class attachments {
        public String  uploadedContentId{get;set;}
        public boolean isUploaded{get;set;}
        public boolean isMandatory{get;set;}
        public String fileName{get;set;}
        public String ddaId{get;set;}
    }
}