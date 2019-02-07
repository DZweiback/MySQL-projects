-- ZWEIBACK - MYSQL HOMEWORK PART 2
-- Using your gwsis database, develop a stored procedure that will drop an individual student's enrollment from a class.
-- Be sure to refer to the existing stored procedures, enroll_student and terminate_all_class_enrollment in the gwsis database for reference.
-- The procedure should be called terminate_student_enrollment and should accept the course code, section, student ID, and effective date of the withdrawal as parameters.

USE gwsis;
DROP procedure IF EXISTS gwsis.terminate_student_enrollment;

DELIMITER $$
CREATE PROCEDURE `terminate_student_enrollment`(
-- This procedure accepts four parameters
  StudentID_in varchar(45),
  CourseCode_in varchar(45),
  Section_in varchar(45),
  WithdrawalDate_in date
)
BEGIN
UPDATE classparticipant cp
SET EndDate = WithdrawalDate_in
WHERE StudentID_in IN (SELECT StudentID FROM student s WHERE s.ID_student = cp.ID_Student)
AND CourseCode_in IN (SELECT CourseCode FROM course co WHERE co.CourseCode = CourseCode_in)
AND Section_in IN (SELECT Section FROM class c WHERE c.ID_Class = cp.ID_Class); 

-- DISPLAY RESULTS
SELECT * 
FROM classparticipant;

-- IF A STUDENT IS LEAVING SCHOOL, DELETE STUDENT FROM STUDENT TABLE
-- DELETE FROM student
-- WHERE student.ID_Student = StudentID_in;

END $$

DELIMITER ;


ROLLBACK;

COMMIT;

END$$

DELIMITER ;
