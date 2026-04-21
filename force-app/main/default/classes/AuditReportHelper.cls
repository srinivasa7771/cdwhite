public class AuditReportHelper {

    public static List<openAFSRequests> getPreviousReqDetails(String licNo) {

        String jsonResponse = '';
        String jsonBody='{"methodname": "getafsinfo", "data": {"licenseNum": "'+licNo+'"}}';
        List<openAFSRequests> openAfslst = new List<openAFSRequests> ();
        try{
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept', 'application/json');
            request.setEndpoint('callout:DCCA_Auth/apexrest/onbordingapi');
            request.setMethod('POST');
            request.setBody(jsonBody);
            request.setTimeout(60000);
            response = h.send(request);
            System.debug('<getNewReqDetails> response: ' + response);
            if (response.getStatusCode() == 200) {
                jsonResponse = response.getBody();
               /// jsonResponse='{"openAFSRequests":[{"totalAmountToPay":0.00, "subRequests":[], "submitForStartDate":"2021-09-01", "submitForEndDate":"2022-08-31", "status":"Awaiting Submission", "invoiceItems":[], "financialYearStart":"2021-09-01", "financialYearEnd":"2022-08-31", "financialYear":2021, "ddaId":"1a1CFV000000mB7d2AE", "axsRefNo":null, "attachments":[]}, {"totalAmountToPay":0.00, "subRequests":[], "submitForStartDate":"2022-09-01", "submitForEndDate":"2023-08-31", "status":"Awaiting Submission", "invoiceItems":[], "financialYearStart":"2022-09-01", "financialYearEnd":"2023-08-31", "financialYear":2022, "ddaId":"1a1CFV000000mB9F2AU", "axsRefNo":null, "attachments":[]}, {"totalAmountToPay":10020.00, "subRequests":[{"type":"AFS Penalty", "status":"Approved", "requestSubmissionDate":null, "isRejected":false, "isApproved":true, "inProgress":false}], "submitForStartDate":"2023-09-01", "submitForEndDate":"2024-08-31", "status":"Awaiting Submission", "invoiceItems":[{"name":"Audited Financial Statement Submission Overdue", "fineOrFee":"Fine", "amount":10000}, {"name":"Knowledge Dirham", "fineOrFee":"Fine", "amount":10}, {"name":"Innovation Dirham", "fineOrFee":"Fine", "amount":10}], "financialYearStart":"2023-09-01", "financialYearEnd":"2024-08-31", "financialYear":2023, "ddaId":"1a1CFV000000mB612AE", "axsRefNo":null, "attachments":[{"uploadedContentId":"069FV000001JdJdYAK", "isUploaded":true, "isMandatory":true, "fileName":"Engagement Letter from the Appointed Auditor", "ddaId":"a3eFV0000001VWPYA2"}]}], "license":93353}';

                //jsonResponse='{"openAFSRequests":[{"totalAmountToPay":0.00, "subRequests":[], "submitForStartDate":"2022-09-01", "submitForEndDate":"2023-08-31", "status":"Awaiting Submission", "invoiceItems":[], "financialYearStart":"2022-09-01", "financialYearEnd":"2023-08-31", "financialYear":2022, "ddaId":"1a1CFV000000mB9F2AU", "axsRefNo":null, "attachments":[]}, {"totalAmountToPay":10020.00, "subRequests":[{"type":"AFS Penalty", "status":"Approved", "requestSubmissionDate":null, "isRejected":false, "isApproved":true, "inProgress":false}], "submitForStartDate":"2023-09-01", "submitForEndDate":"2024-08-31", "status":"Awaiting Submission", "invoiceItems":[{"name":"Audited Financial Statement Submission Overdue", "fineOrFee":"Fine", "amount":10000}, {"name":"Knowledge Dirham", "fineOrFee":"Fine", "amount":10}, {"name":"Innovation Dirham", "fineOrFee":"Fine", "amount":10}], "financialYearStart":"2023-09-01", "financialYearEnd":"2024-08-31", "financialYear":2023, "ddaId":"1a1CFV000000mB612AE", "axsRefNo":null, "attachments":[{"uploadedContentId":"069FV000001JdJdYAK", "isUploaded":true, "isMandatory":true, "fileName":"Engagement Letter from the Appointed Auditor", "ddaId":"a3eFV0000001VWPYA2"}]}], "license":93353}';

                //jsonResponse='{"openAFSRequests":[{"totalAmountToPay":10020.00, "subRequests":[{"type":"AFS Penalty", "status":"Approved", "requestSubmissionDate":null, "isRejected":false, "isApproved":true, "inProgress":false}], "submitForStartDate":"2023-09-01", "submitForEndDate":"2024-08-31", "status":"Awaiting Submission", "invoiceItems":[{"name":"Audited Financial Statement Submission Overdue", "fineOrFee":"Fine", "amount":10000}, {"name":"Knowledge Dirham", "fineOrFee":"Fine", "amount":10}, {"name":"Innovation Dirham", "fineOrFee":"Fine", "amount":10}], "financialYearStart":"2023-09-01", "financialYearEnd":"2024-08-31", "financialYear":2023, "ddaId":"1a1CFV000000mB612AE", "axsRefNo":null, "attachments":[{"uploadedContentId":"069FV000001JdJdYAK", "isUploaded":true, "isMandatory":true, "fileName":"Engagement Letter from the Appointed Auditor", "ddaId":"a3eFV0000001VWPYA2"}]}], "license":93353}';
                //jsonResponse='{"openAFSRequests":[{"totalAmountToPay":0, "subRequests":[{"type":"AFS Penalty", "status":"Approved", "requestSubmissionDate":null, "isRejected":false, "isApproved":true, "inProgress":false}], "submitForStartDate":"2024-01-01", "submitForEndDate":"2024-12-31", "status":"Awaiting Submission", "financialYearStart":"2024-01-01", "financialYearEnd":"2024-12-31", "financialYear":2024, "ddaId":"1a1CFV000000mB612AE", "axsRefNo":null, "attachments":[{"uploadedContentId":"069FV000001JdJdYAK", "isUploaded":true, "isMandatory":true, "fileName":"Engagement Letter from the Appointed Auditor", "ddaId":"a3eFV0000001VWPYA2"}]}], "license":93353}';
                ///jsonResponse='{"openAFSRequests":[{"totalAmountToPay":"10000.00", "subRequests":[{"type":"AFS Penalty", "status":"Approved", "requestSubmissionDate":null, "isRejected":false, "isApproved":true, "inProgress":false}], "submitForStartDate":"2023-06-15", "submitForEndDate":"2024-07-14", "status":"Awaiting Submission", "financialYearStart":"2023-06-15", "financialYearEnd":"2024-07-14", "financialYear":2024, "ddaId":"1a1CFV000000mB612AE", "axsRefNo":null, "attachments":[{"uploadedContentId":"069FV000001JdJdYAK", "isUploaded":true, "isMandatory":true, "fileName":"Engagement Letter from the Appointed Auditor", "ddaId":"a3eFV0000001VWPYA2"}]}], "license":93353}';
                AFSRequests afsReq =(AFSRequests) System.JSON.deserialize(jsonResponse, AFSRequests.class);
                openAfslst = afsReq.openAFSRequests;
            }
        }catch (Exception e) {
        }
        return openAfslst;
    }

    /*
    public static List<openAFSRequests> getPrvReq(String licno) {

        String xx='{"openAFSRequests":[{"totalAmountToPay":10020.00, "invoiceItems":[{"name":"Audited Financial Statement Submission Overdue", "fineOrFee":"Fine", "amount":10000}, {"name":"Knowledge Dirham", "fineOrFee":"Fine", "amount":10}, {"name":"Innovation Dirham", "fineOrFee":"Fine", "amount":10}], "financialYearStart":"2023-01-01", "financialYearEnd":"2023-12-31", "financialYear":2023, "ddaId":"a1CFW000000FFgH2AW", "axsRefNo":null, "attachments":[{"uploadedContentId":null, "isUploaded":false, "isMandatory":true, "fileName":"Engagement Letter from the Appointed Auditor", "ddaId":"a3eFW00000007PhYAI"}]}, {"totalAmountToPay":10020.00, "invoiceItems":[{"name":"Audited Financial Statement Submission Overdue", "fineOrFee":"Fine", "amount":10000}, {"name":"Knowledge Dirham", "fineOrFee":"Fine", "amount":10}, {"name":"Innovation Dirham", "fineOrFee":"Fine", "amount":10}], "financialYearStart":"2022-01-01", "financialYearEnd":"2022-12-31", "financialYear":2022, "ddaId":"a1CFW000000FFgH2AW", "axsRefNo":null, "attachments":[{"uploadedContentId":null, "isUploaded":false, "isMandatory":true, "fileName":"Engagement Letter from the Appointed Auditor", "ddaId":"a3eFW00000007PhYAI"}]}], "license":102889}';
        system.debug('################################+'+xx);
        AFSRequests afsReq =(AFSRequests) System.JSON.deserialize(xx, AFSRequests.class);
        
        system.debug('^^^^^^^^^^^^^^^^'+afsReq);
        List<openAFSRequests> openAfslst=afsReq.openAFSRequests;
        return openAfslst ;
    }
  */

}