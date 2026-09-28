-- Run once against the SSA schema after deploying the protected-animal counter change.
-- ANIMAL_STATUS = '0' is the ANIMAL_STATUS common-code value for "보호중".
-- This preserves all animal records and only rebuilds the derived ANIMAL_COUNTER values.

MERGE INTO ANIMAL_COUNTER counter_row
USING (
    SELECT TO_NUMBER(ANIMAL_TYPE) AS counter_id, COUNT(*) AS current_count
    FROM ANIMAL_DETAIL
    WHERE ANIMAL_STATUS = '0'
    GROUP BY ANIMAL_TYPE
) protected_animals
ON (counter_row.COUNTER_ID = protected_animals.counter_id)
WHEN MATCHED THEN
    UPDATE SET CURRENT_COUNT = protected_animals.current_count,
               LAST_UPDATE = SYSDATE
WHEN NOT MATCHED THEN
    INSERT (COUNTER_ID, CURRENT_COUNT, LAST_UPDATE)
    VALUES (protected_animals.counter_id, protected_animals.current_count, SYSDATE);

-- Existing counter types with no protected animals must show zero.
UPDATE ANIMAL_COUNTER counter_row
SET CURRENT_COUNT = 0,
    LAST_UPDATE = SYSDATE
WHERE NOT EXISTS (
    SELECT 1
    FROM ANIMAL_DETAIL animal
    WHERE animal.ANIMAL_STATUS = '0'
      AND TO_NUMBER(animal.ANIMAL_TYPE) = counter_row.COUNTER_ID
);

COMMIT;

SELECT counter_row.COUNTER_ID, counter_row.CURRENT_COUNT, counter_row.LAST_UPDATE
FROM ANIMAL_COUNTER counter_row
ORDER BY counter_row.COUNTER_ID;
