public class gctlFileDwnld {

    public transient string docCopy {get;set;}
    public string strExt {get;set;}
    public string filename {get;set;}
    public PageReference getDocCopy() {
        String docId= apexpages.currentpage().getparameters().get('id');
        String lc= apexpages.currentpage().getparameters().get('lc');
       // if (String.isNotBlank(lc)) { String jsonResp = grqWsDccaGetService.getLicenseCopy(lc); Map<String, Object> metadata_Map = (Map<String, Object>) JSON.deserializeUntyped(jsonResp); docCopy=(String)metadata_Map.get('body'); }
        if (String.isNotBlank(lc)) {
            return new PageReference('/axslogin');
        }
        else{
            List<Attachment> a  = [select id, name, body, contenttype  from attachment where id=:docId];
        if (a.size()>0) {
            strExt = a[0].contenttype;  filename =  a[0].name;
            /*Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename='+a[0].name); */
            docCopy= EncodingUtil.base64Encode(a[0].Body);

        }
        }

        return null;
    }
}