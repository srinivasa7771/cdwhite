public class DocumentConversionWrapper {

    public List<FileInfo> Files;
    public integer ConversionCost;
    public class FileInfo{
        public String FileName {set;get;}
        public String FileExt {set;get;}
        public String FileData {set;get;}
    }
   public static DocumentConversionWrapper parse(String json) {
        return (DocumentConversionWrapper) System.JSON.deserialize(json, DocumentConversionWrapper.class);
    }
}