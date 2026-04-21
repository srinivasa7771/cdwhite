/*

Created Date:            06-11-2016
Description:     Covering grqSurvey apex class

*/

@isTest
public class testSurvey{


    // User Input good feedback and selected multiple values
    static testMethod void SurveyRequestTest1(){

        // Insert Survey Data
        Survey__c survey = TestDataDictionaryForSurvey.SurveyData();
        insert survey ;
         List<gStg__c> lstGStg = new List<gStg__c>();
        gStg__c pActivation = new gStg__c(name='counter SurveyId',Text_Value__c = 'a1328000000qraLAAQ');
        gStg__c srv = new gStg__c(name='Counter Survey',Text_Value__c = survey.id);
        lstGStg.add(pActivation);
        lstGStg.add(srv);
        SObjectAccessDecision secDec = Security.stripInaccessible(AccessType.CREATABLE, lstGStg);
        insert secDec.getRecords();

        // Insert Survey Response
        List<Survey_Request__c> srLst = new List<Survey_Request__c>();
        Survey_Request__c sr = TestDataDictionaryForSurvey.SurveyResponseData(survey);
        sr.Anonymous_Survey_Request__c = true;
        srLst.add(sr);
        Survey_Request__c sr1 = TestDataDictionaryForSurvey.SurveyResponseData(survey);
        sr1.Anonymous_Survey_Request__c = false;
        sr1.Unique_Response_Id__c = 'R_1552212628223_5';
         srLst.add(sr1);
        SObjectAccessDecision secDec2 = Security.stripInaccessible(AccessType.CREATABLE, srLst);
        insert secDec2.getRecords();

        // Insert question 1
        Questionaire__c question1 = TestDataDictionaryForSurvey.QuestionaireData('How satisfied are you?', 'Rating', survey );
        question1.Question_Number__c  = '1';
        insert question1;

        // Insert question 2
        Questionaire__c question2 = TestDataDictionaryForSurvey.QuestionaireData('What do you dislike the most?', 'MultiSelect', survey );
        question2.Question_Number__c  = '2';
        insert question2;

        // Insert question 3
        Questionaire__c question3 = TestDataDictionaryForSurvey.QuestionaireData('What did you like the most?', 'MultiSelect', survey );
        question3.Question_Number__c  = '3';
        insert question3;

        // Insert survey Responses with Qualtrics supposition
        // Rating Data
        Answer__c answerResponse1 = TestDataDictionaryForSurvey.AnswerData('', 'Delighted', 9, 'R_1552212628223_5' , sr.Id, question1.Id);
        insert answerResponse1 ;

        // Insert survey Responses with Qualtrics supposition
        // Multiselect Data
        Answer__c answerResponse3 = TestDataDictionaryForSurvey.AnswerData('Process Simplicity, System Ease of Use', 'Delighted', null, 'R_x4y0VlSUkca6Q6t' , 'a1328000000qraLAAQ', question3.Id);
        insert answerResponse3 ;

        List<Detail__c> Details = [select id, Answer__c from Detail__c where Answer__c =: answerResponse3.Id ];
        system.assertEquals(Details.size() , 2);
    }

    // User Input bad feedback but selected one values
    static testMethod void SurveyRequestTest2(){

        // Insert Survey Data
        Survey__c survey = TestDataDictionaryForSurvey.SurveyData();
        insert survey ;
         List<gStg__c> lstGStg = new List<gStg__c>();
        gStg__c pActivation = new gStg__c(name='counter SurveyId',Text_Value__c = 'a1328000000qraLAAQ');
        gStg__c srv = new gStg__c(name='Counter Survey',Text_Value__c = survey.id);
        lstGStg.add(pActivation);
        lstGStg.add(srv);
        SObjectAccessDecision secDec3 = Security.stripInaccessible(AccessType.CREATABLE, lstGStg);
        insert secDec3.getRecords();

        // Insert Survey Response
        Survey_Request__c sr = TestDataDictionaryForSurvey.SurveyResponseData(survey);
        sr.Anonymous_Survey_Request__c = true;
        insert sr;

        // Insert question 1
        Questionaire__c question1 = TestDataDictionaryForSurvey.QuestionaireData('How satisfied are you?', 'Rating', survey );
        question1.Question_Number__c  = '1';
        insert question1;

        // Insert question 2
        Questionaire__c question2 = TestDataDictionaryForSurvey.QuestionaireData('What do you dislike the most?', 'MultiSelect', survey );
        question2.Question_Number__c  = '2';
        insert question2;

        // Insert question 3
        Questionaire__c question3 = TestDataDictionaryForSurvey.QuestionaireData('What did you like the most?', 'MultiSelect', survey );
        question3.Question_Number__c  = '3';
        insert question3;

        // Insert survey Responses with Qualtrics supposition
        // Rating Data
        Answer__c answerResponse1 = TestDataDictionaryForSurvey.AnswerData('', 'Dissatisfied', 6, 'R_3noahcsnoOIyFkW' , sr.Id, question1.Id);
        insert answerResponse1 ;

        // Insert survey Responses with Qualtrics supposition
        // Multiselect Data
        Answer__c answerResponse2 = TestDataDictionaryForSurvey.AnswerData('Delays', 'Dissatisfied', null, 'R_3noahcsnoOIyFkW' , sr.Id, question2.Id);
        insert answerResponse2 ;

        List<Detail__c> Details = [select id, Answer__c from Detail__c where Answer__c =: answerResponse2.Id ];
        system.assertEquals(Details.size() , 1);
    }

}