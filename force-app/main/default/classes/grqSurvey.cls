public class grqSurvey{

    static map<string, Survey_Request__c> mapOfUniqueIdsWithNewResponse;
    static List<Survey_Request__c> listOfSurveyResponse ;

    public static void generateResponse(List<Answer__c> newSurveyResponses, boolean before, boolean after) {

        listOfSurveyResponse = [select id, Survey__c, Anonymous_Survey_Request__c, Unique_Response_Id__c, Survey_Score__c
                                from Survey_Request__c
                                where Survey__c =:gU.csStr('Counter Survey') and Anonymous_Survey_Request__c = false
                                 and Unique_Response_Id__c != null
                                 order by createddate desc limit 200];
        mapOfUniqueIdsWithNewResponse = new map<string, Survey_Request__c> ();
        for (Survey_Request__c sr: listOfSurveyResponse ) {
            mapOfUniqueIdsWithNewResponse.put(sr.Unique_Response_Id__c, sr);
        }

        if (before) {
            for (Answer__c response : newSurveyResponses) {

                if (mapOfUniqueIdsWithNewResponse.size() > 0) {

                    if (mapOfUniqueIdsWithNewResponse.containsKey(response.Unique_Response_Id__c)) {
                        response.Survey_Request__c = mapOfUniqueIdsWithNewResponse.get(response.Unique_Response_Id__c).Id ;
                    }
                    else if (response.Survey_Request__c == gU.csStr('counter SurveyId')) {
                        response = CreateNewAndAssociate(response);
                    }
                }
            }
        }
        if (after) {
            CreateNewAnswers(newSurveyResponses);
        }

     }

     static void CreateNewAnswers(List<Answer__c> SurveyResponses) {
        List<Detail__c> ListResponseDetails = new List<Detail__c>() ;
        Detail__c responseDetail;

        for (Answer__c response : SurveyResponses) {

            if (response.Answer_by_customer__c != '' && response.Answer_by_customer__c != null) {
                if (response.Answer_by_customer__c.contains(', ')) {
                    string[] responses = response.Answer_by_customer__c.split(', ');
                    for (string resDetail : responses) {
                        responseDetail = new Detail__c ();
                        responseDetail.Name = resDetail.Trim();
                        responseDetail.Category__c = response.Category__c ;
                        responseDetail.Answer__c = response.Id;
                        responseDetail.Index__c = 1;
                        ListResponseDetails.add(responseDetail);
                    }
                }
                else if (response.Value__c == null && response.Answer_by_customer__c != null) {
                    responseDetail = new Detail__c ();
                    responseDetail.Category__c = response.Category__c ;
                    responseDetail.Name = response.Answer_by_customer__c.Trim();
                    responseDetail.Answer__c = response.Id;
                    responseDetail.Index__c = 1;
                    ListResponseDetails.add(responseDetail);
                }
            }
            else if (response.Value__c != null) {
                responseDetail = new Detail__c ();
                responseDetail.Answer__c = response.Id;
                responseDetail.Index__c = response.Value__c;
                responseDetail.Name = string.valueOf(response.Value__c) ;
                responseDetail.Name = response.Category__c ;
                responseDetail.Category__c = response.Category__c ;
                ListResponseDetails.add(responseDetail);
            }

        }
        if (ListResponseDetails.size() > 0) {

                 if (Schema.sObjectType.Detail__c.isCreateable()) {
                     insert ListResponseDetails;
                 }
            }
    }

    static Answer__c CreateNewAndAssociate(Answer__c resp) {

        Survey_Request__c request = new Survey_Request__c();
        request.Survey__c = resp.Survey__c ;
        request.Unique_Response_Id__c = resp.Unique_Response_Id__c;
        request.Survey_Score__c = resp.Score__c;

        if (Schema.sObjectType.Survey_Request__c.isCreateable()) {
            insert request;
        }

        resp.Survey_Request__c = request.Id ;

        mapOfUniqueIdsWithNewResponse.put(resp.Unique_Response_Id__c, request);

        return resp;
    }

}