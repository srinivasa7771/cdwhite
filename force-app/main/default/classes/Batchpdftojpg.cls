global class Batchpdftojpg implements Database.Batchable < sObject > , Database.AllowsCallouts {
    global String query;
    global Batchpdftojpg() {
        query = 'select id,name,parentid from attachment where name=\'EIDA Application form.pdf\' and createddate > 2021-04-01T06:58:23.000+0000  and createddate < 2021-04-06T12:26:24.000+0000 order by createddate desc';
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('query::' + query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List < Attachment > scope) {
        String pdfimageBase64 = '';
        List < Attachment > attLst = [select id, Body, name, parentid from attachment where parentid =: scope[0].parentid];
        if (attLst != null && attLst.size() == 1) {
            /* call webservice to get base 64 image*/
            HttpRequest req = New HttpRequest();
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Content-Disposition', 'attachment');
            req.setHeader('Apikey', Label.JPGConvertAPIKey);
            String endpointUrl = 'https://v2.convertapi.com/convert/pdf/to/jpg?Secret=' + Label.JPGConvertSecret;
            req.setTimeout(90000);
            req.setMethod('POST');
            req.setEndpoint(endpointUrl);
            req.setBody('{"Parameters":[{"Name":"File","FileValue":{"Name":"my_file.pdf","Data":"' + EncodingUtil.base64Encode(attLst[0].body) + '"}},{"Name":"StoreFile","Value":false},{"Name":"ImageResolution","Value":65}]}');
            Http http = new Http();
            try {
                HTTPResponse res = http.send(req);
                system.debug('res : ' + res.getBody());
                if (res.getStatusCode() == 200) {
                    String jsonResp = res.getBody();
                    FileInfo finfo = (FileInfo) Json.deserialize(jsonResp, FileInfo.class);
                    if (finfo != null && finfo.Files != null && !finfo.Files.isEmpty()) {
                        pdfimageBase64 = finfo.Files[0].FileData;
                    }
                }
            } catch (System.CalloutException e) {
                system.debug('exception::' + e.getMessage());
            }
            if (String.isNotBlank(pdfimageBase64)) {
                String docName = attLst[0].name;
                docName = docName.replace('.pdf', '.jpg');
                Attachment a = new Attachment(Body = EncodingUtil.base64Decode(pdfimageBase64), Name = docName, ParentId = attLst[0].parentid);
                insert a;
            }
        }
    }
    global void finish(Database.BatchableContext BC) {}
    public class FileInfo {
        public List < Files > Files;
    }
    public class Files {
        public string FileData;
    }
}