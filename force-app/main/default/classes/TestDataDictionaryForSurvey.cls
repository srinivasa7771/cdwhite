@isTest
public class TestDataDictionaryForSurvey{

    public static Survey__c SurveyData() {
        Survey__c srvy = new Survey__c();
        srvy.Name = 'AXS Center';
        srvy.Survey_Type__c = 'Customer Feedback';
        srvy.Service_Type__c = 'CoA Amendment';
        srvy.Total_Number_of_Questions_to_be_asked__c = 3;
        srvy.Total_no_of_questions_must_be_answered__c = 2;
        return srvy;
    }

    public static Survey_Request__c SurveyResponseData(Survey__c srv) {
        Survey_Request__c sr = new Survey_Request__c ();
        sr.Anonymous_Survey_Request__c = false;
        sr.Survey__c = srv.Id;
        return sr;
    }

    public static Questionaire__c QuestionaireData(string quesText, string quesType, Survey__c srv) {
        Questionaire__c questionaire = new Questionaire__c();
        questionaire.Question_Text__c = quesText;
        questionaire.Survey__c = srv.Id ;
        questionaire.Type_of_question_in_GetFeedback__c = quesType;
        return questionaire ;
    }

    public static Answer__c AnswerData(string ansr, string cat, decimal val, string uid, Id sfId, Id qId ) {
        Answer__c ans = new Answer__c();
        ans.Answer_by_customer__c = ansr;
        ans.Value__c = val;
        ans.Category__c = cat;
        ans.Comments__c = 'test Comments';
        ans.Start_time__c = DateTime.Now();
        ans.Completion_Time__c = Datetime.Now() + 1;
        ans.Survey_Request__c = sfId ;
        ans.Unique_Response_Id__c = uid;
        ans.Questionaire__c = qId;
        return ans;
    }

}