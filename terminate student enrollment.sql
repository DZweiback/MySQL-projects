CREATE PROCEDURE `terminate student enrollment` ()

CREATE DEFINER=`root`@`localhost` PROCEDURE `terminate student enrollment`(
-- This procedure accepts four parameters
	StudentID_in varchar(45),
  CourseCode_in varchar(45),
  Section_in varchar(45),
  EffectiveDate_in date
)

BEGIN
UPDATE classparticipant
SET EndDate = NOW()
WHERE ID_Student =
(
-- You can assign a value to a variable by using the SET command
SET ID_Student_out = (SELECT ID_Student FROM Student WHERE StudentID = StudentID_in);

-- You can also assign a value by SELECTing INTO the variable
SELECT
  ID_Class
INTO
  ID_Class_out
FROM
  Class c
  INNER JOIN COURSE co
  ON c.ID_Course = co.ID_Course
WHERE
  CourseCode = CourseCode_in
  AND Section = Section_in;

-- Drop from the ClassParticipant table the dereferenced values
DELETE FROM ClassParticipant(ID_Student, ID_Class, StartDate)
VALUES (ID_Student_out, ID_Class_out, StartDate_in
);

END