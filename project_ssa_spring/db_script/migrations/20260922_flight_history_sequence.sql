-- Run this script once against the SSA schema before deploying the Mapper change.
-- It does not alter or delete existing FLIGHT_HISTORY rows.

-- 1) Check whether the sequence already exists and compare it with the table maximum.
SELECT sequence_name, last_number
FROM user_sequences
WHERE sequence_name = 'SEQ_FLIGHT_HISTORY';

SELECT NVL(MAX(flight_id), 0) AS max_flight_id,
       NVL(MAX(flight_id), 0) + 1 AS required_start_with
FROM flight_history;

-- 2) Run only while inserts are paused. The block creates the sequence if absent
-- and derives START WITH from the current maximum FLIGHT_ID.
DECLARE
    v_sequence_count NUMBER;
    v_start_with     NUMBER;
BEGIN
    SELECT COUNT(*)
      INTO v_sequence_count
      FROM user_sequences
     WHERE sequence_name = 'SEQ_FLIGHT_HISTORY';

    IF v_sequence_count = 0 THEN
        SELECT NVL(MAX(flight_id), 0) + 1
          INTO v_start_with
          FROM flight_history;

        EXECUTE IMMEDIATE
            'CREATE SEQUENCE SEQ_FLIGHT_HISTORY START WITH ' || v_start_with
            || ' INCREMENT BY 1 NOCACHE NOCYCLE';
    END IF;
END;
/

-- If the sequence already exists but LAST_NUMBER is not greater than MAX_FLIGHT_ID,
-- have the DBA advance or recreate it before deployment. Every NEXTVAL must exceed
-- the existing table maximum.
