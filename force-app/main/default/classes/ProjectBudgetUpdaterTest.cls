@isTest
public class ProjectBudgetUpdaterTest {

    @isTest
    static void testUpdateProjectBudgets() {
        // Step 1: Create test Projects
        Project__c activeProject = new Project__c(Status__c = 'Active', Budget__c = 0);
        insert activeProject;

        Project__c inactiveProject = new Project__c(Status__c = 'Inactive', Budget__c = 0);
        insert inactiveProject;

        // Step 2: Create test Tasks for active project
        Task__c task1 = new Task__c(Project__c = activeProject.Id, Cost__c = 100, Completed__c = false);
        Task__c task2 = new Task__c(Project__c = activeProject.Id, Cost__c = 200, Completed__c = false);
        insert new List<Task__c>{task1, task2};

        // Step 3: Run the method
        Test.startTest();
        ProjectBudgetUpdater.updateProjectBudgets();
        Test.stopTest();

        // Step 4: Verify that the Budget__c was updated correctly
        activeProject = [SELECT Budget__c FROM Project__c WHERE Id = :activeProject.Id];
        System.assertEquals(300, activeProject.Budget__c, 'Budget should be the sum of task costs.');

        // Verify inactive project is not updated
        inactiveProject = [SELECT Budget__c FROM Project__c WHERE Id = :inactiveProject.Id];
        System.assertEquals(0, inactiveProject.Budget__c, 'Inactive project budget should remain unchanged.');
    }
}