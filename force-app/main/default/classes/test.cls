public class Interview {
 
    /**
     * @description		This method is used to calculate the mean of employees working for all Accounts of a certain Type.
     * 					Based on the Account Type and NumberOfEmployees. 
     * 					In case there is no Account for the specified type, returns -1.
     * 
     * @param 			accountType (String) : the Account Type for which we want the average of employees
     * @return 			Double : the average number of employees, or -1 if there is no Account for the required type.
     */
    public static Double calculateNumberEmployeesAverage(String accountType) {
        List<Account> accounts = [SELECT Id, NumberOfEmployees FROM Account WHERE Type =: accountType];
        if(accounts.size() == 0){
            return -1;
        }
        else{
            Integer total = 0;
            for (Accounts a : accounts) {
			Int employees = a.NumberOfEmployees;
            total += employees;
        }
        Double avg = total/accounts.size();
        
        return avg;   
        }
        
    }
}