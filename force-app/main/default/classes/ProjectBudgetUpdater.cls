public class ProjectBudgetUpdater {

    public static void updateProjectBudgets() {
        // Step 1: Query all Projects with Status "Active" and fetch related Task__c records
        List<Project__c> activeProjects = [SELECT Id, Status__c, Budget__c,
                                           (SELECT Id, Cost__c FROM Tasks__r WHERE Completed__c = false)
                                           FROM Project__c
                                           WHERE Status__c = 'Active'];

        // Step 2: Initialize a list to hold updated projects
        List<Project__c> projectsToUpdate = new List<Project__c>();

        // Step 3: Loop through each Project and calculate total Task cost
        for (Project__c project : activeProjects) {
            Decimal totalTaskCost = 0;
            
            // Loop through each related Task__c and sum up the Cost__c
            for (Task__c task : project.Tasks__r) {
                totalTaskCost += task.Cost__c;
            }
            
            // Update the project's Budget__c field with the total Task cost
            project.Budget__c = totalTaskCost;
            
            // Add the project to the update list
            projectsToUpdate.add(project);
        }

        // Step 4: Update all projects in bulk
        if (!projectsToUpdate.isEmpty()) {
            update projectsToUpdate;
        }
    }
}