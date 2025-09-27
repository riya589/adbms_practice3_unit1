DROP TABLE IF EXISTS StudentEnrollments;

CREATE TABLE StudentEnrollments (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    course_id VARCHAR(10),
    enrollment_date DATE
);

INSERT INTO StudentEnrollments (student_id, student_name, course_id, enrollment_date) VALUES
(1, 'Ashish', 'CSE101', '2024-06-01'),
(2, 'Smaran', 'CSE102', '2024-06-01'),
(3, 'Vaibhav', 'CSE103', '2024-06-01');

SELECT * FROM StudentEnrollments ORDER BY student_id;

-- Part A Simulation (Run in two separate sessions)
-- Session 1
START TRANSACTION;
UPDATE StudentEnrollments SET course_id = 'CSE101-UPD' WHERE student_id = 1;
UPDATE StudentEnrollments SET course_id = 'CSE101-FINAL' WHERE student_id = 2;
COMMIT;

-- Session 2
START TRANSACTION;
UPDATE StudentEnrollments SET course_id = 'CSE102-UPD' WHERE student_id = 2;
UPDATE StudentEnrollments SET course_id = 'CSE102-FINAL' WHERE student_id = 1; -- This will cause a deadlock

-- Verification and Reset for Part A
SELECT * FROM StudentEnrollments ORDER BY student_id;
UPDATE StudentEnrollments SET course_id = 'CSE101' WHERE student_id = 1;
UPDATE StudentEnrollments SET course_id = 'CSE102' WHERE student_id = 2;

-- Part B Simulation (Run in two separate sessions)
-- Session A
START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id = 1;
SELECT * FROM StudentEnrollments WHERE student_id = 1;
COMMIT;
SELECT * FROM StudentEnrollments WHERE student_id = 1;

-- Session B
START TRANSACTION;
UPDATE StudentEnrollments SET enrollment_date = '2024-07-10' WHERE student_id = 1;
COMMIT;


-- Part C Simulation (Run in two separate sessions)
-- Scenario 1: Locking
-- Session A
START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id = 1 FOR UPDATE;
COMMIT;

-- Session B
START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id = 1 FOR UPDATE;
COMMIT;

-- Scenario 2: MVCC
UPDATE StudentEnrollments SET enrollment_date = '2024-06-01' WHERE student_id = 1;

-- Session A
START TRANSACTION;
UPDATE StudentEnrollments SET enrollment_date = '2024-08-15' WHERE student_id = 1;
COMMIT;

-- Session B
START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id = 1;
COMMIT;
