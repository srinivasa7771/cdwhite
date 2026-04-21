public class SelectTransactionsMonthCtrl {
    public List<SelectOption> monthsDropDown {get;set;}
    public String selectedMonth{Get;set;}
    Map<Integer, String> montNames = new Map<Integer, String>{
    1 => 'Jan', 2 => 'Feb', 3 => 'Mar', 4 =>'Apr', 5 => 'May', 6 => 'Jun', 7 => 'Jul', 8 => 'Aug', 9 => 'Sep', 10 => 'Oct', 11 => 'Nov', 12 => 'Dec'}
    ;
    public SelectTransactionsMonthCtrl() {
       monthsDropDown = new List<SelectOption>();
        for (Integer i=0;i<24;i++) {
            Date newDate = System.today();
            newDate = newDate.addMonths(-1*i);
            monthsDropDown.add(new SelectOption(newDate.Month()+'-'+newDate.year(), montNames.get(newDate.Month())+'-'+newDate.year()));
        }
    }
    public PageReference DownloadXML() {
        if (selectedMonth == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Please select transactions period'));
            return null;
        }
        String month = selectedMonth.split('-')[0];
        String year = selectedMonth.split('-')[1];
        return new PageReference('/apex/ExportTransactionsAsXML?selectedMonth='+month+'&selectedYear='+year+'&fileName='+montNames.get(Integer.valueOf(month))+'-'+year);
    }
}