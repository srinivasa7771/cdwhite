public class grqAddSanctionHelper {

    @InvocableMethod(label='SubmitApproval' description='Submit Account for Approval.')
    public static void SubmitApproval(List<Account> acc) {
        grqCtrlAddSanction s = new grqCtrlAddSanction('');
        s.submitForApproval(acc[0]);
    }

}