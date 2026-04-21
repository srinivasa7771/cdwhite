public class PdftoJpgCtrl {
  //declare a variable to pass data to Visualforce Page
 public transient  string body{get;set;}
 public  string contentType {get;set;}

    public PdftoJpgCtrl() {
     string attid=   String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
          Attachment att= [select id, body, ContentType from Attachment where id=:attid];
          body = EncodingUtil.base64Encode(att.Body);
        contentType = att.ContentType;
    }

}