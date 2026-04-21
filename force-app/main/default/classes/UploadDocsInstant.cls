public class UploadDocsInstant {

    public static void uploadDocs(String reqid) {
        List<g_Req__c> reqlst = new List<g_Req__c>();
        if (String.isNotBlank(reqid)) {
            reqlst=[select Name from g_Req__c where Id=:reqid];
        }
        if (!reqlst.isEmpty()) {
            if (String.isNotBlank(reqlst[0].Name)) {
                List<g_reqitemDoc__c> rqitemdocs =[select id, name, Re__c, Req__c, reqItm__c, upOk__c, reqDoc__c from g_reqitemDoc__c where Re__c=:reqlst[0].Name AND Req__c=true];
                String bodyStr ='document1';
                List<Attachment> attachmentlst = new List<Attachment>();
                system.debug('rqitemdocs'+rqitemdocs);
                Set<Id> reqdocIds = new Set<Id>();
                if (!rqitemdocs.isEmpty()) {
                    for (g_reqitemDoc__c itmdoc : rqitemdocs) {
                        if (itmdoc.Req__c == true && itmdoc.upOk__c == false) {
                            reqdocIds.add(itmdoc.reqDoc__c);
                            Attachment att=new Attachment();
                            att.Body=Blob.valueOf(bodyStr);
                            att.Name= itmdoc.Name+ '.jpg';
                            att.parentId=itmdoc.reqDoc__c;
                            attachmentlst.add(att);
                        }
                    }
                    system.debug('attachmentlst'+attachmentlst);
                    system.debug('attachmentlst size'+attachmentlst.size());
                    if (!attachmentlst.isEmpty()) {
                        if (Schema.sObjectType.Attachment.isCreateable()) {
                            insert attachmentlst;
                        }
                    }
                }

            }
        }
    }

}