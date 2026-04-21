global class ScheduleSurveyUpdate implements Schedulable{

     global void execute(SchedulableContext sc) {
         BatchSurveyUpdates batchAfPay = new BatchSurveyUpdates('afterpayment');
         BatchSurveyUpdates batchFreelancer = new BatchSurveyUpdates('regular');
         BatchSurveyUpdates batchRegular = new BatchSurveyUpdates('freelancer');
            database.executebatch(batchAfPay);
         database.executebatch(batchFreelancer);
         database.executebatch(batchRegular);
     }

}