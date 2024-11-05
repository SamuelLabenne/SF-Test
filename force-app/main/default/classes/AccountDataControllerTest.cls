/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AccountDataControllerTest {

    @isTest
    static void testGetAccountData() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Closed Won',
            Amount = 1000,
            CloseDate = Date.today(),
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        Contact testContact = new Contact(
            LastName = 'Test Contact',
            Email = 'test@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        // Call the method
        Test.startTest();
        List<AccountDataController.AccountWrapper> results = AccountDataController.getAccountData();
        Test.stopTest();

        // Validate results
        System.assertEquals(1, results.size());
        AccountDataController.AccountWrapper result = results[0];
        System.assertEquals('Test Account', result.account.Name);
        System.assertEquals(1, result.totalOpportunities);
        System.assertEquals(1000, result.closedWonValue);
        System.assertEquals(1, result.contacts.size());
        System.assertEquals('test@example.com', result.contacts[0].Email);
    }
}