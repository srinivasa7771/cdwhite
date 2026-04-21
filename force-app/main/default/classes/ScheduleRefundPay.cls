global class ScheduleRefundPay implements Schedulable{
    global void execute(SchedulableContext sc) {
        String endDate=Datetime.now().format('yyyy-MM-dd');
        String startDate=Datetime.now().addMonths(-3).format('yyyy-MM-dd');
        Database.executeBatch(new BatchRefundTransOraFu(startDate, endDate), 1);
    }
}