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
UPDATE classparticipant
	INNER JOIN student ON student.ID_Student = classparticipant.ID_Student
	INNER JOIN class ON classparticipant.ID_Class = class.ID_Class
	INNER JOIN course ON class.ID_Course = course.ID_Course
SET classparticipant.EndDate = WithdrawalDate_in
	WHERE student.StudentID = StudentID_in
	AND course.CourseCode = CourseCode_in
	AND class.Section = Section_in;

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
