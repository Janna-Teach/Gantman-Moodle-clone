@core_grades @javascript
Feature: Grade item validation
  In order to ensure validation is provided to the teacher
  As a teacher
  I need to know why I can not add/edit values on the grade item form

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | student1 | Student | 1 | student1@example.com |
      | teacher1 | Teacher | 1 | teacher1@example.com |
    And the following "courses" exist:
      | fullname | shortname | category | groupmode |
      | Course 1 | C1 | 0 | 1 |
    And the following "course enrolments" exist:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | student1 | C1 | student |
    And I log in as "admin"
    And I navigate to "Grades > Scales" in site administration
    And I press "Add a new scale"
    And I set the following fields to these values:
      | Name  | ABCDEF      |
      | Scale | F,E,D,C,B,A |
    And I press "Save changes"
    And I press "Add a new scale"
    And I set the following fields to these values:
      | Name  | Letter scale                              |
      | Scale | Disappointing, Good, Very good, Excellent |
    And I press "Save changes"
    And I am on "Course 1" course homepage
    And I navigate to "Setup > Gradebook setup" in the course gradebook
    And I press "Add grade item"
    And I set the following fields to these values:
      | Item name | MI 1 |
    And I click on "Save" "button" in the "New grade item" "dialogue"

  Scenario: Being able to change the grade type, scale and maximum grade for a manual grade item when there are no grades
    Given I click on grade item menu "MI 1" of type "gradeitem" on "setup" page
    And I choose "Edit grade item" in the open action menu
    When I should not see "Some grades have already been awarded, so the grade type"
    Then I set the field "Grade type" to "Scale"
    And I click on "Save" "button" in the "Edit grade item" "dialogue"
    And I should see "Scale must be selected"
    And I set the field "Scale" to "ABCDEF"
    And I click on "Save" "button" in the "Edit grade item" "dialogue"
    And I should not see "You cannot change the type, as grades already exist for this item"
    And I click on grade item menu "MI 1" of type "gradeitem" on "setup" page
    And I choose "Edit grade item" in the open action menu
    And I should not see "Some grades have already been awarded, so the grade type"
    And I set the field "Scale" to "Letter scale"
    And I click on "Save" "button" in the "Edit grade item" "dialogue"
    And I should not see "You cannot change the scale, as grades already exist for this item"

  Scenario: Attempting to change a manual item's grade type when grades already exist
    Given I navigate to "View > Grader report" in the course gradebook
    And I turn editing mode on
    And I give the grade "20.00" to the user "Student 1" for the grade item "MI 1"
    And I press "Save changes"
    And I navigate to "Setup > Gradebook setup" in the course gradebook
    And I click on grade item menu "MI 1" of type "gradeitem" on "setup" page
    And I choose "Edit grade item" in the open action menu
    Then I should see "Some grades have already been awarded, so the grade type cannot be changed. If you wish to change the maximum grade, you must first choose whether or not to rescale existing grades."
    And "//div[contains(concat(' ', normalize-space(@class), ' '), 'felement') and contains(text(), 'Value')]" "xpath_element" should exist

  Scenario: Attempting to change a manual item's scale when grades already exist
    Given I click on grade item menu "MI 1" of type "gradeitem" on "setup" page
    And I choose "Edit grade item" in the open action menu
    And I set the field "Grade type" to "Scale"
    And I set the field "Scale" to "ABCDEF"
    And I click on "Save" "button" in the "Edit grade item" "dialogue"
    And I navigate to "View > Grader report" in the course gradebook
    And I turn editing mode on
    And I give the grade "C" to the user "Student 1" for the grade item "MI 1"
    And I press "Save changes"
    And I navigate to "Setup > Gradebook setup" in the course gradebook
    And I click on grade item menu "MI 1" of type "gradeitem" on "setup" page
    And I choose "Edit grade item" in the open action menu
    Then I should see "Some grades have already been awarded, so the grade type and scale cannot be changed."
    And "//div[contains(concat(' ', normalize-space(@class), ' '), 'felement') and contains(text(), 'ABCDEF')]" "xpath_element" should exist

  Scenario: Attempting to change a manual item's maximum grade when no rescaling option has been chosen
    Given I navigate to "View > Grader report" in the course gradebook
    And I turn editing mode on
    And I give the grade "20.00" to the user "Student 1" for the grade item "MI 1"
    And I press "Save changes"
    And I navigate to "Setup > Gradebook setup" in the course gradebook
    And I click on grade item menu "MI 1" of type "gradeitem" on "setup" page
    And I choose "Edit grade item" in the open action menu
    Then I should see "Some grades have already been awarded, so the grade type cannot be changed. If you wish to change the maximum grade, you must first choose whether or not to rescale existing grades."
    And I should see "Choose" in the "Rescale existing grades" "field"
    And the "Maximum grade" "field" should be disabled
