-- Run once against the SSA schema before (or with) the Animal picture Mapper deployment.
-- The script preserves existing uploaded image names and changes only NULL values.

-- Confirm the current column definition first.
SELECT column_name, data_type, data_length, nullable, data_default
FROM user_tab_columns
WHERE table_name = 'ANIMAL_DETAIL'
  AND column_name = 'ANIMAL_PICTURE';

-- Existing rows must be populated before the NOT NULL constraint is applied.
UPDATE ANIMAL_DETAIL
SET ANIMAL_PICTURE = 'noImage.jpg'
WHERE ANIMAL_PICTURE IS NULL;

-- Keep the same database-level contract used by MEMBER.PICTURE.
-- No datatype is specified, so the existing column length/type is preserved.
ALTER TABLE ANIMAL_DETAIL
    MODIFY (ANIMAL_PICTURE DEFAULT 'noImage.jpg' NOT NULL);

COMMIT;

-- Verify the resulting definition and that no NULL data remains.
SELECT column_name, data_type, data_length, nullable, data_default
FROM user_tab_columns
WHERE table_name = 'ANIMAL_DETAIL'
  AND column_name = 'ANIMAL_PICTURE';

SELECT COUNT(*) AS null_picture_count
FROM ANIMAL_DETAIL
WHERE ANIMAL_PICTURE IS NULL;
